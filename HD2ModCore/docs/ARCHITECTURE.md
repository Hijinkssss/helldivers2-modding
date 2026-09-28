# Architecture

The packager embeds independent Lua module factories into one plaintext Loader resource. `entry.lua` returns a cached facade, wraps the prior update/shutdown callbacks once, and rolls back required-stage failures. Loader owns discovery/bootstrap; Core owns only its Lua wrappers and registered consumers.

The foundation modules provide Result values, namespaced atomic config, bounded structured logging, lifecycle, per-owner scheduler subscriptions and producer-defined snapshot events. The Windows adapter supplies hashing, clocks, bounded reads and keyboard/focus sampling. Profiles select exact identities; symbols resolve module-relative addresses; the diagnostic observer rechecks bounded entity-map snapshots. Readable-page cache entries live only inside one synchronous observer snapshot. Normal reads still validate pages and every read uses ReadProcessMemory.

Input runs after the prior update and before after-update scheduler callbacks. Shortcut eligibility is on-demand and holds no subscription. It checks engine focus/cursor, an anchored native UI receiver and a reread menu snapshot. It does not call native UI functions. Consumers choose actions and must apply the guard themselves.

Shutdown runs owner cleanup in reverse registration order, clears scheduler/event/input callbacks, stops stages and restores globals only while Core still owns them. A later outer wrapper cannot safely be removed; restart instead of assuming hot reload. Armory's exact-build native presenter stays entirely in its independent consumer.

HD2Runtime is the optional semantic gameplay layer. Core retains native input/UI guards and consumer services rather than implementing another resource/weapon authoring runtime. The separate bridge candidate calls its public API only. Unscheduled public read jobs can use Core dispatch; HD2Runtime-attached watches retain their own scheduling. Each operation has exactly one driver. See [interoperability](HD2RUNTIME.md).
