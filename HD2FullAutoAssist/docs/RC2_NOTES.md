# RC2 feedback changes

The user reports successful Balanced play on P-2 Peacemaker, P-113 Verdict,
M6C/SOCOM, P-69 Veto, R-63 Diligence, R-63CS Diligence Counter Sniper and
APW-1 AMR. Liberator, Quasar and Laser Cannon negative controls passed.
This report applies to reference commit a93008f, not the standalone refactor.

## Talon: previous 60 RPM candidate

The reviewed build-25480438 Runtime catalog records heat capacity 100,
15 heat per shot, 10 cooling per second and a 750 RPM native cap. See
`talon-heat-evidence.json` for the pinned primary source and digest.
At 380 RPM, nominal input heat is 95 units/second; at 60 it is 15.
If cooling runs continuously at the recorded rate, net heat falls from
85 to 5 units/second. This is a conditional model, not a gameplay guarantee.
Nominal neutral cadence would be 40 RPM. Cooling delays, planet conditions,
held-Fire behavior and actual accepted shots have not been established here.

RC3 promotes 210 RPM to Balanced from the discrete-shot model documented in
`talon-heat-evidence.json`; 60 RPM remains the Efficiency profile. The model
predicts shot eight reaches 100 heat if cooling is linear during intervals.
Live play is authoritative. Talon's additional profiles are 380 RPM and the
750 RPM native cap.

## Amendment v0.1 limitation

Holding Fire chains bursts continuously into full-auto-like output. The game
still controls burst internals; repeated Fire starts the next legal burst.
The validated behavior is preserved. No special burst timing is implemented.

## AMR roadmap

Balanced remains the live-tested 120 RPM. Future optional per-weapon modes:
Recenter (recoil recovery friendly), Balanced (120 RPM), and FULLER AUTO
(native 400 RPM cap). Native Cap already selects 400 RPM through the INI.
No per-weapon UI is included in RC2.
