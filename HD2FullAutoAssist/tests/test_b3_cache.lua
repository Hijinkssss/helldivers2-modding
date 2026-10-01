local Fixture=require('native_transition_fixture')
local peace,talon='05e4e5c2db6e44a2','416d053372c4e433'
local function arm(f)
    f:fire(false);f:tick();f:fire(true);f:tick()
    f:healthy();assert(f.backend.lease)
end
local f=Fixture.new();arm(f)
local before=f.host:diagnostics().observer
local misses=f.consumer:status().assist_state.revision
for _=1,100 do f:tick(5000)end
local after=f.host:diagnostics().observer
assert(after.discoveries==before.discoveries and after.cache_hits>=before.cache_hits+100)
assert(f.consumer:status().assist_state.revision==misses,'Same identity must not rebuild derived policy/state')
-- A generation/identity change with the same root addresses must cancel the lease.
f:respawn(0x42,0x99);f:tick()
assert(not f.backend.lease and f:restored() and f.consumer:status().wait_release)
arm(f);assert(f.consumer:get_state().weapon.avatar_id==0x99)
-- Parent pointer movement must be checked BEFORE reading any cached child.
f:fire(false);f:tick();local current=f.host:local_avatar();assert(current.ok)
local start=#f.read_log
f:relocate_equipment(0x68000000)
current=f.host:local_avatar();assert(current.ok)
for i=start+1,#f.read_log do assert(f.read_log[i].at~=f.EM+32,'Stale equipment manager followed')end
f:weapon(talon,0xb9,0x69000000);f:tick();arm(f)
assert(f.consumer:get_state().weapon.resource_hash==talon)
-- Same entity/hash, moved equipment-record pointer still invalidates the certificate.
f:fire(false);f:tick();before=f.host:diagnostics().observer
f:weapon(talon,0xb9,0x6a000000);assert(f.host:local_avatar().ok)
after=f.host:diagnostics().observer;assert(after.discoveries==before.discoveries+1)
-- Move the held row array and preserve identity. The old row must not be read.
local newrows=0x6b000000;f:put(newrows,f.u32(0xb9));f:put(f.WM+96,f.ptr(newrows))
start=#f.read_log;assert(f.host:local_avatar().ok)
for i=start+1,#f.read_log do assert(f.read_log[i].at~=f.ROWS,'Stale wielder row followed')end
-- Compaction changes a key/index row even when all table roots are unchanged.
local key=0x99;local maprow=0x53000000+key%8*8
f:put(maprow,f.u32(key)..f.u32(1));f:put(f.BACKS+8,f.ptr(f.AVATAR))
f:put(newrows+464,f.u32(0xb9));before=f.host:diagnostics().observer
assert(f.host:local_avatar().ok)
assert(f.host:diagnostics().observer.discoveries==before.discoveries+1)
-- Unreadable child fails closed, then fresh discovery recovers without stale values.
f.failed_read=0x6a000000;assert(not f.host:local_avatar().ok)
f.failed_read=nil;assert(f.host:local_avatar().ok)
assert(f.host:diagnostics().observer.invalidations>0)
assert(f.consumer:stop().ok and f:restored())

-- Bounded binding rediscovery, exact restoration and no original recapture.
f=Fixture.new();arm(f);local searches=f.backend.binding_searches
f:fire(false);f:tick();arm(f)
assert(f.backend.binding_searches==searches and f.backend.binding_hits>0)
f:fire(false);f:tick()
local shifted=f.BUCKET+328
f:put(f.BUCKET,f.u32(1234)..f.u32(0))
f:put(shifted,f.u32(0x20009)..f.u32(2)..f.original..f.original)
f:fire(true);f:tick();f:healthy()
assert(f.backend.lease.bucket==shifted and f.backend.binding_searches==searches+1)
assert(f.backend.binding_probes<=256*(searches+1),'Binding searches must remain bounded')
f:fire(false);f:tick();assert(f:bytes(shifted+8,40)==f.original..f.original)
assert(f.consumer:stop().ok)

-- Worst-case Fire table collision chain consumes exactly the 256-slot budget.
f=Fixture.new();f:fire(false);f:tick()
for i=0,255 do f:put(f.BINDINGS+i*328,f.u32(1234)..f.u32(0))end
local last=f.BINDINGS+8*328
f:put(last,f.u32(0x20009)..f.u32(2)..f.original..f.original)
f:fire(true);f:tick();f:healthy()
assert(f.backend.lease.bucket==last and f.backend.binding_probes==257,
    'One initial inspection probe plus one complete bounded 256-slot discovery')
f:fire(false);f:tick();assert(f:bytes(last+8,40)==f.original..f.original)
assert(f.consumer:stop().ok)

-- Read failure during RESTORE retains the lease and originals until retry succeeds.
f=Fixture.new();arm(f);f.failed_read=f.CONTROLS+0xa7ad0
f:fire(false);f:tick();assert(f.backend.lease and not f:restored())
assert(f.consumer:status().failed and f.host:diagnostics().scheduler.active>=1)
f.failed_read=nil;f:tick();assert(not f.backend.lease and f:restored())
assert(f.host:diagnostics().scheduler.active==0)
assert(f.consumer:stop().ok)

-- Cached page metadata never replaces current-access checking by RPM.
f=Fixture.new();local A=0x80000000;f:put(A,string.rep('a',8192))
assert(f.host:read_live(A,1)=='a' and f.host.live_region_last,
    'A guarded read should retain only its already-validated region as a lookup hint')
local queries=#f.queries
assert(f.host:read_live(A+20,1)=='a' and #f.queries==queries)
assert(f.host.live_region_last.base<=A+20 and A+20<f.host.live_region_last.base+f.host.live_region_last.size,
    'Same-region reads should reuse the bounded region hint')
f:put(A,'b');assert(f.host:read_live(A,1)=='b','Cached metadata must not cache native bytes')
f.bad_page=A;assert(not pcall(f.host.read_live,f.host,A,1) and not f.host.live_regions and
    not f.host.live_region_last,'Read failure must invalidate region metadata and its fast-path hint')
f.bad_page=nil;assert(f.host:read_live(A,1)=='b')
queries=#f.queries;f.now=f.now+1000001;f.host:read_live(A,1)
assert(#f.queries>queries,'Static page metadata must expire')
f.bad_page=A+4096
assert(not pcall(f.host.read_live,f.host,A+4094,4),'Cross-page RPM access failure must reject')
f.bad_page=nil
f.region_provider=function()return {base=A,size=4096,state=0x1000,protect=4}end
assert(not pcall(f.host.read_live,f.host,A+4096,1),'Wrong-region metadata must not certify an address')
f.region_provider=nil
for i=1,70 do
    local at=A+0x10000+i*4096;f:put(at,'x');assert(f.host:read_live(at,1)=='x')
end
assert(#f.host.live_regions<=64,'Persistent region metadata must remain bounded')
assert(f.consumer:stop().ok)

-- Idle ship never performs identity discovery, including return from a mission.
f=Fixture.new();f:game_state(1);for _=1,100 do f:tick(5000)end
assert(f.host:diagnostics().observer.discoveries==0)
f:game_state(4);f:tick();assert(f.consumer:get_state().identity_valid)
f:game_state(1);f:tick();assert(not f.consumer:get_state().identity_valid)
before=f.host:diagnostics().observer.discoveries
for _=1,100 do f:tick(5000)end
assert(f.host:diagnostics().observer.discoveries==before)
assert(f.consumer:stop().ok)
print('B3 certificate, compaction, bounded binding, restore retry and RPM cache checks passed')
