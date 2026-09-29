-- Exercise policy intervals through the installed controller, not just arithmetic.
local rows={
    {'05e4e5c2db6e44a2',380,900,'ASSIST'},
    {'0f83639ab8c86165',380,480,'ASSIST'},
    {'1a437158e1b8d2a1',380,450,'ASSIST'},
    {'03e67a19b07c6523',350,350,'ASSIST'},
    {'4c786785c79d44e7',350,350,'ASSIST'},
    {'89c5493e08ca4207',120,400,'SPECIAL'},
    {'cf8934ff6567a42d',380,450,'ASSIST'},
}
a=app.install(core,function()return backend end,function()return cadence_config end)
for i,row in ipairs(rows) do
    local at=i*200
    resource_hash=row[1];entity_id=1000+i;fire=false;tick(at)
    assert(a:get_state().effective and a:get_state().eligibility.category==row[4])
    fire=true;tick(at+20)
    local expected=math.max(cadence_override_ms/1000,60/row[cadence_mode=='native_cap' and 3 or 2])
    assert(backend.lease and math.abs(backend.repeat_seconds-expected)<.000001,
        'Controller must use the selected per-weapon cadence: '..row[1])
    fire=false;tick(at+40)
    assert(not backend.lease and not a:get_state().repeat_active,'Release restores lease')
end
for i,hash in ipairs({'968211c0033dce64','35a61296619cc47e'}) do
    local at=1600+i*200
    local starts=backend.starts
    resource_hash=hash;entity_id=2000+i;fire=false;tick(at);fire=true;tick(at+20)
    assert(not backend.lease and backend.starts==starts and not a:get_state().effective)
    fire=false;tick(at+40)
end
-- Switching between eligible identities also restores and waits for release.
resource_hash=rows[1][1];entity_id=3001;fire=false;tick(2400);fire=true;tick(2420)
assert(backend.lease)
resource_hash=rows[#rows][1];entity_id=3002;tick(2440)
assert(not backend.lease and a:get_state().effective)
tick(2460);assert(not backend.lease)
fire=false;tick(2480);fire=true;tick(2500);assert(backend.lease)
assert(a:stop().ok and not backend.lease)
shutdown();assert(a:status().counters.errors==0 and core.Diagnostics:Status().scheduler.active==0)
