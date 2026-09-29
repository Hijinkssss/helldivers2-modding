# Changelog

## 1.0.1-WARRANT-RC1 (development candidate)

- Added P-92 Warrant to the existing ordinary held-Fire policy at 380 RPM Balanced, using authored fire-rate metadata of 450 RPM.
- Reused the existing controller. Guided lock, target acquisition, burst behavior, and shot acceptance remain game-controlled; no guidance or targeting automation was added.
- Requires live validation in Guided and Unguided modes before release.

## 1.0.0

- Initial public release of Full Auto Assist, an accessibility-focused held-Fire aid for 29 explicitly supported weapons.
- Added seven configurable Arsenal profile groups and Balanced/native-style cadence profiles.
- Added Amendment-style burst chaining through ordinary legal Fire input.
- Starts ON by default, with mission-session state persistence and `=` fallback toggle.
- Added optional Mod Bindings Menu integration.
- Requires Bingus Shared Loader v18 / API 1 only; unknown and native Full Auto weapons remain vanilla behind an exact-build safety gate.
