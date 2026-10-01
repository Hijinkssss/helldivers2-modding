# Offline tests

Run `python HD2FullAutoAssist/tests/run_standalone.py` from a full Git clone with
Python and `lupa.luajit21`. `run.py` and `run_weapon_policy_v2.py` forward to this
same suite. Package checks follow building, as described in the mod README.
It covers Arsenal-over-INI precedence and every profile-to-policy cadence. Run
`test_package.py --loader-discovery <discover.lua>` to verify the core and option
archives against Bingus Shared Loader's actual addon scanner.

Legacy Lua fixtures are retained to replay reference commit a93008f, not as
independent current-version runners. Runtime bridge fault fixtures describe the
old dependency and run against that preserved version only. New standalone
controller and native lifecycle checks require no installed game or Runtime.

The B2 native-transition fixture connects the real lifecycle, guarded identity,
controller, policy and native mapping backend over synthetic byte memory. It
covers all 31 assisted resources in both modes and every selectable profile,
active A/B/C swaps, unsupported transitions, hash/entity/root changes, transient
identity page/read failure, ship/mission and death/new-avatar respawn. Page-scope
checks reject different and crossing addresses and verify error cleanup.
Eruptor and Crossbow must pass through native `begin`, not a permissive mock.

Research RC2 adds `test_charge_probe.lua`, run by both standalone and next-version
suites. It verifies selected charge/trigger/beam/ammo observations, generation
tokens, relocation, missing-table backoff, scope, zero writes, sample bounds and
logger failure/cleanup. Run `test_probe_loader.py --loader-source <shared_loader.lua>`
to exercise the actual Shared Loader logging implementation. RC1's `.jsonl`
filename must be rejected before file operations; RC2's `.log` must be accepted.
Run `run_next_version.py` for exact ordinary native-work parity with v1.0.1.

Research RC3 targets only Accelerator `30061f91af477f5e` and Meltagun
`6cfcc7f8801a0266`. `test_charge_probe_targets.lua` exercises actual observer and
recorder recognition for both, and verifies Arc/Purifier/Loyalist, conventional,
and unknown resources consume zero probe reads or samples. Both suites run it.

RC2 adds `test_rc2.lua`: legacy config and Arsenal migration, guarded Commando hold/release/swap/OFF/ship handling, HUD classification, multi-world GUI selection, explicit visibility, bounded diagnostics and opt-in force-probe/fault isolation. B3 enumerates all 31 identities plus every selectable profile (81 native threshold cases). These remain offline tests; no GUI fixture proves in-game pixels or accepted rockets.
