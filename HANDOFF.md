# Helldivers 2 Modding - Preservation Snapshot

## Current-patch v0.1 preparation, 2026-09-28

- Branch: `feature/full-auto-assist-weapon-policy`; pre-change HEAD `fde16e9a2137364ced2a8d3431c86f5e242aaa0e`.
- Current Assist package: `HD2FullAutoAssist-v0.1.2-Current-Patch-Validation-Arsenal.zip`.
- Verdict is ASSIST at native/Balanced 450/380; Diligence and Diligence CS are ASSIST at 350/350. Source: reviewed Runtime 0.24.0 current-build snapshot, semi-only native vectors and conventional projectile identity. Caps are RUNTIME_SNAPSHOT; live continuation/cadence remain pending.
- Existing values retained: Peacemaker/SOCOM 900/380, Veto/Talon 750/380, Amendment 480/380, AMR SPECIAL 400/120 (Balanced provisional). No other weapons added.
- AMR SPECIAL activation now reaches the existing controller. `repeat_ms=0` uses the selected policy; positive values only slow it. Native mapping interval bound now permits the existing 900-RPM cap without changing its mechanism or build guards.
- Standalone v2 tests and all 16 full offline check groups passed. Original capture hashes and the unchanged observer's LF source hash were verified. The real reviewed Runtime metadata and package/discovery/parity were checked offline.
- Exact dependencies: Loader v18/API 1, Core 0.3.2-runtime-candidate/API 1, Runtime exactly 0.24.0/API 1. Installed build 25480438 fingerprints matched the evidence.
- Read `HD2FullAutoAssist/docs/NEXT_TEST.md` for one controlled session, and `docs/weapon-policy-evidence.json` for each promotion's provenance and missing live evidence.
- No import, deployment, launch, live process inspection, merge or release was performed. Backend future-proofing and architecture redesign remain deferred.

## Earlier observed selective baseline

- this is a preservation snapshot
- Full Auto Assist selective weapon behavior is live-tested and working
- Peacemaker assist works
- AMR remains vanilla
- Amendment remains vanilla
- switching between them works seamlessly
- normal audio/animation were confirmed
- further work is primarily supported-weapon classification and fire-rate tuning
- do not redesign or replace the working selective implementation without evidence
