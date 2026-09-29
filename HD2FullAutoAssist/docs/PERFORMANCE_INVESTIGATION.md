# Full Auto Assist performance investigation

Status: **measured baseline; narrow optimization passed offline tests; live
performance unverified.** The measurements below come from
the diagnostic build's shutdown profiler summary and the author's Watchdog run.
The profiler covers one mixed ship/mission session rather than isolated scenes.

## 2026-09-29 measured diagnosis (before optimization)

The author observed Full Auto Assist at **57.8 ms/s, worst 3 ms** on the ship/menu
after a D10 solo Exterminate mission, and approximately **80-90 ms/s** during
active combat. The 31-second Watchdog window averaged 11.1 ms game frames and
had no stalls of at least 50 ms. These are sustained-cost observations, not a
large individual-stall reproduction.

The local `HD2FullAutoAssist.log` shutdown profile covers 859.88 seconds. Its
`update_wrapper` accounts for 46.72 seconds, or **54.33 ms/s** of elapsed FAA
time excluding the original game update. This is close to the author's 57.8
ms/s Watchdog reading, although the two clocks and measurement windows differ.
The profile recorded 76,272 update callbacks (88.7/s), 75,155 native Fire
samples (87.4/s), 8,114 identity callbacks (9.4/s), and 14,166 full identity
snapshots. The Fire callback was entered once per update even when Fire was not
held.

| Inclusive profiler phase | Calls | Total elapsed | Mean | Run-average contribution |
| --- | ---: | ---: | ---: | ---: |
| Update wrapper, excluding stock update | 76,272 | 46.72 s | 612.5 us | 54.33 ms/s |
| Fire callback | 76,272 | 37.81 s | 495.7 us | 43.97 ms/s |
| Native Fire input sample | 75,155 | 35.32 s | 470.0 us | 41.08 ms/s |
| Identity callback | 8,114 | 7.94 s | 978.0 us | 9.23 ms/s |
| Full guarded identity snapshot | 14,166 | 8.82 s | 622.4 us | 10.25 ms/s |
| Input eligibility | 6,333 | 0.72 s | 114.2 us | 0.84 ms/s |
| Toggle polling | 76,272 | 0.71 s | 9.3 us | 0.83 ms/s |
| Policy resolution | 14,166 | 0.08 s | 5.7 us | 0.09 ms/s |
| Lease refresh | 2,682 | 0.03 s | 12.5 us | 0.04 ms/s |

The phases are nested, so their totals must not be added. The controller's
separate idle/held timing counters show **67,524 Fire-up calls / 29.77 s**
(34.62 ms/s across this run) and **7,631 Fire-held calls / 7.71 s** (8.97
ms/s across this run). A held call averaged about 1,011 us; an idle call about
441 us. The larger combat reading is consistent with more held calls, but the
mixed profile does not isolate D10 combat or prove a combat-only phase split.

The guard layer performed 966,961 reads and 250,973 page queries. Every read
validates page state/protection before `ReadProcessMemory`; the 1-in-32 sample
of page validation averaged 42.02 us per read versus 2.72 us for the platform
read. Extrapolating those sampled means to all calls suggests approximately
40.6 s in page validation and 2.6 s in the platform read. These estimates
overlap the inclusive phases and may contain sampling/profiler overhead; they
identify page validation/querying as the likely cost within the Fire sample
and identity snapshot, not an independently additive 47 ms/s.

The static audit matches the profile. `native_fire.sample()` reads the controls
owner, the Fire state record, and the owner again on every sampled update. If
Fire is held it also reads and rechecks game/player state. `lifecycle.read()`
validates each read's page, with a cache scoped only to one callback. The
identity callback takes a guarded full snapshot at most every 100 ms while
unleased; held Fire takes another full snapshot each eligible update. Policy
lookup is already cached by resource hash. Lease refresh, toggle polling,
eligibility, startup hashing, and logging are too small in this capture to
explain the reported sustained cost.

**Dominant confirmed operation:** repeated guarded Fire sampling on idle
updates, with page validation/querying the probable underlying cost. The
second material operation is the full guarded identity snapshot. Any patch
must preserve native input coverage and read safety, including non-mouse Fire
bindings, player/weapon changes, UI transitions, and lease restoration. A
long-lived native pointer or unvalidated page cache is not justified by this
profile.

## Narrow patch after diagnosis

The measured Fire sample remains necessary every update: the existing code has
no proven event source that covers every native Fire binding, physical release,
weapon swap, and teardown with the same timing. Throttling the sample or gating
it on the left mouse button would change behavior for other bindings. The patch
instead removes work that the static audit proved redundant:

- Identity's symbol resolver no longer reads a global immediately before the
  observer's guarded read of the same address. The observer still reads and
  revalidates each global. A successful full snapshot avoids five redundant
  reads, and early-failing snapshots avoid however many globals they reached.
- Identity and Fire callbacks share page-query results within a single
  pre-stock update. Both callbacks previously opened separate scopes, so a
  page touched by both could be queried twice in one update. The scope clears
  before the stock update, and the next update queries pages afresh.
- The native sampler no longer calls `GetAsyncKeyState` solely to populate a
  validation-trace field when validation tracing is off. Normal input sampling
  and lease decisions still use the same native Fire record. Trace-enabled
  sampling retains the physical mouse observation.

No player, weapon, UI, mapping, or page pointer is cached across updates. On
weapon swap, death/respawn, UI or stratagem transition, mission transition,
return to ship, loadout change, or teardown, the existing fresh read and
restore/release gates remain active; a failed guarded read still fails closed.
The expected reduction is from fewer native reads, page queries on updates
where identity and Fire touch the same region, and one fewer input API call per
sample. This is likely a modest improvement because the 41.08 ms/s Fire sample
phase remains, and only another unprofiled Watchdog run can measure the result.

## Report and watchdog metrics

A Nexus user reported that Mod Lag Watchdog attributed delays of up to about
150 ms to Full Auto Assist and described a substantial FPS impact. The report
does not identify which watchdog metric was elevated.

Mod Lag Watchdog defines `ms/s` as the mod's sustained Lua CPU cost over time;
it describes values below 10 ms/s as essentially negligible and 50 ms/s or
more as worth investigating. `worst` is the longest single stall in the last
30 seconds; 150 ms or more is a noticeable stutter. A 150 ms `worst` result is
not 150 ms/s of sustained work. Both fields must be recorded separately.

## Runtime map from source inspection

| When | Work |
| --- | --- |
| Startup | Hashes the executable and `game.dll` from disk for exact-build gating; resolves the game module and validates PE headers; loads selected Arsenal option resources; opens the loader log; parses the INI once; builds policy tables; registers identity, Fire, toggle, and shutdown callbacks. |
| Every game update | The wrapper dispatches identity polling, then the Fire callback, then the stock update, then toggle polling. Each registered callback is protected and timed by the lifecycle dispatcher. |
| Identity callback, at most 10 Hz | Takes a guarded player/avatar/held-weapon snapshot and resolves policy. While a Fire lease is active, the identity callback returns early because the Fire callback performs its own fresh resolution. |
| Fire callback, every update while active | Samples ordinary Fire. If held in gameplay and not waiting for physical release, it checks input eligibility and takes a fresh full identity snapshot. With an active lease it validates the mapping snapshot. Without a lease it scans and validates bindings, then changes the legal Fire mapping once. The game handles repeated Fire according to that mapping. |
| Toggle polling, every update | Checks focus, polls the registered Mod Bindings action or fallback key, and rate-limits registration attempts to once per second. Actual toggle eligibility and state change run only on a pressed edge. |
| Weapon change / invalid identity | Re-resolves identity; on an active lease, a mismatch or failed guard restores the original binding and waits for physical Fire release. Policy lookup is cached for the most recently resolved resource hash; identity and pointer guards are still refreshed. |
| Mission/UI transition | There is no separate mission callback. Fire sampling observes the current game state; an active hold also runs the UI/focus eligibility checks. Invalid gameplay state invalidates identity and restores any lease. |
| Shutdown / failure | Restores a lease, removes callbacks, and writes shutdown/error records. A transient restore failure retains the callbacks needed to retry cleanup. |

### Suspects checked

- **VirtualQuery:** page-region results are cached only inside one synchronous
  pre-stock update scope, then discarded. Identity and Fire reads in that
  update reuse region rows. Mapping writes also perform their own writable-page
  query.
- **Pointer safety:** identity snapshots revalidate guarded pointer/map rows
  before returning. Input eligibility re-reads the UI state and window flags.
  These safety reads currently repeat during held-Fire updates.
- **Module lookup and hashing:** `GetModuleHandleA` is used for module lookup;
  there is no module enumeration loop. Full executable and DLL hashing occurs
  at startup, not per update.
- **Identity and policy:** policy classification is cached for the last hash,
  but a held-Fire update still takes a full identity snapshot and builds a
  state snapshot/fingerprint. The identity observer formats the held resource
  hash each time. This is a candidate for measurement, not a proven cause.
- **Input eligibility:** on held gameplay updates, the text-input anchor,
  UI manager, receiver, and UI-state snapshot are checked and revalidated.
  This path is skipped on ordinary Fire-up updates and when the controller is
  waiting for release.
- **Allocation and formatting:** identity snapshots build guard/result tables;
  state snapshots deep-copy state; policy results are copied on cache misses;
  the identity fingerprint uses string conversion and concatenation. The
  profiler checks their containing phases, not individual allocator costs.
- **Logging:** with `debug_logging=false` and `validation_logging=false`, there
  is no per-frame validation trace. Ordinary logs are event-driven. However,
  lifecycle code writes and flushes a `slow_callback` warning on the first
  callback over 2 ms and every 100 such callbacks thereafter, even with debug
  logging disabled. Whether that branch occurs during gameplay is unmeasured.
  Validation tracing is separate, opt-in, and flushes buffered records once a
  second; do not enable it during performance measurements.
- **Callbacks/retries:** the lifecycle wrapper owns one update hook and one
  set of identity, Fire, toggle, and shutdown callbacks. Existing lifecycle
  tests verify idempotent start and single Mod Bindings registration. Identity
  polling is throttled to 10 Hz; registration retry is one second. A failed
  consumer is disabled; if a native lease still needs restoration, the
  retained Fire callback retries cleanup on subsequent updates until it
  succeeds. This exceptional recovery path is now counted and timed separately
  through `native_fire_restore` and `restoration_retry_calls`.
- **Configuration:** the INI is read and parsed once at startup. No config
  parsing or profile-table construction occurs in the update loop.

There is substantial guarded native reading on held-Fire updates, but the
static count alone cannot establish Mod Lag Watchdog cost or explain a 150 ms
stall. The per-update identity snapshot and guarded reads are the primary
phases to measure before considering a cache change. No native pointer cache
or safety relaxation is introduced here.

## Instrumentation and measured baseline

Set `performance_profile = true` and give `performance_label` a short scenario
name in the local INI. Keep `debug_logging` and `validation_logging` false. The
profiler accumulates fixed phase histograms in memory and emits one JSON
summary through the existing loader log when the mod unloads. It does not
write a line each update. Phase summaries include count, average, maximum,
and p95/p99 upper histogram bounds. Startup executable/DLL hash time is
included. Host memory-read and page-query calls have exact counts;
page-validation and platform-read durations are sampled once per 32 calls to
limit instrumentation overhead. `update_wrapper` measures FAA's before/after-
stock segments and excludes the game's original update. A profile label should
identify one scenario per game run.

The profiler uses the platform's monotonic elapsed-time clock (QueryPerformanceCounter
where available, with GetTickCount64 as fallback). It helps locate slow phases,
but it is not a replacement for Mod Lag Watchdog's CPU `ms/s` measure:
elapsed phase time can include scheduling delays. Compare Watchdog values with
profiling disabled, and use separate profiling runs to localize phase cost.

| Evidence type | Current result |
| --- | --- |
| Measured in-game diagnostic baseline (`ms/s`, `worst`) | 57.8 ms/s and worst 3 ms on the ship/menu; about 80-90 ms/s in active D10 combat. The unprofiled build still needs a separate comparison. |
| Measured in-game phase timings | One mixed-session summary is analyzed above. Isolated ship and combat profiles remain unavailable. |
| Static baseline | Full identity resolution and input eligibility are repeated during held-Fire updates; module hashes and config parsing are startup-only. |
| Confirmed dominant operation | Guarded Fire sampling on every active update, mostly while Fire is up in the mixed run. Page validation/querying is the likely dominant suboperation. |
| Optimization in this branch | The earlier commit made detailed timing opt-in. The new patch removes the three proven redundancies above without changing the native Fire sampling cadence. |
| Post-fix measurement | Not available. Live performance improvement is unverified. |

The prior HD2ModCore region-cache measurements were synthetic and belong to a
different consumer. They are not FAA performance evidence and are not used as
baseline numbers here.

## Cache and invalidation decision

No cache is added for native pointers, identity snapshots, UI state, or page
validation across updates. Those values can change during weapon swap,
player/mission transitions, or loader lifecycle changes. The shared region
cache exists only from the beginning of the identity callback through the end
of the Fire callback in one pre-stock update. `read_scope` clears it on both
success and error. Identity guard rows are revalidated before the snapshot is
accepted; a failed check keeps the controller fail-closed and restores an
active lease. The existing policy decision cache remains keyed by the
normalized resource hash, and policy is immutable for one controller lifetime.

## Local comparison plan

For Watchdog comparison, use the same game build, mission, graphics settings,
normal mod stack, and a fresh game launch for each version. Keep profiling and
validation logging disabled for both comparison runs. Record both Watchdog
`ms/s` and `worst` after a warm-up, including the reported interval and run
duration. Repeat runs where practical. Compare the previous diagnostic source
commit `fa186bd` with the new patch commit, built separately with the same
Arsenal selections. This is an unpublished A/B candidate, not a claimed live
performance fix.

Run each scenario separately and set `performance_label` to its name for the
diagnostic pass. Save the shutdown summary before changing the label or
restarting:

1. Ship idle.
2. Mission idle.
3. Supported weapon equipped, not firing.
4. Unsupported weapon equipped.
5. Supported semi-auto held Fire.
6. Supported burst held Fire.
7. P-92 Warrant, Guided and Unguided.
8. Repeated weapon swaps.
9. Repeated FAA ON/OFF toggles.
10. Menu open/close and focus transitions.
11. Mission initialization/transition.
12. Several minutes of D10 combat with continuous held Fire intervals.

For each case, capture at least 60 seconds of Watchdog `ms/s` and `worst`,
plus the profiler summary for a separate run. Note frame-rate impact, exact
Watchdog version, FAA config, enabled mods, and whether the run was on the
normal mod stack or the isolated Shared Loader + Watchdog + FAA stack. If only
the normal stack is abnormal, repeat the isolated run to identify interaction
cost. Profile instrumentation itself is opt-in and adds QueryPerformanceCounter
reads; do not compare its `ms/s` with an uninstrumented package.

## Remaining uncertainty

The diagnostic session establishes sustained cost on this mod stack. It does
not isolate combat from ship time or quantify how much the opt-in profiler
itself adds. Unprofiled A/B Watchdog runs on the same build and mod stack are
needed before claiming a live improvement. The patch has only offline coverage
so far. The unchanged per-update native input sample likely leaves a material
floor to FAA's sustained cost.
