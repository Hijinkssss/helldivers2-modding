-- Semantic state machine ONLY. Not wired to native Fire until evidence gates pass.
-- No memory, timers, stats, reload commands, or per-weapon charge thresholds.
local M={}
function M.new(behavior)
    assert(behavior=='release_at_ready' or behavior=='restart_after_beam','Unknown charge behavior')
    local self={phase='idle',identity=nil,wait_release=false}
    function self:cancel(reason,require_release)
        self.phase='idle';self.identity=nil;self.wait_release=require_release==true
        return {action='stop',reason=reason}
    end
    function self:step(o)
        assert(type(o)=='table','Observation required')
        if o.physical_held==false then return self:cancel('physical_release',false)end
        if o.physical_held~=true or o.valid~=true or type(o.identity)~='string' or
            o.enabled~=true or o.can_fire~=true or o.state=='unknown' or o.state=='reload_required' then
            return self:cancel(o.state or 'invalid',true)
        end
        if self.identity and self.identity~=o.identity then return self:cancel('identity_changed',true)end
        if self.wait_release then return {action='stop',reason='wait_physical_release'}end
        self.identity=o.identity
        local valid={idle=true,charging=true,ready=true,firing=true,recovering=true}
        if not valid[o.state] then return self:cancel('unknown_state',true)end
        if behavior=='release_at_ready' then
            if self.phase=='released' then
                -- Wait for native completion before a new charge input edge.
                if o.state=='idle' then self.phase='charging';return {action='press'}end
                return {action='release'}
            end
            if o.state=='ready' then self.phase='released';return {action='release'}end
            self.phase='charging';return {action='hold'}
        end
        if o.state=='firing' then self.phase='beam';return {action='hold'}end
        if self.phase=='beam' and (o.state=='recovering' or o.state=='idle') then
            self.phase='released';return {action='release'}
        end
        if self.phase=='released' then
            if o.state=='idle' then self.phase='charging';return {action='press'}end
            return {action='release'}
        end
        self.phase='charging';return {action='hold'}
    end
    return self
end
return M
