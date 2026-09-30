# Full Auto Assist 1.1.0 research RC1 (unpublished)

This is a partial next-version candidate based on public v1.0.1. Do not upload
it to Nexus or treat it as a completed charge-weapon release.

Implemented: Eruptor Stable 26, Balanced 27, Fast 28 and Max 32 RPM selections,
and a small static three-cartridge indicator beside the lower-left weapon HUD.
The indicator uses exposed Stingray screen-GUI rectangles, no text or animation,
and reads only already-resolved FAA state. It hides when FAA is OFF, identity is
unavailable, aboard ship, or the weapon is unsupported. Position, appearance,
GUI-world selection and interaction with HUD scale/offsets need live validation.
It does not yet inherit the native ammo widget's fade.

The v1.0.1 conventional roster and optimized native input path are preserved.
Legacy Eruptor `balanced` and `full_auto` INI profiles still mean 26 and 32 RPM.
New INI profiles: `stable_26`, `balanced_27`, `fast_28`, `max_32`.
Arsenal selections take precedence. With no explicit selection Eruptor stays 26.

Arc Thrower, Purifier, Loyalist and Meltagun remain unsupported for automation.
Shared semantic-cycle groundwork and a developer-only read-only observer exist,
but readiness, beam completion, reload and safe synthetic Fire release/re-press
must be proven first. The charge research package observes manual firing; it
does not automate these weapons. Its raw field names deliberately avoid guessing
which floats are ready thresholds or which flags indicate firing/empty state.

No reload automation, stat changes, damage/recoil/heat/cooldown changes, ammo
management or weapon swapping. Quasar is excluded for its long cooldown.
Railgun and Epoch are excluded to preserve deliberate overcharge/self-damage
risk. Unknown identities and builds remain fail closed.

Requires the separately installed Bingus Shared Loader v18 / API 1. No Core or
Runtime dependency is bundled. Close the game, enable exactly one FAA package,
then Purge / Deploy with the loader at winning priority. Do not deploy standalone
ArcThrowerRevamped or its Megapack option during stock charge research.

All logging/profiling options default OFF. The ordinary candidate never starts
the charge observer. The separately named Charge Research ZIP enables only the
bounded developer trace, in addition to the same Eruptor/HUD candidate behavior.
An existing INI can override logging defaults; verify it before measuring.

Reference attribution: CowboyBingus's [ArcThrowerRevamped in VanillaPlusMegapack](https://github.com/CowboyBingus/VanillaPlusMegapack/tree/1b943e61d2436f204fb5d8740a6082f44a780e42/components/ArcThrowerRevamped)
informed bounded charge-table discovery and slot validation. Its weapon-data and
charge-flag writes were not copied. KnowYourConstellation in the same source
demonstrates the exposed retained GUI API and world-lifetime checks. FAA's glyph
and presentation code are newly written.

See LIVE_TEST.md. No live validation, installation or deployment has been
performed by the development task. v1.0.1 history, tag and release are preserved.
