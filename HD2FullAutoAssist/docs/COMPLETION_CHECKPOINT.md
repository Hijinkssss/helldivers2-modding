# RC3 completion checkpoint and release status

Branch: `release/full-auto-assist-1.1.0-rc3-off-investigation`. Continues directly from `8fbe8d402ac547c1cd143476e10e3149b1bb0828`. No main restart, framework changes, merge, push, publication, deployment or Nexus edit. This is a source checkpoint and internal packaging verification, not the final private RC.

## Completed corrections

The user's fresh verified no-mod vanilla validation establishes Eruptor native hold-to-repeat through its bolt cycle near 32 RPM. OFF repeating is expected native behavior and no longer a restoration investigation. FAA provides controlled cadence at 27/28/32 RPM, default 28; existing input conversion and stock cooldown authority are unchanged. The user's observation of better follow-up control at 28 RPM is recorded as observation, not official design intent.

The 31 supported identities remain. Eruptor is Cadence Control; AMR remains Special; the other 29 retain Repeat Assist policy roles without claiming that all their vanilla held-trigger baselines were newly audited. All five intended charge candidates were audited as Special, currently blocked from activation. See REMAINING_WEAPON_AUDIT.md for the seven requested behavior questions and exact remaining evidence.

The approved HUD renderer is unchanged. `hud_anchor.number` views already-captured Lua strings through cached FFI types, eliminating an FFI allocation/substr/copy per field. `hud_anchor.sample` combines separate flag/link verification reads into one checked 248-byte read per known node while retaining the original comparison predicates. No cross-frame geometry/pointer cache, throttled presentation, additional scan or shifted glyph was introduced. Owner/row rechecks, topology/flag validation, 192-node/16-depth bounds, inaccessible-page guards and nil-on-failure behavior remain.

The cost changes from 3N+4 checked reads to 2N+4 per visible sample. A six-node fixture uses 16 instead of 22 reads; forty nodes use 84 instead of 124; the 192-node maximum uses 388 reads. No unsupported-HUD native reads occur. Optional `hud_anchor` profiling records elapsed time and read/node/success/failure counters in memory and emits with the existing unload summary. Release defaults remain profiling/validation/debug/HUD logging OFF.

## Performance evidence and its limits

Current live RC3 baseline: approximately 50 ms/s, reported by the user. The preserved 1,649-byte RC3 FAA log has 17,421 input checks, zero errors/conflicts, 15 restored mappings, no lease at shutdown and no phase profile. It cannot attribute the 50 ms/s session. The older approximately 14 ms spike is superseded.

Controlled before/after measurements use the real FAA lifecycle read path and Windows ReadProcessMemory/VirtualQuery against the test process's own temporary allocations, with simulated six-node and forty-node HUD trees. Seven measured trials of 2,000 samples follow warmup; measurements, source hash and all trials accompany the output report. This confirms the sampled HUD parse/read cost and its reduction. It does not establish the live node count, Stingray GUI API cost, the share of the 50 ms/s reading, or total mod after-performance.

No source change was made to weapon polling, policy cache, cadence scheduling, native Fire ownership/restoration, mapping validation, page-query caching, context switching or logging frequency. Existing B3/next-version budgets compare those paths against preserved known-good source. The standalone tests include HUD work separately because their old lifecycle fixtures do not instantiate the actual in-game GUI.

The live root cause and after Watchdog measurement remain unresolved until a matched phase profile/production comparison is available. Nested `hud_anchor` and `hud_present` timings must not be added as separate independent costs. See LIVE-VALIDATION.md.

## Regression and packaging checks

New `test_behavior_roles.lua` checks Cadence Control metadata, native held Fire surviving OFF unchanged, all Eruptor lease intervals, zero OFF mapping writes, manual-edge OFF, release guards, supported OFF white state, ON state, unsupported hiding and held swaps. These are input/lease tests, not stock accepted-shot emulation.

New `test_hud_work_budget.lua` enforces 16 reads for stable six-node geometry and 388 at the 192-node maximum, flag/topology race rejection, failure recovery and opt-in in-memory profile counts. Existing live-type-2, AMR/SPECIAL, Commando, all-policy/profile, restore-ownership, HUD state/color/extent/scale, page protection and native-work regressions remain. Package delivery executes the new fixtures against bundled factories with production diagnostics OFF. Deterministic internal package rebuilding verifies the source checkpoint only.

Changed runtime functions: `hud_anchor.number`, `hud_anchor.sample`, `performance_profile` phase registry, `weapon_policy.new` metadata and the initialization version marker. The native Fire/controller behavior is unchanged. Builder profile wording now says Eruptor maximum/native-speed cadence, and metadata explicitly keeps final-RC readiness false.

## Gates preventing a final private RC

1. A verified input-only charge-release/re-press adapter and bound readiness/completion permission for the four nonbeam candidates; Accelerator's burst completion/empty denial needs distinct proof.
2. Meltagun beam owner/consumer and natural completion versus interruption/re-arm proof. Its full-map RC5 capture still has no held-entity key.
3. Matched live attribution of the current approximately 50 ms/s RC3 cost and an actual after measurement with production diagnostics OFF; test-process improvement is not substituted for this result.

No final private RC ZIP is delivered while these gates remain open. An internal verification checkpoint may be built to test deterministic packaging. Existing RC3 artifacts are preserved. The short final ordinary-weapon live checklist is in LIVE-VALIDATION.md; no deployment or launch is authorized by this source checkpoint.
