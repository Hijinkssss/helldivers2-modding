local Fixture=require('native_transition_fixture')
local function arm(f)f:fire(true);f:tick();assert(f.backend.lease)end
local f=Fixture.new();arm(f)
local original_header=f:bytes(f.CONTROLS+0xa7ad0,20)
local lease=f.backend.lease;local writes=f.writes
-- A header edit alone must not make the outstanding modified rows disappear.
f:put(f.CONTROLS+0xa7ad0+16,f.u32(2))
local clean,reason=f.backend:restore()
assert(not clean and reason=='binding_context_changed')
assert(f.backend.lease==lease and f.writes==writes,'Lost originals or wrote through changed context')
f:put(f.CONTROLS+0xa7ad0,original_header)
assert(f.backend:restore() and f:restored() and not f.backend.lease)
assert(f.consumer:stop().ok)
-- Actual OFF callback must reject unsuccessful restoration and retain recovery.
f=Fixture.new();arm(f);original_header=f:bytes(f.CONTROLS+0xa7ad0,20)
f:put(f.CONTROLS+0xa7ad0+16,f.u32(2))
f.host.callbacks.toggle.callback()
assert(f.consumer:status().failed and not f.consumer:status().active)
assert(f.backend.lease and not f:restored())
local count=0
for _,line in ipairs(f.logs)do if line:find('restore_failed',1,true)then count=count+1 end end
for _=1,100 do f:tick()end
local after=0
for _,line in ipairs(f.logs)do if line:find('restore_failed',1,true)then after=after+1 end end
assert(after==count,'Unresolved restore floods synchronous diagnostics')
f:put(f.CONTROLS+0xa7ad0,original_header);f:tick()
assert(f:restored() and not f.backend.lease and not f.consumer:status().active)
assert(f.consumer:stop().ok)
-- An external edit remains untouched, but saved originals are retained until
-- every owned row is positively verified original; the controller fails closed.
f=Fixture.new();arm(f);lease=f.backend.lease
local edited=f.original:sub(1,4)..'\2\0\0\0'..f.original:sub(9)
f:put(f.BUCKET+8,edited)
clean,reason=f.backend:restore()
assert(not clean and f.backend.lease==lease and f:bytes(f.BUCKET+8,20)==edited)
f:put(f.BUCKET+8,f.original)
assert(f.backend:restore() and f:restored() and not f.backend.lease)
assert(f.consumer:stop().ok)
print('PASS restoration ownership: changed context retained, OFF failure rejected, bounded retry logs, exact retry recovery and external edits preserved')
