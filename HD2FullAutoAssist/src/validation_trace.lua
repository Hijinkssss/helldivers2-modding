-- Local validation only. Bounded buffering; no extra scheduler subscriptions.
local M={}
local bounds={25,50,100,250,500,1000,1500,2000,3000,5000,10000,20000,100000,1000000}
local function quote(value)
    return '"'..value:gsub('[%z\1-\31\\"]',function(c)
        return string.format('\\u%04x',c:byte()) end)..'"'
end
local function json(value)
    local kind=type(value)
    if kind=='nil' then return 'null' end
    if kind=='boolean' then return value and 'true' or 'false' end
    if kind=='number' then
        if value~=value or value==math.huge or value==-math.huge then return 'null' end
        return string.format('%.17g',value)
    end
    if kind=='string' then return quote(value) end
    assert(kind=='table','Unsupported validation value')
    local keys={};for key in pairs(value)do keys[#keys+1]=key end
    table.sort(keys,function(a,b)return tostring(a)<tostring(b)end)
    local parts={};for _,key in ipairs(keys)do parts[#parts+1]=quote(tostring(key))..':'..json(value[key]) end
    return '{'..table.concat(parts,',')..'}'
end
M.json=json
function M.new(options)
    local clock=assert(options.clock)
    local file=options.file or assert(io.open(assert(os.getenv('LOCALAPPDATA'))..
        '/CowboyBingus/Helldivers2/Logs/HD2FullAutoAssistValidation.jsonl','wb'))
    local pending,metrics={},{}
    local sequence,last_flush,closed,last_state,last_input=0,clock(),false,nil,nil
    local run_id=os.date('!%Y%m%dT%H%M%SZ')..'-'..string.format('%.0f',clock())
    local self={errors=0,dropped=0,records=0}
    function self:cost(name,us)
        us=math.max(0,us)
        local m=metrics[name]
        if not m then m={count=0,total_us=0,max_us=0,buckets={}};metrics[name]=m end
        m.count=m.count+1;m.total_us=m.total_us+us;m.max_us=math.max(m.max_us,us)
        local bucket=#bounds+1;for i,limit in ipairs(bounds)do if us<=limit then bucket=i;break end end
        m.buckets[bucket]=(m.buckets[bucket] or 0)+1
    end
    function self:record(event,fields)
        if closed then return end
        if #pending>=4096 then self.dropped=self.dropped+1;return end
        sequence=sequence+1
        pending[#pending+1]=json({schema=1,run_id=run_id,sequence=sequence,t_us=clock(),event=event,fields=fields or {}})..'\n'
        self.records=self.records+1
    end
    function self:flush(force)
        if closed or (not force and clock()-last_flush<1000000) then return end
        local started=clock()
        if #pending>0 then
            local ok=pcall(function()assert(file:write(table.concat(pending)));assert(file:flush())end)
            if not ok then self.errors=self.errors+1 end
            pending={}
        end
        last_flush=clock();self:cost('trace_flush',last_flush-started)
    end
    function self:state(current,reason)
        -- Revision is intentionally excluded: repeated invalid snapshots remain one state window.
        local copy={user_enabled=current.user_enabled,weapon=current.weapon,eligibility=current.eligibility,
            identity_valid=current.identity_valid,identity_observed=current.identity_observed,
            effective=current.effective,repeat_active=current.repeat_active,reason=current.reason}
        local fingerprint=json(copy)
        if fingerprint~=last_state then last_state=fingerprint;self:record('state',{state=copy,cause=reason})end
    end
    function self:input(row,current,lease)
        local held=row and row.held or false
        local physical=row and row.raw_lmb_down
        local key=tostring(row~=nil)..':'..tostring(held)..':'..tostring(physical)
        if key~=last_input then
            last_input=key
            self:record('input_edge',{available=row~=nil,native_held=held,raw_lmb_down=physical,
                physical_binding_verified=false,state=current,lease_active=lease})
        end
        if row and row.pressed then
            self:record('fire_observed',{native_held=held,trigger=row.trigger,held_seconds=row.held_seconds,
                lease_active=lease,state=current,observation='native_input_sample_not_shot'})
        end
    end
    function self:summary(extra)
        local result={}
        for name,m in pairs(metrics)do
            local total,upper=0,nil
            for i=1,#bounds+1 do
                total=total+(m.buckets[i] or 0)
                if total>=math.ceil(m.count*.95) then upper=bounds[i] or m.max_us;break end
            end
            result[name]={count=m.count,mean_us=m.total_us/m.count,max_us=m.max_us,
                p95_upper_bound_us=upper,histogram=m.buckets}
        end
        self:record('metrics',{costs=result,diagnostics=extra,trace_errors=self.errors,dropped=self.dropped})
    end
    function self:close(extra)
        if closed then return end
        self:summary(extra);self:record('trace_closed',{trace_errors=self.errors,dropped=self.dropped})
        self:flush(true);closed=true
        local ok=pcall(function()assert(file:close())end);if not ok then self.errors=self.errors+1 end
    end
    self:record('trace_started',{version='0.1.1-selective-live-validation',utc=os.date('!%Y-%m-%dT%H:%M:%SZ'),
        timing='in_process_monotonic_us',shot_count_observed=false,physical_binding_verified=false})
    self:flush(true)
    return self
end
return M
