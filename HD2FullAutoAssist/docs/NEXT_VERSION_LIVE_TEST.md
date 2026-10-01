> Historical development document. Current authority: COMPLETION_CHECKPOINT.md and REMAINING_WEAPON_AUDIT.md. Eruptor vanilla native hold-to-repeat is confirmed; OFF repetition is expected. Mode labels in historical tables are metadata, not held-trigger evidence.

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
   Repeat with Slower Cadence 27 and Balanced 28, using separate closed-game
   Arsenal selections and redeployment. Compare Maximum / native-speed cadence 32. Record shot
   count, intervals, sound/animation continuity and settling feel separately.
5. Test supported -> supported, supported -> unsupported -> supported, death /
   respawn, and ship -> mission -> ship. Confirm glyph and Fire mapping recovery.
   Swaps interrupting held Fire require release before FAA reacquisition.
6. Record Watchdog active-Fire cost with the Eruptor and a conventional assisted
   sidearm. Return to idle and check cost falls back. Exit the game normally.

## Research RC2: targeted manual observations only

Charge automation remains disabled. The logger contract is fixed; its JSON Lines
file is `%LOCALAPPDATA%/CowboyBingus/Helldivers2/Logs/HD2FullAutoAssist-charge-probe.log`.
Check `charge_probe_ready` in the normal FAA log and `research_start` in that file
before any cycles. Disable the ordinary candidate and ArcThrowerRevamped / its
Megapack option while selecting this separate research build. Preserve the log
before the next launch overwrites it.

The old broad four-weapon trace is superseded by CHARGE_REASSESSMENT.md. That file
explains each known native signal and exactly why each remaining test is needed.

1. Shared charge-release stage: Arc (short reference), Purifier and Loyalist,
   preferably in one mission. Idle two seconds per weapon, two normal full
   charge/release cycles, one early release, and one blocked swap while full
   followed by manual discharge and a successful swap. Fire/charge/native commands
   are recorded together; no manual timestamp worksheet. Compare the two plasma
   weapons before adding more cases. One empty Fire attempt/manual reload resolves
   the ammo gate; defer the second plasma empty case if their gate semantics and
   policy are demonstrably identical.
2. Meltagun stage: idle two seconds, two normal beams, briefly keep Fire held
   after one beam finishes then manually release/re-press, one interrupted charge
   or beam, and one swap after completion. One empty Fire attempt -> manual reload
   -> normal cycle distinguishes completion/restart from reload denial.

This is a bounded read-only probe, not a request to perform testing immediately.
It samples each relevant stock update, stops after 6,000 relevant samples per
launch (100 seconds at 60 FPS, 50 at 120, 25 at 240), and flushes on normal exit.
The normal header/end records and field-specific unavailable states make failure
visible. There are no charge/beam/ammo writes, heap scans, native function calls,
synthetic charge releases, automatic reloads or weapon switches. Existing ordinary
FAA behavior remains in the package. Unrelated weapons perform no probe reads.

Do not compare Watchdog performance with research enabled. The ordinary candidate
still needs Eruptor/HUD gameplay and wall-time validation. The eventual charge
Fire-edge adapter needs separate observed physical release, stock cycle/cadence,
ammo, restoration and performance validation before assistance can be enabled.
