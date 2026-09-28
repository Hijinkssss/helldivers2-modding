# Contributing

Use small LuaJIT 2.1 modules, LF UTF-8, explicit Result checks and stable owner identifiers. Preserve game callback arguments, nil return values and errors. Register cleanup before acquiring resources; unregister owned subscriptions and release handles on every failure and normal exit. Keep gameplay decisions in consumers.

Public API changes need documentation, meaningful fixtures and an evidence record separating source review, offline checks and observed game behavior. Build constants require exact EXE/DLL hashes, provenance, bounded reads and unchanged-state checks. An old RVA or a working third-party mod is insufficient proof of a new public capability. Do not promote experimental game-state fields without independent validation.

Avoid unnecessary work each frame. Prefer subscriptions, rate limits and on-demand reads. Measure native read/query counts and direct callback cost; report workload and limitations. Scheduler budgets are advisory and cannot interrupt synchronous work. Preserve snapshot-scoped cache expiry and refusal on unavailable/changed state.

Build and run the documented offline suite before submitting a patch. Do not include game captures, extracted game resources, other authors' source/binaries, tokens, personal paths, saved profiles or raw user logs. New third-party code needs redistribution permission and retained notices. Keep Core API and loader resource identities stable; document breaking changes before release.

For bugs, include Core/consumer versions, Steam build, EXE/DLL hashes when relevant, Loader version/API, enabled mod list and order, reproduction steps, expected/actual behavior and redacted logs. Remove usernames, local paths, chat content and credentials. State whether the failure is on ship, during loading or in a mission, and whether shutdown cleanup completed.
