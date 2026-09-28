# Current-patch v0.1 validation scope

## Exact build and dependencies

Prepared 2026-09-28 for Steam build 25480438. Installed files were read and rehashed during this pass:

- game.dll: `2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E`
- helldivers2.exe: `F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06`

Dependencies: Loader v18/API 1; Core 0.3.2-runtime-candidate/API 1; Runtime exactly 0.24.0/API 1 at `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`. No game process is accessed by the offline runners. Build checks do not demonstrate gameplay.

## Classification evidence for this pass

The reviewed Runtime checkout was clean and matched its recorded commit and audited API hashes. Its `hd2.weapon(name):describe()` and `:fire_modes()` public methods were executed offline. The authoring catalog identifies snapshot `F5FEE03DCFDB-20260926T222226Z.hd2snap` with both installed fingerprints above.

| Weapon | Hash | Native modes | Native RPM | Balanced RPM | Result |
|---|---|---|---:|---:|---|
| P-113 Verdict | 1a437158e1b8d2a1 | [2,0,0], semi_auto | 450 | 380 | ASSIST candidate |
| R-63 Diligence | 03e67a19b07c6523 | [2,0,0], semi_auto | 350 | 350 | ASSIST candidate |
| R-63CS Diligence Counter Sniper | 4c786785c79d44e7 | [2,0,0], semi_auto | 350 | 350 | ASSIST candidate |

Each has one UNIQUE resource, `allowedModes=[2]`, no native mode 1 (Full Auto), and implementation family `conventional_projectile`. Repeated normal Fire is the intended continuation input inferred from those semi-only conventional projectile semantics; no charge/hold mode is present. The controlled live pass must confirm actual repetition.

Fire-rate evidence comes from the Runtime field `weapon.fire_rate`, `ProjectileWeaponComponentData`, f32 offset 8. Verdict record/index row: 233/540; Diligence: 221/507; Counter Sniper: 222/259. The full compact receipt, source hashes and field provenance are in `weapon-policy-evidence.json`. Runtime explicitly marks these fields `gameplay_proven=false`, `native_consumer_proven=false` and `current_live_ownership_proven=false`. Accordingly, all three caps are `RUNTIME_SNAPSHOT`, not claimed live-verified accepted rates. No weapon-stat field is read from or written to a game process by this evidence pass.

Existing policy stays at Peacemaker/SOCOM 900/380, Veto/Talon 750/380, Amendment 480/380, and AMR 400/120. AMR remains SPECIAL with its provisional Balanced override. Liberator remains IGNORE_NATIVE_AUTO; Quasar remains EXCLUDE_CHARGE_HOLD; unknown identities remain REVIEW. Laser Cannon's multiple resources fail the single-resource guard and leave it REVIEW/vanilla. No additional weapon is added.

The actual Amendment metadata has native `[2,3,0]`, default semi_auto, filtered `allowedModes=[2]`. Its corrected fixture uses that actual vector. The consumer's explicit Amendment approval permits its semi/burst vector and never permits native Full Auto. Other mixed/unknown vectors still fail closed.

## Offline verification

The original full runner is retained and reconciled with policy v2, including its previously stale Peacemaker-only assertions. It covers metadata caching and vetoes, collisions, malformed identity, closed identity gate, swaps/toggle/player transitions, chat/menu/focus guards, OFF-state traces, Runtime disconnect, config rejection, startup preference, failure rollback, restoration retries, cancellation and unload. Existing native mapping tests retain exact restoration, edit preservation and axis exclusion checks.

Added checks verify each promoted weapon in Balanced and Native Cap, missing/native-auto metadata vetoes, policy values through the installed controller, AMR SPECIAL activation, eligible-to-eligible held swaps, negative controls, and a slower explicit override. Native mapping fixtures exercise all distinct candidate intervals: 900, 750, 480, 450, 400, 380, 350 and 120 RPM. The adapter only lowers its accepted interval bound to 60/900; its input mechanism, build anchors and restoration logic are retained.

The runner compares promotions to real pinned Runtime metadata, checks source hashes, compiles and executes the bundle in an isolated missing-game fixture, performs Loader v18 discovery, verifies archive format, and checks packaged-source/config/document parity. It writes `build/selective-checks.json` and marks `build/build-report.json` offline-tested only after every check completes. The standalone v2 runner also writes `tests/weapon_policy_v2_results.json`; a skip is not a passing test.

The builder still verifies every original capture SHA256 and the observer source against `identity-validation.json`. Only CRLF-to-LF normalization is allowed for the source comparison. No capture is regenerated. `native_fire.lua` remains current-build-specific; update resilience and backend architecture changes are deferred.

## Observed history and release gates

`HANDOFF.md` records earlier selective Peacemaker hold/release and swaps to vanilla Amendment/AMR working, with normal audio/animation. `identity-validation.json` retains the original idle Peacemaker/Amendment/AMR identities and player invalidation evidence. That history does not validate the expanded policy or new cadence.

Follow `NEXT_TEST.md` once. Still required: current candidate startup; actual hold/release and clean input restoration; new held identities; selected cadence and continuous audio/animation; native-auto and charge controls; eligible swaps; chat/menu/focus isolation; no errors; measured callback cost and scheduler warnings; clean shutdown. Input-attempt counters are not successful shots or accepted RPM. Veto/SOCOM/Talon compatibility remains outside this requested matrix. No HUD is implemented; HUD and future patch resilience are deferred and are not requirements of this scoped pass.

No package has been imported or deployed by this preparation. The game was not launched. This is a validation candidate, not a release.
