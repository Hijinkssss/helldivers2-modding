# HUD indicator investigation status

## Branch and source boundary

This work starts at public v1.0.0 `main` (`f5c52219da2b3e9a7b1a3f919d34ae2ca799bed9`). It does not include the separate compatible-build branch. The existing 29-weapon policy remains authoritative.

## Existing evidence reviewed

- `validation/anchor-hud.asm` identifies an exact-build game HUD owner access and its constructor/update calls. `validation/anchors.json` records the associated global and offsets.
- `validation/anchor-root.asm` and `validation/anchor-resize.asm` show root layout and scale/resize behavior. The root routine constructs and sizes native elements; it does not establish a stable public Lua object API.
- `validation/anchor-draw.asm`, `validation/anchor-normal.asm`, and `validation/anchor-summary.txt` identify HUD draw/resource and palette paths. The resource inventory in `validation/resources.json` contains no positively identified automatic-fire/bullet HUD icon. The crosshair-specific entries in `validation/extra-evidence.json` are unrelated and are not reused.
- This public v1.0.0 standalone package exposes no GUI, HUD, or draw adapter in its Lua host. The evidence does not currently prove a safe way to create, update, or remove a custom HUD object, observe its reconstruction, or read the lower-left weapon widget's live alpha.

The signatures and offsets are evidence for targeted follow-up, not a license to write directly into undocumented objects. No native writes or new memory reads were added.

## Aggro Counter reference

The available public reference is the [Aggro Counter Nexus page](https://www.nexusmods.com/helldivers2/mods/16623). Its description says the badge is repositionable through persisted directional hotkeys and warns that game HUD scale/offset/compass-width settings can shift its placement. This supports keeping layout position represented independently from drawing and persisting future user placement. The page did not expose its renderer source in the accessible description, so no implementation details are attributed to it and no code was copied.

## Implemented safe portion

`src/hud_indicator.lua` is a pure projection from the current AssistState snapshot to `HIDDEN`, `ENABLED`, `DISABLED`, `ENABLED_DIM`, or `DISABLED_DIM`. It treats ASSIST/SPECIAL plus valid and observed identity as the support predicate, consumes `user_enabled`, ignores `repeat_active`, and accepts the native weapon-HUD opacity as an external presentation input. It owns no preference, weapon list, input, lifecycle hook, or game-memory access. This keeps future layout values (position, scale, opacity, visibility) in a renderer-facing boundary without coupling them to the gameplay controller.

This is not yet a visible HUD feature. In particular, opacity defaults to full active opacity until a renderer can supply a trustworthy native fade value.

## Smallest missing evidence before renderer work

1. A callable and version-supported HUD draw/widget API exposed to LuaJIT mods on the exact supported build, including object ownership and destruction rules.
2. A stable way to detect HUD rebuild/session transitions and reacquire the correct render surface.
3. A readable weapon-HUD alpha/fade signal, or a validated overlay hook that shares the weapon widget's fade lifecycle.
4. A positively identified native automatic-fire icon resource. If none exists, use a small vector glyph in the approved draw API with a slash overlay for OFF.

Until those are known, the full visual milestone and HUD development archive are blocked. The existing gameplay package must not depend on HUD initialization.

## Offline verification

`tests/test_hud_indicator.lua` covers supported enabled/disabled states, hidden unsupported/unknown/native-auto and unavailable-identity cases, faded states, zero opacity, clamping, invalid opacity, snapshot immutability, and independence from `repeat_active`. The full controller/policy/package regression suite remains required after changes to package wiring.

## Live test checklist for the eventual renderer

1. Launch the game and enter a mission with a supported weapon.
2. Confirm ON shows the normal bullet/full-auto icon.
3. Toggle OFF and confirm the same icon has a clear slash; toggle ON and confirm it returns.
4. Let the weapon HUD fade and confirm the icon dims with it; wake the HUD and confirm it brightens.
5. Switch to an unsupported weapon and confirm the icon disappears; switch back and confirm it returns correctly.
6. Cross a mission transition and menu/focus transitions; confirm no duplicate or stuck object/state.
7. Confirm gameplay Full Auto Assist behavior is unchanged.
8. Shut down and restart; confirm no stale or duplicate HUD object.

Future management work should keep normalized position, scale, opacity, and visibility in renderer configuration, with the renderer lifecycle isolated from the authoritative AssistState consumer.
