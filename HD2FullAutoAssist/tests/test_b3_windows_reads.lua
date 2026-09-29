-- Actual Windows APIs against this test process's OWN temporary allocation.
-- No game/process attachment, persistent system changes or game writes.
local ffi=require('ffi')
local Platform=require('platform')
local Fixture=require('native_transition_fixture')
ffi.cdef[[
void *VirtualAlloc(void *,size_t,uint32_t,uint32_t);
int VirtualProtect(void *,size_t,uint32_t,uint32_t *);
int VirtualFree(void *,size_t,uint32_t);
]]
local kernel=ffi.load('kernel32')
local memory=kernel.VirtualAlloc(nil,8192,0x3000,4)
assert(memory~=nil,'Own-process test allocation failed')
local address=tonumber(ffi.cast('uintptr_t',memory))
local previous=ffi.new('uint32_t[1]')
local f=Fixture.new();local windows=Platform.new()
local old_read,old_query=f.platform.read,f.platform.query_region
f.platform.read=function(p,at,n)
    if at>=address and at<address+8192 then return windows:read(at,n)end
    return old_read(p,at,n)
end
f.platform.query_region=function(p,at)
    if at>=address and at<address+8192 then return windows:query_region(at)end
    return old_query(p,at)
end
local freed=false
local good,problem=pcall(function()
    ffi.fill(memory,8192,65)
    assert(f.host:read_live(address,32)==string.rep('A',32))
    assert(kernel.VirtualProtect(memory,4096,0x104,previous)~=0)
    assert(not pcall(f.host.read_live,f.host,address,32),'Cached metadata cannot authorize a guarded RPM read')
    assert(windows:query_region(address).protect==0x104,'RPM must not consume the guard flag')
    assert(kernel.VirtualProtect(memory,4096,4,previous)~=0)
    assert(f.host:read_live(address,32)==string.rep('A',32))
    assert(kernel.VirtualProtect(ffi.cast('void *',address+4096),4096,1,previous)~=0)
    assert(not pcall(f.host.read_live,f.host,address+4094,4),'Cross-page inaccessible span must fail')
    assert(kernel.VirtualProtect(ffi.cast('void *',address+4096),4096,4,previous)~=0)
    assert(f.host:read_live(address+4094,4)=='AAAA')
    assert(kernel.VirtualFree(memory,0,0x8000)~=0);freed=true
    assert(not pcall(f.host.read_live,f.host,address,1),'Freed allocation must never return cached data')
end)
if not freed then assert(kernel.VirtualFree(memory,0,0x8000)~=0)end
assert(f.consumer:stop().ok)
assert(good,tostring(problem))
print('B3 actual Windows RPM: cached guard/no-access/freed allocation checks passed')
