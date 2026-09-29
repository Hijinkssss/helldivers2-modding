> Historical development record. Current release status and validation are in [RELEASE_1.0.1.md](RELEASE_1.0.1.md).

# FAA B3 design, before implementation

Baseline: feature/full-auto-assist-performance, be04ea15359b505bf953ef22d747e8f5e2de013e. No other branch/ref changes, live deployment, merges, pushes, or releases.

## Diagnosis
The preserved exact-build memory image has SHA256 e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969. Input evaluator 0x12fbb78 copies mapping bytes, including +16, into the argument to 0x12fc180. That function loads +16 at 0x12fc1ce as both trigger parameter and magnitude threshold; 0x12fc4c6 and 0x12fc4d7 gate held-time accumulation on it. A 1.875 or 1.2 interval exceeds normalized button magnitude 1.0 and keeps held time at zero. B2 only relaxed the consumer assertion. This is an exact-build static explanation, not a new recorded live Eruptor trace. Existing fixtures populated a permanently held magnitude and never executed native trigger semantics.

General cadence conversion: requested interval remains 60/policy RPM (or slower override). Native timed-button parameter must be <=1. For a longer requested native cooldown, use requested / ceil(requested) as an evenly divided retry period. The game owns accepted shots and enforces the native cooldown; these are extra legal input attempts, not extra shots. Existing <=1 profiles are byte-for-byte unchanged. Do not claim exact accepted shot spacing or animation/audio acceptance offline. No synthetic action/weapon writes, OS input, native detours, or Eruptor-specific branch.

## Architecture
- Keep Fire sampling every update, same pre-stock phase, all binding/device signals, no polling gaps. The controls global is freshly read before the Fire record and rechecked afterward. Release uses magnitude and engine held time; no cadence-based stale-hold timer.
- Separate identity discovery from validation. Cache the successful result plus original identity guard locations/bytes, including all map headers, matched key/index rows, record generations, counts, ownership, table pointers, and back-references. Validate ordered parent/root guards before child reads, then recheck root globals at the end. Any mismatch/read failure discards the certificate; mismatches rediscover within the existing 96-read budget. Read failures return unavailable for that update; next update rediscovers. Policy classification stays keyed to hash/config; avoid unchanged state fingerprint work.
- Ship/non-gameplay identity callback takes only game-state gates and clears identity; it does not discover weapon identity. Unleased supported/unsupported state validates at the existing 100 ms UI cadence. Every Fire activation/active lease validates immediately, independent of the idle callback interval.
- Cache binding bucket location only with matching controls global, full table header and Fire key/count row. Search at most 256 slots only on cache miss. Lease maintenance still reads and compares every leased mapping. Writes/restoration keep their own writable-page query and read/compare/write/read verification.
- Region metadata: bounded 64-entry cache, one-second maximum age. Reuse only for contained spans with stored committed/readable/non-guard metadata; every actual read is still checked by ReadProcessMemory, never an FFI dereference. RPM itself enforces current readable access and full-length success. Expiry refreshes VirtualQuery; every failure clears metadata and identity/binding certificates. Public guarded read API remains fresh; production internals opt into safe cached reads. Writes never borrow cached permission. Region metadata is not an object-identity proof; identity and binding certificates supply that proof separately.
- UI eligibility remains dynamic every active update; only the fixed module/text anchor is validated at startup, with a fresh UI root and receiver/state revalidation each call. No cached UI permission.
- Remove unconditional callback timing/slow-log work when profiling/debugging are off. Render never performs native work. Keep transition/error/restore event logs.

## Invalidation
Weapon/entity/hash/generation changes, manager/table/pointer movement or compaction, ownership/count changes, held entity/loadout change, death/respawn, mission/ship transition, unknown state, native read failure, UI/focus cancellation, toggle/unload, and lease restoration failure invalidate appropriate derived certificates. Active mismatches restore and retain the existing wait-for-release gate. Region failures clear every region row. Cached addresses are always validated through their current parent binding before access and protected by RPM.

Reference: current VanillaPlusMegapack 1b943e61d2436f204fb5d8740a6082f44a780e42, ArcThrowerRevamped v1.6. Adopt discovery/maintenance separation, slot/header validation, bounded rediscovery, startup static validation and diagnostics off the hot path. Do not adopt Arc charge writes, its recovery window, or its Fire polling backoff.

## Verification
Replay native threshold/held-time/trigger-8 semantics at every supported profile, including >1 intervals, multiple slow shots, release/boundary taps and swaps. Verify actual patched and original bytes. Exercise certificates, root/index/record movement, reuse/generation, death/ship/read failures, binding edits and retry rollback. Count native reads/page queries against be04ea1 with identical byte-memory workloads, strict per-update and rediscovery budgets. Existing standalone and package suites must pass. Candidate INI has profiling, validation and debug false; report live performance and gameplay unvalidated.

## Implementation amendments after validation

- Native disassembly establishes +4 as physical magnitude and +0 as pulse, so release keeps the existing magnitude check; held time is not used to extend a released action.
- An unreadable cached slot now permits bounded same-call rediscovery. Persistent failure returns unavailable.
- Dynamic UI/text eligibility and its static anchor recheck remain intact; no separate UI cache optimization was required.
- Avatar and complete identity-record tokens participate in lease comparisons. Restoration read failure retains the lease for retry rather than assuming detachment.
- See B3_RESULTS.md for final validation rules, measured work counts and acceptance limitations.
