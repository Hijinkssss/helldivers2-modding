# One controlled live session

Target Balanced set: Peacemaker 380, Amendment 380, Verdict 380, Diligence 350, Diligence Counter Sniper 350, AMR 120; Liberator and Quasar remain vanilla. All three REVIEW weapons were promoted using reviewed current-build snapshot evidence.

## Prepare once

1. Close the game before package/config changes. Preserve the existing INI and previous Assist package as rollback files. No deployment is part of this preparation.
2. In the existing isolated Arsenal test profile, replace only Assist with `HD2FullAutoAssist-v0.1.2-Current-Patch-Validation-Arsenal.zip`. Use the listed Core 0.3.2 Runtime candidate, Runtime exactly 0.24.0 and Loader v18. Enable one instance of each; leave unrelated test consumers and weapon-changing mods disabled. Keep Loader at the profile's working last/default priority.
3. Copy `HD2FullAutoAssist.validation.ini` to the existing consumer INI path. Verify `user_enabled=false`, `repeat_ms=0`, `fire_rate_mode=balanced`, debug/validation logging ON. An old positive repeat_ms would slow Native Cap; this matrix uses zero.
4. Deploy once, confirm archive/package hashes and dependency versions, then launch once. Check fresh startup logs, one loaded instance per addon, current fingerprints, expected policy and no errors. Runtime source-known Core degradation is recorded separately from errors.

## Loadouts in one session

A solo loadout cannot carry four different primaries and two different sidearms at once. Use four short loadout blocks in the same game session; each distinct primary requires its own entry unless an actual teammate/ground pickup is available. Do not complete or repeat whole missions just to retest a passed block. Use a quiet low-difficulty mission, return to ship once the required block is recorded, change loadout, and run the next missing block. If teammates can supply the required pickups, combine blocks only after each pickup and its identity are observed; do not assume access to a secondary swap.

| Block | Primary | Secondary | Support | Required observations |
|---|---|---|---|---|
| A | Amendment | Peacemaker | AMR | 380/380/120; eligible swaps; common guards |
| B | Diligence | Verdict | Quasar | 350/380; charge/hold negative control |
| C | Diligence Counter Sniper | Peacemaker | Any unchanged | 350; do not repeat passed Peacemaker checks |
| D | Liberator | Peacemaker | Any unchanged | Native Full Auto negative control; compare OFF/ON |

This is one controlled session covering the requested eight weapons, not a claim that all eight fit in one solo mission. With verified pickups, the mission count can shrink; no additional weapons or cadence tuning are requested.

## Exact checklist

For every assisted target, record the observed held name/hash, policy/category and lease interval. Target intervals are 157.895 ms at 380, 171.429 ms at 350, and 500 ms at 120.

- Start with Fire released. Toggle ON using F8, release Fire again, then hold for one short 2–3 second string with enough ammo. Hold repeats normal Fire; no reload or aim automation occurs.
- Release Fire. It stops promptly with no extra repeating input and no stuck Fire. Record physical observation alongside trace timing; polling cannot prove zero-latency release.
- Confirm normal sound and animation, no clipped bursts or obvious cadence skipping. Count accepted shots/ammo changes over the observed interval if judging RPM; input-attempt counts alone cannot establish accepted cadence. Do not change weapon stats.
- On Amendment, inspect the R-menu once for absence of Full Auto and observe semi and burst if both are selectable. Burst chaining must preserve normal burst audio/animation; 380 is an input ceiling, not burst-internal RPM.
- In A, hold an assisted weapon and swap to another eligible identity. The old lease restores; ON persists; assistance resumes only after Fire release and a new hold, with the new interval. In B/D, swap to Quasar/Liberator while holding and confirm no lease remains; release before continuing normal fire.
- Once in A, toggle OFF during a hold and confirm restoration. Toggle ON while held; release before restarting. ON/OFF preference persists across swaps.
- Once in A, test menu, chat and focus loss during a hold. Assistance restores and no repeated Fire enters the menu/chat. Return to gameplay and release before a new hold.
- Quasar: compare normal charge/hold and release with toggle OFF/ON once its cooldown permits. Charge duration, shot and cooldown behave normally; no Assist lease or mapping write for Quasar.
- Liberator: select native Full Auto and compare a short OFF/ON hold. Cadence, continuous audio and animation remain normal; no Assist lease or mapping write for Liberator. Other native R-menu modes must also remain untouched.
- Review logs after each block for errors, failed identity, restoration conflicts and unexpected leases. Record callback cost and aggregate scheduler.slow separately from emitted warnings. Expected budget-warning counts are not zero-cost evidence.
- End once with a clean game exit. Verify shutdown has zero active leases/subscriptions, matching mapping restorations and no errors/conflicts. Preserve the run ID, logs and observations before another launch can overwrite them.

If a block fails, release Fire, toggle OFF and preserve that failure. Stop the session to repair the candidate; do not keep doing repeat missions or silently tune the cadence. Do not merge, publish v0.1 or claim compatibility from package import/offline checks. Native Cap gameplay and Veto/SOCOM/Talon remain separately unvalidated; this requested pass targets Balanced.
