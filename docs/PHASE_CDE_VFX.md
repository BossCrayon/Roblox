# Phases C–E — all pathway ability presentation

[EXISTING] Phases C, D and E are implemented in source and included in the rebuilt `studio/Mysteries.rbxlx`. All 54 registered abilities have explicit composition recipes and per-ability cast-pose selections; none of the registered roster relies on the generic fallback. This describes completed code, not Studio-certified appearance or performance.

[EXISTING] Phase C supplies all 18 Seer packages; Phase D all 18 Marauder packages; Phase E all 18 Apprentice packages. Gameplay balance, damage, cooldowns, potion rules, server hit decisions, teleport eligibility, control limits, persistence and administrator permissions are preserved. Source changes in the server observe actual outcomes rather than authorize outcomes from visuals.

[PROPOSED] Full HUD/Journal skins, permanent world-label replacement, the enlarged Victorian world, player outfit kit, enemy rig/silhouette redesign and guaranteed attack telegraphs remain Phases F–I. This pass adds only the status/charge UI necessary to read the existing powers.

## Assets, lore and framework

[EXISTING] The original twelve animation states and eleven primitives remain in use. A pooled SigilStencil from Phase B plus four new native-geometry blocks—CardFan, PaperFold, VeilRibbon and ContourEcho—supply the extra vocabulary. New profiles select shoulder/root/neck overlays within the existing controller; they do not disable default Animate or move HumanoidRootPart.

[EXISTING] Every pose/asset slot remains empty, every supplied sound ID remains 0, and no mesh/texture/animation/sound ID was invented. Empty particle textures use geometric motes. All shapes, gestures and color choices are original art direction. Existing lore metadata remains [UNVERIFIED]. Broad concepts such as paper substitutes, threads, historical projection, theft and spatial travel inspire the designs; exact combat effects and uncertain named powers are gameplay interpretations, not claims of verified canon.

[NEEDS NEW ASSET] Optional original foley, polished uploaded cast animation and custom texture/mesh polish can replace the defaults later. None is required to run these 54 packages. Trigger sound hooks are explicitly `Trigger.SubstituteTriggered`, `Trigger.GraftReflected` and `Trigger.PayloadTriggered`; their numeric bindings in Theme default to 0.

[EXISTING] Theme owns UI colors/fonts/sizes and sound bindings; AnimConfig owns pose/timing/asset overrides; VfxConfig owns geometry, pools, quality and protocol limits. Palette remains Seer fog/purple/gold; Marauder black/crimson/bronze; Apprentice teal/silver/starlight.

## Ability-by-ability source coverage

[EXISTING] All animations below are procedural, with optional empty uploaded-asset overrides. Windup is **0.50 seconds at Sequences 9–5** and **1.50 seconds at Sequences 4–1**, matching the unchanged authoritative cast times. The duration column is the release pose; cosmetic fades/compositions can continue afterward without adding an input lock. Each row's exact visuals are original interpretations. [UNVERIFIED] applies to unverified names/placement/scope throughout the project.

### Phase C — Seer / Fool

| Status | Seq / ability | Release | Implemented composition and evidence |
|---|---|---:|---|
| [EXISTING] | 9 Divination | 0.22 s | Blank card fan, small reading circle and star; obscured readings use an incomplete split mark with no invented reveal. |
| [EXISTING] | 9 Spirit Vision | 0.18 s | Eye stencil and reading circle; only server-authorized private outlines, with low/mobile eye-only fallback. |
| [EXISTING] | 8 Acrobatic Evasion | 0.20 s | Departure contour and ankle ring, destination seal; actual server dodge remains the only movement. |
| [EXISTING] | 8 Composure | 0.25 s | Chest seal and stable ground reading mark; actual buff has an owner-only badge. |
| [EXISTING] | 7 Flame Jump | 0.18 s | Warm geometric embers and fog-grey rings at real departure/arrival. |
| [EXISTING] | 7 Paper Figurine Substitute | 0.24 s | Folded paper figure when armed; separate server-confirmed lethal substitute trigger breaks the paper into pieces. |
| [EXISTING] | 6 Disguise | 0.30 s | Narrow face veil, contour and eye mark around the existing permitted appearance change. No new species transformation. |
| [EXISTING] | 6 Voice Mimicry | 0.20 s | Collar veil, fine throat-level arc and seal; existing permitted voice-profile/disguise behavior remains unchanged. |
| [EXISTING] | 5 Spirit Body Threads | 0.25 s | Fine gold links and knot mark; private live badges show actual 1/3 and 2/3 stages, public marionette mark only after real control. |
| [EXISTING] | 5 Marionette Command | 0.18 s | Caster-to-marionette thread and a second link to the actual struck victim supplied by the server. |
| [EXISTING] | 4 Marionette Exchange | 0.18 s | Opposing endpoint contours and connecting thread around real exchange coordinates. |
| [EXISTING] | 4 Bizarre Illusion | 0.32 s | Confirmed area border and up to three decorative contours; low/mobile uses one. No clone has a hitbox. |
| [EXISTING] | 3 Historical Projection | 0.35 s | Veil/contour/reading circle at the actual summon; local fog tint/transparency dresses the real existing NPC until expiry/removal. |
| [EXISTING] | 3 Historical Recall | 0.30 s | Offset past-self contour aligns inward with a thread and eye mark; no time/position rewind is invented. |
| [EXISTING] | 2 Wish Fulfillment | 0.35 s | Gold seal, quiet reading ring and motes only after actual recovery/wish-credit success. |
| [EXISTING] | 2 Miracle of Recovery | 0.35 s | Two inward threads and a recovery star; preserves real need/credit checks. |
| [EXISTING] | 1 Grafting | 0.25 s | Knot mark plus links to actual affected enemies; reflected-hit cue is a distinct confirmed trigger. |
| [EXISTING] | 1 Realm of Mysteries | 0.40 s | Sparse actual-radius boundary and edge veils; affected Stasis badges. No Sefirah Castle or extra authority claim. |

### Phase D — Marauder / Error

| Status | Seq / ability | Release | Implemented composition and evidence |
|---|---|---:|---|
| [EXISTING] | 9 Pickpocket | 0.16 s | Bronze split diamond pulled along a curved crimson line after real one-time theft. |
| [EXISTING] | 9 Stealth | 0.20 s | Compact offset frame and narrow veil; does not grant invisibility. |
| [EXISTING] | 8 Deception | 0.20 s | Head-side split diamond and offset frame, with confirmed Confused marker. |
| [EXISTING] | 8 Misdirection | 0.18 s | Lateral false frame connected by a thin red cut; no fake attack or position change. |
| [EXISTING] | 7 Decipher | 0.25 s | Book/pattern stencil, split mark and reading circle; owner-only real CipherSight state. |
| [EXISTING] | 7 Information Interpretation | 0.22 s | Bronze split reading mark and compact offset frame; sensing targets remain private. |
| [EXISTING] | 6 Ability Theft | 0.22 s | Server-selected capture/release directions, stored-power slot diamond and Journal description. |
| [EXISTING] | 6 Energy Theft | 0.25 s | Crimson siphon, small caster motes and target cut; no invented recovery quantities. |
| [EXISTING] | 5 Thought Theft | 0.20 s | Head-side missing fragment pulled inward; actual Sleep status is labelled truthfully. |
| [EXISTING] | 5 Dream Intrusion | 0.25 s | Crimson cut, sparse ember-like motes and split mark. Current gameplay is damage/Burning, not a dream world. |
| [EXISTING] | 4 Parasitism | 0.25 s | Needle-like link, host mark and veil; private host status, no player possession or marionette ownership claim. |
| [EXISTING] | 4 Vitality Siphon | 0.30 s | Two converging host-linked strands and caster ring; requires the actual eligible host. |
| [EXISTING] | 3 Spiritual Deception | 0.25 s | Offset frame and crimson spiritual-reading mark; actual Deceived state only. |
| [EXISTING] | 3 Belief Misdirection | 0.30 s | Veil, single ownership link and split mark; public control badge follows real NPC ownership. |
| [EXISTING] | 2 Destiny Infiltration | 0.20 s | Paired cuts at true departure/arrival, arrival contour and target payload mark. |
| [EXISTING] | 2 Hidden Destiny Payload | 0.22 s | Small armed split/link; distinct crimson unfolding/star effect only when the server actually triggers the payload. |
| [EXISTING] | 1 Time Theft | 0.25 s | Incomplete tick stencil, transfer strand and removed segment; NPC speed follows real TimeSlow. No global clock change. |
| [EXISTING] | 1 Temporal Delay | 0.35 s | Actual area border, separated tick mark and controlled offset frame; Stasis state is server-owned. |

### Phase E — Apprentice / Door

| Status | Seq / ability | Release | Implemented composition and evidence |
|---|---|---:|---|
| [EXISTING] | 9 Door Opening | 0.25 s | Frame fits the actual selected door dimensions/orientation, with a small key mark. |
| [EXISTING] | 9 Passage Sense | 0.20 s | Palm key and star; only granted passages receive private outlines. |
| [EXISTING] | 8 Spark Trick | 0.16 s | Small four-point mark and short cast-to-target link, plus actual damage/Confused feedback. |
| [EXISTING] | 8 Wind Trick | 0.25 s | Two silver/teal curved strands and the real effect-radius border; no cosmetic knockback posing as gameplay. |
| [EXISTING] | 7 Astrological Divination | 0.28 s | Star reading, small circle and connecting trace; obscured results stay incomplete. |
| [EXISTING] | 7 Danger Reading | 0.22 s | Narrow body-side arch and head star; actual Shielded state remains a bounded gameplay interpretation. |
| [EXISTING] | 6 Record | 0.30 s | Book stencil at the observed target, inward link and palm threshold. Actual power ID and three charges appear in owner UI. |
| [EXISTING] | 6 Release Recording | 0.20 s | Palm book, outbound line and target star; charges decrease only through the existing server executor. |
| [EXISTING] | 5 Travel | 0.20 s | Matching thresholds at confirmed endpoints, individually culled. |
| [EXISTING] | 5 Spatial Door | 0.30 s | Paired activation key marks; persistent plain/nested teal frames dress the actual server gate pair. |
| [EXISTING] | 4 Concealment | 0.35 s | Body threshold, narrow veil and key mark; no additional character invisibility. |
| [EXISTING] | 4 Spatial Seal | 0.30 s | Actual-radius outline and sparse threshold corners; low/mobile reduces corners. No physical wall is added. |
| [EXISTING] | 3 Wandering | 0.25 s | Depth-separated threshold pairs; simplified endpoints on low/mobile, actual Concealed status only. |
| [EXISTING] | 3 Spatial Concealment | 0.30 s | Compact inner doorway, veil and chest star; stationary under Reduced Motion. |
| [EXISTING] | 2 Replication | 0.30 s | Double book stencil, outbound link and confirmed phenomenon star; uses the actual allowlisted recording. |
| [EXISTING] | 2 Planar Travel | 0.30 s | Tall paired thresholds and endpoint stars around actual travel. Does not create a separate plane or live portal view. |
| [EXISTING] | 1 Star Gate | 0.40 s | Star activation plus persistent nested gate frames/top stars around the actual server pair. |
| [EXISTING] | 1 Spatial Closure | 0.30 s | Boundary, compact closing threshold and key mark; confirmed GateRemoval releases existing frame presentation. |

## Lifecycle, privacy and budgets

- [EXISTING] Server Result metadata names actual area radius/affected targets, summoned echo, thread count/control state, recorded power/charges and gate references/expiry. No client-selected outcome is accepted.
- [EXISTING] A read-only scan runs on the existing server tick. It sends status transitions/removals when owner, effective expiry or thread stage changes; unchanged state produces no per-frame remote stream. It never deletes or changes gameplay statuses.
- [EXISTING] Thread stages, parasite host, hidden payload, disguise/concealment, perception and self-buff statuses are caster-private. Actual NPC control and visible combat statuses may be public. The client independently rejects foreign private receipts.
- [EXISTING] Public/private transitions carry increasing revisions; stale receipts cannot revive removed badges. Late-join Sync respects privacy, is separately throttled to five seconds, and caps replayed status entries at 64. Active gate/echo snapshots support clients joining after activation.
- [EXISTING] Status widgets are pooled, maximum four desktop/two mobile, visible within 40 studs and the viewport. Priority/nearest sorting chooses readable states. Long buffs become labels rather than occupying a 3D effect slot indefinitely.
- [EXISTING] Gate frames share the same world VFX budget as casts. The old pane is hidden locally only while a replacement lease is admitted; budget denial or quality/culling cleanup restores the real pane. Collision, query, ownership and Enter prompt remain untouched. Frames renew in leases of at most eight seconds until actual expiry/removal.
- [EXISTING] Echo styling modifies only local color/transparency on the real historical NPC. Expiry, owner cleanup or model removal restores/releases local state; no extra combat NPC is created.
- [EXISTING] Core active caps remain 4 low / 8 medium / 16 high, capped at 8 mobile. All pooled cosmetics still obey the viewport/120-stud cutoff and desktop/mobile instance caps. No shadowed PointLight is introduced. No effect fills the screen with a solid field.
- [EXISTING] Reduced Motion keeps silhouettes and slow fades but removes moving fragments/contours, transfer travel, jitter, camera effects and flashes. Low/mobile reduces cards, paper/contour pieces, veil ribbons and paired depth layers. Screen flash opacity stays capped at 0.16.

## Full code and Explorer placement

[EXISTING] `docs/PHASE_CDE_VFX_CODE.md` contains complete production scripts, classes and exact Explorer paths, followed by the Studio tests below. `docs/PHASE_CDE_SCRIPTS.json` is the manifest. Install against the existing Mysteries foundation with Play stopped and replace same-name scripts. `docs/FULL_SOURCE.md` covers a blank place; `studio/Mysteries.rbxlx` already contains everything.

[EXISTING] The new helper is a **ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/Choreography`. Existing `PathwayEffects/Seer`, `Marauder`, `Apprentice`, animation/config, status/event modules and the test room are extended rather than replaced by parallel systems.

## Cloud verification

[EXISTING] 9,617 assertions passed, including 1,336 ability/status/privacy/lifecycle assertions. All 62 production/test Luau files compile, strict Roblox API/type analysis passes, and the Rojo build contains source-identical copies of all 49 ModuleScripts plus the server/client entrypoints. Late-join status sync receives fresh revisions so intervening live receipts cannot suppress still-active statuses.

[PROPOSED] Rendering, physics, real multiplayer networking, mobile frame time and real DataStore behavior still require Roblox Studio. The checks below verify appearance and engine behavior; no rendered result is claimed here.

## Studio checklist

### Shared setup and visual pass

1. [PROPOSED] Download the fresh tracked place with Download raw file, open through Studio File → Open from File and Play as the configured account. Open ADMIN/F8 → Studio VFX test room. Use the new 1/54 selector, Next/Previous and its Preview button. Existing six quick-access buttons and all original primitive/animation previews remain available.
2. [PROPOSED] Preview all 54 powers in sequence. Body poses run on your avatar while cosmetics use the local mannequin/stage. These previews do not grant powers, teleport you, alter inventory or broadcast gameplay. Preview area radius is intentionally a small stage value; real casts use the actual server radius.
3. [PROPOSED] Repeat representative low/middle/high sequence powers in Low Graphics and Reduced Motion, then grayscale. Check that paper, threads, offset diamonds and door frames remain distinguishable. No blank texture squares, full-screen fields, shadows, rapid blinking or camera/input lock should appear.
4. [PROPOSED] Check R15 and R6 where supported. Cancel windups, walk/jump afterward, respawn three times and reopen previews. Default Animate must continue without joint drift. Selecting a cast profile or importing a real animation must not move HumanoidRootPart through cosmetic code.

### Phase C — Seer tests

5. [PROPOSED] Real Divination/Spirit Vision: test successful and obscured readings and an empty area. Compare caster and observer views: private perception outlines must not leak. The card fan is original blank geometry, not uploaded tarot art.
6. [PROPOSED] Real Acrobatic Evasion/Composure: verify actual dodge displacement/invulnerability and resource costs remain unchanged; the contour never creates an extra dodge. The Composed badge must expire with its real buff.
7. [PROPOSED] Arm Paper Figurine Substitute. The small paper figure means armed, not consumed. The paper-break effect must occur only when an actual lethal hit consumes it. The dedicated test-room trigger is a local preview, not evidence that the real buff fired. A second lethal hit without rearming must behave as before.
8. [PROPOSED] Disguise and Voice Mimicry: check both existing profiles, expiry, advancement and admin-switch restoration of display name/colors/scales. Veils must not change species, grant invisibility or leave extra accessories behind. Sound slots remain silent until original IDs are supplied.
9. [PROPOSED] Seer/5: select an eligible weaker/equal-sequence hostile NPC and apply threads with the actual cooldown. Observe 1/3 → 2/3 privately; a public Marionette mark appears only after actual control. Test two-owner observations, thread expiry, stronger-target rejection, summon limit, command with/without a real nearby victim, exchange under threat and owner death/admin cleanup.
10. [PROPOSED] Historical Projection: read Hidden Archive first, summon, inspect fog tint and decorative contour, then expiry/cleanup. No extra combat summon may appear. A second client joining while the echo exists should receive its appearance snapshot. Historical Recall should show success only when recovery is actually possible.
11. [PROPOSED] Wishes: the admin selector deliberately preserves earned wish credits. Earn a credit from an actual successful acting objective first, switch to Seer/2, sustain real damage or sanity loss, then test each recovery wish. Full-health/full-sanity or insufficient-credit attempts must cancel without a success effect or extra credit grant.
12. [PROPOSED] Graft a real enemy and let an actual hostile attack reflect. The knot/reflection cue must follow that reflected hit, not the arming cast. Realm of Mysteries must show the server-sized area and actual Stasis targets without inventing a new realm.

### Phase D — Marauder tests

13. [PROPOSED] Test one-time Pickpocket and ordinary Stealth; no invisibility is granted. Deception/Misdirection should display actual Confused state. Decipher still requires the Cipher Archive interaction for its objective; Information Interpretation cannot reveal arbitrary player secrets.
14. [PROPOSED] Capture then release an allowlisted NPC power. Stored badge and Journal text must match real state and clear after release. Energy Theft must not invent a visible heal amount. Test bad targets and already-owned NPCs.
15. [PROPOSED] Thought Theft must show the real Sleep state. Dream Intrusion must show the current damage/Burning interpretation, not an unimplemented dream scene. Parasitism is host-linked DOT/shielding, not player possession; Vitality Siphon rejects another player's host.
16. [PROPOSED] Spiritual Deception and Belief Misdirection: verify the real Deceived/control outcome, expiry and ownership cleanup. Destiny Infiltration must use actual safe teleport endpoints. Hidden payload remains caster-private while armed; its burst must follow a real attack-triggered payload event. Time Theft/Temporal Delay may change NPC movement through the server status but must never freeze world time, camera updates or other players.

### Phase E — Apprentice tests

17. [PROPOSED] Door Opening fits the actual practice door without changing its existing collision/open timing. Passage Sense remains private. Spark/Wind Tricks must not add physics knockback. Astrological Divination handles uncertain readings; Danger Reading displays actual Shielded state rather than guaranteed prediction.
18. [PROPOSED] Record only after observing an allowlisted enemy cast. Verify real 3 → 2 → 1 → 0 charges through Release Recording/Replication, slot badges and Journal. An invalid/unobserved power must not create a stored stencil/charge. Replication still uses the current whitelist and actual damage rules.
19. [PROPOSED] Compare Travel, Wandering and Planar Travel: basic/depth-separated/star-edged endpoint language should differ, while all original support/occupancy/range/bounds checks remain enforced. Turn away from one endpoint or move beyond 120 studs: the other visible endpoint must remain correctly budgeted.
20. [PROPOSED] Create Spatial Door and Star Gate. Check both real Enter prompts and owner-only use, matched frame silhouettes, duration, replacement by a new pair, Spatial Closure, owner death/leaving, administrative switch and late-join rendering. No extra collider or teleport target may be created by the cosmetics.
21. [PROPOSED] Fill the VFX budget while gates exist. If the frame is evicted/denied, the real pane must stay/restored visible; it must never become an invisible active portal. Change quality/touch mode and confirm old local appearance restores and renewal respects the new cap. Concealment and Spatial Concealment must not add actual invisibility; Spatial Seal/Closure must not create new physical walls.

### Device, performance and cleanup

22. [PROPOSED] Desktop at about 1920×1080 and a smaller window: inspect all 54 previews, live status labels, charge badges and scrolling controls. Observe counters before/after repeated casts. Active/Reserved must return to idle after expiry; allocated pools should stabilize. Errors should stay 0. Measure frame time with Stats/MicroProfiler; code checks cannot guarantee FPS.
23. [PROPOSED] Phone at about 390×844 portrait and 844×390 landscape, with joystick/jump enabled: test at least one low/middle/high ability per pathway, paired travel, paper trigger, recording charges, Low Graphics and Reduced Motion. Controls remain at least 44 px, the selector wraps legibly and labels do not cover the combat center. Switching into touch emulation mid-Play must apply mobile caps.
24. [PROPOSED] Tablet at about 768×1024 portrait and 1024×768 landscape: repeat the selector, high-tier contours, status labels and gate renewals. Rotate during a cast and after respawn. Check for duplicates or orphaned widgets/frames.
25. [PROPOSED] Two-client checks: only the caster receives private thread/host/payload/perception/self-buff information; confirmed ownership/combat states may be public. Join a second client after gate/echo activation. Add latency where available and verify stale events, removed statuses and completed/cancelled casts do not revive after death/admin changes.

## Exact captures to send

- [PROPOSED] `C01-seer-low-mid.mp4` — 20–30 seconds: Divination, paper arm/trigger, Disguise and live thread stages. Include current sequence and settings.
- [PROPOSED] `C02-seer-high.mp4` — 20–30 seconds: exchange, historical echo, successful recovery wish and a real graft reflection. State which prerequisites were met.
- [PROPOSED] `D01-error-transfers.mp4` — capture/release, thought theft and host-linked siphon; include stored-power UI.
- [PROPOSED] `D02-error-payload-time.mp4` — armed payload versus real trigger, Time Theft and Temporal Delay. Keep the whole camera/HUD visible.
- [PROPOSED] `E01-recording.png` — Journal and equipped recording/release slot showing a real remaining charge count.
- [PROPOSED] `E02-doors-travel.mp4` — Travel/Wandering/Planar Travel followed by a real Spatial Door/Star Gate and closure.
- [PROPOSED] `E03-gate-budget.mp4` — 15–20 seconds: gate frame under normal budget, forced low-budget fallback, then cleanup/renewal. Include effect counters.
- [PROPOSED] `CDE-phone-portrait.png`, `CDE-phone-landscape-rm.mp4`, `CDE-tablet.png` — full viewports with touch controls and high-tier effects. State resolution, graphics level and both accessibility toggles.
- [PROPOSED] `CDE-private-observer.png` — caster and observer views of the same private status/perception test, labelled clearly.
- [PROPOSED] `CDE-cleanup.mp4` — repeated previews/casts, expiry, respawn and counters settling. Include measured frame time and allocated instances.
- [PROPOSED] If Output has errors, send `CDE-output-errors.png` and paste the entire script/line/error text.

[EXISTING] Implementation stops at Phase E. [PROPOSED] Phase F begins only after a later instruction.
