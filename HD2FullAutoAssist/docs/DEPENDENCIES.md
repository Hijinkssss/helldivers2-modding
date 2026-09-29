# Full Auto Assist dependency audit and standalone design

Reference: `a93008f5c0a69bf5bcf4be8bddb468dc5607bcf3` on
`feature/full-auto-assist-weapon-policy`. The inventory below was taken from
`full_auto_assist.lua`, `native_fire.lua`, `weapon_policy.lua` and the builder
before their dependency plumbing was replaced. `assist_state.lua` has no Core
or Runtime calls and remains unchanged.

| Reference dependency | Purpose | Standalone replacement |
|---|---|---|
| `core.api`, Input/Config/Hooks/Diagnostic presence | Runtime service contract | Private mod-specific host; no public service API |
| `OnLoad`, `OnUnload`, `Unregister` | Initialization, stop, rollback, unload | `lifecycle.lua` startup and cleanup for one controller |
| `Config:Register`, `Config:Load` | Strict bounded INI parsing | `config.lua`; same settings/defaults, unknown/duplicate/invalid entries rejected before firing |
| `Input:ParseKey`, `SubscribePressed`, `Remove` | `=` rising edge and 150 ms debounce | Local `VK_OEM_PLUS` poll after stock update; optional Mod Bindings Menu registration takes precedence when available |
| `Input:ShortcutEligibility` | Chat, UI, cursor and focus isolation | `input.lua`: preserved native UI layout, text anchor, bounds and transition revalidation |
| `Memory:Read`, `ReadPointer`, `ReadU32`, `WithReadScope` | Bounded reads and per-callback region cache | Mod-local guarded `ReadProcessMemory` and `VirtualQuery` via LuaJIT FFI |
| `Build:Status` and Core EXE/DLL profile selection | Exact build gate | Both original SHA-256 fingerprints checked through Windows BCrypt; PE image bounds and native input anchors also checked |
| `Symbols:Resolve('player_manager')` | Native input player global | Five fixed current-build globals owned by this mod, checked against loaded image size |
| `Diagnostic:LocalAvatar` | Fresh local-player/avatar/held resource identity | `identity.lua`: extracted bounded avatar/wielder/equipment observer, ownership/backrefs/map guards and final revalidation preserved |
| `Logger:Emit` | Startup, warnings, errors, cleanup records | Shared Loader `open_log('HD2FullAutoAssist.log')` plus local JSON formatting |
| `Diagnostics:Status`, `WriteStatus` | Optional validation summaries | Local read/observer/callback/error counters; no general diagnostic framework |
| `Hooks:Subscribe('before_update')`, `Remove` | 100 ms idle identity observation and every-update Fire safety check | Local wrapper for exactly two callbacks, before stock update; original arguments and return values forwarded |
| Existing native FFI writes | Lease button Fire mappings and restore them | Existing native adapter retained; full 20-byte writable mapping, context and compare/readback checks remain mandatory |
| `Integrations.HD2Runtime` reference and `Status` | Require connected 0.24.0 with weapon/support metadata | Removed; known current-build resources plus fresh native identity reads |
| Runtime bridge `Connect`, `Target` | Find the explicit named weapons | Explicit table of eleven unique known resources; no discovery or Runtime code embedded |
| Target `describe` | Name, resource uniqueness; canonical support identity | Pinned reviewed resources and categories in `weapon_policy.lua`; ambiguous Laser Cannon resources remain unmapped REVIEW |
| Target `fire_modes` | Veto native-auto/unknown semantics | Reviewed static current-build policy. R-menu introspection deferred; unknown resources fail closed |
| Builder import of Core build module and original-capture argument | Encode resource archive and verify original evidence | Existing archive encoding moved into the mod's build tool; evidence stays historical, standalone tests check extracted observer behavior |

Full Auto Assist never calls Runtime read/patch/transaction APIs. The reference
suite's `ReadLegacy` cancellation exercise tested the bridge, not a consumer
dependency. No Runtime schema/catalog/API files are shipped.

[Shared Loader's public interface](https://github.com/CowboyBingus/BingusSharedLoader/blob/main/docs/TECHNICAL.md)
provides startup/discovery and API 1 logging. Its optional ecosystem peer,
[Mod Bindings Menu](https://github.com/CowboyBingus/ModBindingsMenu), exposes
`register_binding` and `is_down`. Full Auto Assist registers a third-party slot
only when both functions exist, then stops polling the local `=` key. Missing or
failed registration leaves the standalone fallback active. The menu API has no
argument for choosing a new binding's default key, so its initial default is
controlled by the reserved third-party action. Rebinding and persistence belong
to that menu. Vanilla Plus and Mod Bindings Menu are optional and are not
package/runtime dependencies.
Only native operations use FFI; configuration, policy, state and lifecycle use Lua.

## Files and safety boundary

- `full_auto_assist.lua`: existing hold/release/toggle controller and counters.
- `weapon_policy.lua`: explicit current-build hashes, names, categories and rates.
- `assist_state.lua`: unchanged resolved state and cache.
- `native_fire.lua`: existing input mapping lease, verification and restoration.
- `identity.lua`: local avatar/held resource reader; maximum 96 reads per snapshot.
- `input.lua`: existing UI eligibility algorithm.
- `config.lua`: one strict mod INI.
- `platform.lua`: only required Windows reads, hashing, clock and key state.
- `lifecycle.lua`: one mod's read guards, fixed symbols, callback forwarding and logging.
- `validation_trace.lua`: existing optional bounded local evidence collection.

There is no generic registry, event bus, runtime bridge, mod framework export,
whole-arsenal mapping, detour service or general patching API. The module's own
`require` allows only these bundled files and LuaJIT's `ffi`. HD2ModCore and the
separate Runtime integration candidate remain intact in their own directories.

The only policy change is Talon's Balanced override. Unsupported builds refuse
startup before a callback or mapping write. Unknown/invalid identities restore
assistance and require Fire release. Mapping edits are preserved, and partially
written mappings retain rollback state. Failed stop attempts retain restoration
state and retry while updates remain available. Process termination has no further
updates; no Lua mod can perform an unload callback after the process is gone.
