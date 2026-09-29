# Targeted expansion evidence

Identity, unique ownership, native mode vectors, projectile families and native
fire-rate metadata were taken from the pinned HD2Runtime audit commit
`fd0c0d2b5618807a1ff63bedc9ed2f4b807c759` and its F5FEE03DCFDB snapshot. The
primary evidence files are `schemas/player_weapon_authoring_catalog.json`,
`schemas/player_weapon_composition_catalog.json`,
`research/final-five-player-weapons-F5FEE03DCFDB.json`, and
`research/weapon-family-expansion-F5FEE03DCFDB.json` in that audit checkout.
This add-on records the resolved policy rows in
[weapon-candidate-matrix.md](weapon-candidate-matrix.md).

For the 19 supported targets, the snapshot shows conventional projectile
operation and a non-Full-Auto primary mode. Native Fire remains the only input
the assist repeats. It does not invoke Reload or alter any weapon state. The
Pump/rounds-feed family is treated as internal game behavior between shots; the
mod neither simulates cycling nor advances a reload. This is a static
eligibility finding, not proof of successful live shot acceptance. The
explosive-impact Bolt Pistol and status-bearing Re-Educator also use ordinary
semi-auto Fire; projectile effects are untouched.

Breaker Incendiary has native modes `[3,2,0]` (Burst/Semi); Dominator has
`[2,3,0]` (Semi/Burst). Each uses the established Amendment policy: repeat
ordinary Fire at the weapon's snapshot RPM and let the game control burst
internals. Bushwhacker mode metadata `[2,4,0]` is not changed by the mod; the
game handles whichever legal mode the player selected. Blitzer's `[1,0,0]`
mode is native Full Auto and remains unsupported.

The selected release candidate is still pre-release. The live checklist must
confirm accepted shots, manual-cycle behavior, reload independence, release
stopping, mode-specific burst chaining, state persistence, and personal-modpack
compatibility before a public v1.0.0 claim.
