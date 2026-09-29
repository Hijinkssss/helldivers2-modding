# Historical reference validation and RC6 scope

Reference commit: `a93008f5c0a69bf5bcf4be8bddb468dc5607bcf3`.
Supported Steam build: `25480438`. EXE and game.dll SHA-256 fingerprints are
unchanged, as are native input anchors and mapping checks.

The user reports successful Balanced gameplay on Peacemaker, Verdict, SOCOM,
Veto, Diligence, Diligence CS and AMR, plus unaffected Liberator, Quasar and Laser
Cannon. Amendment works and continuously chains bursts. Talon at 380 heats too
quickly. These are user-reported reference results; no new logs or measured
accepted-shot traces were supplied for that pass.

RC3 preserves those intervals except Talon, which now exposes four profiles.
Balanced is 210 RPM by a discrete heat/cooling estimate; Efficiency is 60,
Full Auto is 380 and FULLER AUTO is 750. AMR stays 120.
The standalone version replaces Core/Runtime plumbing, so reference gameplay
evidence does not establish gameplay success for the rebuilt package.

## Offline checks

`tests/run_standalone.py` reads the reference from Git into a temporary directory
and checks its original controller tests, then replays the standalone controller:

- Nine assisted resources, both rate modes, zero and positive cadence overrides.
- Identical names/categories/eligibility and rates except Talon's deliberate change.
- Unknown, native-auto, charge/hold and ambiguous resources remain vanilla.
- Held swaps, same-name new entities, player/identity failure, release, `=`, chat,
  menus, focus, startup settings and unload.
- Native layout validation before writes; readback, axis exclusion, binding edit
  preservation, exact restoration and partial-write rollback.
- Actual standalone lifecycle integration with the native observer and UI reader,
  VK_OEM_PLUS parsing, optional native binding registration, exclusive input
  selection after registration, and local fallback behavior.
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
96-read budget. No original capture is manufactured or required to install this standalone consumer.

The native binding API exposes registration and key-state reading, but does not
accept a custom first-use key. That means the API cannot guarantee `=` as the
initial native binding; the local fallback uses `=` when registration is absent.
Follow [NEXT_TEST.md](NEXT_TEST.md) once before a standalone gameplay-release claim.
Future patch resilience, automatic discovery and R-menu introspection are deferred.

## RC6 expansion status

RC6 adds the 20 weapons in [weapon-candidate-matrix.md](weapon-candidate-matrix.md), using pinned Runtime audit metadata at fd0c0d2b5618807a1ff63bedc9ed2f4b807c759. Added identities and policy caps are tested offline. The checks do not establish live accepted cadence or weapon-specific reload behavior. RC6 remains a pre-release candidate pending [NEXT_TEST.md](NEXT_TEST.md).

## RC7 startup reconciliation

RC6 initialized the controller's `wait_release` gate as true and set it again
whenever mission gameplay or player/weapon identity was temporarily unavailable.
If Fire was already held during mission/player initialization, that gate remained
latched after the context became valid, so an otherwise ON controller ignored
the first held Fire input until it observed a release. Startup now begins with
no outstanding lease/release obligation. Transient mission or unresolved-player
guards preserve a release requirement only when an existing lease or earlier
release requirement must be cleared; a positively observed ineligible weapon
still requires release before another attempt. User preference remains separate
from those guards. The new live-order regression keeps Fire held from before
mission/player readiness through the first eligible weapon and verifies
assistance without a toggle. RC7 remains pending live confirmation.
