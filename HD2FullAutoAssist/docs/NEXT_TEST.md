> Historical development record. Current release status and validation are in [RELEASE_1.0.1.md](RELEASE_1.0.1.md).

# Full Auto Assist 1.0 pre-release live validation

RC7 is pre-release. Offline checks establish controller and package behavior;
they do not prove live shot acceptance, reload independence, cadence feel,
audio/animation continuity or personal-modpack compatibility.

## Short gameplay pass

Use three mission entries so both ON and OFF persistence are observed:

1. With no explicit `user_enabled` override, start the game and enter Mission 1
   without pressing `=`. Confirm ON and firing on one existing known-good gun.
   In the same mission, test the 20 remaining expansion weapons listed in
   [weapon-candidate-matrix.md](weapon-candidate-matrix.md), swapping within
   each slot. The Warrant was live-tested separately in Guided and Unguided
   modes. Confirm each remaining weapon gets shots from held normal Fire
   without a reload input between shots. Include a charge/hold negative
   control and leave Blitzer untouched.
2. Test Hyena Balanced/Full Auto (120/190), Bushwhacker Balanced/Full Auto
   (90/650), Breaker Incendiary Semi/Burst and Dominator Semi/Burst. Do not
   change weapon modes through the mod. Release Fire after every hold and check
   that repetition stops immediately. Confirm reload never starts by itself.
   Exercise weapon swap, menu and focus guards while holding Fire.
3. Enter Mission 2 still ON and confirm startup-to-mission persistence. Toggle
   OFF with the Mod Bindings action, or `=`/`+` if registration is unavailable;
   confirm exactly one state change. Enter Mission 3 still OFF and verify no
   repeated Fire. Toggle back ON once. Confirm menu/focus/swap guards never
   change the preference, then confirm the existing personal modpack works.

For Arsenal, confirm the seven profile groups, saved profile selection,
mutual exclusivity and artwork. Blitzer must remain vanilla because its native
mode is Full Auto. Do not publish v1.0.0 until this pass succeeds on the exact
supported build and current personal modpack.
