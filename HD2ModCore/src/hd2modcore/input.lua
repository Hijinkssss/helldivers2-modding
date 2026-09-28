-- Keyboard press edges only. No game-native action mapping or menu policy.
local Result=require('hd2modcore.result')
local Util=require('hd2modcore.util')
local M={}
local Input={};Input.__index=Input
local NAMED={SPACE=0x20,TAB=9,ENTER=13,ESCAPE=27,INSERT=45,DELETE=46,
    HOME=36,END=35,PAGEUP=33,PAGEDOWN=34,LEFT=37,UP=38,RIGHT=39,DOWN=40}
function M.parse(key)
    if type(key)~='string' then return Result.err('InvalidKey','input','key name required') end
    local name=key:match('^%s*(.-)%s*$'):upper()
    local code=NAMED[name]
    if name:match('^[A-Z0-9]$') then code=name:byte() end
    local f=name:match('^F(%d+)$')
    if f and tonumber(f)>=1 and tonumber(f)<=24 and name=='F'..tonumber(f) then code=111+tonumber(f) end
    local hex=name:match('^VK_(%x%x)$')
    if hex and tonumber(hex,16)>=8 and tonumber(hex,16)<=254 then code=tonumber(hex,16) end
    if not code then return Result.err('InvalidKey','input','use A-Z, 0-9, F1-F24, a named key or VK_XX') end
    return Result.ok(code)
end
function M.new(platform,logger)
    return setmetatable({platform=platform,logger=logger,entries={},keys={},next_id=1,
        active=0,ticks=0,presses=0,failures=0,callback_failures=0,
        tick_us_total=0,tick_us_max=0,dispatching=false},Input)
end
function Input:compact()
    if self.dispatching then return end
    local write=1
    for read=1,#self.entries do
        local row=self.entries[read]
        if row.active then self.entries[write]=row;write=write+1 end
    end
    for i=write,#self.entries do self.entries[i]=nil end
    write=1
    for read=1,#self.keys do
        local row=self.keys[read]
        if row.refs>0 then self.keys[write]=row;write=write+1 end
    end
    for i=write,#self.keys do self.keys[i]=nil end
end
function Input:remove(token)
    if type(token)~='table' then return false end
    for i=1,#self.entries do
        local row=self.entries[i]
        if row.active and row.id==token.id and row.owner==token.owner then
            row.active=false;row.callback=nil;row.key.refs=row.key.refs-1
            self.active=self.active-1;self:compact();return true
        end
    end
    return false
end
function Input:remove_owner(owner)
    for i=#self.entries,1,-1 do
        local row=self.entries[i]
        if row.active and row.owner==owner then self:remove({id=row.id,owner=owner}) end
    end
    self:compact()
end
function Input:clear()
    for i=1,#self.entries do self.entries[i].active=false;self.entries[i].callback=nil end
    for i=1,#self.keys do self.keys[i].refs=0 end
    if not self.dispatching then self.entries={};self.keys={} end
    self.active=0
end
function Input:subscribe(owner,key,options,callback)
    local parsed=M.parse(key)
    if not parsed.ok then return parsed end
    if options==nil then options={} end
    if type(owner)~='string' or not owner:match('^[%w_%-]+$') or type(callback)~='function'
        or type(options)~='table' or not Util.integer(options.debounce_ms or 150,0,2000) then
        return Result.err('InvalidSubscription','input','invalid owner, callback or debounce_ms')
    end
    if self.active>=32 then return Result.err('BudgetExceeded','input','32 subscriptions maximum') end
    if type(self.platform.prepare_input)~='function' then
        return Result.err('Unavailable','input','Windows keyboard adapter unavailable')
    end
    local ok,why=self.platform:prepare_input()
    if not ok then return Result.err('Unavailable','input',why or 'keyboard setup failed') end
    for i=1,#self.entries do
        local row=self.entries[i]
        if row.active and row.owner==owner and row.key.code==parsed.value then
            return Result.err('InvalidSubscription','input','duplicate owner/key')
        end
    end
    local slot
    for i=1,#self.keys do if self.keys[i].code==parsed.value then slot=self.keys[i];break end end
    if not slot then slot={code=parsed.value,refs=0,down=false};self.keys[#self.keys+1]=slot end
    slot.refs=slot.refs+1
    local row={id=self.next_id,owner=owner,key=slot,callback=callback,active=true,
        armed=false,down=false,last_edge=-math.huge,debounce_us=(options.debounce_ms or 150)*1000}
    self.next_id=self.next_id+1;self.active=self.active+1;self.entries[#self.entries+1]=row
    return Result.ok({id=row.id,owner=owner})
end
function Input:tick()
    if self.active==0 or self.dispatching then return end
    local started=self.platform:clock_us()
    self.ticks=self.ticks+1
    local focused=self.platform:input_focused()
    if focused==nil then self.failures=self.failures+1;self:clear();return end
    if not focused then
        for i=1,#self.entries do self.entries[i].armed=false;self.entries[i].down=false end
    else
        for i=1,#self.keys do
            local slot=self.keys[i]
            if slot.refs>0 then
                slot.down=self.platform:input_down(slot.code)
                if slot.down==nil then self.failures=self.failures+1;self:clear();return end
            end
        end
        self.dispatching=true
        local count=#self.entries
        for i=1,count do
            local row=self.entries[i]
            if row.active then
                local down=row.key.down
                if not down then row.armed=true end
                local pressed=down and not row.down and row.armed
                row.down=down
                if pressed then
                    local due=started-row.last_edge>=row.debounce_us
                    row.last_edge=started
                    if due then
                        self.presses=self.presses+1
                        local ok,why=pcall(row.callback)
                        if not ok then
                            self.callback_failures=self.callback_failures+1
                            if self.logger then self.logger:emit('error','input','callback_failed',{owner=row.owner,reason=tostring(why)}) end
                            self:remove({id=row.id,owner=row.owner})
                        end
                    end
                end
            end
        end
        self.dispatching=false;self:compact()
    end
    local elapsed=math.max(0,self.platform:clock_us()-started)
    self.tick_us_total=self.tick_us_total+elapsed
    self.tick_us_max=math.max(self.tick_us_max,elapsed)
end
function Input:status()
    return {active=self.active,ticks=self.ticks,presses=self.presses,failures=self.failures,
        callback_failures=self.callback_failures,tick_us_total=self.tick_us_total,tick_us_max=self.tick_us_max}
end
return M
