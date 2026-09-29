local Hud=require('hud_indicator')

local function snapshot(category,enabled,valid,observed,semantic)
    return {user_enabled=enabled,identity_valid=valid~=false,identity_observed=observed~=false,
        effective=enabled==true,repeat_active=false,
        weapon={semantic_id=semantic or 'weapon:P-2 Peacemaker'},
        eligibility={category=category}}
end
local function expect(value,state,visible,slash,opacity)
    assert(value.state==state,value.state..' ~= '..state)
    assert(value.visible==visible)
    assert(value.slash==slash)
    assert(value.opacity==opacity)
end

expect(Hud.project(snapshot('ASSIST',true)), 'ENABLED',true,false,1)
expect(Hud.project(snapshot('ASSIST',false)), 'DISABLED',true,true,1)
expect(Hud.project(snapshot('REVIEW',true)), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('REVIEW',false)), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('SPECIAL',true),0.35), 'ENABLED_DIM',true,false,0.35)
expect(Hud.project(snapshot('ASSIST',false),0.35), 'DISABLED_DIM',true,true,0.35)
expect(Hud.project(snapshot('ASSIST',true,false)), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('ASSIST',true,true,false)), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('REVIEW',true,true,true,'weapon:unknown')), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('IGNORE_NATIVE_AUTO',true,true,true,'weapon:AR-23 Liberator')), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('ASSIST',true),0), 'HIDDEN',false,false,0)
expect(Hud.project(snapshot('ASSIST',true),2), 'ENABLED',true,false,1)
expect(Hud.project(snapshot('ASSIST',true),0/0), 'HIDDEN',false,false,0)

-- Projection does not mutate or retain the authoritative AssistState snapshot.
local source=snapshot('ASSIST',false)
source.repeat_active=true
local before={user_enabled=source.user_enabled,effective=source.effective,
    repeat_active=source.repeat_active,category=source.eligibility.category,
    semantic_id=source.weapon.semantic_id}
Hud.project(source,0.4)
assert(source.user_enabled==before.user_enabled and source.effective==before.effective and
    source.repeat_active==before.repeat_active and source.eligibility.category==before.category and
    source.weapon.semantic_id==before.semantic_id)

-- Fire activity is intentionally irrelevant to indicator visibility.
source.user_enabled=true;source.eligibility.category='ASSIST';source.identity_valid=true;source.identity_observed=true
source.repeat_active=false
expect(Hud.project(source), 'ENABLED',true,false,1)
source.repeat_active=true
expect(Hud.project(source), 'ENABLED',true,false,1)
print('test_hud_indicator: all checks passed')
