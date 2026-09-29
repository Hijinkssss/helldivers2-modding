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
covers all 30 assisted resources in both modes and every selectable profile,
active A/B/C swaps, unsupported transitions, hash/entity/root changes, transient
identity page/read failure, ship/mission and death/new-avatar respawn. Page-scope
checks reject different and crossing addresses and verify error cleanup.
Eruptor and Crossbow must pass through native `begin`, not a permissive mock.
