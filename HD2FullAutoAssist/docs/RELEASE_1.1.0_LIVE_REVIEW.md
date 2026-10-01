# v1.1.0 live validation record

The release request reports the following live acceptance results:

- HUD: supported OFF is visible in white, supported ON is visible in yellow, unsupported weapons hide the indicator, and placement is correct.
- Eruptor: 28 RPM is the default; 27 and 32 RPM remain available; OFF restores native 32 RPM hold behavior.
- Conventional weapons and Commando: validated functional behavior.
- Normal gameplay performance: approximately 5–6 ms/s idle and 7–8 ms/s in a mission. Ordinary toggles and toggling while firing showed no sustained result above 10 ms/s.
- Repeated toggle-spam stress can temporarily reach approximately 10–12 ms/s and is not considered representative gameplay.

Profiling, validation logging, HUD diagnostics, and debug logging are disabled in the public example configuration. Five charge Special weapons remain gated off.
