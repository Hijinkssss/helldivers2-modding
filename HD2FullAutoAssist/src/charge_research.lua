-- Developer-only trace; default candidate never instantiates this module.
local Observer=require('charge_observer')
local Signals=require('charge_signals')
local Json=require('validation_trace')
local M={}
M.filename='HD2FullAutoAssist-charge-probe.log' -- Shared Loader API 1 accepts .log only.
function M.new(host,provider,loader)
    local observer=Observer.new(host)
    local signals=Signals.new(host)
    local file=assert(loader.open_log(M.filename),'Charge probe log unavailable: '..M.filename)
    local opened,reason=pcall(function()
        assert(file:write(Json.json({event='research_start',version='1.1.0-research-rc2',
            filename=M.filename,format='json_lines',automatic_charge_fire=false,
            steam_build='25480438',sampling='each_relevant_stock_update',max_samples=6000})..'\n'))
        assert(file:flush())
    end)
    if not opened then pcall(file.close,file);error(reason,0)end
    host:log('info','charge_probe_ready',{filename=M.filename,automatic_charge_fire=false})
    local self={samples=0,observer=observer,signals=signals,closed=false,buffer={},last_flush=host:clock_us()}
    function self:close()
        if self.closed then return end
        -- Always attempt close, including a failed flush/write.
        local ok,why=pcall(function()
            if #self.buffer>0 then assert(file:write(table.concat(self.buffer)));self.buffer={}end
            assert(file:write(Json.json({event='research_end',samples=self.samples})..'\n'))
            assert(file:flush())
        end)
        local closed,reason=pcall(function()assert(file:close())end);self.closed=true
        assert(ok,why);assert(closed,reason)
    end
    function self:tick()
        if self.closed then return end
        local now=host:clock_us()
        if now==self.last_us then return end;self.last_us=now
        local state=provider()
        local row=host:read_scope(function()
            local value=observer:sample(state)
            if value then value.signals=signals:sample(state)end
            return value
        end)
        if row then
            row.event='charge_probe_sample';row.time_us=now;row.assistance_enabled=false
            self.last_identity=row.identity_token
            self.buffer[#self.buffer+1]=Json.json(row)..'\n';self.samples=self.samples+1
        elseif self.last_identity then
            self.buffer[#self.buffer+1]=Json.json({event='charge_probe_boundary',time_us=now,
                previous_identity=self.last_identity,identity_observed=state and state.identity_observed,
                next_weapon=state and state.weapon and state.weapon.resource_hash})..'\n'
            self.last_identity=nil;signals:invalidate()
        end
        if now-self.last_flush>=1000000 and #self.buffer>0 then
            assert(file:write(table.concat(self.buffer)));assert(file:flush());self.buffer={};self.last_flush=now
        end
        if self.samples>=6000 then self:close()end
    end
    return self
end
return M
