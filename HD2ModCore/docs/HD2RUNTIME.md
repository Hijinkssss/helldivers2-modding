# HD2Runtime interoperability

Core remains independently usable for input, accessibility/QoL and consumer services. HD2Runtime is an optional, separately installed semantic gameplay dependency. Bingus Shared Loader v18 / API 1 is required by this Core preview.

The source audit pinned HD2Runtime 0.24.0 at `fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`. Its public library is `mods/skyeshade/hd2runtime`, API 1. It owns reviewed gameplay definitions, resource/component resolution, weapon/support/stratagem/entity authoring, projectile/damage/explosion composition and guarded writing. Core keeps keyboard edges, eligibility, owner cleanup, consumer config/logging, scheduling and generic events.

A separate local v0.3.1 candidate implements `core.Integrations.HD2Runtime`: explicit startup connection, version/capability reporting, public typed metadata, and opt-in legacy read jobs stepped through Core's scheduler. The v0.3.0 public staging source does not yet include that extension. Metadata adds no background work. Generic player/support graphs are not a universal live-read interface, and metadata does not identify the current held weapon or selected firing mode.

Do not wrap HD2Runtime's internal resolvers, scan again for its data, copy its SDK, or independently write the same gameplay fields. Consumers using its public authoring API must own/cancel its watches. Do not tick a Runtime-attached watch through Core as well. Cancellation stops further work and does not imply restoring vanilla. Runtime's operation gate is not a global third-party memory lock.

Core's own build support and Runtime's are separate. HD2Runtime has no dedicated exported build-support probe; successful metadata import is not live support evidence. Generic Core services can remain available even if game-dependent features refuse a build. Both callback wrappers require game restart for package changes; no hot reload guarantee is added.

No root license grant was found in that pinned HD2Runtime checkout/package. Its THIRD_PARTY/provenance files document inputs but do not authorize source reuse. Our adapter is independently implemented against public APIs. HD2Runtime source, SDK/stubs and binaries are not redistributed or covered by our MIT license. Credit and obtain the dependency from [SkyeShade/HD2Runtime](https://github.com/SkyeShade/HD2Runtime).

The separate candidate's API is provisional. This preview promises only the services documented in its own API reference. The [pinned upstream public facade](https://github.com/SkyeShade/HD2Runtime/blob/fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595/api/hd2.lua), [typed target builders](https://github.com/SkyeShade/HD2Runtime/blob/fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595/api/target.lua) and [0.24.0 release limits](https://github.com/SkyeShade/HD2Runtime/blob/fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595/docs/releases/0.24.0.md) are the dependency contracts reviewed for that candidate.
