# HD2ModTemplate

Minimal independent consumer requiring HD2ModCore v0.3.0-dev / API 1 and Bingus Shared Loader v18 / API 1. Demonstrates optional INI config, logging, a synthetic snapshot event, one throttled scheduler task, F11 press subscription, fail-closed text/UI eligibility and owner cleanup. The hotkey only logs; there is no native game action. Offline fixture validation is not live game validation of a new consumer.

Adapt `src/template.lua`. Change the owner, channel, config filename, module resource name and manager GUID before distributing your own mod. Require Core as an external dependency; never bundle its modules. Its MIT license is available at the root of the Core source repository and in the generated package.

Optional `HD2ModTemplate.ini` belongs under `%LOCALAPPDATA%/CowboyBingus/Helldivers2/`:

```ini
enabled=true
hotkey=F11
```

Build this directory with `python scripts/build.py`. It has its own package encoder and emits an ignored `build/HD2ModTemplate-v0.1.0-dev-Arsenal.zip`. Supply Core and Loader separately at runtime. Use Core's `python tests/test_template.py` after building Core to run the real-facade lifecycle/config/event/scheduler/input/eligibility/cleanup fixtures.

On unload, remove all three tokens or call `core:Unregister(owner)`. Register the unload handler before initialization, and unregister after any partial initialization failure. Eligibility errors and refusals consume the press immediately. Keep action policy in your consumer and require its own build/state validation before any future native action.
