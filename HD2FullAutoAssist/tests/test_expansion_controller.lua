-- Exercise accepted identity, held-Fire lease and immediate release for each
-- newly supported target with the synthetic standalone controller.
a=app.install(standalone_host,function()return backend end,function()return ''end)
assert(a:get_state().user_enabled)
local rows={
 '7b75e5132ffd4ca6','e6d932be83729076','e5796355a8fd67e0','f0338468dcdb6a6c',
 '41eac4a03987faa0','4f749e2ee26f532d','4e310b1fe4c52b52','d323de60855898ac',
 '90ddc374f4e3d756','c12a34f375bd5a87','f49227a0630a3f7f','b6aff2195568767f',
 '05d8d8c073b9d502','1abbff60d26ba391','80f1a156d9fa1e36','8d3d52a3b2f19402',
 'd6b1fb05b9109353','2b28e17ffed05f7c','0b882808c6f498e8','dbb6c961c59fadc1'}
local t=0
for i,hash in ipairs(rows)do
    t=t+160;resource_hash=hash;entity_id=3000+i;fire=false;tick(t)
    fire=true;tick(t+20)
    assert(backend.lease and a:get_state().effective and a:get_state().weapon.resource_hash==hash,
        'Eligible target must repeat normal Fire: '..hash)
    fire=false;tick(t+40)
    assert(not backend.lease and not a:get_state().repeat_active,
        'Release must stop immediately: '..hash)
end
resource_hash='076dd5d4f4360204';fire=false;tick(t+200)
fire=true;tick(t+220)
assert(not backend.lease and a:get_state().eligibility.category=='IGNORE_NATIVE_AUTO',
    'Blitzer native Full Auto remains untouched')
assert(a:stop().ok and not backend.lease)
shutdown()
print('test_expansion_controller: all checks passed')
