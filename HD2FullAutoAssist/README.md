# HD2 Full Auto Assist v0.1.3 Standalone RC2

An accessibility/QoL mod that repeats normal Fire while you hold Fire on a small,
explicitly reviewed set of weapons. The game decides whether each shot or burst
is accepted. It changes no damage, recoil, ammo or projectiles and automates no
reloads, aiming or recoil compensation.

**Only external dependency: [Bingus Shared Loader v18 / API 1](https://github.com/CowboyBingus/BingusSharedLoader/releases).**
End users do not need HD2ModCore, HD2Runtime, Python or Lua tools. Neither framework
is bundled. This candidate supports **Steam build 25480438** with exact EXE and
game.dll fingerprints. Other builds refuse startup. Future patch support is
planned, and is not provided by this version.

## Current status

- Standalone current-patch RC2; offline checks pass.
- Reference implementation passed user-reported Balanced gameplay on the weapons
  below, except the new Talon cadence. Native-auto/charge negative controls passed.
- The standalone refactor still needs the focused live follow-up in
  [NEXT_TEST.md](docs/NEXT_TEST.md). It has not been deployed or played in this task.
- No HUD or per-weapon options UI is included. F8 toggles assistance during play.

## Install

1. Close the game. Install one copy of Bingus Shared Loader v18 / API 1.
2. Import `HD2FullAutoAssist-v0.1.3-Standalone-RC2-Arsenal.zip` into Arsenal.
   Replace the older Full Auto Assist entry; enable only one copy of this mod.
3. Enable the standalone option and the loader. Give the loader winning startup
   priority as described in its instructions, then Purge / Deploy.
4. If Full Auto Assist was your only reason to install Core or Runtime, disable
   those entries for the standalone follow-up. Other mods may still need them.
5. To configure the mod, copy `HD2FullAutoAssist.example.ini` to
   `%LOCALAPPDATA%/CowboyBingus/Helldivers2/HD2FullAutoAssist.ini`. Restart the game
   after editing. No INI selects the normal defaults: ON, F8, Balanced.
   The validation INI starts OFF and enables local diagnostic records.

Build output is a candidate, not a claimed completed gameplay release. Importing
and deploying remain separate actions; this task did neither.

## Supported weapons

| Weapon | Balanced RPM | Native Cap RPM |
|---|---:|---:|
| P-2 Peacemaker | 380 | 900 |
| P-113 Verdict | 380 | 450 |
| M6C/SOCOM Pistol | 380 | 900 |
| P-69 Veto | 380 | 750 |
| R-63 Diligence | 350 | 350 |
| R-63CS Diligence Counter Sniper | 350 | 350 |
| R-2 Amendment | 380 | 480 |
| LAS-58 Talon | **60, follow-up pending** | 750 |
| APW-1 Anti-Materiel Rifle | **120** | 400 |

These values set input-attempt intervals, not guaranteed measured shot rates.
Verdict/Diligence caps come from reviewed current-build Runtime snapshot data;
reference Balanced play passed, but this does not establish every Native Cap rate.
Liberator is ignored, Quasar's charge/hold stays vanilla, and Laser Cannon's
ambiguous resources remain unmapped/vanilla. All unlisted or invalid resources
fail closed. The supported weapon set is unchanged from the reference.

## Cadence and limitations

`fire_rate_mode=balanced` uses a 380 RPM ceiling, AMR's 120 RPM override and
Talon's 60 RPM override. `fire_rate_mode=native_cap` uses each listed native cap,
including Talon 750 and AMR 400. `repeat_ms=0` selects that policy interval.
A positive integer up to 1000 only slows input: `max(repeat_ms/1000, 60/policy_rpm)`.
For example, an old `repeat_ms=125` limits Native Cap to 480 input attempts/minute.
Unknown, duplicate or malformed configuration entries disable startup.

Talon's old 380 RPM default overheated too quickly in the user's live test.
RC2 uses one attempt per second to favor battery efficiency over burst DPS.
The reviewed snapshot records 100 heat capacity, 15 heat per shot and 10 cooling
per second. That supports a lower cadence but does not prove continuous cooling
while firing, environmental modifiers or heat-neutral operation. This candidate
can still overheat. See [RC2 notes](docs/RC2_NOTES.md) for the conditional model
and one short live test. Native Cap retains the full-speed option.

**Amendment v0.1 limitation:** held Fire continuously chains legal bursts into
full-auto-like output. The game still controls burst internals. No special burst
gap or burst-mode logic was added.

AMR Balanced remains the user-tested 120 RPM. Future optional per-weapon modes:
Recenter (recoil recovery friendly), Balanced (120), FULLER AUTO (native 400).
Native Cap already selects 400 through the INI; a per-weapon UI is deferred.

F8 changes the session toggle, which survives weapon swaps but is not written
back to the INI. Toggle, weapon/entity/player changes, chat, menus, lost focus,
invalid identities and read failures restore assistance and require Fire release
before restarting. Release restores the original button mappings on the next
observed update. Axis mappings remain vanilla. User binding edits are preserved.
Partially written mappings retain rollback state; failed cleanup keeps a retry
path while updates remain available. Brief windows between updates are unmeasured.

This is an explicit current-build table. It does not discover weapons or inspect
the current R-menu fire mode. Using other mods that change these weapons' fire
semantics is outside the tested scope. Native mapping anchors and exact build
fingerprints remain mandatory.

## Build and verify

For developers, Python with `lupa.luajit21` and Git is needed for offline checks.
The full clone includes Core solely for reference comparison tests; the package
and its builder have no Core/Runtime dependency.

```text
python HD2FullAutoAssist/tests/run_standalone.py
python HD2FullAutoAssist/scripts/build.py
python HD2FullAutoAssist/tests/test_package.py --loader-discovery <BingusSharedLoader-v18/src/discover.lua>
```

Output: `HD2FullAutoAssist/build/HD2FullAutoAssist-v0.1.3-Standalone-RC2-Arsenal.zip`.
The builder owns the resource encoding and bundles only mod-specific helpers.
It creates one Arsenal option with the retained addon GUID.
[Dependency audit](docs/DEPENDENCIES.md) and [validation boundaries](docs/VALIDATION.md)
describe exactly what was extracted, preserved and verified.
