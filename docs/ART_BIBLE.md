# Phase 0 — Mysteries Art Bible

**Status:** design specification only. No gameplay, UI, map, lighting, or shipped place files are changed in this phase. Implementation starts after “continue.”

## 1. Visual identity

**Gaslit Victorian mystery, rendered as readable stylized architecture.** Wet cobblestones, soot-dark brick, wrought iron, aged brass, carved dark wood, frosted glass, restrained steam machinery, and original geometric occult ornament. The hub feels inhabited and safe; the outer districts become increasingly improbable and dangerous.

The reference is the atmosphere of nineteenth-century detective fiction and LotM's city settings, not a reproduction of a novel illustration or another game's assets. Use original silhouettes, invented heraldry, and geometric tarot motifs. Do not copy passages, franchise artwork, symbols, audio, or another designer's UI.

Three principles:

1. **Architecture establishes identity.** Real facades, thresholds, roofs, alleys and landmarks replace freestanding colored blocks.
2. **Light directs attention.** Warm gaslight marks safety; cool spiritual light marks interaction; crimson signals actual danger. Neon is reserved for brief powers and small emissive details.
3. **Mystery stays readable.** Dark backgrounds retain visible midtones. Combat telegraphs, enemy silhouettes, exits and interactables remain recognizable at low graphics settings.

Composition target: 70% quiet stone/wood/dark metal, 20% warm light and architectural detail, 10% pathway magic. Keep the middle of the combat view open. Fog layers create depth without erasing the next destination.

### Shape language

| Place or pathway | Signature silhouette and ornament |
|---|---|
| Hub Square | Broad cobbled crossroads, iron lamps, slate roofs, a clock-tower landmark; orderly symmetry. |
| Potion Altar | Narrow chapel/alchemist shop, pointed arch, amber windows, brass instruments, etched glass vessels. |
| Hidden Archive | Tall library facade, narrow windows, stacked shelves, ladders, heavy wooden reading desks. |
| Cipher Archive | Compact observatory/workshop, bronze rings, shuttered skylight, rotating geometric mechanisms. |
| Stabilization Hall | Quiet stone arcade, pale cloth, steady candles, strong horizontal lines. |
| Seer/Fool | Broken circles, veils, fan-shaped cards, fine golden threads, grey fog. |
| Marauder/Error | Offset frames, split diamonds, narrow red cuts, bronze mechanisms. |
| Apprentice/Door | Tall rectangles, nested arches, star points, thin silver/teal edges. |

No giant world-space names, evenly scattered debug lights, glowing structural bars, or permanent red threat haze.

## 2. Exact palette

All future values become tokens in one **Theme.lua ModuleScript** under `ReplicatedStorage/Shared`. Theme owns the visual constants, including fonts, dimensions, durations, asset bindings, light profiles and quality tiers. Other visual scripts consume these tokens rather than restating numeric style values.

| Token | HEX | Use |
|---|---|---|
| Primary / Ink | `#11151D` | Main HUD/menu backing and deep architectural shadows. |
| Secondary / Slate | `#252C36` | Raised surfaces, inactive panels, cool stone shadows. |
| Accent / AntiqueGold | `#C6A56B` | Selection, fine borders, tarot frame details. |
| TextPrimary / Parchment | `#E9DFC6` | Main readable text. |
| TextSecondary | `#B8B4AC` | Supporting text; never reduce its alpha for small labels. |
| DangerText | `#E17986` | Warning text and accessible danger icons. |
| Health / Crimson | `#B94A61` | Health fill and damage accents. |
| Spirituality / Blue | `#71B9DA` | Spirituality fill and mystical resource icon. |
| Sanity / Violet | `#AD96DD` | Sanity fill and mental-state detail. |
| Gaslight | `#FFD39A` | Warm practical lights. |
| Stone | `#68615D` | Weathered masonry. |
| Wood | `#42342D` | Dark wood and furniture. |
| Iron | `#2B3037` | Railings, lamps and machinery. |
| Fog | `#8B96A4` | Cool atmospheric distance. |

Pathway signature colors:

| Pathway | Main signature | Supporting colors |
|---|---|---|
| Seer/Fool | Fog grey `#A8ADB7` | Deep purple `#41334F`, antique gold `#C6A56B`. |
| Marauder/Error | Near black `#0C0E12` | Crimson `#9F3148`, bronze `#B88A5A`. |
| Apprentice/Door | Teal `#4AB7BA` | Silver `#C6D0D9`, starlight white `#EEF7FF`. |

Keep labels and resource numbers on dark backing, not directly on changing bar colors. Danger also uses a broken-diamond icon and text; health uses a heart/crest, spirituality a droplet/star, sanity a crescent/eye. Color is never the only signal. Text uses Parchment or TextSecondary against Ink/Slate; reserve muted pathway colors for fills and decoration. Implementation QA must measure each actual text/background pair at **at least 4.5:1**.

Calculated sRGB contrast for **opaque** text/backings (rounded):

| Text token | On Ink | On Slate |
|---|---|---|
| Parchment | 13.78:1 | 10.61:1 |
| TextSecondary | 8.85:1 | 6.81:1 |
| DangerText | 6.34:1 | 4.88:1 |

These ratios do not certify translucent panels over arbitrary scenery. Text regions must keep opaque Ink/Slate backing or be remeasured against their final composited backgrounds.

## 3. Typography

These names are available in the project's Roblox API definitions; no external font upload is required.

| Role | Roblox font | Desktop / tablet / phone size |
|---|---|---|
| Zone cinematic / major title | `Enum.Font.Antique` | 32 / 28 / 24 px |
| Menu heading / pathway name | `Enum.Font.Merriweather` | 22 / 20 / 18 px |
| Body / objective | `Enum.Font.Gotham` | 16 / 15 / 14 px |
| Resource number / key badge | `Enum.Font.GothamMedium` | 14 / 14 / 13 px |
| Label / cost | `Enum.Font.GothamMedium` | 13 / 13 / 12 px |

Use readable mixed case for body text, short capitals for category labels, and no ornate font for changing numeric values. Small text must not be shrunk below 12 px by a global UIScale. Set intentional TextSize values rather than unrestricted TextScaled; use UITextSizeConstraint where fitting is unavoidable.

## 4. Lighting prescription

Set the lighting mode in **Studio Properties**, not through a runtime script that assumes write access. In Studio versions exposing the legacy selector, choose **Future**. On current unified-lighting versions, choose **LightingStyle = Realistic** and **PrioritizeLightingQuality = true**. Treat these as version-dependent alternatives. Low graphics may reduce the result; readability must not depend on dynamic shadows.

### Lighting service

| Property | Value |
|---|---|
| ClockTime | `20.25` — 8:15 PM |
| GeographicLatitude | `42` |
| Brightness | `2.0` |
| ExposureCompensation | `-0.05` |
| Ambient | `#464A55` |
| OutdoorAmbient | `#67717B` |
| ColorShift_Top | `#000000` |
| ColorShift_Bottom | `#000000` |
| GlobalShadows | `true` |
| ShadowSoftness | `0.45` |
| EnvironmentDiffuseScale | `0.40` |
| EnvironmentSpecularScale | `0.55` |
| FogColor | `#8B96A4` |
| FogStart / FogEnd | `120 / 600` as the fallback when Atmosphere is disabled. |

With Atmosphere active, use its controls as the primary distance treatment; do not expect legacy FogStart/FogEnd to combine into a second independent fog layer.

### Lighting children

| Instance | Exact properties |
|---|---|
| `ColorCorrectionEffect` | Brightness `0.02`, Contrast `0.10`, Saturation `-0.12`, TintColor `#D9E2F2`. |
| `BloomEffect` | Intensity `0.18`, Size `24`, Threshold `1.60`. |
| `Atmosphere` | Density `0.32`, Offset `0.12`, Color `#8B96A4`, Decay `#394253`, Glare `0.08`, Haze `1.70`. |
| `SunRaysEffect` | Intensity `0.025`, Spread `0.80`. |
| `DepthOfFieldEffect` | Disabled during gameplay. Optional cinematic profile only: NearIntensity `0`, FarIntensity `0.08`, FocusDistance `36`, InFocusRadius `28`. |
| `Sky` | CelestialBodiesShown `true`, StarCount `1600`, SunAngularSize `10`, MoonAngularSize `8`, SkyboxOrientation `(0, 20, 0)`. |

Night sky art: six original cubemap faces, each **1024×1024**, with a midnight-blue upper hemisphere (`#111827`), a muted grey horizon (`#394253`), sparse stars and no baked buildings. Upload these in the world-art phase and bind their real IDs to SkyboxBk/Dn/Ft/Lf/Rt/Up in Theme. No asset IDs are invented in this specification. Retain the existing Studio Sky until those originals are available; ClockTime and the above lighting still establish night.

Practical lights: hub gas lamps use PointLight Color `#FFD39A`, Brightness `1.8`, Range `18`, Shadows `true`, positioned `9` studs above the street. Lamps are spaced `24` studs apart along major streets. Limit shadowed lamps visible simultaneously to `8` desktop / `3` low-quality; unshadowed warm window emissives maintain the composition. Flicker is subtle: brightness multiplier `0.96–1.04`, changes every `0.18–0.35` seconds, with independent phases. No rapid flashing.

Zone tint targets, applied locally with a `1.2s` transition rather than a new global Lighting state per player: hub base tint; Potion Altar `#F0DDC5`; Hidden Archive `#D5D1E5`; Cipher Archive `#DFD5C2`; lower arenas `#D3DBE5`; upper arenas `#C6C7DE`. Apply at only `25%` blend strength against the base tint. Do not stack new ColorCorrectionEffects on every entry.

## 5. Scale, camera and composition

- Reference avatar: **5–5.5 studs** high. Judge every doorway and staircase with an actual avatar beside it.
- Ordinary door clear opening: **4 wide × 7 high** studs; use a 7-high, 4-wide, 0.5-deep leaf. Main library/chapel entrance: **8 wide × 11 high** studs.
- Main streets: **20 studs** clear carriageway plus **4-stud pavements** on each side; alleys: **8 studs** clear.
- Storeys: **12 studs**; parapets/roofs: **28–44 studs**; clock tower: **64 studs**. Keep the first combat sightline free of decorative clutter below head height.
- Hub Square: **96×96 studs**; service entrances spread around its edge rather than adjacent pillars. Connected combat spaces: lower arena **96×112**, middle **120×120**, upper **144×144** studs.
- **Updated authorization:** Phase 3 may enlarge and relayout the hub, zones and arenas to this scale; the current playable bounds are not a limit. Preserve working spawn points, portal validation, enemy statistics and server-authoritative systems. Verify portal destinations against the new geometry and bounds. No map changes occur in Phase 1.
- Third-person exploration camera: FOV **70**, zoom range **9–26 studs**, default starting distance target **14 studs**. Combat FOV target **74**, transition **0.25s**. Do not resize the player's gameplay rig for a cinematic; scale the environment around the reference avatar.
- Frame each service doorway with one light source and a recognizable silhouette. Visitors should recognize a library, chapel or workshop without a floating title.

These are design targets, not changes to collision, spawn locations, ranges, enemy statistics or camera behavior in Phase 0.

## 6. Pixel-level HUD and menu mockup specification

Baseline: **1920×1080 desktop**, **1024×768 tablet**, **390×844 phone**. Coordinates below are relative to a **safe-area root Frame** inside a ScreenGui that respects Core UI and device insets. UDim2 notation is `((xScale,xOffset),(yScale,yOffset))`. AnchorPoint is listed separately. Physical touch targets remain at least **44×44 px**; decorative badges may be smaller.

Breakpoints: desktop width `>=1024`; tablet `720–1023`; phone `<720`. When usable height is `<450`, enable a compact landscape profile. UIScale token is `1.0` for these measured layouts; alternate layout tokens provide responsiveness without shrinking phone text/touch targets. A user accessibility scale may increase to `1.15`, with layout reflow.

### Layout table

| Element | AnchorPoint | Position | Desktop size | Tablet / phone changes |
|---|---|---|---|---|
| Resource cluster | `(0,0)` | `((0,20),(0,20))` | `((0,280),(0,124))` | Tablet `252×116` at `(16,16)`; phone `220×104` at `(12,44)`. |
| Compass | `(0.5,0)` | `((0.5,0),(0,20))` | `((0,320),(0,28))` | Tablet `240×26` at top `16`; phone `144×24` at top `10`. |
| Pathway panel | `(0,0)` | `((0,20),(0,156))` | `((0,280),(0,116))` expanded, `280×36` collapsed | Tablet top `144`, width `252`; phone top `156`, width `220`, height `32` collapsed by default. |
| Hotbar | `(0.5,1)` | `((0.5,0),(1,-20))` | `((0,448),(0,96))` | Tablet `386×86`, bottom `24`; phone `296×72`, bottom `168` to clear default touch controls. |
| Journal button | `(1,0)` | `((1,-20),(0,20))` | `((0,112),(0,44))` | Tablet `104×44` offset `16`; phone `44×44` offset `12`, book icon only. |
| Zone entry title | `(0.5,0)` | `((0.5,0),(0,90))` | `((0,520),(0,80))` | Tablet `420×72`; phone width `((1,-32))`, height `60`, top `44`. Temporarily hide overlapping compass/panel content. |
| Center cast feedback | `(0.5,0.5)` | `((0.5,0),(0.5,72))` | `((0,220),(0,24))` | Phone `180×24`, vertical offset `48`. |
| Journal modal | `(0.5,0.5)` | `((0.5,0),(0.5,0))` | Target `920×640`; clamp to safe width/height minus `48` | Tablet target `720×600`, clamp minus `32`; phone `((1,-24),(1,-24))`. Scroll content, keep navigation fixed. |
| Potion confirmation card | `(0.5,0.5)` | `((0.5,0),(0.5,0))` | Target `440×360`; clamp minus `32` | Phone width `((1,-24))`, height up to `360`, clamp safe height minus `24`. |

Compact landscape: resource cluster `208×72`, three thin rows, at `(12,40)`; pathway is a single `208×28` row underneath; compass top `8`; hotbar `296×64`, bottom `160`; hide secondary flavor text. Modal bodies scroll. Actual device QA remains mandatory, especially with Roblox touch-control variants.

### Component construction and styling

**Resources:** 3 rows, each 32 px high with 4 px gaps. A 20×20 original crest sits at x=12; label at x=40. Numbers align to the right with a dark backing. A 6 px fill track spans x=40 to width−12 beneath the label; use a 0.18s TweenService fill animation. Health uses the crimson token, spirituality blue, sanity violet. Track is Slate, backing is Ink. No text sits on a changing fill.

**Pathway panel:** 12 px padding, Merriweather pathway/sequence heading, 6 px digestion track, one wrapped objective, and a 44×44 transparent collapse hit target around a smaller chevron. Collapse motion lasts 0.18s. The compact row still shows sequence and digestion percentage.

**Hotbar:** six square ability faces, desktop **64×64** with **8 px gaps** and **12 px side padding**; tablet **56×56**, gaps **6**, padding **10**; phone **44×44**, gaps **4**, padding **6**. UIAspectRatioConstraint = 1 on faces. The remaining bar height holds cost/cast feedback. Faces use subtle card corners and an original pathway glyph, not purple filled buttons. Key badges are 18×18 desktop, 16×16 phone; cost uses a blue droplet and 12–13 px text. Cooldown is a **32-segment circular overlay** around the glyph, with a short numeric countdown only while cooling. Empty faces show a dim geometric seal with dashed borders; never the word “Empty.” All six slots are reserved so layout does not jump.

**Menus:** book-like Ink panels with a restrained AntiqueGold frame, parchment text, and tabbed Journal / Pathway / Inventory navigation. Potion preview: 96×96 bottle illustration; title and pathway; current→target sequence; required digestion; owned quantity; gold cost; 44 px Confirm and Cancel buttons. The confirmation invokes the existing server transaction; no client-authorized purchase, grant or advancement is introduced.

**Shared construction:** use UIListLayout for rows, UIPadding 12 px desktop / 8 px phone, UICorner 6 px on controls and 10 px on modals, UIStroke 1 px, and a subtle vertical UIGradient from Ink to Slate. Major frame gradients use at most 12% perceptual brightness variation. UIAspectRatioConstraint protects icons; UIScale handles accessibility rather than unchecked whole-screen shrinking. Theme stores all constants and durations.

**Developer information:** session-only status, server diagnostics and test controls are absent from the player HUD. A developer panel toggles with F8 only when the local player is the individual creator or is in a server-validated admin list. For group-owned experiences, membership alone is not admin authorization. The server still enforces all existing Studio-only test restrictions. Hiding a label does not remove the safety checks.

### Interaction and label choreography

- Custom ProximityPrompt panel target: **176×44 px**, object-relative, with a 20 px key/controller glyph, short action and hold-progress edge. It appears only for an eligible, in-range prompt. Keep the camera center clear.
- Interactable name label: preferred **156×28**, absolute maximum **200×50 px** using offset dimensions; visibility limit **40 studs**. Alpha is zero outside 40, interpolates toward full visibility from 40→28, and remains full at 28 or closer.
- Zones use **no persistent name BillboardGui**. Their name appears once per entry, then lives in the compass. Entry card timing: **0.35s fade in, 2.0s hold, 0.55s fade out**; no repeat until exited for at least **8s**.
- Label priority: active prompt, its object name only if space remains, nearby interactables, decorative labels. Suppress an object's separate name while its prompt is open. Reject labels whose padded screen rectangles intersect accepted higher-priority labels, the active prompt, HUD or modal exclusions. Padding is **8 px**; try vertical slots `0, −32, +32`, then hide the lower-priority label if none fits. Cap visible labels at **6** and active prompt panels at **1**.
- Zones would use AlwaysOnTop=false if a temporary debug label is enabled; eligible interactable labels alone may use true. Projection/occlusion and collision avoidance must be implemented and tested in Phase 2, not assumed from art.

### Feedback timings and accessibility

- Hover tint: **0.10s**; click depression: **0.08s** down, **0.12s** return.
- Hit flash: **0.08s** rise, **0.18s** fall; opacity cap **0.16**.
- Damage number: 18 px, 16 px on phone; rises 22 px over **0.55s**, expires at **0.70s**, maximum 12 concurrent.
- Sanity warning below **20%**: corner vignette alpha cap **0.22**, breathing cycle **2.4s**; no full-screen strobe or text distortion. Reduced-motion mode removes breathing/distortion.
- Sequence advance: **0.25s** fade in, **1.6s** hold, **0.45s** fade out. Input/camera presentation must not extend or alter the server's progression transaction.
- Camera shake cap: **0.10 studs / 0.25 degrees** for a small hit, **0.22 studs / 0.55 degrees** for a major cast, duration **0.12–0.22s**. Reduced-motion mode disables it. “Hit-stop” is a brief cosmetic camera/animation pause, never a freeze of server time, physics, cooldowns or input validation.
- UI sound bindings: `Hover`, `Click`, `Confirm`, `Reject`, `JournalOpen`, `Advance`. Initial IDs are **0 = disabled** until original audio is uploaded. Proposed volumes: hover `0.12`, click `0.18`, confirm `0.22`, reject `0.18`, journal `0.15`, advance `0.28`; hover minimum interval `0.08s`. No invented IDs or borrowed soundtrack.

## 7. Eight copy-ready image prompts

These are prompts only. No images have been generated or imported in Phase 0. Generated lettering is deliberately excluded; real readable text is rendered by Roblox UI.

### 1 — Hub city concept art

> Original stylized Victorian gothic mystery RPG hub, a foggy gaslit cobblestone crossroads with believable 20-stud-wide streets and four-stud pavements, soot-dark brick terraces, slate roofs, wrought-iron balconies, a single clock tower as the navigation landmark, lived-in shops with frosted amber windows, restrained brass machinery, wet stone reflections, warm welcoming center and mysterious blue-grey distance; eye-level third-person camera behind a five-stud-tall humanoid silhouette, 35mm composition, clear navigable foreground and layered depth; palette charcoal #11151D, stone #68615D, wood #42342D, antique gold #C6A56B, gaslight #FFD39A, fog #8B96A4; evening illumination with soft readable shadows, stylized PBR materials suitable for an optimized Roblox environment, original architecture and geometric occult details only, no copied franchise imagery, 16:9, game concept art, no text, no watermark.

### 2 — Potion Altar room

> Original Victorian alchemist chapel interior for a gothic mystery action RPG, a brass-and-marble preparation altar beneath a pointed arch, glass potion bottles with original silhouettes, balance scales, copper tubing, sealed cabinets, candle clusters, stained glass using abstract circles and fan-shaped tarot geometry without lettering, real walkable floor space and an eight-by-eleven-stud main doorway; three-quarter interior camera at humanoid eye height, 28mm lens, altar as a strong focal point without blocking the entrance; palette ink #11151D, dark wood #42342D, parchment #E9DFC6, antique gold #C6A56B and warm gaslight #FFD39A, with restrained blue #71B9DA highlights inside glass; warm practical pools of light against cool foggy windows, readable stylized PBR kitbash, original assets, 16:9, game concept art, no text, no watermark.

### 3 — Hidden Archive / library

> Original secret Victorian library interior for a stylized gothic mystery RPG, towering dark wooden shelves, rolling ladders, arched windows, velvet curtains, worn reading desks, brass lamps, stacked closed books with unmarked spines, a concealed side doorway and one luminous geometric seal integrated into the architecture; deep but navigable space with generous aisles and a five-stud-tall character silhouette for scale; three-quarter eye-level camera along the central aisle, 35mm lens, strong shelf rhythm and a quiet focal desk; palette deep purple #41334F, fog grey #A8ADB7, wood #42342D, parchment #E9DFC6 and aged gold #C6A56B; violet moonlight through windows mixed with small amber desk lights and visible dust, low bloom and readable midtones, original architecture and ornaments, 16:9, game concept art, no text, no watermark.

### 4 — Cipher Archive

> Original Victorian cipher workshop and small observatory for a gothic occult RPG, interlocking bronze rings, offset rectangular mechanisms, black iron cabinets, mechanical shutters, an open star-viewing roof and a central decoding desk, original abstract geometric patterns with no readable characters, practical stairs and wide routes around every machine; elevated three-quarter interior camera at 30 degrees, 32mm lens, central mechanism as the dominant silhouette with clear playable space; palette near black #0C0E12, bronze #B88A5A, iron #2B3037, parchment #E9DFC6 and restrained crimson #9F3148; narrow warm task lights, cool starlight and faint atmospheric dust, steampunk-lite rather than a factory full of pipes, optimized stylized PBR shapes, original design, 16:9, game concept art, no text, no watermark.

### 5 — Sequence 9–5 enemy arena

> Original lower-tier enemy district for a Victorian gothic mystery action RPG, an abandoned gasworks courtyard transitioning into brick alleys and a derelict carriage depot, cobblestone ground, broken wagons, modest stone stairs, waist-high cover and two readable exits, human-scale threats with coats, masks and lantern silhouettes, no giant monsters; over-the-shoulder third-person gameplay camera, 35mm lens, wide open central combat lane with clear enemy silhouettes and restrained peripheral detail; palette stone #68615D, iron #2B3037, wood #42342D, fog #8B96A4, warm lamp accents #FFD39A and limited crimson #B94A61 for real danger cues; evening fog, practical lamps with readable shadow detail, stylized PBR and reusable Roblox kitbash proportions, original props and outfits, 16:9, game concept art, no text, no watermark.

### 6 — Sequence 4–1 enemy arena

> Original high-tier supernatural arena beyond a Victorian city, a vast ruined observatory cathedral where intact walkable stone terraces frame impossible distant arches, suspended architectural fragments only outside the playable route, original giant geometric seals and distant star-lit doorways, threatening elongated masked silhouettes, strong contrast between a safe approach and the dangerous central floor; low third-person camera at humanoid eye height, 24mm lens emphasizing scale while preserving a readable foreground and two visible escape routes; palette ink #11151D, deep purple #41334F, fog grey #A8ADB7, teal #4AB7BA, silver #C6D0D9 and sparse starlight white #EEF7FF; layered moonlit fog, restrained localized magical emissives, no full-screen neon wash, stylized game-ready architectural materials and original imagery, 16:9, game concept art, no text, no watermark.

### 7 — Full HUD UI mockup

> Original production-oriented HUD mockup for a Victorian gothic mystery action RPG, straight-on flat 1920x1080 interface presentation over a subdued blurred gaslit street, top-left three slim crest-and-track resource meters in crimson #B94A61, spirituality blue #71B9DA and sanity violet #AD96DD, a compact collapsible tarot-framed pathway and digestion panel beneath them, a fine compass strip at top center, six elegant card-like square ability slots bottom center with small blank key badges, blue cost gems and segmented radial cooldown rings, one deliberately vacant slot marked by a dim dashed geometric seal, small book button top right; ink #11151D and slate #252C36 backing, antique gold #C6A56B hairline frames, parchment #E9DFC6 icon details, generous negative space and phone-adaptable proportions; flat orthographic UI camera, even interface illumination with no baked text shadows obscuring shapes, all label areas blank with no pseudo-lettering, original ornamental geometry only, game concept art, no text, no watermark.

### 8 — Potion bottle icons and ability icon style guide

> Original coordinated icon atlas for a Victorian occult RPG, three distinct potion bottle families and accompanying ability glyph studies arranged on a regular transparent-background grid with generous spacing and no labels: Seer bottles use frosted fog-grey glass #A8ADB7, deep purple #41334F fluid and antique-gold #C6A56B caps; Marauder bottles use near-black #0C0E12 glass, crimson #9F3148 fluid and bronze #B88A5A mechanical closures; Apprentice bottles use teal #4AB7BA fluid, silver #C6D0D9 frames and starlight-white #EEF7FF inclusions; original ability motifs include fine threads, fanned blank cards, split diamonds, nested door arches and four-point stars, never franchise emblems; consistent three-quarter bottle camera, front-facing glyph camera, upper-left soft studio key light, restrained highlights and crisp silhouettes readable at 44x44 pixels, no tiny engravings, 1:1 atlas with separate 512x512 source cells, original assets, game concept art, no text, no watermark.

## 8. Handoff and phase boundary

Phase 0 supplies the palette, type hierarchy, exact lighting baseline, dimensional UI specification, interaction choreography and eight prompts. It does not modify gameplay logic, regenerate the downloadable place, or claim visual QA that has not been rendered in Studio.

After “continue,” Phase 1 creates Theme.lua and the UI overhaul, documenting every script's class and Explorer destination. Phase 2 implements label/compass behavior; Phase 3 implements the world kitbash and generators; Phase 4 implements the VFX/character/combat presentation; Phase 5 measures visual QA and performance. Each future phase stops for “continue” unless the user changes that instruction.

The requested <=100k on-screen triangles and <=150 draw calls are **targets to measure with Roblox tools**, not guarantees derivable from this document. Future implementation must include low-graphics, phone/tablet safe-area, label collision and >=4.5:1 text contrast checks. Asset uploads, lighting-mode configuration, profiling, and desktop/mobile engine playtests remain explicit Studio steps.
