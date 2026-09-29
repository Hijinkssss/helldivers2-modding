# Full Auto Assist 1.0 weapon expansion

Identity, mode vectors, family data and snapshot RPMs come from the pinned
HD2Runtime audit at `fd0c0d2b5618807a1ff63bedc9ed2f4b807c759`, built from the
F5FEE03DCFDB / Steam build 25480438 snapshot. See [expansion-evidence.md](expansion-evidence.md).
Snapshot RPM is metadata, not a measured accepted live shot rate. Eligibility
is a targeted static classification: the conventional targets have no
charge/hold or native Full Auto mode and accept ordinary Fire input; explicit
reload is a magazine/supply action and is never invoked by the mod. Live firing,
reload behavior, cadence, audio and animation still need the checklist in
[NEXT_TEST.md](NEXT_TEST.md).

| Requested weapon | Resource hash | Native mode vector | Native RPM | Balanced RPM | Result |
|---|---|---|---:|---:|---|
| R-2124 Constitution | `7b75e5132ffd4ca6` | 2/0/0 | 60 | 60 | Supported |
| R-6 Deadeye | `e6d932be83729076` | 2/0/0 | 100 | 100 | Supported |
| R-4 Hyena | `e5796355a8fd67e0` | 2/0/0 | 190 | 120 | Supported, profile outlier |
| R-72 Censor | `f0338468dcdb6a6c` | 2/0/0 | 400 | 380 | Supported |
| SG-8 Punisher | `41eac4a03987faa0` | 2/0/0 | 80 | 80 | Supported |
| SG-8S Slugger | `4f749e2ee26f532d` | 2/0/0 | 80 | 80 | Supported |
| SG-20 Halt | `4e310b1fe4c52b52` | 2/0/0 | 80 | 80 | Supported |
| SG-451 Cookout | `d323de60855898ac` | 2/0/0 | 80 | 80 | Supported |
| M90A Shotgun | `90ddc374f4e3d756` | 2/0/0 | 80 | 80 | Supported |
| SG-225IE Breaker Incendiary | `c12a34f375bd5a87` | 3/2/0 | 300 | 300 | Supported, native burst chaining |
| CB-9 Crossbow | `f49227a0630a3f7f` | 2/0/0 | 50 | 50 | Supported |
| R-36 Eruptor | `b6aff2195568767f` | 2/0/0 | 32 | 32 | Supported |
| SG-8P Punisher Plasma | `05d8d8c073b9d502` | 2/0/0 | 80 | 80 | Supported |
| R/40-K Hot Shot Marksman Rifle | `1abbff60d26ba391` | 2/0/0 | 210 | 210 | Supported |
| JAR-5 Dominator | `80f1a156d9fa1e36` | 2/3/0 | 250 | 250 | Supported, native burst chaining |
| P-4 Senator | `8d3d52a3b2f19402` | 2/0/0 | 200 | 200 | Supported |
| P-11 Stim Pistol | `d6b1fb05b9109353` | 2/0/0 | 70 | 70 | Supported |
| SG-22 Bushwhacker | `2b28e17ffed05f7c` | 2/4/0 | 650 | 90 | Supported, profile outlier |
| P-35 Re-Educator | `0b882808c6f498e8` | 2/0/0 | 110 | 110 | Supported |
| P/40-K Bolt Pistol | `dbb6c961c59fadc1` | 2/0/0 | 150 | 150 | Supported |
| P-92 Warrant | `cf8934ff6567a42d` | 3/0/0 | 450* | 380 | Supported, live-tested Guided and Unguided |

ARC-12 Blitzer (`076dd5d4f4360204`) is excluded because its native mode vector
is `1/0/0` (Full Auto). GL-15 Evictor, Double Freedom and SG-97 Sweeper remain
unmapped and fail closed.

*Warrant's 450 RPM is authored `fire_rate` metadata, not a measured accepted
native cap. The previous deferral required decoding mode and guidance internals
that FAA does not use. Support follows the demonstrated external-input
contract: FAA repeats ordinary Fire, while the game decides whether a shot is
legal. The mod author live-tested Guided and Unguided modes. See
[WARRANT_SUPPORT_RESEARCH.md](WARRANT_SUPPORT_RESEARCH.md) for scope and result.
