# Independent example consumers

The publication set contains three separate source repositories: HD2ModCore, HD2SessionJournal and HD2ArmoryHotkey. Each has its own history, MIT license, build, version and Arsenal ZIP. Core is required at runtime and never embedded in either consumer. Their public URLs will be linked here once repositories exist.

**HD2SessionJournal v0.1.0-dev:** lifecycle/config/logging/scheduler example that appends session start/end and optional minute heartbeats. Validated on a ship with clean shutdown. No native game access. Tested with Core v0.3.0-dev; Loader v18 / API 1.

**HD2ArmoryHotkey v0.1.0-dev:** provisional Input/ShortcutEligibility consumer with an exact-build native Armory presenter backend. F10 opens only; it does not close menus. Ship chat blocking, normal F10 and cleanup passed on 25480438. Mission/loading/alternate layouts/other text surfaces remain untested. Core v0.3.0-dev and Loader v18 / API 1 are required.

For the smallest source to adapt, use [HD2ModTemplate](../template/HD2ModTemplate/README.md).
