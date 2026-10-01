local Fixture=require('native_transition_fixture')
local Validation=require('validation_trace')
local lines,now={},0
local file={write=function(self,s)lines[#lines+1]=s;return self end,flush=function()return true end,close=function()return true end}
local trace=Validation.new({clock=function()return now end,file=file})
local state={user_enabled=false,weapon={},eligibility={},effective=false}
for _=1,1000 do trace:input({held=true,pressed=true,trigger=2,held_seconds=1},state,false)end
assert(trace.records==3,'Held level produced repeated pulse records')
trace:input({held=false,pressed=false,trigger=2},state,false)
trace:input({held=true,pressed=true,trigger=2},state,false)
local records=trace.records
for _=1,3 do trace:input({held=true,pressed=true,trigger=8},state,true)end
assert(trace.records==records+3,'Native timed pulses were suppressed')
trace:close({})
lines={}
local f=Fixture.new('validation_logging=true\nhud_diagnostics=false',function(options)
    options.file=file;return Validation.new(options)
end)
f:weapon('b6aff2195568767f');f:tick();f:fire(true);f:tick()
assert(f.backend.lease)
f.host.callbacks.toggle.callback();f:input(0,0,false,2);f:tick();f:input(1,.1,true,2)
for _=1,200 do f:tick(250000)end
assert(not f.backend.lease and f:restored())
assert(f.consumer:stop().ok)
local text=table.concat(lines)
assert(text:find('toggle_mapping_audit',1,true) and text:find('mappings_equal_pre_assist',1,true))
local count=0;for _ in text:gmatch('"event":"fire_mapping_audit"')do count=count+1 end
assert(count<=96 and count>10,'Mapping audit budget missing')
print('PASS opt-in OFF trace: level-edge deduplication, timed pulse retention, actual controller audit, restored fresh hold and bounded audit records')
