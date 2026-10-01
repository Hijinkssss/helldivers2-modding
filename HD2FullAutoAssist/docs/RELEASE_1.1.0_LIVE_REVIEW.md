# v1.1.0 candidate live review

This is a pending review checklist, not a record of completed gameplay tests. No game launch or deployment was performed during release preparation.

1. With the game closed, select only this FAA candidate with Bingus Shared Loader v18. Preserve your v1.0.1 setup for rollback. Confirm profiling/debug/validation logging are OFF.
2. In a mission, check glyph position and scale beside ammo at your normal HUD settings. Toggle OFF/ON and swap supported/unsupported weapons. Check death, respawn, focus/menu transitions and mission return. It should hide whenever effective assistance is unavailable.
3. Hold/release Fire with a familiar supported weapon and Eruptor. Check immediate stop and restoration during swaps. Default Eruptor remains 26 RPM; compare optional 27/28/32 selections only if desired. Record animation/audio continuity separately from input-attempt rates.
4. Compare measured Watchdog idle and active-Fire usage with the validated v1.0.1 baseline. Synthetic native-work parity is not a wall-time benchmark.
5. Confirm Arc Thrower, Purifier, Loyalist, Accelerator and Meltagun receive no assistance or HUD glyph. No charge research or new weapon research is required for this review.

Keep merge and publication pending review of the diff, supported roster, version, package hash, offline results and these new live acceptance items.
