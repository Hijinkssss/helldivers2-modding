-- Actual Core facade; no game access.
local Entry=require('hd2modcore.entry')
local profile=require('hd2modcore.example_profile')
local env={update=function()end,shutdown=function()end}
local bytes='old!'
local platform={clock_us=function()return 0 end,
    query_region=function()return {base=0x10000,size=4096,state=0x1000,protect=4}end,
    read=function()return bytes end,
    module_hash=function(_,name)return name and profile.identity.dll_sha256 or profile.identity.exe_sha256 end,
    prepare_input=function()return true end,input_focused=function()return true end,input_down=function()return false end}
local loader={api=1,open_log=function()return {write=function()end,flush=function()end,close=function()end}end}
local core=assert(Entry.install(env,{platform=platform,loader=loader,config_text=''}))
local before=core.Diagnostics:Status().memory
local result=core.Memory:WithReadScope(function()
    assert(core.Memory:Read(0x10000,4).value=='old!');bytes='new!'
    assert(core.Memory:Read(0x10000,4).value=='new!')
    assert(core.Memory:WithReadScope(function()return core.Memory:Read(0x10000,4).ok end).value[1])
    return nil,'axis',false
end)
assert(result.ok and result.value.n==3 and result.value[1]==nil and result.value[2]=='axis' and result.value[3]==false)
local after=core.Diagnostics:Status().memory
assert(after.queries-before.queries==1 and after.native_reads-before.native_reads==3)
assert(core.Memory:Read(0x10000,4).ok and core.Diagnostics:Status().memory.queries==after.queries+1)
assert(core.Memory:WithReadScope(function()error('fixture abort')end).error.code=='ReadScopeFailed')
local queries=core.Diagnostics:Status().memory.queries
assert(core.Memory:Read(0x10000,4).ok and core.Diagnostics:Status().memory.queries==queries+1)
assert(core.Memory:WithReadScope(nil).error.code=='InvalidRead')
local thread=coroutine.create(function()return core.Memory:WithReadScope(function()error('No yielding scope')end)end)
local resumed,rejected=coroutine.resume(thread);assert(resumed and rejected.error.code=='InvalidRead')
env.shutdown();assert(core.Memory:WithReadScope(function()error('Stopped scope')end).error.code=='InvalidState')
