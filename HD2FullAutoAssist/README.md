# HD2 Full Auto Assist v0.1.2 current-patch validation candidate

Full Auto Assist repeats normal Fire while the player holds Fire on explicitly approved weapons. The game decides whether each shot or burst is accepted. It changes no damage, recoil, ammunition or projectile data and automates no reloads, aiming, recoil compensation or combos.

This package is prepared for controlled validation on Steam build **25480438**. Earlier Peacemaker-only selective behavior was observed working; this expanded policy and its current cadence values have not passed live validation. Do not publish v0.1 yet.

Required, separately installed dependencies: **Bingus Shared Loader v18 / API 1**, **HD2ModCore 0.3.2-runtime-candidate / API 1** from `integrations/HD2ModCore-runtime-candidate`, and **HD2Runtime exactly 0.24.0 / API 1**, reviewed at commit `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`. The consumer checks Runtime 0.24.0 during identity resolution. A missing, disconnected or replaced Runtime leaves assistance unavailable and restores an active lease. No dependency is embedded. The Core build fingerprints and native input anchors remain mandatory.

## Weapon policy and cadence

| Weapon | Category | Balanced RPM | Native Cap RPM | Value source |
|---|---|---:|---:|---|
| P-2 Peacemaker | ASSIST | 380 | 900 | Existing user-confirmed policy |
| M6C/SOCOM Pistol | ASSIST | 380 | 900 | Existing user-confirmed policy |
| P-69 Veto | ASSIST | 380 | 750 | Existing user-confirmed policy |
| LAS-58 Talon | ASSIST | 380 | 750 | Existing user-confirmed policy |
| R-2 Amendment | ASSIST | 380 | 480 | Existing user-confirmed policy; semi/burst vector |
| P-113 Verdict | ASSIST | 380 | 450 | Reviewed current-build Runtime snapshot |
| R-63 Diligence | ASSIST | 350 | 350 | Reviewed current-build Runtime snapshot |
| R-63CS Diligence Counter Sniper | ASSIST | 350 | 350 | Reviewed current-build Runtime snapshot |
| APW-1 Anti-Materiel Rifle | SPECIAL | 120 | 400 | Existing user-confirmed policy; Balanced override provisional |
| AR-23 Liberator | IGNORE_NATIVE_AUTO | — | — | Native Full Auto; always vanilla |
| LAS-99 Quasar Cannon | EXCLUDE_CHARGE_HOLD | — | — | Charge/hold; always vanilla |
| LAS-98 Laser Cannon | REVIEW in practice | — | — | Multiple resource identities prevent mapping; always vanilla |

Balanced is the default: `min(native_cap_rpm, 380)`, except AMR at 120. Native Cap uses the per-weapon value in the table. These values select input intervals, not guaranteed measured shot rates. The three new caps are marked `RUNTIME_SNAPSHOT`, because metadata confirmation is distinct from accepted live shots. Their evidence is in `docs/weapon-policy-evidence.json`.

Use `fire_rate_mode=balanced` or `fire_rate_mode=native_cap` in the INI. `repeat_ms=0` selects the policy interval. A positive integer through 1000 can only slow it down: actual interval is `max(repeat_ms/1000, 60/policy_rpm)`. Existing positive values remain respected, so an old `repeat_ms=125` caps 900-RPM Native Cap input to 480 attempts/minute. Use zero for the requested Native Cap values. Invalid mode names fail configuration loading.

All unlisted, ambiguous, unknown or malformed identities stay REVIEW/vanilla. Metadata can veto explicit approval and cannot add weapons. Any native Full Auto option vetoes assistance on an approved weapon. The only approved semi/burst combination is Amendment's reviewed native vector `[2,3,0]`; Runtime's filtered `allowedModes` alone does not describe that vector. No automatic R-menu discovery is attempted. Laser Cannon's static category is IGNORE_NATIVE_AUTO, but its ambiguous identity fails closed before mapping.

## Controls and limitations

`enabled=false` disables the consumer. F8 changes the global user toggle; it persists across weapon swaps within the session, but is not saved to disk. `user_enabled` selects the startup preference. The validation INI starts OFF, selects Balanced at policy cadence, and enables debug and validation records. The normal example starts ON with validation logging disabled.

Release restores the input mapping on the next observed update. Weapon/entity/player changes, toggle changes, menu/chat/focus guards and identity or Runtime failure restore a lease and require Fire release before restarting. The guarded held-weapon observer and selective cache remain intact. Axis mappings remain vanilla. No HUD is included.

Known limits: exact current build only; 0.24.0 Runtime only; accepted shot cadence and audio/animation remain unverified for this package; AMR 120 is provisional; held identities beyond the earlier Peacemaker/Amendment/AMR observations need live confirmation; brief identity windows between polls are unmeasured. Veto, SOCOM and Talon remain existing candidates and are outside this pass's requested live matrix, so this matrix alone cannot establish their release compatibility. Scheduler budgets are advisory; review aggregate slow counts as well as warning lines. Core logs the first and every hundredth over-budget callback.

## Build and validation

From the repository root, using Python with Lupa/LuaJIT 2.1 installed:

```text
python HD2FullAutoAssist/scripts/build.py --identity-records <preserved-original-identity-directory>
python HD2FullAutoAssist/tests/run_weapon_policy_v2.py
python HD2FullAutoAssist/tests/run.py --runtime-path <lupa-parent-directory> --loader-source <Loader-v18-src/discover.lua> --hd2runtime-source <reviewed-Runtime-root> --identity-records <preserved-original-identity-directory>
```

The original identity captures must match their recorded hashes. The preserved repository contains CRLF source, while the observed source receipt uses LF; the builder normalizes only line endings for the observer comparison and Lua bundle. It does not replace the observer or manufacture identity proof. The runner checks real reviewed Runtime metadata offline without accessing a game process.

Output: `build/HD2FullAutoAssist-v0.1.2-Current-Patch-Validation-Arsenal.zip`. One Arsenal option, same existing addon GUID; do not enable another Full Auto Assist instance. Building does not install, deploy or launch anything. Follow `docs/NEXT_TEST.md` for one controlled session and `docs/VALIDATION.md` for evidence boundaries.
