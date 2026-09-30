# RC3 short live test

Use **one launch per weapon** so each gets its own 6,000-sample budget. Save the
Accelerator log before launching the Meltagun run. No manual timestamps needed.

## Setup and budget

- Close the game; enable **Full Auto Assist RC3 Charge Probe** with Bingus Shared
  Loader v18. Disable other FAA packages, ArcThrowerRevamped/Megapack Arc changes,
  and other weapon-stat changes. Purge / Deploy normally.
- A 60-90 FPS cap gives approximately 100-67 seconds of target-equipped sampling
  per launch. At 120 FPS the budget is 50 seconds; at 240 FPS it is 25 seconds.
  These are estimates; the recorder stops at 6,000 relevant samples regardless.
- Prepare your location and loadout with an **unrelated weapon held**. Equip the
  target only for the steps below. Unrelated weapons do not use the probe budget.
  Avoid long pauses with either target equipped. Do core cycles before optional
  empty/reload cases; do not prolong the run trying to obtain empty ammo.
- Confirm `charge_probe_ready` in `HD2FullAutoAssist.log` and an RC3
  `research_start` header listing both hashes in `HD2FullAutoAssist-charge-probe.log`.
  Equipping the target produces `charge_probe_target_seen` with its exact name/hash.
  No charge assistance should activate.

## Launch 1: PLAS-39 Accelerator Rifle

1. Idle two seconds with Accelerator held.
2. Perform **two normal full-charge/manual-discharge cycles**. On one, hold at
   full charge briefly, attempt a swap, then discharge and swap. Report whether
   swapping was blocked before discharge and allowed afterward. If it permits
   the first swap, report that and complete the second cycle after re-equipping.
3. Perform one early/interrupted release. A third full cycle is optional if quick.
4. If empty is quick to obtain: attempt ordinary Fire while empty, manually
   reload, and perform one fresh cycle. Otherwise skip this optional case.
5. Exit normally and save a copy of the probe file as
   `HD2FullAutoAssist-charge-probe-Accelerator-RC3-saved.log` before launching again.
   Confirm it contains Accelerator samples (`30061f91af477f5e`).

## Launch 2: 40-K Meltagun

1. Idle two seconds with Meltagun held.
2. Perform **two normal beams**. After one beam visibly ends, briefly keep Fire
   held, then manually release/re-press to start the next cycle. Report whether
   a new charge started before or only after that release/re-press.
3. Interrupt one charge or beam; identify which and how you interrupted it.
4. Perform one swap after a beam completes. This may be combined with step 2.
5. If practical: empty -> ordinary Fire attempt -> manual reload -> one fresh
   cycle. Skip if obtaining empty would exhaust the sampling budget.
6. Exit normally and save the probe as
   `HD2FullAutoAssist-charge-probe-Meltagun-RC3-saved.log`.

Both source logs are written to:
`%LOCALAPPDATA%\CowboyBingus\Helldivers2\Logs\HD2FullAutoAssist-charge-probe.log`.
The end record states sample counts by weapon and whether the limit was hit.
Save each recording before another launch. Keep visible firing, beam completion,
interruption, and swap feedback with the corresponding weapon; no worksheet.
Do not use this diagnostic package to compare release performance.
