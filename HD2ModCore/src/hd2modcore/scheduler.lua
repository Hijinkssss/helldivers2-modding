local Result = require('hd2modcore.result')
local Util = require('hd2modcore.util')

local M = {}
local Scheduler = {}
Scheduler.__index = Scheduler
local PHASE = {before_update=true, after_update=true}

function M.new(clock_us, logger)
    assert(type(clock_us)=='function', 'monotonic clock required')
    return setmetatable({clock=clock_us, logger=logger, entries={}, next_id=1,
        maximum=64, dispatching=false, cursor=1, ticks=0, callbacks=0,
        failures=0, slow=0, skipped=0, callback_us_total=0,
        callback_us_max=0, global_budget_us=2000}, Scheduler)
end

function Scheduler:compact()
    if self.dispatching then return end
    local kept={}
    for _,entry in ipairs(self.entries) do
        if entry.active then kept[#kept+1]=entry end
    end
    self.entries=kept
    if self.cursor>#kept then self.cursor=1 end
end

function Scheduler:subscribe(owner, phase, options, callback)
    self:compact()
    if type(owner)~='string' or not owner:match('^[%w_%-]+$') or
        not PHASE[phase] or type(callback)~='function' or type(options)~='table' or
        not Util.integer(options.every_ms or 0,0,60000) or
        not Util.integer(options.budget_us or 500,1,100000) or
        (options.error_policy and options.error_policy~='disable' and
            options.error_policy~='retry') or
        not Util.integer(options.max_errors or 1,1,100) or
        not Util.integer(options.backoff_ms or 1000,0,60000) then
        return Result.err('InvalidSubscription','scheduler','invalid arguments')
    end
    if #self.entries >= self.maximum then
        return Result.err('BudgetExceeded','scheduler','subscription limit')
    end
    local entry={id=self.next_id,owner=owner,phase=phase,callback=callback,
        every_us=(options.every_ms or 0)*1000,
        budget_us=options.budget_us or 500,
        error_policy=options.error_policy or 'disable',
        max_errors=options.max_errors or 1,
        backoff_us=(options.backoff_ms or 1000)*1000,
        errors=0, slow=0, calls=0, next_due=0, active=true}
    self.next_id=self.next_id+1
    self.entries[#self.entries+1]=entry
    return Result.ok({id=entry.id, owner=owner})
end

function Scheduler:remove(token)
    if type(token)~='table' then return false end
    for _, entry in ipairs(self.entries) do
        if entry.id==token.id and entry.owner==token.owner then
            entry.active=false
            entry.callback=nil
            self:compact()
            return true
        end
    end
    return false
end

function Scheduler:remove_owner(owner)
    for _,entry in ipairs(self.entries) do
        if entry.owner==owner then entry.active=false;entry.callback=nil end
    end
    self:compact()
end

function Scheduler:tick(phase, ...)
    if not PHASE[phase] or self.dispatching then return false end
    self.dispatching=true
    self.ticks=self.ticks+1
    local args=Util.pack(...)
    local started=self.clock()
    local count=#self.entries
    local index=self.cursor
    if index>count then index=1 end
    for _=1,count do
        if self.clock()-started>=self.global_budget_us then
            self.skipped=self.skipped+1
            break
        end
        local entry=self.entries[index]
        if entry and entry.active and entry.phase==phase and
            self.clock()>=entry.next_due then
            local begin=self.clock()
            local ok,why=xpcall(function()
                entry.callback(Util.unpack(args))
            end, function(err)
                return debug and debug.traceback and debug.traceback(err,2) or tostring(err)
            end)
            local finished=self.clock()
            local elapsed=math.max(0,finished-begin)
            entry.calls=entry.calls+1
            self.callbacks=self.callbacks+1
            self.callback_us_total=self.callback_us_total+elapsed
            self.callback_us_max=math.max(self.callback_us_max,elapsed)
            entry.next_due=finished+entry.every_us
            if elapsed>entry.budget_us then
                entry.slow=entry.slow+1;self.slow=self.slow+1
                if self.logger and (entry.slow==1 or entry.slow%100==0) then
                    self.logger:emit('warning','scheduler','slow_callback',
                        {owner=entry.owner,elapsed_us=elapsed})
                end
            end
            if not ok then
                entry.errors=entry.errors+1;self.failures=self.failures+1
                if self.logger then
                    self.logger:emit('error','scheduler','callback_failed',
                        {owner=entry.owner,reason=why})
                end
                if entry.error_policy=='disable' or entry.errors>=entry.max_errors then
                    entry.active=false;entry.callback=nil
                else
                    entry.next_due=finished+entry.backoff_us
                end
            end
        end
        index=index%math.max(count,1)+1
        self.cursor=index
    end
    self.dispatching=false
    self:compact()
    return true
end

function Scheduler:clear()
    for _,entry in ipairs(self.entries) do entry.active=false;entry.callback=nil end
    self.entries={}
    self.cursor=1
end

function Scheduler:status()
    local active=0
    for _,entry in ipairs(self.entries) do if entry.active then active=active+1 end end
    return {active=active,ticks=self.ticks,callbacks=self.callbacks,
        failures=self.failures,slow=self.slow,skipped=self.skipped,
        callback_us_total=self.callback_us_total,
        callback_us_max=self.callback_us_max}
end

return M
