# P-92 Warrant support and RC1 validation

**Integrated in unreleased main; RC1 passed live validation.** The Warrant is
supported through the existing held-Fire controller. The
previous deferral treated unresolved mode and guidance internals as required
implementation evidence. That was stricter than FAA's actual contract. FAA
does not inspect those internals; it repeats ordinary Fire, and the game owns
whether each input produces a legal shot.

## Exact-build metadata

The pinned HD2Runtime audit is commit
`fd0c0d2b5618807a1ff63bedc9ed2f4b807c7595`, using snapshot
`F5FEE03DCFDB-20260926T222226Z.hd2snap` (Steam build 25480438). The pinned
Runtime receipt in `validation/HD2Runtime-audit-2026-09-28.json` records the
same executable and game DLL fingerprints as the FAA exact-build gate.

The authoring catalog resolves **P-92 Warrant** uniquely to resource
`0xCF8934FF6567A42D`. It records native mode vector `[3,0,0]`, authored
`fire_rate=450`, magazine capacity 13, and a conventional projectile attack.
The static catalog does not decode the meaning of mode value 3. RC1 does not
need that meaning because it neither reads nor changes fire mode. The authored
rate is treated as the policy cap metadata; Balanced is the existing default
calculation `min(450, 380) = 380 RPM`. Actual accepted firing remains governed
by the game and must be checked live.

## External firing contract

The player selects Guided or Unguided mode. Unguided behaves as a burst pistol.
In Guided mode, the player must aim and acquire a valid target; the game
controls whether a lock exists and whether a Fire input is accepted. Repeated
ordinary Fire does not create a lock or bypass the native lock requirement.
With a valid lock, ordinary Fire inputs can continue to launch legal shots or
bursts. Continued aiming while Fire remains held can let the game acquire a
subsequent target and accept later inputs. This behavior is already
reproducible with an ordinary mouse auto-clicker. These are user-established
external gameplay observations and are the reason this candidate proceeds;
they are not claims about the decoded internal mode or guidance implementation.

The implementation only adds the Warrant identity and policy metadata. It
reuses the existing repeated ordinary-Fire controller, release handling,
weapon-swap guard, OFF behavior, and unknown-identity fail-closed path. There is
no Warrant-specific controller and no target, lock, guidance, aim, reload,
projectile, or fire-mode automation.

## RC1 live validation result

The mod author live-tested the Warrant RC1 and reported a pass in the actual
game. Confirmed results:

### Unguided

1. Launch with Warrant equipped, select Unguided, and enable FAA.
2. Hold Fire; confirm native bursts repeat and native burst cadence remains intact.
3. Release Fire; confirm firing stops immediately.

### Guided without a lock

4. Select Guided and aim somewhere without a valid target lock.
5. Hold Fire; confirm the Warrant does not fire without a lock and FAA does not create or select a target.

### Guided with a valid lock

6. Acquire a valid target normally by aiming; keep Fire held.
7. Confirm the game accepts legal launches or bursts only when its native lock requirements are satisfied, with guidance remaining native.

### Successive targets and safety

8. Keep Fire held after the first target is finished; aim so the game can acquire another target and confirm later legal inputs are accepted without releasing the physical trigger. Target acquisition must remain game-controlled.
9. Release Fire and confirm attempts stop.
10. Reload normally and confirm FAA does not automate reload.
11. Swap weapons and confirm assistance resets safely.
12. Test one known-good existing burst weapon and one unsupported weapon; confirm both retain their expected behavior.

Guided and Unguided modes both work with FAA. Native lock requirements remain
game-controlled. FAA does not bypass target locking, automate guidance or
target selection, or switch firing modes. Repeated ordinary Fire is sufficient;
no Warrant-specific gameplay controller is needed. No internal-state tests are
added because FAA does not observe those states. Offline controller tests cover
the same ordinary Fire path, release, swap, OFF, unknown-identity, and
fail-closed behavior for the Warrant.
