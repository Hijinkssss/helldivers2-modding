-- Bounded READ-ONLY research observer. Never grants assistance eligibility.
-- Layout informed by ArcThrowerRevamped and exact-build static xrefs.
local M={}
local Signals=require('charge_signals')
local names=require('charge_probe_targets').names
local function u32(s,n)local a,b,c,d=s:byte(n+1,n+4);assert(d,'Short charge record');return a+b*256+c*65536+d*16777216 end
local function pointer(s,n)
    local value=u32(s,n or 0)+u32(s,(n or 0)+4)*4294967296
    assert(value>=0x10000 and value<=0x7fffffffffff,'Invalid charge pointer');return value
end
local function hash(s)local out={};for i=8,1,-1 do out[#out+1]=string.format('%02x',s:byte(i))end;return table.concat(out)end
local function hex(s)return (s:gsub('.',function(c)return string.format('%02x',c:byte())end))end
local function modulo20(hash_text)
    assert(type(hash_text)=='string' and #hash_text==16 and hash_text:match('^%x+$'),
        'Invalid resource hash')
    -- Keep the 64-bit resource id exact without converting it to a Lua double.
    local high,low=tonumber(hash_text:sub(1,8),16),tonumber(hash_text:sub(9,16),16)
    return ((high%20)*16+(low%20))%20 -- 2^32 mod 20 == 16.
end
function M.new(host)
    assert(host:build_status().id=='steam-25480438-v02-candidate','Unsupported charge research build')
    local self={discoveries=0,cache_hits=0,invalidations=0,expensive_scans=0,
        resource_settings_scans=0,resource_settings_cache_hits=0}
    local function read(at,n)return (host.read_live or host.read)(host,at,n)end
    function self:invalidate()
        self.cached=nil;self.resource_settings_cache=nil;self.invalidations=self.invalidations+1
    end
    function self:sample(state)
        local w=state and state.weapon
        if not state or not state.identity_observed or not w or not names[w.resource_hash] then
            if self.cached then self:invalidate()end
            return nil
        end
        local ok,row=pcall(function()
            local global=host.base+0x3326c20
            local manager=pointer(read(global,8))
            local header=read(manager+16,56)
            local count=u32(header,0)
            assert(count<=512,'Charge row count outside research budget')
            if count==0 then self:invalidate();return {name=names[w.resource_hash],state='charge_row_absent'}end
            local entities,entries=pointer(header,40),pointer(header,48)
            local cached=self.cached
            local now=host:clock_us()
            if cached and cached.absent and cached.manager==manager and cached.header==header and
                cached.identity==w.identity_token and cached.id==w.entity_id and now<cached.retry_us then
                return {name=names[w.resource_hash],state='charge_row_absent',
                    lookup_entity_id=w.entity_id,lookup_row_count=u32(header,0),
                    lookup_header_hex=hex(header),lookup_probes=0}
            end
            local index,entity
            if cached and not cached.absent and cached.manager==manager and cached.header==header and
                cached.identity==w.identity_token and cached.id==w.entity_id and cached.hash==w.resource_hash then
                index,entity=cached.index,cached.entity
                if pointer(read(entities+index*8,8))~=entity then index=nil end
            end
            if index==nil then
                self:invalidate();self.discoveries=self.discoveries+1
                -- One finite table, at most 512 pointers. No process/heap scan.
                local pointers=read(entities,count*8)
                for i=0,count-1 do
                    local at=pointer(pointers,i*8)
                    local identity=read(at,24)
                    if u32(identity,8)==w.entity_id and hash(identity:sub(1,8))==w.resource_hash then
                        index,entity=i,at;break
                    end
                end
                if index==nil then
                    self.cached={absent=true,manager=manager,header=header,identity=w.identity_token,
                        id=w.entity_id,hash=w.resource_hash,retry_us=now+250000}
                    return {name=names[w.resource_hash],state='charge_row_absent',
                        lookup_entity_id=w.entity_id,lookup_row_count=count,
                        lookup_header_hex=hex(header),lookup_probes=count}
                end
            else self.cache_hits=self.cache_hits+1 end
            local identity=read(entity,24)
            assert(u32(identity,8)==w.entity_id and hash(identity:sub(1,8))==w.resource_hash,'Charge entity changed')
            assert(type(w.identity_token)=='string' and #w.identity_token==64 and
                hash(identity:sub(9,16))..hash(identity:sub(17,24))==w.identity_token:sub(-32),'Charge generation token changed')
            local raw=read(entries+index*40,40)
            assert(pointer(read(global,8))==manager and
                read(manager+16,56)==header and pointer(read(entities+index*8,8))==entity and
                read(entity,24)==identity,'Charge snapshot changed')
            if cached and cached.entity==entity and cached.id==w.entity_id and cached.identity==w.identity_token then
                assert(cached.record==identity,'Charge generation changed')
            end
            local settings_header=read(manager+80,20)
            local capacity,empty,mult=u32(settings_header,8),u32(settings_header,12),u32(settings_header,16)
            assert(capacity>0 and capacity<=8192 and capacity%1==0,'Invalid charge settings map')
            local power=capacity;while power>1 and power%2==0 do power=power/2 end
            assert(power==1,'Charge settings capacity not power of two')
            local map=pointer(settings_header,0)
            -- Modulo capacity divides 2^32; reducing before multiply avoids double rounding.
            local seed=(w.entity_id%capacity)*(mult%capacity)%capacity
            local settings,settings_source
            for probe=0,math.min(capacity,128)-1 do
                local at=map+(seed+probe)%capacity*8
                local key=read(at,8)
                if u32(key,0)==w.entity_id then
                    local slot=u32(key,4);assert(slot<4096,'Charge settings index outside bounds')
                    local records=pointer(read(manager+144,8))
                    local setting_at=records+slot*216
                    -- Three native boundaries plus auto-fire flags and burst recovery.
                    -- No full weapon settings dump or guessed fixed charge duration.
                    settings=read(setting_at,4)..read(setting_at+24,4)..read(setting_at+48,4)..read(setting_at+184,12)
                    assert(read(at,8)==key and pointer(read(manager+144,8))==records and
                        read(manager+80,20)==settings_header,'Charge settings changed')
                    settings_source='instance_override';break
                end
                if u32(key,0)==empty then break end
            end
            if not settings then
                -- The stock getter falls back to a bounded 20-slot resource table
                -- (game.dll+0x346bf98 owner, owner+0xf12ad8) and 216-byte records
                -- after the 0x140-byte table header. Mirrors 0x504d80 exactly.
                local owner_root=read(host.base+0x346bf98,8)
                local owner=pointer(owner_root)
                local table_base=pointer(read(owner+0xf12ad8,8))
                local resource_seed=modulo20(w.resource_hash)
                local cached=self.resource_settings_cache
                local setting_index,key,table_slot
                if cached and cached.hash==w.resource_hash and cached.owner==owner and
                    cached.table_base==table_base then
                    local at=table_base+cached.slot*16
                    local current=read(at,16)
                    if current==cached.key then
                        key,setting_index,table_slot=current,cached.index,cached.slot
                        self.resource_settings_cache_hits=self.resource_settings_cache_hits+1
                    else self.resource_settings_cache=nil end
                end
                if setting_index==nil then
                    self.resource_settings_scans=self.resource_settings_scans+1
                    for probe=0,19 do
                        local slot=(resource_seed+probe)%20
                        local at=table_base+slot*16
                        local candidate=read(at,16)
                        if hash(candidate:sub(1,8))==w.resource_hash then
                            key=candidate;setting_index=u32(key,8);table_slot=slot
                            assert(setting_index<4096,'Resource charge settings index outside bounds')
                            self.resource_settings_cache={hash=w.resource_hash,owner=owner,
                                table_base=table_base,slot=slot,key=key,index=setting_index}
                            break
                        end
                        -- The native map terminates at its first empty key.
                        if candidate:sub(1,8)==string.rep('\0',8) then break end
                    end
                end
                if setting_index~=nil then
                    local at=table_base+table_slot*16
                    local setting_at=table_base+0x140+setting_index*216
                    settings=read(setting_at,4)..read(setting_at+24,4)..read(setting_at+48,4)..read(setting_at+184,12)
                    assert(read(at,16)==key,'Resource charge settings key changed')
                    settings_source='resource_default'
                end
                assert(read(host.base+0x346bf98,8)==owner_root and
                    pointer(read(owner+0xf12ad8,8))==table_base,
                    'Resource charge settings changed')
            end
            assert(pointer(read(global,8))==manager and read(manager+16,56)==header and
                read(entity,24)==identity,'Charge roots changed after settings sample')
            self.cached={manager=manager,header=header,index=index,entity=entity,record=identity,
                identity=w.identity_token,id=w.entity_id,hash=w.resource_hash}
            return {name=names[w.resource_hash],state='raw_observed',entity_id=w.entity_id,
                resource_hash=w.resource_hash,identity_token=w.identity_token,slot=index,
                runtime_hex=hex(raw),settings_hex=settings and hex(settings),
                settings_state=settings and 'observed' or 'not_found',
                settings_source=settings_source,
                settings_layout='f32@0,f32@24,f32@48,bytes@184:12',
                charge_seconds=Signals.float(raw,4),discharged_charge_seconds=Signals.float(raw,8),
                phase_value=Signals.float(raw,0),recovery_timer=Signals.float(raw,24),
                charging_flag=raw:byte(13),raw_flag32=raw:byte(33),
                native_boundaries=settings and {minimum=Signals.float(settings,0),
                    safety=Signals.float(settings,4),maximum=Signals.float(settings,8)} or nil}
        end)
        if not ok then self:invalidate();return {name=names[w.resource_hash],state='unavailable',reason=tostring(row)}end
        return row
    end
    return self
end
return M
