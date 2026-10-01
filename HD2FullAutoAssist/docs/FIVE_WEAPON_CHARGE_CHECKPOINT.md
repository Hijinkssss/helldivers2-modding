# Full Auto Assist checkpoint

Stopped at the user's request with 3% usage remaining. This is a handoff, not a completed charge-support implementation.

Branch: `feature/full-auto-assist-charge-weapons-hud`. Starting commit: `08eec954abdb8a44d0ce8770736414d51b4cc679`. RC3 tooling committed as `d2bca9f`. No merge, push, publication, Nexus update, deployment, or game launch. Gameplay automation remains unchanged and all five charge weapons remain blocked.

## Preserved evidence

All four logs were read and parsed as JSON Lines. Sample times increase, footer totals match the samples, and files are separated by weapon identity. The combined RC3 Accelerator samples are incidental swap data; the dedicated RC3 Accelerator recording is the timing source.

- `HD2FullAutoAssist-charge-probe-Accelerator-Loyalist-saved.log`: 4,142,915 bytes; 3,943 samples; cap hit: False. SHA-256: `171b9c84f8af29743dc7744f37d8846701893156261cfaf543f8d58cad6c5289`.
  - PLAS-15 Loyalist: 3,943 samples, 27 positive-charge episodes.
- `HD2FullAutoAssist-charge-probe-Arc-Purifier-saved-20260929-222028-136.log`: 5,988,229 bytes; 6,000 samples; cap hit: True. SHA-256: `0f4d3ec5d1b91d64a27e3679053594b8af04edc7f3617e14bd5121396fa73f10`.
  - ARC-3 Arc Thrower: 2,908 samples, 9 positive-charge episodes.
  - PLAS-101 Purifier: 3,092 samples, 15 positive-charge episodes.
- `HD2FullAutoAssist-charge-probe-RC3-Meltagun-combined-saved-20260929-232204-446.log`: 6,472,211 bytes; 6,000 samples; cap hit: True. SHA-256: `b7c135edf11d69be7251bb42e9ee0bf187308b9b679a77e6ddcb96265f6753e6`.
  - 40-K Meltagun: 4,408 samples, 9 positive-charge episodes.
  - PLAS-39 Accelerator Rifle: 1,592 samples, 0 positive-charge episodes.
- `HD2FullAutoAssist-charge-probe-RC3-saved-20260929-230618-031.log`: 5,978,671 bytes; 5,538 samples; cap hit: False. SHA-256: `560fe196537c6fac1ff62692727060233bd62546fa59dc33e5b81a2600a57dd2`.
  - PLAS-39 Accelerator Rifle: 5,538 samples, 14 positive-charge episodes.

Saved files are in: `C:\Users\Law\Documents\Codex\2026-09-29\referenced-chatgpt-conversation-this-is-an-3\outputs`. The full machine-readable analysis is `FIVE_WEAPON_CHARGE_PROBE_METRICS.json` in that directory. Original logs were not edited.

## Findings

- Arc: nine charge episodes, seven plateaus near 1.1 seconds and two early releases. Early resets leave retained discharge unchanged, consistent with cancellation. Later valid resets also leave a previously latched 1.1 unchanged, so +8 cannot count shots. +32 remains sticky after the first discharge and cannot establish readiness. No ammo event is available for direct shot confirmation.
- Purifier: fifteen release/reset cycles, five plateaus near 1.0 seconds and ten partial releases. Every reset coincides with one round consumed, magazine 15 to zero. Six empty Fire holds show no charging. No refill was recorded before the cap.
- Loyalist: twenty-seven release/reset cycles, thirteen plateaus near 0.75 seconds and fourteen partial releases. Each charge reset coincides with one round consumed. Six empty attempts and four 0-to-8 refills show charging can resume after replenishment. Two other 3-to-0 ammo transitions are not classified as shots. A final noncharging hold with ammo remains unexplained and must not be treated as permission to force another cycle.
- Accelerator dedicated recording: fourteen positive-charge episodes: seven successful release-triggered three-round bursts and seven cancelled early releases. Six successful releases follow a 0.5 plateau; one succeeds at approximately 0.4556. Early releases near 0.12 to 0.30 cancel. Full holds do not automatically discharge. Each burst consumes three rounds with approximately 0.122-second intervals; runtime recovery becomes approximately 0.12 for each round. Two 0-to-9 refills were captured. No distinct new empty-press attempt was captured. It shares the release-charge mechanism with Purifier/Loyalist but needs a distinct burst-completion policy.
- Combined RC3: Accelerator 1,592 and Meltagun 4,408 samples, exactly 6,000 total. Incidental Accelerator samples show no positive charge episodes in the recorded fields; they are not used as intentional timing evidence. This does not negate the user's recollection of incidental shots during swaps.
- Meltagun: nine charge episodes, seven automatic reset/discharge candidates and two interrupted early releases. Ammo consumption precedes the approximately 0.5 charge reset by about 0.1 seconds. Processed Fire stays held after automatic reset; a later release/re-press starts another charge. Two 0-to-3 refills were recorded. The final cycle is cut off shortly after charge reset by the sample cap. Every beam sample says row_absent: actual beam start, end, interruption, and next permitted restart are not established. Charge reset and ammo consumption are not substitutes for beam completion.

## Why automation is still blocked

All recorded Fire samples explicitly have `physical_binding_verified=false`. Processed action state cannot safely be used as the independent physical-release source once FAA owns a charge input cycle. A verified release/re-press input adapter is still missing. The existing adapter only leases ordinary repeat mappings. All five are currently STILL BLOCKED for activation because of this common input safety gap; the four nonbeam charge models are much better characterized, but this is not permission to turn them on.

No log contains bound charge settings: RC2 omitted them; RC3 reports settings_state=not_found. Exact-build disassembly establishes a recorder lookup bug: settings getter 0x5052c0 tries the live override map and then falls back to resource getter 0x504d80. The current observer stops after the override lookup. The fallback is a bounded 20-slot resource-hash table at owner(global 0x346bf98)+0xf12ad8, with 16-byte keys and 216-byte settings records after table+0x140. This fix is identified but NOT implemented or tested yet. Do not substitute observed plateau times as hardcoded thresholds.

Exact-build native burst code at 0x73d985 reads settings+188 for burst count, runtime+20 for the burst index, and settings+192/runtime+24 for native recovery. A zero timer alone is insufficient to prove the entire Accelerator burst ended. This should be checked against runtime_hex in the saved dedicated log and the native update path before implementing restart permission.

Meltagun beam lookup is absent for the held entity in every captured sample. Do not guess another entity, scan the heap, or use a fixed beam timer. Trace ownership and the native completion consumer offline first. One examined function at 0x80ddd0 uses 40-byte rows and is NOT proved to be the 168-byte Meltagun beam update; do not carry forward that assumption.

## Shared architecture

1. Bounded read-only observer: validate full weapon identity/generation, table roots, row pointers, and settings source. Follow the stock settings fallback; retain validated cache certificates and invalidate on relocation, identity change, or read failure. No ordinary-weapon charge reads.
2. Semantic policies: Arc/Purifier/Loyalist release at the bound native full-charge state; Accelerator release at the native state and await completion of the full native burst; Meltagun await independently confirmed beam completion before re-press. Thresholds and permission come from native evidence, never duration guesses.
3. One Fire-input adapter: only ordinary legal Fire edges. Establish the physical binding independently, preserve exact original mapping bytes, restore on every exit, retain originals for restoration retries, and preserve external edits. No weapon-state writes or synthetic startup keypress.
4. Shared cancellation: physical release, swap, generation/identity loss, unsupported weapon, death/respawn, ship/mission, read failure, ammo denial and reload recovery invalidate charge state and restore Fire. Reacquisition must not reuse a previous weapon's state.
5. HUD consumes the existing shared state; no independent native polling. The ordinary RC2 candidate uses Eruptor profiles 27/28/32, default 28.

## Next work, in order

1. Fix the exact native settings fallback in the recorder with collision, missing-key, sentinel, cache invalidation, override precedence and read-race fixtures. Preserve RC2 and RC3 artifacts.
2. Trace the physical binding and release/re-press input path offline. Do not enable a new adapter until mapping and restoration safety are proved. Add independent physical/mapping diagnostics only if necessary.
3. Trace the actual Meltagun beam ownership/completion path offline and correct a proved recorder defect if found.
4. Use all five policies in one architecture; wire only those that pass the native permission and physical-input gates. No Quasar, Railgun, Epoch, reload automation, auto swapping, ammo management, overcharge protection, stat changes or cooldown bypass.
5. Test native work, lease restoration, physical release, swaps, stale generations, reload/denial, death/respawn, mission transitions and failure/recovery before building a new candidate.

Do not request another broad probe. If offline work still leaves a gap, the smallest possible targeted observation is: (a) one hold/release on the specifically verified Fire binding to correlate independent physical input, and (b) one Meltagun beam with Fire held through its visible end, then one release/re-press. Such a recording is useful ONLY after its diagnostics actually observe the missing binding/beam state; the current RC3 recorder cannot resolve the beam gap. No repeat of the old five-weapon checklist is requested.

## Tests, packages and performance

RC3 checks passed before this analysis: 23 standalone groups, B3 cache/bounds regressions, native-work parity against v1.0.1 for ordinary scenarios and idle/manual holds of all five charge weapons, actual Loader API filename handling, actual Loader discovery and deterministic ZIP rebuild. No new automation was enabled, so there are no automated-charge work-budget or gameplay results. The exact native-work reports are preserved in RC3_VALIDATION.json / RC3_PACKAGE_CHECKS.json / RC3_BUILD_REPORT.json and the repository build reports. Live ~5 ms/s idle and ~13–14 ms/s active targets remain unverified for new charge support.

Existing unpublished RC3 research ZIP: `Full-Auto-Assist-1.1.0-research-rc3-Charge-Research-Arsenal.zip`.
SHA-256: `5412ba4ac425ea8b5436da98d991208fb46735408d543a871daa926923002678`.
It is the earlier two-target research package, NOT a charge-automation candidate and NOT a beam-recorder fix. No new implemented charge-support ZIP was produced at this checkpoint.

Workspace: `C:\Users\Law\Documents\Codex\2026-09-29\files-pasted-by-the-user-continue-3\work\helldivers2-modding`.
Analysis script: `C:\Users\Law\Documents\Codex\2026-09-29\referenced-chatgpt-conversation-this-is-an-3\work\analyze_charge_probes.py`.
Exact-build disassembly script: `C:\Users\Law\Documents\Codex\2026-09-29\referenced-chatgpt-conversation-this-is-an-3\work\native_charge_details.py`.
Dump: `C:/Users/Law/.codex/.chatgpt-projects/g-p-6ab5a5a50be48191a2ea4b3727a6602b/work/chat-native-review/game-25480438-memory.bin`, SHA-256 `e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969`.

User requested this stop; resume from this checkpoint and do not redo the probe collection or start from main.
