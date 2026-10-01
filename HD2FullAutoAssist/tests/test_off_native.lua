-- Replay the actual live mapping type (2), not only the old press-edge fixture (0).
-- This checks FAA ownership; it is not a weapon-controller/shot emulator.
local Fixture=require('native_transition_fixture')
local ffi=require('ffi')
local function word(s,at)local a,b,c,d=s:byte(at+1,at+4);return a+b*256+c*65536+d*16777216 end
local function float(s,at)local n=ffi.new('float[1]');ffi.copy(n,s:sub(at+1,at+4),4);return tonumber(n[0]) end
for _,profile in ipairs({'slower_27','balanced_28','max_32'})do
    local f=Fixture.new('eruptor_profile='..profile)
    local original=f.u32(0x0012ff43)..f.u32(1)..f.u32(2)..f.float(0)..f.float(.5)
    f:put(f.BUCKET,f.u32(0x20009)..f.u32(3)..original:rep(3))
    local function restored()return f:bytes(f.BUCKET+8,60)==original:rep(3)end
    local function toggle()f.host.callbacks.toggle.callback()end
    f:weapon('b6aff2195568767f');f:input(1,.5,true,2);f:tick()
    assert(f.backend.lease and #f.backend.lease.records==3)
    assert(word(f:bytes(f.BUCKET+8,20),8)==8)
    toggle();assert(not f.consumer:status().active and not f.backend.lease and restored())
    assert(not f.consumer:get_state().repeat_active)
    local writes=f.writes
    -- Stock type 2 remains a level signal while held, including a new press.
    -- No FAA mapping writes/reacquisition occur during OFF frames.
    for i=1,100 do f:input(1,.5+i/120,true,2);f:tick(8333)end
    f:input(0,0,false,2);f:tick();f:input(1,.1,true,2);f:tick()
    assert(f.writes==writes and restored() and not f.backend.lease)
    f:weapon('05e4e5c2db6e44a2');f:tick();f:weapon('b6aff2195568767f');f:tick()
    assert(f.writes==writes and not f.backend.lease)
    local no_lease_revision=f.host.native_cache_revision or 0
    local no_lease_invalidations=f.host:diagnostics().observer.invalidations
    local no_lease_writes,no_lease_restores=f.backend.writes,f.backend.restored
    toggle();assert(f.consumer:get_state().user_enabled,'ON toggle must take effect immediately')
    assert((f.host.native_cache_revision or 0)==no_lease_revision and
        f.host:diagnostics().observer.invalidations==no_lease_invalidations,
        'Toggle without a lease must preserve valid identity/native caches')
    assert(f.backend.writes==no_lease_writes and f.backend.restored==no_lease_restores,
        'Toggle without a lease must not write or restore mappings')
    assert(f.consumer:status().counters.toggle_cache_invalidation_skips>0)
    f:tick();assert(not f.backend.lease,'ON while held must retain release guard')
    f:input(0,0,false,2);f:tick();f:input(1,.1,true,2);f:tick()
    assert(f.backend.lease)
    assert(f.backend.repeat_seconds==60/({slower_27=27,balanced_28=28,max_32=32})[profile])
    f:weapon('05e4e5c2db6e44a2');f:tick();assert(restored() and not f.backend.lease)
    f:weapon('b6aff2195568767f');f:tick();assert(not f.backend.lease)
    f:input(0,0,false,2);f:tick();f:input(1,.1,true,2);f:tick();assert(f.backend.lease)
    local active_lease_revision=f.host.native_cache_revision or 0
    toggle();assert(restored() and not f.backend.lease)
    assert((f.host.native_cache_revision or 0)>active_lease_revision,
        'Restoring an active lease must still invalidate identity/native caches')
    assert(f.consumer:stop().ok)
end
-- Exact-build jump-table case 2 (0x12fc2b9): abs(new magnitude)>=parameter.
-- It does not consult old held time or the previous transient pulse.
local function level(magnitude,threshold)return math.abs(magnitude)>=threshold end
assert(level(1,.5) and level(1,.5) and not level(0,.5))
print('PASS live-type-2 OFF: 3 Eruptor profiles, 3 mappings, held toggles, fresh press, ON/OFF swaps, re-equip and zero OFF mapping writes; native level input is not a shot proof')
