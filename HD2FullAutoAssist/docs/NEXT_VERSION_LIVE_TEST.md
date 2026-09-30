# Controlled next-version validation

## Ordinary candidate: Eruptor and HUD

1. Close the game. In Arsenal disable other FAA packages and enable this candidate
   plus Bingus Shared Loader v18. Keep a copy of the v1.0.1 selection for rollback.
   Purge / Deploy. Verify the active INI has profiling, validation and debug
   logging OFF. Launch normally.
2. Check Mod Lag Watchdog for 30 seconds aboard ship without Fire or toggles.
   Record measured FAA ms/s and configuration. Compare with the user's roughly
   5 ms/s v1.0.1 result. Synthetic work counts do not predict this wall time.
3. Enter a mission with Eruptor and a familiar assisted sidearm. Confirm the small
   glyph appears beside ammo, disappears when FAA is toggled OFF, reappears ON,
   and disappears on unsupported weapons. Check HUD scale/offset settings and
   whether it obstructs any native HUD element. Capture a screenshot for layout.
4. Hold Eruptor Fire across several bolts; release and check immediate stop.
   Repeat with Stable 26, Balanced 27 and Fast 28, using separate closed-game
   Arsenal selections and redeployment. Optionally compare Max 32. Record shot
   count, intervals, sound/animation continuity and settling feel separately.
5. Test supported -> supported, supported -> unsupported -> supported, death /
   respawn, and ship -> mission -> ship. Confirm glyph and Fire mapping recovery.
   Swaps interrupting held Fire require release before FAA reacquisition.
6. Record Watchdog active-Fire cost with the Eruptor and a conventional assisted
   sidearm. Return to idle and check cost falls back. Exit the game normally.

## Charge Research candidate: manual cycles only

This package does NOT repeat charge weapons. Its purpose is to resolve native
signals before automation. Disable the ordinary candidate when selecting it.
Disable ArcThrowerRevamped, its Megapack option, and other charge/weapon-stat mods
so traces describe stock behavior. No new installation/deployment is automatic.

The observer samples at most 50 times/second, reads a bounded charge table and
records raw charge/settings/Fire bytes. It caches the selected slot and validates
roots, index and identity on reuse. It never writes charge or weapon records.
It stops after 10,000 relevant samples (about 200 seconds at 50 Hz). Normal exit
flushes/closes the trace. The log is
`%LOCALAPPDATA%/CowboyBingus/Helldivers2/Logs/HD2FullAutoAssist-charge-research.jsonl`.
Save the log under a unique weapon/session name before another launch overwrites
it. An `unavailable` or `charge_row_absent` record is a research result, not a
reason to relax guards.

Use one weapon per fresh run, recording action timestamps:

1. Arc Thrower: idle, initial hold through ready, manual release/fire, four
   consecutive manual charge/release cycles, release partway through charge,
   swap away during hold, swap back and manually fire again.
2. Purifier: idle, short hold/release, full hold/manual release, four full-charge
   manual cycles, release during charge, empty magazine, attempt Fire while
   empty, manual reload, then another normal cycle.
3. Loyalist: the same sequence as Purifier, identifying full-charge audio/visual
   cues and recording how many rounds are consumed by each manual release.
4. Meltagun: hold through charge and the entire beam, keep holding after beam
   ends, then manually release and re-press. Perform four consecutive manual
   beam cycles; release during charge, during beam and after beam. Empty the
   weapon, attempt Fire, reload manually, and repeat one beam. Record beam start
   and end times and audio continuity. No Reload input is emitted by FAA.
5. For each, also swap charge -> conventional -> charge, die/respawn, and return
   to ship. Confirm charge weapons have no FAA lease or indicator.

Keep the 50-Hz research observer OFF for comparative Watchdog measurements.
Its diagnostic cost is deliberately separate from the ordinary candidate.

## Automation live pass after the evidence gate

These checks are pending and cannot be performed with this partial candidate:
automatic Arc repeated firing, Purifier repeated full-charge firing, Loyalist
repeat charge/fire, and Meltagun consecutive beams until manual reload is
required. Once native observation and Fire-edge integration are verified, build
a new profiling/logging-OFF candidate and perform these holds/releases, swaps,
death/respawn and ship/mission transitions, then 30-second Watchdog idle and
active-Fire measurements for each new weapon. Never infer acceptance from raw
logs, a synthetic state machine, or successful package loading.
