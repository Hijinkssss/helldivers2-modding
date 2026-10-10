# FAA 1.3.0 supported weapons

The production registry contains 31 supported weapon identities. Every identity below has exactly one selector. Ordinary weapons default ON; special-case weapons default Balanced (Eruptor: 28 RPM). This list follows the in-game menu groups.

## Primary (18)

- R-63 Diligence
- R-63CS Diligence Counter Sniper
- R-2 Amendment
- R-2124 Constitution
- R-6 Deadeye
- R-4 Hyena
- R-72 Censor
- SG-8 Punisher
- SG-8S Slugger
- SG-20 Halt
- SG-451 Cookout
- M90A Shotgun
- SG-225IE Breaker Incendiary
- CB-9 Exploding Crossbow
- R-36 Eruptor
- SG-8P Punisher Plasma
- R/40-K Hot-Shot Marksman Rifle
- JAR-5 Dominator

## Secondary (11)

- P-2 Peacemaker
- M6C/SOCOM Pistol
- P-69 Veto
- P-113 Verdict
- P-4 Senator
- P-11 Stim Pistol
- SG-22 Bushwhacker
- P-35 Re-Educator
- P/40-K Bolt Pistol
- LAS-58 Talon
- P-92 Warrant

## Stratagem/Support (2)

- MLS-4X Commando
- APW-1 Anti-Materiel Rifle

## Existing special-case selectors

OFF is the first choice in every selector below. Balanced is the fresh-install default. RPM describes repeated Fire input, not guaranteed accepted shots.

| Weapon | Existing enabled choices and input cadence |
| --- | --- |
| R-4 Hyena | BALANCED 120 RPM; FULL AUTO 190 RPM |
| R-36 Eruptor | 28 RPM Balanced/default; 27 RPM Slower Cadence; 32 RPM Maximum/native-speed cadence |
| P-2 Peacemaker | BALANCED 380 RPM; FULL AUTO 900 RPM |
| M6C/SOCOM Pistol | BALANCED 380 RPM; FULL AUTO 900 RPM |
| P-69 Veto | BALANCED 380 RPM; FULL AUTO 750 RPM |
| LAS-58 Talon | BALANCED 210 RPM; EFFICIENCY 60 RPM; FULL AUTO 380 RPM; FULLER AUTO 750 RPM |
| SG-22 Bushwhacker | BALANCED 90 RPM; FULL AUTO 650 RPM |
| APW-1 Anti-Materiel Rifle | BALANCED 120 RPM; FULL AUTO 400 RPM |
| MLS-4X Commando | BALANCED 120 RPM; FULL AUTO 240 RPM |

Talon Efficiency spaces inputs for cooling; faster modes build heat faster. The remaining 22 supported weapons use OFF/ON only and preserve their existing normal FAA cadence.

## Unsupported weapons

Unknown weapons, native Full Auto weapons and deferred charge/special-weapon experiments are not added to FAA support by this release.
