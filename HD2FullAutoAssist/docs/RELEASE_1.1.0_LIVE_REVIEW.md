# Final RC live-test checklist

Use the exact Final RC ZIP identified in the accompanying validation report. Keep profiling, validation logging, HUD diagnostics, and debug logging off during the acceptance run. Do not publish unless every section passes.

## A. HUD

- [ ] Unsupported weapon: FAA indicator hidden.
- [ ] Supported weapon with FAA OFF: indicator visible in the approved inactive white appearance.
- [ ] Supported weapon with FAA ON: indicator visible in the approved yellow appearance.
- [ ] Three-cartridge design and approved position/size/spacing remain unchanged. Report any actual visual defect before changing HUD code.

## B. Eruptor

- [ ] FAA OFF preserves native vanilla hold-to-repeat behavior.
- [ ] FAA ON at 27 RPM works.
- [ ] FAA ON at 28 RPM works and is the default balanced option.
- [ ] FAA ON at 32 RPM works as the vanilla maximum cadence option.
- [ ] Transitions produce no double-fire, missed-fire, stuck-input, or release/re-press artifacts.
- [ ] At 28 RPM, the practical sight picture recovers as intended.

## C. Live mission performance (hard gate)

Measure in a representative live mission with production diagnostics off. Record Mod Lag Watchdog sustained `ms/s` and `worst` readings, the scenario, and observations at 30 and 60 seconds.

- [ ] Sustained FAA/HUD processing is below 5 ms/s.
- [ ] No major periodic spikes or runaway per-frame work.
- [ ] No unexpected allocation/read growth or clear degradation while switching weapons or FAA state.
- [ ] If sustained processing is 5 ms/s or higher, stop and investigate; do not approve release.

## Report back

Provide the build/mission context and pass/fail plus observations for A, B, and C. Report the exact sustained and worst Watchdog readings. Release approval requires explicit confirmation that all three sections passed and no release-blocking regression was observed.
