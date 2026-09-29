# Full Auto Assist performance investigation

Status: **instrumentation branch; live performance cause not confirmed.** No
performance release candidate has been built. The report below separates
static code inspection from measurements that still require the mod author's
game session and Mod Lag Watchdog.

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
  Fire `read_scope`, then discarded. Repeated reads in that update reuse the
  region rows. Mapping writes also perform their own writable-page query.
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
| Measured in-game baseline (`ms/s`, `worst`) | Not available. No live game or Mod Lag Watchdog session has been run for this investigation. |
| Measured in-game phase timings | Not available until the mod author runs the opt-in profiler and unloads FAA. |
| Static baseline | Full identity resolution and input eligibility are repeated during held-Fire updates; VirtualQuery results are reused only within one update scope; module hashes and config parsing are startup-only. |
| Confirmed root cause | None yet. The report does not say whether `ms/s`, `worst`, or both were elevated. |
| Optimization in this branch | Removed the prior always-on per-update timing reads/counter math from ordinary mode. Detailed timing is now opt-in. Its in-game benefit has not been measured. Gameplay policy and memory guards are unchanged. |
| Post-fix measurement | Not available; no runtime root cause has been confirmed or fixed. |

The prior HD2ModCore region-cache measurements were synthetic and belong to a
different consumer. They are not FAA performance evidence and are not used as
baseline numbers here.

## Cache and invalidation decision

No new cache is added for native pointers, identity snapshots, UI state, or
page-validation results across updates. Those values can change during weapon
swap, player/mission transitions, or loader lifecycle changes. The existing
within-update region cache is cleared at the end of each `read_scope`; identity
guard rows are revalidated before the snapshot is accepted; a failed check
keeps the controller fail-closed and restores an active lease. The policy
decision cache remains keyed by the normalized resource hash, and policy is
immutable for one controller lifetime.

Only if live profiling shows a repeated phase is material should a follow-up
change define a precise cache key and invalidation rule. It must cover held
resource/entity changes, avatar/player changes, mission transition, invalid
pointer checks, shutdown/reload, and restore-before-release safety.

## Local comparison plan

For Watchdog comparison, use the same game build, mission, graphics settings,
normal mod stack, and a fresh game launch for each version. Keep profiling and
validation logging disabled for both comparison runs. Record both Watchdog
`ms/s` and `worst` after a warm-up, including the reported interval and run
duration. Repeat runs where practical. If the feature branch has no behavioral
optimization, treat this as a baseline confirmation rather than a claim that
the report is fixed. There is no PERF-RC1 at this stage. If the author elects
to compare builds now, candidate B is an unpublished package from this branch
with profiling disabled, used only to compare the gated removal of the old
always-on timing counters. It is not a claimed performance fix.

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

The author still needs to run Mod Lag Watchdog on public v1.0.0 and the
instrumented branch, then provide the metric values and profiler summaries.
Until those data exist, it is unknown whether FAA has sustained cost, a
transition/startup stall, an interaction with another mod, or no reproducible
issue. No PERF-RC1 archive is built in this branch because no real performance
issue has yet been confirmed and fixed.
