# Nexus Mods release materials

## Title

Full Auto Assist - Accessibility Autofire

## Short description

An accessibility-focused quality-of-life mod that repeats normal Fire input while held for 30 explicitly supported semi-auto, burst, and game-cycled weapons. It does not alter damage, recoil, ammo, projectiles, penetration, or native weapon statistics.

## Full description

Full Auto Assist helps reduce repeated input for supported weapons. Hold Fire and the mod repeats ordinary legal Fire input at each weapon's configured cadence. The game remains authoritative over whether each input produces a shot.

The mod does not automate aim, reload, recoil compensation, or charge/hold behavior. It does not change damage, recoil, ammunition, projectiles, penetration, heat, or native weapon statistics. Unknown and unlisted weapons remain vanilla. The ARC-12 Blitzer is intentionally excluded because it already has native Full Auto.

The mod starts ON. Press `=` (or `+`, depending on keyboard layout) to toggle assistance. The ON/OFF preference persists between missions during the game session. A complete game restart uses the optional INI setting or defaults to ON.

## Installation

1. Install Bingus Shared Loader v18 / API 1.
2. Import `Full-Auto-Assist-1.0.1-Arsenal.zip` in Arsenal.
3. Enable Full Auto Assist, select any desired Arsenal profiles, then deploy.

The advanced INI is optional. Copy `HD2FullAutoAssist.example.ini` to `%LOCALAPPDATA%\CowboyBingus\Helldivers2\HD2FullAutoAssist.ini` only if you need advanced settings. Do not use the developer validation INI as your normal configuration.

## Requirements

- Required: Bingus Shared Loader v18 / API 1.
- Optional: Mod Bindings Menu, for a rebindable action using the same toggle path.
- Not required: HD2ModCore or HD2Runtime.

## Supported weapons

P-2 Peacemaker, P-113 Verdict, M6C/SOCOM Pistol, P-69 Veto, R-63 Diligence, R-63CS Diligence Counter Sniper, R-2 Amendment, LAS-58 Talon, APW-1 Anti-Materiel Rifle, R-2124 Constitution, R-6 Deadeye, R-4 Hyena, R-72 Censor, SG-8 Punisher, SG-8S Slugger, SG-20 Halt, SG-451 Cookout, M90A Shotgun, SG-225IE Breaker Incendiary, CB-9 Crossbow, R-36 Eruptor, SG-8P Punisher Plasma, R/40-K Hot Shot Marksman Rifle, JAR-5 Dominator, P-4 Senator, P-11 Stim Pistol, SG-22 Bushwhacker, P-35 Re-Educator, P/40-K Bolt Pistol, and P-92 Warrant.

## Arsenal profiles

Arsenal has eight configurable groups: Peacemaker, SOCOM, Veto, Talon, AMR, Hyena, Bushwhacker, and Eruptor. Eruptor defaults to controlled 26 RPM (about 2.3077 seconds) for additional bolt-animation settling time; its Full Auto option retains 32 RPM. Constitution remains unchanged. Each group offers Balanced and Full Auto profiles; Talon also offers Efficiency and FULLER AUTO. Existing profile values are documented in the included README. Other supported weapons use Balanced cadence capped at the lower of their native cap and 380 input attempts per minute. These values describe attempted Fire inputs, not guaranteed accepted shots.

Amendment, Breaker Incendiary, and Dominator can chain their normal burst behavior while Fire is held. The game controls burst internals, fire-mode selection, and legal shot acceptance.

## Compatibility and limitations

This version is exact-build gated for Steam build 25480438. Game updates may temporarily break compatibility; no other game build is claimed. Unknown weapons and native Full Auto weapons remain vanilla. Mission, menu, focus, identity, and weapon guards may temporarily suppress assistance. The session toggle is not written back across full game restarts. Profile cadence controls attempted input timing, not guaranteed weapon output.

## Changelog

### 1.0.1

Major performance pass with validated caching and safe invalidation, substantially reduced idle/native memory validation work, low-RPM and long-cadence weapon fixes, corrected Eruptor support with a controlled 26 RPM default, weapon swap/reacquisition fixes, and lease/restoration recovery improvements. The mod author observed roughly 50+ ms/s idle dropping to roughly 5 ms/s in Mod Lag Watchdog; results vary by setup. Profiling and diagnostic logging are off.

### 1.0.0

Initial public release: 29 supported weapons, seven Arsenal profile groups, held-Fire assistance, default ON, optional Mod Bindings Menu integration, exact-build safety gate, and Bingus Shared Loader v18 / API 1 as the only required runtime dependency.

## Suggested Nexus metadata

- Categories: User Interface (if Nexus lists accessibility/QoL there); otherwise Miscellaneous or Utilities, based on the categories available for Helldivers 2.
- Tags: Accessibility, Quality of Life, Arsenal, Shared Loader, Fire Assist.
- Final filename: `Full-Auto-Assist-1.0.1-Arsenal.zip`.
- Artwork: use the existing project thumbnail without modification.
