-- Offline tests for the weapon policy classification table and fire-rate modes.
-- Validates all required cases from the weapon policy specification.
-- No live game access; uses policy_host.lua fixtures only.
local Policy = require('weapon_policy')

-- ── Helpers ─────────────────────────────────────────────────────────────────

local function approx(a, b, tol)
    tol = tol or 0.001
    return math.abs(a - b) <= tol
end

local function rpm_to_s(rpm)
    return 60 / rpm
end

local function check(label, ok, detail)
    if not ok then
        error('FAIL: ' .. label .. (detail and (' | ' .. tostring(detail)) or ''))
    end
end

-- ── Build a policy with the synthetic bridge ─────────────────────────────────

local function make(mode)
    local bridge = policy_fixture()
    return Policy.new(bridge, mode)
end

-- ── 1. Generic fail-closed: unknown weapon ────────────────────────────────────

local p_balanced = make('balanced')
local unknown = p_balanced:classify('ffffffffffffffff')
check('unknown_no_assist', not unknown.allowed)
check('unknown_category_review', unknown.category == 'REVIEW')
check('unknown_reason', unknown.reason == 'unknown_or_unrecognised_weapon')

-- ── 2. IGNORE_NATIVE_AUTO: AR-23 Liberator ───────────────────────────────────

local liberator = p_balanced:classify('968211c0033dce64')
check('liberator_not_allowed',   not liberator.allowed)
check('liberator_ignore_native', liberator.category == 'IGNORE_NATIVE_AUTO')

-- ── 3. EXCLUDE: LAS-99 Quasar Cannon ─────────────────────────────────────────

local quasar = p_balanced:classify('35a61296619cc47e')
check('quasar_not_allowed',  not quasar.allowed)
check('quasar_exclude',      quasar.category == 'EXCLUDE_MANUAL_RELOAD')

-- ── 4. Peacemaker – Balanced -> 380 RPM ──────────────────────────────────────

local pm = p_balanced:classify('05e4e5c2db6e44a2')
check('pm_allowed',          pm.allowed)
check('pm_category_assist',  pm.category == 'ASSIST')
check('pm_balanced_rpm',     pm.max_repeat_rpm == 380,
      'got ' .. tostring(pm.max_repeat_rpm))
check('pm_balanced_seconds', approx(pm.repeat_seconds, rpm_to_s(380)),
      'got ' .. tostring(pm.repeat_seconds))

-- ── 5. Peacemaker – Native Cap ────────────────────────────────────────────────

local p_native = make('native_cap')
local pm_native = p_native:classify('05e4e5c2db6e44a2')
check('pm_native_allowed',      pm_native.allowed)
check('pm_native_rpm',          pm_native.max_repeat_rpm == 480,
      'got ' .. tostring(pm_native.max_repeat_rpm))
check('pm_native_seconds',      approx(pm_native.repeat_seconds, rpm_to_s(480)),
      'got ' .. tostring(pm_native.repeat_seconds))

-- ── 6. SOCOM – Balanced -> 380 RPM ───────────────────────────────────────────

local socom = p_balanced:classify('aaaaaaaaaaaa0001')
check('socom_allowed',         socom.allowed,         'SOCOM not ASSIST: ' .. tostring(socom.category) .. ' / ' .. tostring(socom.reason))
check('socom_balanced_380',    socom.max_repeat_rpm == 380,
      'got ' .. tostring(socom.max_repeat_rpm))

-- ── 7. Veto – Balanced -> 380 RPM ────────────────────────────────────────────

local veto = p_balanced:classify('aaaaaaaaaaaa0002')
check('veto_allowed',          veto.allowed,          'Veto not ASSIST: ' .. tostring(veto.category) .. ' / ' .. tostring(veto.reason))
check('veto_balanced_380',     veto.max_repeat_rpm == 380,
      'got ' .. tostring(veto.max_repeat_rpm))

-- ── 8. Talon – Balanced -> 380 RPM ───────────────────────────────────────────

local talon = p_balanced:classify('aaaaaaaaaaaa0003')
check('talon_allowed',         talon.allowed,         'Talon not ASSIST: ' .. tostring(talon.category) .. ' / ' .. tostring(talon.reason))
check('talon_balanced_380',    talon.max_repeat_rpm == 380,
      'got ' .. tostring(talon.max_repeat_rpm))

-- ── 9. Amendment – eligible, burst-fire, Balanced ────────────────────────────
-- native_cap_rpm = 300, which is already below 380, so Balanced == 300.

local amendment = p_balanced:classify('0f83639ab8c86165')
check('amendment_allowed',      amendment.allowed,     'Amendment not ASSIST')
check('amendment_category',     amendment.category == 'ASSIST')
check('amendment_balanced_rpm', amendment.max_repeat_rpm == 300,
      'got ' .. tostring(amendment.max_repeat_rpm) .. ' (expected 300, cap below ceiling)')
check('amendment_balanced_s',   approx(amendment.repeat_seconds, rpm_to_s(300)),
      'got ' .. tostring(amendment.repeat_seconds))

-- Amendment Native Cap (same value – native cap IS 300, below ceiling)
local amendment_native = p_native:classify('0f83639ab8c86165')
check('amendment_native_rpm', amendment_native.max_repeat_rpm == 300,
      'got ' .. tostring(amendment_native.max_repeat_rpm))

-- ── 10. AMR – SPECIAL, Balanced -> 120 RPM ───────────────────────────────────

local amr = p_balanced:classify('89c5493e08ca4207')
check('amr_allowed',           amr.allowed,           'AMR not allowed')
check('amr_category_special',  amr.category == 'SPECIAL')
check('amr_balanced_rpm',      amr.max_repeat_rpm == Policy.AMR_BALANCED_RPM,
      'got ' .. tostring(amr.max_repeat_rpm) .. ' expected ' .. Policy.AMR_BALANCED_RPM)
check('amr_balanced_seconds',  approx(amr.repeat_seconds, rpm_to_s(Policy.AMR_BALANCED_RPM)),
      'got ' .. tostring(amr.repeat_seconds))

-- AMR Native Cap
local amr_native = p_native:classify('89c5493e08ca4207')
check('amr_native_allowed',    amr_native.allowed)
-- Native cap for AMR is 60 RPM
check('amr_native_rpm',        amr_native.max_repeat_rpm == 60,
      'got ' .. tostring(amr_native.max_repeat_rpm))
check('amr_native_seconds',    approx(amr_native.repeat_seconds, rpm_to_s(60)),
      'got ' .. tostring(amr_native.repeat_seconds))

-- ── 11. REVIEW weapons fail closed ───────────────────────────────────────────

-- P-113 Verdict
local verdict = p_balanced:classify('aaaaaaaaaaaa0004')
check('verdict_not_allowed', not verdict.allowed)
check('verdict_review',      verdict.category == 'REVIEW')

-- ── 12. Classify never mutates internal state ─────────────────────────────────

local pm2 = p_balanced:classify('05e4e5c2db6e44a2')
pm2.max_repeat_rpm = 9999
local pm3 = p_balanced:classify('05e4e5c2db6e44a2')
check('classify_copy_detached', pm3.max_repeat_rpm == 380,
      'classify leaked mutable reference')

-- ── 13. Balanced ceiling constant exposed ────────────────────────────────────

check('ceiling_constant', Policy.BALANCED_CEILING_RPM == 380)
check('amr_constant',     Policy.AMR_BALANCED_RPM == 120)

-- ── 14. fire_rate_mode recorded on status ────────────────────────────────────

local status_b = p_balanced:status()
local status_n = p_native:status()
check('status_balanced_mode',    status_b.fire_rate_mode == 'balanced')
check('status_native_mode',      status_n.fire_rate_mode == 'native_cap')
check('status_ceiling_present',  status_b.balanced_ceiling_rpm == 380)
check('status_amr_rpm_present',  status_b.amr_balanced_rpm == 120)

-- ── All checks passed ─────────────────────────────────────────────────────────
print('test_weapon_policy_v2: all checks passed')
