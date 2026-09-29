-- Full Auto Assist owned-avatar reader for Steam build 25480438.
-- Narrow extraction of the reference observer. Bounds and revalidation preserved.
local Result={ok=function(v)return {ok=true,value=v}end,
    err=function(code,stage,detail)return {ok=false,error={code=code,stage=stage,detail=detail}}end}
local function integer(v,lo,hi)return type(v)=='number' and v==v and v%1==0 and v>=lo and v<=hi end

local M={}
local Observer={}
Observer.__index=Observer
local INVALID=0xffffffff
local AVATAR_RESOURCE='\151\250\077\041\077\051\028\077'

local function u32(bytes,at)
    local a,b,c,d=bytes:byte(at+1,at+4)
    if not d then return nil end
    return a+b*256+c*65536+d*16777216
end

local function pointer_value(bytes,at)
    local low,high=u32(bytes,at),u32(bytes,at+4)
    if not low or not high then return nil end
    return high*4294967296+low
end

-- Lua doubles cannot safely multiply two arbitrary u32 values directly.
local function mul32(a,b)
    local al,ah=a%65536,math.floor(a/65536)
    local bl,bh=b%65536,math.floor(b/65536)
    return (al*bl+((ah*bl+al*bh)%65536)*65536)%4294967296
end

local function hash64(bytes)
    if #bytes<8 then return nil end
    local out={}
    for i=8,1,-1 do out[#out+1]=string.format('%02x',bytes:byte(i)) end
    return table.concat(out)
end

function M.new(memory,symbols)
    assert(memory and symbols,'observer dependencies required')
    return setmetatable({memory=memory,symbols=symbols,calls=0,successes=0,
        unavailable=0,failures=0,reads=0,cache_hits=0,discoveries=0,invalidations=0},Observer)
end

function Observer:invalidate()
    if self.certificate then self.invalidations=self.invalidations+1 end
    self.certificate=nil
end

function Observer:snapshot()
    self.calls=self.calls+1
    local reads,guards=0,{}
    local function fail(code,stage,detail)
        error({code=code,stage=stage,detail=detail},0)
    end
    local function read(address,size,stage,guard)
        reads=reads+1
        if reads>96 then fail('BudgetExceeded',stage,'snapshot read limit') end
        local result=self.memory:read(address,size)
        if not result.ok then
            fail('Unavailable',stage,result.error.code..': '..result.error.detail)
        end
        if guard then guards[#guards+1]={address=address,bytes=result.value} end
        return result.value
    end
    local function pointer(bytes,at,stage,empty_ok)
        local value=pointer_value(bytes,at or 0)
        if value==0 and empty_ok then return nil end
        if not integer(value,0x10000,0x7fffffffffff) then
            fail(value==0 and 'Unavailable' or 'InvalidLayout',stage,
                value==0 and 'null pointer' or 'noncanonical pointer')
        end
        return value
    end
    local function ptr_at(address,stage,guard,empty_ok)
        return pointer(read(address,8,stage,guard),0,stage,empty_ok)
    end
    local function global(name)
        local symbol=self.symbols:resolve(name)
        if not symbol.ok then
            fail(symbol.error.code,name,symbol.error.detail)
        end
        local value=ptr_at(symbol.value.address,name,true)
        guards[#guards].root=true
        return value
    end
    local function lookup(at,key,capacity_limit,stage)
        local header=read(at,20,stage,true)
        local cap,empty,mult=u32(header,8),u32(header,12),u32(header,16)
        if cap==0 then fail('Unavailable',stage,'empty map') end
        if not cap or cap>capacity_limit or cap%2~=0 and cap~=1 then
            fail('InvalidLayout',stage,'map capacity outside supported range')
        end
        local power=cap
        while power>1 and power%2==0 do power=power/2 end
        if power~=1 then fail('InvalidLayout',stage,'map capacity is not power of two') end
        local rows=pointer(header,0,stage)
        local seed=mul32(key,mult)
        for probe=0,math.min(cap,128)-1 do
            local slot=(seed+probe)%cap
            local row_at=rows+slot*8
            local row=read(row_at,8,stage)
            if u32(row,0)==key then
                local index=u32(row,4)
                if index==INVALID then fail('Unavailable',stage,'entity removed') end
                guards[#guards+1]={address=row_at,bytes=row}
                return index
            end
            if u32(row,0)==empty then fail('Unavailable',stage,'entity absent') end
        end
        fail('Unavailable',stage,'probe limit reached')
    end
    local function run()
        local cached=self.certificate
        if cached then
            -- Parents precede children: never follow an old slot after its
            -- manager, table, key/index, ownership or generation changed.
            local checked,valid=pcall(function()
                for _,guard in ipairs(cached.guards) do
                    if read(guard.address,#guard.bytes,'cache_validate')~=guard.bytes then return false end
                end
                for _,guard in ipairs(cached.guards) do
                    if guard.root and read(guard.address,#guard.bytes,'cache_roots')~=guard.bytes then return false end
                end
                return true
            end)
            if not checked then valid=false end
            if valid then self.cache_hits=self.cache_hits+1;return cached.snapshot end
            self:invalidate()
        end
        self.discoveries=self.discoveries+1
        local pm=global('player_manager')
        local counts=read(pm+0x84,8,'local_player',true)
        local count,available=u32(counts,0),u32(counts,4)
        if count>4 or available>4 then
            fail('InvalidLayout','local_player','player count exceeds four')
        end
        if count==0 or available==0 then
            fail('Unavailable','local_player','no active local player')
        end
        local player_at=ptr_at(pm+0xe8,'local_player',true)
        local player=read(player_at,24,'local_player',true)
        if player:byte(21)%2==0 then
            fail('Unavailable','local_player','player record not owned')
        end
        local unit_bytes=read(pm+0x3a8,4,'local_avatar',true)
        local unit=u32(unit_bytes,0)
        if unit==0x7fff then fail('Unavailable','local_avatar','no local unit') end
        local owner=global('entity_owner')
        local index=lookup(owner+0xf22ec8,unit,1048576,'entity_owner')
        if index>=262144 then fail('InvalidLayout','entity_owner','entity index too large') end
        local avatar_at=owner+0xf32f18+index*24
        local avatar=read(avatar_at,24,'local_avatar',true)
        if avatar:sub(1,8)~=AVATAR_RESOURCE then
            fail('InvalidLayout','local_avatar','unexpected avatar resource')
        end
        if avatar:byte(21)%2==0 then
            fail('Unavailable','local_avatar','avatar record not owned')
        end
        local avatar_id=u32(avatar,8)
        if avatar_id==0 or avatar_id==INVALID then
            fail('InvalidLayout','local_avatar','invalid avatar identity')
        end
        local am=global('avatar_manager')
        local ai=lookup(am+0xf8,avatar_id,64,'avatar_manager')
        local n=u32(read(am+0x6c,4,'avatar_manager',true),0)
        if n>8 or ai>=n then
            fail('InvalidLayout','avatar_manager','avatar index outside live count')
        end
        local back=ptr_at(am+0x110+ai*8,'avatar_manager',true)
        if read(back,24,'avatar_manager',true)~=avatar then
            fail('SnapshotChanged','avatar_manager','avatar back-reference changed')
        end
        local snapshot={state='present',avatar_id=avatar_id,unit_ref=unit,
            identity_token=hash64(avatar:sub(9,16))..hash64(avatar:sub(17,24)),
            held={state='unknown'},evidence='source_candidate'}
        local wm=global('weapon_wielder')
        local wi=lookup(wm+48,avatar_id,4096,'weapon_wielder')
        if wi>=4096 then
            fail('InvalidLayout','weapon_wielder','wielder index too large')
        end
        local backrefs=ptr_at(wm+72,'weapon_wielder',true)
        local back_at=ptr_at(backrefs+wi*8,'weapon_wielder',true)
        if back_at~=avatar_at or read(back_at,24,'weapon_wielder',true)~=avatar then
            fail('SnapshotChanged','weapon_wielder','avatar back-reference changed')
        end
        local rows=ptr_at(wm+96,'weapon_wielder',true)
        local held_at=rows+wi*464
        local held_bytes=read(held_at,4,'held_entity',true)
        local held_id=u32(held_bytes,0)
        if held_id==0 or held_id==INVALID then
            snapshot.held={state='absent'}
        else
            local em=global('equipment_manager')
            local ei=lookup(em+32,held_id,8192,'held_entity')
            if ei>=4096 then fail('InvalidLayout','held_entity','equipment index too large') end
            local equipment_back=ptr_at(em+56,'held_entity',true)
            local record_at=ptr_at(equipment_back+ei*8,'held_entity',true)
            local record=read(record_at,24,'held_entity',true)
            if u32(record,8)~=held_id then
                fail('SnapshotChanged','held_entity','equipment identity changed')
            end
            snapshot.held={state='present',entity_id=held_id,
                identity_token=hash64(record:sub(9,16))..hash64(record:sub(17,24)),
                resource_hash=hash64(record:sub(1,8))}
        end
        for _,guard in ipairs(guards) do
            if read(guard.address,#guard.bytes,'revalidate')~=guard.bytes then
                fail('SnapshotChanged','revalidate','identity changed during snapshot')
            end
        end
        self.certificate={guards=guards,snapshot=snapshot}
        return snapshot
    end
    local ok,value=pcall(function()
        if type(self.memory.with_region_cache)=='function' then
            return self.memory:with_region_cache(run)
        end
        return run()
    end)
    self.reads=self.reads+reads
    if ok then
        self.successes=self.successes+1
        return Result.ok(value)
    end
    self:invalidate()
    local problem=type(value)=='table' and value or
        {code='InvalidLayout',stage='observer',detail=tostring(value)}
    if problem.code=='Unavailable' then self.unavailable=self.unavailable+1
    else self.failures=self.failures+1 end
    return Result.err(problem.code,problem.stage,problem.detail)
end

function Observer:status()
    return {calls=self.calls,successes=self.successes,
        unavailable=self.unavailable,failures=self.failures,reads=self.reads,
        cache_hits=self.cache_hits,discoveries=self.discoveries,invalidations=self.invalidations}
end

return M
