local Menu = require('mod_options_menu')
local ids = {enabled='codex.full_auto_assist.enabled', profile='codex.full_auto_assist.peacemaker_profile'}

-- The menu is optional and load order may put it after FAA.
local fallback_calls = 0
local waiting = Menu.new({user_enabled=true,peacemaker_profile='',fire_rate_mode='balanced'}, {
    set_enabled=function()fallback_calls=fallback_calls+1 end,
    set_profile=function()fallback_calls=fallback_calls+1 end})
_G.ModOptionsMenu=nil
waiting:step()
assert(not waiting.registered and fallback_calls==0)

local values,callbacks,specs,sets={},{},{},{}
local api={api=1,version=3,ready=function()return true end}
function api.register_option(id,spec)
    specs[id]=spec
    if values[id]==nil then values[id]=spec.default end
    return true
end
function api.get(id)return values[id]end
function api.on_change(id,callback)callbacks[id]=callback;return true end
function api.set(id,value)values[id]=value;sets[#sets+1]={id=id,value=value};return true end
_G.ModOptionsMenu=api

local policy=require('weapon_policy').new('balanced','balanced',{})
local state=require('assist_state').new(policy,true)
state:set_enabled(true)
local wait_release=false
local profile_restore_pending=false
local bridge=Menu.new({user_enabled=true,peacemaker_profile='',fire_rate_mode='balanced'}, {
    set_enabled=function(value)
        if state:is_enabled()==value then return end
        if not value then wait_release=true end
        state:set_enabled(value)
    end,
    set_profile=function(profile,weapon)
        assert(policy:set_profile(weapon,profile))
        state:refresh_policy()
        profile_restore_pending=true
    end})
bridge:step()
assert(bridge.registered and specs[ids.enabled].type=='toggle' and specs[ids.enabled].default==true)
assert(specs[ids.profile].type=='choice' and specs[ids.profile].default==1)
assert(specs[ids.profile].choices[1]=='Balanced' and specs[ids.profile].choices[2]=='Full Auto')
assert(not specs[ids.profile].min and not specs[ids.profile].max,'No arbitrary RPM slider')
assert(state:is_enabled() and policy:classify('05e4e5c2db6e44a2').max_repeat_rpm==380)

-- Resolve a current Peacemaker identity, then verify an applied named choice
-- refreshes the live policy without another identity/native snapshot.
local identity={ok=true,value={state='present',unit_ref=123,identity_token='unit',held={state='present',entity_id=1001,
    resource_hash='05e4e5c2db6e44a2',identity_token='held'}}}
assert(state:resolve(identity,123).eligibility.max_repeat_rpm==380)
callbacks[ids.profile](2)
local after=state:snapshot()
assert(after.identity_valid and after.effective and after.eligibility.max_repeat_rpm==900)
assert(profile_restore_pending,'Active-lease restoration is requested for the next FAA tick')

-- Menu Apply disables and re-enables the same state used by the existing hotkey.
callbacks[ids.enabled](false)
assert(not state:is_enabled() and wait_release)
callbacks[ids.enabled](true)
assert(state:is_enabled() and wait_release)
assert(bridge:set_enabled(false) and values[ids.enabled]==false)

-- A rejected API registration preserves the existing safe runtime defaults.
local rejected_handlers=0
_G.ModOptionsMenu={api=1,register_option=function()return false,'category full'end,
    get=function()return nil end,set=function()return true end,on_change=function()return true end}
local rejected=Menu.new({user_enabled=true,peacemaker_profile='',fire_rate_mode='balanced'}, {
    set_enabled=function()rejected_handlers=rejected_handlers+1 end,
    set_profile=function()rejected_handlers=rejected_handlers+1 end})
rejected:step()
assert(rejected.failed and not rejected.registered and rejected_handlers==0)

print('test_mod_options_runtime: adapter and live policy checks passed')
