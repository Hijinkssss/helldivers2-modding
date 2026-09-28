local Config=require('hd2modcore.config')
local Profiles=require('hd2modcore.profiles')
local Scheduler=require('hd2modcore.scheduler')
local Events=require('hd2modcore.events')
local Logger=require('hd2modcore.logger')
local Diagnostics=require('hd2modcore.diagnostics')

local config=Config.new()
assert(config:register('core',{enabled={type='boolean',default=true},
    level={type='enum',values={'info','debug'},default='info'},
    maximum={type='integer',min=1,max=9,default=3}}).ok)
assert(config:load('core','enabled=false\nlevel=debug\nmaximum=8\n').ok)
assert(config:get('core','enabled').value==false)
assert(config:get('core','maximum').value==8)
local invalid=config:load('core','maximum=10\nunknown=1\n')
assert(not invalid.ok and invalid.error.code=='InvalidConfig')
assert(config:get('core','maximum').value==8) -- atomic failure
assert(not config:load('core','maximum=1\nmaximum=2\n').ok)
assert(not config:load('core','not an entry').ok)

local profile=require('hd2modcore.example_profile')
local registry=Profiles.new({profile})
local selected=registry:select({exe_sha256=profile.identity.exe_sha256,
    dll_sha256=profile.identity.dll_sha256})
assert(selected.ok and registry:status().state=='source_known')
assert(not registry:select({exe_sha256=string.rep('0',64),
    dll_sha256=profile.identity.dll_sha256}).ok)
assert(registry:status().state=='unsupported')
assert(not pcall(function() Profiles.new({profile,profile}) end))

local files={}
local loader={open_log=function(name)
    files[name]=''
    return {write=function(self,value) files[name]=files[name]..value;return self end,
        close=function()return true end,flush=function()return true end}
end}
local now=0
local logger=Logger.new(loader,function()return now/1000 end,'debug')
logger:emit('info','test','started',{detail='a\nb'})
assert(files.HD2ModCoreEvents_log==nil)
assert(files['HD2ModCoreEvents.log']:find('detail=a b',1,true))
assert(logger:status_snapshot('state=running\n'))
assert(files['HD2ModCoreStatus.log']=='state=running\n')
assert(logger:status_snapshot('state=stopped\n'))
assert(files['HD2ModCoreStatus.log']=='state=stopped\n')

local scheduler=Scheduler.new(function()return now end,logger)
local calls={}
local a=scheduler:subscribe('alpha','before_update',{every_ms=10,budget_us=50},
    function()calls[#calls+1]='a';now=now+75 end)
assert(a.ok)
local b=scheduler:subscribe('beta','before_update',{every_ms=0},
    function()error('broken subscriber') end)
assert(b.ok)
assert(scheduler:tick('before_update'))
assert(#calls==1 and scheduler:status().failures==1 and scheduler:status().slow==1)
assert(scheduler:status().callback_us_max==75)
assert(scheduler:status().callback_us_total==75)
assert(scheduler:status().active==1)
assert(scheduler:tick('before_update')) -- a is not due yet
assert(#calls==1)
now=now+10000
assert(scheduler:tick('before_update'))
assert(#calls==2)
assert(scheduler:status().callback_us_total==150)
assert(scheduler:remove(a.value))
assert(scheduler:status().active==0)
for i=1,100 do
    local token=scheduler:subscribe('short','after_update',{},function()end)
    assert(token.ok)
    assert(scheduler:remove(token.value))
end

local events=Events.new(logger)
local received=0
local token=events:subscribe('owner','scene',function(event)
    received=received+1
    event.current.id=999
end)
assert(token.ok)
local first=events:observe('scene','id:1',{id=1})
assert(first.ok and first.value.changed and received==1)
local unchanged=events:observe('scene','id:1',{id=1})
assert(unchanged.ok and not unchanged.value.changed and received==1)
assert(events:current('scene').value.snapshot.id==1)
assert(events:observe('scene','id:2',{id=2}).value.previous.id==1)
assert(received==2)
assert(events:remove(token.value))
assert(events:observe('scene','id:3',{id=3}).ok and received==2)
assert(not events:observe('scene','bad',{pointer=function()end}).ok)
local recursive
assert(events:subscribe('owner','recursive',function()
    recursive=events:observe('recursive','again',{id=2})
end).ok)
assert(events:observe('recursive','first',{id=1}).ok)
assert(recursive.error.code=='BudgetExceeded')
local new_calls=0
assert(events:subscribe('owner','late',function()
    local added=events:subscribe('owner','late',function()new_calls=new_calls+1 end)
    assert(added.ok)
end).ok)
assert(events:observe('late','one',{id=1}).ok)
assert(new_calls==0)
assert(events:observe('late','two',{id=2}).ok)
assert(new_calls==1)
local large={}
for i=1,256 do large[i]=i end
assert(events:observe('bounded','first',large).ok)
local replacement={}
for i=1,256 do replacement[i]=i+1 end
assert(events:observe('bounded','second',replacement).ok)
assert(not events:observe('bounded','too_large',{text=string.rep('X',32769)}).ok)
assert(not events:observe('bounded','bad_key',{[function()end]=1}).ok)

local diagnostics=Diagnostics.new('0.1.0')
diagnostics.state='degraded'
diagnostics:module('platform','active')
diagnostics:validation('build_identity','unsupported','hash mismatch')
diagnostics:error('UnsupportedBuild','profile','unknown')
local rendered=diagnostics:render()
assert(rendered:find('state=degraded',1,true))
assert(rendered:find('validation.build_identity=unsupported',1,true))
assert(rendered:find('error.code=UnsupportedBuild',1,true))
assert(logger:close())

print('services: config, profiles, logging, diagnostics, scheduler, events OK')
