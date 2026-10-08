# Full Auto Assist v1.2.0

This release uses the validated Candidate D runtime, with no Candidate E changes.

- Adds the optional in-game Mod Options Menu integration: FAA Enabled plus nine weapon profile rows, covering all 21 existing named choices.
- Preserves the 31 supported weapon policies, existing HUD, `=` toggle synchronization, legacy INI/Arsenal configuration, saved profile meanings and Fire restoration safeguards.
- Uses Candidate D's bounded guarded-memory metadata hints and reduced input-eligibility allocations. Fresh-read checks, identity validation and Fire control remain intact.
- Ships a Core-only Arsenal package. Requires Bingus Shared Loader v18+ / API 1; Mod Options Menu v1.2 / API 1 is optional.
- Profiling and diagnostics remain OFF in the supplied example configuration. Charge weapons remain excluded.

RPM values control repeated Fire input cadence, not weapon statistics or guaranteed accepted shots.

Verified gameplay measurements supplied for Candidate D:

| Metric | Peacemaker | Full mission |
|---|---:|---:|
| Duration | 4 minutes | 12 minutes |
| Average | 7.7 ms/s | 7.9 ms/s |
| Worst minute | 12.0 ms/s | 12.7 ms/s |
| Worst frame | 3 ms | 3 ms |
| Stalls >=150 ms | 0 | 0 |

The full mission used AMR, Eruptor and Commando in Balanced mode. These results describe those sessions. FAA does not always stay below 10 ms/s and does not guarantee FPS improvements.

Update through Arsenal with one FAA runtime enabled. Preserve your existing INI and saved menu values; no settings reset is needed. Disable any separate private FAA candidate before deploying the public package. See README.md for installation, profile precedence and limitations.
