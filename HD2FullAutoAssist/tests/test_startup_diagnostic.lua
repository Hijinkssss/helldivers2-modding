-- Capture the requested A-I sequence without changing controller decisions.
local records={}
local function clone(v)
    if type(v)~='table' then return v end
    local c={};for k,x in pairs(v)do c[k]=clone(x)end;return c
end
standalone_host.log=function(_,level,event,fields)
    if event=='startup_diagnostic' then records[#records+1]=clone(fields) end
end
local source='fallback_key'
standalone_host.activation_status=function()return {toggle_source=source}end
backend.diagnostic=function(self)return {sample={game_state=gameplay and 4 or 1},
    original_mapping_records=self.lease and 1 or 0}end
local function find(phase,last)
    local found
    for _,r in ipairs(records)do if r.phase==phase then found=r;if not last then break end end end
    return assert(found,'Missing phase '..phase)
end
gameplay=false;avatar_ok=false;fire=false
a=app.install(standalone_host,function()return backend end,function()return ''end)
tick(0,false)
assert(find('A_controller_initialization').user_enabled)
assert(not find('A_controller_initialization').backend_initialized)
find('B_ship_or_pre_mission')
gameplay=true;tick(120,false);find('C_mission_active')
avatar_ok=true;tick(240,false);find('D_avatar_valid');find('E_eligible_weapon')
fire=true;tick(260,false)
local f=find('F_first_hold_before_toggle')
assert(f.user_enabled and f.effective and f.fire_held and not f.begin_attempted)
assert(find('begin_after').begin_count==1 and find('begin_after').begin_result==1)
tick(280,false);find('repeat_pulse_before_toggle')
fire=false;tick(300,false);tick(500,true)
local g,h=find('G_toggle_before'),find('H_toggle_after')
assert(g.user_enabled and not h.user_enabled and g.first_toggle_source=='fallback_key')
assert(g.begin_count==h.begin_count and g.backend_initialized==h.backend_initialized)
assert(h.wait_release and h.restore_reason=='toggle' and h.toggles==1)
assert(find('restore_after',true).detail.backend_restore_called==false)
tick(520,false);source='mod_bindings_menu';tick(700,true);tick(720,false)
fire=true;tick(740,false);tick(760,false)
assert(find('I_first_assisted_hold_after_toggle').lease_active)
assert(find('I_repeat_pulse_after_toggle').fire_pressed)
assert(find('H_toggle_after',true).detail.source=='mod_bindings_menu')
assert(find('H_toggle_after',true).first_toggle_source=='fallback_key')
fire=false;tick(780,false)
-- A guard rejects the callback without flipping the preference.
menu=true;tick(1000,true)
assert(find('H_toggle_rejected').toggle_rejected==1 and a:get_state().user_enabled)
menu=false;tick(1020,false)
-- Read failures in diagnostic-only native inspection never stop the controller.
backend.diagnostic=function()error('diagnostic-only unavailable')end
fire=true;tick(1040,false);assert(backend.lease and not a:status().failed)
local count=#records
for i=1,1000 do tick(1040+i*20,false)end
assert(#records<count+10,'Steady held input must not flood the log')
fire=false;tick(22000,false)
backend.begin=function()return nil,'fixture_axis_unsupported'end
fire=true;tick(22020,false)
assert(find('begin_after',true).begin_result=='unsupported')
assert(find('begin_after',true).begin_reason=='fixture_axis_unsupported' and a:status().wait_release)
fire=false;tick(22040,false)
backend.begin=function()error('fixture_begin_error')end
fire=true;tick(22060,false)
assert(find('begin_after',true).begin_result=='error')
assert(find('begin_after',true).begin_reason:find('fixture_begin_error',1,true))
assert(a:status().failed and not backend.lease)
assert(a:stop().ok);shutdown()
for _,r in ipairs(records)do
    for _,key in ipairs({'user_enabled','effective','identity_valid','identity_observed','reason','revision',
        'repeat_active','wait_release','weapon_name','resource_hash','entity_id','avatar_id','player_unit_ref',
        'category','max_repeat_rpm','backend_initialized','lease_active','unit_ref','leased_entity_id',
        'leased_resource_hash','eligibility_ok','eligibility_allowed','eligibility_reason','fire_held',
        'fire_pressed','trigger','gameplay','begin_attempted','begin_count','begin_result','begin_reason',
        'restore_count','restore_reason','toggles','toggle_rejected','first_toggle_source','runtime'})do
        assert(r[key]~=nil,'Missing diagnostic field '..key)
    end
end
print('startup diagnostic phases, before/after, guards, failure isolation and bounded logging passed')
