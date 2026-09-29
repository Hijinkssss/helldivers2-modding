# Public repository audit

Audit date: 2026-09-28. Scope: all fetched reachable commits from main and the
feature branch, unique content blobs, tracked working files and the standalone
ZIP. Findings are based on targeted credential/path patterns and content review;
a pattern scan cannot prove the absence of every possible secret.

## Current branch and standalone package

- No candidate GitHub/OpenAI/AWS tokens, private keys or credential assignments
  were detected. No auth files, personal documents or raw private logs are tracked.
- Personal absolute paths in `provenance.json` and the Runtime audit receipt were
  replaced with basenames. Hashes, upstream commits and factual evidence remain.
- The obsolete machine-specific `prepare_release.py` staging script and generated
  `weapon_policy_v2_results.json` report were removed.
- Complete extracted AMR/loader Lua resources were removed from the current tree:
  `amr_reticle.lua`, `amr_reticle-readable.lua`, `7251fdd9bb62480a.lua` and
  `323c77238711d28f.lua`. Their original resource digests remain in `resources.json`.
- The standalone ZIP contains only this mod's source resource, empty companions,
  manager manifest and documentation. It includes no Core, Runtime, loader source,
  game binary, extracted AMR script, private log or local absolute path.
- Root/user documentation explains the accessibility/QoL mod, installation,
  supported weapons, build sensitivity, current candidate state and limitations.
  HD2ModCore remains separate and unchanged as a reusable framework.

## Publication blocker: reachable history

Earlier commits, including main, still expose personal machine paths and complete
extracted Lua resources from the downloaded AMR package. No applicable license or
redistribution permission was found for those extracted resources in this repository.
Their public availability elsewhere does not establish permission to republish them.
The origin and full source digests are recorded in `provenance.json`/`resources.json`.

The requested audit therefore **does not clear this repository for public
visibility**. Deleting the current files cannot remove them from Git history.
History was not rewritten, main was not modified, and visibility remains private.
This is a publication blocker, not a Shared Loader-only technical blocker.

Resolving it requires either authorized history cleanup, a separate clean public
repository, or verified redistribution clearance plus an explicit decision about
historical path exposure. None of those is silently substituted for the user's
no-history-rewrite instruction in this task.

## GitHub tools and later manual visibility step

The connected GitHub account reports repository admin/push access, but the
available GitHub connector has no repository visibility mutation tool. After the
publication blockers are resolved, the manual path is:

1. Open `https://github.com/Hijinkssss/helldivers2-modding/settings`.
2. Scroll to **Danger Zone** and select **Change repository visibility**.
3. Choose **Make public** and complete GitHub's repository-name confirmation.
4. Open the repository URL signed out to verify public access.

Do not take that visibility step while the above findings remain unresolved.
