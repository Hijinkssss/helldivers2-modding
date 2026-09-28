# HD2 Full Auto Assist v0.1.1: selective live validation candidate

The held-weapon route passed read-only idle Amendment/Peacemaker/AMR swaps and player-state invalidation. The source identity gate is now enabled for a **Peacemaker-only selective firing validation candidate**. This is not a selective gameplay pass or a release candidate. The previous identity-gated ZIP remains a rollback artifact.

Use Shared Loader v18, HD2ModCore v0.3.2 Runtime bridge candidate and separately installed HD2Runtime 0.24.0+. Missing Runtime disables selective assistance cleanly and leaves normal Fire behavior. Neither dependency is embedded. Nothing has been installed or deployed by the build script.

This validation build requires the reviewed Runtime **0.24.0** during identity resolution. A disconnected/replaced bridge or lost weapon capability invalidates the shared state and restores an active lease. Dependency loss never grants eligibility. Only Peacemaker is an ASSIST candidate; all other entries remain vanilla.

`validation_logging=true` enables bounded local JSONL collection in `%LOCALAPPDATA%/CowboyBingus/Helldivers2/Logs/HD2FullAutoAssistValidation.jsonl`. Records carry a unique run ID, sequence and in-process monotonic timestamp. State changes, input edges, observed Fire events, acquisition/restoration and warnings/errors are recorded. Native Fire is observed while the toggle is OFF without acquiring a lease. Records are buffered and flushed at most once per second, with five-second cumulative cost histograms and Core diagnostics. The collector preserves each run before a restart overwrites the live file. It adds no scheduler subscription.

Costs include identity resolution, full callback, idle/held update, repeat controller and trace flush. The reported p95 is an upper bound from fixed histogram bins. Policy cache hits/misses, region cache hits, memory reads and scheduler counters accompany the cost records. Raw left-mouse state is also sampled, but its association with the configured Fire binding is unverified. Input events measure attempts, never successful shots, mechanical RPM, animation or audio. Timing and in-game overhead remain pending until live records exist.

The prepared live-test configuration starts `user_enabled=false`, uses 125 ms, and enables validation logging. F8 turns assistance on. The normal example keeps validation logging disabled and retains the user's startup preference. The full guarded identity walk is retained pending measured in-game cost and a validated faster observer; no stale cached identity may authorize a repeat lease. Resolved semantic policy is cached and avatar, entity, resource, invalid snapshot and Runtime transitions invalidate effective state.

## Policy and state

The consumer owns an explicit whitelist. Only P-2 Peacemaker is an ASSIST candidate, with a provisional ceiling retaining the previous 125 ms interval (480 input attempts/minute). This is not a verified shot rate or native weapon RPM. Native weapon data and its mechanical shot limits are untouched. Cadence must still be validated; a slower configured interval is supported.

Verdict, Veto, M6C/SOCOM Pistol, Talon, Diligence, Diligence Counter Sniper and AMR are REVIEW candidates pending semantic and gameplay evidence. Liberator and Amendment are REVIEW for all modes. Quasar is IGNORE. Laser Cannon's ambiguous resources remain REVIEW/vanilla. All unlisted, ambiguous, mixed-mode, malformed or unknown identities remain vanilla. Metadata cannot automatically approve a weapon.

The public Runtime API resolves semantic metadata once at startup. Subsequent classification uses the local policy map and unchanged identities reuse the resolved state. The observer retains its full guarded graph. Core 0.3.2 shares region-query validation within the firing callback and always rereads memory contents. Actual in-game performance is pending.

`consumer:get_state()` returns a detached copy of one consumer-owned state: user toggle, held entity/hash/semantic identity, classification, identity confidence, effective assistance, and repeat lease activity. Identity observed through the candidate route is distinct from identity validated live. The future HUD must consume this same state. No HUD has been implemented yet.

F8 changes the global user toggle and does not change on weapon swaps. This persistence is within the running session. `user_enabled` selects the startup preference; pressing F8 does not save a file. `enabled=false` disables the consumer entirely. `repeat_ms` supports 125 through 1000 ms and is bounded by the explicit per-weapon ceiling. Unsupported input mappings remain vanilla.

Idle diagnostic polling runs at most once every 100 ms, including while the user toggle is OFF. It skips duplicate work during an active lease because the firing callback revalidates identity every update. Any entity, hash, player, policy or identity invalidation terminates the lease on the next observed update and requires Fire release before restart. These controller paths have only synthetic offline validation until live firing checks are recorded.

## Validation and deployment

See `docs/VALIDATION.md`, `docs/identity-validation.json` and `build/selective-checks.json` for evidence, exact hashes and scope. The builder verifies the recorded observer source and capture hashes before enabling packaging. The package contains one selective option, with no universal or Maximum variant. It retains the same addon identity as the original consumer and should not be enabled alongside it.

After replacing the original consumer/Core with these candidates and installing Runtime, validate Peacemaker hold/release/toggle and swaps to Amendment/AMR. These latter two must remain vanilla and the global toggle must persist. Measure the actual callback cost before adding further ASSIST entries. Broader representative native-auto/charge checks and HUD integration follow reliable selective behavior.

This is **not release-candidate ready**. Live identity evidence is established only for the observed states. Selective firing, HUD, in-game callback cost and gameplay cadence remain unvalidated. Animation-relative timing and input-to-identity latency were not measured; brief windows between 50 ms polls cannot be excluded.
