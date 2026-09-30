# Charge evidence reassessment, research RC2

> Historical analysis. Current checkpoint: `FAA_CHARGE_HANDOFF.md`. The current
> unpublished RC4 research build targets the Meltagun alone, adds the verified
> stock resource-settings fallback, and records a raw left-mouse diagnostic.
> The settings fix has offline regression coverage; physical binding correlation
> and Meltagun beam completion still need the single focused RC4 observation.

Continued `feature/full-auto-assist-charge-weapons-hud` from `12a60aa`.
No merge, publication, Nexus update, installation, deployment, game launch or
live process access occurred. The ordinary controller/cache/native Fire path,
HUD and Eruptor 26/27/28/32 RPM profiles are preserved. All four charge weapons
remain denied assistance.

## Logger failure: confirmed filename contract mismatch

The installed normal log reports `charge_research_unavailable` with
`Charge research log unavailable`, after `initialized`. The installed loader log
identifies `loader-v18; API 1`. Thus the research option ran, reached its
constructor, and failed before its first research record.

Shared Loader `open_log` accepts only `^[%w_-]+%.log$`. RC1 passed
`HD2FullAutoAssist-charge-research.jsonl`. That is rejected before directory
initialization or `io.open`. This particular failure was not caused by directory
permissions, callback order, shutdown flushing or a misplaced output file.
Those can independently fail, but are not needed to explain the observed error.
RC1's logger fixture accepted that invalid filename, masking the integration bug.

RC2 uses `HD2FullAutoAssist-charge-probe.log`, still containing JSON Lines.
It flushes its header immediately, logs `charge_probe_ready` with the exact name,
flushes buffered samples once per second and closes at shutdown or its sample
limit. Close is attempted even after a write/flush failure. Diagnostic failure
does not prevent the conventional Fire lease from being restored. The actual
loader logging implementation now has a fixture check for the rejected old
name, corrected path, directory creation and nonfatal I/O failure.

## What ArcThrowerRevamped establishes

Pinned [ArcThrowerRevamped v1.6 source](https://github.com/CowboyBingus/VanillaPlusMegapack/blob/1b943e61d2436f204fb5d8740a6082f44a780e42/components/ArcThrowerRevamped/src/arc_thrower_auto.lua),
commit `1b943e61d2436f204fb5d8740a6082f44a780e42`, source SHA-256
`041c162fab76448f027dad176d752d438ed50036f06022aca8ba2b3793c1cc65`:

* It binds the local player Fire action, native Arc fire command, ownership,
  complete entity record and bounded charge-table slot. Cached bindings follow
  compaction/relocation and are revalidated; ordinary weapons avoid charge scans.
* Progress is the float at charge runtime row `+4`. Its diagnostics infer shots
  from a large drop in that float; this is a reset heuristic, not a shot event.
* It calls `+8` "full-charge time". FAA must not adopt that interpretation:
  exact-build code below shows that the engine writes discharged charge into it.
* It patches settings `+184` (`auto_fire_in_safety`) and asserts runtime `+12`
  every active update. The native updater then crosses the safety boundary,
  dispatches and resets charge. The engine advances charge; the mod does not
  implement an input-only release/re-press adapter.
* Recovery uses identity/ownership/slot checks, brief input-outage handling,
  bounded rediscovery and stalled-progress detection. It does not expose a
  general ready, beam-ended, reload-required or next-charge-permitted predicate.

FAA can reuse the demonstrated read paths and caching principles. It cannot
copy either write under this request's input-assistance scope. The reference
README distinguishes earlier solo validation from v1.6 recovery changes still
awaiting gameplay verification. Source is strong implementation evidence, not
new FAA gameplay acceptance.

Megapack's Arc and ModBindingsMenu handling confirm native processed-action
layouts and bounded owner/action lookup. They do not supply a stock charge
release adapter or a shared Arc/Purifier/Loyalist swap-lock predicate. FAA's
current backend independently retains physical mapping magnitude during an
ordinary repeat lease. That does not prove independence while synthesizing a
charge-release edge. No fake keypress or direct weapon-state write was added.

## Exact-build native findings

Analysis used only the existing captured module image, SHA-256
`e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969`.
Its recorded game.dll identity is
`2e2c3b7c2500646dadd5f2b4c6e0504dbb7e7896139f64cddc0d1813c718f51e`,
Steam build `25480438`. These are RVAs for that image, not cross-build guesses.

The shared charge manager is `0x3326c20`; entity pointers are at manager `+56`,
runtime rows at `+64`, 40 bytes each. Settings lookup uses the entity map at
manager `+80` and 216-byte settings at `+144`. In updater `0x73c8f0`:

| Field | Confirmed native operation | Limit on interpretation |
| --- | --- | --- |
| runtime `+4` | Loaded at `0x73ca7c`, advanced by update delta at `0x73cc1e`, stored at `0x73cc23` | Current charge accumulation; not sufficient by itself to authorize a new shot |
| settings `+0/+24/+48` | Loaded at `0x73cafe/0x73cb04/0x73cb0a`; compared at charge/release boundaries | Component charge levels; thresholds must come from the bound instance |
| runtime `+12` | Tested at `0x73cb76`; set/cleared by trigger handling at `0x740a88/0x740bb0` | Charge advancement flag, not proof of fully ready or swap lock |
| settings `+184` | Tested at `0x73cc42` before automatic boundary dispatch | Explains Bingus's auto-fire patch; FAA must leave it unchanged |
| runtime `+8` | Current charge copied at `0x73cc5b`, `0x73cdab`, `0x73cdde`; consumed for discharge level selection at `0x73db3d/0x73db65` | Latched/discharged charge, not a permanent duration threshold |
| runtime `+32` | Used with entity-active eligibility at `0x73ca90`; cleared by dispatch at `0x73d948` | Candidate latch to correlate with the reported committed/swap-locked state; no proven swap-lock equivalence |
| runtime `+24` | Decremented at `0x73cb17`; positive value takes recovery path | Native recovery timer for the shared component; zero alone is not full can-fire permission |
| trigger runtime/command | Manager `0x3326660`, 40-byte rows at `+80`, command bytes at `+88`; code `0x7406a0` | Records stock command/flags; helper `0x744ad0` checks several additional conditions |

The release path compares previous charge against settings `+0` at `0x73cdcf`,
latches it into `+8`, conditionally dispatches `0x73d8c0` and clears `+4`.
The held path uses settings `+24` and its auto-fire flag. That gives a common
charge/release implementation without inventing a duration. It does not prove
all three requested weapons have identical policies or that every reset is a
successful shot. Excluded charge weapons can also use this generic component.

Pinned Runtime audit `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595` already identifies
Arc and Meltagun as unique owners of `WeaponChargeComponentData` (`0xEAC335A1`),
records 6 and 7 respectively. Its existing read-only snapshot reports charge
levels approximately `[1,1.1,1.2]` for Arc and `[0.4,0.5,1]` for Meltagun.
These are instance metadata evidence, not values hard-coded into automation.
The available player catalog identifies Purifier/Loyalist uniquely but does not
provide the same component ownership/charge-level snapshot. Their working
runtime membership must be checked by the narrow observer.

Meltagun uniquely owns a Beam component in that audit. Native trigger code
at `0x740790/0x73ce6e` accesses 168-byte beam rows at manager `+120`, through
the map at `+80` on global `0x33266d8`. It writes request byte `+1`; code around
`0x80e0ac` transfers it to byte `+0`, clears counter `+4` and decrements timer
`+8`. These are the three narrowly selected lifecycle fields, not a complete
semantic beam/can-fire model. A beam timer or request byte alone cannot prove
Meltagun's actual beam has completed or another charge is permitted.

Stock ammo gating at `0x744c20` reads global `0x3326648`, its map `+32`,
16-byte count/state rows at `+72` and 12-byte flags at `+80`, with different
branches for magazine types. The probe records these exact gate records only
for the ammo-using requested weapons. It never reloads or manages ammunition.

The reported swap lock is a useful correlation target. No traced switch-input
consumer yet proves it is runtime `+32`, charge progress, or a shared distinct
state. Do not label the observed latch a swap permission field.

## Classification and minimum remaining evidence

| Weapon | Classification | Already known | Exact remaining question |
| --- | --- | --- | --- |
| Arc Thrower | NEEDS SMALL TARGETED LIVE PROBE | Identity, charge component/levels, progression, dispatch/reset and Bingus's cycling mechanism | In stock input-only behavior, which ready/latch and recovery transitions surround manual release, and does a fresh ordinary press begin the next cycle? The eventual release/re-press adapter also needs validation. |
| Purifier | NEEDS SMALL TARGETED LIVE PROBE | Unique resource; generic native charge/release path | Does its held instance occupy this same table and use the same boundaries/latch/reset path? Which stock ammo flags change at empty/reload? |
| Loyalist | NEEDS SMALL TARGETED LIVE PROBE | Unique resource; likely related behavior | Does it match Purifier's shared field semantics despite a potentially different ammo/charge policy? |
| Meltagun | NEEDS SMALL TARGETED LIVE PROBE | Identity; shared charge component; distinct Beam component; charge levels; beam request/current/timer and stock ammo-gate layouts | Which beam transitions distinguish running/completed from interrupted, and which charge/trigger/ammo combination permits a new cycle after completion but denies it at empty? |

None requires a full manual trace on current evidence. None is yet safely
implementable as FAA input-only automation. The broader RC1 recorder is no
longer needed: its 216-byte settings dump, four fresh sessions, four repeated
cycles, deaths and ship transitions add no evidence to these narrow questions.

Use one shared observer and existing semantic cycle abstraction. Weapon policy
selects release-at-confirmed-ready or restart-after-confirmed-discharge/beam-end.
Only validated semantics may enter that abstraction; field guesses, reset-as-
shot heuristics and arbitrary timers must not. Input edge restoration, physical
release independence and full next-cycle permission remain integration gates.

## Minimal staged live probe, when the user chooses to test

This is a build for the user to deploy; no game or installed files were changed.
First verify `charge_probe_ready` and the immediately flushed `research_start`
in `HD2FullAutoAssist-charge-probe.log`. JSON Lines are intentionally in `.log`.
Disable ArcThrowerRevamped / its Megapack option and other weapon-stat changes
to observe vanilla fields. Preserve the log before another launch overwrites it.

First stage: shared charge-release comparison, with Arc, Purifier and Loyalist
in one mission where practical. Arc is a short reference check, not rediscovery
of every established behavior. For each, idle 2 seconds and perform two normal
charge/release cycles. On one cycle hold the full cue briefly, attempt one swap,
then manually discharge and swap successfully. Perform one early release.
No per-action timestamps are required: Fire/command/charge are recorded together.
Report only the weapon and whether the full cue and blocked/allowed swaps behaved
as described. Compare Purifier/Loyalist before adding any more cases. One empty
attempt and manual reload for each ammo weapon resolves its own gate; if the
gate semantics and policy are identical after the first weapon, defer the
second empty case to final automation validation.

Second stage: Meltagun alone. Idle 2 seconds, perform two normal beams (on one,
keep Fire held briefly after the beam ends, then manually release/re-press),
one interrupted charge or beam, and one swap after beam completion. If available,
finish with empty -> ordinary Fire attempt -> manual reload -> one fresh cycle.
Those cases separate actual beam completion, interruption, renewed charge
permission and reload denial. No additional fields or manual trace template.

The recorder samples after each relevant stock update to avoid dropping a
one-frame reset between 50-Hz polls, capped at 6,000 relevant samples per launch
(about 100 seconds at 60 FPS, 50 at 120, 25 at 240). Unrelated weapons perform
zero probe-native reads. Missing optional tables are marked unavailable/absent;
they never relax native bounds or authorize writes. Absence rediscovery is
throttled to 250 ms. The settings sample is only 24 selected bytes. Meltagun
alone gets a 12-byte beam sample; Arc skips ammo. Existing state and full entity
records guard charge/trigger reuse. Beam/ammo maps and roots are rechecked, but
their values remain research observations, never cached eligibility.

The existing controller updates held identity every 100 ms; a swap boundary can
therefore lag by up to that polling interval. Do not infer an exact swap-lock
timestamp or physical binding from the processed-action samples. Full physical
Fire behavior must be verified when an input adapter is eventually implemented.
No SDK, game function call, heap scan, charge write or weapon-data write is added.

## Validation and performance boundary

RC2 tests cover actual Loader filename handling, accepted output path,
sample limit, shutdown/disk failure, cache reuse/relocation, generation change,
missing bindings, zero charge writes and scoped beam/ammo reads. Conventional
idle/held native-work counts are compared with v1.0.1, including all four denied
charge identities. Eruptor profiles and retained HUD regressions remain covered.
Build/package audits verify dependency/discovery and deterministic archives.

Offline work parity does not establish the user's ~5 ms/s idle or ~13–14 ms/s
active wall time. The probe deliberately adds diagnostics only in its separate
research package; do not measure release performance with it enabled. Gameplay,
HUD placement, charge automation and live performance remain unverified.
