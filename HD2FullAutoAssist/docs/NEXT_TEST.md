# Next test: selective Peacemaker validation

Identity proof is complete for the observed states. The new packages have not been imported or deployed. Exit Helldivers 2 before changing packages.

In the existing Arsenal test profile, import:

1. `../../HD2ModCore-runtime-candidate/build/HD2ModCore-v0.3.2-Runtime-Candidate-Arsenal.zip`.
2. The supplied `C:\Users\Law\Downloads\HD2Runtime-0.24.0-runtime.zip`.
3. `../build/HD2FullAutoAssist-v0.1-Selective-Peacemaker-Validation-Arsenal.zip`.

Enable one Core (0.3.2), HD2Runtime, the selective Peacemaker validation consumer, and Shared Loader v18. Disable the old Core/universal consumer if they remain as separate entries. Leave state probe, Journal and Armory disabled. Preserve the Loader's correct priority placement; the previous profile placed it last. Deploy after imports and confirm the displayed names before launching.

Retain Amendment, Peacemaker and AMR for the first narrow rerun. Peacemaker alone should gain assistance. Amendment and AMR remain vanilla. Do not change weapon stats or use another mod that changes Peacemaker trigger behavior in this validation profile.

After startup/log verification, perform the prompted short checks: hold/release Peacemaker Fire, toggle OFF/ON with F8, and swap from an active Peacemaker hold to Amendment/AMR. The lease must terminate for these unsupported weapons while the global toggle remains ON. Enabling or returning to an eligible weapon while Fire remains held requires a fresh release; this deliberate guard prevents surprise restart. Check chat/menu/focus guards and no stuck input, then exit cleanly so counters are logged.

Default is the retained provisional 125 ms interval. A slower `repeat_ms` of 200 can be selected for conservative testing; the correct cadence is not yet established. These are input attempts, not guaranteed shot rates. `debug_logging=true` in the consumer's existing INI records identity/lease transitions; shutdown always records counters. No config has been overwritten by this preparation.

Do not run a broad matrix yet. After this consumer works and callback cost is measured, add only explicitly validated ASSIST entries and the representative native-auto/mixed/charge tests. HUD follows stable selective behavior and must read `get_state()`.
