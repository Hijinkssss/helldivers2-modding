# Full Auto Assist RC2 handoff

Development branch: `feature/full-auto-assist-weapon-policy`.
Starting validated candidate: `a93008f5c0a69bf5bcf4be8bddb468dc5607bcf3`.

The mod is now a standalone Shared Loader-only current-build RC2 candidate.
Core and Runtime remain separate projects. No merge, installation, deployment,
game launch or new gameplay validation occurred in this task.

Talon Balanced is 60 RPM; Native Cap remains 750. AMR Balanced stays 120 with
native 400. Amendment continuously chains bursts, as the reference did.
User-reported reference gameplay results and their evidence boundaries are in
`HD2FullAutoAssist/docs/RC2_NOTES.md`. Offline differential replay and guard tests
pass; standalone gameplay and Talon's new cadence still need the focused session
in `HD2FullAutoAssist/docs/NEXT_TEST.md`.

The public audit covers fetched reachable Git history. Current files have been
cleaned, but historical machine paths and complete extracted third-party Lua
resources remain reachable. Redistribution rights for those resources are not
established. Under the no-history-rewrite restriction, this repository's public
visibility gate cannot pass. Keep it private; see `validation/PUBLIC_AUDIT.md`.
