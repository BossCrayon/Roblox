# Phases F–I — HUD, world, characters, enemies and QA

[EXISTING] The Phase F–I **implementation** is complete in source and the rebuilt `studio/Mysteries.rbxlx`. This continues the roadmap used for Phases B–E: F = HUD/Journal, G = world/outfits, H = enemies, I = QA tooling. Earlier uploaded specifications used different phase letters; this document follows the immediately preceding C–E handoff.

[EXISTING] This is original native-part art and procedural presentation. All 54 dedicated ability packages, the twelve-state animation controller, eleven original primitives, VisualBudget, AnimConfig, VfxConfig, authority and existing progression systems remain. No new pathway, Sequence 0, gameplay executor, damage value, cooldown, enemy statistic, quest, economy, crafting system or incoming remote was added. The source uses original combat interpretations; lore metadata remains [UNVERIFIED]. The new district/enemy names are **original game fiction**, not claimed canon locations or creatures.

[PROPOSED] Rendered visual acceptance, measured device performance and engine/network acceptance are still pending the Studio checklist below. Linux cloud checks do not render Roblox. No live Roblox publication occurred.

## Phase F — readable themed HUD and Journal

| Status | Deliverable | Actual behavior/tuning |
|---|---|---|
| [EXISTING] | Seer skin | Purple charcoal `#25202F` card surfaces; antique-gold `#C6A56B` corner lines, tilted tarot rules, and fine thread brackets on both slot faces and folio panels (`Pathway`, `Hotbar`, `JournalCard`, `SequenceAdvance`); folio spine and “Veiled cards” Journal heading. All 18 Seer abilities map to bespoke vector glyphs in `Theme.AbilityGlyphs`. |
| [EXISTING] | Marauder skin | Near-black `#191B22` surfaces, bronze `#B88A5A` offset corners, crimson/bronze split-rule ledger headers on panels, and bespoke theft/cipher/time/parasite glyphs in `Theme.AbilityGlyphs`; “Split ledger” Journal heading. |
| [EXISTING] | Apprentice skin | Blue charcoal `#172A30` surfaces, silver `#C6D0D9` vertical threshold jambs and lintels on slots and folio cards, and bespoke door/key/arch/star/book glyphs in `Theme.AbilityGlyphs`; “Threshold folio” Journal heading. |
| [EXISTING] | Ability readiness | Existing 32-segment sweep/countdown retained. On completion, frame transparency becomes 0.12 for 0.55 s; Reduced Motion removes this accent. Vacant slots retain dim dashed seals and never show `"Empty"`. Equipped slots show framed `StoredPower` (`◆`) and `RecordedCharges` (`1`–`3`) badges, spirituality-cost affordability tinting, and enriched desktop hover tooltips. |
| [EXISTING] | Potion/advancement | Successful server drinking emits owner-only `PotionConfirmed`: a 0.90 s procedural hand-to-mouth pose and bounded motes. Existing 0.25/1.60/0.45 s sequence title follows confirmed snapshots. Administrator changes get sequence titles without pretending a potion was consumed. No client presentation postpones a transaction or locks input. |
| [EXISTING] | Acting/digestion | Same-sequence confirmed digestion gains show a 1.4 s “Acting recognised” message. The client does not award credit. Open Journal refresh includes digestion, acting, stored power and recording charges. |
| [EXISTING] | Sanity | Static textual guidance accompanies the existing bounded vignette. Madness/loss-of-control do not distort text. Reduced Motion disables breathing, camera shake and flashing. The public HUD never displays storage/session diagnostics or “Normal.” |
| [EXISTING] | Layout | Existing measured safe-area layouts retained: 64 px desktop / 56 px tablet / 44 px phone slots; 44 px minimum interaction targets. Opaque Ink/Slate text backing, Gotham body/numbers, Merriweather headings, Antique major titles. New labels yield to modals and prompts. |

[EXISTING] `Theme.Skins`, `Theme.Ritual`, `Theme.Layout`, `Theme.Type` and `Theme.Timing` own styling. `AnimConfig.CastProfiles.Potion` selects the original procedural pose and its empty optional AnimationId. No canonical drinking gesture is asserted.

## Phase G — world and player appearance

| Status | Deliverable | Implementation |
|---|---|---|
| [EXISTING] | Larger sanctuary | 96×96 square, 20-stud carriageways and 4-stud pavements; 64-stud clock tower. Original cobblestone, slate, brick, iron and wood native parts. Spawn remains at `(0, 0.5, 0)`. |
| [EXISTING] | Service architecture | Four 28×28×28 buildings with 8×11 clear entrances, original pointed arch lines, frosted amber windows, cabinets, brass trim and reading/potion desks. Potion Altar/Hidden Archive/Cipher Archive/Stabilization keep their exact server lookup names and validated prompts. Entrances face the hub; no solid leaf blocks them. |
| [EXISTING] | Six arenas | Centers at radius 238, spaced 60° apart. Sequences 9/7: 96×112; 5/4: 120×120; 2/1: 144×144. Buttresses and high-tier background arches stay out of the central fighting area. Same eighteen spawn records/tiers/statistics; relaid-out positions are inside the unchanged 380-stud travel bound and supported 800×800 ground. |
| [EXISTING] | Traversal landmarks | Four real 4×7 practice-door leaves; registered gas lamps remain FlameAnchors. Each arena includes four anchors near its fighting area. Existing safe-destination, ownership and movement checks still apply. |
| [EXISTING] | Night atmosphere | Art Bible 20.25 clock, ambient colors, 0.32-density Atmosphere, restrained bloom, one local world grade and 25% zone-tint blend. Low Graphics disables bloom. LightingStyle/Technology remains a Studio property. No skybox ID is supplied. |
| [EXISTING] | Practical lights/ambience | Nearest visible lamps: max8 desktop, max3 low/mobile, 120-stud cutoff, **no light shadows**. Brightness1.8, range18; slow ±4% local flicker, disabled under Reduced Motion. Bounded pooled warm motes: max2 desktop/1 mobile per 3 s interval, low priority in the existing global budget. Low Graphics/Reduced Motion skip decorative motes. Atmosphere supplies fog; no unbounded fog emitter field. |
| [EXISTING] | World labels | No permanent zone BillboardGuis. Max6 compact 156×28 labels, 40-stud cutoff, fade28→40, ray obstruction check, padded screen-rectangle rejection against HUD/prompt/modals and each other. Three vertical attempts:0/−32/+32. The active object's prompt replaces its separate label. |
| [EXISTING] | Zones/navigation | Top-center heading/zone compass replaces the old wordmark strip. One entry card per visit,0.35/2.0/0.55 s; repeat suppressed until exited for8 s. Zone tint changes over1.2 s; Reduced Motion applies a static change. On cramped landscape the card can have zero available height instead of covering controls. |
| [EXISTING] | Player clothing | Locally welded, massless, non-query/non-collision coat pieces. Seer top hat/coat; Marauder waistcoat/mantle/bronze pin; Apprentice traveller collar/cape. Both R6 and R15 supported. Each pathway has Sequence9–1 selections: base silhouette, extra crest at4–1, collar seal at2–1. This is tiered trim, not27 independently authored uploaded costumes. |
| [EXISTING] | Outfit limits | Max8 nearby player assemblies within80 studs, max10 parts each. No body-color, rig-scale, Humanoid, motor, physics or avatar-asset mutation. Clear/rebuild on pathway/sequence, death, respawn, distance and server-reported Disguise; the existing identity/mask/scale restoration remains in charge. |
| [EXISTING] | Pathway aura | Sequences9–7: none.6–4: faint motes.3–1: small veil. At most one visible nearby aura emitted per4 s interval, shares global effects budget. Low Graphics/Reduced Motion remove it. |

[EXISTING] Geometry, proportions, lighting, colors, fonts, labels, quality settings, timing and sound bindings are exposed through Theme's World/CharacterArt/EnemyArt and existing animation/VFX configs. Native-kit decorative parts are anchored/non-query; collision is reserved for architecture/floors. These fixed parts are bounded scene geometry, separate from transient pooled effects.

## Phase H — original enemies and presentation

| Status | Seq | Original silhouette | Scale / width |
|---|---:|---|---:|
| [EXISTING] | 9 | Lamplight Ruffian: short dark coat, block hat, pale unmarked face | 1.00 /1.00 |
| [EXISTING] | 7 | Veiled Penitent: narrow purple mantle and long veil | 1.10 /0.90 |
| [EXISTING] | 5 | Brass-Masked Prowler: broad iron sleeves, angular ears, bronze mask | 1.15 /1.40 |
| [EXISTING] | 4 | Cloister Apparition: elongated narrow body, long dark veil, grey mask | 1.50 /0.72 |
| [EXISTING] | 2 | Bound Astronomer: tall purple silhouette within silver binding uprights | 1.80 /0.85 |
| [EXISTING] | 1 | Warden of the Last Arch: broad towering teal mantle and arch frame | 2.10 /1.30 |

[EXISTING] Maximum18 visible enemy assemblies,12 native parts each,120-stud/offscreen culling. Original server torso/head proxies are hidden locally while replacement art is visible, then restored when a live assembly is culled. The **real root, humanoid, hit eligibility and statistics remain unchanged**; oversized costume details are non-query/non-collision and do not enlarge a hitbox. Aim at the central registered body. Historical echoes retain their existing ghost presentation rather than receiving a hostile outfit.

[EXISTING] Procedural idle rise0.035 studs over3.6 s; confirmed attack lean12°, hit lean8° for0.20 s; death fade0.80 s. Reduced Motion/Low Graphics keep static silhouettes. Existing server-confirmed hit/death blocks remain active. Health widgets pool at4 desktop/2 mobile,40-stud distance; show actual Humanoid health, silhouette name and a textual attack cue.

[EXISTING] The server publishes only cosmetic attack target/due/impact attributes. A 0.65 s ground-fill warning anticipates **already scheduled** next strikes when eligibility/range permit. Melee uses the unchanged real attack-range radius6; spell windup uses a2.6-stud marker at the caster, **not an invented blast radius**. Warnings use2 pooled Parts, priority5, and share4/8/16 effect admission. They cancel when the server clears eligibility or the due time ends. Controlled entities clear hostile eligibility; silence disables spell eligibility. Colors remain readable under grayscale through circular shape/fill and text.

[EXISTING] **Timing limitation:** existing first/overdue attacks can resolve immediately on entering range, and the authoritative scheduler ticks at0.25 s. This visual-only pass does not delay those attacks to manufacture a windup, so advance warning is not guaranteed. Clients observe impact lean/feedback on the real strike. Network delay can shorten warning time further.

[PROPOSED] Guaranteed pre-hit windups would require a separately approved gameplay-timing change; they are intentionally not claimed complete here. Enemy navigation also retains the existing straight-line/leash behavior; this is not a pathfinding rewrite.

[EXISTING] High-tier presentation template: first visible intro notice (8 s global gap), one local50%-health “seal fractured” cue/notice, death fade plus existing defeat presentation. The phase cue does not alter AI, damage or stats. Optional sound hooks `Enemy.Intro/Phase/Death/Melee/Spell` all bind to0 in Theme.

## Phase I — QA tooling and evidence

[EXISTING] Authorized **F8 → Studio VFX test room** includes **Run bounded stress** and **Cancel stress run**. The harness refuses published clients, overlapping runs and runs beyond its12-report/session bound. It requests max-effects+4 compositions every0.4 s for10 s, then drains3 s, and writes `[Mysteries visual QA]` JSON to Studio Output. It never sends gameplay intents or clears unrelated effects.

[EXISTING] Report fields include median/p95/max Heartbeat milliseconds, at most600 frame samples, peak active effects, final active/reserved counts, before counts, allocation totals, dropped/evicted counts, pool bounds, admission violations, instance totals and accessibility/device/quality settings. These are observed client frame intervals, **not isolated GPU timings or guaranteed FPS**. Background gameplay/ambience can keep final global counts nonzero; compare idle baselines and rerun until allocated pools stabilize. Cancellation releases only test-owned handles.

[EXISTING] All 54 ability previews, 36 gesture families, tiers, grayscale silhouette view, cancellation, private statuses, confirmed triggers and lifecycle tests remain available. Automated checks pass **11,791 assertions** (including 1,903 choreography/composition/privacy assertions and 409 UI/layout/glyph assertions), compile 68 Luau files, pass strict Roblox API/type analysis and verify source-identical copies of 54 ModuleScripts plus one server Script and one LocalScript in the real Rojo build. New coverage includes 7-joint windup-to-release pose deltas across all 54 abilities, primary-vs-secondary sequence gesture differentiation, gesture-origin vertical alignment, bespoke 54-ability glyph coverage, world construction/bounds/names/tags, R6/R15 outfit combinations/disguise/assembly caps, all six silhouettes, unchanged threat clocks, warning cancellation, bounded bars/lights, label occlusion/modals, low/RM settings, stress overfill and drain. The mocks do not simulate collision, font rasterization, device insets, live replication or DataStore.

[NEEDS NEW ASSET] Optional original audio, uploaded animations, atlas art and six original sky faces. No asset or publishing service is required to run the procedural build; no ID has been invented. Real assets need upload/permissions testing in Studio before use.

## Full scripts and Explorer placement

[EXISTING] [PHASE_FI_VISUALS_CODE.md](PHASE_FI_VISUALS_CODE.md) contains **all56 production scripts in full**, Theme first, with filename, Script/LocalScript/ModuleScript class and exact Explorer path. The desktop/phone/tablet checklist and capture list follow the code. [PHASE_FI_SCRIPTS.json](PHASE_FI_SCRIPTS.json) supplies the machine-readable manifest. Use this export or the built place for current installation; older phase exports are historical milestones with integration updates.

## Studio checklist

### Desktop and world/travel acceptance

1. [PROPOSED] Download the current `studio/Mysteries.rbxlx` with **Download raw file**, open through **Studio → File → Open from File**, then Play as your configured account. Use1920×1080 and1280×720. Keep Output open. Confirm one HUD, one sanity grade and one world grade; no public debug strings or “Empty” slots.
2. [PROPOSED] Inspect all three skins using ADMIN and Journal. Exercise a cooldown through completion, then Reduced Motion. Open the Journal before changing recording charges and digestion; ensure rows refresh while open, scroll position remains sensible and all text stays readable.
3. [PROPOSED] Drink a legitimate starter/next potion through Inventory confirmation. Cancel once first. Only a successful drink should move the hand to the mouth; ADMIN should not pretend to drink. Confirm inventory/progression remain server-controlled and the title adds no input delay. Reach low sanity/madness normally; verify readable static guidance with RM on.
4. [PROPOSED] Walk from origin spawn around the96-stud square and into each service building. Verify the8×11 doorway is actually clear, camera collision does not trap you, desks/prompts are reachable, cabinets leave walkable aisles and both Archive acting interactions still work. Complete an altar purchase/cancel and Stabilization. Inspect20-stud roads and4-stud pavements with an avatar for scale.
5. [PROPOSED] Visit all six arenas and capture their entry cards/compass. Count three enemies per arena and confirm all six tiers. Test high-tier exposure remains centered on the arena. Verify arena floors, two clear approaches, no backdrop blocking the fighting area and no unintended hub enemy aggro.
6. [PROPOSED] Use Flame Jump at street and arena lamps; use Door Opening at every practice door. Test Travel, Wandering and Planar Travel on street, terrace, near a service doorway/interior and near the outer map edge. Confirm obstruction/support/world-bound rejection remains correct. Inspect successful destinations with an avatar, including whether a roof is selected by the existing downward support ray. Report mismatches; do not weaken SafeDestination to hide them.
7. [PROPOSED] Create Spatial Door and Star Gate on the new geometry. Traverse both ends as owner; reject a second player. Test renewal, budget denial fallback, cleanup, death, respawn and departure. Repeat the C–E late-join/private status checklist.
8. [PROPOSED] Approach labels at40,28 and10 studs; rotate behind walls and put the object offscreen. Verify occlusion, fades, screen collision rejection, prompt priority and modal suppression. Zones must have no permanent floating signs. Cross a boundary quickly, then wait outside8 s and re-enter; no rapid title spam.
9. [PROPOSED] Inspect lamps at quality1,5 and10; confirm no shadow-casting PointLights. RM should make lamps steady. Low Graphics should reduce visible lights to3, disable bloom and stop decorative motes/auras. Check pool counters rather than judging only brightness.

### Character, enemy and authority acceptance

10. [PROPOSED] Test both R6 and R15. Switch all three pathways and inspect Sequence9,6,4,3,2,1 trim/aura thresholds. Verify your original avatar restores on uninitiation/disguise cleanup, and no rigid clothing prevents default movement, climbing or camera zoom. Wide/custom avatars need visual fit review; the fallback is designed around ordinary humanoid proportions.
11. [PROPOSED] Cast Disguise, approach the archive, then let it expire. Repeat death/admin advancement while disguised. Outfit parts should disappear while disguise is server-active and return cleanly afterward, without leftover masks, body colors or R15 scale values. Use two clients to inspect each other and keep admin access server-validated.
12. [PROPOSED] Fight each enemy tier. Inspect coat/mask/arch silhouette in color and F8 grayscale, actual health numbers, hit lean and death fade. Aim at the central body: decorative giant extremities deliberately do not add hit eligibility. Leave/re-enter120 studs and rotate offscreen; no duplicated art, bars or visible old proxy should remain on a living enemy.
13. [PROPOSED] Stay within attack range for a second/third attack and record the fill/impact timing. First or overdue strikes can be immediate by design. Leave range, obstruct LOS, apply control/stasis/silence and verify warning eligibility cancels appropriately. Verify spell marker is read as a caster warning, not a target AoE. Check health/damage/cooldown values against the prior build.
14. [PROPOSED] Reduce a Sequence2/1 enemy below50% and defeat it; intro/phase/death presentation must remain cosmetic. Spawn/departure/respawn must not accumulate enemy art. Record one historical echo and verify it retains ghost styling and actual combat behavior.

### Phone and tablet

15. [PROPOSED] Phone emulator near390×844 portrait and844×390 landscape, default joystick/jump enabled: check all six44-pixel slots, Strike, Journal, ADMIN when authorized, prompts, zone cards, sanity/acting messages and cooldowns. No input should activate behind a modal. Rotate while a Journal/potion card is open; keep Confirm/Cancel fixed and body scrollable. Cramped landscape can omit the zone card instead of covering controls.
16. [PROPOSED] Tablet near768×1024 and1024×768: expand/collapse pathway, use a long ability/sequence name, open each tab and potion confirmation, fight near a prompt, and rotate. Inspect overlap between health widgets/status badges and the HUD in each orientation.
17. [PROPOSED] Repeat one live cast, recording/release, gate traversal, disguise and enemy warning at quality1 with both accessibility toggles on. Static silhouettes, numeric health/statuses and cooldowns must remain usable without decorative motion, glow or shadows.

### Performance, multiplayer and assets

18. [PROPOSED] In F8 Studio test room, recenter the stage in view, run bounded stress and wait the full13 s. Save the JSON line and a full-viewport recording with counters. Run twice at desktop quality1 and10, then phone/tablet, Low Graphics and Reduced Motion. Expected: Errors=0, BudgetViolations=0, PoolsBounded=true; steady allocations after warmup. Drops during forced overfill are expected. Use Stats and MicroProfiler for actual CPU/GPU diagnosis; emulator frame time is not a physical phone benchmark.
19. [PROPOSED] Cancel stress mid-run, close F8, respawn and switch graphics quality while effects exist. Test-owned handles must release; real gates/private statuses must keep their own lifecycle. Repeat five minutes of mixed casts/rotation/culling and compare instance and memory baselines after expiry. Target60 FPS on your desktop and30 on the target phone; report measured frame time/device rather than assuming a pass.
20. [PROPOSED] Start a two-client server. Confirm independent inventory/progression, private sensing/thread stages/payloads, owner-only gates/control, and public enemy outcomes. Test latency and a late join while an echo/gate/status is active. Recheck save/rejoin only in an isolated published development place as described in STUDIO_TESTS.md; this build does not change persistence rules.
21. [PROPOSED] If adding assets: publish original animations from Animation Editor, copy the real IDs into the relevant AnimConfig entry/profile, and test experience ownership/rig compatibility; blanks use the procedural version. Upload original sounds and set Theme.Sound IDs, including `Enemy.*` hooks; zero remains silent. Upload an original particle texture into VfxConfig.Particle.Texture if desired; otherwise geometric motes remain. Sky bindings remain empty and do not replace the Studio sky automatically. Never insert guessed IDs or enable unrelated API permissions for art.

## Exact captures to send

[PROPOSED] Send the **whole game viewport**, including HUD/touch controls, at normal image scale. Include device/resolution, quality and both accessibility settings. Clips should be15–30 s where timing matters. Do not crop errors or hide their script/line.

- [PROPOSED] `F01-seer-hud-journal.png`, `F02-error-hud-journal.png`, `F03-door-hud-journal.png` — each skin with one cooldown and its Journal page; use separate idle/Journal captures if needed.
- [PROPOSED] `F04-drink-advance.mp4` — cancel first, then legitimate potion drinking, title, resource/slot update.
- [PROPOSED] `F05-sanity-acting-rm.mp4` — confirmed digestion feedback and low-sanity/madness guidance with RM on.
- [PROPOSED] `G01-square-scale.png` — third-person avatar, square, clock tower, street/pavement and building entrances.
- [PROPOSED] `G02-service-interiors.mp4` — enter all four services, use archive/altar prompts and show camera clearance.
- [PROPOSED] `G03-six-arenas.mp4` — each tier's approach, entry card, floor, enemies and background exits.
- [PROPOSED] `G04-outfit-r6-r15.png` — labelled views for each pathway on both rigs, at9 and1; include a disguise-before/after pair.
- [PROPOSED] `H01-enemy-lineup.png`, `H02-enemy-grayscale.png` — readable silhouettes for tiers9/7/5/4/2/1, with an avatar for scale, color and grayscale.
- [PROPOSED] `H03-warning-impact.mp4` — sustained melee/spell fight showing scheduled next-strike fill, actual hit, health widget and cancellation after control/silence/range exit. State latency if simulated.
- [PROPOSED] `H04-high-tier-phase-death.mp4` — intro,50% cue and defeat with visible health numbers.
- [PROPOSED] `I01-phone-portrait.png`, `I02-phone-landscape-rm.mp4`, `I03-tablet-portrait.png`, `I04-tablet-landscape.png` — complete HUD/touch controls with a prompt or combat and one open modal among the captures.
- [PROPOSED] `I05-stress-desktop.mp4`, `I06-stress-phone.mp4` — full13 s stress/drain and counters; paste the complete `[Mysteries visual QA]` JSON lines and measured hardware/quality.
- [PROPOSED] `I07-multiplayer-cleanup.mp4` — caster/observer private cue check, active gate/echo on late join, followed by expiry or respawn.
- [PROPOSED] `I08-output-errors.png` if any errors occur, plus the full text. Include a wider Studio screenshot if a device-inset or import issue occurs.

[EXISTING] Implementation stops after Phase I. [PROPOSED] Engine acceptance and any refinements should follow observed Studio evidence; uploaded asset polish remains optional.
