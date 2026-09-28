from pathlib import Path
import shutil, json, hashlib, difflib

ROOT = Path(__file__).resolve().parents[2]
OLD = Path('C:/Users/Law/Documents/Codex/2026-09-26/i')
DEST = ROOT / 'outputs/public-release'
REVIEW = Path(__file__).resolve().parent
ORIGINS = {
    'HD2ModCore': ROOT/'outputs/HD2ModCore-v0.3-input-candidate',
    'HD2SessionJournal': OLD/'outputs/HD2SessionJournal',
    'HD2ArmoryHotkey': ROOT/'outputs/HD2ArmoryHotkey',
}

def write(repo, path, text):
    target = DEST/repo/path
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text.strip()+'\n', encoding='utf-8', newline='\n')

inventory = []
for name, origin in ORIGINS.items():
    for file in sorted(origin.rglob('*')):
        if not file.is_file(): continue
        rel = file.relative_to(origin)
        public = rel.parts[0] in ('src','scripts','tests') and file.suffix in ('.lua','.py')
        classification = 'public source; sanitize build/test paths' if public else (
            'generated; rebuild only' if rel.parts[0]=='build' else
            'internal evidence; exclude raw records' if rel.parts[0]=='validation' else
            'documentation/config; replace or review')
        inventory.append({'project':name,'path':str(rel),'classification':classification,
                          'sha256':hashlib.sha256(file.read_bytes()).hexdigest()})
        if public:
            write(name, rel, file.read_text(encoding='utf-8'))
    for file in origin.glob('*.ini.example'):
        write(name, 'examples/'+file.name, file.read_text())

(REVIEW/'inventory.json').write_text(json.dumps(inventory,indent=2)+'\n')

license_text = '''MIT License

Copyright (c) 2026 HD2ModCore contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.'''

gitignore = '''/build/*
!/build/.gitkeep
*.log
*.ini
!*.ini.example
__pycache__/
*.py[cod]
.venv/
.pytest_cache/
.vscode/
.idea/
.DS_Store
Thumbs.db
/validation/
/artifacts/
/test-profiles/
/tmp/
/staging/
*.dmp
*.bin
*.dll
*.exe
*.patch_*
*.zip'''

contributing = '''# Contributing

Use small LuaJIT 2.1 modules, LF UTF-8, explicit Result checks and stable owner identifiers. Preserve game callback arguments, nil return values and errors. Register cleanup before acquiring resources; unregister owned subscriptions and release handles on every failure and normal exit. Keep gameplay decisions in consumers.

Public API changes need documentation, meaningful fixtures and an evidence record separating source review, offline checks and observed game behavior. Build constants require exact EXE/DLL hashes, provenance, bounded reads and unchanged-state checks. An old RVA or a working third-party mod is insufficient proof of a new public capability. Do not promote experimental game-state fields without independent validation.

Avoid unnecessary work each frame. Prefer subscriptions, rate limits and on-demand reads. Measure native read/query counts and direct callback cost; report workload and limitations. Scheduler budgets are advisory and cannot interrupt synchronous work. Preserve snapshot-scoped cache expiry and refusal on unavailable/changed state.

Build and run the documented offline suite before submitting a patch. Do not include game captures, extracted game resources, other authors' source/binaries, tokens, personal paths, saved profiles or raw user logs. New third-party code needs redistribution permission and retained notices. Keep Core API and loader resource identities stable; document breaking changes before release.

For bugs, include Core/consumer versions, Steam build, EXE/DLL hashes when relevant, Loader version/API, enabled mod list and order, reproduction steps, expected/actual behavior and redacted logs. Remove usernames, local paths, chat content and credentials. State whether the failure is on ship, during loading or in a mission, and whether shutdown cleanup completed.'''

third_party = '''# Provenance and third-party inputs

The included framework, consumers, fixtures and single-resource packager are project implementations. No loader, other mod source, game dump, extracted stock resource, artwork or third-party binary is redistributed. MIT applies to the project code and documentation; it grants no rights to Helldivers 2 or separately installed dependencies.

Design/source references reviewed during development:

- [Bingus Shared Loader v18](https://github.com/CowboyBingus/BingusSharedLoader/tree/3d7e3a120828178573ef1ee0a5c7eeae4a951865): API 1 discovery, declaration/resource format, callback startup and logging contract. Its source states that no repository-wide license has been selected. It must be supplied separately for runtime and optional discovery tests.
- [Ship Station Hotkeys](https://github.com/CowboyBingus/ShipStationHotkeys/tree/14757fad9e243e874737a8cc181f1d4b3df4a3e8): keyboard/presenter design references, ship resource identity, Armory presenter ABI and build-specific constants. The Armory backend is a separate small implementation; it does not include the upstream mod.
- [Mod Bindings Menu](https://github.com/CowboyBingus/ModBindingsMenu/tree/b7f76c85b5c671282d18b5d760bef043e2b2cd51) and other CowboyBingus addons: input, entity-map and Windows-reader design review. No native bindings menu integration is bundled.
- Installed C4/DiverKit UI catalogs were internal research references. Their source is not included. Cursor/menu-only heuristics failed chat checks; the text receiver guard was implemented from current-build native registration/clearing traces and bounded read-only observations.
- MurmurHash64A, created by Austin Appleby, defines the seed-zero resource-name hashing algorithm. The Python implementation here is independently expressed. No upstream MurmurHash source is bundled.
- Windows API names/declarations and build-specific offsets, hashes and short instruction anchors describe interoperability; they are not a packaged game binary. Numeric facts do not establish a compatible build without runtime guards.

External test dependencies: [Lupa](https://github.com/scoder/lupa) and [LuaJIT](https://luajit.org/) are MIT licensed; install them separately. No runtime library is vendored. GPT-6 Astra assisted with research, implementation, testing and documentation.

The publication audit compared project source with the reviewed local upstream checkouts and excluded third-party implementations. Future contributions must disclose provenance and retain any required notices; do not assume that public GitHub source permits copying.'''

for name in ORIGINS:
    write(name,'LICENSE',license_text.replace('HD2ModCore contributors',name+' contributors'))
    write(name,'.gitignore',gitignore)
    write(name,'.gitattributes','* text=auto eol=lf\n*.zip binary\n*.patch_* binary')
    write(name,'CONTRIBUTING.md',contributing)
    write(name,'THIRD_PARTY.md',third_party)
    write(name,'requirements-test.txt','lupa==2.8')
    write(name,'build/.gitkeep','')
    write(name,'.github/ISSUE_TEMPLATE/bug_report.md',
          '---\nname: Bug report\nabout: Reproduction and compatibility evidence\n---\n\nVersions (Core, consumer, Loader/API, Steam build):\n\nEnabled mods and order:\n\nSteps to reproduce:\n\nExpected and actual behavior:\n\nShip/loading/mission context and cleanup result:\n\nRedacted logs (remove private paths, chat and credentials):')

core = DEST/'HD2ModCore'
entry=core/'src/hd2modcore/entry.lua'
entry.write_text(entry.read_text().replace("VERSION='0.3.0-input-candidate'","VERSION='0.3.0-dev'"),newline='\n')
profile=core/'src/hd2modcore/example_profile.lua'
profile.write_text(profile.read_text().replace('-- Source candidate only. These RVAs are not yet HD2ModCore runtime validated.',
    '-- Exact-build diagnostic profile. Ship observations do not establish stable game semantics.\n-- Keep source_only evidence and the existing profile id; see docs/VALIDATION.md.'),newline='\n')
arm=DEST/'HD2ArmoryHotkey/src/armory_hotkey.lua'
arm.write_text(arm.read_text().replace("version='0.1.0-candidate'","version='0.1.0-dev'"),newline='\n')

# Each consumer carries only our MIT single-resource encoder and has its own build.
builder=(core/'scripts/build.py').read_text()
archive_part=builder[builder.index('MIX = '):builder.index('def bundle()')]
archive_part+='\n'+builder[builder.index('def archive_resource('):builder.index('def main()')]
archive_source='"""Project-owned single plaintext resource encoder; no stock game resources."""\nimport struct\nMODULE = ""\nLUA_TYPE = 0xA14E8DFA2CD117E2\n'+archive_part
for name in ('HD2SessionJournal','HD2ArmoryHotkey'):
    write(name,'scripts/archive.py',archive_source)

def change(name,path, replacements):
    p=DEST/name/path
    text=p.read_text()
    for before,after in replacements:
        assert before in text,(name,path,before)
        text=text.replace(before,after)
    p.write_text(text,encoding='utf-8',newline='\n')

change('HD2ModCore','scripts/build.py',[
    ('HD2ModCore-v0.3.0-Input-Candidate-Arsenal.zip','HD2ModCore-v0.3.0-dev-Arsenal.zip'),
    ('HD2ModCore v0.3.0 input candidate','HD2ModCore v0.3.0-dev Developer Preview'),
    ('0.3.0-input-candidate','0.3.0-dev'),
    ('Candidate game-state observer; no gameplay feature.','Developer Preview infrastructure and experimental read-only game-state observer.'),
    ('Keyboard press edges with the frozen read-only diagnostic observer','Shared lifecycle, config, logging, scheduler, events and guarded keyboard input'),
])
change('HD2ModCore','tests/run.py',[
    ('HD2ModCore-v0.3.0-Input-Candidate-Arsenal.zip','HD2ModCore-v0.3.0-dev-Arsenal.zip')])
change('HD2ArmoryHotkey','scripts/build.py',[
    ("CORE=ROOT.parent/'HD2ModCore-v0.3-input-candidate'",''),
    ("spec=importlib.util.spec_from_file_location('archive_builder',CORE/'scripts/build.py')", "spec=importlib.util.spec_from_file_location('archive_builder',ROOT/'scripts/archive.py')"),
    ('HD2ArmoryHotkey-v0.1-Candidate-Arsenal.zip','HD2ArmoryHotkey-v0.1.0-dev-Arsenal.zip'),
    ('HD2 Armory Hotkey v0.1 candidate','HD2 Armory Hotkey v0.1.0-dev Developer Preview'),
    ('HD2ModCore input candidate','HD2ModCore v0.3.0-dev / API 1 shortcut eligibility extension')])
change('HD2SessionJournal','scripts/build.py',[
    ('ROOT.parent / "HD2ModCore" / "scripts" / "build.py"','ROOT / "scripts" / "archive.py"'),
    ('HD2SessionJournal-v0.1-Arsenal.zip','HD2SessionJournal-v0.1.0-dev-Arsenal.zip'),
    ('HD2 Session Journal v0.1','HD2 Session Journal v0.1.0-dev Developer Preview')])

# Portable external fixtures, with clear missing-dependency errors.
bootstrap='''import argparse
parser=argparse.ArgumentParser()
parser.add_argument('--core-source',type=Path,default=ROOT.parent/'HD2ModCore')
parser.add_argument('--runtime-path',type=Path)
parser.add_argument('--loader-source',type=Path,required=True)
args=parser.parse_args()
CORE=args.core_source.resolve()
LOADER=args.loader_source.resolve()
if args.runtime_path: sys.path.insert(0,str(args.runtime_path.resolve()))
'''
for file in ('test_offline.py','test_chat_eligibility.py'):
    p=DEST/'HD2ArmoryHotkey/tests'/file
    text=p.read_text()
    start=text.index("CORE=ROOT.parent/")
    end=text.index('from lupa.luajit21 import LuaRuntime')
    text=text[:start]+bootstrap+text[end:]
    text=text.replace("(RUNTIME.parent/'BingusSharedLoader-v18/src/discover.lua')",'LOADER')
    text=text.replace('HD2ModCore-v0.3.0-Input-Candidate-Arsenal.zip','HD2ModCore-v0.3.0-dev-Arsenal.zip')
    text=text.replace('HD2ArmoryHotkey-v0.1-Candidate-Arsenal.zip','HD2ArmoryHotkey-v0.1.0-dev-Arsenal.zip')
    p.write_text(text,newline='\n')
jp=DEST/'HD2SessionJournal/tests/test_offline.py'
text=jp.read_text();start=text.index('WORKSPACE =');end=text.index('from lupa.luajit21')
text=text[:start]+bootstrap+text[end:]
text=text.replace('(WORKSPACE / "work" / "BingusSharedLoader-v18" / "src" / "discover.lua")','LOADER')
text=text.replace('HD2SessionJournal-v0.1-Arsenal.zip','HD2SessionJournal-v0.1.0-dev-Arsenal.zip')
text=text.replace('for name in ("HD2ModCore", "HD2ModCore-v0.2"):\n        CORE = WORKSPACE / "outputs" / name', 'for name in ("HD2ModCore",):')
text=text.replace('["0.1.0", "0.2.0-candidate"]','["0.3.0-dev"]')
jp.write_text(text,newline='\n')

# Reproducible package member metadata and useful standalone release documents.
for name in ORIGINS:
    p=DEST/name/'scripts/build.py'
    text=p.read_text()
    text=text.replace('def main()', '''def zip_member(package, name, data):
    info=zipfile.ZipInfo(name, date_time=(1980,1,1,0,0,0))
    info.compress_type=zipfile.ZIP_DEFLATED
    info.external_attr=0o100644 << 16
    package.writestr(info,data)


def main()''')
    # Keep source byte production unchanged except the explicit version labels.
    for var in ('package','output','z'):
        text=text.replace(var+'.writestr(', 'zip_member('+var+',')
    # Undo the helper's own call after replacing package.writestr.
    text=text.replace('zip_member(package,info,data)','package.writestr(info,data)')
    marker='    report = {' if name!='HD2ArmoryHotkey' else '    report={'
    assetvar='BUILD' if name!='HD2ArmoryHotkey' else 'build'
    insert=f'''    with zipfile.ZipFile({assetvar}/PACKAGE, 'a') as release_zip:
        for document in ('README.md','LICENSE','THIRD_PARTY.md'):
            zip_member(release_zip,document,(ROOT/document).read_bytes())
    ({assetvar}/'SHA256SUMS.txt').write_text(hashlib.sha256(({assetvar}/PACKAGE).read_bytes()).hexdigest()+'  '+PACKAGE+'\\n',encoding='utf-8')
'''
    assert marker in text
    text=text.replace(marker,insert+marker)
    p.write_text(text,newline='\n')

write('HD2ModCore','README.md','''# HD2ModCore Developer Preview

HD2ModCore is a small shared LuaJIT foundation for Helldivers 2 mods using Bingus Shared Loader. It gives consumers one lifecycle, configuration parser, logger, scheduler, snapshot-event service and keyboard press dispatcher, reducing repeated callback and cleanup code across addons.

First public preview: **v0.3.0-dev**, facade **API 1**. Tested runtime: **Windows x64, Steam build 25480438 / EXE 1.8.46015.0, Bingus Shared Loader v18 / API 1**. This is a pre-1.0 Developer Preview with deliberately limited game integration.

## Install and depend on Core

Supply [Bingus Shared Loader](https://github.com/CowboyBingus/BingusSharedLoader) separately. Import the Core Arsenal ZIP, enable Core and Loader, and deploy with Loader as the winning startup replacement. Enable only one Core version. Restart the game after changing packages. The Core ZIP contains only our plaintext resource and empty manager companion files; it does not include a loader, game DLL or stock script. Manual merging/renumbering of patch archives is outside this preview's instructions.

Consumers require `mods/codex/hd2_mod_core`, check `core.api == 1`, and feature-check any provisional extension. `mods/codex` is the retained loader resource namespace, not a local workspace path. Load order is safe for Core-first or consumer-first `require`; consumer packages must not embed another Core.

```lua
local core = assert(require('mods/codex/hd2_mod_core'))
assert(core.api == 1 and core.Hooks and core.Config and core.Logger)
local owner, task = 'my_mod', nil
local function must(r)
    assert(r and r.ok, r and r.error and r.error.detail or 'Core failure')
    return r.value
end
must(core:OnUnload(owner, function()
    if task then core.Hooks:Remove(task); task = nil end
end))
local loaded = core:OnLoad(owner, function()
    must(core.Config:Register(owner, {enabled={type='boolean',default=true}}))
    local settings = must(core.Config:Load(owner, '')) -- consumer supplies INI text
    if not settings.enabled then return end
    task = must(core.Hooks:Subscribe(owner, 'after_update',
        {every_ms=1000,budget_us=500}, function()
            core.Logger:Emit('info',owner,'heartbeat',{})
        end))
end)
if not loaded.ok then core:Unregister(owner); error(loaded.error.detail) end
-- Explicit removal: core:Unregister(owner). Game shutdown also runs owner cleanup.
```

## What is ready, and what is limited

Lifecycle/config/logging/scheduler/generic events have validated infrastructure contracts. Keyboard edges and the on-demand shortcut guard are provisional. Build profiles, symbols, memory reads and `Diagnostic:LocalAvatar()` remain experimental or build-specific. The profile intentionally retains `source_only` evidence and Core can report `degraded` even on the tested build; that is not a blanket startup failure. Generic services can still run on an unsupported build, while build-dependent reads and eligibility refuse it.

The shortcut guard blocks active text entry, lost focus, visible UI cursor or busy menu state. It reads receiver presence, never typed text. Live chat coverage is the ship chat editor on the exact tested build. Other text-entry surfaces, alternate ship layouts and loading transitions are untested. Raw keyboard subscriptions do not automatically apply this guard. Consumers must require `result.ok` and `result.value.allowed == true` before their action and consume a blocked edge without queueing it.

There is no public write/patch/native-call API, automatic gameplay event catalog, native detour system, controller binding system or reliable hot reload. Scheduler budgets are soft; consumer callbacks must remain small. A hash match alone does not prove object semantics. See [API and maturity](docs/API.md), [validation](docs/VALIDATION.md), [build profiles](profiles/README.md) and [architecture](docs/ARCHITECTURE.md).

## Build and test

Python 3.10+ builds with its standard library: `python scripts/build.py`. On Windows x64, install test dependencies with `python -m pip install -r requirements-test.txt`, then run `python tests/run.py`. This uses `lupa.luajit21`, not a system Lua interpreter. Build first. Optional `--runtime-path <directory>` uses an existing Lupa install; `--loader-source <checkout>/src/discover.lua` runs real Loader v18 discovery, and `--peer-adapter <windows_api.lua>` checks declaration order. Dependencies are supplied locally and not copied into releases.

Outputs appear in ignored `build/`: bundled plaintext Lua, single-resource patch, Arsenal ZIP, build report and `SHA256SUMS.txt`. Repeated builds produce the same ZIP with fixed member metadata. Source commits exclude generated packages and personal configuration.

## Template and independent examples

- [HD2ModTemplate](template/HD2ModTemplate/README.md): minimal consumer with config, logging, synthetic snapshot events, throttled scheduling, guarded keyboard input and owner cleanup. No native game action.
- [Example catalog](examples/README.md): HD2SessionJournal and HD2ArmoryHotkey are prepared as separate repositories and independent packages. Public repository links will be added after those repositories exist; this preview does not pretend they are already published.

See [changelog](CHANGELOG.md), [version policy](docs/VERSIONING.md), [contributor guide](CONTRIBUTING.md) and [provenance](THIRD_PARTY.md). Project code is MIT licensed. Helldivers 2 and separately installed dependencies retain their own rights.''')

api=(OLD/'outputs/HD2ModCore/docs/API.md').read_text()
api=api.replace('"0.1.0"','"0.3.0-dev"').replace('Unregister removes scheduler and event subscriptions','Unregister removes scheduler, event and input subscriptions')
api=api.replace('Every operation that can fail returns','Fallible service operations generally return')
api+='''

## Keyboard input (provisional)

`core.Input:ParseKey(key)` returns a Result containing a Windows virtual key. `SubscribePressed(owner,key,{debounce_ms=150},callback)` returns a Result token; `Remove(token)` returns a boolean. Callbacks receive no arguments and run after the prior update. At most 32 subscriptions, one sample per unique key per focused update. Registration/refocus requires release before a new press; holds do not repeat. Debounce is 0..2000 ms; rejected edges are consumed. A callback error disables that subscription. This is OS keyboard polling, not chat handling or controller rebinding.

`core.Input:ShortcutEligibility()` returns a Result of `{allowed,reason,window_focused,cursor_visible,text_entry_active,primary,modal,stack_count,secondary_count,pending}`. Reasons: `eligible`, `game_focus_lost`, `ui_cursor_visible`, `text_entry_active`, `ui_busy`. Unsupported build, missing/invalid engine/read service, changed native anchor, invalid bounds, failed reads, changing snapshot or stopped Core returns an error. Require success AND `allowed == true`. Call on demand immediately before acting; never queue a blocked press. The generic text receiver does not expose text. Its layout is build-specific and live coverage is ship chat only.

## Experimental diagnostic access

`core.Symbols:Resolve(name)` returns a Result for an exact-build module-relative symbol. `core.Diagnostic:LocalAvatar()` returns a Result containing copied diagnostic state and IDs, including a held-entity candidate. These fields do not establish weapon identity, idle/camera state or durable entity handles. There is no stable Game/Equipment API.

## Maturity policy

| Surface | Preview maturity | Dependence |
| --- | --- | --- |
| Result shape; lifecycle; Config; Logger; Hooks; generic Events | Stable infrastructure contract for this preview | Loader API 1, Windows/LuaJIT host |
| Diagnostics status schema | Provisional | Fields may expand/change before 1.0 |
| Input ParseKey/SubscribePressed/Remove | Provisional | OS keyboard/focus; feature-check |
| Input ShortcutEligibility | Provisional, build-specific | Exact hashes, native anchor/layout; ship chat tested |
| Build/Profiles, Symbols, Memory | Experimental/build-specific | Exact profile and bounded readers |
| Diagnostic LocalAvatar/held state | Experimental | Observed diagnostic IDs, incomplete semantics |
| Internal module constructors/platform/cache details | Private | No consumer compatibility promise |

Stable describes the evidence-backed infrastructure contract, not a 1.0 lifetime guarantee. API 1 alone does not promise Input exists in older local versions. Feature-check extensions and require the documented minimum release. Consumers should not call global `Shutdown()` during ordinary unload; use their own `Unregister(owner)`.
'''
write('HD2ModCore','docs/API.md',api)
write('HD2ModCore','docs/VERSIONING.md','''# Version and compatibility policy

The first public version is `v0.3.0-dev`: a pre-1.0 Developer Preview, not three historical public releases. It preserves local development milestones in the changelog. API 1 identifies the facade family, not every optional extension or game-build support level.

Use semantic versions. During 0.x, document breaking public contract changes and bump the minor version; patch versions are compatible fixes. Prerelease labels identify previews. At 1.0 and later, breaking stable contracts require a major bump. Version comparisons must understand prereleases; do not compare arbitrary version strings lexicographically.

Specify the minimum Core release and API in consumer documentation/manifests. Journal's first public preview is tested against Core `0.3.0-dev`; Armory and the template require that preview's Input and ShortcutEligibility extension, checked at startup. Experimental surfaces may change with a documented preview minor bump. Loader compatibility is separately stated as tested v18 / API 1, not a promise about every later loader.

A game update never inherits old RVAs merely because the API version is unchanged. Build-dependent APIs require both module hashes and their runtime guards. Unsupported builds keep generic infrastructure available where possible and return errors for unavailable native state. New layouts need their own profile and evidence; changing an evidence label is not validation.''')
write('HD2ModCore','docs/ARCHITECTURE.md','''# Architecture

The packager embeds independent Lua module factories into one plaintext Loader resource. `entry.lua` returns a cached facade, wraps the prior update/shutdown callbacks once, and rolls back required-stage failures. Loader owns discovery/bootstrap; Core owns only its Lua wrappers and registered consumers.

The foundation modules provide Result values, namespaced atomic config, bounded structured logging, lifecycle, per-owner scheduler subscriptions and producer-defined snapshot events. The Windows adapter supplies hashing, clocks, bounded reads and keyboard/focus sampling. Profiles select exact identities; symbols resolve module-relative addresses; the diagnostic observer rechecks bounded entity-map snapshots. Readable-page cache entries live only inside one synchronous observer snapshot. Normal reads still validate pages and every read uses ReadProcessMemory.

Input runs after the prior update and before after-update scheduler callbacks. Shortcut eligibility is on-demand and holds no subscription. It checks engine focus/cursor, an anchored native UI receiver and a reread menu snapshot. It does not call native UI functions. Consumers choose actions and must apply the guard themselves.

Shutdown runs owner cleanup in reverse registration order, clears scheduler/event/input callbacks, stops stages and restores globals only while Core still owns them. A later outer wrapper cannot safely be removed; restart instead of assuming hot reload. Armory's exact-build native presenter stays entirely in its independent consumer.''')
write('HD2ModCore','profiles/README.md','''# Build profiles

The executable profile is `src/hd2modcore/example_profile.lua`, bundled as source. This directory documents it rather than duplicating a second authority. Its retained ID `steam-25480438-v02-candidate` is a compatibility identity used by experimental consumers; it is not the release version.

Steam build: 25480438; EXE: 1.8.46015.0.

- EXE SHA-256: `F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06`
- game.dll SHA-256: `2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E`

Both hashes must match. The schema retains source-only evidence and empty capabilities because selected ship observations do not establish stable player/equipment semantics. `degraded` is expected for this profile. Public bounded reads require a selected profile; eligibility additionally checks native code bytes and stable UI state. No proprietary module is distributed.

New profiles require independent current-build provenance, bounds/anchor tests, changed/unavailable-state refusal and separately recorded live scope. Never copy historical offsets into an unobserved build.''')
write('HD2ModCore','docs/VALIDATION.md','''# Validation scope

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

Publication checks cover all Lua fixtures, exact bundle initialization/update/shutdown, require ordering, Windows adapter/hash smoke checks, Loader v18 discovery, independent consumer fixtures, template cleanup, source parity, deterministic packaging, ZIP contents/checksums, and sanitization. See the release assets' SHA256SUMS for new package identity. No game launch or manager change is part of publication preparation.''')
write('HD2ModCore','CHANGELOG.md','''# Changelog

## v0.3.0-dev - first public Developer Preview

- Shared lifecycle, namespaced config, structured logging, bounded scheduler and generic snapshot events.
- Experimental exact-build symbol resolution, bounded memory reads and diagnostic local-avatar snapshots.
- Snapshot-scoped region caching preserved from the measured local v0.2 implementation.
- Provisional keyboard press subscriptions and on-demand native text/UI eligibility guard.
- Sanitized source repository, portable builds/tests, API maturity policy, MIT license and minimal consumer template.

### Local milestones before publication

- v0.1 foundation: offline and ship/menu infrastructure validation; Loader v18 API 1 review.
- v0.2 candidate: diagnostic observer and measured ship cache optimization; game-state meanings remained provisional.
- v0.3 input candidate: Armory keyboard consumer, then a receiver-based chat guard after cursor/menu-only blocking failed; targeted ship chat and cleanup passed.

These were local development labels, not previous public GitHub releases. No new gameplay-facing Core capability is introduced by publication.''')
write('HD2ModCore','examples/README.md','''# Independent example consumers

The publication set contains three separate source repositories: HD2ModCore, HD2SessionJournal and HD2ArmoryHotkey. Each has its own history, MIT license, build, version and Arsenal ZIP. Core is required at runtime and never embedded in either consumer. Their public URLs will be linked here once repositories exist.

**HD2SessionJournal v0.1.0-dev:** lifecycle/config/logging/scheduler example that appends session start/end and optional minute heartbeats. Validated on a ship with clean shutdown. No native game access. Tested with Core v0.3.0-dev; Loader v18 / API 1.

**HD2ArmoryHotkey v0.1.0-dev:** provisional Input/ShortcutEligibility consumer with an exact-build native Armory presenter backend. F10 opens only; it does not close menus. Ship chat blocking, normal F10 and cleanup passed on 25480438. Mission/loading/alternate layouts/other text surfaces remain untested. Core v0.3.0-dev and Loader v18 / API 1 are required.

For the smallest source to adapt, use [HD2ModTemplate](../template/HD2ModTemplate/README.md).''')

for name,description in [('HD2SessionJournal','Configurable session logging example'),('HD2ArmoryHotkey','Guarded ship Armory shortcut example')]:
    version='0.1.0-dev'
    specific=('''Journal appends session start/end and clean shutdown records; optional heartbeats run no more often than once a minute. Configure `enabled`, `output_path`, `log_verbosity`, `heartbeat_interval_minutes` and `write_status_snapshots` using [the example](examples/HD2SessionJournal.ini.example). Defaults disable heartbeats and status snapshots. Output defaults to `Logs/HD2SessionJournal.log`; a custom absolute output path is user configuration, never distributed.

Uses Core lifecycle/config/logging/scheduler/diagnostics without reading or changing game state. The previously validated source body remains unchanged, including its historical `mod_initialized version=0.1.0` log marker; package prerelease version is defined in `VERSION` and the manifest. Ship validation recorded session start, heartbeats at 60 and 120 seconds, normal exit and complete cleanup.''' if name=='HD2SessionJournal' else '''F10 opens the native Armory presenter aboard ship. It is **open-only**: F10 does not close Armory. Configure `enabled`, `hotkey` and `debug_logging` using [the example](examples/HD2ArmoryHotkey.ini.example). Defaults are enabled, F10 and debug logging off.

Requires Core's Input and ShortcutEligibility extension. Every press must pass Core's active-text/focus/cursor/menu guard before consumer-specific exact-build, ship, player, native-prefix and menu-manager checks. Unsupported or changed state refuses the action. A blocked press is consumed, never queued. The native presenter remains consumer code, not a Core API.

Release-ready for the observed **ship scope on build 25480438**: chat-focused F10 blocked, normal F10 after closing chat opened Armory, normal shutdown cleaned all subscriptions. The public version-label rebuild has only offline verification; the original behavior was tested live. Mission/loading transitions, alternate ship layouts and other text-entry surfaces are untested. This is not a general station interaction API. See [validation](docs/VALIDATION.md).''')
    write(name,'VERSION',version)
    write(name,'README.md',f'''# {name} Developer Preview

{description}. First public package: **v{version}**, MIT licensed.

Requires separately installed **HD2ModCore v0.3.0-dev / API 1** and [Bingus Shared Loader v18 / API 1](https://github.com/CowboyBingus/BingusSharedLoader). Tested runtime: Windows x64, Steam build **25480438**, EXE **1.8.46015.0**. Core is prepared in a separate repository; its public link will be added after publication.

{specific}

## Install

Import this consumer's Arsenal ZIP alongside Core and Loader, enable all required packages, keep Loader as winning startup replacement and deploy. Enable only one Core and one copy of this consumer. Restart after changing packages. Put the optional `{name}.ini` in `%LOCALAPPDATA%/CowboyBingus/Helldivers2/`. Missing file uses defaults; invalid config refuses consumer initialization and cleans up. Logs are under the same root's `Logs/` directory. Disable the consumer in the manager and redeploy to remove it; restart rather than hot unloading.

## Build and test

`python scripts/build.py` builds independently using only Python's standard library. It contains this consumer and our MIT resource encoder, without embedding Core or another mod.

Install `python -m pip install -r requirements-test.txt`, place the Core source checkout alongside this repo (or pass `--core-source <path>`), build Core first, then run:

```
python tests/test_offline.py --loader-source <Loader-v18-checkout>/src/discover.lua
```

Tests require Windows x64 Lupa's LuaJIT 2.1 engine. Optional `--runtime-path <directory>` selects an existing Lupa install. Armory additionally runs `tests/test_chat_eligibility.py` with the same arguments. Loader source is an external read-only test dependency, never bundled. Reproducible release ZIP and SHA256SUMS are in ignored `build/`.

See [contributing](CONTRIBUTING.md), [provenance](THIRD_PARTY.md) and [changelog](CHANGELOG.md).''')
    write(name,'CHANGELOG.md',f'''# Changelog

## v0.1.0-dev - first public Developer Preview

- Independent {description.lower()} using Core API 1.
- Sanitized documentation, portable test arguments, standalone package encoder and reproducible release assets.
- Preserves prior ship-tested behavior; new public package labels are verified offline.

Earlier v0.1/candidate labels were local milestones, not public releases.''')
    write(name,'docs/VALIDATION.md',('''# Validation

Journal was observed aboard ship for approximately 136 seconds with one initialization, session start, minute heartbeats at 60/120 seconds, session end and clean shutdown. Core stopped with zero tasks/events and no errors. It uses generic infrastructure only; this is not gameplay validation.

The publication source body is byte-identical to the preserved consumer. New package labels and portable tooling are verified offline against Core v0.3.0-dev, including actual filesystem append output, config failures, disabled mode, heartbeat scheduling, cleanup and Loader v18 discovery. No new game run is claimed.''' if name=='HD2SessionJournal' else '''# Validation and boundaries

The original ship run covered keyboard presses, held-key suppression, normal Alt-tab, busy-menu/Social refusal and user-perceived performance. It also exposed that cursor/menu-only checks did not block chat. These historical results are not retested for publication.

The final receiver-based guard was checked with read-only ship chat-open/chat-closed samples, targeted offline fixtures and a minimal live sequence: chat-focused F10 produced `text_entry_active=true` and no native action; after chat closed, fresh F10 produced `text_entry_active=false` and opened Armory. The user confirmed the fix. Shutdown recorded zero consumer errors and zero remaining input/scheduler/event subscriptions or Core failures. The consumer was then disabled and removed from the isolated deployment.

The native backend and input implementation remain unchanged. Consumer/Core version labels and publication packaging are rebuilt and tested offline, not redeployed. Source parity distinguishes those presentation changes from behavioral changes. Other text fields, scene transitions, missions and alternate ship layouts remain untested. No station-wide or stock physical-interaction callback guarantee is made.

The backend references the build-specific downstream presenter mapping reviewed in Ship Station Hotkeys; a full physical station callback trace was not established. It requires the exact Core profile ID, ship galaxy-table resource, local avatar, matching 16-byte native entry anchor, idle menu manager and stable UI pointer, then checks that presenter 5 opened. See THIRD_PARTY.md for reference provenance.'''))

write('HD2ModCore','VERSION','0.3.0-dev')
print('Prepared selected source and public documentation; template and verification remain.')
