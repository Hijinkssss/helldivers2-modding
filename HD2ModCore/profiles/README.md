# Build profiles

The executable profile is `src/hd2modcore/example_profile.lua`, bundled as source. This directory documents it rather than duplicating a second authority. Its retained ID `steam-25480438-v02-candidate` is a compatibility identity used by experimental consumers; it is not the release version.

Steam build: 25480438; EXE: 1.8.46015.0.

- EXE SHA-256: `F5FEE03DCFDB2E553A4752C283590950AC13316B376D8196AA556FF0400D5F06`
- game.dll SHA-256: `2E2C3B7C2500646DADD5F2B4C6E0504DBB7E7896139F64CDDC0D1813C718F51E`

Both hashes must match. The schema retains source-only evidence and empty capabilities because selected ship observations do not establish stable player/equipment semantics. `degraded` is expected for this profile. Public bounded reads require a selected profile; eligibility additionally checks native code bytes and stable UI state. No proprietary module is distributed.

New profiles require independent current-build provenance, bounds/anchor tests, changed/unavailable-state refusal and separately recorded live scope. Never copy historical offsets into an unobserved build.
