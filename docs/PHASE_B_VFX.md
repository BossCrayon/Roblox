# Phase B — pathway cues and six dedicated ability packages

[EXISTING] Historical milestone notes below describe Phase B. Phases C–E now provide dedicated recipes for all 54 abilities; use [the current coverage and Studio checklist](PHASE_CDE_VFX.md) and [current full-code handoff](PHASE_CDE_VFX_CODE.md). References below to remaining/deferred packages describe the earlier milestone.

[EXISTING] Phase B is implemented in source and included in `studio/Mysteries.rbxlx`. This means code exists; rendered appearance and real-device performance still need the Studio tests below. No assets were uploaded. Balance, damage, costs, target eligibility, cast durations, travel rules, admin authorization and persistence semantics remain unchanged.

[EXISTING] All 54 selected abilities now use pathway-shaped completion cues instead of neutral expanding spheres. Six have dedicated compositions and cast-pose profiles. [PROPOSED] Full bespoke choreography for the remaining 48 remains Phases C–E; the finished world/HUD/enemy redesign remains later work. Canon metadata remains [UNVERIFIED]. Every new shape and pose is original art direction, not a verified depiction from the novel.

## Deliverables and actual tuning

| Status | Ability / ID | Windup / release pose | Confirmed result and lifetime | Low/mobile fallback |
|---|---|---|---|---|
| [EXISTING] | Spirit Vision / `Seer_9_Secondary` | Reading,0.50 s /0.18 s | Gold eye stencil and small broken ground reading circle,0.85 s; private target outlines for at most 5 s | Four-segment eye; no ground circle. Private outlines remain budget-limited. |
| [EXISTING] | Flame Jump / `Seer_7` | Flame,0.50 s /0.18 s | Fog-grey ankle rings with warm geometric embers at actual departure/arrival,0.75 s | Four-segment rings; two motes per visible endpoint. No animated rising/orbit under Reduced Motion. |
| [EXISTING] | Pickpocket / `Marauder_9` | Pickpocket,0.50 s /0.16 s | Bronze split diamond travels from target toward caster on a thin curved crimson transfer beam,0.65 s | Same silhouette; no decorative screen effects. RM crossfades a stationary endpoint mark. |
| [EXISTING] | Ability Theft / `Marauder_6` | Theft,0.50 s /0.22 s | Capture pulls toward caster; release reverses direction,0.85 s. Stored power has an owner-only hotbar diamond and readable Journal text. | Static endpoint mark under RM; same single transfer beam. |
| [EXISTING] | Door Opening / `Apprentice_9` | Threshold,0.50 s /0.25 s | Thin teal frame follows actual selected door dimensions/orientation,0.85 s. Actual door state remains server-owned. | One three-sided frame rather than nested frames. |
| [EXISTING] | Travel / `Apprentice_5` | Travel,0.50 s /0.20 s | Matching teal thresholds at actual departure/arrival,0.75 s | One plain three-stroke frame per visible endpoint. |

[EXISTING] Retained lower-sequence abilities use the tier of their own unlock sequence. These six use the existing0.50 s cast window. The server still controls the real execution time; client release poses add no movement/input lock and no gameplay delay. Animation recovery uses existing configured fades.

[EXISTING] Shared fallback for the remaining 48: Seer broken fog/gold ring; Marauder bronze offset frame; Apprentice teal doorway. These are explicitly generic pathway cues, not48 completed bespoke packages. An obscured divination uses an incomplete mark rather than a successful reading/reveal.

[EXISTING] Existing primitive names remain the original eleven. `SigilStencil` is one additional procedural block for ability compositions. It consumes the existing bounded Part/Attachment/Beam pools; it does not introduce a replacement VFX system. `AnimConfig.CastProfiles` extends the original twelve animation entries rather than adding a separate animation controller.

[EXISTING] Palette: Seer `#A8ADB7/#41334F/#C6A56B`; Marauder `#0C0E12/#9F3148/#B88A5A`; Apprentice `#4AB7BA/#C6D0D9/#EEF7FF`; flame core `#FFD39A`. UI styling remains in Theme; pose tuning is in AnimConfig; effect geometry and network bounds are in VfxConfig. Minimum composite beam width is0.04 stud desktop /0.06 mobile, so shrinking a motif does not shrink its lines into invisibility.

[NEEDS NEW ASSET] Optional original audio and polished uploaded animation overrides can be added later. All supplied animation IDs are empty and sound IDs0. No MeshId/TextureId/SoundId/AnimationId was invented. Blank pose-specific animation slots inherit a configured generic cast asset; otherwise they use procedural poses. No upload is required for any current package.

## Server evidence and lifecycle

[EXISTING] The server reuses the existing `MysteriesRemotes.Effect` RemoteEvent. No incoming visual remote exists. Intent rate limits and all original validation remain in force. `VisualEventService` observes accepted casts and sends:

- [EXISTING] Begin: stable ability ID, owner, character instance, monotonic visual token, tier, origin and synchronized accepted end time.
- [EXISTING] Result/Cancel: confirmed outcome, origin, actual resulting root position and actual selected target where applicable. Capture versus release is determined from real stored-power state.
- [EXISTING] Reveal: one private batch of up to 16 server-selected targets sent only to its authorized caster, with bounded expiry. This replaces individual reveal packets, not permission filtering.

[EXISTING] Tokens remain monotonic even if an admin resets domain progression. Character identity prevents an old character's packet from animating a respawned rig. The client deduplicates repeated Begin/Result/Reveal packets, rejects stale/invalid evidence, and limits tracked owners to 64. A missing completion expires the windup without inventing a successful impact. Death, interruption, administrative progression change and leaving release visual state. Owner snapshots include stored-power identity for the slot badge/Journal.

[EXISTING] Cast bars can start immediately from accepted server evidence and end from the matching result. Older snapshots cannot resurrect a completed bar. Selected powers and resource deductions still come from the server.

## Composition and performance

[EXISTING] One atomic reservation covers all layers of a cast, including paired endpoints. Up to 6 layers / 12 anchors are permitted. Invisible endpoints allocate no instances until visible; their reservations still count against the same hard pool caps. Groups park independently when off-screen/outside 120 studs and release together on expiry/cancellation. Moving symbols and windup attachments use their actual updated positions for culling. Windup marks follow existing rig parts without moving them.

[EXISTING] Active caps remain4 low / 8 medium / 16 high, capped at 8 mobile. Mobile compositions use detail at most 0.35. Switching TouchEnabled during an emulator session applies mobile limits and trims idle desktop pools to mobile caps. Existing strict lower-priority eviction remains unchanged. Quality/settings changes release existing effects; cast again to inspect the new profile.

[EXISTING] Desktop/mobile hard instance caps remain: Part160/96, Attachment192/112, Beam96/56, Trail16/8, ParticleEmitter24/12, PointLight4/2, Highlight8/4. The Phase B packages create no PointLights, Trails or emitters with empty texture slots. Geometric motes are pooled Parts. No shadowed lights are added.

| Status | Package | Desktop high maximum geometry | Mobile fallback geometry |
|---|---|---|---|
| [EXISTING] | Spirit Vision release |2 Parts,16 Beams,32 Attachments |1 Part,4 Beams,8 Attachments |
| [EXISTING] | Flame Jump release |16 Parts,24 Beams,48 Attachments |8 Parts,8 Beams,16 Attachments |
| [EXISTING] | Pickpocket / Ability Theft release |2 Parts,5 Beams,10 Attachments |Same, with stationary mark under RM |
| [EXISTING] | Door Opening release |1 Part,6 Beams,12 Attachments |1 Part,3Beams,6 Attachments |
| [EXISTING] | Travel release |2 Parts,12 Beams,24 Attachments |2 Parts,6 Beams,12 Attachments |

[EXISTING] Figures above exclude separately budgeted private reveal Highlights and generic confirmed-hit feedback. Pool limits can reject a composition before the active-effect count limit is reached. No FPS claim is made from these counts.

[EXISTING] Reduced Motion disables flashes/camera feel, moving transfer marks, mote rising/orbit and offset-frame jitter. Rings remain stationary. Screen flash opacity stays capped at0.16 and the existing shared flash interval remains enforced. Empty/denied pulse compositions do not acquire a visual lease.

## Full code and Explorer paths

[EXISTING] [PHASE_B_VFX_CODE.md](PHASE_B_VFX_CODE.md) contains complete scripts, classes and exact Explorer paths with the test checklist after the code. [PHASE_B_SCRIPTS.json](PHASE_B_SCRIPTS.json) is its manifest. Apply to the existing foundation with Play stopped; replace same-name scripts and create matching Folder parents. For a blank place, use the complete [FULL_SOURCE.md](FULL_SOURCE.md). The ready-to-open place already includes everything.

[EXISTING] The automated build inspection now checks full Explorer paths, because Shared/Pathways/Seer and Visuals/PathwayEffects/Seer correctly share a module name in different folders.

## Studio checklist

[EXISTING] Host checks execute real modules against explicit engine stand-ins and build a real Rojo place. They cannot certify Roblox rendering, physics, networking, live account lookup or device frame rate. Complete these checks in Studio.

1. [PROPOSED] Download a fresh `studio/Mysteries.rbxlx` with GitHub's Download raw file. Open using Studio File → Open from File, then Play as `johnskie816`. Wait for the configured server username lookup, open ADMIN/F8 → Studio VFX test room. Unlisted/noncreator accounts must not get those controls.
2. [PROPOSED] Use each of the six new Ability buttons. The room previews poses on your avatar and effects on a local stage. These previews send no gameplay intent, grant no power, move no player and spend no resource. The local mannequin is not a combat enemy. Set normal motion/high graphics first, then Low Graphics and Reduced Motion. Recenter the stage after changing the camera angle.
3. [PROPOSED] Use Ability Theft capture and its separate release button. Confirm opposite transfer directions. Use Cancel windup: the mark and pose must unwind without release, impact or sound. Use generic tier3 fallback buttons: all three should have distinct silhouettes with no spheres. Confirm original eleven primitive/animation preview controls still work.
4. [PROPOSED] Test Travel origin-behind-camera and arrival-beyond 120 controls. Only visible/in-range endpoints may instantiate. Turn the camera during paired effects; one disappearing endpoint must not erase the other. Advance normally with the ADMIN controls to test real travel as well; the preview itself never teleports you.
5. [PROPOSED] Real Spirit Vision: use ADMIN Seer/9, equip Spirit Vision in Journal, and cast with nearby enemies. The eye and privately authorized outlines should appear. Compare with a second client: only the caster gets the perception outlines. With no nearby enemies, the self-cue is allowed but no invented enemy outlines appear.
6. [PROPOSED] Real Flame Jump: Seer/7, aim near an orange FlameAnchor and cast. Verify departure/arrival match actual server travel. Aim away from any anchor or at an obstructed landing: there must be no successful departure/arrival effect. Keep cooldown/resource behavior unchanged.
7. [PROPOSED] Real Pickpocket: Marauder/9, target a living hostile enemy within 8 studs. First theft shows transfer and adds the existing 5 gold. Repeating on the same NPC must not show a successful snatch or award more loot. A target already owned by someone must be rejected.
8. [PROPOSED] Real Ability Theft: Marauder/6, target an eligible ArcBolt NPC. Capture should show inward transfer and the small stored-power diamond on that equipped slot. Journal should say Stored: Arc Bolt. Recast after cooldown on a valid hostile target: transfer reverses, confirmed damage occurs, and badge/Journal storage clear on the next snapshot. An invalid target must not clear/grant a fake stored power.
9. [PROPOSED] Real Door Opening: Apprentice/9, aim near a closed practice door. The teal frame must fit that actual door; opening/collision timing must match the old game. Reject an already-open door or a point without one. Watch the actual door close later; the short decorative frame must not act as a second physical gateway.
10. [PROPOSED] Real Travel: Apprentice/5, equip Travel and cast at a valid destination at least 10 studs away. Confirm matching endpoints and preserved orientation/safe placement. Try a blocked/unsupported/out-of-bounds destination: cancellation only. No camera tunnel or fake alternate plane should appear.
11. [PROPOSED] Interrupt a windup by dying, then respawn. Switch pathway/sequence through ADMIN during a windup. Old effects/poses must not resume. Cast again after switching, including after using legacy Studio mastery controls if present. Visual tokens must not lock out subsequent effects. Default Animate walking/jumping must still work after previews and real casts on both R15 and R6 where supported.
12. [PROPOSED] Repeat effects to reach the budget. Watch Active/Allocated/Reserved/Errors in the room. Counts must stay bounded, Errors remain 0, and active/reserved counts return to idle after lifetimes expire. Idle pooled allocations may remain; they must stabilize rather than grow per click. No effect should create shadows or solid neon spheres.
13. [PROPOSED] Desktop: test 1920×1080 and a smaller window; ordinary cast bar, cooldowns, prompts, stored badge and Journal must remain legible. Verify a finished/rejected cast bar does not reappear from a late snapshot. During a windup, walk/turn: the small mark should follow the rig without root drift or locked movement.
14. [PROPOSED] Phone emulator: about 390×844 portrait, then844×390 landscape with default joystick/jump enabled. Test all six packages, Low Graphics, Reduced Motion and the stored-power Journal explanation. Test switching from desktop to touch emulation mid-Play; displayed mobile caps must update. Buttons remain at least 44 px; effect borders must remain visible without covering the hotbar.
15. [PROPOSED] Tablet emulator: about 768×1024 portrait and1024×768 landscape. Repeat paired travel, private vision, theft badge, scrolling test-room controls and respawn. Check safe edges and camera-center targeting.
16. [PROPOSED] Multiplayer: use two real authorized test accounts where needed, or test public powers with unprivileged clients. Check shared release positions/capture variants but private reveal targets. Studio synthetic negative IDs do not receive admin privileges. Add latency simulation if available; cancelled/stale casts must not produce successful late releases.
17. [PROPOSED] Measure frame time using Studio Stats/MicroProfiler for quality 1, middle, high and real phone hardware if available. Record resolution, quality, toggles and instance counters. Test grayscale using the room's silhouette toggle. Code tests do not establish a device performance guarantee.

## Exactly what to send for review

- [PROPOSED] `B01-six-abilities-desktop.mp4`:20–30 s, all six preview packages in the same camera angle; include both Ability Theft directions. Show normal/high settings at the start.
- [PROPOSED] `B02-real-flame-travel.mp4`:15–20 s, real successful Flame Jump and Travel, then an invalid destination. Keep player and arrival area visible.
- [PROPOSED] `B03-private-vision.png`: both clients' views of the same Spirit Vision cast, labelled caster/observer; observer must not gain private outlines.
- [PROPOSED] `B04-theft-stored.png`: real captured power with the hotbar diamond and readable Journal storage text. Also report that release clears both.
- [PROPOSED] `B05-cancel-and-cull.mp4`:10–15 s, cancelled preview, hidden-origin Travel and distant-arrival Travel. Include counters.
- [PROPOSED] `B06-phone-portrait.png` and `B07-phone-landscape-rm.mp4`: full viewport with touch controls, Low Graphics and Reduced Motion; show a paired effect and a transfer, not a crop of only the particles.
- [PROPOSED] `B08-tablet.png`: complete viewport/panel in either orientation, plus report the second orientation worked.
- [PROPOSED] `B09-budget-cleanup.mp4`:15–20 s of repeated effects then waiting for active/reserved counts to settle; include measured frame time and quality setting.
- [PROPOSED] If Output has red errors, paste the full text with script/line and attach `B-output-errors.png`.

[PROPOSED] Stop after Phase B review. Phase C completes the Seer package after the user says continue.
