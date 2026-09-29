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
