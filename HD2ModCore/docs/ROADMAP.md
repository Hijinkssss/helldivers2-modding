# Focused roadmap

Core's public identity is QoL, accessibility, input and consumer services. Scope decisions are source-backed by the 2026-09-28 HD2Runtime comparison, rather than a commitment to another broad framework rewrite.

| Decision | Systems |
| --- | --- |
| KEEP | Loader facade, Results/utilities, lifecycle/owner cleanup, namespaced config, structured logs/diagnostics, bounded consumer scheduling, producer-defined events, keyboard edges, hold suppression, validated eligibility, minimal input/UI build guards, bounded reads and snapshot-scoped cache, templates/examples |
| ADAPT | Optional HD2Runtime presence/version/capabilities, semantic metadata and explicit read jobs; existing community binding/options APIs; Runtime results into Core events when needed |
| DROP | Competing gameplay authoring for weapons/support weapons/entities/stratagems/sentries/emplacements/vehicles/backpacks/boosters/projectiles/damage/explosions; generic gameplay writer/transaction/plan engine; duplicate resource scanner and generated gameplay SDK; general native detour/reverse-engineering platform |
| UNRESOLVED | Proven current weapon/mode/active-instance services; reusable action/trigger leases; controller expansion; automatic gameplay-event catalog; public Runtime build-support probe; live bridge coexistence |

Keep Journal frozen and Armory within its tested ship scope. Full Auto Assist remains a behavior candidate until actual representative results justify release. The user reports testing the slower preset but has not supplied the results in this chat. Further firing tests were paused in favor of integration. No charge automation or unproved weapon exclusions belong in v0.1.

The optional bridge is prepared separately as v0.3.1-runtime-candidate. Core infrastructure and simple consumers must continue working without HD2Runtime. Do not merge the candidate into the first public preview or silently replace deployed Core packages without completing its own review/validation.

After FullAuto, prefer a bounded adoption pass for the existing DiversBestFriend accessibility/selection UI, reusing Core's lifecycle/eligibility and existing community controls. Do not start another gameplay-stat mod or recreate HD2Runtime's semantic authoring. This is a recommendation, not newly started work.
