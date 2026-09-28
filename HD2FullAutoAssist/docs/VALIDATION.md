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

### Category assignments

| Weapon | Kind | Category | Balanced RPM | Native Cap RPM |
|---|---|---|---|---|
| P-2 Peacemaker | weapon | ASSIST | 380 | 480 |
| M6C/SOCOM Pistol | weapon | ASSIST | 380 | 480 |
| P-69 Veto | weapon | ASSIST | 380 | 480 |
| LAS-58 Talon | weapon | ASSIST | 380 | 480 |
| R-2 Amendment | weapon | ASSIST | 300 (below ceiling) | 300 |
| APW-1 Anti-Materiel Rifle | support_weapon | SPECIAL | 120 (explicit override) | 60 |
| AR-23 Liberator | weapon | IGNORE_NATIVE_AUTO | — | — |
| LAS-98 Laser Cannon | support_weapon | IGNORE_NATIVE_AUTO | — | — |
| LAS-99 Quasar Cannon | support_weapon | EXCLUDE_MANUAL_RELOAD | — | — |
| P-113 Verdict | weapon | REVIEW | — | — |
| R-63 Diligence | weapon | REVIEW | — | — |
| R-63CS Diligence Counter Sniper | weapon | REVIEW | — | — |

### Fire-rate mode policy

- **Balanced (default):** generic ceiling 380 RPM; AMR uses 120 RPM override.
- **Native Weapon Cap:** each weapon's actual accepted native rate; no ceiling applied.
- Mode is user-selectable via `fire_rate_mode` in the `.ini`.

### Offline test results (feature branch)

- `test_weapon_policy_v2.lua` – all 26 checks passed offline.
- Fail-closed: unknown weapons return REVIEW/not-allowed. ✅
- IGNORE_NATIVE_AUTO (Liberator): not assisted. ✅
- EXCLUDE_MANUAL_RELOAD (Quasar): not assisted. ✅
- Peacemaker Balanced 380 RPM. ✅
- Peacemaker Native Cap 480 RPM. ✅
- SOCOM Balanced 380 RPM. ✅
- Veto Balanced 380 RPM. ✅
- Talon Balanced 380 RPM. ✅
- Amendment eligible (burst-fire, no native Full Auto), Balanced 300 RPM. ✅
- AMR Balanced 120 RPM. ✅
- AMR Native Cap 60 RPM. ✅
- REVIEW weapons fail closed (Verdict). ✅
- classify() returns detached copies; mutation does not leak. ✅
- Constants and status fields correct. ✅

### Remaining live validation needed

- All weapon resource hashes except Peacemaker, AMR, and Amendment are **placeholder** values.
  Live identity validation pass required before release.
- Per-weapon cadence confirmed as plausible; game-side animation/recoil behaviour
  at each RPM ceiling not yet confirmed with recorded gameplay.
- AMR 120 RPM Balanced is provisional; refine after live gameplay pass.
- REVIEW weapons (Verdict, Diligence, CS Diligence) need fire-mode vector confirmation.


Existing universal-candidate observations do not validate the selective candidate. No 125 ms gameplay result has been supplied.
