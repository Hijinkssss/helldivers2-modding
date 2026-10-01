# Full Auto Assist v1.1.0 RC2 release notes (unpublished)

RC2 fixes a HUD render-path blocker: RC1 refused every scene containing more than one non-main world. The renderer now uses the screen-GUI surface selection established by existing Loader HUD mods and explicitly makes the completed GUI visible. The original yellow three-cartridge geometry, normal position, scale and conditional visibility are preserved. RC1 was packaged and installed correctly; the installed archive matches RC1 exactly and Loader reported it loaded. The live world count and RC2 appearance still require confirmation.

Adds MLS-4X Commando through ordinary repeated Fire at the retained native 240 RPM input cadence. Projectile behavior, guidance, selector, reload, ammo, damage and all other mechanics remain game-controlled. The existing 30-weapon roster is retained, with Eruptor tuning as the sole cadence change.

Eruptor now offers exactly:

- 27 RPM - Slower Cadence
- 28 RPM - Balanced / default
- 32 RPM - Maximum Full Auto

The Arsenal default selection is listed first as Balanced 28 RPM. Old RC1 configuration selections migrate safely; the retired slow setting falls back to the new 28 RPM default. Legacy Balanced also migrates to 28, while existing selections for the remaining cadences retain their rates. Compatibility names are accepted only while parsing/discovering old settings, and are not selectable options.

Temporary RC2 HUD diagnostics write bounded records to HD2FullAutoAssist.log, including renderer creation, callback count, weapon identity, FAA eligibility, conditional visibility, screen coordinates, alpha and world selection. Set hud_diagnostics=false to disable. hud_probe_visible=false is the normal default; the optional true setting places the same glyph at screen center at 4x size to isolate the render path. It does not enable weapon assistance.

**Meltagun support is not included in v1.1.0. I am actively researching how to implement it for a later update.** Arc Thrower, Purifier, Loyalist and Accelerator also remain unassisted. The normal package includes no charge-research factories.

Requires Bingus Shared Loader v18 / API 1 and supported Steam build 25480438. Starts ON; use `=` or your registered binding to toggle. Unknown/native-auto weapons stay unassisted. No merge, push, publication, deployment or public-release modification was performed.

Offline regression and package checks do not establish live HUD visibility or accepted weapon cadence. See LIVE_TEST.md for the remaining acceptance checks.
