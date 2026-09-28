-- One consumer-owned resolved state. A future HUD reads snapshot(), never memory.
local Policy=require('weapon_policy')
local M={}
local function integer(value,maximum)
    return type(value)=='number' and value==value and value%1==0 and value>0 and value<maximum
end
local function clone(value)
    if type(value)~='table' then return value end
    local result={};for key,item in pairs(value)do result[key]=clone(item) end;return result
end
function M.new(policy,validated)
    local last_decision,last_hash
    local state={user_enabled=true,weapon={},eligibility={category='REVIEW'},identity_valid=false,
        identity_observed=false,effective=false,repeat_active=false,reason='identity_unavailable',revision=0}
    local self={cache_hits=0,cache_misses=0}
    local function derive()
        state.effective=state.user_enabled and state.identity_valid and
            (state.eligibility.category=='ASSIST' or state.eligibility.category=='SPECIAL')
    end
    function self:set_enabled(enabled)
        state.user_enabled=enabled==true;derive();state.revision=state.revision+1
    end
    function self:invalidate(reason)
        last_decision,last_hash=nil,nil
        state.weapon={};state.eligibility={category='REVIEW'};state.identity_valid=false
        state.identity_observed=false;state.effective=false;state.reason=reason or 'identity_unavailable'
        state.revision=state.revision+1
    end
    function self:resolve(result,expected_unit)
        local avatar=type(result)=='table' and result.ok==true and result.value
        local held=type(avatar)=='table' and avatar.held
        if type(avatar)~='table' or avatar.state~='present' or not integer(avatar.unit_ref,4294967295) or
            (expected_unit~=nil and avatar.unit_ref~=expected_unit) or type(held)~='table' or
            held.state~='present' or not integer(held.entity_id,4294967295) or not Policy.hash(held.resource_hash) then
            self:invalidate('identity_unavailable_or_player_changed');return self:snapshot()
        end
        local resource_hash=Policy.hash(held.resource_hash)
        local decision
        if last_hash==resource_hash then decision=last_decision;self.cache_hits=self.cache_hits+1
        else decision=policy:classify(resource_hash,nil);self.cache_misses=self.cache_misses+1 end
        last_hash,last_decision=resource_hash,decision
        if state.identity_observed and state.weapon.unit_ref==avatar.unit_ref and
            state.weapon.avatar_id==avatar.avatar_id and
            state.weapon.entity_id==held.entity_id and state.weapon.resource_hash==resource_hash then
            return self:snapshot() -- Fresh guards passed; resolved policy/state is unchanged.
        end
        state.weapon={unit_ref=avatar.unit_ref,avatar_id=avatar.avatar_id,entity_id=held.entity_id,resource_hash=resource_hash,
            semantic_id=decision.semantic_id,name=decision.name,selected_mode=nil}
        state.eligibility={category=decision.category,max_repeat_rpm=decision.max_repeat_rpm,notes=decision.notes}
        state.identity_observed=true
        state.identity_valid=validated==true and decision.semantic_id~=nil
        state.reason=not validated and 'identity_validation_pending' or decision.reason
        derive();state.revision=state.revision+1
        return self:snapshot()
    end
    function self:set_repeat(active)state.repeat_active=active==true end
    function self:snapshot()return clone(state) end
    function self:cache_status()return {hits=self.cache_hits,misses=self.cache_misses}end
    return self
end
return M
