local M={}
local Policy=require('weapon_policy')
local AssistState=require('assist_state')
local Validation=require('validation_trace')
local PerformanceProfile=require('performance_profile')
local Hud=require('hud_indicator')
-- Enabled only after recorded idle swaps and player invalidation were reviewed.
-- See docs/identity-validation.json. This is not a selective gameplay pass.
local IDENTITY_VALIDATED=true
local installed=setmetatable({},{__mode='k'})
local OWNER='hd2_full_auto_assist'
local schema={enabled={type='boolean',default=true},user_enabled={type='boolean',default=true},
    -- Zero selects the policy interval; positive values can only slow it down.
    repeat_ms={type='integer',default=0,min=0,max=1000},
    toggle_hotkey={type='string',default='=',max_length=16},debug_logging={type='boolean',default=false},
    validation_logging={type='boolean',default=false},
    hud_diagnostics={type='boolean',default=true},
    hud_probe_visible={type='boolean',default=false},
    performance_profile={type='boolean',default=false},
    performance_label={type='string',default='unlabeled',max_length=48},
    -- Fire-rate mode:
    --   balanced     (default) clamp to 380 RPM ceiling; AMR uses 120 RPM; Talon uses talon_mode
    --   native_cap   allow up to each weapon's actual accepted native cap
    fire_rate_mode={type='string',default='balanced',max_length=16,values={balanced=true,native_cap=true}},
    talon_mode={type='string',default='balanced',max_length=16,
        values={balanced=true,efficiency=true,full_auto=true,fuller_auto=true}},
    peacemaker_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    socom_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    veto_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    talon_profile={type='string',default='',max_length=16,
        values={['']=true,balanced=true,efficiency=true,full_auto=true,fuller_auto=true}},
    amr_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    commando_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    hyena_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    bushwhacker_profile={type='string',default='',max_length=16,values={['']=true,balanced=true,full_auto=true}},
    eruptor_profile={type='string',default='',max_length=16,
        values={['']=true,slower_27=true,balanced_28=true,max_32=true}}}
local function config_text()
    local root=assert(os.getenv('LOCALAPPDATA'),'LOCALAPPDATA unavailable')
    local f,why,number=io.open(root..'/CowboyBingus/Helldivers2/HD2FullAutoAssist.ini','rb')
    if not f then if number==2 then return '' end;error(why) end
    local text=f:read(8193);assert(f:close());assert(text and #text<=8192,'Configuration exceeds 8192 bytes')
    return text
end
function M.install(host,backend_factory,read_config,validation_factory)
    assert(type(host)=='table' and host.read and host.eligibility,'Full Auto Assist host required')
    if installed[host] then return installed[host] end
    local input_token,hook_token,identity_token,backend,settings,closed,failed,policy,state,profiler
    local leased_entity_id,leased_resource_hash,leased_avatar_id,leased_identity_token
    -- A new controller has no outstanding Fire lease to release. Start armed;
    -- only safety guards after an observed eligible/leased state may require a
    -- physical release. This lets delayed mission/player initialization settle
    -- while the user is already holding ordinary Fire.
    local wait_release,unit_ref,inspected=false,nil,false
    local lease_started,lease_repeat_start
    local trace,last_metrics_us

    local counters={toggles=0,toggle_rejected=0,holds=0,releases=0,blocked=0,errors=0,
        idle_calls=0,held_calls=0,idle_us=0,held_us=0,max_us=0,repeat_frames=0,restore_conflicts=0,
        input_checks=0,repeat_calls=0,repeat_us=0,repeat_us_max=0,repeat_wall_us=0,
        identity_lookups=0,identity_changes=0,identity_lookup_us=0,identity_lookup_us_max=0}
    local consumer={name=OWNER}
    local function emit(level,event,fields)
        host:log(level,event,fields or {})
        if trace then trace:record(event,{level=level,data=fields or {},state=state and state:snapshot()}) end
    end
    local function restore(reason)
        if reason~='release' and ((backend and backend.lease) or
            (reason~='weapon_not_effective' and reason~='invalid_gameplay_state'))then
            if host.invalidate_identity then host:invalidate_identity()end
            if backend and backend.invalidate then backend:invalidate()end
        end
        if state then state:set_repeat(false) end
        leased_entity_id,leased_resource_hash,leased_avatar_id,leased_identity_token=nil,nil,nil,nil
        if not backend or not backend.lease then unit_ref=nil;return end
        local restore_started=profiler and profiler:start()
        local clean,detail=backend:restore();unit_ref=nil
        if profiler then profiler:finish('native_fire_restore',restore_started)end
        local wall=lease_started and math.max(0,backend.clock_us()-lease_started) or 0
        local repeats=counters.repeat_frames-(lease_repeat_start or counters.repeat_frames)
        counters.repeat_wall_us=counters.repeat_wall_us+wall
        lease_started,lease_repeat_start=nil,nil
        if trace then trace:record('lease_released',{reason=reason,clean=clean,detail=detail,wall_us=wall,
            observed_repeat_pulses=repeats,active_lease=backend.lease~=nil,state=state:snapshot()}) end
        if not clean then
            if host.invalidate_identity then host:invalidate_identity()end
            counters.restore_conflicts=counters.restore_conflicts+1
            emit('warning','restore_conflict',{reason=detail}) end
        if settings and settings.debug_logging then emit('info','hold_stopped',
            {reason=reason,clean=clean,wall_us=wall,observed_repeat_pulses=repeats}) end
    end
    local function fail(why)
        if not failed then
            if profiler then profiler:increment('failure_entries')end
            failed=true;counters.errors=counters.errors+1
            if state then state:invalidate('consumer_failed') end
            if backend and backend.invalidate then backend:invalidate()end
            emit('error','assist_disabled',{reason=tostring(why)})
            if input_token then host:remove(input_token);input_token=nil end
        end
        local ok,reason=pcall(restore,'error')
        if not ok then emit('error','restore_failed',{reason=tostring(reason)}) end
        -- Retain the hook only while a failed write still needs restoration.
        if (not backend or not backend.lease) and hook_token then host:remove(hook_token);hook_token=nil end
        if identity_token then host:remove(identity_token);identity_token=nil end
    end
    host:on_stop(function()
        if closed then return end
        restore('unload');closed=true
        if state then state:invalidate('unloaded') end
        if input_token then host:remove(input_token);input_token=nil end
        if hook_token then host:remove(hook_token);hook_token=nil end
        if identity_token then host:remove(identity_token);identity_token=nil end
        counters.mapping_writes=backend and backend.writes or 0
        counters.mapping_restored=backend and backend.restored or 0
        counters.active_lease=backend and backend.lease~=nil or false
        local shutdown_fields=counters
        if profiler then
            shutdown_fields.performance=profiler:summary()
            if type(host.diagnostics)=='function' then
                shutdown_fields.performance.runtime_diagnostics=host:diagnostics()
            end
        end
        emit('info','shutdown',shutdown_fields)
        if trace then trace:close(host:diagnostics())end
        if profiler and type(host.set_profiler)=='function' then host:set_profiler(nil)end
    end)
    local loaded,load_error=pcall(function()
        settings=host:config(schema,(read_config or config_text)(),rawget(_G,'FullAutoAssistArsenalOptions'))
        if settings.performance_profile then
            assert(type(host.clock_us)=='function' and type(host.set_profiler)=='function',
                'Performance profiling is unavailable on this host')
            profiler=PerformanceProfile.new(function()return host:clock_us()end,settings.performance_label)
            host:set_profiler(profiler)
            if type(host.startup_timing)=='function' then
                local startup=host:startup_timing()
                profiler:observe('startup_exe_hash',startup.exe_hash_us or 0)
                profiler:observe('startup_game_dll_hash',startup.game_dll_hash_us or 0)
            end
        end
        assert(settings.fire_rate_mode=='balanced' or settings.fire_rate_mode=='native_cap',
            'fire_rate_mode must be balanced or native_cap')
        assert(settings.talon_mode=='balanced' or settings.talon_mode=='efficiency' or
            settings.talon_mode=='full_auto' or settings.talon_mode=='fuller_auto','Invalid talon_mode')
        host:parse_key(settings.toggle_hotkey)
        if not settings.enabled then emit('info','disabled');return end
        policy=Policy.new(settings.fire_rate_mode,settings.talon_mode,settings)
        state=AssistState.new(policy,IDENTITY_VALIDATED)
        state:set_enabled(settings.user_enabled)
        if host.set_hud_provider then host:set_hud_provider(function()return state:hud_state()end,settings)end
        if not policy.available then
            emit('warning','selective_assist_unavailable',{reason=policy.reason,
                fallback='vanilla',required='known_current_build_policy'})
            return
        end
        if settings.validation_logging then
            backend=backend_factory(host)
            trace=(validation_factory or Validation.new)({clock=backend.clock_us})
            last_metrics_us=backend.clock_us()
            trace:record('policy_ready',{policy=policy:status(),identity_source='local_guarded_observer',
                build=host:build_status(),peacemaker=policy:classify('05e4e5c2db6e44a2'),
                amendment=policy:classify('0f83639ab8c86165'),amr=policy:classify('89c5493e08ca4207')})
            trace:state(state:snapshot(),'startup')
        end
        input_token=host:on_toggle(settings.toggle_hotkey,function()
            local ok,why=pcall(function()
                local eligibility=host:eligibility()
                if settings.debug_logging then
                    local fields={active=state:is_enabled(),stage='pressed_after_update',hotkey=settings.toggle_hotkey}
                    if eligibility.ok then
                        for key,value in pairs(eligibility.value) do fields[key]=value end
                    else
                        fields.allowed=false;fields.reason='eligibility_unavailable'
                        fields.detail=eligibility.error and eligibility.error.detail
                    end
                    emit('info','toggle_eligibility',fields)
                end
                if not eligibility.ok or eligibility.value.allowed~=true then
                    counters.toggle_rejected=counters.toggle_rejected+1;return
                end
                local enabled=not state:is_enabled()
                restore('toggle');state:set_enabled(enabled);wait_release=true
                if trace then trace:state(state:snapshot(),'toggle')end
                counters.toggles=counters.toggles+1
                emit('info','assist_toggled',{active=enabled})
            end)
            if not ok then fail(why) end
        end,{id='codex.full_auto_assist.toggle',label='Toggle Full Auto Assist',slot=2,
            options={category='Full Auto Assist'}})
        local fingerprint,last_revision
        local function resolve(expected_unit)
            counters.identity_lookups=counters.identity_lookups+1
            local snapshot_started=profiler and profiler:start()
            local ok,result=pcall(host.local_avatar,host)
            local identity_elapsed=0
            if profiler then
                identity_elapsed=profiler:finish('identity_snapshot',snapshot_started) or 0
                profiler:increment('identity_snapshots')
            end
            local policy_started=profiler and profiler:start()
            local current=state:resolve(ok and result or nil,expected_unit)
            local policy_elapsed=profiler and profiler:finish('policy_resolution',policy_started)
            if policy_elapsed then
                identity_elapsed=identity_elapsed+policy_elapsed
            end
            if trace and policy_elapsed then trace:cost('identity_resolution',policy_elapsed)end
            local fingerprint_started=profiler and profiler:start()
            local next_fingerprint=current.revision==last_revision and fingerprint or table.concat({tostring(current.weapon.unit_ref),tostring(current.weapon.avatar_id),tostring(current.weapon.entity_id),
                tostring(current.weapon.resource_hash),current.eligibility.category,tostring(current.identity_observed),
                tostring(current.weapon.identity_token)},':')
            if profiler then
                local fingerprint_elapsed=profiler:finish('identity_fingerprint',fingerprint_started) or 0
                identity_elapsed=identity_elapsed+fingerprint_elapsed
                counters.identity_lookup_us=counters.identity_lookup_us+identity_elapsed
                counters.identity_lookup_us_max=math.max(counters.identity_lookup_us_max,identity_elapsed)
            end
            last_revision=current.revision
            if next_fingerprint~=fingerprint then
                fingerprint=next_fingerprint;counters.identity_changes=counters.identity_changes+1
                if settings.debug_logging then emit('info','held_identity_changed',{
                    name=current.weapon.name or 'unknown',resource_hash=current.weapon.resource_hash or 'unavailable',
                    entity_id=current.weapon.entity_id or 0,category=current.eligibility.category,
                    identity_valid=current.identity_valid,effective=current.effective}) end
            end
            if trace then trace:state(current,'identity')end
            if backend and backend.lease and (not current.effective or
                current.weapon.unit_ref~=unit_ref or current.weapon.entity_id~=leased_entity_id or
                current.weapon.resource_hash~=leased_resource_hash or current.weapon.avatar_id~=leased_avatar_id or
                current.weapon.identity_token~=leased_identity_token) then
                restore('weapon_identity_changed_or_invalid');wait_release=true
            end
            return current
        end
        identity_token=host:on_identity(function()
                if closed or failed then return end
                if backend and backend.lease then return end -- The firing callback resolves fresh identity every update.
                local ok,why=pcall(function()
                    if IDENTITY_VALIDATED and not backend then backend=backend_factory(host)end
                    if backend and backend.gameplay_state and not backend:gameplay_state()then
                        state:invalidate('invalid_gameplay_state')
                        if host.invalidate_identity then host:invalidate_identity()end
                        return
                    end
                    resolve()
                end);if not ok then fail(why) end
            end)
        local function tick()
            if closed then return end
            if failed then
                if profiler then profiler:increment('restoration_retry_calls')end
                fail('restoration_retry');return
            end
            if not state:is_enabled() and not trace then return end
            if not backend then
                local init_started=profiler and profiler:start()
                backend=backend_factory(host)
                if profiler then profiler:finish('backend_initialize',init_started)end
            end
            local started=(profiler or trace) and backend.clock_us();local held=false;local leased_before=backend.lease~=nil
            local ok,why=pcall(function()
                counters.input_checks=counters.input_checks+1
                local sample_started=profiler and profiler:start()
                local row=backend:sample(trace~=nil)
                if profiler then profiler:finish('native_input_sample',sample_started);profiler:increment('native_input_samples')end
                if trace then trace:input(row,state:snapshot(),backend.lease~=nil)end
                if not row then restore('input_unavailable');wait_release=true;return end
                held=row.held
                if not inspected and type(backend.inspect)=='function' then
                    emit('info','native_input_ready',backend:inspect(row));inspected=true
                end
                if not state:is_enabled() and not trace then return end
                if not row.held then
                    if backend.lease then counters.releases=counters.releases+1 end
                    restore('release');wait_release=false;return
                end
                if row.pressed and row.trigger==8 and backend.lease then counters.repeat_frames=counters.repeat_frames+1 end
                if not row.gameplay then
                    local release_required=wait_release or backend.lease~=nil
                    state:invalidate('invalid_gameplay_state')
                    if host.invalidate_identity then host:invalidate_identity()end
                    restore('invalid_gameplay_state');wait_release=release_required;return
                end
                if wait_release then return end
                local eligibility_started=profiler and profiler:start()
                local eligibility=host:eligibility()
                if profiler then profiler:finish('input_eligibility',eligibility_started);profiler:increment('input_eligibility_calls')end
                if not eligibility.ok or eligibility.value.allowed~=true then
                    if backend.lease then counters.blocked=counters.blocked+1 end
                    restore(eligibility.ok and eligibility.value.reason or 'eligibility_unavailable')
                    wait_release=true;return
                end
                local current=resolve(row.unit_ref)
                if wait_release or not current.effective then
                    local release_required=wait_release or current.identity_observed
                    restore('weapon_not_effective');wait_release=release_required;return
                end
                if backend.lease then
                    if unit_ref~=row.unit_ref then restore('local_player_changed');wait_release=true;return end
                    local refresh_started=profiler and profiler:start()
                    if backend:refresh(row)==false then
                        restore('axis_input_selected');wait_release=true
                    end
                    if profiler then profiler:finish('native_fire_refresh',refresh_started);profiler:increment('native_fire_refresh_calls')end
                    return
                end
                unit_ref=row.unit_ref
                leased_entity_id,leased_resource_hash=current.weapon.entity_id,current.weapon.resource_hash
                leased_avatar_id,leased_identity_token=current.weapon.avatar_id,current.weapon.identity_token
                local cadence_started=profiler and profiler:start()
                local seconds=math.max(settings.repeat_ms/1000,60/current.eligibility.max_repeat_rpm)
                if profiler then profiler:finish('cadence_logic',cadence_started)end
                local begin_started=profiler and profiler:start()
                local changed,reason=backend:begin(row,seconds)
                if profiler then profiler:finish('native_fire_begin',begin_started);profiler:increment('native_fire_begin_calls')end
                if changed==nil then unit_ref=nil;wait_release=true
                    emit('warning','hold_unsupported',{reason=reason});return end
                counters.holds=counters.holds+1
                state:set_repeat(true)
                lease_started=backend.clock_us();lease_repeat_start=counters.repeat_frames
                if trace then trace:record('lease_acquired',{mappings=changed,repeat_ms=seconds*1000,
                    native_retry_ms=(backend.native_repeat_seconds or seconds)*1000,state=state:snapshot()})end
                if settings.debug_logging then emit('info','hold_started',{mappings=changed,repeat_ms=backend.repeat_seconds*1000}) end
            end)
            local elapsed=started and math.max(0,backend.clock_us()-started)
            if held then counters.held_calls=counters.held_calls+1
            else counters.idle_calls=counters.idle_calls+1 end
            if elapsed then
                if held then counters.held_us=counters.held_us+elapsed
                else counters.idle_us=counters.idle_us+elapsed end
            end
            if held and (leased_before or backend.lease) then
                counters.repeat_calls=counters.repeat_calls+1
                if elapsed then
                    counters.repeat_us=counters.repeat_us+elapsed
                    counters.repeat_us_max=math.max(counters.repeat_us_max,elapsed)
                end
            end
            if elapsed then counters.max_us=math.max(counters.max_us,elapsed)end
            if profiler then
                -- Detailed elapsed-time counters only run in profiling mode, avoiding
                -- per-update clock reads in ordinary use.
                profiler:observe('update_tick',elapsed)
            end
            if trace then
                trace:cost(held and 'held_update' or 'idle_update',elapsed)
                if held and (leased_before or backend.lease)then trace:cost('repeat_controller',elapsed)end
            end
            if not ok then fail(why) end
        end
        if IDENTITY_VALIDATED then hook_token=host:on_fire(function()
                local callback_started=backend and backend.clock_us()
                local ok,why=pcall(function()
                    host:read_scope(tick)
                end)
                if not ok then fail(why) end
                if trace and callback_started then
                    trace:cost('callback',backend.clock_us()-callback_started)
                    if backend.clock_us()-last_metrics_us>=5000000 then
                        local diagnostics=host:diagnostics();diagnostics.assist_cache=state:cache_status()
                        trace:summary(diagnostics);host:write_status()
                        last_metrics_us=backend.clock_us()
                    end
                    trace:flush(false)
                end
            end) end
        local initialized={version='1.1.0-rc2',hotkey=settings.toggle_hotkey,
            talon_mode=settings.talon_mode,
            active=state:is_enabled(),mechanism='selective_native_repeat_interval',identity_validated=IDENTITY_VALIDATED}
        if profiler then
            initialized.performance_profile=true;initialized.performance_label=settings.performance_label
            initialized.startup_timing=host.startup_timing and host:startup_timing() or nil
        end
        emit('info','initialized',initialized)
    end)
    if not loaded then fail(load_error);host:stop();error(load_error,0) end
    function consumer:stop()
        local result=host:stop()
        if not result.ok then fail(result.error.detail)end
        if result.ok and installed[host]==self then installed[host]=nil end
        return result
    end
    function consumer:get_state()
        return state and state:snapshot() or {user_enabled=false,weapon={},eligibility={category='REVIEW'},
            identity_valid=false,effective=false,repeat_active=false,reason='consumer_unavailable'}
    end
    function consumer:get_hud_state()return state and state:hud_state() or Hud.project(nil)end
    function consumer:status()return {active=state and state:is_enabled() or false,closed=closed,failed=failed,wait_release=wait_release,
        identity_validated=IDENTITY_VALIDATED,policy_available=policy and policy.available or false,
        assist_state=self:get_state(),counters=counters}end
    installed[host]=consumer
    return consumer
end
return M
