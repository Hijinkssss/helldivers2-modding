# RC2 HUD diagnosis and evidence limits

The confirmed implementation blocker is RC1's GUI-world selection: it rejects every scene with two or more non-main worlds before creating a GUI. The exact RC1 renderer reproduces this silently with a three-world fixture; RC2 creates nine rectangles on the first non-main world in the same fixture. KnowYourConstellation and the recent HCR renderer use that exposed surface selection. RC2 also explicitly sets the fully drawn GUI visible and hides it before cleanup. It preserves the original glyph geometry/color and normal coordinates.

This is a reproduced code defect and a plausible cause of the reported live failure. It is not yet a confirmed live-session root cause: RC1 recorded no HUD telemetry and RC2 has not been deployed. The live world's count, correct render surface, eligibility and pixel visibility must be checked using RC2's log and screenshot. No invisible-pixel diagnosis is being inferred from offline GUI mocks.

## What is currently established

| Requested check | Evidence now | RC2 observation needed |
|---|---|---|
| Intended implementation packaged/installed/loaded | Installed data/9ba626afa44a3aa3.patch_43 exactly matches RC1 ZIP core, SHA-256 fb5805fe98ea075675348569aa44856e3a3c0a3eca79c34482d931835d90192e. Loader v18/API 1 log lists mods/codex/hd2_full_auto_assist as loaded. | New implementation marker 1.1.0-rc2 in hud_rc2. |
| Renderer instantiated in-game | Lifecycle installs the HUD provider and constructs the renderer; tested through actual lifecycle with mocked engine APIs. RC1 live instantiation is not independently observed. | renderer_instantiated and renderer_available plus exposed API flags. |
| Draw/update callback fires | Actual wrapper invokes present after stock update; fixture preserves stock return values. | draw_update_calls must increase; GUI creation/rectangles indicate drawing calls returned. |
| Equipped weapon classified assisted | Exact policy and guarded state tests pass, including Commando. RC1 test session identity was not captured. | resource_hash, weapon, eligible, category and identity_valid. |
| Conditional visibility true | State projection tested for ON/OFF, assisted/native-auto, ship, invalid identity and respawn. | hud_visible, user_enabled, effective. |
| Position/anchor/scale/alpha | Static values: x=width*0.17, y=height*0.09, scale=height/1080, layer=900, Color(230,255,213,0). At 1920x1080: x=326.4, y=97.2, scale=1. Original nine-rectangle glyph unchanged. | Actual resolution, x/y/scale, on_screen and screenshot at normal settings. |
| Clipping/parenting/render surface | Independent screen GUI, no native ammo-widget parent; no added clip region. RC1 rejected multi-world scenes. Native ammo fade is not inherited. | world_count, target_index, world and actual pixels. A successful call alone does not prove surface draw order or clipping. |

## RC2 diagnostics

Temporary diagnostics use the actual Loader .log contract and existing host logger. Default hud_diagnostics=true emits constructor state, relevant transitions, frame 60 and every 600 updates, capped at 120 records per load. Logging failures are caught, and HUD failures do not disable Fire assistance. The HUD reads already-resolved state and adds no native reads/page queries. This does not establish zero CPU/I/O cost; logging can be disabled with hud_diagnostics=false.

The optional hud_probe_visible=true probe renders the same yellow three cartridges at screen center, four times normal scale, without granting assistance or altering any weapon. It is false in the packaged defaults. If used manually, restore false with the game closed, relaunch, and reconfirm normal conditional visibility before accepting RC2.

RC2 live indicator, Commando accepted cadence/guidance continuity, and Eruptor cadence feel remain pending. No game launch, deployment, injection, live memory modification, merge, push, publication or Nexus change was performed in this development pass. The existing installed RC1 bytes and public release remain untouched.
