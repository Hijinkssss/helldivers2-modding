local Profile=require('performance_profile')
local now=0
local p=Profile.new(function()return now end,'unit-fixture')
local started=p:start();now=4;p:finish('native_input_sample',started)
p:observe('native_input_sample',1);p:observe('native_input_sample',25);p:observe('native_input_sample',250)
assert(not p:sample('memory_page_validation',2))
assert(p:sample('memory_page_validation',2))
local result=p:summary()
local sample=result.phases.native_input_sample
assert(result.label=='unit-fixture' and sample.count==4 and sample.average_us==70)
assert(sample.max_us==250 and sample.p95_upper_bound_us==250 and sample.p99_upper_bound_us==250)
assert(result.counters.memory_page_validation_calls==2 and result.memory_sampling_every==32)
assert(result.phases.memory_page_validation==nil,'Unsampled phases are omitted')
print('test_performance_profile: counters and percentile bounds passed')
