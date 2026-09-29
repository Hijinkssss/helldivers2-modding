# P-92 Warrant support decision

**Decision: deferred.** The Warrant remains unsupported and fail-closed. The
available exact-build data resolves its identity and several authored weapon
fields, but it does not establish the input and mode behavior required by Full
Auto Assist's eligibility rules. No policy entry, special controller, Arsenal
option, or development package was added.

## Evidence inspected

The repository's targeted expansion notes point to HD2Runtime audit commit
`fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`, using snapshot
`F5FEE03DCFDB-20260926T222226Z.hd2snap` (Steam build 25480438). The pinned
Runtime receipt in `validation/HD2Runtime-audit-2026-09-28.json` records the
same executable and game DLL fingerprints as the FAA exact-build gate.

The authoring catalog resolves **P-92 Warrant** uniquely to resource
`0xCF8934FF6567A42D`. It reports `fire_rate=450`, `primary_fire_mode=3`, and a
conventional projectile attack. The composition catalog reports native mode
vector `[3,0,0]`, an empty `allowedModes` list, and
`defaultModeSemantics="family_specific_or_unresolved"`. Its reason says that
the catalog only treats conventional weapons with both native values 1 and 2
in the vector as writable; the Warrant is not in that set. The vector therefore
cannot be safely translated into guided/unguided or burst semantics from this
evidence alone. The 450 RPM value is authored metadata, not a measured or
confirmed accepted native cap.

The composition catalog identifies the attack as `conventional_plain`, reports
no heat mechanism, and exposes the magazine as the simple API. The separate
ammo research resolves a capacity of 13 plus magazine supply counts. These
records describe authored composition; they do not establish whether explicit
Reload input is required between ordinary accepted shots, or whether a
repeated Fire input is sufficient to continue legal bursts.

The user-reported three-round burst, guided/unguided behavior, held-Fire lock
acquisition, and absence of a separate cancel-lock input are retained as
observations only. They are not independently proven by the checked-in FAA
evidence or the pinned Runtime catalogs.

## Eligibility fields still unresolved

- The meaning of native mode value `3`; whether the Warrant has a native Full
  Auto path; and how the player changes between guided and unguided behavior.
- Whether ordinary Fire alone initiates the next legal burst in both modes, or
  whether a separate alt-fire or other input participates.
- Whether Reload input is needed between accepted shots or bursts in normal
  operation.
- Whether holding/repeating Fire can interfere with acquisition, guidance,
  target selection, or launch permission, and whether the game remains fully
  authoritative over all of those steps.
- The accepted native cadence. `fire_rate=450` is recorded as metadata only.

Without those facts, neither native Full Auto exclusion nor safe
Amendment-style repeated-Fire eligibility is proven. No Warrant tests can
truthfully assert either mode path without inventing unverified mechanics.
If later exact-build evidence establishes eligibility, the default Balanced
calculation would be `min(450, 380) = 380 RPM`; this is conditional metadata,
not a Warrant policy setting.

## Next evidence needed

Use current-build authoring/composition records or a focused exact-build trace
to resolve mode meaning and inputs. Then use a controlled live test to establish
that ordinary Fire can be repeated without Reload, mode changes, or any
interaction with the game's guidance and lock state. Until both static and
live evidence are available, Warrant must remain unmapped and unaffected.
