-- Independently implemented bridge to the separately installed public API.
local Result = require('hd2modcore.result')
local M = {}
local RESOURCE = 'mods/skyeshade/hd2runtime'
local BUILDERS = {weapon=true, support_weapon=true, stratagem=true,
    vehicle=true, backpack=true, equipment=true, booster=true,
    weapon_attachment=true}

function M.new(core, external_require)
    local runtime, attempted, problem, found, observed_version, observed_api
    local jobs, registered = {}, {}
    local self = {}
    local function active()
        return core:State()=='running' or core:State()=='degraded'
    end
    local function fail(code, detail)
        return Result.err(code, 'integration.hd2runtime', detail)
    end
    local function copy(value, depth)
        if type(value)~='table' then return value end
        if depth>24 then error('metadata nesting exceeds bridge limit') end
        local result={}
        for key,item in pairs(value) do result[key]=copy(item,depth+1) end
        return result
    end
    function self:Connect()
        if not active() then return fail('InvalidState','Core is not active') end
        if runtime then return Result.ok(self:Status()) end
        if attempted then return problem end
        attempted=true
        found=false
        if type(external_require)~='function' then
            problem=fail('DependencyUnavailable','host require is unavailable')
            return problem
        end
        local ok, value=pcall(external_require,RESOURCE)
        if not ok or type(value)~='table' then
            problem=fail('DependencyUnavailable',ok and 'runtime returned no API' or value)
            return problem
        end
        found=true
        observed_version=type(value.version)=='string' and value.version or nil
        observed_api=type(value.api_version)=='number' and value.api_version or nil
        if value.api_version~=1 or type(value.version)~='string' then
            problem=fail('UnsupportedDependency','HD2Runtime API 1 and version required')
            return problem
        end
        local major,minor,patch=value.version:match('^(%d+)%.(%d+)%.(%d+)$')
        if not major or (tonumber(major)==0 and tonumber(minor)<24) then
            problem=fail('UnsupportedDependency','HD2Runtime 0.24.0 or newer required')
            return problem
        end
        runtime=value
        return Result.ok(self:Status())
    end
    function self:Status()
        local presence;if attempted then presence=found end
        local capabilities={}
        for kind in pairs(BUILDERS) do
            capabilities[kind]=runtime~=nil and type(runtime[kind])=='function'
        end
        capabilities.legacy_read=runtime~=nil and type(runtime.read)=='function'
        local count=0;for _ in pairs(jobs) do count=count+1 end
        local state=runtime and 'connected' or (attempted and 'unavailable' or 'not_checked')
        if problem and problem.error.code=='UnsupportedDependency' then state='unsupported' end
        return {state=state,present=presence,
            resource=RESOURCE,version=observed_version,api=observed_api,
            reviewed_version=runtime~=nil and runtime.version=='0.24.0',
            capabilities=capabilities,active_reads=count,
            build_support='not_checked',
            build_support_reason='No separate public build-check API; each live operation verifies its own build',
            error=problem and copy(problem.error,0)}
    end
    function self:Target(kind, identity)
        if not active() then return fail('InvalidState','Core is not active') end
        if not runtime then return fail('DependencyUnavailable','call Connect during addon startup') end
        if not BUILDERS[kind] or type(runtime[kind])~='function' then
            return fail('UnsupportedCapability','no public builder for '..tostring(kind))
        end
        if type(identity)~='string' or #identity==0 or #identity>256 then
            return fail('InvalidTarget','a semantic name or ID of at most 256 bytes is required')
        end
        local ok,value=pcall(runtime[kind],identity)
        if not ok or type(value)~='table' then
            return fail('TargetUnavailable',ok and 'builder returned no target' or value)
        end
        return Result.ok(value)
    end
    function self:Describe(kind, identity)
        local target=self:Target(kind,identity)
        if not target.ok then return target end
        if type(target.value.describe)~='function' then
            return fail('UnsupportedCapability','target has no public describe method')
        end
        local ok,value=pcall(function()return copy(target.value:describe(),0)end)
        if not ok then return fail('TargetUnavailable',value) end
        return Result.ok(value)
    end
    function self:CancelRead(owner)
        local entry=jobs[owner]
        if not entry then return false end
        jobs[owner]=nil
        if entry.token then core.Hooks:Remove(entry.token) end
        entry.job=nil
        return true
    end
    function self:ReadLegacy(owner, target, on_result, on_error)
        if not active() then return fail('InvalidState','Core is not active') end
        if not runtime or type(runtime.read)~='function' then
            return fail('UnsupportedCapability','connect a runtime with public read support first')
        end
        if type(owner)~='string' or #owner==0 or #owner>128 or
            type(target)~='table' or type(target.read_target)~='function' or
            type(on_result)~='function' or (on_error~=nil and type(on_error)~='function') then
            return fail('InvalidRead','owner, public readable target and callback required')
        end
        if jobs[owner] then return fail('InvalidState','owner already has a read in progress') end
        local count=0;for _ in pairs(jobs) do count=count+1 end
        if count>=8 then return fail('BudgetExceeded','at most eight explicit read jobs') end
        local ok,descriptor=pcall(target.read_target,target)
        if not ok then return fail('UnsupportedCapability',descriptor) end
        if type(descriptor)~='table' or type(descriptor.resource)~='string' or
            type(descriptor.fields)~='table' or #descriptor.fields==0 then
            return fail('InvalidRead','target returned no legacy read descriptor')
        end
        local made,job=pcall(runtime.read,{targets={descriptor}})
        if not made or type(job)~='table' or type(job.step)~='function' then
            return fail('ReadFailed',made and 'runtime returned no read job' or job)
        end
        if not registered[owner] then
            local cleanup=core:OnUnload(owner,function()
                self:CancelRead(owner);registered[owner]=nil
            end)
            if not cleanup.ok then return cleanup end
            registered[owner]=true
        end
        local entry={job=job,steps=0}
        jobs[owner]=entry
        local function finish(result)
            self:CancelRead(owner)
            if result.ok then on_result(result.value)
            elseif on_error then on_error(result.error)
            else core.Logger:Emit('warning',owner,'runtime_read_failed',result.error) end
        end
        local subscribed=core.Hooks:Subscribe(owner,'after_update',
            {every_ms=16,budget_us=500,error_policy='disable'},function()
                entry.steps=entry.steps+1
                if entry.steps>10000 then return finish(fail('BudgetExceeded','read step limit reached')) end
                local stepped,done=pcall(entry.job.step)
                if not stepped then return finish(fail('ReadFailed',done)) end
                if entry.job.status=='rejected' then
                    return finish(fail(entry.job.code or 'ReadFailed',entry.job.error))
                end
                if done then
                    if entry.job.status~='complete' then
                        return finish(fail('ReadFailed','read ended without a complete result'))
                    end
                    return finish(Result.ok(entry.job.result))
                end
            end)
        if not subscribed.ok then self:CancelRead(owner);return subscribed end
        entry.token=subscribed.value
        return Result.ok({owner=owner})
    end
    return self
end
return M
