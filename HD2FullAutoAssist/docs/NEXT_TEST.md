# Full Auto Assist 1.0 pre-release live validation

The 1.0 release remains blocked on reproducing and fixing default-ON mission
startup, exact-build evidence for the requested roster, and a fresh live pass.
The current local validation setup is explicitly marked test-only and has
`enabled=true`, `user_enabled=false`, plus the F8 test binding. Its startup log
records `active=false`, followed by a manual toggle to ON. This accounts for
that run starting OFF; it does not reproduce a default-ON mission-entry failure.
The standard example config and absent-INI defaults both set `user_enabled=true`.

## Short live sequence after a corrected package is built

1. With default config and no toggle press, enter a mission; hold Fire with a
   known eligible weapon and confirm immediate assistance.
2. Toggle OFF and ON using the registered Mod Bindings Menu binding, if present;
   otherwise use `=` / `+`. Confirm native binding precedence after registration.
3. Check one existing known-good weapon, then each newly approved weapon once.
   Group them by loadout and swap weapons within one mission where practical.
4. Confirm Double Freedom remains untouched and SG-97 Sweeper remains native
   Full Auto.
5. Check one charge/hold negative control; release Fire and confirm assistance
   stops immediately.
6. Swap weapons, open a menu, and change focus while holding Fire; confirm the
   safety guard prevents stuck Fire and requires release before resuming.
7. Confirm the personal modpack still works.
8. Check Arsenal branding, the five existing profile groups, one saved profile
   change, and artwork. Preserve the Peacemaker, SOCOM, Veto, Talon, and AMR
   profile values listed in the README.

The candidate matrix lists requested weapons that are still deferred because
the checked-in exact-build evidence does not establish their identity, fire
modes, reload/charge behavior, and accepted cadence. Do not claim or test them
as supported until those records are added and policy tests cover them.
