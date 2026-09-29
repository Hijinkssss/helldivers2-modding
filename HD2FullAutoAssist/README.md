# Full Auto Assist

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

The existing runtime, Talon Balanced at 210 RPM, and compatibility with the user's
personal modpack passed earlier live testing. This 1.0.0-RC7 candidate fixes
startup release-gate reconciliation and includes the RC6 20-weapon expansion
from pinned build metadata. Newly added weapon behavior still requires
the checks in [NEXT_TEST.md](docs/NEXT_TEST.md).

Full Auto Assist starts ON. `=` toggles assistance by default; the optional Mod
Bindings Menu can register a persistent rebindable action and takes precedence
after successful registration.

## Install

1. Close the game. Install one copy of Bingus Shared Loader v18 / API 1.
2. Import `Full-Auto-Assist-1.0.0-RC7-Arsenal.zip` into Arsenal.
   Replace the older Full Auto Assist entry; enable only one copy of this mod.
3. Enable the standalone option and the loader. Give the loader winning startup
   priority as described in its instructions, then Purge / Deploy.
4. If Full Auto Assist was your only reason to install Core or Runtime, disable
   those entries for the standalone follow-up. Other mods may still need them.
5. Use Arsenal's **Change Active Options** for the normal configuration path.
   Each weapon group offers mutually exclusive profiles and starts at Balanced.
   The INI remains for advanced/fallback settings. Copy
   `HD2FullAutoAssist.example.ini` to
   `%LOCALAPPDATA%/CowboyBingus/Helldivers2/HD2FullAutoAssist.ini` and restart
   after editing. Startup defaults to ON with `=` and Balanced policy.
   The Mod Bindings Menu API cannot set a custom first-use key; its reserved
   third-party action supplies the native action's initial default.
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
| LAS-58 Talon | **210, estimated 8 shots to overheat** | 750 |
| APW-1 Anti-Materiel Rifle | **120** | 400 |
| R-2124 Constitution | 60 | 60 |
| R-6 Deadeye | 100 | 100 |
| R-4 Hyena | **120** | 190 |
| R-72 Censor | 380 | 400 |
| SG-8 Punisher | 80 | 80 |
| SG-8S Slugger | 80 | 80 |
| SG-20 Halt | 80 | 80 |
| SG-451 Cookout | 80 | 80 |
| M90A Shotgun | 80 | 80 |
| SG-225IE Breaker Incendiary | 300 | 300 |
| CB-9 Crossbow | 50 | 50 |
| R-36 Eruptor | 32 | 32 |
| SG-8P Punisher Plasma | 80 | 80 |
| R/40-K Hot Shot Marksman Rifle | 210 | 210 |
| JAR-5 Dominator | 250 | 250 |
| P-4 Senator | 200 | 200 |
| P-11 Stim Pistol | 70 | 70 |
| SG-22 Bushwhacker | **90** | 650 |
| P-35 Re-Educator | 110 | 110 |
| P/40-K Bolt Pistol | 150 | 150 |

These values set input-attempt intervals, not guaranteed measured shot rates.
Verdict/Diligence caps come from reviewed current-build Runtime snapshot data;
reference Balanced play passed, but this does not establish every Native Cap rate.
Liberator is ignored, Quasar's charge/hold stays vanilla, and Laser Cannon's
ambiguous resources remain unmapped/vanilla. All unlisted or invalid resources
fail closed. ARC-12 Blitzer remains unsupported because it has native Full Auto.
Other expansion values are pinned snapshot RPM metadata; live accepted cadence
and exact in-game fire behavior remain unverified.

## Cadence and limitations

Arsenal exposes only the outliers: Peacemaker, SOCOM, Veto, Talon, AMR, Hyena
and Bushwhacker. Hyena offers Balanced 120 / Full Auto 190 RPM. Bushwhacker
offers Balanced 90 / Full Auto 650 RPM. Existing profile values are preserved;
other supported weapons use `min(native cap, 380 RPM)` automatically.
These are input-attempt cadences, not guaranteed shot rates. No weapon statistics
are changed.

Configuration precedence is **selected Arsenal profile**, then an explicit
per-weapon INI profile when no Arsenal choice is present, then the legacy INI
`fire_rate_mode` / `talon_mode`, then the built-in Balanced policy. Arsenal
options are compiled as separate option archives following the Aggro Counter
pattern and write into the existing policy's profile table. They do not add a
second runtime policy.

`fire_rate_mode=native_cap` remains available in the advanced INI. Talon retains
its selected profile. `repeat_ms=0` selects the resulting policy interval.
A positive integer up to 1000 only slows input: `max(repeat_ms/1000, 60/policy_rpm)`.
For example, an old `repeat_ms=125` limits Native Cap to 480 input attempts/minute.
Unknown, duplicate or malformed configuration entries disable startup.

The reviewed snapshot records 100 heat capacity, 15 heat per shot and 10 cooling
per second. At 210 RPM, seven intervals before shot eight allow about 20 heat
to cool: `8*15 - 7*(60/210)*10 = 100`. This predicts the eighth shot reaches the
overheat threshold if cooling is linear during firing. The Talon heat system may
be nonlinear or state-dependent, so gameplay is authoritative. See [Talon evidence](docs/talon-heat-evidence.json).
Live gameplay remains required. Native Cap retains the full-speed option.

**Amendment v0.1 limitation:** held Fire continuously chains legal bursts into
full-auto-like output. The game still controls burst internals. No special burst
gap or burst-mode logic was added.

AMR Balanced remains the live-tested 120 RPM. Its Arsenal Full Auto profile uses
the verified native 400 RPM cap. No Recenter mode is included.

The configured toggle changes the session state, which survives weapon swaps but is not written
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

Output: `HD2FullAutoAssist/build/Full-Auto-Assist-1.0.0-RC7-Arsenal.zip`.
The builder owns resource encoding, writes the supplied artwork as `thumbnail.png`,
and creates one required core option plus seven Aggro Counter-style profile groups.
[Dependency audit](docs/DEPENDENCIES.md) and [validation boundaries](docs/VALIDATION.md)
describe exactly what was extracted, preserved and verified.
