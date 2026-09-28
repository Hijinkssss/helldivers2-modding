local Result = require('hd2modcore.result')

local M = {}
local Lifecycle = {}
Lifecycle.__index = Lifecycle

function M.new(diagnostics, logger)
    return setmetatable({diagnostics=diagnostics,logger=logger,state='uninitialized',
        cleanup={},degraded=false},Lifecycle)
end

function Lifecycle:begin()
    if self.state~='uninitialized' then
        return Result.err('InvalidState','lifecycle','already initialized')
    end
    self.state='initializing';self.diagnostics.state=self.state
    return Result.ok(true)
end

function Lifecycle:stage(name, required, initialize, cleanup)
    if self.state~='initializing' then
        return Result.err('InvalidState',name,'not initializing')
    end
    self.diagnostics:module(name,'initializing')
    if self.logger then self.logger:emit('info','lifecycle','stage_start',{module=name}) end
    local ok,value=pcall(initialize)
    if not ok or value==false or value==nil then
        local reason=ok and 'stage returned no success' or tostring(value)
        self.diagnostics:module(name,required and 'failed' or 'disabled',reason)
        self.diagnostics:error('InitializationFailed',name,reason)
        if self.logger then
            self.logger:emit(required and 'fatal' or 'warning','lifecycle',
                'stage_failed',{module=name,reason=reason})
        end
        if required then
            self.state='failed';self.diagnostics.state='failed'
            self:rollback()
        else self.degraded=true end
        return Result.err('InitializationFailed',name,reason)
    end
    self.diagnostics:module(name,'active')
    self.cleanup[#self.cleanup+1]={name=name,run=cleanup}
    if self.logger then self.logger:emit('info','lifecycle','stage_ready',{module=name}) end
    return Result.ok(value)
end

function Lifecycle:finish()
    if self.state~='initializing' then
        return Result.err('InvalidState','lifecycle','initialization not active')
    end
    self.state=self.degraded and 'degraded' or 'running'
    self.diagnostics.state=self.state
    return Result.ok(self.state)
end

function Lifecycle:rollback()
    for index=#self.cleanup,1,-1 do
        local row=self.cleanup[index]
        if row.run then
            local ok,reason=pcall(row.run)
            if not ok then
                self.diagnostics:module(row.name,'cleanup_failed',tostring(reason))
                self.diagnostics:error('CleanupFailed',row.name,reason)
            else self.diagnostics:module(row.name,'stopped') end
        else self.diagnostics:module(row.name,'stopped') end
    end
    self.cleanup={}
end

function Lifecycle:shutdown()
    if self.state=='stopped' then return Result.ok(true) end
    if self.state=='shutting_down' then
        return Result.err('InvalidState','lifecycle','shutdown reentered')
    end
    if self.state~='running' and self.state~='degraded' and self.state~='failed' then
        return Result.err('InvalidState','lifecycle','not running')
    end
    self.state='shutting_down';self.diagnostics.state=self.state
    self:rollback()
    local failure=self.diagnostics.recent_error
    self.state='stopped';self.diagnostics.state=self.state
    if failure and failure.code=='CleanupFailed' then
        return Result.err('CleanupFailed','lifecycle',failure.detail)
    end
    return Result.ok(true)
end

return M
