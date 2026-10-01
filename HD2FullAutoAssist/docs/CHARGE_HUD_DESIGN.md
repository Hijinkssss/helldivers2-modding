# Next-version design and evidence gate

Research RC2 supersedes the RC1 manual trace plan below. See
[CHARGE_REASSESSMENT.md](CHARGE_REASSESSMENT.md) for corrected runtime `+8`
semantics, exact native transitions, logger root cause and the targeted probe.

Base: public main `2bba9ab85ab2f1264a310e9aa77168a9e22a5185` (v1.0.1).
Branch: `feature/full-auto-assist-charge-weapons-hud`. No release, tag,
Nexus update or merge is authorized for this candidate.

## Architecture reviewed before charge implementation

The standalone lifecycle performs identity and Fire callbacks before stock
update. The identity observer validates a parent-first certificate and only
rediscovers after invalidation. Native Fire owns a reversible mapping lease;
the original physical magnitude remains available independently of repeat
events. Idle identity work is throttled to 100 ms. `read_live` caches page
metadata, never bytes, and uses checked Windows RPM on every read.

Keep the observer, mapping lease, native long-period scheduler and conventional
weapon controller unchanged. Add Eruptor profiles to policy/config/resources.
HUD consumes AssistState only, with no independent weapon observer. The first
indicator is hidden when disabled, invalid or unsupported; otherwise it shows
one static three-cartridge glyph. It does not distinguish idle from cycling.

## Reference and findings

Reviewed CowboyBingus/VanillaPlusMegapack at
`1b943e61d2436f204fb5d8740a6082f44a780e42`, pinned ArcThrowerRevamped v1.6
source SHA-256 `041c162fab76448f027dad176d752d438ed50036f06022aca8ba2b3793c1cc65`.
Its bounded discovery, cached slot validation and update-only handling inform
this design. Its auto-fire data patch and charge-flag writes are not used.
FAA must use Fire input only and preserve stock weapon settings.

The exact-build offline image has SHA-256
`e27989fe7a2c0e2184ef64d4d587828f3ba5bc79f09a2d95c29f0724b8ab1969`;
capture provenance records game.dll SHA-256
`2e2c3b7c2500646dadd5f2b4c6e0504dbb7e7896139f64cddc0d1813c718f51e`.
Static xrefs confirm charge manager global RVA `0x3326c20`, 40-byte
runtime rows (`manager+0x40`) and entity-pointer rows (`manager+0x38`).
RVA `0x740a88` sets row+12, `0x740bb0` clears it. Charge settings accessor
`0x5052c0` uses the entity-ID map at manager+0x50 and 216-byte records at +0x90.
`0x73e316` reads settings+24, +0 and +48, while `0x73e32d` reads runtime+8.
Do not assume runtime+8 is a full-charge duration merely because the reference
names it that way. Its relation to elapsed charge, release and full readiness
needs a trace before it can decide an input edge.

Pinned exact-build Runtime catalogs uniquely identify all four resources:
Arc `96de9cd50f7306e6`, Purifier `fb3a19078694708a`, Loyalist
`aa69a60d74a3ec54`, Meltagun `6cfcc7f8801a0266`. These establish identity,
not charge readiness or permission to automate. Meltagun's attack is a Beam.
No verified beam-ended, can-fire or reload-required predicate is yet available.

## Minimum shared cycle boundary

Two behaviors suffice: full-charge release/re-press (Arc, Purifier, Loyalist)
and charge/beam-end/re-press (Meltagun). One pure machine accepts validated
semantic observations: `charging`, `ready`, `firing`, `recovering`, `idle`,
`reload_required`, `unknown`. It emits only hold/release/press/stop intents.
Weapon policy selects the behavior; no generic timers, invented thresholds,
weapon-stat writes, reload or weapon swap commands.

Physical release, changed identity/generation/session, unavailability and reload
cancel the cycle. Reacquisition requires a new physical press after interruption.
The native adapter must later prove that processed synthetic release cannot
mask physical release, that every input edge lasts one stock update, and that
all Fire originals remain restorable after partial failures. Existing repeat
mapping semantics alone do not establish charge-release input semantics.

Before native integration, collect a bounded read-only raw charge trace for each
weapon, including held charging, manual release, repeated manual cycles,
empty/reload, swaps and Meltagun beam completion. The semantic machine is
offline groundwork only until the observer and input edge adapter are verified.
All four charge weapons remain fail closed in ordinary FAA policy.

## HUD integration

The old HUD branch was reviewed without merging. Its state projection is useful
but its OFF/slash behavior differs from this request. Current Megapack
KnowYourConstellation source demonstrates `stingray.Application.worlds`,
`World.create_screen_gui` / `destroy_gui`, `Gui.rect` / `update_rect` and screen
resolution. Use these exposed APIs for retained geometry, with native yellow
and white coloring. No undocumented HUD-object writes or native function calls.
RC2 GUI lifetime follows the first non-main world, matching the exposed surface selection used by existing HUD mods. Missing worlds hide it; diagnostics record the chosen world.
Normalized default position beside lower-left ammo requires visual validation;
exact native ammo fade/offset binding remains unresolved. GUI errors hide the
indicator without disabling gameplay. No animation or text.

## Non-negotiable limits

No reload automation, stat changes, cooldown bypass or ammo management.
Quasar excluded for long cooldown; Railgun and Epoch excluded because automatic
safe release would remove deliberate overcharge/self-damage risk. Live gameplay
and Watchdog performance are separate acceptance gates from synthetic tests.
