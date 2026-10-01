# Full Auto Assist v1.1.0 release notes (draft)

Full Auto Assist now includes a small three-cartridge HUD indicator so you can see when assistance is enabled and effective for your equipped supported weapon. It hides when assistance is OFF or unavailable. It shows assistance availability, not whether a shot was accepted.

All 30 supported weapons remain included, with the existing Warrant support and v1.0.1 performance/reliability changes preserved. Eruptor gains Stable 26, Balanced 27, Fast 28 and Max 32 RPM choices. Stable 26 remains the default; legacy INI selections retain their behavior. The game controls shot acceptance, animations and weapon statistics.

**Meltagun support is not included in v1.1.0. I am actively researching how to implement it for a later update.**

Arc Thrower, Purifier, Loyalist and Accelerator also remain unassisted: charge research is preserved, but charge automation has not passed the shared input-safety gate. No research probe runs in the release candidate.

Requires Bingus Shared Loader v18 / API 1 and supported Steam build 25480438. HD2ModCore and HD2Runtime are not required. Starts ON; use `=` to toggle. Unknown and native-auto weapons retain normal behavior.

Review status: packaged as `1.1.0-rc1`, targeting final `1.1.0`. No tag, merge, push or publication is authorized yet. Offline checks do not establish in-game HUD placement or performance. Check the review report and LIVE_TEST.md before approving the final release.
