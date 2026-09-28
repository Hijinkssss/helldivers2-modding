-- Consumer weapon classification table.
-- Metadata can veto approval; it can never grant approval.
-- Policy categories:
--   ASSIST               eligible for Full Auto Assist
--   IGNORE_NATIVE_AUTO   weapon already has native Full Auto in the R-menu; never assist
--   EXCLUDE_CHARGE_HOLD   charge/hold weapon; hold-to-fire is inherent, repeated Fire assist incompatible
--   SPECIAL              special-case weapon with per-weapon tuning (e.g. AMR)
--   REVIEW               unresolved or ambiguous; fail closed (no assist)
-- Unknown/unrecognised weapons always fail closed (no assist).
--
-- Fire-rate modes (fire_rate_mode setting):
--   "balanced"   (default) – clamp repeat interval to at most BALANCED_CEILING_RPM.
--                             AMR uses AMR_BALANCED_RPM instead of the generic ceiling.
--   "native_cap" – allow repeat up to each weapon's actual accepted native rate.
--
-- RPM -> seconds: interval_s = 60 / rpm
--
-- native_cap_rpm verification key (per entry):
--   VERIFIED   confirmed by user from live game observation
--   RUNTIME_SNAPSHOT confirmed by reviewed current-build Runtime metadata;
--                    accepted live shot cadence still requires validation
--   UNRESOLVED placeholder value; must be confirmed before release
--              UNRESOLVED entries must NOT be tested for specific native-cap values.

local M = {}

-- Generic Balanced ceiling: 380 RPM ~= 157.9 ms interval.
-- Chosen as a plausible trained rapid-manual ceiling without turning
-- high-cap semi-auto weapons into pseudo-SMGs.
local BALANCED_CEILING_RPM = 380

-- AMR Balanced override: 120 RPM ~= 500 ms interval.
-- Conservative because of extreme recoil, no vanilla third-person reticle,
-- and the precision support role. Provisional; refine after gameplay testing.
local AMR_BALANCED_RPM = 120

-- Battery-efficiency candidate; heat-neutral operation is not established.
local TALON_BALANCED_RPM = 60

-- Derive the interval (seconds) for a given entry and fire_rate_mode.
local function resolve_interval(entry, fire_rate_mode)
    local native_rpm = entry.native_cap_rpm
    if fire_rate_mode == 'native_cap' then
        return 60 / native_rpm
    end
    if entry.balanced_rpm then
        return 60 / entry.balanced_rpm
    end
    local rpm = math.min(native_rpm, BALANCED_CEILING_RPM)
    return 60 / rpm
end

-- Classification table.
-- All fields:
--   kind              'weapon' | 'support_weapon'
--   name              exact in-game name string
--   category          ASSIST | IGNORE_NATIVE_AUTO | EXCLUDE_CHARGE_HOLD | SPECIAL | REVIEW
--   native_cap_rpm    accepted maximum fire rate from the game (native cap).
--                     Required for ASSIST and SPECIAL. See verification comment per entry.
--   native_cap_status 'VERIFIED' | 'RUNTIME_SNAPSHOT' | 'UNRESOLVED'
--   balanced_rpm      (optional) explicit Balanced override; omit to use generic ceiling.
--   notes             (optional) human-readable annotation.
local ENTRIES = {
    -- ─── SEMI-AUTO PISTOLS ────────────────────────────────────────────────

    { kind = 'weapon', name = 'P-2 Peacemaker',
      category = 'ASSIST', native_cap_rpm = 900, native_cap_status = 'VERIFIED',
      notes = 'Verified 900 RPM native cap. Balanced clamps to 380 RPM.' },

    { kind = 'weapon', name = 'M6C/SOCOM Pistol',
      category = 'ASSIST', native_cap_rpm = 900, native_cap_status = 'VERIFIED',
      notes = 'Verified 900 RPM native cap. Balanced clamps to 380 RPM.' },

    { kind = 'weapon', name = 'P-69 Veto',
      category = 'ASSIST', native_cap_rpm = 750, native_cap_status = 'VERIFIED',
      notes = 'Verified 750 RPM native cap. Balanced clamps to 380 RPM.' },

    { kind = 'weapon', name = 'P-113 Verdict',
      category = 'ASSIST', native_cap_rpm = 450, native_cap_status = 'RUNTIME_SNAPSHOT',
      notes = 'Runtime 0.24.0: semi-only [2,0,0], conventional projectile. '..
              'Snapshot cap 450 RPM; Balanced 380. Live cadence pending.' },

    -- ─── SEMI-AUTO RIFLES ────────────────────────────────────────────────

    { kind = 'weapon', name = 'R-63 Diligence',
      category = 'ASSIST', native_cap_rpm = 350, native_cap_status = 'RUNTIME_SNAPSHOT',
      notes = 'Runtime 0.24.0: semi-only [2,0,0], conventional projectile. '..
              'Snapshot cap and Balanced 350 RPM. Live cadence pending.' },

    { kind = 'weapon', name = 'R-63CS Diligence Counter Sniper',
      category = 'ASSIST', native_cap_rpm = 350, native_cap_status = 'RUNTIME_SNAPSHOT',
      notes = 'Runtime 0.24.0: semi-only [2,0,0], conventional projectile. '..
              'Snapshot cap and Balanced 350 RPM. Live cadence pending.' },

    -- ─── BURST-FIRE ───────────────────────────────────────────────────────
    -- Burst weapons without native Full Auto are eligible.
    -- Repeated Fire presses simply chain the next legal burst; no artificial
    -- burst gap is inserted. The game remains authoritative over burst size
    -- and cadence. The assist interval governs how quickly the next Fire press
    -- is delivered after the previous burst input, not burst internals.
    { kind = 'weapon', name = 'R-2 Amendment',
      category = 'ASSIST', native_cap_rpm = 480, native_cap_status = 'VERIFIED',
      notes = 'Semi/burst modes; no native Full Auto. Verified 480 RPM native cap. '..
              'Balanced clamps to 380 RPM (480 > 380 ceiling).' },

    -- ─── ENERGY PISTOL ───────────────────────────────────────────────────

    { kind = 'weapon', name = 'LAS-58 Talon',
      category = 'ASSIST', native_cap_rpm = 750, native_cap_status = 'VERIFIED',
      balanced_rpm = TALON_BALANCED_RPM,
      notes = 'Semi-auto energy pistol with no native Full Auto. '..
              'Verified 750 RPM native cap. Balanced 60 RPM battery-efficiency candidate; live follow-up required.' },

    -- ─── WEAPONS WITH NATIVE FULL AUTO (always ignored) ──────────────────

    { kind = 'weapon', name = 'AR-23 Liberator',
      category = 'IGNORE_NATIVE_AUTO',
      notes = 'Has native Full Auto in R-menu. Never assist.' },

    -- ─── SUPPORT WEAPONS ─────────────────────────────────────────────────

    { kind = 'support_weapon', name = 'APW-1 Anti-Materiel Rifle',
      category = 'SPECIAL', native_cap_rpm = 400, native_cap_status = 'VERIFIED',
      balanced_rpm = AMR_BALANCED_RPM,
      notes = 'Extreme recoil, no vanilla third-person reticle, precision role. '..
              'Verified 400 RPM native cap. '..
              'Balanced: '..tostring(AMR_BALANCED_RPM)..' RPM (provisional special override). '..
              'Native Cap: 400 RPM. Refine Balanced value after live gameplay testing.' },

    { kind = 'support_weapon', name = 'LAS-99 Quasar Cannon',
      category = 'EXCLUDE_CHARGE_HOLD',
      notes = 'Charge/hold weapon; hold-to-fire input is inherent and not compatible with repeated Fire assist.' },

    { kind = 'support_weapon', name = 'LAS-98 Laser Cannon',
      category = 'IGNORE_NATIVE_AUTO',
      notes = 'Continuous beam; native auto behavior. Never assist.' },
}

function M.hash(value)
    if type(value) ~= 'string' then return nil end
    value = value:lower():gsub('^0x', '')
    if #value ~= 16 or value:find('[^0-9a-f]') then return nil end
    return value
end

local function single(values)
    if type(values) ~= 'table' or values[1] == nil then return false end
    for key in pairs(values) do if key ~= 1 then return false end end
    return true
end

local function copy(entry)
    local result = {}
    for key, value in pairs(entry) do result[key] = value end
    return result
end

-- Compute the Balanced repeat interval for an entry (seconds).
local function balanced_interval(entry)
    if entry.balanced_rpm then
        return 60 / entry.balanced_rpm
    end
    local rpm = math.min(entry.native_cap_rpm, BALANCED_CEILING_RPM)
    return 60 / rpm
end

-- Compute the Native Cap repeat interval for an entry (seconds).
local function native_interval(entry)
    return 60 / entry.native_cap_rpm
end

-- Whether the category is actively assisted (ASSIST or SPECIAL).
local function is_assisted(category)
    return category == 'ASSIST' or category == 'SPECIAL'
end

function M.new(bridge, fire_rate_mode)
    -- fire_rate_mode: 'balanced' (default) | 'native_cap'
    local mode = (fire_rate_mode == 'native_cap') and 'native_cap' or 'balanced'
    local by_hash, notes = {}, {}
    local self = { available = false, reason = 'optional_runtime_bridge_unavailable', fire_rate_mode = mode }

    function self:classify(resource_hash)
        local key = M.hash(resource_hash)
        local entry = key and by_hash[key]
        if not entry then
            return { category = 'REVIEW', allowed = false, reason = 'unknown_or_unrecognised_weapon' }
        end
        -- Compute runtime repeat interval from stored base entry + current mode.
        local result = copy(entry)
        if is_assisted(result.category) and result._base then
            local base = result._base
            if mode == 'native_cap' then
                result.repeat_seconds = native_interval(base)
            else
                result.repeat_seconds = balanced_interval(base)
            end
            result.repeat_ms = math.floor(result.repeat_seconds * 1000 + 0.5)
            -- max_repeat_rpm kept for consumers that still read it.
            result.max_repeat_rpm = math.floor(60 / result.repeat_seconds + 0.5)
            result._base = nil -- do not expose internal reference
        end
        return result
    end

    function self:status()
        local count = 0
        for _ in pairs(by_hash) do count = count + 1 end
        local detached = {}
        for i, note in ipairs(notes) do detached[i] = copy(note) end
        return {
            available = self.available, reason = self.reason,
            fire_rate_mode = mode,
            balanced_ceiling_rpm = BALANCED_CEILING_RPM,
            amr_balanced_rpm = AMR_BALANCED_RPM,
            mapped_resources = count, notes = detached
        }
    end

    if type(bridge) ~= 'table' or type(bridge.Connect) ~= 'function' or
       type(bridge.Target) ~= 'function' then return self end

    local connected, result = pcall(bridge.Connect, bridge)
    if not connected or type(result) ~= 'table' or result.ok ~= true then
        self.reason = 'runtime_unavailable'; return self
    end

    self.available = true; self.reason = 'ready'

    for _, entry in ipairs(ENTRIES) do
        local ok, metadata, modes = pcall(function()
            local result = bridge:Target(entry.kind, entry.name)
            assert(type(result) == 'table' and result.ok == true and
                   type(result.value) == 'table', 'Target unavailable')
            local target = result.value
            return target:describe(),
                   type(target.fire_modes) == 'function' and target:fire_modes() or nil
        end)

        local resources = ok and type(metadata) == 'table' and
                          (metadata.resources or metadata.resourceHashes)
        local identity  = ok and type(metadata) == 'table' and
                          (metadata.name or metadata.catalogIdentity)

        if not single(resources) or not M.hash(resources[1]) or identity ~= entry.name then
            notes[#notes + 1] = {
                name = entry.name, category = 'REVIEW',
                reason = 'semantic_identity_not_unique_or_malformed'
            }
        else
            local key      = M.hash(resources[1])
            local category = entry.category
            local reason   = 'explicit_consumer_policy'

            -- Support weapons get extra identity checks.
            if entry.kind == 'support_weapon' and
               (metadata.identityResolution ~= 'UNIQUE' or
                M.hash(metadata.canonicalResourceHash) ~= key) then
                category = 'REVIEW'; reason = 'semantic_identity_not_unique'
            end

            -- ASSIST and SPECIAL: verify the weapon is NOT natively full-auto
            -- and that repeated Fire alone continues firing.
            if is_assisted(category) then
                local valid_fire_modes = false
                if type(modes) == 'table' then
                    local semantics = modes.defaultModeSemantics
                    local allowed   = modes.allowedModes
                    local vector    = modes.nativeModeVector
                    local mode_id = semantics == 'semi_auto' and 2 or
                                    semantics == 'burst_fire' and 3 or nil
                    -- Runtime allowedModes filters the native vector. Check both;
                    -- only the explicitly approved Amendment may retain semi/burst.
                    local valid_vector = type(vector) == 'table' and vector[1] == mode_id and
                        vector[2] == 0 and vector[3] == 0
                    if entry.name == 'R-2 Amendment' and type(vector) == 'table' then
                        valid_vector = vector[1] == mode_id and vector[2] == 3 and vector[3] == 0
                    end
                    if type(vector) == 'table' then
                        for key in pairs(vector) do
                            if key ~= 1 and key ~= 2 and key ~= 3 then valid_vector = false end
                        end
                    end
                    valid_fire_modes = mode_id ~= nil and single(allowed) and
                        allowed[1] == mode_id and valid_vector
                elseif entry.category == 'SPECIAL' then
                    valid_fire_modes = (modes == nil or modes == false)
                end
                if not valid_fire_modes then
                    category = 'REVIEW'; reason = 'fire_mode_check_failed_or_native_auto_detected'
                end
            end

            if by_hash[key] then
                by_hash[key] = { category = 'REVIEW', allowed = false, reason = 'semantic_hash_collision' }
            else
                local allowed_flag = is_assisted(category)
                local record = {
                    name = identity,
                    semantic_id = entry.kind .. ':' .. identity,
                    category = category,
                    allowed = allowed_flag,
                    resource_hash = key,
                    reason = reason,
                    notes = entry.notes,
                    native_cap_status = entry.native_cap_status,
                }
                if allowed_flag then
                    record._base = entry
                    if mode == 'native_cap' then
                        record.repeat_seconds = native_interval(entry)
                    else
                        record.repeat_seconds = balanced_interval(entry)
                    end
                    record.repeat_ms = math.floor(record.repeat_seconds * 1000 + 0.5)
                    record.max_repeat_rpm = math.floor(60 / record.repeat_seconds + 0.5)
                    record.native_cap_rpm = entry.native_cap_rpm
                end
                by_hash[key] = record
            end
        end
    end

    return self
end

-- Expose constants for tests.
M.BALANCED_CEILING_RPM = BALANCED_CEILING_RPM
M.AMR_BALANCED_RPM     = AMR_BALANCED_RPM
M.TALON_BALANCED_RPM   = TALON_BALANCED_RPM

return M
