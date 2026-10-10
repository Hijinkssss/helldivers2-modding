# Full Auto Assist 1.3.0

**NEW: In-game per-weapon settings!** Configure all 31 supported weapons directly in one **FULL AUTO ASSIST** menu. Each weapon starts enabled, with Balanced behavior where applicable.

Full Auto Assist is an accessibility-focused Helldivers 2 mod that simulates automatic firing by repeating normal Fire input while held. It does not change damage, ammunition, reload behavior or weapon statistics, and does not bypass native firing restrictions. Input cadence does not guarantee accepted shots.

## Installation

Choose one route for in-game settings and keybind configuration:

**Recommended convenience route:** install [Bingus Shared Loader](https://www.nexusmods.com/helldivers2/mods/16292) and [CB Vanilla Plus Megapack](https://www.nexusmods.com/helldivers2/mods/16294). Enable the Megapack's **Mod Options Menu** and **Mod Bindings Menu** components.

**Standalone route:** install [Bingus Shared Loader](https://www.nexusmods.com/helldivers2/mods/16292), [CB Mod Options Menu](https://www.nexusmods.com/helldivers2/mods/16625) and [CB Mod Bindings Menu](https://www.nexusmods.com/helldivers2/mods/16478).

Use either bundled or standalone copies of each menu component, not both. The whole Megapack is not mandatory. Current documented versions are Shared Loader **v19 / API 1** (v18+ supported), Mod Options Menu **v1.2 / API 1**, and Mod Bindings Menu **v2.2 / API 1**. These releases target Steam build **25480438**.

Then import `Full-Auto-Assist-1.3.0-Arsenal.zip` into Arsenal, enable **FULL AUTO ASSIST 1.3.0** and its single Core option, and deploy. Keep only one FAA runtime enabled. Preserve your existing settings; no reset is needed. Keep Shared Loader as the winning Wwise startup replacement.

**What each component provides:** Shared Loader is required for core FAA operation. Mod Options Menu is required for in-game weapon/profile configuration. Mod Bindings Menu is required for in-game keybind configuration. FAA's core firing and existing fallback configuration still work without either menu. None of these companion mods is bundled in FAA's ZIP.

## Configure in-game

1. Launch Helldivers 2 after installing and deploying FAA and the menu components.
2. Open the game's **MODS** settings tab.
3. Select **FULL AUTO ASSIST**.
4. Set **FAA Enabled** and the individual weapon selectors, then press **Apply**.

The single menu contains 32 settings: one global toggle and 31 weapon selectors, grouped Primary → Secondary → Support with two visual separators. Ordinary weapons use OFF/ON, default ON. Nine special-case weapons combine OFF with Balanced and all their existing profile/cadence choices. Eruptor defaults to 28 RPM. Contextual descriptions explain every option, and applied selections persist across sessions.

Global OFF overrides every weapon without changing its selection. Individual OFF disables assistance only for that weapon. The existing `=` global toggle remains available. With Mod Bindings Menu, configure its toggle action on the MODS tab of the keyboard/controller bindings pages. Release Fire after enabling FAA or changing a profile before beginning another assisted hold.

## Supported weapons and profiles

The same 31 production-supported weapons and all 21 existing enabled profile choices are preserved. See [SUPPORTED_WEAPONS.md](SUPPORTED_WEAPONS.md) for the full names, groupings and special-case cadences. No new weapon support, firing modes or experimental charge functionality is included.

## Upgrading and advanced fallback

Keep your existing INI and saved menu values. Disabled legacy weapons migrate to OFF; enabled weapons retain their valid saved profiles. New combined selectors use separate persisted IDs so OFF cannot shift old numeric profile selections. Missing or invalid settings use established enabled defaults. The existing public package GUID and runtime installation paths are unchanged.

Manual INI editing is an advanced fallback, not the normal configuration method. Without Mod Options Menu, edit `%LOCALAPPDATA%/CowboyBingus/Helldivers2/HD2FullAutoAssist.ini` while the game is closed. Existing legacy Arsenal profile options remain supported. Applied/saved in-game selections take precedence when the menu is installed. The example INI keeps diagnostics and profiling disabled.

For manual installation, use one verified FAA patch slot for the archive and both sidecars in `Core/`; do not overwrite another mod's files.

## Compatibility and validation

Supports Steam build 25480438 behind the existing exact-build gate. The author confirmed the v1.3.0 candidate works in-game. This release changes only metadata, documentation and packaging; its runtime archive is byte-identical to that tested candidate. Targeted package checks confirmed the unchanged runtime, roster, menu, profiles and migration, preserved identity and a freshly calculated ZIP checksum. No additional gameplay or performance testing was performed for this metadata update.

[More mods and guides by Hijinks](https://hijinkssss.github.io/)
