# Full Auto Assist research RC3: Accelerator and Meltagun

This separate Arsenal package records manual stock firing of exactly two weapons:

| Matched catalog name | Internal resource hash |
| --- | --- |
| PLAS-39 Accelerator Rifle | `30061f91af477f5e` |
| 40-K Meltagun | `6cfcc7f8801a0266` |

Both names resolve uniquely in the pinned exact-build Runtime authoring catalogs
at commit `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`. Their catalog fingerprints
match FAA's supported Steam build 25480438. Accelerator uniquely owns charge
component record 2; Meltagun owns charge record 7 and beam record 21. This proves
research identity, not live readiness or permission to automate.
See RC3_IDENTITY_EVIDENCE.json for the verification receipt.

Arc Thrower, Purifier, Loyalist, ordinary weapons, and unknown resources are
excluded before any charge/trigger/beam/ammo probe reads. They consume no samples
from the 6,000-sample budget. Accelerator receives charge/trigger/ammo samples;
only Meltagun additionally receives beam samples. All reads retain the existing
exact-build, entity, generation, bounds, and snapshot validation.

The output remains JSON Lines in
`%LOCALAPPDATA%\CowboyBingus\Helldivers2\Logs\HD2FullAutoAssist-charge-probe.log`.
The immediately flushed `research_start` identifies RC3 and both target hashes.
`charge_probe_target_seen` in the normal FAA log and probe file identifies each
target actually reached by the recorder. The footer reports per-weapon sample
counts, stop reason, and whether the cap was hit. Missing settings-map results
now explicitly report `settings_state=not_found`; no threshold is guessed.

Requires the separately installed Bingus Shared Loader v18 / API 1. The package
has no HD2ModCore or HD2Runtime dependency. Existing ordinary FAA, Eruptor profiles,
HUD, input mapping, and charge-cycle behavior are preserved from commit 08eec95.
The normal initialized-version string changes to RC3 only. All five charge
weapons remain denied automation. This package adds no input edge adapter,
weapon-state writes, reloads, switches, heap scan, or native game-function call.

Close the game before selecting RC3, disable other FAA packages, and keep
ArcThrowerRevamped/Megapack Arc changes and other weapon-stat changes disabled
for stock observations. Purge / Deploy normally with the Shared Loader available.
Follow LIVE_TEST.md. Preserve the resulting file before another launch overwrites
it. The older CHARGE_REASSESSMENT.md included in the archive is historical RC2
native background; its three-weapon testing plan is superseded by LIVE_TEST.md.

Only offline validation is claimed for RC3. No installation, deployment, game
launch, live-process access, merge, publication, or Nexus update was performed.
