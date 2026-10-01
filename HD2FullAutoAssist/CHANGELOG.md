# 1.1.0 (release candidate, unpublished)

- Added the retained three-cartridge HUD glyph for effective FAA assistance on supported weapons.
- Eruptor options are Slower Cadence 27, Balanced / default 28 and Maximum Full Auto 32 RPM; legacy config migration is safe.
- Added Commando through the ordinary 240 RPM Fire-repeat policy.
- Fixed multi-world HUD suppression and explicit GUI visibility; added bounded RC2 diagnostics.
- Preserved the existing 30 supported weapons, for 31 total, Warrant support, validated caches, input restoration, startup/toggle behavior and v1.0.1 performance fixes.
- Meltagun support is not included. I am actively researching how to implement it for a later update.
- Arc Thrower, Purifier, Loyalist and Accelerator remain unassisted pending charge input validation.
- Candidate requires offline verification and in-game HUD/new-option review before final release.

# Changelog

## 1.0.1

- Major runtime performance pass: validated identity and binding caching, safe invalidation, bounded rediscovery and substantially fewer native page queries replace full discovery on every active update.
- Reduced ship idle work and removed unconditional callback timing when profiling is off. Physical Fire sampling remains active every update.
- Fixed low-RPM / long-cadence native Fire handling, including Eruptor and Crossbow, and removed the cadence-bound failure affecting supported slow weapons.
- Added a controlled Eruptor cadence and optional maximum native cadence. v1.1.0 RC2 supersedes its default tuning. Constitution and other weapon cadences were unchanged.
- Fixed weapon transition/reacquisition and avatar/identity invalidation; retain original lease bytes and retry restoration after a transient read failure. Mission/ship/respawn recovery preserves the session preference.
- Preserved P-92 Warrant support already present in the performance branch; guidance and shot acceptance remain game-controlled.
- The mod author successfully live-tested the performance candidate. Observed ship idle cost fell from roughly 50+ ms/s to roughly 5 ms/s in Mod Lag Watchdog; this is a test observation, not a universal FPS guarantee. Final Eruptor tuning is verified by offline regressions.
- Public package ships with profiling, validation logging and debug logging off.

## 1.0.0

- Initial public release of Full Auto Assist, an accessibility-focused held-Fire aid for 29 explicitly supported weapons.
- Added seven configurable Arsenal profile groups and Balanced/native-style cadence profiles.
- Added Amendment-style burst chaining through ordinary legal Fire input.
- Starts ON by default, with mission-session state persistence and `=` fallback toggle.
- Added optional Mod Bindings Menu integration.
- Requires Bingus Shared Loader v18 / API 1 only; unknown and native Full Auto weapons remain vanilla behind an exact-build safety gate.
