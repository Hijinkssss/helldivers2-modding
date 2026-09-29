# Full Auto Assist B3 results

Unpublished candidate based on `feature/full-auto-assist-performance` at `be04ea15359b505bf953ef22d747e8f5e2de013e`. No merge, push, release/Nexus change, protected-branch change, deployed-file change, or game-process access. B3 gameplay and Mod Lag Watchdog performance remain unvalidated.

## Low-RPM diagnosis

B2 fixed the throwing one-second consumer bound but left the native cadence model incorrect. The engine's timed-button parameter at mapping +16 also becomes a magnitude threshold. Values above normalized button magnitude 1.0 prevent held-time accumulation and subsequent trigger-8 pulses. Eruptor requests 60/32 = 1.875 seconds; Crossbow requests 60/50 = 1.2 seconds. Talon profiles range from 0.08 to 1.0 seconds, Verdict uses 0.13333 / 0.15789 seconds, and Cookout uses 0.75 seconds. Those parameters pass the same native threshold.

Exact-build evidence: preserved build-25480438 memory image SHA-256 `e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969`, reverified this run. At 0x12fbb78/0x12fbb82 the mapping is copied to the argument of 0x12fc180; 0x12fc1ce loads its +16 into xmm7. Trigger 8 uses that parameter for modulo timing at 0x12fc44c; 0x12fc4c6/0x12fc4d7 also gate held-time accumulation on it. The transient pulse is +0, physical magnitude remains +4, and hold duration is +8. FAA therefore keeps its authoritative magnitude release check. No new physical-input guess, timeout, synthetic Fire action write, or Eruptor-specific exception is used.

The narrow native-function replay reproduces B2 emitting only the initial pulse for both long intervals. This confirms a structural native-parameter failure and strongly explains the user's current live observations; no new live Eruptor trace was captured, and other live issues are not ruled out.

The general conversion is `native_retry_period = requested_interval / ceil(requested_interval)`. Intervals <=1 are unchanged. Eruptor gets 0.9375 seconds and Crossbow gets 0.6 seconds. These are legal retry attempts; the game owns accepted shots, cycling and cooldown. This does not guarantee exact 32/50 accepted RPM: frame rounding, a rejected boundary input, animation, reload or guidance can delay acceptance. Confirm the actual shot/audio/animation behavior in-game before accepting B3. Requested policy intervals remain visible separately from `native_retry_ms` in diagnostics. Existing axis-input exclusion remains unchanged; native button actions still cover their existing keyboard/mouse/controller bindings without mouse-only gating or polling gaps.

## Current idle and active work

Idle Fire-up performs three current RPM reads per update: controls global, 32-byte Fire record, controls global recheck. Every 100 ms an identity callback checks the game-state root/value/root. Ship/non-gameplay does no weapon discovery. In gameplay, the same callback validates the cached identity certificate. It still returns current derived state for user/diagnostic getters.

Active Fire performs nine input/game/player reads, 34 certificate validation reads in the normal fixture, seven full UI/focus eligibility reads, and four lease-context/mapping reads: 54 in total. Certificate validation is the largest remaining operation by read count. Fire/identity no longer rebuild page validation on every frame. UI/text-state revalidation remains intact, including its fixed text-layout anchor; the proposed additional UI static-anchor optimization was not needed for this coherent change. Actual phase timing is unknown until a new profile/Watchdog run. QPC clocks used for cache expiration and input scheduling remain; unconditional callback timing/slow-log work is disabled when profiling is off.

There is one pre-stock update path and no new render callback. State getters have no native reads. Native sampling occurs every update at the same observation phase, preserving the baseline opportunity to see taps, release/repress, holds and binding changes. Sub-frame input events are not newly claimed as observable.

## Reference patterns adopted

Reviewed current [VanillaPlusMegapack ArcThrowerRevamped v1.6 source](https://github.com/CowboyBingus/VanillaPlusMegapack/blob/1b943e61d2436f204fb5d8740a6082f44a780e42/components/ArcThrowerRevamped/src/arc_thrower_auto.lua), pinned Megapack commit `1b943e61d2436f204fb5d8740a6082f44a780e42`.

Adopted relevance gating, discovery/maintenance separation, validated slot/header reuse, bounded rediscovery, throttled static page validation, update-only work and diagnostics outside the ordinary hot path. Arc's charge writes, 0.25-second recovery window, blind-pointer assumptions and its discovery backoff were not adopted. FAA still resolves a broader identity/eligibility contract, so matching Arc's reported ms/s is not assumed.

## Cache inventory and exact validation

| Cached item | Validation before reuse |
| --- | --- |
| Identity snapshot plus guard certificate | Parent-first current bytes for five manager globals, local counts, player pointer/owned record, unit ref, map headers and matched key/index rows, full avatar record, live avatar count, avatar table pointer/record, wielder back-array pointer/slot/record, held-array pointer/entity ID, equipment map/key/index, equipment back-array pointer/slot and full equipment record. Recheck all five roots after validation. Every read uses RPM. A changed/unreadable guard discards the certificate and attempts bounded fresh discovery. |
| Avatar/equipment identity token | Derived hex bytes from identity records +8..+23, not a guessed new native generation API. Token, avatar ID, unit, entity and resource hash participate in resolved-state/lease comparisons. Same-unit avatar replacement and record-token changes restore the lease. |
| Policy result and derived state/fingerprint | Existing classification cache is keyed by normalized resource hash within immutable startup config/profile. Changed identity/hash recomputes state; unchanged state revision reuses the fingerprint. Zero policy classifications occurred in all steady workloads. `AssistState.resolve` still validates the observed result each active update. |
| Fire bucket location | Fresh controls global, complete 20-byte binding table header, Fire key and count row, plus host cache revision. A mismatch triggers at most 256 probes. Mapping bytes are freshly captured only when unleased. |
| Lease originals/patched records | Existing owner/table/key/count context plus every patched record, using a single bounded mapping snapshot per active update. Writes/restoration retain fresh writable-page query, compare, write and full readback. A context read failure retains originals/lease for retry; proven foreign edits remain preserved. |
| Region metadata | At most 64 contained, committed/readable/non-guard regions, maximum one-second metadata epoch. New spans, expiry and failures query afresh. RPM enforces CURRENT full-span readability on every actual read. This is separate from object-identity validation; metadata never grants write permission. |

[Microsoft documents that ReadProcessMemory checks the entire requested range for readable access before transferring it](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-readprocessmemory). The actual Windows adapter was also tested against guard/no-access pages and freed memory in the test process's own temporary allocation; failed guard reads did not consume the guard flag. No raw game-memory FFI dereference was introduced.

## Invalidation rules

- Weapon swap, resource hash/entity change, loadout/held-row change, full avatar/equipment record-token change, or identity ownership/count changes invalidate the prior identity certificate/state. Active changes restore and require the existing release gate.
- Manager/global movement, table pointer/header movement, key/index compaction, back-reference movement and equipment-record address movement invalidate before following a cached child. Discovery remains bounded by 96 actual identity reads; no unbounded scan is introduced.
- Death/respawn invalidates through local-unit/ownership/record guards, including an avatar replacement with an unchanged unit ref. Mission/ship changes invalidate through the current game-state root/value; unheld UI identity updates retain their existing 100 ms refresh rhythm and Fire activation checks immediately.
- Read failure clears region metadata, bumps the binding-cache revision and discards the identity certificate. Bounded fresh identity discovery can recover in the same call when an old slot became unreadable; persistent read failure returns unavailable and never yields the old result.
- Binding/controls/header changes invalidate the cached bucket; binding-context mismatch or foreign mapping edits revoke ownership conservatively. Failed restoration reads retain the original lease bytes and retry hook.
- Focus/UI/text cancellation, toggle, unload and consumer failure invalidate the relevant certificates and restore owned mappings. A genuine unsafe native failure still permanently fails closed after cleanup, as before.
- Unknown/unsupported observations cannot grant assistance. Transitioning to them discards the prior eligible identity/policy/lease state. A newly validated stable unsupported observation can be retained as an ineligible token so the cheap watch path does not rediscover every update. No stale eligibility survives.

## Offline work budgets

Identical byte-memory fixture, 1,000 updates at 5 ms/update (five simulated seconds), B2 commit versus B3 source; startup/initial acquisition excluded. Native read counts include complete safety checks. Write-side page queries are included when writes occur; these steady measurements contain no recurring mapping writes. Counts are not wall-time or FPS benchmarks. The synthetic platform uses 4 KiB region boundaries, so live absolute query counts can differ.

| Scenario | Native reads before -> after | Page queries before -> after | Full discoveries before -> after | B3 max reads / queries in one update |
| --- | --- | --- | --- | --- |
| ship idle | 5,700 -> 3,150 | 2,850 -> 20 | 50 -> 0 | 6 / 4 |
| unsupported idle | 5,700 -> 4,850 | 2,850 -> 100 | 50 -> 0 | 40 / 20 |
| supported idle | 5,700 -> 4,850 | 2,850 -> 100 | 50 -> 0 | 40 / 20 |
| unsupported held | 11,700 -> 10,850 | 5,750 -> 100 | 50 -> 0 | 46 / 20 |
| active fire | 74,000 -> 54,000 | 25,000 -> 125 | 1000 -> 0 | 54 / 25 |

All five steady paths perform zero policy classifications. Idle gameplay validates 50 certificates; active Fire validates 1,000. Region expiration can cause a bounded refresh burst (up to 25 page queries for active Fire), rather than charging those queries on every update. Ship idle read budget is <=3,200 per 1,000 updates, supported/unsupported idle <=5,000, unsupported-held <=12,000 and active <=55,000. Tests assert these budgets, zero rediscovery/classification and the per-update limits; metadata growth and a complete 256-slot collision chain are also checked.

## Regression and delivery checks

All 20 existing standalone groups passed. Three B3 groups passed: certificate/cache/state/restoration checks, native threshold replay across 76 policy/profile combinations, and actual Windows own-process RPM safety. They cover Eruptor/Crossbow, 32 RPM and >1-second intervals, long holds across multiple retry cycles, release during long cadence, boundary release/taps, slow/fast swaps, same-identity reuse, generation/token changes, root/record/array movement, key/index compaction, death/respawn, mission/ship transitions, read/page failures, bounded rediscovery and exact mapping restoration. Simulated cooldown acceptance does not establish actual shot timing.

Package checks passed for actual Shared Loader v18 discovery at `3d7e3a120828178573ef1ee0a5c7eeae4a951865`, all 16 option resources, Lua/archive/ZIP parity, missing-loader and unsupported-process fail-closed behavior, dependency audit and deterministic rebuild. The actual delivered bundle was separately exercised with its delivered INI and profiler/trace constructors replaced with errors. Eruptor -> Talon -> Verdict -> Cookout acquired/held/restored native mapping bytes with no profiler, trace, physical diagnostic sample or debug hold logs.

Candidate defaults and supplied INI: `performance_profile=false`, `validation_logging=false`, `debug_logging=false`, normal Balanced profiles, ON by default. Existing installed INI/manager profiles were not modified. Builder and package reports explicitly mark live validation false, removing the inherited RC1 live-pass label for this candidate.

## Required next live check

Use one FAA candidate at a time, the same mod stack/profile and diagnostics-off INI, with Mod Lag Watchdog. Check idle ship, unsupported weapon, supported weapon idle, active firing and swaps. For Eruptor/Crossbow, observe at least three successive accepted shots, release during cycling, release/press near cadence boundaries, slow/fast swaps, reload and death/respawn. Recheck Talon/Verdict/Cookout cadence feel, animation/audio continuity and restoration. Record ms/s and worst separately; return-to-idle must fall back quickly. Do not publish or claim live performance/cadence improvement until these checks pass.
