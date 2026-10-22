# Phase A — procedural animation and VFX framework

Phase A supplies the client presentation framework and a local Studio preview room. It adds no pathway-specific ability choreography, character outfit redesign, enemy balance changes or progression changes. Existing server-confirmed casts and hits drive presentation. Rendering never grants damage, movement, invulnerability, resources, cooldown completion or progression.

The existing damage event adds only a server-confirmed `Dead` boolean so a lethal-hit dissolve works even when client health replication arrives later. It adds no remote or client damage request. The old neutral cast pulse remains as a compatibility cue until the pathway phases replace it. Current anchored NPCs have no Motor6D rig; their hits and dissolve work, while enemy skeletal animation and silhouettes remain Phase E.

Open the updated `studio/Mysteries.rbxlx` in **Roblox Studio → File → Open from File**, then press **Play**. Download a fresh copy from GitHub using **Download raw file**. For manual installation, [PHASE_A_VFX_CODE.md](PHASE_A_VFX_CODE.md) contains complete scripts with their classes and exact Explorer paths. Create matching Folder parents, replace existing same-name scripts with Play stopped, and keep unchanged foundation modules. [PHASE_A_SCRIPTS.json](PHASE_A_SCRIPTS.json) is the machine-readable manifest.

## Assets and configuration

The supplied effects use original native geometry. No asset upload is needed. Every animation entry in `ReplicatedStorage.Shared.AnimConfig.Entries` has `AnimationId=""` plus a procedural implementation. An optional uploaded animation overrides that entry; its procedural form remains the fallback when the asset cannot play. Use animation assets owned by the experience creator/group and compatible with the rig. Restart Play after editing config because ModuleScripts are cached.

`Theme` contains the Art Bible palettes, UI/camera/test-room tokens and sound slots. `VfxConfig` contains effect budgets, tier/quality scaling, lifetimes and explicit emitter/beam/trail/light/highlight properties. `AnimConfig` contains poses, timing, priorities, blend limits, spring settings and optional animation IDs. Empty texture slots intentionally use readable geometric fallbacks; an untextured ParticleEmitter is never treated as visible artwork. Sound IDs remain **0**, meaning silent, until original audio is configured. No MeshId, AnimationId, TextureId or SoundId has been invented.

The animation library includes Idle, Walk, Run, Jump, Land, CastWindup, CastRelease, HitReact, Dodge, Roll, Death and Victory. Procedural poses are small joint overlays. The controller removes its previous contribution before the default Animator updates and reapplies the current contribution afterward. It does not disable Roblox's default Animate script or animate HumanoidRootPart movement. Dodge and Roll are poses only. Hit-stop pauses cosmetic presentation only; server simulation, physics, input and cooldowns continue.

## Budgets and numeric properties

Effects are distance-culled at **120 studs** and skipped outside the camera viewport. Detail decreases after **30** and **70 studs**. Quality levels **1–3** use low detail, **4–6** medium and **7–10** high; Automatic is conservatively treated as level **5**. Maximum active effects are **4 low / 8 medium / 16 high**, capped at **8 on mobile**. A new effect can displace strictly lower-priority effects, oldest first at the same priority, only when the entire new reservation can fit. Equal/higher-priority effects are protected.

The pools grow on demand up to the following hard limits. Expiration/culling/eviction returns instances to their pools and clears attachment/adorned-target references. Zero shadow-casting lights are used by the supplied blocks. The service allows at most **one PointLight per effect**, with `Shadows=false` by default.

| Pooled class | Desktop cap | Mobile cap |
|---|---:|---:|
| Part | 160 | 96 |
| Attachment | 192 | 112 |
| Beam | 96 | 56 |
| Trail | 16 | 8 |
| ParticleEmitter | 24 | 12 |
| PointLight | 4 | 2 |
| Highlight | 8 | 4 |

Tier scales are **1.0 / 1.35 / 1.7** for Sequences **9–7 / 6–4 / 3–1**. These scale presentation only. The screen-flash opacity cap is **0.16**, with a minimum gap of **0.34 seconds**. GlitchFlicker makes two positional shifts over **1.1 seconds**; its opacity never alternates. Small camera feel is capped at **0.10 studs / 0.25° for 0.12 seconds**; major feel is capped at **0.22 studs / 0.55° for 0.22 seconds**. FOV kick uses **1.8°**, capped at **2.5°**; cosmetic hit-stop defaults to **0.045 seconds**, capped at **0.06 seconds**.

These are the explicit defaults in `VfxConfig`; block-specific color/width/geometry overrides are in that same module. NumberSequence notation below is `(time,value)`.

| Class/property | Value |
|---|---|
| ParticleEmitter Texture / Rate | `""` / `0`; bounded bursts only when an original texture is supplied |
| Lifetime / Speed | `NumberRange(0.35,0.65)` seconds / `NumberRange(0.5,1.5)` studs per second |
| SpreadAngle / Size | `(18,18)` degrees / `[(0,0.10),(1,0)]` |
| Transparency / Color | `[(0,0.35),(1,1)]` / Fog `#A8ADB7` → Gold `#C6A56B`; RisingMotes uses the selected palette's primary color |
| LightEmission / LightInfluence | `0.15` / `0.8` |
| Drag / Acceleration | `1.5` / `(0,0.7,0)` |
| Rotation / RotSpeed | `NumberRange(0,180)` / `NumberRange(-15,15)` |
| VelocityInheritance / LockedToPart | `0` / `false` |
| Orientation / EmissionDirection | `FacingCamera` / `Top` |
| ZOffset / TimeScale | `0` / `1` |
| Beam Texture / TextureLength / TextureSpeed / TextureMode | `""` / `1` / `0` / `Stretch` |
| Beam Width0 / Width1 / Segments | `0.055` / `0.055` / `12`; ThreadBeam uses width `0.045 × tier scale`, end taper `0.55`, `16` curve segments |
| Beam CurveSize0 / CurveSize1 / FaceCamera | `0` / `0` / `true`; ThreadBeam sets cubic-Bezier tangents from length `7 × tier scale` and arch height `2 × tier scale` |
| Beam Transparency / Color | constant `0.25` initially, fading to `1` / selected palette accent; DoorFrame uses primary |
| Beam LightEmission / LightInfluence / ZOffset | `0.1` / `0.9` / `0` |
| Trail Texture / TextureLength / TextureMode | `""` / `1` / `Stretch` |
| Trail Lifetime / MinLength / MaxLength | `0.22` / `0.03` / `8` |
| Trail WidthScale / Transparency | `[(0,1),(1,0)]` / `[(0,0.4),(1,1)]` |
| Trail Color / LightEmission / LightInfluence / FaceCamera | Fog → Gold, overridden to selected primary / `0.1` / `0.9` / `true` |
| PointLight Enabled / Brightness / Range / Shadows | `false` / `0` / `0` / `false` |
| Highlight FillTransparency / OutlineTransparency / DepthMode | `0.65` / `1` / `Occluded` |

Every building block has a texture-free fallback. Simplified detail is selected by quality and distance, in addition to the explicit Low graphics toggle.

| Block | Lifetime | Normal silhouette | Low-graphics fallback |
|---|---:|---|---|
| RingBurst | 0.7 s | Broken expanding ground circle, base radius 3 | Fewer outline segments, minimum 4 |
| RisingMotes | 1.2 s | Up to six small geometric motes, base rise 3; optional texture burst | Fewer geometric motes; texture not required |
| ThreadBeam | 0.85 s | One tapered cubic-Bezier beam, length 7, arch height 2 | Same single thin beam |
| DoorFrame | 1.1 s | Two nested three-sided frames, width 3, height 5 | One three-sided frame |
| StarBurst | 0.65 s | Four-point star outline, radius 2.4 | Same eight outline segments |
| GlitchFlicker | 1.1 s | Four offset frame strokes, two slow position edits | Static offset strokes |
| GroundRune | 1.2 s | Circle of radius 3 and four inward spokes | Simplified circle without spokes |
| ImpactFlash | 0.32 s | Two crossed strokes, radius 0.9 | Same small cross |
| ScreenEdgePulse | 0.5 s | One capped edge pulse; center stays clear | Same capped edge pulse; suppressed by Reduced motion |
| ShockwaveRing | 0.8 s | Expanding outline circle, radius 4 | Fewer outline segments, minimum 4 |
| AfterimageTrail | 1.0 s | Narrow geometric head with pooled ribbon, length 5 | Geometric head without Trail |

## Preview and accessibility

The VFX Test Room runs on the local client in Studio and requires server-validated developer access. Open **F8** using the individual creator account or an ID explicitly listed in `ServerScriptService.AdminConfig.AdminUserIds`, then use the VFX Test Room control. An unpublished place may have CreatorId 0; put your real numeric Roblox user ID in the existing server allowlist if needed. Usernames, group membership and Studio's negative synthetic user IDs do not confer access.

The preview room is cosmetic. Its controls do not call a damage remote or modify the server world. Close it before checking normal combat. It provides the eleven reusable blocks in each of the three power tiers and each pathway palette. Reduced motion disables camera shake, FOV kicks, cosmetic hit-stop, impact flashes, hit highlights/recoil and screen flashes; damage numbers and slow death fades remain. ImpactFlash and ScreenEdgePulse share a maximum-three-per-second gate. Low graphics chooses simplified geometry and lower budgets. The normal Journal settings apply the same preferences during play.

## Verification boundary

Run `python3 scripts/check.py` for the data/domain tests, focused presentation tests with explicit Roblox stand-ins, Luau compilation, strict Roblox API analysis and a real Rojo place build/source check. Run `python3 scripts/package.py` afterward to update the downloadable place and full-source exports. The cloud workspace cannot run Roblox Studio. Rendering, real Animator/default Animate interaction, touch controls, actual graphics-quality behavior, network replication, live DataStores and device frame time still require the Studio checks below; passing host-side tests does not certify them.

## Studio checklist — run after installing all code

### Desktop and framework preview

1. Open a fresh place copy and **View → Output**. Use Play, not Run, so LocalScripts execute. Confirm there are no red errors and no public storage/session debug banner.
2. Press F8 with an authorized account and open the VFX Test Room. Confirm the room is local and gameplay remains server-authoritative. Close/reopen the panel several times; check that one preview room is active and its controls still respond. An unprivileged client must not open the F8 panel or preview room.
3. Select **Seer**, tier **1**, normal graphics and normal motion. Trigger each building block separately: RingBurst, RisingMotes, ThreadBeam, DoorFrame, StarBurst, GlitchFlicker, GroundRune, ImpactFlash, ScreenEdgePulse, ShockwaveRing and AfterimageTrail. Check recognizable silhouettes, no solid sphere obscuring the center, and no missing-texture squares.
4. Repeat at tiers **2** and **3**, then repeat the complete set with **Marauder** and **Apprentice**. Seer uses fog/purple/gold; Marauder uses near-black/crimson/bronze; Apprentice uses teal/silver/starlight. Tier 3 should occupy more space while keeping the view center readable. ThreadBeam should curve smoothly; DoorFrame should remain tall; StarBurst should read as four points; GroundRune should remain on the ground.
5. Repeatedly trigger effects until lower-priority previews are displaced or dropped. Watch the displayed instance/effect counts: they must remain bounded. Wait for all lifetimes to expire and confirm active counts return to idle. Run for at least **60 seconds**, close the room, reopen it and repeat. Pooled idle instances may remain allocated; they must not grow with every click or duplicate across room reopenings.
6. Turn the camera away from the preview location, then turn back. Walk more than **120 studs** from an effect origin. Off-screen or distant effects should be skipped/released. Return and trigger a fresh effect; it should render normally. Check Studio graphics quality **1**, a middle setting and a high setting; if quality is Automatic, note that in your report.
7. Enable **Low graphics** and repeat all eleven blocks at tier 3. They should retain their basic shapes with fewer components. Enable **Reduced motion** and repeat ImpactFlash, ScreenEdgePulse, camera feel and GlitchFlicker. No camera shake, FOV kick, hit-stop or screen flash should remain. Numeric damage feedback must stay readable. Rapid clicks must not create a strobe.
8. Preview every animation on the local character: Idle, Walk, Run, Jump, Land, CastWindup, CastRelease, HitReact, Dodge, Roll, Death and Victory. Check R15, then an R6 session if your experience supports it. Walk and jump normally afterward: default Animate should still work without joint drift, locked limbs or changed root position. Stop/restart previews, respawn three times and confirm the new character animates normally.
9. Close the room and play normally. Drink a starter potion, cast a power and hit an enemy. Windup/release should follow accepted server state/events; health numbers and cooldowns must match the existing game. On an accepted hit, look for a brief enemy highlight, a small visual displacement/afterimage, floating damage and a death dissolve on defeat. NPC collision/root positions and server death rewards must behave as before.
10. For an optional real-asset check, set one `AnimConfig.Entries.<Name>.AnimationId` to an original permitted asset. Verify it plays, then clear the slot and verify the procedural fallback. An inaccessible asset must fall back without disabling locomotion or spamming Output. Leave all other asset slots empty unless you have uploaded suitable originals.

### Phone emulator

Use **Test → Device Emulator**, select a phone close to **390×844 portrait**, then rotate to approximately **844×390 landscape**. Keep Roblox's joystick and jump controls enabled.

- Open F8/test controls using Studio's keyboard while the emulated phone is active. Check the preview list scrolls, buttons remain tappable, close/settings controls stay visible, and text respects the safe area.
- Test all eleven blocks at tiers 1 and 3 with Low graphics both off and on. Keep the whole viewport visible so effect scale can be judged relative to the character and HUD.
- Enable Reduced motion. Trigger the camera/flash controls repeatedly and check that the camera and screen edges remain still. Default touch movement and jump must continue working.
- Close the preview room, cast using touch controls and defeat an enemy. Verify aim still uses the center reticle, numeric feedback is legible, and effects do not cover the six slots or joystick/jump.
- Rotate during an effect, while the panel is open, and after a respawn. There must be no duplicate UI, runaway effect count or new Output error.

### Tablet emulator

Use approximately **768×1024 portrait** and **1024×768 landscape** with touch controls enabled.

- Repeat the eleven tier-3 building blocks in each palette, checking room scrolling, safe edges and touch targets.
- Repeat Low graphics and Reduced motion checks; close the room and verify normal movement/casting.
- Respawn, change orientation and reopen the room. Check all controls and the default character animations remain responsive.

### Measurement and readability

Use Studio's **Stats** and **MicroProfiler** while repeatedly previewing effects. Record device/emulator resolution, graphics quality, Low graphics/Reduced motion state, average frame time and visible instance/effect counts. Host-side tests cannot establish a real device frame-rate guarantee.

Use the test room's **Silhouette view** toggle to preview grayscale, then return to color. Rings, narrow threads, tall frames, stars and offset glitch frames should remain distinguishable by shape. This is a manual visual check; a full automated performance stress script and Phase F UI polish remain later work.

## Exactly which screenshots and recordings to send

Send full game viewports at their original resolution, keeping the HUD, character, device safe edges and default touch controls in frame. Put device size, graphics level and toggle state in the filename or message. A still screenshot cannot verify motion, pooling cleanup or flash frequency, so include the short recordings below.

1. **`A01-desktop-room.png`** — authorized F8/test-room controls, palette/tier settings and budget counters visible at approximately 1920×1080.
2. **`A02-silhouettes.mp4`** — **15–25 seconds** on desktop, showing RingBurst, ThreadBeam, DoorFrame, StarBurst, GlitchFlicker and GroundRune one after another at tier 3. Keep the same camera angle; show Seer, Marauder and Apprentice palettes at least once each.
3. **`A03-all-blocks-low.mp4`** — **20–30 seconds**, Low graphics on, triggering all eleven blocks at tier 3. Include the counters before triggers and after effects finish.
4. **`A04-reduced-motion.mp4`** — **10–15 seconds**, Reduced motion on, triggering camera feel, ImpactFlash, ScreenEdgePulse and GlitchFlicker repeatedly. Keep settings visible at the beginning.
5. **`A05-animation-r15.mp4`** — **20–30 seconds**, idle/walk/run/jump/land, cast windup/release, hit-react, dodge/roll, death and victory preview, then ordinary walking. State rig type. Add **`A05b-animation-r6.mp4`** if R6 is supported.
6. **`A06-server-hit-death.mp4`** — **10–20 seconds** of ordinary combat with a damage number and enemy defeat. Keep health, cooldown and target visible; close the preview panel first.
7. **`A07-phone-portrait.png`** — approximately 390×844, tier-3 DoorFrame or GroundRune with normal HUD and touch controls visible.
8. **`A08-phone-landscape-low.mp4`** — **10–15 seconds** around 844×390, Low graphics + Reduced motion on, triggering at least ThreadBeam, StarBurst and AfterimageTrail; show readable controls and counters.
9. **`A09-tablet-portrait.png`** and **`A10-tablet-landscape.png`** — around 768×1024 and 1024×768, with tier-3 effects and the complete preview panel/HUD visible across the two images.
10. **`A11-budget-cleanup.mp4`** — **15–20 seconds** of repeated triggers reaching the budget, followed by waiting until active counts settle. Include the counters throughout. Also report the frame time you measured and graphics setting.

If Output shows errors, send **`A-output-errors.png`** and paste the full error text including script name/line number. State whether unprivileged F8 stayed closed, whether off-screen/>120-stud effects stopped, and whether counts stayed stable after three respawns and room reopenings. Do not expose private identifiers or change balance/storage settings just to capture a preview.

Phase A stops here. Phase B starts after **“continue.”**
