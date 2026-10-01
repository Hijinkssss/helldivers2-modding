# Full Auto Assist 1.1.0

Full Auto Assist repeats ordinary Fire inputs for 31 supported weapons. Unknown and unsupported weapons remain under normal game control.

Requires Bingus Shared Loader v18 / API 1 and Steam build 25480438. Import this ZIP in Arsenal and enable Full Auto Assist. Profiling, validation logging, HUD diagnostics, and debug logging are off in the supplied example configuration.

## Supported weapons

The package includes all 31 supported weapon identities, MLS-4X Commando support, and the APW-1 Anti-Materiel Rifle SPECIAL policy. Unknown weapons and native Full Auto weapons remain under game control. See `SUPPORTED_WEAPONS.md` for the roster.

## HUD indicator

The finalized three-cartridge indicator appears for supported weapons. It is hidden for unsupported weapons, opaque white for supported weapons while FAA is OFF, and yellow while FAA is ON. Its approved shape, size, placement, and spacing are preserved.

## Eruptor Cadence Control

FAA OFF releases FAA control and preserves the Eruptor's native hold-to-repeat behavior. With FAA ON, choose 27 RPM for slower cadence, 28 RPM for the balanced default, or 32 RPM for the vanilla maximum cadence. These are attempted Fire input rates; the game decides whether each input produces a shot. Validate sight recovery and input transitions in game.

## Unsupported Special weapons

ARC-3 Arc Thrower, PLAS-101 Purifier, PLAS-15 Loyalist, PLAS-39 Accelerator Rifle, and 40-K Meltagun are intentionally unsupported and remain under normal game control. Charge automation is not included.

## Safety and performance

FAA repeats only ordinary legal Fire inputs for supported policies. The game retains control of shot acceptance, weapon mechanics, ammo, aim, reload, recoil, and charge behavior. In live testing, normal gameplay processing measured about 5–8 ms/s and stayed below 10 ms/s. Repeated toggle-spam stress can briefly reach about 10–12 ms/s.
