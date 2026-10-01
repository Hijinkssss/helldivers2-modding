# Private RC3 live validation

Persistent Eruptor OFF repetition remains unresolved. This candidate fixes a reproduced ownership-loss defect and captures the evidence needed to identify the live cause. Do not treat it as release ready.

1. With the game closed, preserve the prior candidate and INI. Select only this candidate's core and Eruptor Balanced 28 option. Keep the existing mod stack. Do not load two FAA cores. Keep Commando selections unchanged. The package retains all 31 supported identities and existing Arsenal options.
2. For the first short diagnostic run, use the included `OFF-STATE-DIAGNOSTIC.ini` as `%LOCALAPPDATA%\CowboyBingus\Helldivers2\HD2FullAutoAssist.ini`. This is a manual test configuration, not automatic deployment. It enables validation/profiling, not the old enlarged HUD probe. Start a fresh game session, enter gameplay with Eruptor, and begin the sequence promptly; mapping audits are capped at 96.
3. ON: hold Fire for three successive shots. Confirm approximately 28 RPM and yellow cartridges. Fully release Fire, toggle OFF, wait, then make a fresh hold for three expected firing cycles. Record whether it still repeats at approximately 32 RPM. Supported OFF should show opaque white at the same position.
4. Toggle ON while holding, then release and press again. Re-enabling intentionally requires physical release before another FAA lease. Repeat ON to OFF while holding. Record whether a new shot occurs after OFF, separately from animation/audio already in progress.
5. Exit normally so buffered summaries close. Preserve `Logs\HD2FullAutoAssist.log` and `Logs\HD2FullAutoAssistValidation.jsonl` under the same LOCALAPPDATA folder. Return both logs and the observed ON/OFF firing result. The trace overwrites its previous validation file on each launch, so preserve it before another run. Do not infer shots from `fire_observed`; it records native input, not accepted shots.

After that short diagnostic run, restore the ordinary diagnostics-off INI. In a separate run:

- Test all Eruptor options, 27 slower / 28 default / 32 maximum. No retired option should appear.
- Swap while ON and while OFF: Eruptor to supported sidearm to Eruptor, and Eruptor to unsupported/native-auto weapon to Eruptor. Held swaps require release before reacquisition. Check respawn/mission transition and re-equip for stale assist state.
- Recheck Commando Balanced 120/Full Auto 240 and AMR Balanced 120/Full Auto 400; no profile or SPECIAL eligibility change was made.
- HUD: yellow ON, opaque white OFF at identical coordinates, unsupported hidden. Without backpack, with backpack, and while equipping/unequipping or swapping weapons, confirm a small gap after the native HUD's right edge and ammo-row vertical alignment. Check usual HUD scale, aspect ratio, fading and animations. Capture the offending layout if anything overlaps or flickers.
- Watchdog: record idle, repeated firing, toggles, swaps, first Eruptor activation and backpack/HUD transitions separately. Record worst single-call spike and sustained ms/s. Diagnostic-run timings include audit and disk-I/O overhead; compare production using validation/profiling/HUD diagnostics OFF.

Do not accept the candidate until fresh OFF holds behave like the never-initialized FAA baseline. If `restore_failed` or pending ownership appears, preserve logs and stop testing that session. The candidate retains originals and will retry only through verified context; restart if it cannot recover. No merge, push, publication or deployment is performed by the agent.
