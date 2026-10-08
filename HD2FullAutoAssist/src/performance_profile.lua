-- Opt-in, in-memory runtime profiling. Summaries are emitted only on unload.
local M={}
local LIMITS={1,2,5,10,25,50,100,250,500,1000,2000,5000,10000,50000}
local NAMES={'callback_fire','callback_identity','callback_toggle','toggle_poll','toggle_restore',
    'toggle_cache_invalidation','toggle_followup_first_fire','update_tick','update_wrapper','hud_present','hud_anchor',
    'hud_owner_check','hud_ammo_row_check','hud_cached_verify','hud_tree_refresh','hud_tree_revalidate',
    'hud_render_update','hud_render_write','hud_state_project',
    'backend_initialize','native_input_sample','input_eligibility','identity_snapshot',
    'policy_resolution','identity_fingerprint','cadence_logic','native_fire_begin','native_fire_refresh',
    'native_fire_restore','memory_page_validation','memory_platform_read','log_io',
    'startup_exe_hash','startup_game_dll_hash'}
function M.new(clock,label)
    assert(type(clock)=='function','Profiler clock required')
    local metrics,counters={},{}
    local profile_started=clock()
    for _,name in ipairs(NAMES)do
        local buckets={};for i=1,#LIMITS+1 do buckets[i]=0 end
        metrics[name]={count=0,total_us=0,max_us=0,buckets=buckets}
    end
    local self={enabled=true,label=label or 'unlabeled',clock='monotonic elapsed time in microseconds',
        memory_samples_every=32}
    function self:start()return clock()end
    function self:finish(name,started)
        if started==nil or started==false then return nil end
        local elapsed=math.max(0,clock()-started)
        self:observe(name,elapsed)
        return elapsed
    end
    function self:observe(name,elapsed)
        local row=assert(metrics[name],'Unknown performance phase: '..tostring(name))
        elapsed=math.max(0,elapsed)
        row.count=row.count+1;row.total_us=row.total_us+elapsed;row.max_us=math.max(row.max_us,elapsed)
        for i,limit in ipairs(LIMITS)do if elapsed<=limit then row.buckets[i]=row.buckets[i]+1;return end end
        row.buckets[#LIMITS+1]=row.buckets[#LIMITS+1]+1
    end
    function self:increment(name,amount)
        counters[name]=(counters[name] or 0)+(amount or 1)
    end
    function self:sample(name,every)
        self:increment(name..'_calls')
        return counters[name..'_calls']%every==0
    end
    function self:summary()
        local phases={}
        for name,row in pairs(metrics)do
            if row.count>0 then
                local function percentile(q)
                    local target=math.ceil(row.count*q);local seen=0
                    for i,n in ipairs(row.buckets)do
                        seen=seen+n
                        if seen>=target then return LIMITS[i] or row.max_us end
                    end
                    return row.max_us
                end
                phases[name]={count=row.count,average_us=row.total_us/row.count,max_us=row.max_us,
                    p95_upper_bound_us=percentile(.95),p99_upper_bound_us=percentile(.99),
                    histogram=row.buckets}
            end
        end
        local duration=math.max(0,clock()-profile_started)
        local update_total=metrics.update_wrapper.total_us
        local update_rate=duration>0 and update_total*1000000/duration or 0
        for name,row in pairs(phases)do
            local metric=metrics[name]
            local calls=counters[name..'_calls'] or row.count
            local rate=duration>0 and calls*1000000/duration or 0
            local average=metric.total_us/metric.count
            row.calls_per_second=rate
            row.average_us=average
            row.measured_total_us=metric.total_us
            row.estimated_total_us_per_second=average*rate
            -- Child phases are nested inside callback/wrapper measurements.
            -- This share is an inclusive comparison against wrapper time and
            -- must not be summed across phases.
            row.percent_of_update_wrapper=update_rate>0 and row.estimated_total_us_per_second*100/update_rate or 0
        end
        local rates={}
        for name,value in pairs(counters)do
            if type(value)=='number' then rates[name..'_per_second']=duration>0 and value*1000000/duration or 0 end
        end
        return {label=self.label,clock=self.clock,profiled_duration_us=duration,
            phases=phases,counters=counters,counter_rates=rates,
            update_wrapper_total_us=update_total,
            memory_sampling_every=self.memory_samples_every}
    end
    return self
end
return M
