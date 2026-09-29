-- Live-path order: controller starts before an owned avatar exists; the mission
-- loads, then the avatar and eligible held weapon become observable.
gameplay=false;avatar_ok=false;fire=true
a=app.install(standalone_host,function()return backend end,function()return ''end)
local startup=a:get_state()
assert(startup.user_enabled and not startup.identity_valid and not startup.effective)
tick(0)
assert(a:status().active and not a:get_state().identity_valid and not a:status().wait_release)

-- Mission entry precedes player/avatar readiness. No toggle is synthesized.
gameplay=true;tick(120)
assert(a:get_state().user_enabled and not a:get_state().identity_valid)
avatar_ok=true;resource_hash='05e4e5c2db6e44a2';entity_id=5001;unit=123
tick(240)
local before_fire=a:get_state()
assert(before_fire.user_enabled and before_fire.identity_valid and before_fire.effective)
tick(260)
assert(backend.lease and a:get_state().repeat_active,
    'First eligible weapon must assist on held Fire after delayed avatar readiness')
fire=false;tick(280)
assert(not backend.lease and not a:get_state().repeat_active)

-- ON persists through the next mission without a toggle.
gameplay=false;tick(400,false);gameplay=true;tick(520,false)
assert(a:get_state().user_enabled and a:status().active)

-- OFF then ON each update the same preference exactly once and persist across
-- their following mission transition.
local before_pref=a:get_state()
local before_status=a:status()
assert(before_pref.user_enabled and before_pref.identity_valid and before_pref.effective and
    not before_pref.repeat_active and not before_status.wait_release,
    'State immediately before the fallback toggle is fully reconciled')
local prior=before_status.counters.toggles
tick(700,true);tick(720,false)
local after_pref=a:get_state()
local after_status=a:status()
assert(not after_pref.user_enabled and not after_pref.effective and not after_status.active)
assert(after_pref.identity_valid==before_pref.identity_valid and
    after_pref.identity_observed==before_pref.identity_observed and
    after_pref.weapon.resource_hash==before_pref.weapon.resource_hash and
    after_pref.revision==before_pref.revision+1,
    'Toggle changes preference/effective revision without disturbing resolved identity')
assert(after_status.counters.toggles==prior+1 and after_status.wait_release,
    'One fallback press toggles once and requires release before a future hold')
gameplay=false;tick(900,false);gameplay=true;tick(1020,false)
assert(not a:get_state().user_enabled and not a:status().active)
tick(1200,true);tick(1220,false)
assert(a:get_state().user_enabled and a:status().active)
assert(a:status().counters.toggles==prior+2)
gameplay=false;tick(1400,false);gameplay=true;tick(1520,false)
assert(a:get_state().user_enabled and a:status().active)

-- Temporary guards and weapon swaps never alter the user preference.
local function check_guard(label)
    assert(a:get_state().user_enabled and a:status().active,label)
end
menu=true;tick(1600,false);check_guard('menu guard');menu=false
focused=false;tick(1720,false);check_guard('focus guard');focused=true
fire=true;tick(1840);assert(backend.lease)
resource_hash='968211c0033dce64';entity_id=5002;tick(1860)
assert(not backend.lease);check_guard('weapon swap guard')
fire=false;tick(1880);assert(a:stop().ok)
shutdown()
print('test_live_startup_reconcile: all checks passed')
