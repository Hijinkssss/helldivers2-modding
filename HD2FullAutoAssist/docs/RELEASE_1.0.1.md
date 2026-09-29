# Full Auto Assist v1.0.1 release validation

## Scope and evidence

Continues the existing performance branch from validated candidate `9010c978a66b72e13a67c47a0c4802f9256fe3e7`. The mod author reported successful live testing on 2026-09-29: Talon, Verdict, Cookout and Eruptor work; slow-cadence repeat continues; weapon and mission transitions retain assistance; no known lease/restoration failure reproduced. This is author-reported gameplay evidence, not an agent-captured new session.

Observed Mod Lag Watchdog results: original ship idle approximately 50–53 ms/s and combat commonly 67–75+ ms/s; validated candidate ship idle generally 4.5–5 ms/s, brief values around 6 ms/s, mission usage generally below approximately 13–14 ms/s. These observations do not establish universal CPU timings or FPS gains. Performance is treated as resolved; validated cache architecture remains intact.

## Final Eruptor policy

The existing per-weapon profile selects Balanced 26 RPM by default: `60/26 = 2.3076923077` seconds, rounded diagnostic interval 2308 ms. This applies without an INI and with legacy global native-cap mode. Explicit Eruptor Full Auto retains 32 RPM. Arsenal profiles take precedence over the optional `eruptor_profile=balanced|full_auto` INI setting. No other weapon policy changes, including Constitution 60 RPM, Crossbow 50 RPM, Cookout 80 RPM, Talon profiles and Verdict 380/450 RPM.

No scheduler redesign: B3's `seconds / ceil(seconds)` conversion remains identical. The input safety ceiling alone admits the new slowest policy interval (`60/26` instead of `60/32`); just-outside bounds, infinity, NaN and invalid types still fail before writing. At 26 RPM the native retry parameter is `20/26` seconds. The game retains accepted-shot/cooldown/animation control; the final 26 RPM settling feel has not been newly live-tested by the agent.

## Final checks

All 20 existing standalone groups pass. All three B3 groups pass, now covering 78 policy/profile cases including both Eruptor options, multi-cycle long holds, cadence-boundary release/taps, native transitions, exact restoration, retry after transient read failure, cache invalidation, ship/mission/death/respawn recovery and actual Windows own-process guard/no-access/freed-memory rejection. A direct comparison against the validated B3 policy confirms every non-Eruptor identity and cadence is unchanged.

The actual delivered bundle runs with its included INI while profiler and validation constructors are forbidden. Profiling, validation logging and debug logging remain off. The new Eruptor option uses existing Shared Loader option discovery. Source/archive/ZIP parity, actual Shared Loader discovery without warnings, all 18 selectable option modules, dependency audit and deterministic rebuild pass. No Core/Runtime dependency is bundled. No game launch, installed configuration change or deployed-file edit occurs during this release pass.

## Preserved native-work budgets

Identical byte-memory fixture, 1,000 updates at 5 ms/update (five simulated seconds), setup excluded. All final values match validated B3 exactly; these are operation counts, not time measurements.

| Scenario | Reads | Page queries | Rediscoveries | Maximum reads/queries per update |
|---|---:|---:|---:|---:|
| Ship idle | 3150 | 20 | 0 | 6/4 |
| Supported idle | 4850 | 100 | 0 | 40/20 |
| Unsupported idle | 4850 | 100 | 0 | 40/20 |
| Unsupported held | 10850 | 100 | 0 | 46/20 |
| Active Fire | 54000 | 125 | 0 | 54/25 |

Steady policy classifications remain zero. Parent-first identity certificate checks, bounded 96-read discovery, validated binding lookup with at most 256 probes, 64-entry page metadata cache and one-second refresh remain unchanged. Every native read still checks current access; writes require fresh page validation and compare/write/readback. The prior restoration retry and eligibility/focus guards are preserved.

## Publication boundary

v1.0.0 was the only current public GitHub release and Nexus version when checked. v1.0.1 is the next release. Public package filename: `Full-Auto-Assist-1.0.1-Arsenal.zip`; final hash is provided with the release asset. Only the performance branch and main are advanced. Existing v1.0.0 tag/history and compatibility, HUD and Warrant branch refs are preserved. Nexus follows GitHub publication, retains the existing page format and leaves the author's sticky post untouched.
