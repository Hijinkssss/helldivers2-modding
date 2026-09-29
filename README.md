# Helldivers 2 modding

**[Full Auto Assist V4](HD2FullAutoAssist/README.md)** is the user-facing project:
an accessibility/QoL mod that repeats normal Fire while held for an explicit set
of reviewed weapons. Its standalone RC3 requires only
[Bingus Shared Loader v18 / API 1](https://github.com/CowboyBingus/BingusSharedLoader/releases).
End users do not need HD2ModCore or HD2Runtime.

## Current status

- RC3 runtime behavior passed live testing; V4 / RC4 adds Arsenal branding and per-weapon profile options for Steam build 25480438.
- Exact EXE/game.dll fingerprints required; unknown builds and weapons fail closed.
- Talon Balanced at 210 RPM and compatibility with the user's personal modpack passed live testing in RC3. The V4 package UI and selected profile behavior still need focused verification.
- Talon Balanced is estimated at 210 RPM for about eight shots to overheat; Efficiency is 60, Full Auto is 380 and FULLER AUTO is 750 RPM. AMR remains 120 RPM.
- Default-on startup and `=` toggle, with optional Mod Bindings Menu registration. Arsenal has selectable profiles for Peacemaker, SOCOM, Veto, Talon and AMR.
- Future patch support is not included.

Read the [install instructions and supported weapons](HD2FullAutoAssist/README.md),
[RC3 candidate matrix](HD2FullAutoAssist/docs/weapon-candidate-matrix.md), [prior RC2 notes](HD2FullAutoAssist/docs/RC2_NOTES.md) and
[remaining live steps](HD2FullAutoAssist/docs/NEXT_TEST.md) before using the candidate.
The V4 RC4 Arsenal ZIP is built with `HD2FullAutoAssist/scripts/build.py`.

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
