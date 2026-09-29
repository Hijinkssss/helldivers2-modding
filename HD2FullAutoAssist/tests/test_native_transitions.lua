local Fixture=require('native_transition_fixture')
local Policy=require('weapon_policy')
local peace,eruptor,talon,cookout,verdict,crossbow='05e4e5c2db6e44a2','b6aff2195568767f','416d053372c4e433','d323de60855898ac','1a437158e1b8d2a1','f49227a0630a3f7f'
local unsupported='968211c0033dce64'
local function active(f,hash)
    f:healthy();assert(f.backend.lease and f.consumer:get_state().effective)
    assert(f.consumer:get_state().weapon.resource_hash==hash)
    local expected=60/f.consumer:get_state().eligibility.max_repeat_rpm
    assert(math.abs(f.backend.repeat_seconds-expected)<1e-9)
    local ffi=require('ffi');local v=ffi.new('float[1]')
    ffi.copy(v,f:bytes(f.BUCKET+24,4),4)
    assert(math.abs(tonumber(v[0])-require('native_fire').native_period(expected))<1e-6,'Native mapping must receive the selected interval')
end
local function acquire(f,hash,id,address)
    f:fire(false);f:tick();f:weapon(hash,id,address);f:tick()
    assert(f.consumer:get_state().weapon.resource_hash==hash and not f.backend.lease)
    f:fire(true);f:tick();active(f,hash)
end
local function swap(f,hash,id,address)
    local holds=f.consumer:status().counters.holds
    local restored=f.backend.restored
    f:weapon(hash,id,address);f:tick()
    f:healthy();assert(not f.backend.lease and f:restored(),'Swap must restore every leased mapping')
    assert(f.backend.restored==restored+2 and f.consumer:status().wait_release)
    assert(f.consumer:get_state().weapon.resource_hash==hash)
    f:tick();assert(f.consumer:status().counters.holds==holds,'Held swap must wait for release')
    f:fire(false);f:tick();assert(not f.consumer:status().wait_release)
    f:fire(true);f:tick();active(f,hash)
    assert(f.consumer:status().counters.holds==holds+1,'New weapon must reacquire a lease')
end
-- Native A -> B -> C plus the specifically reported pairs in both directions.
for _,sequence in ipairs({{peace,cookout,verdict},{eruptor,talon,eruptor},
                         {talon,eruptor,talon},{cookout,verdict,cookout},
                         {verdict,cookout,verdict},{peace,crossbow,talon}})do
    local f=Fixture.new();acquire(f,sequence[1])
    swap(f,sequence[2],0xb9,0x64000000);swap(f,sequence[3],0xc9,0x65000000)
    assert(f.consumer:status().counters.identity_changes>=3)
    assert(f.physical_samples==0,'Production updates must skip trace-only mouse sampling')
    assert(f.consumer:status().counters.errors==0 and f.host:diagnostics().scheduler.failures==0)
    assert(f.consumer:stop().ok and f:restored())
end
-- All 30 assisted resources in both modes with the real native cadence guard.
local hashes={peace,'4d58c77087b774c5','c780bcd79547da0f',verdict,'03e67a19b07c6523',
 '4c786785c79d44e7','0f83639ab8c86165',talon,'89c5493e08ca4207',
 '7b75e5132ffd4ca6','e6d932be83729076','e5796355a8fd67e0','f0338468dcdb6a6c',
 '41eac4a03987faa0','4f749e2ee26f532d','4e310b1fe4c52b52',cookout,'90ddc374f4e3d756',
 'c12a34f375bd5a87',crossbow,eruptor,'05d8d8c073b9d502','1abbff60d26ba391',
 '80f1a156d9fa1e36','8d3d52a3b2f19402','d6b1fb05b9109353','2b28e17ffed05f7c',
 '0b882808c6f498e8','dbb6c961c59fadc1','cf8934ff6567a42d'}
assert(#hashes==30) -- 29 weapons plus the AMR support weapon.
for _,mode in ipairs({'balanced','native_cap'})do
    local f=Fixture.new('fire_rate_mode='..mode)
    for i,hash in ipairs(hashes)do acquire(f,hash,0x100+i,0x64000000+i*4096)end
    f:healthy();assert(f.consumer:status().counters.holds==#hashes)
    assert(f.consumer:stop().ok and f:restored())
end
-- Every selectable Arsenal profile reaches the actual native mapping.
for _,row in ipairs({{peace,'peacemaker_profile',{'balanced','full_auto'}},
 {'4d58c77087b774c5','socom_profile',{'balanced','full_auto'}},
 {'c780bcd79547da0f','veto_profile',{'balanced','full_auto'}},
 {talon,'talon_profile',{'balanced','efficiency','full_auto','fuller_auto'}},
 {'89c5493e08ca4207','amr_profile',{'balanced','full_auto'}},
 {'e5796355a8fd67e0','hyena_profile',{'balanced','full_auto'}},
 {'2b28e17ffed05f7c','bushwhacker_profile',{'balanced','full_auto'}}})do
    for _,profile in ipairs(row[3])do
        local f=Fixture.new(row[2]..'='..profile);acquire(f,row[1])
        local decision=Policy.new('balanced','balanced',{[row[2]]=profile}):classify(row[1])
        assert(math.abs(f.backend.repeat_seconds-decision.repeat_seconds)<1e-9)
        assert(f.consumer:stop().ok and f:restored())
    end
end
local f=Fixture.new();acquire(f,peace)
f:weapon(unsupported,0xb9,0x64000000);f:tick()
f:healthy();assert(not f.backend.lease and f:restored() and not f.consumer:get_state().effective)
f:fire(false);f:tick();acquire(f,verdict,0xc9,0x65000000)
-- New hash with unchanged entity, then new entity with unchanged hash.
swap(f,cookout,0xc9,0x66000000);swap(f,cookout,0xd9,0x67000000)
-- Identity global relocation and record pointer change during one update:
-- Fire must dereference fresh bytes, even when identity populated the page cache.
f:fire(false);f:tick()
local identity=f.host.callbacks.identity.callback
f.host.callbacks.identity.callback=function()
    identity()
    f:relocate_equipment(0x68000000)
    f:weapon(talon,0xe9,0x69000000)
end
f:fire(true);f:tick();active(f,talon)
f.host.callbacks.identity.callback=identity
-- Failed guarded identity read then successful recovery while controller survives.
for _,fault in ipairs({'failed_read','bad_page'})do
    f[fault]=f.ERECORD
    f:weapon(peace,0xa9,f.ERECORD);f:tick()
    f:healthy();assert(not f.backend.lease and f:restored() and not f.consumer:get_state().identity_valid)
    f[fault]=nil;f:fire(false);f:tick();f:fire(true);f:tick();active(f,peace)
end
-- Ship -> mission -> ship -> mission with preference and callbacks preserved.
for _,n in ipairs({1,4,1,4})do
    f:game_state(n);f:tick();f:healthy()
    if n~=4 then assert(not f.backend.lease and f:restored())
    else f:fire(false);f:tick();f:fire(true);f:tick();active(f,peace)end
    assert(f.consumer:get_state().user_enabled)
end
-- Death invalidates local unit; synthetic respawn restores that identity chain.
f:alive(false);f:tick();f:healthy();assert(not f.backend.lease and f:restored())
f:respawn(0x43,0x99);f:fire(false);f:tick();f:fire(true);f:tick();active(f,peace)
assert(f.consumer:get_state().weapon.unit_ref==0x43 and f.consumer:get_state().weapon.avatar_id==0x99)
-- Capture is observational: the same native sample/mapping path remains valid.
local before=f.physical_samples;local row=f.backend:sample(true)
assert(row.raw_lmb_down and f.physical_samples==before+1 and row.held and row.gameplay)
-- Retain cadence safety: reject invalid/out-of-roster values before any write.
f:fire(false);f:tick()
f:fire(true);row=f.backend:sample(false)
local writes=f.writes
for _,seconds in ipairs({0,-1,60/900-0.00001,60/26+0.00001,math.huge,0/0,'1'})do
    assert(not pcall(f.backend.begin,f.backend,row,seconds))
    assert(f.writes==writes and not f.backend.lease)
end
assert(f.consumer:stop().ok and f:restored())
print('native transitions, every cadence/profile, recovery and lifecycle passed')
