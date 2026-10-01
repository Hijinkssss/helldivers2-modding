# v1.1.0 supported weapons

31 explicit identities: the 30-weapon v1.0.1 roster plus Commando. Eruptor default is now 28 RPM; its selectable cadences are 27 / 28 / 32 RPM. Rates below are default input-attempt rates, not guaranteed shot rates. Existing validation records cover the base policy; not every weapon has a separately measured shot-rate test.

| Weapon | Default RPM | Resource hash |
|---|---:|---|
| P-2 Peacemaker | 380 | `05e4e5c2db6e44a2` |
| M6C/SOCOM Pistol | 380 | `4d58c77087b774c5` |
| P-69 Veto | 380 | `c780bcd79547da0f` |
| P-113 Verdict | 380 | `1a437158e1b8d2a1` |
| R-63 Diligence | 350 | `03e67a19b07c6523` |
| R-63CS Diligence Counter Sniper | 350 | `4c786785c79d44e7` |
| R-2 Amendment | 380 | `0f83639ab8c86165` |
| LAS-58 Talon | 210 | `416d053372c4e433` |
| APW-1 Anti-Materiel Rifle | 120 | `89c5493e08ca4207` |
| R-2124 Constitution | 60 | `7b75e5132ffd4ca6` |
| R-6 Deadeye | 100 | `e6d932be83729076` |
| R-4 Hyena | 120 | `e5796355a8fd67e0` |
| R-72 Censor | 380 | `f0338468dcdb6a6c` |
| SG-8 Punisher | 80 | `41eac4a03987faa0` |
| SG-8S Slugger | 80 | `4f749e2ee26f532d` |
| SG-20 Halt | 80 | `4e310b1fe4c52b52` |
| SG-451 Cookout | 80 | `d323de60855898ac` |
| M90A Shotgun | 80 | `90ddc374f4e3d756` |
| SG-225IE Breaker Incendiary | 300 | `c12a34f375bd5a87` |
| CB-9 Exploding Crossbow | 50 | `f49227a0630a3f7f` |
| R-36 Eruptor | 28 | `b6aff2195568767f` |
| SG-8P Punisher Plasma | 80 | `05d8d8c073b9d502` |
| R/40-K Hot-Shot Marksman Rifle | 210 | `1abbff60d26ba391` |
| JAR-5 Dominator | 250 | `80f1a156d9fa1e36` |
| P-4 Senator | 200 | `8d3d52a3b2f19402` |
| P-11 Stim Pistol | 70 | `d6b1fb05b9109353` |
| SG-22 Bushwhacker | 90 | `2b28e17ffed05f7c` |
| P-35 Re-Educator | 110 | `0b882808c6f498e8` |
| P/40-K Bolt Pistol | 150 | `dbb6c961c59fadc1` |
| P-92 Warrant | 380 | `cf8934ff6567a42d` |
| MLS-4X Commando | 120 | `5990123d142b16cb` |

Commando repeats ordinary Fire with Balanced at 120 RPM (500 ms) by default or Full Auto at the retained native 240 RPM ceiling (250 ms); guided/dumb-fire behavior, four-round expendable capacity and shot acceptance remain game-controlled. Exact identity, owned native cadence and offline input safety are checked; accepted live shot cadence and guidance continuity remain pending RC2 validation.

Meltagun, Arc Thrower, Purifier, Loyalist and Accelerator are audited Special candidates and currently unassisted. See REMAINING_WEAPON_AUDIT.md for specific evidence and blockers. Native Full Auto and unknown/unlisted weapons stay under normal game control.

## Assistance roles and evidence limits

**Cadence Control:** R-36 Eruptor. A fresh verified no-mod vanilla launch showed native hold-to-repeat through the bolt cycle near 32 RPM. FAA paces that existing behavior: 27 slower, 28 default/balanced, 32 maximum/native-speed. OFF releases control and vanilla repetition continues. The user observed more controlled follow-up shots at 28 RPM. This is observed input behavior, not official design intent or a weapon-stat modification.

**Special:** APW-1 Anti-Materiel Rifle retains its existing validated SPECIAL policy, 120/400 RPM profiles and normal Fire lease. The five charge candidates are also Special, but are not enabled; their audit is separate below.

**Repeat Assist policy:** the other 29 supported entries, including Commando, retain existing repeated ordinary Fire handling and profiles. This names FAA's current policy role; it does not claim a fresh vanilla held-trigger audit for all 29. Metadata/native mode vectors establish identity and configured modes, not whether holding Fire naturally repeats. If live vanilla behavior demonstrates native repetition, reclassify the role from evidence without silently changing eligibility or rates.

**Unsupported:** native-auto exclusions, unknown identities and the five gated charge candidates receive no FAA input ownership. Gated Special candidates may add value once their release/completion gates are established; they are not classified as having no value.
