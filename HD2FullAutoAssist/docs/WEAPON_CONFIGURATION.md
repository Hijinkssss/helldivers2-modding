# FAA 1.3.0 configuration

## Configure in-game

1. Launch Helldivers 2 after installing and deploying FAA and the menu components.
2. Open the game's **MODS** settings tab.
3. Select **FULL AUTO ASSIST**.
4. Set **FAA Enabled** and the individual weapon selectors, then press **Apply**.

The single menu contains 32 settings: one global toggle and 31 weapon selectors, grouped Primary → Secondary → Support with two visual separators. Ordinary weapons use OFF/ON, default ON. Nine special-case weapons combine OFF with Balanced and all their existing profile/cadence choices. Eruptor defaults to 28 RPM. Contextual descriptions explain every option, and applied selections persist across sessions.

Global OFF overrides every weapon without changing its selection. Individual OFF disables assistance only for that weapon. The existing `=` global toggle remains available. With Mod Bindings Menu, configure its toggle action on the MODS tab of the keyboard/controller bindings pages. Release Fire after enabling FAA or changing a profile before beginning another assisted hold.

## Upgrading and advanced fallback

Keep your existing INI and saved menu values. Disabled legacy weapons migrate to OFF; enabled weapons retain their valid saved profiles. New combined selectors use separate persisted IDs so OFF cannot shift old numeric profile selections. Missing or invalid settings use established enabled defaults. The existing public package GUID and runtime installation paths are unchanged.

Manual INI editing is an advanced fallback, not the normal configuration method. Without Mod Options Menu, edit `%LOCALAPPDATA%/CowboyBingus/Helldivers2/HD2FullAutoAssist.ini` while the game is closed. Existing legacy Arsenal profile options remain supported. Applied/saved in-game selections take precedence when the menu is installed. The example INI keeps diagnostics and profiling disabled.

For manual installation, use one verified FAA patch slot for the archive and both sidecars in `Core/`; do not overwrite another mod's files.

