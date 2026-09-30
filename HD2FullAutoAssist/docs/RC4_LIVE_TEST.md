# RC4 targeted Meltagun observation

This is one focused live observation. It addresses the Meltagun beam-state gap
and independently records the default left-mouse Fire input alongside the
processed Fire action. It does not validate synthetic Fire interception or
charge automation; no automated input is active in this build.

1. Close the game. In Arsenal, disable all other Full Auto Assist packages and
   enable only this RC4 research package plus Bingus Shared Loader v18. Leave
   ArcThrowerRevamped and its Megapack option disabled. Purge / Deploy.
2. Launch normally and confirm `charge_probe_ready` in the FAA log and
   `research_start` in `HD2FullAutoAssist-charge-probe.log`. If either is absent,
   stop; do not proceed with an unobserved run.
3. Use the default left-mouse Fire binding and the 40-K Meltagun. Hold Fire for
   one normal charge and beam. Keep the button physically down briefly after
   the visible beam ends, then release it and press once for one new cycle.
4. Exit normally and preserve the JSON Lines log before another launch.

The single observation compares `fire.raw_lmb.state` with the sampled processed
Fire fields through hold and release, and correlates the visible beam end with
the captured beam flag/counter/timer, charge reset, ammo, and next manual cycle.
If the beam row is `charge_row_absent`, the probe records only its bounded lookup
metadata; that outcome does not establish beam completion. Do not repeat the old
weapon matrix or infer completion from elapsed time, charge reset, or ammo loss.

This research package is not for performance measurement. It performs no Fire,
weapon-data, ammo, beam, or charge writes, no heap scan, no native function
calls, no synthetic input, and no automatic reload or weapon switch.
