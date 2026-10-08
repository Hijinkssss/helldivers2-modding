# Full Auto Assist 1.2.0

Full Auto Assist is an accessibility feature that repeats ordinary Fire input while held for 31 supported weapons, reducing the need for repeated clicks or presses. The game controls accepted shots and weapon behavior. FAA does not change damage, recoil, ammunition, projectiles, penetration, heat, aim, reload, or native weapon statistics.

## Installation and updating

1. Close Helldivers 2 before updating mods.
2. Install Bingus Shared Loader v18+ / API 1. FAA supports Steam build 25480438 behind its existing exact EXE/game.dll fingerprint gate.
3. Import `Full-Auto-Assist-1.2.0-Arsenal.zip` into Arsenal, enable its Full Auto Assist Core, and deploy exactly one FAA runtime. Disable any separately installed private FAA candidate before deploying this public package.
4. Optional: install CowboyBingus Mod Options Menu v1.2 / API 1 for in-game FAA settings. Install only one copy of that menu. FAA remains functional without it.
5. Keep your existing INI and saved menu values. Do not overwrite them with the example configuration. No settings reset is required.

The package keeps the public FAA GUID `cf368f5c-f686-453f-a566-435b4b7fcf26`. Older public Arsenal entries update under that identity. Private trial entries have a different GUID and must be disabled separately.

For manual installation, use only the three files in `Core/`, with one matching, unused patch suffix for the archive and both sidecars. Replace only an identified previous FAA slot. Do not overwrite another mod's archive or install a second FAA copy. Arsenal may assign patch suffixes during deployment.

## Controls and settings

FAA starts ON by default for a fresh configuration. Press `=` (`+` on some keyboard layouts) to toggle; optional Mod Bindings Menu integration retains the rebindable action. Existing `user_enabled` settings are respected. With Mod Options Menu, FAA Enabled and the nine weapon profile rows use saved, applied values. Select a profile and use the menu's Apply control. The toggle stays synchronized with FAA Enabled. Release Fire after changing a profile or enabling FAA before starting another assisted hold.

Applied/saved menu values take precedence. Legacy Arsenal option addons can seed missing menu choices, ahead of explicit per-weapon INI choices, legacy INI mode and built-in defaults. Existing keys and profile indices keep their meaning. Without the optional menu, the legacy Arsenal/INI/default path remains available. This Core package needs no separate profile addons.

Optional INI: `%LOCALAPPDATA%\CowboyBingus\Helldivers2\HD2FullAutoAssist.ini`. The supplied example leaves profiling, validation logging, HUD diagnostics and debug logging OFF. It is an example, not a replacement for your settings.

## Input cadence profiles

RPM values control repeated Fire input cadence. They do not modify weapon statistics or guarantee that every attempted input produces a shot.

| Weapon | Profiles (attempted Fire inputs per minute) |
|---|---|
| P-2 Peacemaker | Balanced 380; Full Auto 900 |
| M6C/SOCOM | Balanced 380; Full Auto 900 |
| P-69 Veto | Balanced 380; Full Auto 750 |
| LAS-58 Talon | Balanced 210; Efficiency 60; Full Auto 380; FULLER AUTO 750 |
| APW-1 Anti-Materiel Rifle | Balanced 120; Full Auto 400 |
| MLS-4X Commando | Balanced 120; Full Auto 240 |
| R-4 Hyena | Balanced 120; Full Auto 190 |
| SG-22 Bushwhacker | Balanced 90; Full Auto 650 |
| R-36 Eruptor | Balanced/default 28; Slower 27; Maximum/native-speed 32 |

Balanced remains the default. FAA OFF preserves the Eruptor's native held-fire behavior. The existing supported roster, burst behavior, Fire release/swap/toggle cleanup and restoration guards remain intact. See [supported weapons](docs/SUPPORTED_WEAPONS_1.2.0.md).

## HUD and unsupported weapons

The existing three-cartridge indicator is yellow for supported weapons with FAA ON, white with FAA OFF, and hidden for unsupported weapons. Unknown and native Full Auto weapons remain under normal game control.

ARC-3 Arc Thrower, PLAS-101 Purifier, PLAS-15 Loyalist, PLAS-39 Accelerator Rifle and 40-K Meltagun remain intentionally unsupported. Charge automation is not included. HD2ModCore and HD2Runtime are not required.

## Measured gameplay performance

Verified Candidate D gameplay measurements supplied by the tester:

| Metric | Peacemaker | Full mission |
|---|---:|---:|
| Duration | 4 minutes | 12 minutes |
| Average | 7.7 ms/s | 7.9 ms/s |
| Worst minute | 12.0 ms/s | 12.7 ms/s |
| Worst frame | 3 ms | 3 ms |
| Stalls >=150 ms | 0 | 0 |

The full mission used AMR, Eruptor and Commando in Balanced mode. These are measured FAA processing costs for those sessions, not a universal performance ceiling or an FPS improvement guarantee. Results vary with system, gameplay and mod setup.

[More mods and guides by Hijinks](https://hijinkssss.github.io/)
