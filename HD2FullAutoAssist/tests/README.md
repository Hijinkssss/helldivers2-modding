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
