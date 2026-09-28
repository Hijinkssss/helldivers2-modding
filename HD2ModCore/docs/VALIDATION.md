# Validation scope

This preview preserves behavior from local development tested on Steam build 25480438 with Loader v18 / API 1. Public packages are rebuilt with new version labels and portable packaging; those newly labeled ZIP bytes have not been deployed in-game. Source parity is checked separately from offline package validation.

| Area | Observed evidence | Limit |
| --- | --- | --- |
| Foundation lifecycle/config/logging/scheduler/events | Isolated LuaJIT regression plus clean ship/menu initialization and shutdown | No universal mod ordering or hot-unload guarantee |
| v0.2 diagnostic observer | Ship and a D1 mission recorded copied IDs and clean cleanup | Exact held item/idle/camera meanings unvalidated |
| Snapshot-scoped cache | Ship callback mean 5.77 ms before, 1.19 ms after; no errors; clean shutdown | Observer workload measurement, not full-frame/mission performance |
| Journal | Ship session ~136 s, 60/120 s heartbeats, normal shutdown, zero remaining tasks/events | No gameplay feature |
| Keyboard input / Armory | Ship press/hold, no repeat while held, normal Alt-tab, Social refusal; no perceived slowdown | Exact held-key refocus sequence was not separately described by the user |
| Text eligibility / Armory | Active chat receiver blocked F10 while cursor/menu looked idle; after closing chat, normal F10 opened Armory | Ship chat only; other text fields/layouts/transitions untested |
| Final cleanup | Core stopped; zero owned input/scheduler/event subscriptions and failures; Armory disabled after testing | Preserved prior records, no new live test for publication |
| Vanilla Plus | Earlier foundation ship coexistence; v31-to-v32 source delta found no meaningful contract incompatibility | Not a new v32 live coexistence run of this preview |

Original input timing: 12,108 updates, 12.85 microseconds mean, 12.15 ms maximum including action work. This cannot be interpreted as an idle-only cost or overall frame-rate improvement. The original cursor/menu-only chat guard failed; receiver presence superseded it after targeted fixtures and ship observations.

Historical final live Core archive SHA-256: `C224307218579672F0FDD4EE263DBB8C86AACA6ADD72659F39F1948012457BF8`. Armory: `B174C59C95B9D47F32B62FA7DAFA52ECCA26F6ADBD9106932D4B1C7CB3D45E30`. These identify preserved internal validation artifacts, not the renamed preview ZIP. Raw captures, logs and profile snapshots are intentionally not published.

Publication checks cover all Lua fixtures, exact bundle initialization/update/shutdown, require ordering, Windows adapter/hash smoke checks, Loader v18 discovery, independent consumer fixtures, template cleanup, source parity, deterministic packaging, ZIP contents/checksums, and sanitization. See the release assets' SHA256SUMS for new package identity. No game launch or manager change is part of publication preparation.
