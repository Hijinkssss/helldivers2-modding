# Provenance and third-party inputs

The included framework, consumers, fixtures and single-resource packager are project implementations. No loader, other mod source, game dump, extracted stock resource, artwork or third-party binary is redistributed. MIT applies to the project code and documentation; it grants no rights to Helldivers 2 or separately installed dependencies.

Design/source references reviewed during development:

- [Bingus Shared Loader v18](https://github.com/CowboyBingus/BingusSharedLoader/tree/3d7e3a120828178573ef1ee0a5c7eeae4a951865): API 1 discovery, declaration/resource format, callback startup and logging contract. Its source states that no repository-wide license has been selected. It must be supplied separately for runtime and optional discovery tests.
- [Ship Station Hotkeys](https://github.com/CowboyBingus/ShipStationHotkeys/tree/14757fad9e243e874737a8cc181f1d4b3df4a3e8): keyboard/presenter design references, ship resource identity, Armory presenter ABI and build-specific constants. The Armory backend is a separate small implementation; it does not include the upstream mod.
- [Mod Bindings Menu](https://github.com/CowboyBingus/ModBindingsMenu/tree/b7f76c85b5c671282d18b5d760bef043e2b2cd51) and other CowboyBingus addons: input, entity-map and Windows-reader design review. No native bindings menu integration is bundled.
- Installed C4/DiverKit UI catalogs were internal research references. Their source is not included. Cursor/menu-only heuristics failed chat checks; the text receiver guard was implemented from current-build native registration/clearing traces and bounded read-only observations.
- MurmurHash64A, created by Austin Appleby, defines the seed-zero resource-name hashing algorithm. The Python implementation here is independently expressed. No upstream MurmurHash source is bundled.
- Windows API names/declarations and build-specific offsets, hashes and short instruction anchors describe interoperability; they are not a packaged game binary. Numeric facts do not establish a compatible build without runtime guards.

External test dependencies: [Lupa](https://github.com/scoder/lupa) and [LuaJIT](https://luajit.org/) are MIT licensed; install them separately. No runtime library is vendored. GPT-6 Astra assisted with research, implementation, testing and documentation.

Optional semantic dependency: [SkyeShade/HD2Runtime 0.24.0](https://github.com/SkyeShade/HD2Runtime/tree/fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595), public resource `mods/skyeshade/hd2runtime`, API 1. Its public APIs, runtime contracts and provenance were inspected on 2026-09-28. No root license grant was found; THIRD_PARTY.md and docs/provenance.json do not establish reuse permission. No upstream implementation, generated SDK/stubs or binary is included. The optional bridge is independently written and currently lives in a separate candidate. Our MIT license covers our implementation only, and does not license this external dependency.

The publication audit compared project source with the reviewed local upstream checkouts and excluded third-party implementations. Future contributions must disclose provenance and retain any required notices; do not assume that public GitHub source permits copying.
