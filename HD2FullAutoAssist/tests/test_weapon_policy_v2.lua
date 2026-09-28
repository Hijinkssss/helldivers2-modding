-- Offline tests for the weapon policy classification table and fire-rate modes.
-- All resource hashes match selective-checks.json runtime metadata (authoritative).
-- native_cap_rpm values marked VERIFIED use user-confirmed figures.
-- native_cap_rpm values marked UNRESOLVED are not tested for their exact value.
-- No live game access; uses policy_host.lua fixtures only.
local Policy = require('weapon_policy')

-- ── Helpers ─────────────────────────────────────────────────────────────────

local function approx(a, b, tol)
    tol = tol or 0.5  -- within 0.5 RPM (rounding from floor)
    return math.abs(a - b) <= tol
end

local function approx_s(a, b, tol)
    tol = tol or 0.001  -- within 1 ms
    return math.abs(a - b) <= tol
end

local function rpm_to_s(rpm) return 60 / rpm end
local function s_to_rpm(s)   return 60 / s   end

local function check(label, ok, detail)
    if not ok then
        error('FAIL: ' .. label .. (detail and (' | ' .. tostring(detail)) or ''))
    end
end

-- ── Build policies with the real-hash fixture ─────────────────────────────────

local function make(mode)
    local bridge = policy_fixture()
    return Policy.new(bridge, mode)
end

local p_balanced = make('balanced')
local p_native   = make('native_cap')

-- ── 1. Fail-closed: unknown weapon ───────────────────────────────────────────

local unknown = p_balanced:classify('ffffffffffffffff')
check('unknown_no_assist',      not unknown.allowed)
check('unknown_category_review', unknown.category == 'REVIEW')
check('unknown_reason',          unknown.reason == 'unknown_or_unrecognised_weapon')

-- ── 2. IGNORE_NATIVE_AUTO: AR-23 Liberator ───────────────────────────────────
-- Hash: 968211c0033dce64 (from runtime metadata)

local liberator = p_balanced:classify('968211c0033dce64')
check('liberator_not_allowed',   not liberator.allowed)
check('liberator_ignore_native', liberator.category == 'IGNORE_NATIVE_AUTO')

-- ── 3. EXCLUDE: LAS-99 Quasar Cannon ─────────────────────────────────────────
-- Hash: 35a61296619cc47e (from runtime metadata)

local quasar = p_balanced:classify('35a61296619cc47e')
check('quasar_not_allowed',  not quasar.allowed)
check('quasar_exclude',      quasar.category == 'EXCLUDE_MANUAL_RELOAD')

-- ── 4. P-2 Peacemaker – Balanced -> 380 RPM (VERIFIED: 900 RPM native) ───────
-- Hash: 05e4e5c2db6e44a2 (from runtime metadata)

local pm = p_balanced:classify('05e4e5c2db6e44a2')
check('pm_allowed',          pm.allowed)
check('pm_category_assist',  pm.category == 'ASSIST')
-- Balanced: min(900, 380) = 380
check('pm_balanced_rpm',     approx(pm.max_repeat_rpm, 380),
      'got ' .. tostring(pm.max_repeat_rpm) .. ' want 380')
check('pm_balanced_seconds', approx_s(pm.repeat_seconds, rpm_to_s(380)),
      'got ' .. tostring(pm.repeat_seconds))
check('pm_verified_status',  pm.native_cap_status == 'VERIFIED')

-- ── 5. P-2 Peacemaker – Native Cap -> 900 RPM (VERIFIED) ─────────────────────

local pm_native = p_native:classify('05e4e5c2db6e44a2')
check('pm_native_allowed',  pm_native.allowed)
-- Native cap: 900 RPM verified
check('pm_native_rpm',      approx(pm_native.max_repeat_rpm, 900),
      'got ' .. tostring(pm_native.max_repeat_rpm) .. ' want 900')
check('pm_native_seconds',  approx_s(pm_native.repeat_seconds, rpm_to_s(900)),
      'got ' .. tostring(pm_native.repeat_seconds))
check('pm_native_cap_rpm',  pm_native.native_cap_rpm == 900,
      'got ' .. tostring(pm_native.native_cap_rpm))

-- ── 6. M6C/SOCOM Pistol – Balanced -> 380 RPM (UNRESOLVED native cap) ────────
-- Hash: 4d58c77087b774c5 (from runtime metadata)
-- Native cap NOT tested (UNRESOLVED). Only Balanced = 380 is asserted.

local socom = p_balanced:classify('4d58c77087b774c5')
check('socom_allowed',           socom.allowed,
      'SOCOM not ASSIST: '..tostring(socom.category)..'/'..tostring(socom.reason))
check('socom_category_assist',   socom.category == 'ASSIST')
-- Balanced: min(placeholder, 380) = 380 (placeholder is safely > 380)
check('socom_balanced_380',      approx(socom.max_repeat_rpm, 380),
      'got ' .. tostring(socom.max_repeat_rpm))
-- Status confirms this needs verification before release.
check('socom_unresolved_status', socom.native_cap_status == 'UNRESOLVED')
-- Deliberate: do NOT assert socom native cap value here.

-- ── 7. P-69 Veto – Balanced -> 380 RPM (VERIFIED: 750 RPM native) ────────────
-- Hash: c780bcd79547da0f (from runtime metadata)

local veto = p_balanced:classify('c780bcd79547da0f')
check('veto_allowed',         veto.allowed,
      'Veto not ASSIST: '..tostring(veto.category)..'/'..tostring(veto.reason))
-- Balanced: min(750, 380) = 380
check('veto_balanced_380',    approx(veto.max_repeat_rpm, 380),
      'got '..tostring(veto.max_repeat_rpm))
check('veto_verified_status', veto.native_cap_status == 'VERIFIED')

-- Veto Native Cap -> 750 RPM (VERIFIED)
local veto_native = p_native:classify('c780bcd79547da0f')
check('veto_native_rpm',      approx(veto_native.max_repeat_rpm, 750),
      'got '..tostring(veto_native.max_repeat_rpm)..' want 750')
check('veto_native_cap_rpm',  veto_native.native_cap_rpm == 750)

-- ── 8. LAS-58 Talon – Balanced -> 380 RPM (VERIFIED: 750 RPM native) ─────────
-- Hash: 416d053372c4e433 (from runtime metadata)

local talon = p_balanced:classify('416d053372c4e433')
check('talon_allowed',         talon.allowed,
      'Talon not ASSIST: '..tostring(talon.category)..'/'..tostring(talon.reason))
-- Balanced: min(750, 380) = 380
check('talon_balanced_380',    approx(talon.max_repeat_rpm, 380),
      'got '..tostring(talon.max_repeat_rpm))
check('talon_verified_status', talon.native_cap_status == 'VERIFIED')

-- Talon Native Cap -> 750 RPM (VERIFIED)
local talon_native = p_native:classify('416d053372c4e433')
check('talon_native_rpm',     approx(talon_native.max_repeat_rpm, 750),
      'got '..tostring(talon_native.max_repeat_rpm)..' want 750')
check('talon_native_cap_rpm', talon_native.native_cap_rpm == 750)

-- ── 9. R-2 Amendment – Balanced -> 380 RPM (VERIFIED: 480 RPM native) ────────
-- Hash: 0f83639ab8c86165 (from runtime metadata)
-- Burst-fire; no native Full Auto; 480 RPM native > 380 ceiling.

local amendment = p_balanced:classify('0f83639ab8c86165')
check('amendment_allowed',       amendment.allowed,
      'Amendment not ASSIST: '..tostring(amendment.category)..'/'..tostring(amendment.reason))
check('amendment_category',      amendment.category == 'ASSIST')
-- Balanced: min(480, 380) = 380
check('amendment_balanced_380',  approx(amendment.max_repeat_rpm, 380),
      'got '..tostring(amendment.max_repeat_rpm)..' want 380')
check('amendment_balanced_s',    approx_s(amendment.repeat_seconds, rpm_to_s(380)),
      'got '..tostring(amendment.repeat_seconds))
check('amendment_verified',      amendment.native_cap_status == 'VERIFIED')

-- Amendment Native Cap -> 480 RPM (VERIFIED)
local amendment_native = p_native:classify('0f83639ab8c86165')
check('amendment_native_allowed', amendment_native.allowed)
check('amendment_native_rpm',     approx(amendment_native.max_repeat_rpm, 480),
      'got '..tostring(amendment_native.max_repeat_rpm)..' want 480')
check('amendment_native_cap_rpm', amendment_native.native_cap_rpm == 480)

-- ── 10. APW-1 AMR – Balanced -> 120 RPM special override (VERIFIED: 400 native)
-- Hash: 89c5493e08ca4207 (from runtime metadata)

local amr = p_balanced:classify('89c5493e08ca4207')
check('amr_allowed',          amr.allowed, 'AMR not allowed: '..tostring(amr.category))
check('amr_category_special', amr.category == 'SPECIAL')
-- Balanced: explicit override 120 RPM (provisional)
check('amr_balanced_rpm',     approx(amr.max_repeat_rpm, Policy.AMR_BALANCED_RPM),
      'got '..tostring(amr.max_repeat_rpm)..' want '..Policy.AMR_BALANCED_RPM)
check('amr_balanced_seconds', approx_s(amr.repeat_seconds, rpm_to_s(Policy.AMR_BALANCED_RPM)),
      'got '..tostring(amr.repeat_seconds))
check('amr_verified_status',  amr.native_cap_status == 'VERIFIED')

-- AMR Native Cap -> 400 RPM (VERIFIED)
local amr_native = p_native:classify('89c5493e08ca4207')
check('amr_native_allowed',   amr_native.allowed)
check('amr_native_rpm',       approx(amr_native.max_repeat_rpm, 400),
      'got '..tostring(amr_native.max_repeat_rpm)..' want 400')
check('amr_native_cap_rpm',   amr_native.native_cap_rpm == 400)
check('amr_native_seconds',   approx_s(amr_native.repeat_seconds, rpm_to_s(400)),
      'got '..tostring(amr_native.repeat_seconds))

-- ── 11. REVIEW weapons fail closed ───────────────────────────────────────────

-- P-113 Verdict (hash from runtime metadata)
local verdict = p_balanced:classify('1a437158e1b8d2a1')
check('verdict_not_allowed', not verdict.allowed)
check('verdict_review',      verdict.category == 'REVIEW')

-- R-63 Diligence (hash from runtime metadata)
local diligence = p_balanced:classify('03e67a19b07c6523')
check('diligence_not_allowed', not diligence.allowed)
check('diligence_review',      diligence.category == 'REVIEW')

-- ── 12. classify() returns detached copies (mutation does not leak) ───────────

local pm2 = p_balanced:classify('05e4e5c2db6e44a2')
pm2.max_repeat_rpm = 9999
local pm3 = p_balanced:classify('05e4e5c2db6e44a2')
check('classify_copy_detached', approx(pm3.max_repeat_rpm, 380),
      'classify leaked mutable reference: got '..tostring(pm3.max_repeat_rpm))

-- ── 13. Constants exposed correctly ──────────────────────────────────────────

check('ceiling_constant', Policy.BALANCED_CEILING_RPM == 380)
check('amr_constant',     Policy.AMR_BALANCED_RPM == 120)

-- ── 14. Status fields correct ─────────────────────────────────────────────────

local status_b = p_balanced:status()
local status_n = p_native:status()
check('status_balanced_mode',    status_b.fire_rate_mode == 'balanced')
check('status_native_mode',      status_n.fire_rate_mode == 'native_cap')
check('status_ceiling_present',  status_b.balanced_ceiling_rpm == 380)
check('status_amr_rpm_present',  status_b.amr_balanced_rpm == 120)

-- ── 15. Native cap mode does not affect Balanced policy object ────────────────

-- A separate balanced policy produces Balanced values independent of native policy.
local pm_check = p_balanced:classify('05e4e5c2db6e44a2')
check('balanced_unchanged_after_native_call', approx(pm_check.max_repeat_rpm, 380))

-- ── All checks passed ─────────────────────────────────────────────────────────
print('test_weapon_policy_v2: all checks passed')
