-- Evidence collection must remain useful with assist OFF, and clean up without extra jobs.
local Validation=require('validation_trace')
trace_lines={}
local file={write=function(self,text)trace_lines[#trace_lines+1]=text;return self end,
    flush=function()return true end,close=function()trace_closed=true;return true end}
local function factory(options)options.file=file;return Validation.new(options)end
a=app.install(core,function()return backend end,function()
    return 'user_enabled=false\nvalidation_logging=true' end,factory)
tick(0,false);assert(not a:get_state().effective and a:get_state().identity_valid)
fire=true;tick(20);fire=false;tick(40)
assert(backend.starts==0 and backend.writes==0)
tick(200,true);fire=false;tick(220);fire=true;tick(240)
assert(backend.lease and a:get_state().effective)
bridge.Status=function()return {state='unavailable'}end
tick(260);assert(not backend.lease and not a:get_state().effective,'Disconnect restores on next observed update')
tick(1400);shutdown();assert(trace_closed)
local lines=table.concat(trace_lines)
assert(lines:find('"event":"fire_observed"',1,true))
assert(lines:find('"event":"lease_acquired"',1,true))
assert(lines:find('"event":"lease_released"',1,true))
assert(lines:find('"runtime_connection_invalid"',1,true))
assert(lines:find('"callback"',1,true) and lines:find('"trace_closed"',1,true))
local diagnostics=core.Diagnostics:Status()
assert(diagnostics.scheduler.active==0 and diagnostics.scheduler.failures==0)
assert(Validation.json({control='a\n"b\\c',bool=false}):find('\\u000a',1,true))
