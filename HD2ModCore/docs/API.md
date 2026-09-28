# Implemented public API

The discovered resource require('mods/codex/hd2_mod_core') returns the singleton core facade. All methods below use Lua's colon-call form. Fallible service operations generally return {ok=true,value=...} or {ok=false,error={code,stage,detail}}. Platform internals are not part of this API.

## Lifecycle

~~~lua
core.version                         -- "0.3.0-dev"
core.api                             -- 1
core:State()                         -- state string
core:OnLoad(owner, callback)         -- invokes callback(core) now; isolated failure
core:OnUnload(owner, callback)       -- callback(core) on shutdown/unregister
core:Unregister(owner)               -- removes subscriptions and runs unload handlers
core:Shutdown()                      -- idempotent cleanup
~~~

The owner is a stable addon identifier. Register the unload callback before acquiring resources. Owner unload callbacks run in reverse registration order. Unregister removes scheduler, event and input subscriptions for the owner. A failed owner callback is reported and does not prevent other owners' cleanup.

~~~text
uninitialized â†’ initializing â†’ running
                            â†˜ degraded
                            â†˜ failed
running/degraded/failed â†’ shutting_down â†’ stopped
~~~

Required stage failures roll back completed stages and do not publish a singleton. Missing loader API or game update callback is fatal. Optional logging/config/profile failures leave the core degraded with reasons. A known profile with only source evidence is also degraded. Shutdown restores update and shutdown only if core still owns those globals; it cannot safely remove a later addon's outer wrapper.

## Scheduler hooks

~~~lua
local result = core.Hooks:Subscribe(owner, "before_update", {
    every_ms = 100, budget_us = 500,
    error_policy = "disable", max_errors = 1, backoff_ms = 1000
}, function(dt) ... end)
core.Hooks:Remove(result.value)
~~~

Phases are before_update and after_update. Both preserve arguments and return values of the prior game callback. A prior-callback exception triggers core cleanup and is rethrown. Subscriber exceptions are caught and logged. Disable is the default error policy; retry uses a bounded failure count and backoff. A subscription with every_ms=0 is eligible every frame. Next due time is measured after callback completion, so a slow frame causes no catch-up burst.

There are at most 64 active subscriptions. Each tick has a 2000 Âµs **soft** dispatch budget, and each subscriber has a declared budget_us. Synchronous callbacks cannot be preempted; slow calls are counted and logged. Owner removal drops callback references. This is a Lua callback manager, not a native function hook.

## Generic snapshot events

~~~lua
local token = core.Events:Subscribe(owner, "my_channel", function(event)
    -- event = {channel, sequence, changed=true, current, previous}
end)
local observed = core.Events:Observe("my_channel", "stable-fingerprint", {value=1})
local latest = core.Events:Current("my_channel")
core.Events:Remove(token.value)
~~~

Observe compares a producer-supplied string or finite number fingerprint. Identical fingerprints do not notify subscribers. Input snapshots are copied with an eight-level, 256-item and 32 KiB string-data limit; unsafe values and keys are rejected. The producer is responsible for a fingerprint that truly represents its state. V0.1 emits no automatic game-specific event.

A subscriber added during publication first receives the next change. Recursive publication is rejected with BudgetExceeded. Unsubscribing during publication prevents a pending callback from running.

## Configuration

~~~lua
core.Config:Register("my_mod", {
    enabled={type="boolean",default=true},
    interval={type="integer",min=10,max=1000,default=100}
})
core.Config:Load("my_mod", "enabled=false\ninterval=250\n")
local value = core.Config:Get("my_mod", "interval")
~~~

Supported types are boolean, bounded integer, bounded string and enum. Namespace/key names are alphanumeric identifiers with underscores. Loads are atomic and capped at 8192 bytes. Malformed lines, duplicate keys, unknown keys and invalid values return InvalidConfig; the previous valid config remains in use. Core consumes log_level and diagnostics from %LOCALAPPDATA%/CowboyBingus/Helldivers2/HD2ModCore.ini when present. Missing file uses defaults; a read or parse failure degrades startup and is reported.

The diagnostics setting controls automatic startup/shutdown status-file snapshots. `diagnostics=false` leaves structured status available through `Status()` and allows an explicit `WriteStatus()` call. Fatal initialization failures still attempt a status snapshot.

## Build profile and reads

~~~lua
core.Build:Status()               -- {state, id, evidence}
core.Memory:Read(address,size)    -- bytes
core.Memory:ReadU32(address)      -- little-endian unsigned 32-bit integer
core.Memory:ReadPointer(address)  -- canonical numeric pointer, not object identity
~~~

An exact EXE and DLL hash must select a profile before public reads are enabled. source_known is distinct from runtime_observed. Reads require integer addresses in 0x10000..0x7fffffffffff, integer sizes 1..32768, no range overflow, and committed readable nonguarded pages across the full span. Region walking stops after 64 regions. A successful byte read does **not** establish entity type, object lifetime, or compatibility of any offset. There is no write, patch, protection-change or native-call API.

## Logging and diagnostics

~~~lua
core.Logger:Emit("warning", "my_mod", "event_name", {reason="example"})
core.Diagnostics:Status()        -- copied structured status table
core.Diagnostics:WriteStatus()   -- rewrites whole HD2ModCoreStatus.log
~~~

Levels: trace, debug, info, warning, error, fatal. Event history keeps the handle returned by the loader's open_log('HD2ModCoreEvents.log') open until shutdown. The loader opens files in write mode; HD2ModCoreStatus.log is intentionally a rewritten current snapshot. Diagnostics include framework version/state, module states, profile and address-resolution status, scheduler/event/read counters and the most recent failure. No logging is performed for each memory read.

Typical error codes: InitializationFailed, InvalidState, UnsupportedBuild, BuildIdentityFailed, InvalidConfig, InvalidSubscription, InvalidEvent, InvalidRead, InvalidPointer, ReadFailed, BudgetExceeded, CallbackFailed and CleanupFailed. Errors are values unless a prior game callback itself throws; that original error is propagated after cleanup.


## Keyboard input (provisional)

`core.Input:ParseKey(key)` returns a Result containing a Windows virtual key. `SubscribePressed(owner,key,{debounce_ms=150},callback)` returns a Result token; `Remove(token)` returns a boolean. Callbacks receive no arguments and run after the prior update. At most 32 subscriptions, one sample per unique key per focused update. Registration/refocus requires release before a new press; holds do not repeat. Debounce is 0..2000 ms; rejected edges are consumed. A callback error disables that subscription. This is OS keyboard polling, not chat handling or controller rebinding.

`core.Input:ShortcutEligibility()` returns a Result of `{allowed,reason,window_focused,cursor_visible,text_entry_active,primary,modal,stack_count,secondary_count,pending}`. Reasons: `eligible`, `game_focus_lost`, `ui_cursor_visible`, `text_entry_active`, `ui_busy`. Unsupported build, missing/invalid engine/read service, changed native anchor, invalid bounds, failed reads, changing snapshot or stopped Core returns an error. Require success AND `allowed == true`. Call on demand immediately before acting; never queue a blocked press. The generic text receiver does not expose text. Its layout is build-specific and live coverage is ship chat only.

## Experimental diagnostic access

`core.Symbols:Resolve(name)` returns a Result for an exact-build module-relative symbol. `core.Diagnostic:LocalAvatar()` returns a Result containing copied diagnostic state and IDs, including a held-entity candidate. These fields do not establish weapon identity, idle/camera state or durable entity handles. There is no stable Game/Equipment API.

## Maturity policy

| Surface | Preview maturity | Dependence |
| --- | --- | --- |
| Result shape; lifecycle; Config; Logger; Hooks; generic Events | Stable infrastructure contract for this preview | Loader API 1, Windows/LuaJIT host |
| Diagnostics status schema | Provisional | Fields may expand/change before 1.0 |
| Input ParseKey/SubscribePressed/Remove | Provisional | OS keyboard/focus; feature-check |
| Input ShortcutEligibility | Provisional, build-specific | Exact hashes, native anchor/layout; ship chat tested |
| Build/Profiles, Symbols, Memory | Experimental/build-specific | Exact profile and bounded readers |
| Diagnostic LocalAvatar/held state | Experimental | Observed diagnostic IDs, incomplete semantics |
| Internal module constructors/platform/cache details | Private | No consumer compatibility promise |

Stable describes the evidence-backed infrastructure contract, not a 1.0 lifetime guarantee. API 1 alone does not promise Input exists in older local versions. Feature-check extensions and require the documented minimum release. Consumers should not call global `Shutdown()` during ordinary unload; use their own `Unregister(owner)`.
