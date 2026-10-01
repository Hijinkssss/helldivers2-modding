# Full Auto Assist v1.1.0 private RC3 notes (unpublished)

Private RC3 continues the current RC2 lineage. It retains saved Fire originals across context/conflict failures, rejects failed restore transitions, keeps OFF's authoritative gate closed, and retries verified rollback with bounded errors. HUD OFF is opaque white; ON yellow/geometry is unchanged. Native panel extent replaces fixed screen placement. Persistent Eruptor OFF repetition is not yet proven solved: this is a diagnostic candidate, not a release-ready fix.

Adds MLS-4X Commando through ordinary repeated Fire, with Balanced at 120 RPM by default and Full Auto at the retained native 240 RPM ceiling. Its Arsenal group follows the AMR profile setup; the optional INI setting is `commando_profile=balanced|full_auto`, with Arsenal taking precedence. Projectile behavior, guidance, selector, reload, ammo, damage and all other mechanics remain game-controlled. The existing 30-weapon roster is retained, with Eruptor tuning as the sole cadence change.

Eruptor now offers exactly:

- 27 RPM - Slower Cadence
- 28 RPM - Balanced / default
- 32 RPM - Maximum Full Auto

The Arsenal default selection is listed first as Balanced 28 RPM. Old RC1 configuration selections migrate safely; the retired slow setting falls back to the new 28 RPM default. Legacy Balanced also migrates to 28, while existing selections for the remaining cadences retain their rates. Compatibility names are accepted only while parsing/discovering old settings, and are not selectable options.

HUD diagnostics now default OFF. A separate short-run diagnostic INI enables read-only native mapping/state audits and profiling. Audit snapshots are capped at 96; native level-input trace records are deduplicated while timed pulses remain recorded. Synchronous trace and ordinary event logging can affect diagnostic timings. The 14 ms live spike remains unattributed; hud_present and existing log/callback/init metrics support the next measurement.

**Meltagun support is not included in v1.1.0. I am actively researching how to implement it for a later update.** Arc Thrower, Purifier, Loyalist and Accelerator also remain unassisted. The normal package includes no charge-research factories.

Requires Bingus Shared Loader v18 / API 1 and supported Steam build 25480438. Starts ON; use `=` or your registered binding to toggle. Unknown/native-auto weapons stay unassisted. No merge, push, publication, deployment or public-release modification was performed.

Offline regression and package checks do not establish live HUD visibility or accepted weapon cadence. See LIVE_TEST.md for the remaining acceptance checks.
