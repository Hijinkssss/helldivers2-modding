# RC8: first-launch activation diagnosis

This is a diagnostic candidate, not a proven startup fix. RC7's offline delayed
mission/avatar fixture already passes. No root cause explaining the reported
first-toggle activation has been established. Weapon policy, settings, callback
order, preference changes, release guards and mapping writes are unchanged.

## One fresh-launch reproduction

1. Select this RC8 package in Arsenal in place of RC7, using the same profiles
   and existing INI. Do not enable a second copy or change the toggle binding.
2. Launch fresh, enter the first mission, equip an eligible weapon and hold
   Fire before pressing any toggle. Release Fire.
3. Press the configured toggle once. Hold Fire again, then release it. If that
   first press leaves assistance off, press it once more and try another hold.
4. Close the game and provide `HD2FullAutoAssist.log` from the Shared Loader's
   Logs directory, normally `%LOCALAPPDATA%/CowboyBingus/Helldivers2/Logs/`.
   State which hold actually repeated in game. Preserve this log before another
   launch. Diagnostics are enabled in this RC; no INI edit is needed.

## Reading the capture

Each `startup_diagnostic` record has a monotonic sequence and phase. A records
controller initialization; B the first observed non-mission native state; C
native game state 4; D the first present avatar; E the first effective weapon;
F the first held Fire or raw left-mouse attempt before any accepted toggle; G
and H bracket each toggle callback, including rejected callbacks; I records
the first post-toggle lease and subsequent native repeat pulse. A pulse is input
evidence, not proof of a fired shot. If a phase never occurs, its absence matters.

Compare F/G with H/I. Every snapshot includes preference and resolved state,
revision, identity, cadence limit, lease identity, release latch, input sample,
current host eligibility, begin attempt/result/reason, restore count/reason,
toggle counts, registration state, fallback suppression and callback arming.
`runtime` identifies the frame and callback stage. Order remains identity then
Fire, original game update, then toggle polling. Native registration retains
its existing one-frame return and release-to-arm behavior.

Top-level sampled Fire fields are the last **controller** sample. In particular,
OFF controllers can retain an older sample because RC7 skips their Fire tick.
`native.value.sample` is an independent fresh read at the diagnostic event;
it also observes mission/player readiness while Fire is idle. `native` includes
current Fire mapping kinds, triggers and intervals, saved-original record count,
restoration state and write counters. Failed diagnostic reads are reported as
data and never become control decisions. Identity fields are the controller's
resolved identity; D also records the observed avatar if its weapon is not ready.

`restore_before` and `restore_after` show whether backend restoration actually
ran. With no lease, RC7's restore clears repeat and leased identities and returns;
it does not construct a backend, capture mappings or register input. With a lease,
it restores owned mappings. Toggle then flips `user_enabled`, recomputes effective
state and sets `wait_release=true`. There is no proven hidden initialization here.

Fresh native inspection is read-only. Routine polling is at most 10 Hz with
immediate controller-held edges, and only semantic transitions are logged.
Repeated identical release restores are counted without per-frame records.
Routine output is capped at 600 records; first-phase and toggle records remain
available beyond the cap. Diagnostic timestamps use the host clock where present.

## Offline evidence and limits

The dedicated diagnostic fixture verifies A-I, default ON, first-toggle OFF,
second-toggle ON, rejected toggles, source attribution, complete fields, bounded
steady-hold logging and diagnostic-read failure isolation. The real lifecycle
fixture verifies fallback/native registration, callback stages and absence of
duplicate toggles. Existing startup, mission persistence, focus/menu/weapon,
release and native mapping tests remain required.

These tests validate instrumentation and preserve RC7 behavior. They do not
reproduce the user's failure. Whether callback ordering, backend initialization
or Mod Bindings registration explains the live mismatch remains unknown until
the fresh-launch log is compared with observed firing.
