# FAA 1.1.0 approved HUD layout

The user approved RC3's HUD in live testing on 2026-10-01. Its renderer, colors, cartridge geometry, gap, scale, world selection, native extent and per-frame sampling are frozen. Eruptor's former OFF concern is closed by vanilla validation. The completion checkpoint changes only captured-byte parsing and combines the existing flag/link verification reads; it does not alter the visual behavior below.

## Three states

The existing resolved controller identity and supported category decide visibility, independently of the session ON/OFF preference. Unsupported or invalid/unobserved identities stay hidden. A supported weapon is yellow while FAA is enabled and effective, and opaque white while OFF. Yellow remains exactly `Color(230,255,213,0)`; white is `Color(255,255,255,255)` (alpha first). The nine rectangles, three-cartridge geometry, layer 900 and RC1 size at `height / 1080` are unchanged. Color joins the retained-render signature, so toggling recolors the same rectangles without moving or recreating them.

Native HUD absence, unreadable/invalid geometry, an offscreen result, missing UI worlds, or a renderer fault can suppress drawing independently of weapon support. This candidate retains RC2's live-proven first non-main UI-world selection and explicit GUI visibility; it does not reintroduce RC1's multi-world rejection.

## Exact native anchor

After the stock update returns, the HUD renderer requests a fresh geometry sample. The already fingerprint-guarded lifecycle host supplies checked, read-only access; no native UI function is called and no native widget is modified.

For Steam build 25480438, the owner pointer is at `game.dll + 0x346d538`. The lower-left local panel is inline at owner `+0x24e340 +0x60`. Its weapon container is `+0x7b0`; the native ammo/reserve row container is `+0x3220`. The constructor attaches the latter to the weapon container and reserve text `+0x3a60` to that row.

The sample walks the local panel's current child tree: first child `+0xe0`, next sibling `+0xe8`, parent `+0xf0`. It checks parent links, detects cycles, limits the walk to 192 nodes and depth 16, and follows only shown branches. Shown bit `0x10` and inherited opacity `+84 > 0.001` exclude hidden content. Type 1 widgets are structural containers and their reserved width is excluded. All other visible widgets with nonzero solved width/height contribute to the rightmost extent. This includes contents outside a parent's nominal width and backpack contents wherever they occur within this local panel, without an equipment-specific offset or backpack detector.

Solved width/height are at `+36/+40`, scale X/Z at `+100/+140`, and screen translation X/Z at `+148/+156`. Native UI lies in the matrix's X/Z plane. Positive uniform, axis-aligned transforms and finite on-screen bounds are required; rotation/shear is rejected. The owner pointer, ammo row and visited flags/links are rechecked before returning a sample. No pointer or placement sample survives to the next update.

Placement uses:

```
right = maximum(x + width * native_scale) of visible rendered local-panel widgets
glyph_x = right + 6 * ammo_row_native_scale
glyph_y = ammo_row_screen_y + ammo_row_solved_height / 2 - glyph_height / 2
glyph_scale = screen_height / 1080
```

The preserved glyph reserves a 17 by 14 scaled-unit footprint. The gap is six native UI units. X changes immediately with the current native extent; Y follows the ammo row center. ON and OFF use identical formulas. Identical bounds/color skip rectangle updates. If sampling fails, the old GUI is cleared immediately; a later valid sample recreates it. There is no normalized-screen fallback, smoothing delay, or cached backpack position.

## Evidence and limits

`hud-native-evidence.json` records ten field signatures and nine constructor/tree instructions checked against the saved exact-build image SHA-256 `e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969`, whose capture records game.dll identity `2e2c3b7c2500646dadd5f2b4c6e0504dbb7e7896139f64cddc0d1813c718f51e`. Every field signature matched uniquely. This is static native-layout evidence, not live backpack acceptance.

Offline tests cover three states, retained yellow/white recoloring, equal ON/OFF positions, expansion/contraction, native text-width changes, scale/resolution, visible children outside padded parents, hidden content, owner/parent races, read failure, cycles, traversal bounds, nonfinite/sheared/offscreen geometry, recovery and actual lifecycle wiring.

The six-node geometry fixture uses 22 checked reads per sample and zero writes. The bound is at most `3 * node_count + 4` reads, hence 580 at the 192-node ceiling; early failures use fewer. Existing native-work parity fixtures have no exposed GUI and do not measure this added visible-HUD work. Live CPU cost and Mod Lag Watchdog impact remain unmeasured. Normal Fire/identity cache work remains unchanged; restoration ownership/error handling is strengthened separately.

In-game validation must establish that every relevant native backpack element is in this panel tree, solved widget bounds contain actual rendered text/icons, the ammo row remains a suitable visible anchor for all supported layouts, native-to-screen-GUI coordinates agree under HUD scale/aspect settings, and the six-unit gap/alignment are visually clean. Also check that normal native fading/animations do not cause unexpected hiding or movement. If those assumptions fail, record the specific layout and screenshot before changing the anchor. No game launch, deployment, merge, push, publication or Nexus edit occurred in this pass.
