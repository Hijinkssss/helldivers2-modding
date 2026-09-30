# Full Auto Assist 1.1.0 research RC4 (unpublished)

This is a one-weapon, read-only research build for the 40-K Meltagun. It adds a
bounded native resource-settings fallback to the charge observer, records an
independent Windows left-mouse-button sample beside the processed Fire action,
and reports the exact bounded charge-row lookup outcome when that row is absent.
It does not automate Fire or change gameplay behavior.

The research log retains the prior charge, trigger, ammo and beam samples. The
additional `fire.raw_lmb` field reports `down`, `up`, or `unavailable`; it is
explicitly marked independent of processed Fire and **does not claim that the
left mouse button is the active Fire binding**. `physical_binding_verified`
remains false. The targeted manual observation must use the default left-mouse
Fire binding so the raw Windows sample can be compared with the native processed
Fire fields.

The charge settings reader first honors a matching per-instance override. If no
override exists, it follows the exact-build stock getter's 20-slot resource-hash
table at `owner(global 0x346bf98)+0xf12ad8`, then reads the selected 216-byte
settings record at table `+0x140`. It captures only the previously selected 24
bytes and labels their source. It does not infer readiness from the values.

For an absent charge row, the probe logs the held entity ID, row count, 56-byte
table header, and bounded lookup count. It does not search the heap or try a
different entity. Beam completion remains unresolved unless this exact row is
observed and correlated with the visible beam ending and a later manual cycle.

This build requires Bingus Shared Loader v18 / API 1. It does not bundle Core or
Runtime. The probe samples only the Meltagun, stops at 6,000 relevant samples,
and remains developer-only. All five charge weapons remain disabled for
automation. Existing FAA weapon policies, Eruptor profiles, and HUD are
unchanged.
