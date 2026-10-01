# Eruptor OFF investigation: closed

The original interpretation was wrong. On 2026-10-01 the user reported a fresh vanilla validation with game files verified, no mods and no Shared Loader: Eruptor natively continues firing while Fire is held through its bolt cycle, near the native 32 RPM cadence.

RC3 OFF restoration therefore does not need to stop that native repetition. FAA ON supplies controlled cadence; OFF restores the original mappings and gives control back to the game. The RC3 log's zero errors/conflicts and inactive lease at shutdown are consistent with this. No speculative restore or native-state reset was added.

The independently reproduced ownership-retention defect remains fixed and regression-tested. It is not evidence that vanilla Eruptor repetition is a bug. Mechanical action, displayed mode and held-input semantics must be documented separately. The original investigation is preserved in Git at 8fbe8d4.

Current blockers are charge input/completion evidence and measured live performance, described in COMPLETION_CHECKPOINT.md. The approved HUD is frozen. The user-reported approximately 50 ms/s is the current live baseline; the old approximately 14 ms spike is not the acceptance benchmark.
