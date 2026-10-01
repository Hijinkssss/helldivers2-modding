# Changelog

## 1.1.0 Final RC

- Retains 31 supported weapons, including Commando and AMR/SPECIAL.
- Preserves the approved three-cartridge HUD appearance and state behavior.
- Adds Eruptor Cadence Control: 27 RPM slower, 28 RPM balanced default, and 32 RPM vanilla maximum cadence; FAA OFF preserves native hold-to-repeat.
- Includes bounded HUD processing work. Live mission performance under 5 ms/s remains a release gate.
- Keeps five charge Special weapons intentionally unsupported pending separate validation.

## 1.0.1

- Added validated identity and binding caches, bounded rediscovery, and native Fire restoration safeguards.
- Fixed low-cadence native Fire handling and retained exact-build safety gates.
- Profiling and validation logging are opt-in; default configuration keeps them disabled.
