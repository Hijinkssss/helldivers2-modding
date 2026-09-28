# Identity results, 2026-09-28

The read-only route is validated for the observed mission states: owned local avatar, weapon-wielder held entity, equipment resource record, then public HD2Runtime semantic metadata. Raw captures are preserved under `../../HD2FullAutoAssist/validation/selective-identity-2026-09-28`; the machine-readable compilation and hashes are in `identity-validation.json`.

| Observed weapon | Resource hash | Mission entity | Initial policy |
| --- | --- | --- | --- |
| R-2 Amendment | `0f83639ab8c86165` | 475 | REVIEW; vanilla |
| P-2 Peacemaker | `05e4e5c2db6e44a2` | 477 | ASSIST validation candidate |
| APW-1 Anti-Materiel Rifle | `89c5493e08ca4207` | 486 | REVIEW; vanilla |

The controlled 45-second clip contains Amendment -> Peacemaker -> AMR -> Amendment. All 866 samples passed ownership, back-reference and snapshot consistency guards. No absent, unknown or failed samples were observed in that clip. First observations were at 21.266, 26.102 and 31.719 seconds after capture start. Each change is conservatively bracketed by approximately 53-54 ms of observation time; these are not input response times or animation-relative timings. Windows shorter than the polling interval may have been missed.

During the requested return to ship, mission unit/avatar 340/472 became unavailable for approximately 2.70 seconds. New unit/avatar 160/711 appeared with a distinct Amendment entity 714 for one sample, then held state became absent. The old mission entity was not retained. This demonstrates invalidation and rebuilding through that observed player transition; death, reinforcement and other transitions remain untested.

Another clip briefly observed unknown resource `16f397ca5f51f271`. The user reported calling down and picking up AMR, holding it 3-4 seconds, then returning to Amendment. The timing is consistent with that interaction, but the unknown item was not semantically identified. It remains REVIEW and cannot receive assistance.

Across seven clips / 3217 samples, the external observer averaged 1628.634 us and peaked at 5012.2 us; 511 samples exceeded the advisory 2000 us threshold. These include Python/Lua/process-read overhead and do not establish in-game callback cost or negligible overhead. Each probe used only query/read rights; no injection, memory writes, synthetic input or native game calls occurred.

The existing observer code is unchanged. Core 0.3.2 adds only a generic synchronous region-query read scope, while the consumer caches semantic decisions and skips duplicate polling during a lease. All ownership/content reads remain fresh. Those changes passed offline checks; deployed performance is pending.

Only the identity milestone is passed. Selective firing, native-auto/charge preservation, cadence, HUD, new-package coexistence and release readiness remain pending.
