# Compatibility development audit

Status: evidence-limited fallback, not automatic compatibility and not a release
candidate. Baseline main is `f5c52219da2b3e9a7b1a3f919d34ae2ca799bed9`
(the peeled `v1.0.0` tag). Work is on
`feature/full-auto-assist-compatible-build-resolution`.

The known-build path is implemented and regression-tested. Unknown hashes enter
an explicit unsupported-capability path, which currently rejects every unknown
build before resolving globals or creating the Fire backend. This does **not**
meet the requested automatic compatibility success criterion. Both fingerprints
remain mandatory until the missing evidence below is supplied and reviewed.
No safety gate has been removed under the guise of a resolver.

## Evidence reviewed and why discovery is deferred

- `validation/provenance.json` identifies the module-RVA capture and analysis
  image as **25327279**. The installed EXE hash in that same file does not turn
  the earlier DLL capture into 25480438 evidence.
- `validation/*.asm`, `*-xrefs.json`, `extra-evidence.json`,
  `targeted-displacements.json`, `anchors.json` and `anchor-summary.txt` retain
  useful historical reticle and weapon/HUD relationships. The controls loads in
  `1377810.asm` and wielder loads in `17b6490.asm` / `1825e70.asm` are historical
  xref leads, not validated 25480438 or future-build signatures. Several globals
  in `extra-evidence.json` explicitly have `in_capture=false`.
- The masked pieces in `anchors.json` describe earlier reticle/EXE anchors,
  rather than the complete FAA Fire-map lookup and writable-field semantics.
  `targeted-displacements.json` primarily describes reticle/HUD fields.
- `validation/HD2Runtime-audit-2026-09-28.json` records API/source/package
  provenance and no game-process access. It is not native mapping-layout proof.
  The retained Core profile also supplies fixed globals, not approved resolvers.
- FAA's `identity-validation.json`, `IDENTITY_RESULTS.md`, `VALIDATION.md`,
  current native reader, and native test fixtures support the known build.
  The three inherited Fire byte windows and one text-registration prefix do not
  cover the full field consumers or demonstrate uniqueness after relocation.

No discovery patterns were introduced. No match-count or ambiguity guarantee is
claimed. Matching a short prologue or finding a global is insufficient to permit
writes. Masking the relative calls in the existing short Fire windows would
remove useful discrimination without proving the mapping structure.

## Dependency inventory

Classes: A semantic/resource identifier; B structure/layout; C native global;
D instruction/code anchor; E writable mapping assumption; F whole-build gate.
Offsets below are hexadecimal unless otherwise stated. Every runtime native
dependency remains restricted to the known profile.

| Source / dependency | Class | Treatment and evidence boundary |
| --- | --- | --- |
| EXE SHA `F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06` | F | Retained in compatibility profile. No targeted replacement approved. |
| game.dll SHA `2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E` | F | Retained. Hash-read failure also rejects. |
| `steam-25480438-v02-candidate` ID checks in native/UI adapters | F | Replaced by internally issued resolved-profile checks. An ID string alone cannot authorize these adapters. This does not remove the upstream hash gate. |
| `player_manager=3326468`, `entity_owner=346bf98`, `avatar_manager=3326d20`, `weapon_wielder=3326420`, `equipment_manager=3326dc0` | C | Moved from lifecycle into known profile; resolved to bounded absolute module addresses. |
| Controls `347cf18`, game state `3326340`, UI manager `347ce28` | C | Also centralized. These three additional roots are required by compatibility, not just the five identity globals. |
| Fire anchors `12fc180` (12 bytes), `12fc44c` (12), `12fa3b3` (12) | D | Exact bytes retained in profile, compared by native adapter before use. These are fixed-site guards, not signatures. |
| Text registration `14aeb30`, prefix `4889742410574883ec30` (10 bytes) | D | Centralized, still checked on UI samples. A generic prefix cannot establish text/UI semantics on an unknown build. |
| `identity.lua`: player count/available `84/88`, maximum 4; player record pointer `e8`; 24-byte player record, owned bit at byte 21; unit `3a8` | B | Preserved guarded observer and rereads. Unit sentinel `7fff`; zero/`ffffffff` also rejected in Fire gameplay guard. |
| Owner map `f22ec8`, avatar array `f32f18`, stride 24, index <262144 | B | Bounded map lookup; avatar resource and ownership checked. |
| Avatar resource bytes `97fa4d294d331c4d`; entity/resource records use hash at 0, ID at 8, ownership at byte 21 | A/B | Resource constant retained; layout and ownership remain known-build assumptions. Resource hashes alone do not prove weapon behavior on a new build. |
| Avatar manager map `f8`, live count `6c` (<=8), backrefs `110+index*8` | B | Index must be live and pointed-to 24-byte avatar record must agree. |
| Wielder map `30`, backrefs `48`, rows pointer `60`, row stride 464 decimal, held ID at row start | B | Wielder backref must equal avatar address and record bytes. Held state is reread. |
| Equipment map `20`, backrefs `38`, 8-byte pointer stride, 24-byte record, ID at 8 | B | Equipment ID must match held ID; hash read only after consistency checks. |
| Identity hash tables: 20-byte header (pointer 0, capacity 8, empty key 12, multiplier 16), 8-byte key/index slots | B | Power-of-two capacities; limits owner 1048576, avatar 64, wielder 4096, equipment 8192; max 128 probes; equipment index <4096; invalid index `ffffffff`. |
| Pointer shape and snapshot guards | B | x64 little endian, exact integer user pointers `10000..7fffffffffff`, bounded reads, 96-read observer budget, null/unavailable handling and final guard rereads preserved. |
| Fire state `controls+1c88`, 32 bytes: pressed byte 0, magnitude float 4, seconds float 8, mapping index 16, trigger 24 | B | Boolean, finite magnitude <=1.01, seconds [0,86400), trigger <=10; owner reread. |
| State `+ac21c`, state <=16; gameplay enum 4; PM unit `+3a8` | A/B | State enum is semantic; offsets/layout are known-build only. State/PM pointers reread. |
| Action `(group=2,action=9)` / `20009` | A | Retained normal Fire identifier; semantic constancy on another build still needs evidence. |
| Mapping table `controls+a7ad0`, header width 20, capacity 256, slots 328 decimal, bucket key/count at 0/4, records start 8 | B/E | Existing bounded lookup retained. Counts 1..16; active index < count. No unknown-build uniqueness claim. |
| Mapping width 20, flags at 0, device/button field 4, trigger at 8, field 12 preserved, repeat float at 16 | B/E | Flags kind bits 4..7 are button 4 / axis 8; trigger bits 16..19 must equal trigger word <=10. Button triggers 0/2/8 only; set repeat 8, preserve other fields; axis remains unchanged. |
| Mapping write/restore contract | E | Full 20-byte committed PAGE_READWRITE region, table/owner/key/count context, all records validated before first write, compare-before-write, readback, saved exact original bytes, lease before first write, partial rollback, release/change/error cleanup retained. Conflicting user edits are preserved; no stale-context restoration write. |
| UI receiver at manager+0; UI state `+4294`, size `90` | B | Null 8-byte receiver required for text inactivity; no typed text read. |
| UI fields primary/modal 0/4, stack at 8, count `1c` <=5, secondary `84` <=25, pending `8c` | B | Busy-state checks and complete UI/root/receiver rereads preserved. |
| Engine Window focus/cursor API, Win32 foreground PID and key state | A/B | Boolean normalization, rechecked engine flags and focus guards; API semantics still required on another build. No hardcoded EXE native addresses used by FAA. |
| PE `MZ`, `PE\0\0`, PE32+; e_lfanew `3c`, optional-header size field at +24+56 | A/B | File-format structure checks retained; all profile globals and code ranges bounded by module image. Not game-version signatures. |
| `VirtualQuery`/FFI ABI, MEM_COMMIT, readable protection whitelist, guard exclusion, Read/WriteProcessMemory counts | A/B/E | Windows x64 ABI and memory-safety assumptions retained; these are platform checks, not build fingerprints. |
| 29-weapon policy / 32 resource entries, seven profile groups, mode/cadence metadata | A | Byte-identical policy and controller to baseline. Stable identities are not proof that a future build preserves the selected weapon semantics. |

There are no EXE native RVAs in FAA. Its EXE fingerprint is still retained because
this fallback has not established a replacement capability policy for changed
client behavior. Removing it is future work, not a claimed result here.

## Runtime model and cost

`compatibility.select()` chooses a private known-profile token or an unsupported
diagnostic. `resolve()` checks module extent and converts all known global/anchor
RVAs into addresses. Native/UI adapters accept profiles issued by that module,
not caller-supplied ID strings. Layout version `faa-25480438-v1` describes the
unchanged observer, UI and mapping algorithms; offsets without alternative
implementations remain local to those algorithms.

Known-build logs contain `compatibility=known_profile`, `build=25480438`.
Unknown logs contain `compatibility=unsupported`,
`reason=capability_evidence_missing` and the 12 missing capability identifiers.
Unreadable/invalid hashes use `module_fingerprint_unavailable`. Logs contain no
memory dumps. Capabilities describe retained checks, not completed gameplay proof.

No scanning occurs, at startup or per frame. Startup gains small Lua table
construction and one log entry. Existing observer/read caching and mapping loops
are unchanged. No measured performance claim is made. Object presence remains a
per-observation condition, allowing startup before an avatar exists, as v1.0.0 did.

## Offline tests and limits

The canonical runner passes 20 groups: the existing 16, unknown-identity zero-access
startup tests, identical lifecycle fixture replay against the public v1.0.0
commit, byte-for-byte preservation of seven behavior modules, and evidence-tool tests. The native lease suite still checks all mapping bytes, intervals, axis
exclusion, conflicts and partial rollback. The evidence tool has separate matching,
mismatching and truncated synthetic sample tests, none of which authorize runtime.

| Requested case | Actual status |
| --- | --- |
| A known hashes + known layout | Pass in known profile/lifecycle/native fixtures. |
| B unknown hashes + same synthetic layout -> enabled | **Not implemented**. Unknown hashes reject even if existing byte windows match. |
| C missing native signature | Unknown startup rejects with zero native access; a missing-signature resolver test cannot run because no resolver is approved. |
| D ambiguous native signature | Same fail-closed boundary; ambiguity detection is **not implemented** or claimed. |
| E resolved globals + invalid structure | Existing known-build observer invalid-layout/backref/race fixtures pass; unknown resolved-global path is unavailable. |
| F wrong writable layout | Known-build native fixture rejects before writes; unknown builds reject before backend creation. Unknown resolution/layout validation is unavailable. |
| G unknown hashes + valid lease | **Not implemented**. Known-build controlled lease/restore tests pass. |
| H v1.0.0 behavior | Existing suite and same public-release lifecycle fixture pass offline. New source has not been live-tested. |

## Tooling and package

Run `python HD2FullAutoAssist/scripts/audit_compatibility_evidence.py --output <report.json>`
for an inventory. Optionally add `--image <module-rva-capture.bin> --sample-build <label>`.
The tool hashes the sample, reads only four fixed windows, and reports match,
difference or out-of-capture. It neither scans nor opens a process, decodes heap
pointers, approves patterns, or proves layout. Caller-provided build labels are
explicitly unverified. Supply a module-RVA image, not a disk-layout DLL.

The builder writes only `build/compatibility-scaffold/`, with
`Full-Auto-Assist-compatibility-scaffold-Arsenal.zip` and development metadata
`1.0.1-dev`. It does not overwrite the public 1.0.0 ZIP or declare this scaffold
live-validated. There is no `Full-Auto-Assist-1.0.1-Arsenal.zip` release candidate.
Do not publish the scaffold as the requested compatibility update.

## Evidence required before completing automatic compatibility

Obtain bounded, provenance-backed code windows from 25480438 and a second build
for all eight global xrefs and their semantic consumers. Establish masked patterns,
section/range restrictions, complete match counts, and independent disambiguating
relationships. Prove identity layout, UI/text/focus and game-state semantics,
normal Fire action lookup, 328-byte bucket / 20-byte mapping layout and field
consumers, trigger enum/repeat handling, and supported weapon policy semantics.
Validate actual downstream object ownership/backrefs with read-only observations.
Do not use a trial mapping write to establish layout.

Only then implement startup resolution and cases B through G against realistic
captured fixtures and mutations. Keep release blocked until read-only unknown-build
proof precedes any write, every unsafe case fails closed, and restored mapping bytes
are independently verified.

## Exact live validation before any release

On known build 25480438, explicitly deploy the development artifact only when the
user is ready. Confirm default ON, first hold/release, all 29 supported identities,
seven profile groups (unchanged cadence/heat/audio behavior), `=` and optional
Mod Bindings Menu toggle, OFF/ON persistence through mission transitions, swap and
player changes, menu/chat/cursor/focus loss, death/respawn, return to ship and shutdown.
Confirm native Full Auto, unknown resources and controller axes remain vanilla;
confirm reload and charge behavior are unchanged. Verify exact mapping restoration
after each lease and inspect compatibility/error logs.

After the resolver is completed, repeat on the separately evidenced second build,
first read-only, then with explicitly authorized writes. No game process, deployment,
injection, live-memory probing, HUD work or publication is part of this development
pass. Passing this scaffold's tests alone cannot clear the release gate.
