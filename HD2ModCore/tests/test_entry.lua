local Entry=require('hd2modcore.entry')
local profile=require('hd2modcore.example_profile')
local files={}
local loader={api=1,open_log=function(name)
    files[name]=''
    return {write=function(self,value)files[name]=files[name]..value;return self end,
        close=function()return true end,flush=function()return true end}
end}
local now=0
local platform={
    clock_us=function()now=now+1;return now end,
    module_hash=function(self,name)
        return name and profile.identity.dll_sha256 or profile.identity.exe_sha256
    end,
    query_region=function()return {base=0x10000,size=4096,
        state=0x1000,protect=4}end,
    read=function()return 'ABCD' end,
    read_config=function()return '' end
}
local order={}
local original_update=function(a,b)
    order[#order+1]='game'
    return a,nil,b
end
local env={update=original_update,shutdown=function()order[#order+1]='game_shutdown'end}
local core,why=Entry.install(env,{loader=loader,platform=platform,
    config_text='log_level=debug\ndiagnostics=true\n',profiles={profile}})
assert(core,why and why.error and why.error.detail)
assert(core:State()=='degraded') -- exact source-only profile is not runtime validation
assert(Entry.install(env,{loader=loader,platform=platform})==core)
local before=core.Hooks:Subscribe('test','before_update',{},function()
    order[#order+1]='before'
end)
local after=core.Hooks:Subscribe('test','after_update',{},function()
    order[#order+1]='after'
end)
assert(before.ok and after.ok)
local a,b,c=env.update('A','C')
assert(a=='A' and b==nil and c=='C')
assert(table.concat(order,',')=='before,game,after')
assert(core.Memory:Read(0x10000,4).ok)
assert(core.Events:Observe('fixture','1',{value=1}).ok)
local seen=0
assert(core.Events:Subscribe('test','fixture',function()seen=seen+1 end).ok)
assert(core.Events:Observe('fixture','2',{value=2}).ok and seen==1)
local unloaded=0
assert(core:OnUnload('test',function()unloaded=unloaded+1 end).ok)
assert(core:Shutdown().ok)
assert(unloaded==1 and core:State()=='stopped')
assert(core.Diagnostics:Status().modules.test.state=='stopped')
assert(files['HD2ModCoreStatus.log']:find('module.test=stopped',1,true))
for _,name in ipairs({'platform','logger','config','profiles','memory',
    'symbols','game_state','scheduler','events','callbacks'}) do
    assert(core.Diagnostics:Status().modules[name].state=='stopped')
    assert(files['HD2ModCoreStatus.log']:find('module.'..name..'=stopped',1,true))
end
assert(env.update==original_update)
assert(files['HD2ModCoreStatus.log']:find('state=stopped',1,true))
assert(files['HD2ModCoreStatus.log']:find('scheduler.active=0',1,true))
assert(files['HD2ModCoreStatus.log']:find('events.active=0',1,true))
assert(core.Diagnostics:Status().scheduler.active==0)
assert(core.Memory:Read(0x10000,4).error.code=='InvalidState')
assert(core.Memory:ReadU32(0x10000).error.code=='InvalidState')
assert(core.Memory:ReadPointer(0x10000).error.code=='InvalidState')
assert(core.Symbols:Resolve('player_manager').error.code=='InvalidState')
assert(core.Diagnostic:LocalAvatar().error.code=='InvalidState')
assert(core.Hooks:Subscribe('test','before_update',{},function()end).error.code=='InvalidState')
assert(core.Events:Subscribe('test','fixture',function()end).error.code=='InvalidState')
assert(core.Events:Observe('fixture','3',{value=3}).error.code=='InvalidState')
assert(core:OnUnload('test',function()end).error.code=='InvalidState')
assert(core.Config:Register('later',{}).error.code=='InvalidState')
assert(core.Config:Load('core','').error.code=='InvalidState')
assert(not core.Logger:Emit('info','test','after_stop'))

local quiet_env={update=function()end}
files['HD2ModCoreStatus.log']=nil
local quiet=assert(Entry.install(quiet_env,{loader=loader,platform=platform,
    config_text='diagnostics=false\n',profiles={profile}}))
assert(files['HD2ModCoreStatus.log']==nil)
assert(quiet:Shutdown().ok)
assert(files['HD2ModCoreStatus.log']==nil)

local reentrant_env={update=function()end}
local reentrant_core=assert(Entry.install(reentrant_env,{loader=loader,platform=platform,
    profiles={profile}}))
local reentry
assert(reentrant_core:OnUnload('test',function()
    reentry=reentrant_core:Shutdown()
end).ok)
assert(reentrant_core:Shutdown().ok)
assert(reentry.error.code=='InvalidState')

local consumer_env={update=function()end}
local consumer_core=assert(Entry.install(consumer_env,{loader=loader,platform=platform,
    profiles={profile}}))
assert(consumer_core:OnLoad('no_unload',function()end).ok)
assert(consumer_core:Shutdown().ok)
assert(consumer_core.Diagnostics:Status().modules.no_unload.state=='stopped')

local cleanup_env={update=function()end}
local cleanup_core=assert(Entry.install(cleanup_env,{loader=loader,platform=platform,
    profiles={profile}}))
assert(cleanup_core:OnLoad('cleanup_error',function()end).ok)
assert(cleanup_core:OnUnload('cleanup_error',function()end).ok)
assert(cleanup_core:OnUnload('cleanup_error',function()error('expected cleanup error')end).ok)
assert(cleanup_core:Shutdown().error.code=='CleanupFailed')
assert(cleanup_core.Diagnostics:Status().modules.cleanup_error.state=='cleanup_failed')
assert(files['HD2ModCoreStatus.log']:find('module.cleanup_error=cleanup_failed',1,true))

local bad_env={update=function()end}
local bad,failed=Entry.install(bad_env,{loader=loader,platform={}})
assert(not bad and failed.error.code=='InitializationFailed')
assert(bad_env.update~=nil and bad_env.HD2ModCore==nil)

local changed_env={update=function()end}
local changed_callback=function()end
local changing_platform={
    clock_us=platform.clock_us,read=platform.read,query_region=platform.query_region,
    module_hash=function(self,name)
        changed_env.update=changed_callback
        return name and profile.identity.dll_sha256 or profile.identity.exe_sha256
    end
}
local partial,partial_reason=Entry.install(changed_env,{loader=loader,
    platform=changing_platform,profiles={profile}})
assert(not partial and partial_reason.error.stage=='callbacks')
assert(changed_env.update==changed_callback and changed_env.HD2ModCore==nil)

local unknown_profile={
    schema=1,id='unknown',evidence='source_only',
    identity={exe_sha256=string.rep('0',64),dll_sha256=string.rep('1',64)},
    symbols={},capabilities={}
}
local unknown_env={update=function()end}
local unknown=assert(Entry.install(unknown_env,{loader=loader,platform=platform,
    profiles={unknown_profile}}))
assert(unknown:State()=='degraded')
assert(not unknown.Memory:Read(0x10000,4).ok)
assert(unknown.Symbols:Resolve('player_manager').error.code=='UnsupportedBuild')
assert(unknown.Diagnostic:LocalAvatar().error.code=='UnsupportedBuild')
assert(unknown.Diagnostics:Status().profile.state=='unsupported')
unknown:Shutdown()

local failure_env={update=function()error('game failed')end}
local failed_core=assert(Entry.install(failure_env,{loader=loader,platform=platform,
    profiles={profile}}))
local ok,error_text=pcall(failure_env.update)
assert(not ok and tostring(error_text):find('game failed',1,true))
assert(failed_core:State()=='stopped')

print('entry: lifecycle, ordering, errors, unknown build and cleanup OK')
