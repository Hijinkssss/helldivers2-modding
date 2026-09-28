local Config = require('hd2modcore.config')
local Diagnostics = require('hd2modcore.diagnostics')
local Events = require('hd2modcore.events')
local GameState = require('hd2modcore.game_state')
local Input = require('hd2modcore.input')
local InputEligibility = require('hd2modcore.input_eligibility')
local Lifecycle = require('hd2modcore.lifecycle')
local Logger = require('hd2modcore.logger')
local Memory = require('hd2modcore.memory')
local Profiles = require('hd2modcore.profiles')
local Result = require('hd2modcore.result')
local Scheduler = require('hd2modcore.scheduler')
local Symbols = require('hd2modcore.symbols')
local Util = require('hd2modcore.util')
local Windows = require('hd2modcore.platform_windows')
local Example = require('hd2modcore.example_profile')

local M = {VERSION='0.3.0-dev',API=1}

local CORE_CONFIG={
    log_level={type='enum',values={'trace','debug','info','warning','error','fatal'},
        default='info'},
    diagnostics={type='boolean',default=true}
}

local function exception(err)
    return debug and debug.traceback and debug.traceback(err,2) or tostring(err)
end

function M.install(environment, options)
    environment=environment or _G
    options=options or {}
    local existing=rawget(environment,'HD2ModCore')
    if existing then
        if type(existing)=='table' and type(existing.State)=='function' and
            existing.api==M.API and existing.version==M.VERSION and
            existing:State()~='stopped' and existing:State()~='failed' then
            return existing
        end
        return nil,Result.err('InvalidState','bootstrap','incompatible or stopped singleton')
    end
    local loader=options.loader or rawget(environment,'CowboyBingusModLoader')
    if type(loader)~='table' or loader.api~=1 or
        type(environment.update)~='function' then
        return nil,Result.err('InitializationFailed','loader',
            'Bingus Shared Loader API 1 and game update callback required')
    end

    local diagnostics=Diagnostics.new(M.VERSION)
    local lifecycle=Lifecycle.new(diagnostics)
    lifecycle:begin()
    local platform,logger,config,profiles,memory,symbols,game_state,scheduler,events,input
    local previous_update,previous_shutdown=environment.update,environment.shutdown
    local update_wrapper,shutdown_wrapper
    local unload_handlers={}
    local consumer_owners={}
    local shutdown_started=false
    local function stage(name,required,run,undo)
        local result=lifecycle:stage(name,required,run,undo)
        if not result.ok and required then
            if logger then
                logger:status_snapshot(diagnostics:render())
            elseif type(environment.print)=='function' then
                pcall(environment.print,'[HD2ModCore] initialization failed: '..
                    name..': '..result.error.detail)
            end
            return false,result
        end
        return true,result
    end
    local ok,problem=stage('platform',true,function()
        platform=options.platform or Windows.new()
        assert(type(platform.clock_us)=='function' and
            type(platform.module_hash)=='function' and
            type(platform.query_region)=='function' and
            type(platform.read)=='function','platform adapter incomplete')
        return platform
    end)
    if not ok then return nil,problem end

    ok,problem=stage('logger',false,function()
        logger=Logger.new(loader,function() return platform:clock_us()/1000 end,'info')
        lifecycle.logger=logger
        if not logger.history then
            lifecycle.degraded=true
            diagnostics:validation('event_log','unavailable',
                'loader open_log could not provide an event history')
        else diagnostics:validation('event_log','available') end
        return logger
    end,function() if logger then logger:close() end end)

    ok,problem=stage('config',false,function()
        config=Config.new()
        assert(config:register('core',CORE_CONFIG).ok)
        local text=options.config_text
        if text==nil and type(platform.read_config)=='function' then
            local source,why=platform:read_config()
            assert(source~=nil,why or 'configuration read failed')
            text=source
        end
        local parsed=config:load('core',text or '')
        assert(parsed.ok,parsed.error and parsed.error.detail)
        if logger then logger:set_level(config:get('core','log_level').value) end
        return config
    end)
    if not config then
        config=Config.new();assert(config:register('core',CORE_CONFIG).ok)
    end

    ok,problem=stage('profiles',false,function()
        profiles=Profiles.new(options.profiles or {Example})
        local exe,exe_why=platform:module_hash(nil)
        local dll,dll_why=platform:module_hash('game.dll')
        assert(exe and dll,exe_why or dll_why or 'game module hash unavailable')
        local selected=profiles:select({exe_sha256=exe,dll_sha256=dll})
        diagnostics.profile=profiles:status()
        diagnostics:validation('build_identity',selected.ok and 'matched' or 'unsupported',
            selected.ok and profiles.selected.evidence or selected.error.detail)
        if not selected.ok then
            diagnostics:error(selected.error.code,'profile',selected.error.detail)
            lifecycle.degraded=true
        elseif profiles.selected.evidence~='runtime_observed' then
            lifecycle.degraded=true
        end
        return profiles
    end)
    if not profiles then
        profiles=Profiles.new(options.profiles or {Example})
        diagnostics.profile=profiles:status()
        diagnostics:validation('build_identity','failed',
            diagnostics.recent_error and diagnostics.recent_error.detail)
    end
    diagnostics:validation('address_resolution','source_candidate',
        'v0.2 read-only symbols require live validation')

    ok,problem=stage('memory',true,function()
        memory=Memory.new(platform)
        return memory
    end)
    if not ok then return nil,problem end
    ok,problem=stage('symbols',true,function()
        symbols=Symbols.new(platform,memory,profiles)
        return symbols
    end,function() if symbols then symbols:clear() end end)
    if not ok then return nil,problem end
    ok,problem=stage('game_state',true,function()
        game_state=GameState.new(memory,symbols)
        return game_state
    end)
    if not ok then return nil,problem end
    ok,problem=stage('scheduler',true,function()
        scheduler=Scheduler.new(function() return platform:clock_us() end,logger)
        return scheduler
    end,function() if scheduler then scheduler:clear() end end)
    if not ok then return nil,problem end
    ok,problem=stage('events',true,function()
        events=Events.new(logger)
        return events
    end,function() if events then events:clear() end end)
    if not ok then return nil,problem end

    ok,problem=stage('input',true,function()
        input=Input.new(platform,logger)
        return input
    end,function() if input then input:clear() end end)
    if not ok then return nil,problem end
    local core={version=M.VERSION,api=M.API}
    function core:State() return lifecycle.state end
    function core:OnLoad(owner,callback)
        if type(owner)~='string' or type(callback)~='function' then
            return Result.err('InvalidSubscription','on_load','owner and callback required')
        end
        if lifecycle.state~='running' and lifecycle.state~='degraded' then
            return Result.err('InvalidState','on_load','core not active')
        end
        local called,reason=xpcall(function() callback(self) end,exception)
        if not called then
            diagnostics:module(owner,'disabled',reason)
            diagnostics:error('CallbackFailed','on_load',reason)
            if logger then logger:emit('error','lifecycle','owner_load_failed',
                {owner=owner,reason=reason}) end
            return Result.err('CallbackFailed','on_load',reason)
        end
        diagnostics:module(owner,'active')
        consumer_owners[owner]=true
        return Result.ok(true)
    end
    function core:OnUnload(owner,callback)
        if type(owner)~='string' or type(callback)~='function' then
            return Result.err('InvalidSubscription','on_unload','owner and callback required')
        end
        if lifecycle.state~='running' and lifecycle.state~='degraded' then
            return Result.err('InvalidState','on_unload','core not active')
        end
        unload_handlers[#unload_handlers+1]={owner=owner,callback=callback}
        consumer_owners[owner]=true
        return Result.ok(true)
    end
    function core:Unregister(owner)
        if lifecycle.state~='running' and lifecycle.state~='degraded' then
            return Result.err('InvalidState','unregister','core not active')
        end
        scheduler:remove_owner(owner);events:remove_owner(owner);input:remove_owner(owner)
        local failure
        for index=#unload_handlers,1,-1 do
            local row=unload_handlers[index]
            if row.owner==owner then
                local called,reason=xpcall(function() row.callback(self) end,exception)
                if not called then
                    failure=reason
                    diagnostics:error('CleanupFailed',owner,reason)
                end
                table.remove(unload_handlers,index)
            end
        end
        diagnostics:module(owner,failure and 'cleanup_failed' or 'stopped',failure)
        consumer_owners[owner]=nil
        if failure then return Result.err('CleanupFailed','unregister',failure) end
        return Result.ok(true)
    end
    function core:Shutdown()
        if lifecycle.state=='stopped' then return Result.ok(true) end
        if shutdown_started then
            return Result.err('InvalidState','shutdown','shutdown reentered')
        end
        shutdown_started=true
        local owner_failures={}
        for index=#unload_handlers,1,-1 do
            local row=unload_handlers[index]
            local called,reason=xpcall(function() row.callback(self) end,exception)
            if not called then
                owner_failures[row.owner]=reason
                diagnostics:error('CleanupFailed',row.owner,reason)
                if logger then logger:emit('error','lifecycle','owner_unload_failed',
                    {owner=row.owner,reason=reason}) end
            end
        end
        unload_handlers={}
        -- Unload handlers may use their subscriptions while they run. Revoke all
        -- remaining subscriptions before publishing the final status snapshot.
        scheduler:clear()
        events:clear()
        input:clear()
        for owner in pairs(consumer_owners) do
            local reason=owner_failures[owner]
            diagnostics:module(owner,reason and 'cleanup_failed' or 'stopped',reason)
        end
        consumer_owners={}
        diagnostics.scheduler=scheduler:status()
        diagnostics.events=events:status()
        diagnostics.memory=memory:status()
        diagnostics.symbols=symbols:status()
        diagnostics.game_state=game_state:status()
        diagnostics.input=input:status()
        local result=lifecycle:shutdown()
        if environment.update==update_wrapper then environment.update=previous_update end
        if environment.shutdown==shutdown_wrapper then
            environment.shutdown=previous_shutdown
        end
        if logger and config:get('core','diagnostics').value then
            logger:status_snapshot(diagnostics:render())
        end
        return result
    end
    core.Hooks={
        Subscribe=function(_,owner,phase,settings,callback)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','hooks','core not active')
            end
            return scheduler:subscribe(owner,phase,settings,callback)
        end,
        Remove=function(_,token) return scheduler:remove(token) end
    }
    core.Input={
        ParseKey=function(_,key) return Input.parse(key) end,
        ShortcutEligibility=function()
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','input_eligibility','core not active')
            end
            return InputEligibility.sample(platform,memory,profiles:status(),rawget(environment,'stingray'))
        end,
        SubscribePressed=function(_,owner,key,settings,callback)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','input','core not active')
            end
            return input:subscribe(owner,key,settings,callback)
        end,
        Remove=function(_,token) return input:remove(token) end
    }
    core.Events={
        Subscribe=function(_,owner,channel,callback)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','events','core not active')
            end
            return events:subscribe(owner,channel,callback)
        end,
        Remove=function(_,token) return events:remove(token) end,
        Observe=function(_,channel,fingerprint,snapshot)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','events','core not active')
            end
            return events:observe(channel,fingerprint,snapshot)
        end,
        Current=function(_,channel) return events:current(channel) end
    }
    core.Config={
        Register=function(_,namespace,schema)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','config','core not active')
            end
            return config:register(namespace,schema)
        end,
        Load=function(_,namespace,text)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','config','core not active')
            end
            return config:load(namespace,text)
        end,
        Get=function(_,namespace,key) return config:get(namespace,key) end
    }
    core.Build={
        Status=function() return profiles:status() end
    }
    core.Symbols={
        Resolve=function(_,name)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','symbols','core not active')
            end
            return symbols:resolve(name)
        end
    }
    core.Diagnostic={
        LocalAvatar=function()
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','game_state','core not active')
            end
            return game_state:snapshot()
        end
    }
    core.Memory={
        Read=function(_,address,size)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','memory','core not active')
            end
            if not profiles.selected then
                return Result.err('UnsupportedBuild','memory','no exact build profile')
            end
            return memory:read(address,size)
        end,
        ReadU32=function(_,address)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','memory','core not active')
            end
            if not profiles.selected then
                return Result.err('UnsupportedBuild','memory','no exact build profile')
            end
            return memory:read_u32(address)
        end,
        ReadPointer=function(_,address)
            if lifecycle.state~='running' and lifecycle.state~='degraded' then
                return Result.err('InvalidState','memory','core not active')
            end
            if not profiles.selected then
                return Result.err('UnsupportedBuild','memory','no exact build profile')
            end
            return memory:read_pointer(address)
        end
    }
    core.Logger={
        Emit=function(_,level,category,event,fields)
            if not logger or lifecycle.state=='stopped' then return false end
            return logger:emit(level,category,event,fields)
        end
    }
    core.Diagnostics={
        Status=function()
            diagnostics.input=input:status()
            diagnostics.scheduler=scheduler:status()
            diagnostics.events=events:status()
            diagnostics.memory=memory:status()
            diagnostics.symbols=symbols:status()
            diagnostics.game_state=game_state:status()
            return diagnostics:status()
        end,
        WriteStatus=function()
            diagnostics.input=input:status()
            diagnostics.scheduler=scheduler:status()
            diagnostics.events=events:status()
            diagnostics.memory=memory:status()
            diagnostics.symbols=symbols:status()
            diagnostics.game_state=game_state:status()
            return logger and logger:status_snapshot(diagnostics:render()) or false
        end
    }

    update_wrapper=function(...)
        local args=Util.pack(...)
        if lifecycle.state=='running' or lifecycle.state=='degraded' then
            scheduler:tick('before_update',Util.unpack(args))
        end
        local prior=Util.pack(pcall(previous_update,Util.unpack(args)))
        if not prior[1] then
            diagnostics:error('CallbackFailed','previous_update',prior[2])
            core:Shutdown()
            error(prior[2],0)
        end
        if lifecycle.state=='running' or lifecycle.state=='degraded' then
            input:tick()
            scheduler:tick('after_update',Util.unpack(args))
        end
        return unpack(prior,2,prior.n)
    end
    shutdown_wrapper=function(...)
        core:Shutdown()
        if type(previous_shutdown)=='function' then return previous_shutdown(...) end
    end
    ok,problem=stage('callbacks',true,function()
        assert(environment.update==previous_update,'update changed during initialization')
        environment.update=update_wrapper
        environment.shutdown=shutdown_wrapper
        return true
    end,function()
        if environment.update==update_wrapper then environment.update=previous_update end
        if environment.shutdown==shutdown_wrapper then
            environment.shutdown=previous_shutdown
        end
    end)
    if not ok then return nil,problem end
    lifecycle:finish()
    environment.HD2ModCore=core
    if logger then
        logger:emit('info','lifecycle','ready',{state=lifecycle.state,
            profile=diagnostics.profile.id or 'none'})
        if config:get('core','diagnostics').value then
            core.Diagnostics:WriteStatus()
        end
    end
    return core
end

return M
