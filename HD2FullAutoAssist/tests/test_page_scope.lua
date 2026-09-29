local Fixture=require('native_transition_fixture')
local f=Fixture.new();local h=f.host
local A,B=0x80000000,0x81000000
f:put(A,string.rep('a',8192));f:put(B,string.rep('b',8192))
local function page(at)return math.floor(at/4096)*4096 end
local function count()return #f.queries end
local function readable(at)return {base=page(at),size=4096,state=0x1000,protect=4}end
local function guarded(at)return {base=page(at),size=4096,state=0x1000,protect=0x104}end
local before=count()
h:read_scope(function()
    assert(h:read(A,1)=='a');assert(h:read(A+200,1)=='a')
    assert(count()==before+1,'Same queried region should be shared')
    f.region_provider=function(at)return guarded(at)end
    assert(not pcall(h.read,h,B,1),'New pointer address must not borrow A page validation')
    assert(count()==before+2,'Different region must query at the new address')
end)
assert(h.regions==nil)
f.region_provider=readable;assert(h:read(B,1)=='b','Invalid row must expire before next scope')
-- Spanning reads must query and reject a guarded second page.
f.region_provider=function(at)return page(at)==A and readable(at) or guarded(at)end
before=count()
h:read_scope(function()
    assert(h:read(A+4094,2)=='aa')
    assert(not pcall(h.read,h,A+4094,4),'First page cannot validate bytes in next page')
end)
assert(count()==before+2 and h.regions==nil)
-- A lying/mismatched platform result cannot certify a new address.
f.region_provider=function()return readable(A)end
assert(not pcall(h.read,h,B,1))
-- End address is exclusive; neither adjacent page nor new identity is cached.
f.region_provider=readable;before=count()
h:read_scope(function()h:read(A,1);h:read(A+4096,1)end)
assert(count()==before+2)
-- Nested and failing scopes always discard rows when the outer scope exits.
assert(not pcall(h.read_scope,h,function()
    h:read_scope(function()h:read(A,1);error('nested failure')end)
end) and h.regions==nil)
-- Cache contains only page metadata: same address always reads fresh bytes.
h:read_scope(function()
    assert(h:read(A,1)=='a');f:put(A,'z');assert(h:read(A,1)=='z')
end)
-- Pre-stock callback scopes expire each update, including invalidation/recovery.
f:weapon('05e4e5c2db6e44a2');f:tick();local reads=h:diagnostics().memory.reads;f:tick()
assert(h:diagnostics().memory.reads>reads and h.regions==nil)
f.failed_read=f.ERECORD;f:tick();f:healthy();assert(not f.consumer:get_state().identity_valid)
f.failed_read=nil;f:tick();assert(f.consumer:get_state().identity_valid)
assert(f.consumer:stop().ok)
print('page range, cross-page, new pointer, fresh bytes and scope recovery passed')
