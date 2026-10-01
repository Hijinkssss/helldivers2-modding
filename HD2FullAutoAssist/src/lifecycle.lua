-- Owns exactly one Full Auto Assist controller, update wrapper and toggle.
-- No public framework API, registry, runtime jobs or game-data writes.
local Platform=require('platform')
local Identity=require('identity')
local Input=require('input')
local Config=require('config')
local Json=require('validation_trace')
local M={}
local PROFILE='steam-25480438-v02-candidate'
local EXE='F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06'
local DLL='2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E'
local RVAS={player_manager=0x3326468,entity_owner=0x346bf98,
    avatar_manager=0x3326d20,weapon_wielder=0x3326420,equipment_manager=0x3326dc0}
local READABLE={[2]=true,[4]=true,[8]=true,[32]=true,[64]=true,[128]=true}
local function integer(v,lo,hi)return type(v)=='number' and v==v and v%1==0 and v>=lo and v<=hi end
local function ok(v)return {ok=true,value=v}end
local function attempt(fn)
    local good,value=pcall(fn)
    return good and ok(value) or {ok=false,error={code='Unavailable',detail=tostring(value)}}
end
local function pack(...)return {n=select('#',...),...}end
function M.new(environment,options)
    options=options or {}
    local loader=assert(options.loader or environment.CowboyBingusModLoader,'Bingus Shared Loader required')
    assert(loader.api==1 and type(loader.open_log)=='function','Shared Loader API 1 required')
    local platform=options.platform or Platform.new()
    local startup_exe_started=platform:clock_us()
    local exe_hash=platform:module_hash(nil)
    local startup_exe_hash_us=math.max(0,platform:clock_us()-startup_exe_started)
    local startup_dll_started=platform:clock_us()
    local dll_hash=platform:module_hash('game.dll')
    local startup_game_dll_hash_us=math.max(0,platform:clock_us()-startup_dll_started)
    assert(exe_hash==EXE and dll_hash==DLL,
        'Unsupported build: exact EXE and game.dll fingerprints required')
    local base=assert(platform:module_address('game.dll'))
    local self={platform=platform,base=base,callbacks={},closed=false,reads=0,queries=0,
        failures=0,slow=0,slow_by_kind={},log_errors=0,live_region_last=nil,
        force_performance_profile=options.force_performance_profile==true,
        startup_metrics={exe_hash_us=startup_exe_hash_us,game_dll_hash_us=startup_game_dll_hash_us}}
    local file
    function self:log(level,event,fields)
        if file then
            local started=self.profiler and self.profiler:start()
            local good=pcall(function()
                assert(file:write(Json.json({level=level,event=event,fields=fields or {}})..'\n'))
                assert(file:flush())
            end)
            if self.profiler then self.profiler:finish('log_io',started)end
            if not good then self.log_errors=self.log_errors+1 end
        end
    end
    function self:clock_us()return platform:clock_us()end
    function self:set_profiler(profiler)self.profiler=profiler end
    function self:startup_timing()return self.startup_metrics end
    local observer
    function self:invalidate_native_cache()
        self.live_regions=nil
        self.live_region_last=nil
        self.native_cache_revision=(self.native_cache_revision or 0)+1
        if observer then observer:invalidate()end
    end
    function self:read(at,n)
        assert(integer(at,0x10000,0x7fffffffffff) and integer(n,1,32768) and
            n-1<=0x7fffffffffff-at,'Read outside supported bounds')
        local profiler=self.profiler
        local validation_started=profiler and profiler:sample('memory_page_validation',profiler.memory_samples_every)
            and profiler:start()
        local cursor,last,walk=at,at+n,0
        while cursor<last do
            walk=walk+1;assert(walk<=64,'Memory region walk budget exceeded')
            local region
            if self.regions then for _,r in ipairs(self.regions)do
                if cursor>=r.base and cursor<r.base+r.size then region=r;break end
            end end
            if not region then
                if profiler then profiler:increment('page_queries')end
                region=assert(platform:query_region(cursor),'Memory page unavailable');self.queries=self.queries+1
                if self.regions and #self.regions<64 then self.regions[#self.regions+1]=region end
            end
            assert(integer(region.base,0,0x7fffffffffff) and integer(region.size,1,0x7fffffffffff) and
                integer(region.protect,0,0xffffffff) and cursor>=region.base and cursor<region.base+region.size and
                region.size<=0x7fffffffffff-region.base+1 and region.state==0x1000 and
                READABLE[region.protect%256] and math.floor(region.protect/256)%2==0,'Unreadable or guarded page')
            cursor=math.min(last,region.base+region.size)
        end
        if profiler then profiler:finish('memory_page_validation',validation_started)end
        local read_started=profiler and profiler:sample('memory_platform_read',profiler.memory_samples_every)
            and profiler:start()
        if profiler then profiler:increment('memory_reads')end
        local bytes=platform:read(at,n);self.reads=self.reads+1
        if profiler then profiler:finish('memory_platform_read',read_started)end
        assert(type(bytes)=='string' and #bytes==n,'Short or failed memory read');return bytes
    end
    function self:read_live(at,n)
        if not platform.safe_cached_reads then return self:read(at,n)end
        assert(integer(at,0x10000,0x7fffffffffff) and integer(n,1,32768) and
            n-1<=0x7fffffffffff-at,'Read outside supported bounds')
        local profiler=self.profiler
        local validation_started=profiler and profiler:sample('memory_page_validation',profiler.memory_samples_every)
            and profiler:start()
        local good,value=pcall(function()
            local now=platform:clock_us()
            if not self.live_regions or now>=self.live_regions_until then
                self.live_regions={};self.live_region_last=nil;self.live_regions_until=now+1000000
            end
            local cursor,last,walk=at,at+n,0
            while cursor<last do
                walk=walk+1;assert(walk<=64,'Memory region walk budget exceeded')
                local region=self.live_region_last
                if profiler then profiler:increment('region_hint_checks')end
                if region and cursor>=region.base and cursor<region.base+region.size then
                    if profiler then profiler:increment('region_hint_hits')end
                else
                    region=nil
                    if profiler then profiler:increment('region_cache_searches')end
                    for _,r in ipairs(self.live_regions)do
                        if profiler then profiler:increment('region_cache_entries_examined')end
                        if cursor>=r.base and cursor<r.base+r.size then region=r;break end
                    end
                end
                if not region then
                    self.queries=self.queries+1
                    if self.profiler then self.profiler:increment('page_queries')end
                    region=assert(platform:query_region(cursor),'Memory page unavailable')
                    assert(integer(region.base,0,0x7fffffffffff) and integer(region.size,1,0x7fffffffffff) and
                        integer(region.protect,0,0xffffffff) and region.size<=0x7fffffffffff-region.base+1 and
                        cursor>=region.base and cursor<region.base+region.size and region.state==0x1000 and
                        READABLE[region.protect%256] and math.floor(region.protect/256)%2==0,
                        'Unreadable or guarded page')
                    if #self.live_regions<64 then self.live_regions[#self.live_regions+1]=region end
                end
                self.live_region_last=region
                cursor=math.min(last,region.base+region.size)
            end
            if profiler then profiler:finish('memory_page_validation',validation_started)end
            -- Current access is checked on EVERY reuse, including protection
            -- changes between metadata refreshes. Never dereference game memory
            -- with ffi.copy: RPM must return the full span or no value.
            local read_started=profiler and profiler:sample('memory_platform_read',profiler.memory_samples_every)
                and profiler:start()
            local bytes=platform:read(at,n);self.reads=self.reads+1
            if self.profiler then self.profiler:increment('memory_reads')end
            if profiler then profiler:finish('memory_platform_read',read_started)end
            assert(type(bytes)=='string' and #bytes==n,'Short or failed memory read')
            return bytes
        end)
        if not good then
            if profiler then profiler:finish('memory_page_validation',validation_started)end
            self:invalidate_native_cache();error(value,0)
        end
        return value
    end
    function self:read_scope(fn)
        if self.regions then return fn() end
        self.regions={};local values=pack(pcall(fn));self.regions=nil
        if not values[1]then error(values[2],0)end
        return unpack(values,2,values.n)
    end
    function self:u32(at)
        local a,b,c,d=self:read(at,4):byte(1,4);return a+b*256+c*65536+d*16777216
    end
    function self:ptr(at)
        local bytes=self:read(at,8);local a,b,c,d,e,f,g,h=bytes:byte(1,8)
        local p=a+b*256+c*65536+d*16777216+(e+f*256+g*65536+h*16777216)*4294967296
        assert(integer(p,0x10000,0x7fffffffffff),'Invalid pointer');return p
    end
    -- Validate the loaded PE image before resolving any fixed global.
    assert(self:read(base,2)=='MZ','Invalid module DOS header')
    local pe=self:u32(base+0x3c);assert(pe>=64 and pe<=1048576,'Invalid PE offset')
    assert(self:read(base+pe,4)=='PE\0\0','Invalid PE signature')
    assert(self:read(base+pe+24,2)=='\x0b\x02','Expected PE32+ image')
    local size=self:u32(base+pe+24+56);assert(integer(size,4096,0x80000000),'Invalid module image size')
    local function symbol_address(name)
        local rva=assert(RVAS[name],'Unknown assist symbol')
        assert(rva<=size-8,'Symbol outside module image');return base+rva
    end
    function self:symbol(name)
        local address=symbol_address(name)
        self:read(address,8)
        return address
    end
    function self:build_status()return {id=PROFILE,state='exact_fingerprints_matched'}end
    function self:config(schema,text,arsenal_options)return Config.load(schema,text,arsenal_options)end
    local memory={read=function(_,at,n)return attempt(function()return self:read_live(at,n)end)end,
        read_pointer=function(_,at)return attempt(function()
            local bytes=self:read_live(at,8);local a,b,c,d,e,f,g,h=bytes:byte(1,8)
            local p=a+b*256+c*65536+d*16777216+(e+f*256+g*65536+h*16777216)*4294967296
            assert(integer(p,0x10000,0x7fffffffffff),'Invalid pointer');return p
        end)end,
        with_region_cache=function(_,fn)return self:read_scope(fn)end}
    -- Identity immediately reads and later revalidates each resolved global.
    -- Keep the startup-facing symbol API guarded, but avoid reading the same
    -- global a third time on every full identity snapshot.
    local symbols={resolve=function(_,name)return attempt(function()return {address=symbol_address(name)}end)end}
    observer=Identity.new(memory,symbols)
    function self:local_avatar()return observer:snapshot()end
    function self:invalidate_identity()observer:invalidate()end
    function self:eligibility()return Input.sample(platform,memory,{id=PROFILE},environment.stingray)end
    function self:parse_key(key)
        local named={SPACE=32,TAB=9,ENTER=13,ESCAPE=27,INSERT=45,DELETE=46,HOME=36,END=35,
            PAGEUP=33,PAGEDOWN=34,LEFT=37,UP=38,RIGHT=39,DOWN=40}
        assert(type(key)=='string','Key name required');local name=key:match('^%s*(.-)%s*$'):upper()
        local code=named[name];if name:match('^[A-Z0-9]$')then code=name:byte()end
        if name=='=' or name=='+' then code=0xbb end -- VK_OEM_PLUS, with or without Shift.
        local f=name:match('^F(%d+)$')
        if f and tonumber(f)>=1 and tonumber(f)<=24 and name=='F'..tonumber(f)then code=111+tonumber(f)end
        local hex=name:match('^VK_(%x%x)$');if hex and tonumber(hex,16)>=8 and tonumber(hex,16)<=254 then code=tonumber(hex,16)end
        return assert(code,'Invalid toggle key')
    end
    function self:on_toggle(key,callback,binding)
        assert(platform:prepare_input(),'Keyboard unavailable')
        local row={kind='toggle',key=self:parse_key(key),callback=callback,armed=false,down=false,last=-math.huge,
            binding=binding,native_binding=nil,next_binding_attempt=0}
        self.callbacks.toggle=row;return row
    end
    function self:on_identity(callback)
        local row={kind='identity',callback=callback,next_us=0};self.callbacks.identity=row;return row
    end
    function self:on_fire(callback)
        local row={kind='fire',callback=callback};self.callbacks.fire=row;return row
    end
    function self:remove(row)if self.callbacks[row.kind]==row then self.callbacks[row.kind]=nil end end
    function self:on_stop(callback)self.cleanup=callback end
    function self:diagnostics()
        local active=0;for _ in pairs(self.callbacks)do active=active+1 end
        return {memory={reads=self.reads,queries=self.queries},observer=observer:status(),
            startup_timing=self.startup_metrics,
            scheduler={active=active,failures=self.failures,slow=self.slow},log_errors=self.log_errors}
    end
    function self:write_status()self:log('info','status',self:diagnostics())end
    local previous_update,previous_shutdown=environment.update,environment.shutdown
    local hud,hud_provider,charge_research
    function self:set_hud_provider(provider,settings)
        hud_provider=provider
        local anchor=require('hud_anchor').new(self)
        hud=require('hud_indicator').new(environment.stingray,{
            force_visible=settings and settings.hud_probe_visible==true,
            profiler=self.profiler,
            clock_us=function()return self:clock_us()end,
            log=(settings and settings.hud_diagnostics==true) and function(fields)
                self:log('info','hud_rc2',fields)
            end or nil},function(width,height,weapon_key)return anchor:sample(width,height,weapon_key)end)
    end
    function self:set_charge_research(provider)
        charge_research=require('charge_research').new(self,provider,loader)
    end
    local update_wrapper,shutdown_wrapper
    function self:stop()
        if self.closed then return ok(true)end
        if hud then hud:clear()end
        if charge_research then
            -- Diagnostic I/O must never prevent restoration of the Fire lease.
            pcall(charge_research.close,charge_research);charge_research=nil
        end
        -- A restore failure retains callbacks and cleanup for a later retry.
        local good,why=pcall(self.cleanup or function()end)
        if not good then self:log('error','cleanup_failed',{reason=tostring(why)});return {ok=false,error={detail=tostring(why)}}end
        self.closed=true;self.callbacks={}
        if environment.update==update_wrapper then environment.update=previous_update end
        if environment.shutdown==shutdown_wrapper then environment.shutdown=previous_shutdown end
        if file then pcall(function()file:close()end);file=nil end
        return ok(true)
    end
    local function dispatch(kind)
        local row=self.callbacks[kind];if not row or self.closed then return end
        local started=(self.profiler or kind=='identity') and platform:clock_us()
        if kind=='identity' then if started<row.next_us then return end;row.next_us=started+100000 end
        local good,why=pcall(row.callback)
        local elapsed=self.profiler and math.max(0,platform:clock_us()-started) or 0
        if self.profiler then
            local phase=kind=='fire' and 'callback_fire' or kind=='identity' and 'callback_identity' or 'callback_toggle'
            self.profiler:observe(phase,elapsed)
        end
        if elapsed>2000 then
            self.slow=self.slow+1;self.slow_by_kind[kind]=(self.slow_by_kind[kind]or 0)+1
            local count=self.slow_by_kind[kind]
            if count==1 or count%100==0 then self:log('warning','slow_callback',{kind=kind,count=count,elapsed_us=elapsed})end
        end
        if not good then
            self.failures=self.failures+1;self:log('error','callback_failed',{reason=tostring(why)})
            self:stop()
        end
    end
    local function toggle_tick()
        local row=self.callbacks.toggle;if not row or self.closed then return end
        local profile_started=self.profiler and self.profiler:start()
        if not platform:input_focused()then row.armed=false;row.down=false
            if self.profiler then self.profiler:finish('toggle_poll',profile_started)end
            return
        end
        local down
        if row.binding and not row.native_binding then
            local now=platform:clock_us()
            if now>=row.next_binding_attempt then
                row.next_binding_attempt=now+1000000
                local menu=environment.ModBindingsMenu or rawget(_G,'ModBindingsMenu')
                if type(menu)=='table' and type(menu.register_binding)=='function'
                   and type(menu.is_down)=='function' then
                    local ok,registered=pcall(menu.register_binding,row.binding.id,row.binding.label,
                        row.binding.slot,row.binding.options)
                    if ok and registered==true then
                        row.native_binding=menu
                        row.armed=false;row.down=false
                        if self.profiler then self.profiler:finish('toggle_poll',profile_started)end
                        return
                    end
                end
            end
        end
        if row.native_binding then
            -- Once the native action registers, never fall back to the default key.
            -- A nil/unavailable native state fails closed until the binding returns.
            local ok,value=pcall(row.native_binding.is_down,row.binding.id)
            down=ok and value==true
        else
            down=platform:input_down(row.key);assert(type(down)=='boolean','Keyboard state unavailable')
        end
        if not down then row.armed=true end
        local pressed=down and not row.down and row.armed;row.down=down
        if pressed then local now=platform:clock_us();local due=now-row.last>=150000;row.last=now
            if due then dispatch('toggle')end
        end
        if self.profiler then self.profiler:finish('toggle_poll',profile_started)end
    end
    function self:attach()
        assert(type(previous_update)=='function','Game update unavailable')
        update_wrapper=function(...)
            local before_started=self.profiler and self.profiler:start()
            -- Both callbacks run before the stock update. Share only this
            -- update's page-query rows, then discard them before game code runs.
            self:read_scope(function()
                dispatch('identity');dispatch('fire')
            end)
            local before_stock=before_started and math.max(0,platform:clock_us()-before_started) or 0
            local values=pack(pcall(previous_update,...))
            if not values[1]then
                if self.profiler then self.profiler:observe('update_wrapper',before_stock)end
                self:stop();error(values[2],0)
            end
            local after_started=self.profiler and self.profiler:start()
            local good,why=pcall(toggle_tick)
            if hud and hud_provider then
                local hud_started=self.profiler and self.profiler:start()
                hud:present(hud_provider())
                if self.profiler then self.profiler:finish('hud_present',hud_started)end
            end
            if charge_research then
                local ok,reason=pcall(charge_research.tick,charge_research)
                if not ok then
                    self:log('warning','charge_research_stopped',{reason=tostring(reason)})
                    pcall(charge_research.close,charge_research);charge_research=nil
                end
            end
            local after_stock=after_started and math.max(0,platform:clock_us()-after_started) or 0
            if self.profiler then self.profiler:observe('update_wrapper',before_stock+after_stock)end
            if not good then self:log('error','input_failed',{reason=tostring(why)});self:stop()end
            return unpack(values,2,values.n)
        end
        shutdown_wrapper=function(...)
            self:stop()
            if type(previous_shutdown)=='function'then return previous_shutdown(...)end
        end
        assert(environment.update==previous_update and environment.shutdown==previous_shutdown,'Callbacks changed during startup')
        environment.update=update_wrapper;environment.shutdown=shutdown_wrapper
    end
    local opened,value=pcall(loader.open_log,'HD2FullAutoAssist.log')
    if opened then file=value end
    return self
end
function M.start(environment,options)
    if environment.HD2FullAutoAssistStandalone then return environment.HD2FullAutoAssistStandalone end
    -- The Shared Loader discovers addon modules in archive enumeration order.
    -- Resolve the selected Arsenal option resources here before policy setup so
    -- profile selection does not depend on whether those modules loaded first.
    local selected={
        peacemaker_profile={'balanced','full_auto'},
        socom_profile={'balanced','full_auto'},
        veto_profile={'balanced','full_auto'},
        talon_profile={'balanced','efficiency','full_auto','fuller_auto'},
        amr_profile={'balanced','full_auto'},
        commando_profile={'balanced','full_auto'},
        hyena_profile={'balanced','full_auto'},
        bushwhacker_profile={'balanced','full_auto'},
        eruptor_profile={'slower_27','balanced_28','max_32','balanced','full_auto','stable_26','balanced_27','fast_28'},
    }
    local application=environment.stingray and environment.stingray.Application
    local global_require=rawget(_G,'require')
    if application and type(application.can_get)=='function' and type(global_require)=='function' then
        for key,profiles in pairs(selected)do
            for _,profile in ipairs(profiles)do
                local module='mods/codex/hd2_full_auto_assist_option_'..key..'_'..profile
                local ok,available=pcall(application.can_get,'lua',module)
                assert(ok,'Could not check Arsenal profile resource: '..module)
                if available then
                    local loaded,why=pcall(global_require,module)
                    assert(loaded,'Could not load Arsenal profile resource: '..module..': '..tostring(why))
                end
            end
        end
    end
    local host=M.new(environment,options)
    local good,consumer=pcall(require('full_auto_assist').install,host,
        options and options.backend_factory or function(h)return require('native_fire').new(h)end,
        options and options.read_config,options and options.validation_factory)
    if not good then host:stop();error(consumer,0)end
    if options and options.charge_research==true then
        local ready,reason=pcall(host.set_charge_research,host,function()return consumer:get_state()end)
        if not ready then host:log('warning','charge_research_unavailable',{reason=tostring(reason)})end
    end
    local attached,why=pcall(host.attach,host)
    if not attached then host:stop();error(why,0)end
    environment.HD2FullAutoAssistStandalone=consumer;return consumer
end
return M
