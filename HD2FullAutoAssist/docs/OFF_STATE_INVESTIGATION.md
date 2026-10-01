# Private RC3 OFF-state investigation

Status: the persistent live Eruptor OFF bug is still release blocking. This is a private diagnostic candidate with a proven restoration-ownership fix and HUD fixes. It is not a claim that the fresh-hold Eruptor symptom has been fixed.

## Source correspondence

The authoritative existing checkout is `continue-development-of-full-auto-assist/work/faa-rc2`, branch `release/full-auto-assist-1.1.0-rc2`, clean HEAD `735c1025f1b2c3d5f5cbb4dc6d4f4b7b875ce5e9`. Its generated `build/1.1.0-rc2/hd2_full_auto_assist.lua` and RC2 ZIP core exactly equal the bundle produced from that checkout. RC2 ZIP SHA-256: `ae1860ff1b32b0e45661d4b4075bf47a36cb8733e060b703d041cb9451311d1a`; core SHA-256: `b768b0e7b5eb7e5b2379b626dc9b7f09127513d07cb42a5d0907454d712084bc`.

The live log identifies RC2 and its 28 RPM Eruptor and Commando selections. The previously installed archive is no longer present at the recorded data path, so its exact test-session bytes cannot be independently hashed now. A version marker alone does not establish those bytes. There is no differing generated source in the verified RC2 candidate.

Development continues directly from that RC2 commit in the isolated `faa-off-investigation` checkout. The original RC2 checkout and completed RC1-based HUD commit `b189c67080650664d6c5f5a6bbbeff5694841c30` remain preserved. No main restart, merge, push, deployment, Nexus edit or public release/tag change occurred.

## Actual Eruptor path

`native_fire.sample()` reads native Fire magnitude, pulse, trigger type, held duration and active mapping index. `full_auto_assist.tick()` checks the authoritative enable/release/gameplay/UI gates, then resolves the current guarded avatar/weapon identity. `assist_state.resolve()` classifies resource `b6aff2195568767f` through `weapon_policy`. `config` migrates old selections; the actual RC2 profile table selects `slower_27=27`, `balanced_28=28`, or `max_32=32`. There is no Eruptor-specific Lua timer or second generic injection path.

The controller calculates `seconds=max(repeat_ms/1000,60/rpm)`. `native_fire.begin()` captures each original 20-byte button mapping before mutation and changes it to native trigger 8. Its parameter is `seconds/ceil(seconds)` because the native parameter also gates normalized magnitude. For 28 RPM this is approximately 0.714286 seconds. The stock weapon decides which attempts become shots. Accepting every third retry would yield about 28 RPM; that arithmetic is consistent with the user's observed ON cadence, not an independent shot measurement. This patch does not change the conversion, profiles, or accepted weapon cooldown.

The live log reports original mappings `4:2,4:2,4:2`. In the preserved, SHA-verified build-25480438 image, evaluator `0x12fc180` jump-table entry 2 points to `0x12fc2b9`, a level-input comparison. Entry 8 points to `0x12fc403`, the timed/modulo path. Restoring type 2 removes timed gating and can expose held-level Fire. That explains a possible source of maximum-rate requests, but does not establish why the native Eruptor accepts them after FAA involvement. The user's fresh OFF hold still repeats, whereas a fresh launch with FAA never initialized does not. FAA therefore causes or enables a persistent difference. It is not merely one queued pulse surviving a toggle.

The old live log records 27 leases, 81 restored mapping rows, 162 mapping writes, zero conflicts/errors, and no active lease on shutdown. Offline replay of the real three-mapping/type-2 path also restores originals and makes zero mapping writes while OFF, including fresh holds and re-equips. Those checks do not emulate the native weapon controller. They cannot prove the live symptom solved, nor rule out derived native state, a different loaded source, or a restoration failure omitted by the available evidence. No unsafe input-state reset or weapon-state write has been guessed.

## Proven restoration defect and fix

Old `native_fire.restore()` discarded `self.lease` after `BindingContextChanged` without writing or verifying the originals. An in-place header edit reproduces outstanding trigger-8 rows and lost original snapshots. The controller accepted the false return as a warning and continued clearing higher-level state. This hypothesis is correct as a code defect, but zero conflicts in the supplied log prevent attributing that session to it.

Now originals remain owned until every row is positively verified original. Unknown/moved contexts are never followed for writes. External edits are preserved, with originals retained and the controller failed closed; restored rows are verified on retry. A false return cannot complete a toggle or enable transition. The enable gate closes before rollback, OFF also guards against an outstanding lease, and only successful rollback clears cadence metadata, repeat state and identity lease fields. Recovery retains the Fire callback while restoration is pending; repeated identical failure diagnostics are suppressed. The controller cannot acquire a new lease or re-enable during that failure.

Limitation: retaining ownership does not itself neutralize repeat semantics in an inaccessible or externally edited native mapping. The candidate reports pending restoration rather than pretending vanilla is restored. If context cannot safely recover, restart the game. It never writes through an unverifiable/freed context or overrides another editor's changed bytes.

## SPECIAL

Current RC2 already derives effective state for both ASSIST and SPECIAL. AMR is SPECIAL and already reaches native assistance. No eligibility or AMR policy change was needed. New tests confirm AMR ON/OFF and unsupported exclusion. AMR remains in the normal live regression checklist, not a newly enabled feature.

## HUD and performance

Supported OFF stays visible in opaque white; supported ON keeps exactly the existing yellow and three-cartridge size/geometry. Unsupported stays hidden. The live-proven RC2 UI-world selection remains. Native extent anchoring is documented in HUD_ANCHORING.md. Missing/invalid native geometry safely clears drawing, without a fixed-position fallback.

The approximately 14 ms spike was not reproduced or attributed. The supplied session had debug/validation/profiling off, so its old JSONL validation trace is not evidence for that session. RC2 HUD diagnostics were on by default and synchronously called host logging (`file:write` plus `file:flush`) after stock update on relevant transitions/periodic reports. Ordinary toggle and initial input-ready logging also perform synchronous I/O. Optional validation JSONL flushing runs inside the before-stock Fire callback once per second. These are actual synchronous paths, not proof of which caused the observed spike.

HUD diagnostics are now opt-in/default OFF. Existing debug, profiling and validation remain OFF in the ordinary INI. Trigger-2 validation records retain rising edges instead of logging an identical level every frame; trigger-8 pulses remain recorded. Diagnostic mapping snapshots are read-only and capped at 96 per load. Profiling adds a separate `hud_present` phase; existing initialization, identity, binding, callback and log-I/O phases and trace-flush timings remain. The diagnostic INI intentionally enables trace/profiling and is unsuitable for production performance comparison. Visible native HUD sampling adds guarded reads every update; its actual cost remains an in-game measurement requirement.

## Bounded future-proofing

Exact executable/DLL fingerprint and code anchors remain mandatory before mutation. Every mapping/context is validated before writes, originals are captured first, modified bytes and rollback writes are checked, unsupported identities stay vanilla, pending ownership survives read/context/conflict failures, and diagnostics identify failed assumptions without repeated error-log flooding. Policy/profile data remain separate from controller and input adapter. Candidate version, package/source hashes and source-correspondence report identify drift. No native evaluator detour, OS key synthesis, arbitrary action-state write, charge/Meltagun implementation, or other weapon behavior change was added.

The next live trace must show original/current mapping bytes, baseline equality and native trigger/pulse during ON, restored OFF, physical release and a fresh OFF hold. Toggle audits occur after stock update, so that immediate input sample can still describe the last pre-toggle native evaluation. Judge the subsequent fresh-OFF window, not one transition sample. If mappings match their pre-assist baseline but repetition persists, mapping loss is insufficient and the remaining native consumer/evaluator path needs targeted investigation. If trigger-8 mappings remain, ownership/context/restore evidence determines the next fix.
