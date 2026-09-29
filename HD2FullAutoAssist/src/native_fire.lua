-- Build-specific input adapter. Uses local guarded reads; never touches weapon data.
local M={}
local PROFILE='steam-25480438-v02-candidate'
local CONTROLS,STATE,FIRE,MAP,CODE=0x347cf18,0x3326340,0x1c88,0xa7ad0,0x20009
local REPEAT_SECONDS=0.125 -- Provisional default: 8 timed input attempts/second.
M.repeat_seconds=REPEAT_SECONDS
function M.native_period(seconds)
    assert(type(seconds)=='number' and seconds==seconds and
        seconds>=60/900 and seconds<=60/26,'Invalid consumer repeat cadence')
    -- This native parameter is ALSO a normalized magnitude threshold. Values
    -- above one suppress held time. Divide long native cooldowns into legal
    -- retry ticks; the stock weapon cooldown still governs accepted shots.
    return seconds/math.ceil(seconds)
end
local anchors={
    {0x12fc180,'\x48\x8b\xc4\x48\x89\x58\x08\x48\x89\x68\x10\x48'},
    {0x12fc44c,'\x41\x0f\x5a\xc3\x0f\x5a\xcf\xe8\x58\xcb\xe0\x00'},
    {0x12fa3b3,'\xe8\xc8\xb7\x28\xff\x44\x8b\x8e\xd8\x7a\x0a\x00'}
}
local function u32(s,at)
    local a,b,c,d=s:byte(at+1,at+4);assert(d,'Short native input record')
    return a+b*256+c*65536+d*16777216
end
local function pointer(s)
    local p=u32(s,0)+u32(s,4)*4294967296
    assert(p>=0x10000 and p<=0x7fffffffffff,'Invalid native input pointer');return p
end
local function packed(n)
    return string.char(n%256,math.floor(n/256)%256,math.floor(n/65536)%256,math.floor(n/16777216)%256)
end
local function adapter()
    local ffi=require('ffi')
    ffi.cdef[[
        void *GetModuleHandleA(const char *name);
        void *GetCurrentProcess(void);
        int QueryPerformanceCounter(void *counter);
        int QueryPerformanceFrequency(void *frequency);
        short GetAsyncKeyState(int key);
        size_t VirtualQuery(const void *address, void *region, size_t size);
        int WriteProcessMemory(void *process, void *address, const void *buffer,
            size_t size, size_t *written);
        typedef struct {void *base;void *allocation_base;uint32_t allocation_protection;
            uint16_t partition;uint16_t reserved;size_t size;uint32_t state;
            uint32_t protection;uint32_t type;} HD2FAARegionV1;
    ]]
    local k=ffi.load('kernel32')
    local user=ffi.load('user32')
    local game=k.GetModuleHandleA('game.dll');assert(game~=nil,'game.dll unavailable')
    local region,count,counter=ffi.new('HD2FAARegionV1[1]'),ffi.new('size_t[1]'),ffi.new('int64_t[1]')
    local frequency=ffi.new('int64_t[1]');assert(k.QueryPerformanceFrequency(frequency)~=0)
    local hz=tonumber(frequency[0]);assert(hz>0)
    local process=k.GetCurrentProcess()
    return {base=tonumber(ffi.cast('uintptr_t',game)),
        float=function(s,at) local f=ffi.new('float[1]');ffi.copy(f,s:sub(at+1,at+4),4);return tonumber(f[0]) end,
        float_bytes=function(n) local f=ffi.new('float[1]',n);return ffi.string(f,4) end,
        clock_us=function() assert(k.QueryPerformanceCounter(counter)~=0);return tonumber(counter[0])*1000000/hz end,
        raw_lmb_down=function()return user.GetAsyncKeyState(1)<0 end,
        write=function(at,bytes)
            assert(#bytes==20,'Only one complete live input mapping may be replaced')
            local p=ffi.cast('void *',at)
            assert(k.VirtualQuery(p,region,ffi.sizeof(region[0]))~=0,'Mapping page unavailable')
            local r=region[0];local first=tonumber(ffi.cast('uintptr_t',r.base))
            assert(r.state==0x1000 and r.protection==4 and at>=first and
                at+20<=first+tonumber(r.size),'Mapping is not committed writable data')
            count[0]=0
            assert(k.WriteProcessMemory(process,p,bytes,#bytes,count)~=0 and count[0]==20,
                'Live mapping write failed')
        end}
end
function M.new(host,make_adapter)
    assert(host:build_status().id==PROFILE,'Unsupported HD2 build')
    local a=(make_adapter or adapter)()
    local function read(at,n)return (host.read_live or host.read)(host,at,n)end
    local function ptr(at)return pointer(read(at,8))end
    local function word(at)return u32(read(at,4),0)end
    local function maybe_ptr(at)
        local s=read(at,8);if s==string.rep('\0',8) then return nil end;return pointer(s)
    end
    for _,r in ipairs(anchors) do assert(read(a.base+r[1],#r[2])==r[2],'Native input code anchor changed') end
    local pm_global=host:symbol('player_manager')
    local self={lease=nil,writes=0,restored=0,conflicts=0,repeat_seconds=REPEAT_SECONDS,clock_us=a.clock_us,
        binding_hits=0,binding_searches=0,binding_probes=0}
    function self:sample(capture_physical)
        local owner=maybe_ptr(a.base+CONTROLS);if not owner then return nil end
        local bytes=read(owner+FIRE,32)
        assert(ptr(a.base+CONTROLS)==owner,'Controls owner changed during sample')
        local magnitude,seconds=a.float(bytes,4),a.float(bytes,8)
        local trigger=u32(bytes,24);local pressed=bytes:byte(1)
        assert(magnitude==magnitude and math.abs(magnitude)<=1.01 and seconds==seconds and
            seconds>=0 and seconds<86400 and trigger<=10 and pressed<=1,'Invalid Fire input layout')
        local row={owner=owner,held=math.abs(magnitude)>=0.5,pressed=pressed==1,
            trigger=trigger,held_seconds=seconds,mapping_index=u32(bytes,16),gameplay=false}
        if capture_physical and a.raw_lmb_down then row.raw_lmb_down=a.raw_lmb_down()end
        if not row.held then return row end
        local state=maybe_ptr(a.base+STATE);if not state then return row end
        row.game_state=word(state+0xac21c)
        assert(row.game_state<=16,'Invalid game state')
        if self.last_game_state~=nil and self.last_game_state~=row.game_state then self:invalidate()end
        self.last_game_state=row.game_state
        if row.game_state~=4 then return row end
        local pm=maybe_ptr(pm_global);if not pm then return row end
        row.unit_ref=word(pm+0x3a8)
        row.gameplay=row.unit_ref~=0 and row.unit_ref~=0x7fff and row.unit_ref~=0xffffffff
        assert(ptr(a.base+STATE)==state and ptr(pm_global)==pm,'Player state changed during sample')
        return row
    end
    function self:gameplay_state()
        local state=maybe_ptr(a.base+STATE);if not state then return false end
        local n=word(state+0xac21c);assert(n<=16,'Invalid game state')
        if self.last_game_state~=nil and self.last_game_state~=n then self:invalidate()end
        self.last_game_state=n
        assert(ptr(a.base+STATE)==state,'Game state changed')
        return n==4
    end
    function self:invalidate()
        self.binding=nil
        if host.invalidate_native_cache then host:invalidate_native_cache()end
    end
    local function bucket(owner)
        assert(ptr(a.base+CONTROLS)==owner,'Controls owner changed')
        local header=read(owner+MAP,20);local rows=pointer(header)
        assert(u32(header,8)==256,'Unsupported binding map capacity')
        local cached=self.binding
        if cached and cached.revision==host.native_cache_revision and cached.owner==owner and cached.header==header then
            local h=read(cached.at,8);local count=u32(h,4)
            if u32(h,0)==CODE and count>0 and count<=16 then
                self.binding_hits=self.binding_hits+1;return cached.at,count,header
            end
        end
        self.binding=nil;self.binding_searches=self.binding_searches+1
        local seed=(CODE%256)*(u32(header,16)%256)%256
        for probe=0,255 do
            local at=rows+(seed+probe)%256*328
            local h=read(at,8);self.binding_probes=self.binding_probes+1
            if u32(h,0)==CODE then
                local count=u32(h,4);assert(count>0 and count<=16,'Unsupported Fire mapping count')
                self.binding={owner=owner,header=header,at=at,revision=host.native_cache_revision}
                return at,count,header
            end
            if u32(h,0)==u32(header,12) then break end
        end
        error('Normal Fire binding unavailable')
    end
    local function context(l,restoring)
        if ptr(a.base+CONTROLS)~=l.owner then error('BindingContextChanged:controls_owner',0)end
        if read(l.owner+MAP,20)~=l.header then error('BindingContextChanged:binding_table',0)end
        local h=read(l.bucket,8);local count=u32(h,4)
        if not (u32(h,0)==CODE and count>0 and count<=16 and (restoring or count==l.count))then
            error('BindingContextChanged:fire_header',0)end
        return count
    end
    local function replace(l,r,expected,next_bytes)
        context(l)
        assert(read(r.at,20)==expected,'Fire binding changed before replacement')
        a.write(r.at,next_bytes);self.writes=self.writes+1
        assert(read(r.at,20)==next_bytes,'Fire mapping write did not verify')
    end
    function self:inspect(row)
        local at,count=bucket(row.owner)
        local button,axis,triggers=0,0,{}
        for i=0,count-1 do
            local bytes=read(at+8+i*20,20);local flags,trigger=u32(bytes,0),u32(bytes,8)
            local kind=math.floor(flags/16)%16
            assert(math.floor(flags/65536)%16==trigger and trigger<=10,'Unsupported Fire mapping layout')
            if kind==4 then button=button+1 elseif kind==8 then axis=axis+1 else error('Unknown Fire input type') end
            triggers[#triggers+1]=tostring(kind)..':'..tostring(trigger)
        end
        return {mappings=count,button_mappings=button,axis_mappings=axis,triggers=table.concat(triggers,','),
            repeat_ms=self.repeat_seconds*1000,native_retry_ms=(self.native_repeat_seconds or self.repeat_seconds)*1000}
    end
    function self:restore()
        local l=self.lease;if not l then return true end
        local same,current_count=pcall(context,l,true)
        if not same then
            self:invalidate()
            -- A failed read is not proof of detachment. Keep originals and the
            -- lease so the controller can retry restoration instead of losing it.
            if not tostring(current_count):match('^BindingContextChanged:')then error(current_count,0)end
            self.conflicts=self.conflicts+1;self.lease=nil;return false,'binding_context_changed'
        end
        local clean=true
        for _,r in ipairs(l.records) do
            if r.index<current_count then
                local bytes=read(r.at,20)
                if bytes==r.patched then
                    context(l,true);assert(read(r.at,20)==r.patched,'Binding changed during restoration')
                    a.write(r.at,r.original);self.writes=self.writes+1
                    assert(read(r.at,20)==r.original,'Fire mapping restoration did not verify')
                    self.restored=self.restored+1
                elseif bytes~=r.original then clean=false;self.conflicts=self.conflicts+1 end
            else clean=false;self.conflicts=self.conflicts+1 end
        end
        self.lease=nil
        if not clean then self:invalidate()end
        return clean,clean and 'restored' or 'binding_edit_preserved'
    end
    function self:begin(row,repeat_seconds)
        repeat_seconds=repeat_seconds or REPEAT_SECONDS
        -- The slowest default policy is Eruptor at 26 RPM (60/26 s).
        -- A one-second ceiling rejected it and Crossbow before any lease write.
        local native_period=M.native_period(repeat_seconds)
        assert(not self.lease and row.held and row.gameplay,'Invalid Fire lease request')
        local at,count,header=bucket(row.owner)
        local l={owner=row.owner,bucket=at,count=count,header=header,records={}}
        assert(row.mapping_index<count,'Unknown active Fire mapping')
        local active_flags=u32(read(at+8+row.mapping_index*20,20),0)
        if math.floor(active_flags/16)%16~=4 then return nil,'axis_fire_input_not_supported' end
        -- Validate every record before the first write. Axis mappings remain vanilla.
        for i=0,count-1 do
            local p=at+8+i*20;local original=read(p,20)
            local flags,trigger=u32(original,0),u32(original,8)
            local kind=math.floor(flags/16)%16
            assert((kind==4 or kind==8) and math.floor(flags/65536)%16==trigger and trigger<=10,
                'Fire uses an unsupported input mapping')
            if kind==4 then assert(trigger==0 or trigger==2 or trigger==8,'Unsupported Fire button trigger') end
            if kind==4 and trigger~=8 then
                local f=flags-trigger*65536+8*65536
                l.records[#l.records+1]={at=p,index=i,original=original,
                    patched=packed(f)..original:sub(5,8)..packed(8)..original:sub(13,16)..a.float_bytes(native_period)}
            end
        end
        self.repeat_seconds=repeat_seconds;self.native_repeat_seconds=native_period
        self.lease=l -- Set before writing so all failure paths can restore.
        for _,r in ipairs(l.records) do replace(l,r,r.original,r.patched) end
        return #l.records
    end
    function self:refresh(row)
        local l=assert(self.lease,'No Fire lease')
        assert(l.owner==row.owner,'Controls owner changed')
        context(l)
        -- One bounded snapshot retains every leased-row comparison without separate region queries.
        local records=read(l.bucket+8,l.count*20)
        for _,r in ipairs(l.records) do
            assert(records:sub(r.index*20+1,r.index*20+20)==r.patched,'Fire binding edited during hold')
        end
        assert(row.mapping_index<l.count,'Unknown active Fire mapping')
        local flags=u32(records,row.mapping_index*20)
        return math.floor(flags/16)%16==4
    end
    return self
end
return M
