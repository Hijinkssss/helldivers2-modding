# Remaining validation and release gates

Eruptor OFF repetition is expected native behavior, confirmed by the user's fresh verified no-mod vanilla test. Do not request another OFF-bug investigation. The RC3 HUD is approved; its renderer and visual rules are frozen.

## Short ordinary-weapon regression

When testing is separately authorized, use a fresh session and one FAA core. Check Eruptor 27/28/32 RPM, default 28. OFF must relinquish FAA control; continued native Eruptor repetition is correct. Check a true manual/semi weapon OFF/ON, Commando both profiles and guidance, AMR SPECIAL, release, held swaps, supported-to-unsupported, re-equip and respawn. Unsupported hides the glyph; supported OFF is opaque white; ON is the approved yellow. Gap, position, scale and cartridge shape must remain identical.

## Performance evidence

The user's current RC3 baseline is approximately 50 ms/s. It supersedes the earlier 14 ms spike. No profile in the available RC3 log attributes that session's cost.

For attribution, enable only `performance_profile=true`, choose an identifying `performance_label`, and keep validation/debug/HUD diagnostics OFF. Existing metrics cover callbacks, identity, policy, native Fire, memory query/read counts and logging; new `hud_anchor` timing and read/node counts sit inside `hud_present`. Exit normally to emit the single in-memory profile summary. Nested phases must not be summed as independent costs.

For acceptance, use profiling OFF and match stack, settings, resolution, frame rate and scenarios between RC3 and the optimized source. Record Watchdog ms/s and worst at 30/60 seconds for ship idle, supported OFF, supported ON idle/held, unsupported, and swaps/backpack changes. Compare historical v1.0.1 only with the same stack and account for its absent HUD. No test-process benchmark establishes in-game improvement or FPS gains.

## Charge evidence

All five intended charge candidates remain gated. Four share an unvalidated input-only release/re-press adapter and bound-ready/next-cycle evidence gap; Accelerator also needs burst-completion/empty denial proof. Meltagun's RC5 full 1,024-entry table scan still finds no held-entity key, so beam completion cannot be inferred. Trace the actual beam owner/consumer offline before requesting another beam capture. Do not repeat the same absent-row probe, guess another entity, use plateau timers or write weapon state. See REMAINING_WEAPON_AUDIT.md.

No deployment, game launch, merge, push, publication or Nexus edit is part of this checkpoint. The final private RC is withheld until all release criteria are met.
