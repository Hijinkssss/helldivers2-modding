# Full Auto Assist charge handoff

Branch: `feature/full-auto-assist-charge-weapons-hud`. Work resumed from
`d13073c9804cf2ce7ad4144ca0502f110c97b7df`; no main-branch restart, merge,
push, deployment, game launch, publication, or Nexus update occurred.

## Inspected evidence

- The previous authoritative `FAA_CHARGE_HANDOFF.md`, `FIVE_WEAPON_CHARGE_CHECKPOINT.md`, `CHARGE_REASSESSMENT.md`, native settings/beam disassembly, and pinned Runtime identity evidence.
- All four preserved RC2/RC3 recordings and `FIVE_WEAPON_CHARGE_PROBE_METRICS.json`; no broad research was repeated and original logs were not changed.
- Current charge observer/signals/research code, input and Fire lease adapter, controller, probe tests, package builder, and B3/next-version work-budget fixtures.

The earlier findings remain: Arc, Purifier, Loyalist, Accelerator, and Meltagun
charge cycles are researched; live charge automation remains disabled. The old
Meltagun beam row is absent in every preserved recording.

## Physical Fire gate

The processed Fire record is not a safe independent release signal while an
adapter owns/manipulates Fire. The RC4-only probe now samples Windows
`GetAsyncKeyState(VK_LBUTTON)` beside the processed action, with explicit
`independent_of_processed_fire=true` and `binding_verified=false`. This is an
independent OS observation of the left mouse button, not proof that it is the
active Fire binding for every user's keyboard/controller mapping. No charge
adapter was added and the existing ordinary repeat-mapping lease was not
changed.

**Classification: NEEDS ONE SMALL TARGETED LIVE TEST.** Use the default left
mouse Fire binding on one Meltagun hold/release and compare the raw and
processed fields. Generic keyboard/controller binding coverage and masking
while synthetic Fire is active remain unproven. All five charge weapons remain
blocked by this common input gate.

## Meltagun gate

Exact-build code confirms the Meltagun beam table layout at global
`0x33266d8`, with the hashed row map and 168-byte records. The updater transfers
request byte `+1` to active byte `+0`, clears counter `+4` when inactive,
decrements timer `+8`, and reaches native completion handling only after its
state predicate and timer conditions. This does not distinguish natural beam
completion from interruption or establish permission for the next charge.
The saved data still reports `row_absent`; no alternate entity or heap search
was attempted.

**Classification: NEEDS ONE SMALL TARGETED LIVE TEST.** RC4 records the exact
bounded held-entity row lookup metadata and the selected beam fields when
available. If the row remains absent, the test cannot establish completion and
the next step must correct a specifically proven ownership/observer defect.

## Missing-settings recorder fix

Root cause: the old observer stopped after a per-instance override lookup,
although stock getter `0x5052c0` falls back through `0x504d80` to the 20-slot
resource-hash table at owner `(game.dll+0x346bf98)+0xf12ad8`. The observer now
does the same bounded lookup, validates table-owner stability, selects the
216-byte record at table `+0x140`, and reports whether settings came from an
instance override or resource default. The resource slot is cached across
updates only while the root, table and full key still match; relocation or a
read failure invalidates it. The 24 selected bytes remain observational only;
they do not grant charge permission.

Regression fixtures cover collision chains, missing keys, empty-key termination,
instance-override precedence, table relocation, root read races, and failure
invalidation. Twenty repeated synthetic fallback samples reused the validated
slot after one initial table scan. No gameplay behavior consumes these settings.

## RC4 research package and test state

The smallest built package targets only the 40-K Meltagun. It is read-only and
does not synthesize input, write Fire/charge/beam/ammo fields, automate reload,
or switch weapons. The focused procedure is in `RC4_LIVE_TEST.md`.

Offline validation passed: 24 standalone groups; B3 cache, bounds, cadence and
Windows RPM checks; next-version/Eruptor/HUD and charge semantic regressions;
and deterministic package/archive verification. Normal B3 work budgets remain
unchanged because the observer is enabled only in the separate research
package. No charge automation work-budget or live-performance result exists.
These are not live measurements. User live targets (~5 ms/s idle and ~13–14
ms/s active) remain unverified for charge work.

All five charge weapons remain disabled. Do not implement the reusable charge
adapter until the two focused observations establish physical-release safety
and Meltagun beam completion/next-cycle permission. Keep all existing hard
scope exclusions and Eruptor 26/27/28/32 profiles.
