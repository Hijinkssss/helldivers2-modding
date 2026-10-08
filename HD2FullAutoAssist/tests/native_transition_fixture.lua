-- Real lifecycle, identity, controller and native Fire backend over byte memory.
-- The only replacements are Windows/process I/O and the game's stock update.
local ffi=require('ffi')
local Life=require('lifecycle')
local Native=require('native_fire')
local M={}
local function u32(n)return string.char(n%256,math.floor(n/256)%256,math.floor(n/65536)%256,math.floor(n/16777216)%256)end
local function ptr(n)return u32(n)..u32(0)end
local function float(n)local v=ffi.new('float[1]',n);return ffi.string(v,4)end
local function hash_bytes(hash)local out={};for i=16,2,-2 do out[#out+1]=string.char(tonumber(hash:sub(i-1,i),16))end;return table.concat(out)end
function M.new(config,validation_factory)
    local f={now=0,logs={},queries={},writes=0,physical_samples=0,stock_calls=0,read_log={},write_log={}}
    local bytes={}
    function f:put(at,s)for i=1,#s do bytes[at+i-1]=s:sub(i,i)end end
    function f:bytes(at,n)local out={};for i=0,n-1 do assert(bytes[at+i],'Unmapped fixture address');out[#out+1]=bytes[at+i]end;return table.concat(out)end
    local G,PM,PLAYER,OWNER,AM,WM,EM=0x10000000,0x20000000,0x21000000,0x30000000,0x40000000,0x50000000,0x60000000
    local AVATAR=OWNER+0xf32f18+2*24
    local BACKS,ROWS,EBACK,ERECORD=0x51000000,0x52000000,0x61000000,0x62000000
    local UI,CONTROLS,STATE,BINDINGS=0x22000000,0x70000000,0x71000000,0x72000000
    local BUCKET=BINDINGS+9*328
    f.G,f.PM,f.EM,f.ROWS,f.ERECORD,f.BUCKET=G,PM,EM,ROWS,ERECORD,BUCKET
    f.AVATAR,f.WM,f.AM,f.OWNER,f.BACKS,f.EBACK,f.CONTROLS,f.STATE,f.BINDINGS=AVATAR,WM,AM,OWNER,BACKS,EBACK,CONTROLS,STATE,BINDINGS
    f.u32,f.ptr,f.float=u32,ptr,float
    local function put(at,s)f:put(at,s)end
    local function map(at,rows,key,index,cap)
        put(at,ptr(rows)..u32(cap or 8)..u32(0xffffffff)..u32(1))
        put(rows+key%(cap or 8)*8,u32(key)..u32(index))
    end
    put(G,'MZ');put(G+0x3c,u32(128));put(G+128,'PE\0\0');put(G+152,'\x0b\x02');put(G+208,u32(0x4000000))
    put(G+0x3326468,ptr(PM));put(G+0x346bf98,ptr(OWNER));put(G+0x3326d20,ptr(AM));put(G+0x3326420,ptr(WM));put(G+0x3326dc0,ptr(EM))
    put(PM+0x84,u32(1)..u32(1));put(PM+0xe8,ptr(PLAYER));put(PLAYER,string.rep('\0',20)..'\1'..string.rep('\0',3));put(PM+0x3a8,u32(0x42))
    map(OWNER+0xf22ec8,0x31000000,0x42,2)
    local avatar='\151\250\077\041\077\051\028\077'..u32(0x98)..u32(0x42)..string.rep('\0',4)..'\1'..string.rep('\0',3)
    put(AVATAR,avatar);map(AM+0xf8,0x41000000,0x98,1);put(AM+0x6c,u32(2));put(AM+0x118,ptr(AVATAR))
    map(WM+48,0x53000000,0x98,0);put(WM+72,ptr(BACKS));put(BACKS,ptr(AVATAR));put(WM+96,ptr(ROWS))
    put(EM+56,ptr(EBACK))
    function f:weapon(hash,id,address)
        id=id or 0xa9;address=address or ERECORD
        put(ROWS,u32(id));map(EM+32,0x63000000,id,1);put(EBACK+8,ptr(address))
        put(address,hash_bytes(hash)..u32(id)..string.rep('\0',12))
    end
    f:weapon('05e4e5c2db6e44a2')
    put(G+0x347ce28,ptr(UI));put(UI,string.rep('\0',8));put(UI+0x4294,string.rep('\0',0x90))
    put(G+0x14aeb30,'\x48\x89\x74\x24\x10\x57\x48\x83\xec\x30')
    put(G+0x347cf18,ptr(CONTROLS));put(G+0x3326340,ptr(STATE));put(STATE+0xac21c,u32(4))
    put(CONTROLS+0xa7ad0,ptr(BINDINGS)..u32(256)..u32(0xffffffff)..u32(1))
    put(BUCKET,u32(0x20009)..u32(2))
    f.original=u32(0x0010ff43)..u32(1)..u32(0)..float(0)..float(.5)
    put(BUCKET+8,f.original..f.original)
    put(G+0x12fc180,'\x48\x8b\xc4\x48\x89\x58\x08\x48\x89\x68\x10\x48')
    put(G+0x12fc44c,'\x41\x0f\x5a\xc3\x0f\x5a\xcf\xe8\x58\xcb\xe0\x00')
    put(G+0x12fa3b3,'\xe8\xc8\xb7\x28\xff\x44\x8b\x8e\xd8\x7a\x0a\x00')
    function f:input(magnitude,seconds,pressed,trigger,index)
        put(CONTROLS+0x1c88,(pressed and '\1' or '\0')..'\0\0\0'..float(magnitude)..float(seconds)..u32(0)..u32(index or 0)..u32(0)..u32(trigger or 0)..u32(0))
    end
    function f:fire(held)
        put(CONTROLS+0x1c88,'\0\0\0\0'..float(held and 1 or 0)..float(held and .1 or 0)..u32(0)..u32(0)..u32(0)..u32(0)..u32(0))
    end
    function f:game_state(n)put(STATE+0xac21c,u32(n))end
    function f:alive(alive)put(PM+0x3a8,u32(alive and (self.unit or 0x42) or 0x7fff))end
    function f:respawn(unit,id)
        self.unit=unit;self:alive(true)
        map(OWNER+0xf22ec8,0x31000000,unit,2)
        put(AVATAR,avatar:sub(1,8)..u32(id)..u32(unit)..avatar:sub(17))
        map(AM+0xf8,0x41000000,id,1);map(WM+48,0x53000000,id,0)
    end
    function f:relocate_equipment(address)put(G+0x3326dc0,ptr(address));put(address+32,self:bytes(EM+32,20));put(address+56,ptr(EBACK))end
    f:fire(false)
    local p={safe_cached_reads=true,clock_us=function()return f.now end,module_hash=function(_,name)
        return name and '2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E' or 'F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06'
        end,module_address=function()return G end,query_region=function(_,at)
            f.queries[#f.queries+1]=at
            if f.region_provider then return f.region_provider(at)end
            local base=math.floor(at/4096)*4096
            return {base=base,size=4096,state=0x1000,protect=base==f.bad_page and 0x104 or 4}
        end,read=function(_,at,n)
            f.read_log[#f.read_log+1]={at=at,n=n}
            if at==f.failed_read then return nil end
            for page=math.floor(at/4096)*4096,math.floor((at+n-1)/4096)*4096,4096 do
                if page==f.bad_page then return nil end
            end
            if f.on_read then local value,handled=f.on_read(at,n);if handled then return value end end
            return f:bytes(at,n)
        end,prepare_input=function()return true end,input_focused=function()return true end,input_down=function()return false end}
    f.platform=p
    local loader={api=1,open_log=function()return {write=function(self,line)f.logs[#f.logs+1]=line;return self end,flush=function()return true end,close=function()return true end}end}
    local stock=function(marker)
        assert(marker=='fixture');f.stock_calls=f.stock_calls+1
        assert(not f.host.regions,'Page scope survives into game code')
        return 'stock',nil,7
    end
    f.env={update=stock,stingray={Window={has_focus=function()return true end,show_cursor=function()return false end}}}
    f.host=Life.new(f.env,{platform=p,loader=loader})
    local adapter={base=G,clock_us=function()return f.now end,float_bytes=float,
        float=function(s,at)local v=ffi.new('float[1]');ffi.copy(v,s:sub(at+1,at+4),4);return tonumber(v[0])end,
        raw_lmb_down=function()f.physical_samples=f.physical_samples+1;return true end,
        write=function(at,s)
            assert(#s==20);f.write_log[#f.write_log+1]={at=at,bytes=s}
            local region=p:query_region(at)
            assert(region and region.state==0x1000 and region.protect==4 and at>=region.base and at+20<=region.base+region.size)
            if f.write_failure then error('fixture write failure')end
            put(at,s);f.writes=f.writes+1
        end}
    f.consumer=require('full_auto_assist').install(f.host,function(host)
        f.backend=Native.new(host,function()return adapter end);return f.backend
    end,function()return config or ''end,validation_factory)
    f.host:attach()
    function f:tick(delta)
        self.now=self.now+(delta or 120000)
        local a,b,c=self.env.update('fixture');assert(a=='stock' and b==nil and c==7)
        assert(self.host.regions==nil,'Page scope leaked after update')
    end
    function f:restored()return self:bytes(BUCKET+8,40)==self.original..self.original end
    function f:healthy()
        assert(not self.consumer:status().failed and not self.host.closed,'Consumer permanently disabled')
        assert(self.host:diagnostics().scheduler.active==3,'Callbacks removed')
    end
    return f
end
return M
