-- Consumer weapon classification table.
-- Exact-build known identities only. Unknown resources cannot grant approval.
-- R-menu and whole-arsenal discovery are deferred.
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
--                             AMR uses AMR_BALANCED_RPM; Talon uses its profile.
--   "native_cap" – allow repeat up to each weapon's actual accepted native rate;
--                  Talon still uses its separately selected profile.
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
-- and the precision support role. Preserve the user-reported live-tested value.
local AMR_BALANCED_RPM = 120

-- Discrete-shot estimate from the pinned heat/cooling snapshot; live behavior
-- remains authoritative because the heat system may be nonlinear.
-- With 15 heat per shot and 10 heat cooled per second, eight shots over
-- seven intervals reach 100 heat at about 210 RPM: 8*15 - 7*(60/210)*10 = 100.
local TALON_BALANCED_RPM = 210
local TALON_EFFICIENCY_RPM = 60
local TALON_FULL_AUTO_RPM = 380
local TALON_FULLER_AUTO_RPM = 750

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
local KNOWN_HASHES={
    ['P-2 Peacemaker']='05e4e5c2db6e44a2',
    ['M6C/SOCOM Pistol']='4d58c77087b774c5',
    ['P-69 Veto']='c780bcd79547da0f',
    ['P-113 Verdict']='1a437158e1b8d2a1',
    ['R-63 Diligence']='03e67a19b07c6523',
    ['R-63CS Diligence Counter Sniper']='4c786785c79d44e7',
    ['R-2 Amendment']='0f83639ab8c86165',
    ['LAS-58 Talon']='416d053372c4e433',
    ['AR-23 Liberator']='968211c0033dce64',
    ['APW-1 Anti-Materiel Rifle']='89c5493e08ca4207',
    ['LAS-99 Quasar Cannon']='35a61296619cc47e',
    ['R-2124 Constitution']='7b75e5132ffd4ca6',
    ['R-6 Deadeye']='e6d932be83729076',
    ['R-4 Hyena']='e5796355a8fd67e0',
    ['R-72 Censor']='f0338468dcdb6a6c',
    ['SG-8 Punisher']='41eac4a03987faa0',
    ['SG-8S Slugger']='4f749e2ee26f532d',
    ['SG-20 Halt']='4e310b1fe4c52b52',
    ['SG-451 Cookout']='d323de60855898ac',
    ['M90A Shotgun']='90ddc374f4e3d756',
    ['SG-225IE Breaker Incendiary']='c12a34f375bd5a87',
    ['CB-9 Exploding Crossbow']='f49227a0630a3f7f',
    ['R-36 Eruptor']='b6aff2195568767f',
    ['SG-8P Punisher Plasma']='05d8d8c073b9d502',
    ['R/40-K Hot-Shot Marksman Rifle']='1abbff60d26ba391',
    ['JAR-5 Dominator']='80f1a156d9fa1e36',
    ['P-4 Senator']='8d3d52a3b2f19402',
    ['P-11 Stim Pistol']='d6b1fb05b9109353',
    ['SG-22 Bushwhacker']='2b28e17ffed05f7c',
    ['P-35 Re-Educator']='0b882808c6f498e8',
    ['P/40-K Bolt Pistol']='dbb6c961c59fadc1',
    ['ARC-12 Blitzer']='076dd5d4f4360204',
}

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
              'Snapshot cap 450 RPM; Balanced 380. Balanced behavior passed user-reported live validation on the reference.' },

    -- ─── SEMI-AUTO RIFLES ────────────────────────────────────────────────

    { kind = 'weapon', name = 'R-63 Diligence',
      category = 'ASSIST', native_cap_rpm = 350, native_cap_status = 'RUNTIME_SNAPSHOT',
      notes = 'Runtime 0.24.0: semi-only [2,0,0], conventional projectile. '..
              'Snapshot cap and Balanced 350 RPM. Balanced behavior passed user-reported live validation on the reference.' },

    { kind = 'weapon', name = 'R-63CS Diligence Counter Sniper',
      category = 'ASSIST', native_cap_rpm = 350, native_cap_status = 'RUNTIME_SNAPSHOT',
      notes = 'Runtime 0.24.0: semi-only [2,0,0], conventional projectile. '..
              'Snapshot cap and Balanced 350 RPM. Balanced behavior passed user-reported live validation on the reference.' },

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

    -- Targeted 0.24.0 authoring/composition snapshot evidence. These entries
    -- use ordinary legal Fire input; accepted gameplay cadence remains pending.
    { kind='weapon', name='R-2124 Constitution', category='ASSIST', native_cap_rpm=60,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family; repeat Fire only. Balanced 60 RPM.' },
    { kind='weapon', name='R-6 Deadeye', category='ASSIST', native_cap_rpm=100,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family; repeat Fire only. Balanced 100 RPM.' },
    { kind='weapon', name='R-4 Hyena', category='ASSIST', native_cap_rpm=190,
      native_cap_status='RUNTIME_SNAPSHOT', balanced_rpm=120,
      notes='Semi-only [2,0,0], native snapshot cap 190 RPM. Balanced 120 RPM gives the weapon time to settle; Full Auto profile uses native cap.' },
    { kind='weapon', name='R-72 Censor', category='ASSIST', native_cap_rpm=400,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile. Balanced 380 RPM.' },
    { kind='weapon', name='SG-8 Punisher', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 80 RPM.' },
    { kind='weapon', name='SG-8S Slugger', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 80 RPM.' },
    { kind='weapon', name='SG-20 Halt', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 80 RPM.' },
    { kind='weapon', name='SG-451 Cookout', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 80 RPM.' },
    { kind='weapon', name='M90A Shotgun', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 80 RPM.' },
    { kind='weapon', name='SG-225IE Breaker Incendiary', category='ASSIST', native_cap_rpm=300,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Burst/semi [3,2,0], conventional projectile. Repeated legal Fire chains native bursts like Amendment; Balanced 300 RPM.' },
    { kind='weapon', name='CB-9 Exploding Crossbow', category='ASSIST', native_cap_rpm=50,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile. Balanced 50 RPM.' },
    { kind='weapon', name='R-36 Eruptor', category='ASSIST', native_cap_rpm=32,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile. Balanced 32 RPM; game controls recovery.' },
    { kind='weapon', name='SG-8P Punisher Plasma', category='ASSIST', native_cap_rpm=80,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile. Balanced 80 RPM.' },
    { kind='weapon', name='R/40-K Hot-Shot Marksman Rifle', category='ASSIST', native_cap_rpm=210,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile. Balanced 210 RPM.' },
    { kind='weapon', name='JAR-5 Dominator', category='ASSIST', native_cap_rpm=250,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi/burst [2,3,0]. Repeated legal Fire chains native bursts like Amendment; Balanced 250 RPM.' },
    { kind='weapon', name='P-4 Senator', category='ASSIST', native_cap_rpm=200,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 200 RPM.' },
    { kind='weapon', name='P-11 Stim Pistol', category='ASSIST', native_cap_rpm=70,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], conventional projectile, rounds-feed family. Balanced 70 RPM.' },
    { kind='weapon', name='SG-22 Bushwhacker', category='ASSIST', native_cap_rpm=650,
      native_cap_status='RUNTIME_SNAPSHOT', balanced_rpm=90,
      notes='Semi-only [2,4,0], ordinary Fire repeats the selected legal mode without changing it. Balanced 90 RPM; Full Auto profile uses native cap.' },
    { kind='weapon', name='P-35 Re-Educator', category='ASSIST', native_cap_rpm=110,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], status-bearing conventional projectile. Balanced 110 RPM.' },
    { kind='weapon', name='P/40-K Bolt Pistol', category='ASSIST', native_cap_rpm=150,
      native_cap_status='RUNTIME_SNAPSHOT', notes='Semi-only [2,0,0], explosive-impact projectile. Balanced 150 RPM.' },

    -- ─── ENERGY PISTOL ───────────────────────────────────────────────────

    { kind = 'weapon', name = 'LAS-58 Talon',
      category = 'ASSIST', native_cap_rpm = 750, native_cap_status = 'VERIFIED',
      balanced_rpm = TALON_BALANCED_RPM,
      notes = 'Semi-auto energy pistol with no native Full Auto. '..
              'Verified 750 RPM native cap. Talon profiles: Balanced 210, Efficiency 60, Full Auto 380, FULLER AUTO 750 RPM.' },

    -- ─── WEAPONS WITH NATIVE FULL AUTO (always ignored) ──────────────────

    { kind = 'weapon', name = 'AR-23 Liberator',
      category = 'IGNORE_NATIVE_AUTO',
      notes = 'Has native Full Auto in R-menu. Never assist.' },
    { kind='weapon', name='ARC-12 Blitzer', category='IGNORE_NATIVE_AUTO',
      notes='Pinned native mode vector [1,0,0] is Full Auto. Unsupported under current policy.' },

    -- ─── SUPPORT WEAPONS ─────────────────────────────────────────────────

    { kind = 'support_weapon', name = 'APW-1 Anti-Materiel Rifle',
      category = 'SPECIAL', native_cap_rpm = 400, native_cap_status = 'VERIFIED',
      balanced_rpm = AMR_BALANCED_RPM,
      notes = 'Extreme recoil, no vanilla third-person reticle, precision role. '..
              'Verified 400 RPM native cap. '..
              'Balanced: '..tostring(AMR_BALANCED_RPM)..' RPM (live-tested Balanced override). '..
              'Native Cap: 400 RPM. Recenter and FULLER AUTO per-weapon UI remain roadmap items.' },

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

local PROFILE_KEYS={
    ['P-2 Peacemaker']='peacemaker_profile',
    ['M6C/SOCOM Pistol']='socom_profile',
    ['P-69 Veto']='veto_profile',
    ['LAS-58 Talon']='talon_profile',
    ['APW-1 Anti-Materiel Rifle']='amr_profile',
    ['R-4 Hyena']='hyena_profile',
    ['SG-22 Bushwhacker']='bushwhacker_profile',
}
local PROFILE_RPMS={
    ['P-2 Peacemaker']={balanced=380,full_auto=900},
    ['M6C/SOCOM Pistol']={balanced=380,full_auto=900},
    ['P-69 Veto']={balanced=380,full_auto=750},
    ['LAS-58 Talon']={balanced=TALON_BALANCED_RPM,efficiency=TALON_EFFICIENCY_RPM,
        full_auto=TALON_FULL_AUTO_RPM,fuller_auto=TALON_FULLER_AUTO_RPM},
    ['APW-1 Anti-Materiel Rifle']={balanced=AMR_BALANCED_RPM,full_auto=400},
    ['R-4 Hyena']={balanced=120,full_auto=190},
    ['SG-22 Bushwhacker']={balanced=90,full_auto=650},
}

function M.new(fire_rate_mode,talon_mode,profile_settings)
    -- fire_rate_mode: 'balanced' (default) | 'native_cap'
    local mode = (fire_rate_mode == 'native_cap') and 'native_cap' or 'balanced'
    local talon_profile=({balanced=true,efficiency=true,full_auto=true,fuller_auto=true})[talon_mode] and talon_mode or 'balanced'
    profile_settings=type(profile_settings)=='table' and profile_settings or {}
    local selected_profiles={}
    for name,key in pairs(PROFILE_KEYS)do
        local selected=profile_settings[key]
        if PROFILE_RPMS[name][selected] then selected_profiles[name]=selected end
    end
    local by_hash, notes = {}, {}
    local self = { available = false, reason = 'known_policy_unavailable', fire_rate_mode = mode }

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
            local selected=selected_profiles[base.name]
            if selected then
                result.repeat_seconds=60/PROFILE_RPMS[base.name][selected]
            elseif base.name=='LAS-58 Talon' then
                local rpm=({balanced=TALON_BALANCED_RPM,efficiency=TALON_EFFICIENCY_RPM,
                    full_auto=TALON_FULL_AUTO_RPM,fuller_auto=TALON_FULLER_AUTO_RPM})[talon_profile]
                result.repeat_seconds=60/rpm
            elseif mode == 'native_cap' then
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
            talon_mode=talon_profile,
            selected_profiles=(function()local out={};for name,profile in pairs(selected_profiles)do out[name]=profile end;return out end)(),
            balanced_ceiling_rpm = BALANCED_CEILING_RPM,
            amr_balanced_rpm = AMR_BALANCED_RPM,
            mapped_resources = count, notes = detached
        }
    end

    self.available=true;self.reason='ready'
    for _,entry in ipairs(ENTRIES)do
        local key=KNOWN_HASHES[entry.name]
        if key then
            assert(M.hash(key) and not by_hash[key],'Malformed or duplicate known weapon')
            local allowed=is_assisted(entry.category)
            by_hash[key]={name=entry.name,semantic_id=entry.kind..':'..entry.name,
                category=entry.category,allowed=allowed,resource_hash=key,
                reason='explicit_consumer_policy',notes=entry.notes,
                native_cap_status=entry.native_cap_status,
                native_cap_rpm=allowed and entry.native_cap_rpm or nil,
                _base=allowed and entry or nil}
        else
            notes[#notes+1]={name=entry.name,category='REVIEW',reason='semantic_identity_not_unique_or_malformed'}
        end
    end

    return self
end

-- Expose constants for tests.
M.BALANCED_CEILING_RPM = BALANCED_CEILING_RPM
M.AMR_BALANCED_RPM     = AMR_BALANCED_RPM
M.TALON_BALANCED_RPM   = TALON_BALANCED_RPM
M.TALON_EFFICIENCY_RPM = TALON_EFFICIENCY_RPM
M.TALON_FULL_AUTO_RPM = TALON_FULL_AUTO_RPM
M.TALON_FULLER_AUTO_RPM = TALON_FULLER_AUTO_RPM

return M
