# RC2 validation boundaries

Reference commit: `a93008f5c0a69bf5bcf4be8bddb468dc5607bcf3`.
Supported Steam build: `25480438`. EXE and game.dll SHA-256 fingerprints are
unchanged, as are native input anchors and mapping checks.

The user reports successful Balanced gameplay on Peacemaker, Verdict, SOCOM,
Veto, Diligence, Diligence CS and AMR, plus unaffected Liberator, Quasar and Laser
Cannon. Amendment works and continuously chains bursts. Talon at 380 heats too
quickly. These are user-reported reference results; no new logs or measured
accepted-shot traces were supplied for that pass.

RC2 preserves those intervals except Talon Balanced at 60. AMR stays 120.
The standalone version replaces Core/Runtime plumbing, so reference gameplay
evidence does not establish gameplay success for the rebuilt package.

## Offline checks

`tests/run_standalone.py` reads the reference from Git into a temporary directory
and checks its original controller tests, then replays the standalone controller:

- Nine assisted resources, both rate modes, zero and positive cadence overrides.
- Identical names/categories/eligibility and rates except Talon's deliberate change.
- Unknown, native-auto, charge/hold and ambiguous resources remain vanilla.
- Held swaps, same-name new entities, player/identity failure, release, F8, chat,
  menus, focus, startup settings and unload.
- Native layout validation before writes; readback, axis exclusion, binding edit
  preservation, exact restoration and partial-write rollback.
- Actual standalone lifecycle integration with the native observer and UI reader.
- Exact fingerprint mismatch, guarded pages, invalid PE/symbol/read/config paths,
  original callback arguments/return values and update error cleanup.
- Original observer and UI fixtures, including malformed maps and changing snapshots.
- Syntax of every bundled Lua module and no Core/Runtime import or generic writer.

`tests/test_package.py` checks bundle execution without Core/Runtime, actual Loader
v18 discovery when its source is supplied, source/archive/ZIP parity, empty
companions, one manager option, and deterministic rebuild output.

Synthetic fixtures verify controller and guard behavior. They are not live shot,
audio, heat or performance evidence. The optional trace still counts input attempts,
not successful shots. Source/package digests and test receipts are generated locally
in `build/`; the public tree does not include personal logs or raw game captures.

## Historical evidence

`identity-validation.json` and `IDENTITY_RESULTS.md` preserve original observed
idle identity transitions and source hashes. Their Core/Runtime references describe
that historical capture. `weapon-policy-evidence.json` preserves three reviewed
snapshot caps. These records have not been relabeled as standalone observations.
The extracted observer retains its original ownership/back-reference checks and
96-read budget. No original capture is manufactured or required to install RC2.

Follow [NEXT_TEST.md](NEXT_TEST.md) once before a standalone gameplay-release claim.
Future patch resilience, automatic discovery and R-menu introspection are deferred.
