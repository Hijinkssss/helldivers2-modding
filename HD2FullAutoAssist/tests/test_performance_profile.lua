local Profile=require('performance_profile')
local now=0
local p=Profile.new(function()return now end,'unit-fixture')
local started=p:start();now=4;p:finish('native_input_sample',started)
p:observe('native_input_sample',1);p:observe('native_input_sample',25);p:observe('native_input_sample',250)
for _,name in ipairs({'toggle_restore','toggle_cache_invalidation','toggle_followup_first_fire'})do
    p:observe(name,2)
end
assert(not p:sample('memory_page_validation',2))
assert(p:sample('memory_page_validation',2))
local result=p:summary()
local sample=result.phases.native_input_sample
assert(result.label=='unit-fixture' and sample.count==4 and sample.average_us==70)
assert(sample.max_us==250 and sample.p95_upper_bound_us==250 and sample.p99_upper_bound_us==250)
assert(result.counters.memory_page_validation_calls==2 and result.memory_sampling_every==32)
assert(sample.calls_per_second>0 and sample.estimated_total_us_per_second>0)
assert(sample.percent_of_update_wrapper==0,'No wrapper denominator must report zero share')
assert(result.counter_rates.memory_page_validation_calls_per_second>0)
assert(result.phases.memory_page_validation==nil,'Unsampled phases are omitted')
for _,name in ipairs({'toggle_restore','toggle_cache_invalidation','toggle_followup_first_fire'})do
    assert(result.phases[name] and result.phases[name].count==1,'Missing toggle phase '..name)
end
print('test_performance_profile: counters and percentile bounds passed')
