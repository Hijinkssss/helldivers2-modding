# Standalone RC2: one focused live follow-up

Offline parity passes. This checklist is the remaining gameplay gate for the
standalone refactor, not a request to repeat full missions. No game launch,
installation, deployment or live process access occurred in this task.

1. With the game closed, replace the older Full Auto Assist package. For this
   isolated check, enable only Shared Loader and standalone Full Auto Assist.
   Core and Runtime should be disabled. Use the validation INI: startup OFF,
   Balanced, repeat_ms=0. Confirm the loader reports the addon loaded and the
   mod log reports the exact supported build without startup errors.
2. Start with Peacemaker on a safe mission area. F8 ON, release Fire once, hold
   then release. Check natural audio/animation and immediate cessation after
   release. F8 OFF during a hold must restore normal input; F8 ON must wait for
   release before assistance resumes.
3. Talon: start cool on the same planet and loadout used for the earlier test.
   Hold for a short volley and stop before destroying a heatsink. Check roughly
   one accepted shot per second and slower heat accumulation than 380 RPM.
   Record shot count, hold duration, heat level and planet temperature.
   If safe, compare one equal-length manual volley with F8 OFF. Do not call the
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
   Assistance must stop and require release. F8 in chat/menu must not toggle.
   Recheck ordinary unassisted Fire afterward; do not type sensitive text into
   a diagnostic session. The guard reads only receiver presence, never text.
7. Exit normally. Review shutdown for zero active lease, no stuck Fire, errors
   or unresolved restore conflicts. Review callback cost and both aggregate
   slow counts and warning lines. Local warnings retain first/every-100 logging.

If any step fails, release Fire, disable the mod and preserve the short failure
record. Stop the session for repair. Native Cap accepted-shot rates remain a
separate optional test; INI selection and mapping intervals pass offline. No
per-weapon UI, discovery or future-patch investigation is needed for this gate.
