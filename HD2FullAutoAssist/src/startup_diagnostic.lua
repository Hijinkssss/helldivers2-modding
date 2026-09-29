-- RC8 diagnostic only. Never feeds observations back into controller decisions.
local Json=require('validation_trace')
local M={}
local function value(v)if v==nil then return 'unavailable' end;return v end
function M.new(host,collect)
    local self={sequence=0,errors=0,begin_count=0,begin_result='not_attempted',
        begin_reason='none',restore_count=0,restore_reason='none',first_toggle_source='none'}
    local seen,last={},{}
    local function snapshot(event,detail)
        local s=collect();local b=s.backend;local row=s.row or {}
        local good,e=pcall(host.eligibility,host)
        local result=good and type(e)=='table' and e or {}
        local allowed=result.ok and result.value or {}
        local current=s.state or {};local w=current.weapon or {};local policy=current.eligibility or {}
        local runtime=host.activation_status and host:activation_status() or {}
        local fields={phase=event,detail=detail or {},state=current,
            user_enabled=value(current.user_enabled),effective=value(current.effective),
            identity_valid=value(current.identity_valid),identity_observed=value(current.identity_observed),
            reason=value(current.reason),revision=value(current.revision),repeat_active=value(current.repeat_active),
            wait_release=s.wait_release,weapon_name=value(w.name),resource_hash=value(w.resource_hash),
            entity_id=value(w.entity_id),avatar_id=value(w.avatar_id),player_unit_ref=value(w.unit_ref),
            category=value(policy.category),max_repeat_rpm=value(policy.max_repeat_rpm),
            backend_initialized=b~=nil,lease_active=b~=nil and b.lease~=nil,
            unit_ref=value(s.unit_ref),leased_entity_id=value(s.leased_entity_id),
            leased_resource_hash=value(s.leased_resource_hash),native_input_inspected=s.inspected,
            eligibility_ok=result.ok==true,eligibility_allowed=value(allowed.allowed),
            eligibility_reason=value(allowed.reason),eligibility_error=value(result.error or (not good and tostring(e) or nil)),
            sample_available=s.row~=nil,fire_held=value(row.held),fire_pressed=value(row.pressed),
            trigger=value(row.trigger),gameplay=value(row.gameplay),game_state=value(row.game_state),
            sampled_unit_ref=value(row.unit_ref),mapping_index=value(row.mapping_index),raw_lmb_down=value(row.raw_lmb_down),
            begin_attempted=self.begin_count>0,begin_count=self.begin_count,begin_result=self.begin_result,
            begin_reason=self.begin_reason,restore_count=self.restore_count,restore_reason=self.restore_reason,
            toggles=s.counters.toggles,toggle_rejected=s.counters.toggle_rejected,
            first_toggle_source=self.first_toggle_source,runtime=runtime,
            mapping_writes=b and b.writes or 0,mapping_restored=b and b.restored or 0,
            diagnostic_errors=self.errors}
        -- Read-only fresh native context, separate from the controller's last sample.
        -- Failure is diagnostic data, never a controller failure or input guard.
        if b and b.diagnostic then
            local ok,context=pcall(b.diagnostic,b)
            fields.native={ok=ok,value=ok and context or tostring(context)}
        end
        return fields
    end
    function self:record(event,detail,mode)
        -- Bound noisy transitions; reserve forced records for toggles/first phases.
        if mode=='once' and seen[event] then return end
        if self.sequence>=600 and mode~='force' and mode~='once' then return end
        local ok,why=pcall(function()
            local fields=snapshot(event,detail)
            if mode=='change' then
                -- Ignore per-frame revisions, repeat pulses, counters and clock.
                local key=Json.json({fields.user_enabled,fields.effective,fields.identity_valid,
                    fields.identity_observed,fields.reason,fields.wait_release,fields.resource_hash,
                    fields.entity_id,fields.avatar_id,fields.player_unit_ref,fields.lease_active,
                    fields.eligibility_ok,fields.eligibility_allowed,fields.eligibility_reason,
                    fields.fire_held,fields.raw_lmb_down,fields.gameplay,fields.sample_available,
                    fields.native and fields.native.ok and fields.native.value.sample and fields.native.value.sample.game_state,
                    fields.runtime.binding_registration,fields.runtime.armed,
                    fields.begin_result,fields.begin_reason,detail})
                if last[event]==key then return end;last[event]=key
            end
            seen[event]=true;self.sequence=self.sequence+1;fields.sequence=self.sequence
            fields.t_us=host.platform and host.platform:clock_us() or 0
            host:log('info','startup_diagnostic',fields)
            local native=fields.native and fields.native.ok and fields.native.value.sample
            if native and native.game_state~=nil then
                local phase=native.game_state==4 and 'C_mission_active' or 'B_ship_or_pre_mission'
                if not seen[phase] then
                    seen[phase]=true;self.sequence=self.sequence+1
                    fields.phase=phase;fields.sequence=self.sequence
                    host:log('info','startup_diagnostic',fields)
                end
            end
        end)
        if not ok then self.errors=self.errors+1 end
    end
    local next_poll,previous_held=0,nil
    function self:poll()
        local ok=pcall(function()
        local s=collect();local b=s.backend
        local now=b and b.clock_us() or 0
        local held=s.row and s.row.held
        if now<next_poll and held==previous_held then return end
        next_poll=now+100000;previous_held=held
        self:record('runtime_transition',nil,'change')
        end)
        if not ok then self.errors=self.errors+1 end
    end
    return self
end
return M
