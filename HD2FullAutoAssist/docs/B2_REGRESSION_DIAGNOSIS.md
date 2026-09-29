> Historical development record. Current release status and validation are in [RELEASE_1.0.1.md](RELEASE_1.0.1.md).

# B2 regression diagnosis, 2026-09-29

## Confirmed failure before the fix

The retained live loader log records `assist_disabled` with
`mods/codex/hd2_full_auto_assist.lua:1222: Invalid consumer repeat cadence`.
Line 1222 of the delivered 25e12d5 B bundle is the native `begin` assertion
`repeat_seconds>=60/900 and repeat_seconds<=1`. The same log's shutdown
summary has `errors=1`, `holds=0`, `mapping_writes=0`, `identity_lookups=1999`,
and `identity_changes=2`. It was initialized and sampled, then permanently
disabled before acquiring any Fire mapping lease in this recorded run.

Policy supports Eruptor at 32 RPM (1.875 s) and Crossbow at 50 RPM (1.2 s).
Both violate the backend's inherited one-second upper bound. The controller
successfully resolves identity and policy, computes `60/max_repeat_rpm`, then
calls `backend:begin`. That assertion throws before the first mapping write.
The controller catches it in `tick`, invokes `fail`, invalidates state, and
removes the toggle, Fire and identity callbacks after restoration. `failed`
remains true; neither a weapon swap, Fire release nor mission transition
reinstalls them. The wrapper remains attached until shutdown but now does
almost no work. Watchdog v0.7.1's installed source sorts its rolling 30-second
window by cumulative self time and shows only eight rows (`PANEL_ROWS=8`);
log summaries show ten. It does not filter FAA by a minimum-time threshold.
The retained Watchdog log still maps FAA as link #6 via `previous`, reports
47.41 ms/s at t=181.74, 20.20 at t=241.74, then omits FAA from the top ten
from t=301.75 through shutdown at t=992.55. The chain remains 23 links and
Watchdog remains on top. This supports callback removal followed by rank
loss, with a nearly empty FAA wrapper still executing. There is no evidence
of a new attribution source or broken Watchdog timing in this run.

An offline byte-memory fixture using the actual lifecycle, observer, state,
policy, controller and native backend reproduced the same exception and zero
callbacks for **all three requested commits**: fa186bd, c483ad7 and 25e12d5.
Peacemaker -> Eruptor -> Verdict gives one initial successful lease, exact
restoration on swap, then the cadence exception and no Verdict assistance.
Eruptor as the first weapon fails before any successful lease. Cookout,
Verdict and Talon each acquire correctly in a fresh fixture on all three refs.
The mismatch therefore predates 25e12d5. None of its three optimizations
caused this confirmed failure, and reverting them would retain it.

The reported initial Eruptor assistance is user-observed behavior, but this
log has no successful FAA leases. It cannot establish that FAA actually
assisted Eruptor or that initial-only identity caching occurred. There is no
weapon/hash field on the error with ordinary logging, so the exact equipped
weapon at the live exception is unknown. Eruptor/Crossbow are the deterministic
violators under the supplied default configuration. Other live issues cannot
be ruled out until the corrected B2 is tested. Do not reinterpret observations
as proof of an identity regression or claim a live performance improvement.

## Complete optimization semantic comparison

fa186bd -> c483ad7 changes only PERFORMANCE_INVESTIGATION.md; runtime source
is identical. c483ad7 -> 25e12d5 has these runtime changes and no others:

1. Lifecycle symbol resolution for the identity observer returns a bounded,
   fixed module-global address without a preliminary eight-byte read. It
   still checks the RVA against the validated PE image size. The public
   `host:symbol` remains guarded. The removed `self:read(address,8)` returned
   bytes that were discarded; it had no root assignment, observer generation,
   invalidation or recovery side effect. `global` immediately reads that same
   address with `ptr_at(...,true)` and saves its bytes for end-of-snapshot
   revalidation. Every snapshot resolves the global anew and dereferences
   fresh bytes. Memory/read/query diagnostic counts decrease, as intended.
2. The pre-stock wrapper adds an outer `read_scope` around identity and Fire
   dispatch. Nested observer/Fire scopes reuse it. Cache entries are fresh Lua
   tables copied from Windows VirtualQuery's output, not aliases to its FFI
   scratch buffer. Lookup requires `base <= cursor < base+size`; every span is
   walked and state/protection/bounds checked before ReadProcessMemory.
   An address outside that interval needs its own query, even after a root,
   record or held-weapon pointer changes. Raw bytes, pointers and identity
   are never cached. The scope is cleared by protected cleanup before stock
   game code and on errors. Invalid page rows also expire on that update.
   As with any query followed by a read, this is not an atomic memory snapshot;
   the actual read must succeed and identity guards must still match.
3. Controller sampling now passes `trace~=nil`; native sampling calls
   `raw_lmb_down` only when that flag is true. Its Windows implementation only
   tests GetAsyncKeyState(1)'s high bit. The adapter still initializes user32,
   identity and toggle input still initialize separately, and callback order
   is unchanged. `raw_lmb_down` is consumed only by validation_trace. There
   are no initialization or recovery side effects in the removed call.

## Weapon transition path

There is no persistent observer generation or identity-pointer cache.
Observer counters are diagnostics, not invalidation controls. Each snapshot
walks/revalidates the current globals, avatar, held entity and equipment
record. Identity callback runs every 100 ms without a lease; active Fire
resolves every update. AssistState caches only the immutable policy decision
under normalized resource hash. A different entity with the same hash still
changes state and tears down a lease; a changed hash reclassifies policy.
Invalid identity clears the decision and hash. Controller fingerprint includes
unit, avatar, entity, hash, category and observation status.

On an active A -> B swap, `resolve(row.unit_ref)` compares the new unit/entity/
hash against the leased values, restores A's exact original mapping bytes,
clears lease identity and sets `wait_release`. Releasing Fire clears that
flag. B's next press resolves fresh identity, computes B cadence and reacquires
the current mapping owner. C repeats the same sequence. For a slow supported
weapon the pre-fix divergence occurs at native `begin`'s cadence assertion,
after successful identity/policy acquisition, not at pointer refresh.

## Error and recovery audit

Expected identity-read/layout/race failures become a failed Result inside
Observer.snapshot; AssistState invalidates, an active lease restores, and
fresh acquisition is retried after release. Eligibility unavailability and
non-gameplay states similarly suppress assistance without removing callbacks.
Native layout/mapping/read exceptions in tick intentionally use permanent
consumer fail-closed cleanup; this patch does not broadly convert unsafe
native failures into retryable states. Restoration errors retain the Fire
hook only while a lease still needs restoration. Binding-context changes
clear the lease and preserve foreign edits. Host callback/input errors call
host.stop; a failed cleanup retains callbacks for retry. Stock update errors
also restore then propagate. Optional log write/flush errors increment
log_errors and cannot alter identity. The observed cadence exception is
neither swallowed nor a stuck release flag; it is logged and disables all
normal processing.

## Smallest correction

Extend only the finite native cadence upper bound from 1 s to `60/32` s,
the slowest supported policy. Retain the 900 RPM lower bound, type/NaN checks,
all guarded reads, mapping validation, write verification, restoration and
permanent fail-closed behavior for genuine unsafe native exceptions. Do not
clamp cadence to 1 s: that would speed Eruptor/Crossbow beyond their policy.
No optimization is reverted and no deeper performance changes are introduced.
Test all supported policies/profiles through the real native backend rather
than the permissive fake `begin` that masked this mismatch in the old suite.

B2 remains unpublished and requires fresh live transition/recovery validation
before any performance comparison is valid.

## Offline validation

All 20 `run_standalone.py` groups passed. New integrated checks cover all 30
assisted resources in both modes, all 16 selectable profiles, initial
acquisition, A -> B -> C, both directions of Eruptor/Talon and Cookout/Verdict,
supported -> unsupported -> supported, exact mapping teardown/reacquisition,
hash and entity changes independently, root relocation between identity and
Fire in the same update, failed identity read/page followed by recovery,
ship/mission in both directions, and death followed by a different unit/avatar
identity. New page tests require address containment, exclusive region ends,
cross-page checks, fresh raw bytes, mismatched-region rejection and cleanup
after nested errors. Cadence tests reject invalid/NaN/infinite/out-of-range
values before writes. Original mapping conflict, rollback, focus/UI, toggles,
exact-build and profiler tests also pass. Synthetic respawn is not live
gameplay validation.

The full existing package suite also passed in an isolated packaging copy:
actual Shared Loader discovery, Lua/source/archive/ZIP parity, option archives,
missing-loader and unsupported-process startup rejection, and deterministic
rebuild. Its inherited `live_standalone_validated` release metadata is not
B2 evidence. The final B2 verification report explicitly marks live behavior
and performance unvalidated, and verifies the delivered diagnostics-off INI
through a native Eruptor -> Talon replay with profiler/trace constructors
forbidden.
