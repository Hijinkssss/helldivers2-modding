# HD2ModCore Developer Preview

HD2ModCore provides QoL, accessibility, input and consumer services for Helldivers 2 mods using Bingus Shared Loader. It gives independent consumers lifecycle and cleanup, configuration, structured logging, scheduling, snapshot events, keyboard edges and guarded shortcut eligibility.

Core focuses on consumer behavior and input safety. [SkyeShade/HD2Runtime](https://github.com/SkyeShade/HD2Runtime) supplies semantic gameplay definitions, resource ownership and guarded authoring. Weapon, entity, stratagem, projectile, damage and stat authoring belong in that layer. Core does not provide a competing gameplay writer or generated gameplay SDK.

First public preview: **v0.3.0-dev**, facade **API 1**. Tested runtime: **Windows x64, Steam build 25480438 / EXE 1.8.46015.0, Bingus Shared Loader v18 / API 1**. This is a pre-1.0 Developer Preview with deliberately limited game integration.

## Install and depend on Core

Supply [Bingus Shared Loader](https://github.com/CowboyBingus/BingusSharedLoader) v18 / API 1 separately; it is required. HD2Runtime is optional for simple Core consumers, including Journal and Armory. A consumer that uses HD2Runtime must declare and install its own runtime dependency separately. Core does not bundle HD2Runtime or replace its build guards. Import the Core Arsenal ZIP, enable Core and Loader, and deploy with Loader as the winning startup replacement. Enable only one Core version. Restart the game after changing packages. The Core ZIP contains only our plaintext resource and empty manager companion files; it does not include a loader, game DLL or stock script. Manual merging/renumbering of patch archives is outside this preview's instructions.

Consumers require `mods/codex/hd2_mod_core`, check `core.api == 1`, and feature-check any provisional extension. `mods/codex` is the retained loader resource namespace, not a local workspace path. Load order is safe for Core-first or consumer-first `require`; consumer packages must not embed another Core.

```lua
local core = assert(require('mods/codex/hd2_mod_core'))
assert(core.api == 1 and core.Hooks and core.Config and core.Logger)
local owner, task = 'my_mod', nil
local function must(r)
    assert(r and r.ok, r and r.error and r.error.detail or 'Core failure')
    return r.value
end
must(core:OnUnload(owner, function()
    if task then core.Hooks:Remove(task); task = nil end
end))
local loaded = core:OnLoad(owner, function()
    must(core.Config:Register(owner, {enabled={type='boolean',default=true}}))
    local settings = must(core.Config:Load(owner, '')) -- consumer supplies INI text
    if not settings.enabled then return end
    task = must(core.Hooks:Subscribe(owner, 'after_update',
        {every_ms=1000,budget_us=500}, function()
            core.Logger:Emit('info',owner,'heartbeat',{})
        end))
end)
if not loaded.ok then core:Unregister(owner); error(loaded.error.detail) end
-- Explicit removal: core:Unregister(owner). Game shutdown also runs owner cleanup.
```

## What is ready, and what is limited

Lifecycle/config/logging/scheduler/generic events have validated infrastructure contracts. Keyboard edges and the on-demand shortcut guard are provisional. Build profiles, symbols, memory reads and `Diagnostic:LocalAvatar()` remain experimental or build-specific. The profile intentionally retains `source_only` evidence and Core can report `degraded` even on the tested build; that is not a blanket startup failure. Generic services can still run on an unsupported build, while build-dependent reads and eligibility refuse it.

The shortcut guard blocks active text entry, lost focus, visible UI cursor or busy menu state. It reads receiver presence, never typed text. Live chat coverage is the ship chat editor on the exact tested build. Other text-entry surfaces, alternate ship layouts and loading transitions are untested. Raw keyboard subscriptions do not automatically apply this guard. Consumers must require `result.ok` and `result.value.allowed == true` before their action and consume a blocked edge without queueing it.

There is no public write/patch/native-call API, automatic gameplay event catalog, native detour system, controller binding system or reliable hot reload. Scheduler budgets are soft; consumer callbacks must remain small. A hash match alone does not prove object semantics. See [API and maturity](docs/API.md), [validation](docs/VALIDATION.md), [build profiles](profiles/README.md) and [architecture](docs/ARCHITECTURE.md).

[HD2Runtime interoperability and scope](docs/HD2RUNTIME.md) describe the optional integration model. The v0.3.1 bridge is a separate local candidate, not part of this v0.3.0 preview's API promise or a claim of live coexistence. See the [revised roadmap](docs/ROADMAP.md).

## Build and test

Python 3.10+ builds with its standard library: `python scripts/build.py`. On Windows x64, install test dependencies with `python -m pip install -r requirements-test.txt`, then run `python tests/run.py`. This uses `lupa.luajit21`, not a system Lua interpreter. Build first. Optional `--runtime-path <directory>` uses an existing Lupa install; `--loader-source <checkout>/src/discover.lua` runs real Loader v18 discovery, and `--peer-adapter <windows_api.lua>` checks declaration order. Dependencies are supplied locally and not copied into releases.

Outputs appear in ignored `build/`: bundled plaintext Lua, single-resource patch, Arsenal ZIP, build report and `SHA256SUMS.txt`. Repeated builds produce the same ZIP with fixed member metadata. Source commits exclude generated packages and personal configuration.

## Template and independent examples

- [HD2ModTemplate](template/HD2ModTemplate/README.md): minimal consumer with config, logging, synthetic snapshot events, throttled scheduling, guarded keyboard input and owner cleanup. No native game action.
- [Example catalog](examples/README.md): HD2SessionJournal and HD2ArmoryHotkey are prepared as separate repositories and independent packages. Public repository links will be added after those repositories exist; this preview does not pretend they are already published.

See [changelog](CHANGELOG.md), [version policy](docs/VERSIONING.md), [contributor guide](CONTRIBUTING.md) and [provenance](THIRD_PARTY.md). Project code is MIT licensed. Helldivers 2 and separately installed dependencies retain their own rights.
