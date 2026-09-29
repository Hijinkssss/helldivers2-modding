# Changelog

## 1.0.1-FAA-B3 (unpublished development candidate)

- Corrected the long-cadence native input model: use legal divided retry ticks where the timed input parameter also acts as a normalized button threshold. The game still owns accepted shots and stock cooldowns.
- Separated validated identity/binding cache maintenance from bounded discovery, with safe RPM reads and throttled page queries.
- Skip weapon discovery on the ship, preserve Fire sampling every update, and remove callback timing when profiling is off.
- Restore on avatar/identity token changes; retain saved lease bytes when a restoration read fails so cleanup can retry.
- Passed offline regressions and actual Windows own-process read-safety checks. B3 live gameplay and performance are not yet validated.

## 1.0.1-WARRANT-RC1 (development candidate)

- Added P-92 Warrant to the existing ordinary held-Fire policy at 380 RPM Balanced, using authored fire-rate metadata of 450 RPM.
- Reused the existing controller. Guided lock, target acquisition, burst behavior, and shot acceptance remain game-controlled; no guidance or targeting automation was added.
- Live tested by the mod author in Guided and Unguided modes; native lock requirements and game-controlled shot acceptance remain intact.

## 1.0.0

- Initial public release of Full Auto Assist, an accessibility-focused held-Fire aid for 29 explicitly supported weapons.
- Added seven configurable Arsenal profile groups and Balanced/native-style cadence profiles.
- Added Amendment-style burst chaining through ordinary legal Fire input.
- Starts ON by default, with mission-session state persistence and `=` fallback toggle.
- Added optional Mod Bindings Menu integration.
- Requires Bingus Shared Loader v18 / API 1 only; unknown and native Full Auto weapons remain vanilla behind an exact-build safety gate.
