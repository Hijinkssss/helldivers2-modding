# Full Auto Assist 1.1.0 Final RC

This package is a test candidate for in-game validation. Do not treat it as release-ready until the live checks in `LIVE_TEST.md` pass.

Requires Bingus Shared Loader v18 / API 1 and Steam build 25480438. Import this ZIP in Arsenal, enable Full Auto Assist, deploy it, then run the HUD, Eruptor, and mission-performance checklist. Profiling, validation logging, HUD diagnostics, and debug logging are off in the supplied example configuration.

## Supported weapons

This candidate retains all 31 supported weapon identities. It includes MLS-4X Commando support and the APW-1 Anti-Materiel Rifle SPECIAL policy. Unknown weapons and native Full Auto weapons remain under game control. See `SUPPORTED_WEAPONS.md` for the roster.

## HUD indicator

The finalized three-cartridge indicator appears for supported weapons. It is hidden for unsupported weapons, opaque white for supported weapons while FAA is OFF, and yellow while FAA is ON. Its approved shape, size, placement, and spacing are preserved.

## Eruptor Cadence Control

FAA OFF releases FAA control and preserves the Eruptor's native hold-to-repeat behavior. With FAA ON, choose 27 RPM for slower cadence, 28 RPM for the balanced default, or 32 RPM for the vanilla maximum cadence. These are attempted Fire input rates; the game decides whether each input produces a shot. Validate sight recovery and input transitions in game.

## Unsupported Special weapons

ARC-3 Arc Thrower, PLAS-101 Purifier, PLAS-15 Loyalist, PLAS-39 Accelerator Rifle, and 40-K Meltagun are intentionally unsupported in this release candidate and remain under normal game control. They are future work pending separate validation. They are not enabled in this package.

## Safety and performance

FAA repeats only ordinary legal Fire inputs for supported policies. The game retains control of shot acceptance, weapon mechanics, ammo, aim, reload, recoil, and charge behavior. Live mission performance remains an explicit acceptance gate: sustained FAA/HUD processing must stay below 5 ms/s, with no major periodic spikes or runaway work. Synthetic timings do not satisfy this gate.
