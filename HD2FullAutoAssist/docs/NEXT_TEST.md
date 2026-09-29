# Standalone RC3: compact live validation

Offline parity passes. This checklist is the remaining gameplay gate for the
standalone refactor, not a request to repeat full missions. No game launch,
installation, deployment or live process access occurred in this task.

1. Install the RC3 archive. With no INI present, confirm startup logs report
   Full Auto Assist ON. Check `=` turns it OFF, then ON again. Shift is not
   required. Keep Bingus Shared Loader as the only required dependency.
2. Start with Peacemaker on a safe mission area. With assist already ON, hold
   then release. Check natural audio/animation and immediate cessation after
   release. `=` OFF during a hold must restore normal input; `=` ON must wait for
   release before assistance resumes.
3. Talon: start cool and hold Fire with the default Balanced profile. Count shots
   until overheating (expected around eight), then repeat with Efficiency and
   confirm roughly 60 RPM. Change `talon_mode` to `full_auto` (380) and
   `fuller_auto` (750) between launches and verify continuous held fire.
   Record shot count, hold duration, heat level and planet temperature.
   If safe, compare one equal-length manual volley with assistance OFF. Do not call the
   cadence heat-neutral from a single test. Stop if the sink heats unexpectedly
   quickly. No heat/capacity/cooling values are modified by the mod.
4. Confirm one short AMR hold at the unchanged 120 RPM Balanced cadence. Check
   that Amendment still chains bursts, with normal game-controlled internals.
   Check brief hold/release on Verdict, SOCOM, Veto, Diligence and Diligence CS
   as available; prior reference results are preserved, standalone parity needs
   one confirmation for each before a broad compatibility claim.
5. Mix eligible weapons with Liberator, Quasar and Laser Cannon. Check native
   auto audio, normal Quasar charge/release, normal beam behavior, and no mapping
   lease/write for the controls. A held weapon swap must stop assistance and
   require release before restarting on another eligible weapon.
6. While holding Fire, open/close chat or a menu and switch focus out/back.
   Assistance must stop and require release. `=` in chat/menu must not toggle.
   Recheck ordinary unassisted Fire afterward; do not type sensitive text into
   a diagnostic session. The guard reads only receiver presence, never text.
7. If Mod Bindings Menu is installed, open MODS and rebind the action to `=`.
   Verify it toggles, persists after restart, and its previous key no longer
   toggles. Without the menu, `=` remains the fallback. Exit normally. Review
   shutdown for zero active lease, no stuck Fire, errors or unresolved restore
   conflicts. Review callback cost and both aggregate
   slow counts and warning lines. Local warnings retain first/every-100 logging.

If any step fails, release Fire, disable the mod and preserve the short failure
record. Stop the session for repair. Native Cap accepted-shot rates remain a
separate optional test; INI selection and mapping intervals pass offline. No
per-weapon UI, discovery or future-patch investigation is needed for this gate.
