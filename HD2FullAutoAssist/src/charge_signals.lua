-- Read-only, developer-only companion. These values never grant Fire eligibility.
-- Exact-build paths: 7406a0 (trigger), 73ce07/740790 (beam), 744c20 (ammo gate).
local ffi=require('ffi')
local M={}
local function u32(s,at)
    local a,b,c,d=s:byte(at+1,at+4);assert(d,'Short probe record')
    return a+b*256+c*65536+d*16777216
end
local function ptr(s,at)
    at=at or 0;local n=u32(s,at)+u32(s,at+4)*4294967296
    assert(n>=0x10000 and n<=0x7fffffffffff,'Invalid probe pointer');return n
end
local function hex(s)return (s:gsub('.',function(c)return string.format('%02x',c:byte())end))end
local function hash(s)local parts={};for i=8,1,-1 do parts[#parts+1]=string.format('%02x',s:byte(i))end;return table.concat(parts)end
local value=ffi.new('float[1]')
function M.float(s,at)ffi.copy(value,s:sub(at+1,at+4),4);return tonumber(value[0])end
function M.new(host)
    assert(host:build_status().id=='steam-25480438-v02-candidate','Unsupported probe build')
    local self={cache={},discoveries=0,cache_hits=0,probes=0}
    local function read(at,n)return (host.read_live or host.read)(host,at,n)end
    function self:invalidate()self.cache={}end
    local function table_row(tag,w,rva,map_offset,rows_offset,stride,length,entities_offset,command_offset,extra_offset,extra_stride,extra_length)
        local root=host.base+rva;local manager=ptr(read(root,8))
        local header=read(manager+map_offset,20)
        local cap,empty,mult=u32(header,8),u32(header,12),u32(header,16)
        assert(cap>0 and cap<=8192,'Probe table outside bounds')
        local power=cap;while power>1 and power%2==0 do power=power/2 end
        assert(power==1,'Probe table capacity not power of two')
        local map=ptr(header);local rows=ptr(read(manager+rows_offset,8))
        local previous=self.cache[tag];local slot,key_at,key
        local now=host:clock_us()
        if previous and previous.manager==manager and previous.header==header and previous.rows==rows and
            previous.identity==w.identity_token and previous.id==w.entity_id then
            if previous.absent and now<previous.retry_us then return {state='row_absent'}end
            if previous.key_at then
                key=read(previous.key_at,8)
                if key==previous.key then slot,key_at=previous.slot,previous.key_at;self.cache_hits=self.cache_hits+1 end
            end
        end
        if slot==nil then
            self.discoveries=self.discoveries+1
            local seed=(w.entity_id%cap)*(mult%cap)%cap
            for probe=0,math.min(cap,128)-1 do
                key_at=map+(seed+probe)%cap*8;key=read(key_at,8);self.probes=self.probes+1
                if u32(key,0)==w.entity_id then slot=u32(key,4);break end
                if u32(key,0)==empty then break end
            end
        end
        if slot==nil then
            assert(ptr(read(root,8))==manager and read(manager+map_offset,20)==header,'Probe roots changed')
            self.cache[tag]={manager=manager,header=header,rows=rows,identity=w.identity_token,
                id=w.entity_id,absent=true,retry_us=now+250000}
            return {state='row_absent'}
        end
        assert(slot<4096,'Probe row index outside bounds')
        local entity,entity_root,identity
        if entities_offset then
            entity_root=ptr(read(manager+entities_offset,8));entity=ptr(read(entity_root+slot*8,8));identity=read(entity,24)
            assert(hash(identity:sub(1,8))==w.resource_hash and u32(identity,8)==w.entity_id,'Probe identity mismatch')
            assert(type(w.identity_token)=='string' and #w.identity_token==64 and
                hash(identity:sub(9,16))..hash(identity:sub(17,24))==w.identity_token:sub(-32),'Probe generation token changed')
            if previous and previous.entity==entity then assert(previous.record==identity,'Probe generation changed')end
        end
        local raw=read(rows+slot*stride,length);local out={state='observed',slot=slot,raw_hex=hex(raw)}
        if command_offset then
            local command=ptr(read(manager+command_offset,8));out.command=read(command+slot,1):byte()
            assert(ptr(read(manager+command_offset,8))==command,'Probe command array changed')
        end
        if extra_offset then
            local extra=ptr(read(manager+extra_offset,8));out.extra_hex=hex(read(extra+slot*extra_stride,extra_length))
            assert(ptr(read(manager+extra_offset,8))==extra,'Probe auxiliary array changed')
        end
        assert(ptr(read(root,8))==manager and read(manager+map_offset,20)==header and
            ptr(read(manager+rows_offset,8))==rows and read(key_at,8)==key,'Probe snapshot changed')
        if entity then
            assert(ptr(read(manager+entities_offset,8))==entity_root and ptr(read(entity_root+slot*8,8))==entity and
                read(entity,24)==identity,'Probe entity changed')
        end
        self.cache[tag]={manager=manager,header=header,rows=rows,identity=w.identity_token,id=w.entity_id,
            slot=slot,key_at=key_at,key=key,entity=entity,record=identity}
        return out,raw
    end
    local function guarded(tag,fn)
        local ok,row=pcall(fn)
        if ok then return row end
        self.cache[tag]=nil;return {state='unavailable',reason=tostring(row)}
    end
    function self:sample(state)
        local w=assert(state.weapon)
        local out={}
        out.fire=guarded('fire',function()
            local root=host.base+0x347cf18;local owner=ptr(read(root,8));local raw=read(owner+0x1c88,32)
            assert(ptr(read(root,8))==owner,'Probe Fire owner changed')
            return {state='observed',raw_hex=hex(raw),pressed=raw:byte(1),magnitude=M.float(raw,4),
                held_seconds=M.float(raw,8),trigger=u32(raw,24),physical_binding_verified=false}
        end)
        out.trigger=guarded('trigger',function()
            return table_row('trigger',w,0x3326660,40,80,40,40,64,88)
        end)
        if w.resource_hash=='6cfcc7f8801a0266' then
            -- Only the beam's two state bytes, accepted counter and duration.
            out.beam=guarded('beam',function()
                local row,raw=table_row('beam',w,0x33266d8,80,120,168,12)
                if raw then row.current_flag=raw:byte(1);row.request_flag=raw:byte(2)
                    row.counter=u32(raw,4);row.timer=M.float(raw,8)end
                return row
            end)
        end
        if w.resource_hash~='96de9cd50f7306e6' then
            -- The exact stock ammo-gate fields only. No reload commands/count writes.
            out.ammo=guarded('ammo',function()
                return table_row('ammo',w,0x3326648,32,72,16,16,nil,nil,80,12,12)
            end)
        end
        return out
    end
    return self
end
return M
