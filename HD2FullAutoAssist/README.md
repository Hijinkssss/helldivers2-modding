# Full Auto Assist 1.0.1

**v1.0.1 performance and reliability release.** The mod author successfully live-tested the performance candidate, including Talon, Verdict, Cookout, Eruptor, weapon swaps and mission transitions. This release preserves that architecture and sets the Eruptor default to a controlled 26 RPM; the final tuning is regression-tested offline.

Full Auto Assist is an accessibility-focused quality-of-life mod that repeats normal Fire input while Fire is held for 30 explicitly supported semi-auto, burst, and game-cycled weapons. The game decides whether each input produces a shot. The mod does not change weapon statistics or automate aim, reload, recoil compensation, or charge behavior.

**Required dependency:** Bingus Shared Loader v18 / API 1. HD2ModCore and HD2Runtime are not required and are not bundled. Mod Bindings Menu support is optional.

## Install

1. Install Bingus Shared Loader v18 / API 1 and open Arsenal.
2. Import `Full-Auto-Assist-1.0.1-Arsenal.zip`, enable Full Auto Assist and deploy it.
3. Choose any desired options in Arsenal. All eight weapon profile groups default to Balanced.

The mod starts ON by default. Press `=` (or `+`, depending on keyboard layout) once to toggle it. If Mod Bindings Menu is installed and registers the optional action, that action uses the same toggle path and takes precedence over the fallback key.

## Supported weapons

P-2 Peacemaker; P-113 Verdict; M6C/SOCOM Pistol; P-69 Veto; R-63 Diligence; R-63CS Diligence Counter Sniper; R-2 Amendment; LAS-58 Talon; APW-1 Anti-Materiel Rifle; R-2124 Constitution; R-6 Deadeye; R-4 Hyena; R-72 Censor; SG-8 Punisher; SG-8S Slugger; SG-20 Halt; SG-451 Cookout; M90A Shotgun; SG-225IE Breaker Incendiary; CB-9 Crossbow; R-36 Eruptor; SG-8P Punisher Plasma; R/40-K Hot Shot Marksman Rifle; JAR-5 Dominator; P-4 Senator; P-11 Stim Pistol; SG-22 Bushwhacker; P-35 Re-Educator; P/40-K Bolt Pistol; P-92 Warrant.

ARC-12 Blitzer is excluded because it has native Full Auto. Unknown and unlisted weapons remain vanilla.

## Arsenal profiles

The eight configurable groups are Peacemaker, SOCOM, Veto, Talon, AMR, Hyena, Bushwhacker, and Eruptor. Existing profile values are preserved: Peacemaker 380/900 RPM; SOCOM 380/900; Veto 380/750; Talon Balanced 210, Efficiency 60, Full Auto 380, FULLER AUTO 750; AMR 120/400; Hyena 120/190; Bushwhacker 90/650. Eruptor defaults to Balanced at 26 RPM (60/26 = about 2.3077 seconds), allowing additional bolt-animation settling time; Full Auto retains the 32 RPM maximum option. The controlled default also applies to legacy `native_cap` INIs unless an explicit Eruptor profile is selected. Constitution remains 60 RPM. Other supported weapons use Balanced at `min(native cap, 380 RPM)`.

The P-92 Warrant uses Balanced at 380 RPM (authored fire-rate metadata: 450 RPM). The mod author live-tested RC1 in Guided and Unguided modes. In Guided mode, the game retains control of lock acquisition and whether each ordinary Fire input is accepted. FAA does not observe or change guidance, lock, mode, aim, or target selection.

These are input-attempt intervals, not guaranteed shot rates. For Amendment, Breaker Incendiary, and Dominator, Full Auto Assist repeats ordinary legal Fire input; the game controls burst internals, fire-mode selection, and shot acceptance.

## Performance and reliability

Validated identity and binding caches replace full rediscovery every active update. Cheap guarded reads check cached roots, table slots, identity records and back references before reuse; invalid or unreadable state triggers bounded rediscovery or suppresses assistance. Page metadata queries are throttled while every memory read retains the operating-system access check. Weapon discovery is skipped on the ship, and physical Fire sampling still runs each update. Restoration retains its saved bytes for retry after a transient read failure.

The mod author observed approximately 50â€“53 ms/s ship idle and commonly 67â€“75+ ms/s combat in the original build. The validated performance candidate generally showed 4.5â€“5 ms/s ship idle, brief values near 6 ms/s, and mission usage below approximately 13â€“14 ms/s in Mod Lag Watchdog. These are observed test results, not universal timing or FPS guarantees. Profiling, validation logging and debug logging are disabled by default. See [release validation](https://github.com/Hijinkssss/helldivers2-modding/blob/v1.0.1/HD2FullAutoAssist/docs/RELEASE_1.0.1.md) for evidence and limits.

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
