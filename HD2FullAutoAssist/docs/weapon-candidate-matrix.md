# Weapon policy and release coverage

Reviewed sources: `known-weapon-evidence.json`, `weapon-policy-evidence.json`,
`identity-validation.json`, and the pinned build-25480438 Runtime snapshot.
Unknown or ambiguous hashes remain fail-closed.

| Weapon | Hash | Decision | Native cap | Balanced | Basis |
|---|---|---|---:|---:|---|
| P-2 Peacemaker | `05e4e5c2db6e44a2` | ASSIST | 900 | 380 | Existing validated roster |
| P-113 Verdict | `1a437158e1b8d2a1` | ASSIST | 450 | 380 | Semi-only Runtime snapshot; existing validated roster |
| M6C/SOCOM Pistol | `4d58c77087b774c5` | ASSIST | 900 | 380 | Existing validated roster |
| P-69 Veto | `c780bcd79547da0f` | ASSIST | 750 | 380 | Existing validated roster |
| R-63 Diligence | `03e67a19b07c6523` | ASSIST | 350 | 350 | Semi-only Runtime snapshot; existing validated roster |
| R-63CS Diligence Counter Sniper | `4c786785c79d44e7` | ASSIST | 350 | 350 | Semi-only Runtime snapshot; existing validated roster |
| R-2 Amendment | `0f83639ab8c86165` | ASSIST | 480 | 380 | Semi/burst; existing validated chaining behavior |
| LAS-58 Talon | `416d053372c4e433` | ASSIST | 750 | 210 | Semi-only; task-specific profiles |
| APW-1 Anti-Materiel Rifle | `89c5493e08ca4207` | SPECIAL | 400 | 120 | Existing validated special rate |
| AR-23 Liberator | `968211c0033dce64` | IGNORE_NATIVE_AUTO | — | — | Native Full Auto |
| LAS-99 Quasar Cannon | `35a61296619cc47e` | EXCLUDE_CHARGE_HOLD | — | — | Charge/hold operation |
| LAS-98 Laser Cannon | ambiguous | REVIEW (fail closed) | — | — | Continuous beam; multiple resource hashes; none is allowed |

No new weapon was added. The checked-in evidence gives exact identities and
semi/burst metadata for the current roster and three Runtime candidates, all of
which were already represented. It does not prove repeated-Fire-only behavior,
reload independence, native Full Auto absence and current native cadence for
additional marksman rifles, shotguns or sidearms. Promoting candidates without
those facts would violate the fail-closed policy. Those categories remain
deferred for targeted evidence, without another broad scan.

## Requested 1.0 additions: deferred pending exact-build evidence

The repository contains no exact-build candidate records for the following
requested weapons. For each, the resource identity/hash, native fire modes,
accepted fire-rate cap, normal-Fire continuation, reload requirement,
charge/hold behavior, and evidence confidence are therefore **unknown**. No
Balanced RPM can be calculated from the checked-in evidence. All remain
unmapped and fail closed; this is a deliberate deferral, not support.

| Requested weapon | Result | Missing evidence |
|---|---|---|
| R-2124 Constitution | DEFERRED | Exact-build identity and all eligibility fields |
| R-6 Deadeye | DEFERRED | Exact-build identity and all eligibility fields |
| R-4 Hyena | DEFERRED | Exact-build identity and all eligibility fields |
| R-72 Censor | DEFERRED | Exact-build identity and all eligibility fields |
| SG-8 Punisher | DEFERRED | Exact-build identity and all eligibility fields |
| SG-8S Slugger | DEFERRED | Exact-build identity and all eligibility fields |
| SG-20 Halt | DEFERRED | Exact-build identity and all eligibility fields |
| SG-451 Cookout | DEFERRED | Exact-build identity and all eligibility fields |
| M90A Shotgun | DEFERRED | Exact-build identity and all eligibility fields |
| SG-225IE Breaker Incendiary | DEFERRED | Exact-build identity and all eligibility fields |
| GL-15 Evictor | DEFERRED | Exact-build identity and all eligibility fields |
| CB-9 Crossbow | DEFERRED | Exact-build identity and all eligibility fields |
| R-36 Eruptor | DEFERRED | Exact-build identity and all eligibility fields |
| SG-8P Punisher Plasma | DEFERRED | Exact-build identity and all eligibility fields |
| ARC-12 Blitzer | DEFERRED | Exact-build identity and all eligibility fields |
| R/40-K Hot Shot Marksman Rifle | DEFERRED | Exact-build identity and all eligibility fields |
| JAR-5 Dominator | DEFERRED | Exact-build identity and all eligibility fields |
| P-4 Senator | DEFERRED | Exact-build identity and all eligibility fields |
| P-11 Stim Pistol | DEFERRED | Exact-build identity and all eligibility fields |
| SG-22 Bushwhacker | DEFERRED | Exact-build identity and all eligibility fields |
| P-35 Re-Educator | DEFERRED | Exact-build identity and all eligibility fields |
| P/40-K Bolt Pistol | DEFERRED | Exact-build identity and all eligibility fields |

Double Freedom remains an explicit design exclusion. SG-97 Sweeper remains
excluded by the native-Full-Auto rule. Neither weapon has an allowlisted policy
identity, so both continue to fail closed.
