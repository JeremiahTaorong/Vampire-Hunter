# Evidence inspection UI — 2026-11-06 Asia/Shanghai

Scope: independent Demo only, explicitly requested in the current chat. No formal Task Registry exists; DEMO-INSPECTION-20261106 is an evidence label, not a future approved task ID. Official systems remain 0/13 approved; T01–T16 unchanged.

## Design traceability and copy

GDD v4 prologue investigation R53/R59 and narrative method §9; F23 environmental storytelling, F24 art direction, F27 English UI; SCM N-P and S01/S08/S09/S11/S13 cooperation. Narrative v2 III: worn mentor's emblem, missing villagers, blood/drag traces into forest. The user's current request authorizes the Demo inspection presentation. The two English stories are draft wording, not newly frozen story facts: badge recalls Elias Voss; arm identity and survivor outcome stay unknown. Existing witness/conclusion gates unchanged. No inventory or new rewards.

## Implementation

Scene Assets/Demo/Scenes/PrologueSettlement_TerracedInteriors.unity. Trail root moved to actual arm renderer center (32.15,2.64,-1.52); child world transforms preserved. Box size about (0.78,0.37,1.10) now covers arm with small selection margin rather than the larger blood pool. Range 2.8 m and clueId trail retained. Marker repositioned above arm and label changed to SEVERED ARM. Existing 12-stain cluster and badge remain.

EvidenceInspection added to trail/emblem. Activation still records original clue through DemoInteractable, then opens a full-screen modal. Scene camera captured at quarter resolution with 9-tap GPU blur repeated through ping-pong buffers; dark overlay, large interactive 3D preview, title and two story paragraphs. Model uses isolated layer 30, temporary camera/lights/render textures. Badge faces camera; arm uses existing mesh/materials. Drag rotates; return button/Escape closes. All temporary objects/textures cleaned on close/disable/destruction. Prior camera mask and time scale restored, including pre-existing half-speed pause ownership. Movement/enemy/health/flow update and old HUD are gated during inspection; a short close-frame input guard avoids clicking through. Opening cancels pending navigation. No new paid assets, packages, network dependencies.

## Actual runtime evidence

WindowsEditor Unity 2022.3.62f3 DX11; base Git commit 067a9e882ea5ca94e314030a91e7873dda99a020 plus uncommitted earlier blood/badge/arm work, this inspection work, and four pre-existing user material changes (preserved). Final automated Play Mode run starts 2026-11-06 17:07:20 Shanghai. playmode.txt: PASS, logical exit_code=0; editor stays open. Inspector adds a temporary InspectionProbe, invokes real ray selection at each model's bounds center, actual NavMeshAgent path and BeginInteraction, waits for activation, checks clue recording, time freeze/position/HP stability, blocked dodge, supported blur/created preview textures, duplicate Open stability, close/reopen, prior .5 time-scale restoration, 12 stains and marker hidden. Both emblem and trail pass all checks. Story lengths 462/407 characters. No Error/Exception/Assert captured in probe interval.

Screenshots emblem-inspection.png and trail-inspection.png are actual ScreenCapture outputs including UI at 2560x1440. Screenshots were visually reviewed. Initial emblem-first-visual-issue.png records backwards default badge plus incomplete early text capture; default orientation corrected, final captures verify front/cross and complete text. First/second logs retained, final log corresponds to final gameplay code.

Scoped native input verification after probe removal: badge opened using editor review command; actual mouse drag visibly rotated it; actual Return to investigation button restored game. Arm review opened and actual Escape restored game. Editor helper warped player to near arm (test setup only); actual mouse clicked visible arm at window coordinates (1154,453), game showed Approaching evidence, then opened correct arm story. os-arm-open-status.txt confirms open=True, correct title, scale=0. Actual Escape closed again. No OS input was simulated in automated probe; these native checks are additional. World traversal from original spawn was not retested.

Final probe removed; scene saved/reopened, editor stopped Play Mode (saved.txt). Probe GUID absent from saved scene. Shared complete editor session log copied to editor-session.log; prior unrelated warnings outside probe interval remain in log.

## Limitations and recovery

Story copy/art await user review. No complete prologue walkthrough, combat encounter during modal, independent build, performance profiling, alternate aspect ratio/device or exhaustive re-entry tests. Health stability in paused test does not replace a combat playthrough. Official tests remain unexecuted.

Before files: before/Demo*.cs and scene-before.unity.txt here; management snapshot Backups/DocsSync/20261106T165922971690. Scene changes and new scripts/shader are uncommitted. No push/publication. Reopen the scene and press Play; click badge/arm, let hunter approach, drag object, read story and close via button/Escape.
