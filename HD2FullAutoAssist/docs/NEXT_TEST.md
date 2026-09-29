# V4 RC4 focused live follow-up

RC3 runtime behavior passed user-reported live testing, including the Talon
Balanced profile and the user's personal modpack. RC4 changes Arsenal branding,
artwork, and profile selection packaging. This is the remaining UI/configuration
gate; broad weapon regression testing is not required unless a focused check
shows an unexpected runtime change.

1. Import and deploy `Full-Auto-Assist-V4-RC4-Arsenal.zip`. Confirm Arsenal shows
   `Full Auto Assist V4`, the concise description, and the supplied square logo.
2. Open **Change Active Options**. Confirm exactly five expandable profile groups:
   Peacemaker, SOCOM, Veto, Talon, and AMR. Verify the displayed profiles,
   descriptions, and Balanced defaults.
3. Change one profile, confirm, redeploy, and confirm the selection persists.
   Check actual cadence on that weapon. The selected profile should map to the
   policy values in this table; RPM values are Fire-input attempts, not promised
   accepted shot rates.

   | Weapon | Balanced | Other selections |
   |---|---:|---|
   | P-2 Peacemaker | 380 | Full Auto 900 |
   | M6C/SOCOM Pistol | 380 | Full Auto 900 |
   | P-69 Veto | 380 | Full Auto 750 |
   | LAS-58 Talon | 210 | Efficiency 60; Full Auto 380; FULLER AUTO 750 |
   | APW-1 Anti-Materiel Rifle | 120 | Full Auto 400 |

4. Confirm startup is ON and `=` toggles OFF then ON. If Mod Bindings Menu is
   installed, confirm its action still takes precedence after registration;
   otherwise verify the standalone `=` fallback.
5. Briefly hold and release Fire at the changed profile, and confirm assistance
   stops on release. Check native full-auto, charge/hold, unsupported weapons,
   and the existing personal modpack remain intact. Do not retune Talon Balanced.

The RC4 package and offline checks do not establish a live UI display or gameplay
result. Record any visible option, persistence, or cadence discrepancy before
making a follow-up change.
