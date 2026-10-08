# Offline release checks

For v1.2.0 run `python HD2FullAutoAssist/tests/run_release.py` from a full clone with Python and `lupa.luajit21`. This compiles the shipped bundle, checks all 31 supported defaults and unsupported exclusions, exercises all 21 menu choices and native restoration transitions, checks the HUD fixture, audits ZIP contents/defaults/resource identity, and verifies a deterministic rebuild against the exact Candidate D archive checksum.

The fixtures use simulated memory. They never open or launch the game and do not establish gameplay performance or live rendering behavior. Gameplay measurements in the release notes were supplied separately by the tester.

Older runners and fixtures remain for historical reference and are not the v1.2.0 release gate. No private profiling datasets or development logs are included.
