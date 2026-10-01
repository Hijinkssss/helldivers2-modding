# Full Auto Assist 1.1.0 release candidate

**v1.1.0 private RC3 diagnostic candidate.** Continues current RC2 with all 31 supported weapons and unchanged Commando/Eruptor profiles. Fixes a proven restoration-ownership defect and HUD OFF/anchoring issues. Persistent Eruptor fresh-hold OFF repetition remains release blocking and requires the included native-state trace. See OFF-STATE-INVESTIGATION.md and LIVE-VALIDATION.md.

Full Auto Assist is an accessibility-focused quality-of-life mod that repeats normal Fire input while Fire is held for 31 explicitly supported semi-auto, burst, and game-cycled weapons. The game decides whether each input produces a shot. The mod does not change weapon statistics or automate aim, reload, recoil compensation, or charge behavior.

**Required dependency:** Bingus Shared Loader v18 / API 1. HD2ModCore and HD2Runtime are not required and are not bundled. Mod Bindings Menu support is optional.

## Install

1. Install Bingus Shared Loader v18 / API 1 and open Arsenal.
2. Import `Full-Auto-Assist-1.1.0-rc2-Arsenal.zip`, enable Full Auto Assist and deploy it.
3. Choose any desired options in Arsenal. Eight weapon profile groups default to Balanced. Eruptor defaults to Balanced at 28 RPM.

The mod starts ON by default. Press `=` (or `+`, depending on keyboard layout) once to toggle it. If Mod Bindings Menu is installed and registers the optional action, that action uses the same toggle path and takes precedence over the fallback key.

## Supported weapons

P-2 Peacemaker; P-113 Verdict; M6C/SOCOM Pistol; P-69 Veto; R-63 Diligence; R-63CS Diligence Counter Sniper; R-2 Amendment; LAS-58 Talon; APW-1 Anti-Materiel Rifle; R-2124 Constitution; R-6 Deadeye; R-4 Hyena; R-72 Censor; SG-8 Punisher; SG-8S Slugger; SG-20 Halt; SG-451 Cookout; M90A Shotgun; SG-225IE Breaker Incendiary; CB-9 Crossbow; R-36 Eruptor; SG-8P Punisher Plasma; R/40-K Hot Shot Marksman Rifle; JAR-5 Dominator; P-4 Senator; P-11 Stim Pistol; SG-22 Bushwhacker; P-35 Re-Educator; P/40-K Bolt Pistol; P-92 Warrant; MLS-4X Commando.

ARC-12 Blitzer is excluded because it has native Full Auto. Unknown and unlisted weapons remain vanilla.

## Active-assistance indicator

The approved three-cartridge glyph stays yellow for supported FAA ON and visible opaque white for supported FAA OFF. Unsupported or invalid identities stay hidden. It follows the current native lower-left panel's rightmost rendered extent with a six-unit gap and ammo-row alignment, including backpack expansion. ON and OFF have identical positioning and size. Invalid native geometry clears drawing without a fixed-offset fallback. HUD_ANCHORING.md documents exact fields, guards and live assumptions.

## Charge weapons and Meltagun

**Meltagun support is not included in v1.1.0. I am actively researching how to implement it for a later update.**

Arc Thrower, Purifier, Loyalist, and Accelerator also remain unassisted in this candidate: the existing charge research has not validated a physical-release-safe input adapter. Research progress does not establish support. These weapons remain under normal game control, and no charge probe runs in this package.

## Arsenal profiles

The nine configurable groups are Peacemaker, SOCOM, Veto, Talon, AMR, Commando, Hyena, Bushwhacker, and Eruptor. Existing profile values are preserved: Peacemaker 380/900 RPM; SOCOM 380/900; Veto 380/750; Talon Balanced 210, Efficiency 60, Full Auto 380, FULLER AUTO 750; AMR 120/400; Commando 120/240; Hyena 120/190; Bushwhacker 90/650. Eruptor offers Slower Cadence 27 RPM, Balanced / default 28 RPM, and Maximum Full Auto 32 RPM. Use `eruptor_profile=slower_27|balanced_28|max_32`. Old RC1 settings migrate safely to the corresponding new option; the retired slow option falls back to the new default. The default also applies to legacy `native_cap` INIs. Constitution remains 60 RPM. Other supported weapons use Balanced at `min(native cap, 380 RPM)`.

The P-92 Warrant uses Balanced at 380 RPM (authored fire-rate metadata: 450 RPM). The mod author live-tested RC1 in Guided and Unguided modes. In Guided mode, the game retains control of lock acquisition and whether each ordinary Fire input is accepted. FAA does not observe or change guidance, lock, mode, aim, or target selection.

These are input-attempt intervals, not guaranteed shot rates. For Amendment, Breaker Incendiary, and Dominator, Full Auto Assist repeats ordinary legal Fire input; the game controls burst internals, fire-mode selection, and shot acceptance.

## Performance and reliability

Validated identity and binding caches replace full rediscovery every active update. Cheap guarded reads check cached roots, table slots, identity records and back references before reuse; invalid or unreadable state triggers bounded rediscovery or suppresses assistance. Page metadata queries are throttled while every memory read retains the operating-system access check. Weapon discovery is skipped on the ship, and physical Fire sampling still runs each update. Restoration retains its saved bytes for retry after a transient read failure.

The mod author observed approximately 50–53 ms/s ship idle and commonly 67–75+ ms/s combat in the original build. The validated performance candidate generally showed 4.5–5 ms/s ship idle, brief values near 6 ms/s, and mission usage below approximately 13–14 ms/s in Mod Lag Watchdog. These are observed test results, not universal timing or FPS guarantees. Profiling, validation logging and debug logging are disabled by default. See [release validation](https://github.com/Hijinkssss/helldivers2-modding/blob/v1.0.1/HD2FullAutoAssist/docs/RELEASE_1.0.1.md) for evidence and limits.

## Configuration

Most users can configure profiles in Arsenal without an INI. The optional advanced file is `%LOCALAPPDATA%\CowboyBingus\Helldivers2\HD2FullAutoAssist.ini`; copy `HD2FullAutoAssist.example.ini` there only when you want advanced settings. The example starts ON with Balanced policy and the `=` fallback.

The session toggle persists across missions, but it is not saved across a complete game restart. A full restart uses `user_enabled` from the INI, or the default ON when the file or setting is absent. Do not use `HD2FullAutoAssist.validation.ini` as your normal configuration; it is for developer-controlled validation and starts OFF.

## Compatibility and safety

This release supports Steam game build **25480438** and is exact-build gated by executable and game DLL fingerprints. Game updates may temporarily break compatibility; this release does not claim support for other builds. Native Full Auto weapons and unknown weapons stay vanilla. Mission, menu, focus, identity, and weapon guards can temporarily suppress assistance without changing the ON/OFF preference. Fire release, weapon swapping, and shutdown retain restoration safeguards.

## Troubleshooting

If assistance unexpectedly starts OFF, inspect `%LOCALAPPDATA%\CowboyBingus\Helldivers2\HD2FullAutoAssist.ini` and verify `user_enabled=true`. Also confirm that `HD2FullAutoAssist.validation.ini` was not copied into the active INI path. If a game update changed the supported build, wait for a compatible release rather than bypassing the build gate.

## Known limitations

- Supported builds are exact-build gated; future game updates need compatibility work.
- Weapon profiles set the cadence of attempted Fire inputs, not accepted shot rates.
- The supported roster is explicit and does not discover newly added weapons.
- The INI is optional; mission-session toggle state is not written back across full game restarts.
- Optional Mod Bindings Menu support depends on that mod registering its binding successfully.

See [CHANGELOG.md](CHANGELOG.md) for this release's changes.

Commando offers Balanced at 120 RPM by default and Full Auto at its retained native 240 RPM input cadence. `commando_profile=balanced|full_auto` provides the optional INI fallback; Arsenal selections take precedence. Guidance, selector, projectile, ammo and expendable mechanics stay game-controlled; accepted live cadence remains pending.

HUD diagnostics now default OFF. Optional validation/profile logging uses synchronous disk I/O and must stay OFF for production Watchdog comparison. The short OFF-STATE-DIAGNOSTIC.ini run captures current/original mappings and native Fire state, with 96 mapping snapshots per load. The legacy hud_probe_visible setting is parsed for compatibility but does not enlarge or force the glyph. See LIVE-VALIDATION.md.
