# Selective v0.1.1 live validation scope

The local automated collector and stage analyzer are in `../HD2FullAutoAssist/validation/selective-live-2026-09-28` relative to the candidate root's parent. Startup gates require a running process, matching exact file fingerprints, four deployed archives matching the prepared artifacts, one loaded instance per dependency/consumer, fresh logs, Runtime 0.24.0, expected policy, no Core/consumer failures and contiguous trace records. Expected source-known Core degradation is recorded separately from startup errors. Held Peacemaker identity and an inactive lease are checked before the first firing request.

Offline checks cover trace collection while OFF, cleanup, Runtime disconnect, escaped JSON, stage evidence boundaries, forbidden leases, repeat-after-release, loss of trace records and cadence arithmetic. These are fixtures, not live results. A stage may pass objective input checks while native shots, animation/audio and mechanical limits remain unverified. The system does not automatically label gameplay or release validation complete.

2026-09-28. Exact guarded layout: Steam build 25480438, game.dll SHA256 `2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E`, EXE SHA256 `F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06`.

Reviewed Runtime: 0.24.0, commit `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`. Public metadata only; no Runtime implementation is embedded.

## Offline scope

The runner exercises the enabled selective controller against synthetic state/mapping fixtures and an in-memory closed-gate copy as a regression check. It never writes game memory. The source gate was enabled only after the identity evidence below was recorded and reviewed; this does not demonstrate selective gameplay.

Checks cover whitelist/mixed-mode/unknown/ambiguous/malformed metadata, hash collisions, dependency absence, metadata caching, held entity/hash/player invalidation, toggle persistence, guarded lease restoration, chat/menu/focus guards, failure rollback, cancellation/unload, cadence bounds, actual Runtime public metadata, Loader v18 discovery, and source/archive/package parity. Passing results and hashes are written only after the runner completes successfully.

## Live status

- Held identity: passed for idle Amendment, Peacemaker and AMR in the observed mission.
- Controlled primary/secondary/support/back cycle: 866 samples, all guards passed, no observed nulls.
- Player invalidation: observed no-local-unit interval, new unit/avatar, then no held weapon during requested return to ship. Old mission identity was not retained.
- Animation-relative timing, actual input-to-identity latency and sub-poll null windows: not measured/excluded.
- Selective semi-auto, native auto, mixed/burst, charge/hold preservation: pending.
- Per-weapon cadence: pending; 125 ms retains the previous provisional setting.
- Actual lookup, state-change, idle and repeat callback costs: pending.
- HUD insertion and synchronization: pending; no safe insertion route established.
- Arsenal UI/import/deployment: not performed.
- Release readiness: blocked by missing live evidence.

`identity-validation.json` compiles seven captures / 3217 samples with their hashes, raw identities, guard outcomes and transition observation intervals. External lookup averaged 1628.634 us with maximum 5012.2 us; those include Python/Lua/remote-read overhead and are not deployed callback measurements. The temporary unknown item `16f397ca5f51f271` remains REVIEW, consistent in timing with the user's AMR call-down but semantically unidentified.

Core 0.3.2 adds a generic synchronous read scope. Tests confirm contents are reread, nil-containing results are preserved, nested scopes work, errors invalidate the cache, coroutine calls are rejected, and each new scope requeries regions. Selective state/policy caching preserves fresh ownership checks and avoids duplicate identity polling during active leases. Performance benefit must still be measured in game.

## Weapon policy v2 (feature/full-auto-assist-weapon-policy)

Classification table updated to reflect the full weapon-aware accessibility scope.
Native cap corrections applied 2026-09-28 (corrective commit on feature branch).
All resource hashes sourced from `selective-checks.json` runtime metadata.

### Category assignments and native cap verification

| Weapon | Kind | Category | Balanced RPM | Native Cap RPM | Cap Status |
|---|---|---|---|---|---|
| P-2 Peacemaker | weapon | ASSIST | 380 | 900 | VERIFIED |
| M6C/SOCOM Pistol | weapon | ASSIST | 380 | UNRESOLVED | UNRESOLVED |
| P-69 Veto | weapon | ASSIST | 380 | 750 | VERIFIED |
| LAS-58 Talon | weapon | ASSIST | 380 | 750 | VERIFIED |
| R-2 Amendment | weapon | ASSIST | 380 | 480 | VERIFIED |
| APW-1 Anti-Materiel Rifle | support_weapon | SPECIAL | 120 (override) | 400 | VERIFIED |
| AR-23 Liberator | weapon | IGNORE_NATIVE_AUTO | — | — | — |
| LAS-98 Laser Cannon | support_weapon | IGNORE_NATIVE_AUTO | — | — | — |
| LAS-99 Quasar Cannon | support_weapon | EXCLUDE_MANUAL_RELOAD | — | — | — |
| P-113 Verdict | weapon | REVIEW | — | — | — |
| R-63 Diligence | weapon | REVIEW | — | — | — |
| R-63CS Diligence Counter Sniper | weapon | REVIEW | — | — | — |

> [!NOTE]
> All Balanced values use `min(native_cap, 380)` except AMR which uses 120 RPM (special override).
> SOCOM native cap is UNRESOLVED; Balanced = 380 is correct regardless of actual cap.
> Resource hashes: Peacemaker, Amendment, AMR confirmed by identity-validation evidence.
> Remaining hashes (Veto, SOCOM, Talon, Verdict, Diligence, CS Diligence) sourced from
> selective-checks.json runtime metadata; live identity re-validation required before release.

### Fire-rate mode policy

- **Balanced (default):** generic ceiling 380 RPM; AMR uses 120 RPM override.
- **Native Weapon Cap:** each weapon's actual accepted native rate; no ceiling applied.
- Mode is user-selectable via `fire_rate_mode` in the `.ini`.

### Offline test results (corrective pass)

`test_weapon_policy_v2.lua` — all checks passed offline. ✅

| Check | RPM | Hash source | Status |
|---|---|---|---|
| Unknown weapon → fail closed | — | — | ✅ |
| Liberator → IGNORE_NATIVE_AUTO | — | runtime metadata | ✅ |
| Quasar → EXCLUDE_MANUAL_RELOAD | — | runtime metadata | ✅ |
| Peacemaker Balanced | 380 | identity evidence | ✅ |
| Peacemaker Native Cap | 900 (VERIFIED) | identity evidence | ✅ |
| SOCOM Balanced | 380 | runtime metadata | ✅ |
| SOCOM Native Cap | NOT TESTED (UNRESOLVED) | — | — |
| Veto Balanced | 380 | runtime metadata | ✅ |
| Veto Native Cap | 750 (VERIFIED) | runtime metadata | ✅ |
| Talon Balanced | 380 | runtime metadata | ✅ |
| Talon Native Cap | 750 (VERIFIED) | runtime metadata | ✅ |
| Amendment Balanced | 380 (480 > ceiling) | identity evidence | ✅ |
| Amendment Native Cap | 480 (VERIFIED) | identity evidence | ✅ |
| AMR Balanced | 120 (special override) | identity evidence | ✅ |
| AMR Native Cap | 400 (VERIFIED) | identity evidence | ✅ |
| Verdict → REVIEW, not allowed | — | runtime metadata | ✅ |
| Diligence → REVIEW, not allowed | — | runtime metadata | ✅ |
| classify() returns detached copy | — | — | ✅ |
| Constants and status fields | — | — | ✅ |
| Balanced unchanged after native call | — | — | ✅ |

### Remaining pre-release validation needed

- **SOCOM native cap** — UNRESOLVED. Must be confirmed from live game before native_cap mode can be tested for SOCOM.
- **AMR 120 RPM Balanced** — provisional special override. Refine after live gameplay pass.
- **REVIEW weapons** (Verdict, Diligence, CS Diligence) — need fire-mode vector confirmation before elevation to ASSIST.
- **All non-identity-evidence hashes** (Veto, SOCOM, Talon, Verdict, Diligence, CS Diligence) — sourced from runtime metadata snapshot; live identity re-validation pass required.
- **Per-weapon cadence** — game-side animation, recoil, audio at 380 RPM ceiling not yet recorded.


Existing universal-candidate observations do not validate the selective candidate. No 125 ms gameplay result has been supplied.

