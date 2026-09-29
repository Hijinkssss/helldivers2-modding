# Helldivers 2 modding

**[HD2 Full Auto Assist](HD2FullAutoAssist/README.md)** is the user-facing project:
an accessibility/QoL mod that repeats normal Fire while held for an explicit set
of reviewed weapons. Its standalone RC3 requires only
[Bingus Shared Loader v18 / API 1](https://github.com/CowboyBingus/BingusSharedLoader/releases).
End users do not need HD2ModCore or HD2Runtime.

## Current status

- Full Auto Assist v0.1.3 standalone current-patch RC3 candidate, Steam build 25480438.
- Exact EXE/game.dll fingerprints required; unknown builds and weapons fail closed.
- Reference Balanced gameplay passed user-reported live validation. The standalone
  refactor passes offline parity and still needs one focused live follow-up.
- Talon Balanced is estimated at 210 RPM for about eight shots to overheat; Efficiency is 60, Full Auto is 380 and FULLER AUTO is 750 RPM. AMR remains 120 RPM.
- Default `=` toggle, with optional Mod Bindings Menu registration. Balanced/Native Cap and Talon profile INI settings. Amendment continuously chains bursts.
- Future patch support and per-weapon UI are planned, not implemented.

Read the [install instructions and supported weapons](HD2FullAutoAssist/README.md),
[RC3 candidate matrix](HD2FullAutoAssist/docs/weapon-candidate-matrix.md), [prior RC2 notes](HD2FullAutoAssist/docs/RC2_NOTES.md) and
[remaining live steps](HD2FullAutoAssist/docs/NEXT_TEST.md) before using the candidate.
The standalone Arsenal ZIP is built with `HD2FullAutoAssist/scripts/build.py`.

## Repository contents

| Directory | Purpose |
|---|---|
| `HD2FullAutoAssist/` | Standalone mod source, packaging, user documentation and offline parity tests |
| `HD2ModCore/` | Separate reusable personal framework/developer preview; Full Auto Assist has no runtime dependency on it |
| `integrations/HD2ModCore-runtime-candidate/` | Separate experimental Core/Runtime bridge; retained for development and reference tests |
| `validation/` | Historical research provenance and technical evidence; not installable mods |

Development remains on `feature/full-auto-assist-weapon-policy`; no merge to main
is part of this work. Open that branch to view RC3 if main still shows the earlier
preservation snapshot. Research layouts and historical offsets are tied to their
documented builds and are not claims of compatibility with later patches.
