local ffi=require('ffi')
local M={OWNER=0x87000000,BASE=0x10000000}
function M.widget(x,y,w,h,parent,child,sibling,kind,shown,scale)
    local bytes=ffi.new('uint8_t[248]')
    local function u(at,value)ffi.cast('uint32_t*',bytes+at)[0]=value end
    local function f(at,value)ffi.cast('float*',bytes+at)[0]=value end
    local function p(at,value)ffi.cast('uint64_t*',bytes+at)[0]=value or 0 end
    u(0,(kind or 2)*262144+(shown==false and 0 or 16))
    f(36,w);f(40,h);f(84,shown==false and 0 or 1)
    f(100,scale or 1);f(140,scale or 1);f(148,x);f(156,y)
    p(224,child);p(232,sibling);p(240,parent)
    return ffi.string(bytes,248)
end
function M.populate(put,base,options)
    options=options or {};local owner=options.owner or M.OWNER
    local panel=owner+0x24e340+0x60;local row=panel+0x3220
    local weapon=panel+0x7b0;local a,b,pack=panel+0x3330,panel+0x3488,panel+0x4df0
    local s=options.scale or 1
    local ptr=ffi.new('uint64_t[1]',owner);put(base+0x346d538,ffi.string(ptr,8))
    put(panel,M.widget(48,48,450,164,nil,weapon,nil,1,true,s))
    put(weapon,M.widget(48,48,450,164,panel,row,pack,1,true,s))
    put(row,M.widget(180,90,56,48,weapon,a,nil,1,true,s))
    put(a,M.widget(180,90,20,24,row,nil,b,2,true,s))
    put(b,M.widget(210,90,30,24,row,nil,nil,7,true,s))
    put(pack,M.widget(options.pack_x or 270,90,64,48,panel,nil,nil,2,options.backpack==true,s))
    return {panel=panel,row=row,weapon=weapon,a=a,b=b,pack=pack,owner=owner,scale=s}
end
function M.host(options)
    local bytes={};local host={base=M.BASE,reads=0,writes=0,now_us=0}
    function host:clock_us()return self.now_us end
    function host:put(at,value)for i=1,#value do bytes[at+i-1]=value:sub(i,i)end end
    function host:read_live(at,n)
        self.reads=self.reads+1
        if self.failed==at then error('HUD inaccessible')end
        local out={};for i=0,n-1 do out[#out+1]=assert(bytes[at+i],'Missing fixture byte')end
        local value=table.concat(out)
        if self.after_read then self.after_read(at,n)end
        return value
    end
    host.layout=M.populate(function(at,value)host:put(at,value)end,host.base,options)
    return host
end
return M
