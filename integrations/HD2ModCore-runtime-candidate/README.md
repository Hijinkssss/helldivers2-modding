# HD2ModCore optional HD2Runtime bridge candidate

Version **0.3.2-runtime-candidate**, Core API **1**. QoL, accessibility, input and consumer services for Helldivers 2 mods. This candidate adds an independently written, optional bridge to the separately installed HD2Runtime public API and a synchronous read scope. The validated v0.3 input candidate and previous 0.3.1 ZIP remain rollback artifacts.

Required: Windows x64, Bingus Shared Loader v18 / API 1. Optional: [SkyeShade/HD2Runtime](https://github.com/SkyeShade/HD2Runtime) 0.24.0+ / API 1. Core input eligibility and diagnostic reads retain their existing exact-build guards. HD2Runtime checks its own supported build during each live operation. Connecting metadata does not prove that either project's game-specific features support the current build.

Build with `python scripts/build.py`. The prepared package is `build/HD2ModCore-v0.3.2-Runtime-Candidate-Arsenal.zip`. It replaces another Core package; enable only one Core version. Install HD2Runtime separately. No loader or HD2Runtime implementation is embedded. Neither this candidate nor HD2Runtime has been installed or deployed by this pass.

```lua
local core = require('mods/codex/hd2_mod_core')
local bridge = core.Integrations and core.Integrations.HD2Runtime
if bridge then
    -- Explicitly connect during addon startup while archived modules are available.
    local connected = bridge:Connect()
    if connected.ok then
        local info = bridge:Describe('weapon', 'AR-23 Liberator')
        if info.ok then
            -- Definition metadata, not proof of the player's current weapon/mode.
        end
    end
end
```

The bridge never connects automatically. A missing optional runtime leaves Core's input, lifecycle, config, logging and generic events usable. Repeated connection failure is cached for this process; install/restart instead of polling every update.

Methods use Core Results except `Status()` (copied status data) and `CancelRead(owner)` (boolean):

- `Connect()`: public resource lookup, API/version checks and per-method capabilities. No game-memory access or scheduling.
- `Status()`: connection state, version, capabilities, active read count. `build_support='not_checked'` is intentional; HD2Runtime has no separate exported build-check service.
- `Target(kind,identity)`: public typed descriptor passthrough. Supported builders: weapon, support_weapon, stratagem, vehicle, backpack, equipment, booster, weapon_attachment. Each builder is feature-checked.
- `Describe(kind,identity)`: detached copy of the builder's public metadata.
- `ReadLegacy(owner,target,on_result,on_error)`: one explicit read through `hd2.read`, stepped by Core's existing scheduler. Only targets that implement a supported `read_target()` work. Generic player/support weapon graphs are not a universal live-read interface. At most eight jobs, one per owner, 10,000 steps each. Successful results retain HD2Runtime's evidence and mode labels.
- `CancelRead(owner)`: remove Core's step callback and release the read job reference. Owner unregister/shutdown also does this. Cancellation makes no memory changes.

No patch, transaction, ensure, memory-write or protection API is exposed. Authoring consumers should call HD2Runtime directly and explicitly own/cancel its watches. The bridge adds no scheduler wrapper; metadata adds no subscriptions. Explicit reads use a 16 ms scheduling interval and a 500 us advisory budget. HD2Runtime's initial fingerprint/resolution can still exceed a soft callback budget; live read cost remains unmeasured.

The candidate has passed targeted bridge failure/cancellation/budget checks, actual 0.24.0 metadata lookup and Windows declaration coexistence in both load orders, Loader v18 discovery, and package parity. These checks ran after implementation in a standalone LuaJIT host and never accessed Helldivers 2. Live reads, archived late-load behavior and game coexistence remain unvalidated. See `build/bridge-checks.json` and [the audit](../HD2ModCore-HD2Runtime-audit-2026-09-28.md).

`core.Memory:WithReadScope(callback)` returns a Core Result whose value is a packed callback result (`n` preserves nil returns). It shares validated region information only during one synchronous main-thread callback. Each read still calls ReadProcessMemory; bytes, pointers and weapon identity are never cached. Nested scopes share the outer scope. Errors clear the cache, coroutine calls are rejected, and all build/lifecycle/read bounds still apply. This generic API helps any consumer performing related reads within one callback. It adds no writer or weapon-specific policy.

The Core infrastructure, facade read-scope checks, bridge checks and package checks pass offline. The held-weapon observer itself was independently validated read-only against idle Amendment/Peacemaker/AMR swaps and the requested mission-to-ship player transition; its implementation is unchanged. This does not validate deployed Core 0.3.2 callbacks or game coexistence with Runtime.

The separate selective FullAuto validation consumer uses this scope while retaining every identity/content check. Frozen input Core, Journal and Armory sources remain unchanged. Core contains no FullAuto whitelist or stable held-weapon service.
