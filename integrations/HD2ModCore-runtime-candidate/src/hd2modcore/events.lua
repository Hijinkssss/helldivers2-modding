local Result = require('hd2modcore.result')
local Util = require('hd2modcore.util')

local M = {}
local Events = {}
Events.__index = Events

function M.new(logger)
    return setmetatable({logger=logger, channels={}, subscribers={},
        next_id=1, maximum=64, changes=0, failures=0, dispatching=false}, Events)
end

function Events:compact()
    if self.dispatching then return end
    local kept={}
    for _,row in ipairs(self.subscribers) do
        if row.callback then kept[#kept+1]=row end
    end
    self.subscribers=kept
end

function Events:subscribe(owner, channel, callback)
    self:compact()
    if type(owner)~='string' or not owner:match('^[%w_%-]+$') or
        type(channel)~='string' or not channel:match('^[%w_%.%-]+$') or
        type(callback)~='function' then
        return Result.err('InvalidSubscription','events','invalid subscriber')
    end
    if #self.subscribers>=self.maximum then
        return Result.err('BudgetExceeded','events','subscriber limit')
    end
    local row={id=self.next_id,owner=owner,channel=channel,callback=callback}
    self.next_id=self.next_id+1
    self.subscribers[#self.subscribers+1]=row
    return Result.ok({id=row.id,owner=owner})
end

function Events:remove(token)
    if type(token)~='table' then return false end
    for _,row in ipairs(self.subscribers) do
        if row.id==token.id and row.owner==token.owner then
            row.callback=nil
            self:compact()
            return true
        end
    end
    return false
end

function Events:remove_owner(owner)
    for _,row in ipairs(self.subscribers) do
        if row.owner==owner then row.callback=nil end
    end
    self:compact()
end

-- A producer supplies a stable scalar fingerprint. This does not infer game semantics.
function Events:observe(channel, fingerprint, snapshot)
    if self.dispatching then
        return Result.err('BudgetExceeded','events','recursive event publication')
    end
    if type(channel)~='string' or not channel:match('^[%w_%.%-]+$') or
        (type(fingerprint)~='string' and type(fingerprint)~='number') or
        (type(fingerprint)=='number' and
            (fingerprint~=fingerprint or fingerprint==math.huge or
            fingerprint==-math.huge)) or
        type(snapshot)~='table' then
        return Result.err('InvalidEvent','events','invalid channel, fingerprint or snapshot')
    end
    local copied
    local ok,why=pcall(function()
        copied=Util.copy(snapshot,0,{left=256,bytes=32768,max_depth=8})
    end)
    if not ok then return Result.err('InvalidEvent','events',why) end
    local previous=self.channels[channel]
    if previous and previous.fingerprint==fingerprint then
        return Result.ok({changed=false, current=Util.copy(previous.snapshot)})
    end
    local row={fingerprint=fingerprint,snapshot=copied,
        sequence=previous and previous.sequence+1 or 1}
    self.channels[channel]=row
    self.changes=self.changes+1
    local event={channel=channel,sequence=row.sequence,changed=true,
        current=Util.copy(copied),
        previous=previous and Util.copy(previous.snapshot) or nil}
    self.dispatching=true
    local subscriber_count=#self.subscribers
    for index=1,subscriber_count do
        local subscriber=self.subscribers[index]
        if subscriber.callback and subscriber.channel==channel then
            local called,reason=xpcall(function()
                subscriber.callback(Util.copy(event))
            end,function(err)
                return debug and debug.traceback and debug.traceback(err,2) or tostring(err)
            end)
            if not called then
                self.failures=self.failures+1
                if self.logger then self.logger:emit('error','events','subscriber_failed',
                    {owner=subscriber.owner,reason=reason}) end
            end
        end
    end
    self.dispatching=false
    self:compact()
    return Result.ok(event)
end

function Events:current(channel)
    local row=self.channels[channel]
    if not row then return Result.err('Unavailable','events','no snapshot') end
    return Result.ok({sequence=row.sequence,snapshot=Util.copy(row.snapshot)})
end

function Events:clear()
    for _,subscriber in ipairs(self.subscribers) do subscriber.callback=nil end
    self.subscribers={}
    self.channels={}
end

function Events:status()
    local active=0
    for _,row in ipairs(self.subscribers) do if row.callback then active=active+1 end end
    return {active=active,changes=self.changes,failures=self.failures}
end

return M
