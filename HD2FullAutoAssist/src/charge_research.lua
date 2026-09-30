-- Developer-only trace; default candidate never instantiates this module.
local Observer=require('charge_observer')
local Signals=require('charge_signals')
local Json=require('validation_trace')
local Targets=require('charge_probe_targets')
local M={}
M.filename='HD2FullAutoAssist-charge-probe.log' -- Shared Loader API 1 accepts .log only.
M.max_samples=6000
function M.new(host,provider,loader)
    local observer=Observer.new(host)
    local signals=Signals.new(host)
    local file=assert(loader.open_log(M.filename),'Charge probe log unavailable: '..M.filename)
    local opened,reason=pcall(function()
        assert(file:write(Json.json({event='research_start',version='1.1.0-research-rc3',
            filename=M.filename,format='json_lines',automatic_charge_fire=false,
            steam_build='25480438',sampling='each_relevant_stock_update',max_samples=M.max_samples,
            targets=Targets.names})..'\n'))
        assert(file:flush())
    end)
    if not opened then pcall(file.close,file);error(reason,0)end
    host:log('info','charge_probe_ready',{filename=M.filename,automatic_charge_fire=false,targets=Targets.names})
    local self={samples=0,samples_by_weapon={},seen={},observer=observer,signals=signals,
        closed=false,buffer={},last_flush=host:clock_us()}
    function self:close(reason)
        if self.closed then return end
        -- Always attempt close, including a failed flush/write.
        local ok,why=pcall(function()
            if #self.buffer>0 then assert(file:write(table.concat(self.buffer)));self.buffer={}end
            assert(file:write(Json.json({event='research_end',samples=self.samples,
                samples_by_weapon=self.samples_by_weapon,reason=reason or 'shutdown',
                sample_limit_hit=self.samples>=M.max_samples})..'\n'))
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
            local hash=row.resource_hash or (state and state.weapon and state.weapon.resource_hash)
            row.resource_hash=hash
            if hash and Targets.names[hash] and not self.seen[hash] then
                self.seen[hash]=true
                local recognised={name=Targets.names[hash],resource_hash=hash,state=row.state}
                host:log('info','charge_probe_target_seen',recognised)
                recognised.event='charge_probe_target_seen';recognised.time_us=now
                self.buffer[#self.buffer+1]=Json.json(recognised)..'\n'
            end
            row.event='charge_probe_sample';row.time_us=now;row.assistance_enabled=false
            self.last_identity=row.identity_token
            self.buffer[#self.buffer+1]=Json.json(row)..'\n';self.samples=self.samples+1
            local name=row.name or 'unlabelled'
            self.samples_by_weapon[name]=(self.samples_by_weapon[name] or 0)+1
        elseif self.last_identity then
            self.buffer[#self.buffer+1]=Json.json({event='charge_probe_boundary',time_us=now,
                previous_identity=self.last_identity,identity_observed=state and state.identity_observed,
                next_weapon=state and state.weapon and state.weapon.resource_hash})..'\n'
            self.last_identity=nil;signals:invalidate()
        end
        if now-self.last_flush>=1000000 and #self.buffer>0 then
            assert(file:write(table.concat(self.buffer)));assert(file:flush());self.buffer={};self.last_flush=now
        end
        if self.samples>=M.max_samples then self:close('sample_limit')end
    end
    return self
end
return M
