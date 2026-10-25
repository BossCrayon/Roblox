# Canon review record

Status: **Mixed — Mythical Creature Forms researched against primary wiki/novel references; 54 gameplay ability implementations remain marked `[UNVERIFIED]` in runtime data until checked against an authorized edition.**

No novel text was copied verbatim, and no franchise artwork or external game assets are used. All sequence records and derived ability records retain `Canon.status="[UNVERIFIED]"` in [`PathwayFactory.lua`](file:///c:/Roblox/src/ReplicatedStorage/Shared/PathwayFactory.lua) and [`AbilityData.lua`](file:///c:/Roblox/src/ReplicatedStorage/Shared/AbilityData.lua); passives carry the same `[UNVERIFIED]` marker.

## 1. Classification of Lore & Presentation Elements

| Category | Scope in Repository | Verification Label |
|---|---|---|
| **Sequence Titles (9 → 1)** | Fool (`Seer` → `Attendant of Mysteries`), Error (`Marauder` → `Worm of Time`), Door (`Apprentice` → `Key of Stars`) | Canon-aligned sequence progression; marked `[UNVERIFIED]` in runtime data until checked against an authorized edition. |
| **Mythical Creature Forms (`[R]` Ultimate)** | **Seer/Fool**: *Worms of Spirit*<br>**Marauder/Error**: *Worms of Time*<br>**Apprentice/Door**: *Worms of Star*<br>**Sequence Gate**: Locked at Sequences 9–5; Incomplete Saint manifestation at Sequences 4–3; Complete Angel form at Sequences 2–1. | **Canon-verified lore motifs & sequence gate** (researched from *Lord of the Mysteries* wiki/novel references below); timed duration, cooldown, spirituality/sanity costs, and procedural part assembly are **original Roblox adaptations** (`[UNVERIFIED]`). |
| **Pathway Visual Motifs** | **Seer/Fool**: Grey fog (`#A8ADB7`), deep purple (`#41334F`), antique gold (`#C6A56B`); tarot cards, paper figurines, veils, spirit body threads, historical traces, restrained miracle stars.<br>**Marauder/Error**: Near black (`#0C0E12`), crimson (`#9F3148`), bronze (`#B88A5A`); split diamonds, offset glitch frames, narrow cuts, monocle/cipher lenses, directional theft transfers, clock faces.<br>**Apprentice/Door**: Teal (`#4AB7BA`), silver (`#C6D0D9`), starlight (`#EEF7FF`); fitted door frames, nested arches, keys, Scribe tome inscriptions, paired departure/arrival thresholds. | **Canon-inspired art direction** (original procedural geometry; zero franchise assets). |
| **Ability Mechanics, Costs & Timings** | 54 bounded server executors in [`EffectService.lua`](file:///c:/Roblox/src/ServerScriptService/Services/EffectService.lua), fixed cast times (`0.5s` Seq 9–5, `1.5s` Seq 4–1), cooldowns, spirituality costs, and acting objectives. | **Original gameplay interpretations** (`[UNVERIFIED]`). |

## 2. Researched Mythical Creature Lore & Citations

### 2.1 Sequence Distinction (Incomplete vs. Complete Mythical Creature Form)
- **Verified Canon**:
  - **Sequences 9–5 (Low/Mid Sequences)**: Beyonders do not possess a Mythical Creature Form.
  - **Sequences 4–3 (Saints / Demigods)**: Advancing to Sequence 4 initiates a qualitative transformation of the body, soul, and godhood into an **Incomplete Mythical Creature** (*Lord of the Mysteries*, Chapters 904, 946; Wiki: *Mythical Creature Form*). Manifesting this incomplete form in combat is hazardous to the Beyonder's mental stability and exposes them to the inclination of losing control.
  - **Sequences 2–1 (Angels / Subsidiary Gods)**: Advancing to Sequence 2 completes the transformation into a **Complete Mythical Creature** (*Lord of the Mysteries*, Chapters 1105, 1266; Wiki: *Mythical Creature Form*, *Angel*), allowing stable manifestation of the full form without the incomplete Saint instability.
- **Original Gameplay Adaptation (`[UNVERIFIED]`)**:
  - Implemented in [`RuntimeConfig.lua`](file:///c:/Roblox/src/ReplicatedStorage/Shared/RuntimeConfig.lua) and [`PlayerDomain.lua`](file:///c:/Roblox/src/ServerScriptService/Domain/PlayerDomain.lua) as an active `[R]` transformation ultimate (`45s` cooldown, `45` spirituality cost):
    - **Sequences 9–5**: Locked (`Ultimate` intent rejected by server; HUD displays `Seq 4` lock badge).
    - **Sequences 4–3 (`Incomplete`)**: `10s` duration, `1.20x` power multiplier, `25%` damage reduction, `+4` movement speed, `12` initial sanity cost plus `1.2/s` continuous sanity drain while active (reflecting the danger of exhibiting an incomplete Saint form; if sanity reaches `0`, Madness triggers and immediately terminates the transformation).
    - **Sequences 2–1 (`Complete`)**: `14s` duration, `1.35x` power multiplier, `25%` damage reduction, `+4` movement speed, and `4` initial sanity cost with zero ongoing sanity drain.

### 2.2 Pathway Mythical Creature Anatomy & Visual Motifs
| Pathway | Mythical Creature Name | Researched Canon Description & Citations | Procedural Adaptation in [`CharacterArt.lua`](file:///c:/Roblox/src/StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt.lua) & [`Presentation.lua`](file:///c:/Roblox/src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua) |
|---|---|---|---|
| **Seer / Fool** | **Worms of Spirit** | **Canon**: A hive-mind collective of finger-sized translucent worms with white-grey fluorescence and boiling fog-like surface patterns. At Sequences 4–3 (*Bizarro Sorcerer* / *Scholar of Yore*), the incomplete form manifests as a shifting tentacled vortex of Worms of Spirit. At Sequences 2–1 (*Miracle Invoker* / *Attendant of Mysteries*), the complete form manifests as a dark, translucent cloak blending grey fog and dark liquid whose ends extend into slick tentacles of Worms of Spirit beneath a cold, blank-faced mask (*Lord of the Mysteries*, Ch. 946, 1266, 1335; Wiki: *Fool Pathway*). | **Incomplete (Seq 4–3)**: Victorian coat shrouded in a translucent grey-fog vortex with 4 glowing spirit-worm tendrils (`Fog` / `DeepPurple`) and an unstable antique-gold spirit core.<br>**Complete (Seq 2–1)**: Dark translucent purple/fog cloak (`Glass` + `Neon`), cold blank facial mask (`Text`), antique-gold spirit halo, and 4 slick tentacle appendages of Worms of Spirit beneath the hem. |
| **Marauder / Error** | **Worms of Time** | **Canon**: Translucent, thumb-length worms marked by 8 to 12 transparent rings etched with swirling three-dimensional time patterns (resembling knots and clock numerals). At Sequences 4–3 (*Parasite* / *Mentor of Deceit*), the incomplete form is a writhing swarm of ringed Worms of Time. At Sequences 2–1 (*Trojan Horse of Destiny* / *Worm of Time*), the complete form coils into the phantom of a twelve-section ancient stone clock manipulating time (*Lord of the Mysteries*, Ch. 965, 1170, 1369; Wiki: *Error Pathway*). | **Incomplete (Seq 4–3)**: Partial bronze clock arc behind the shoulders with coiled translucent silver Worms of Time and crimson etched time-rings.<br>**Complete (Seq 2–1)**: Full ancient stone-and-bronze 12-section phantom clock wheel (`Stone` / `Bronze`) behind the torso, asymmetric crimson hour and bronze minute hands, ringed Worms of Time, and a temporal crown ring. |
| **Apprentice / Door** | **Worms of Star** | **Canon**: Luminous, sapphire-like cosmos/starlight insects whose bodies bend into a semi-circle resembling tiny illusory doors. At Sequences 4–3 (*Secrets Sorcerer* / *Wanderer*), the incomplete form is a cluster of glowing Worms of Star. At Sequences 2–1 (*Planeswalker* / *Key of Stars*), the complete form is a towering astral figure of light built from layers of real and illusory doors ("Door of all Doors") (*Lord of the Mysteries*, Ch. 1199, 1270, 1351; Wiki: *Door Pathway*). | **Incomplete (Seq 4–3)**: Teal threshold lintel, silver astral pillar shards, and arched starlight Worm of Star door-segments orbiting the torso.<br>**Complete (Seq 2–1)**: Nested outer teal and inner silver astral door jambs and lintels ("Door of All Doors") framing a luminous starlight core, flanked by semi-circular Worms of Star and a starlight key-seal halo. |

## 3. Earlier Foundation Corrections

| Supplied description | Foundation choice | Reason for review |
|---|---|---|
| Door Sequence 4 “Secrets Supplicant” | `Secrets Sorcerer` | Secrets Supplicant belongs to the Hanged Man pathway and is not Door Sequence 4. |
| Error Sequence 2 “Trojan” | `Trojan Horse of Destiny` | Uses the full English sequence title (also translated as Trojan Horse of Fate). |
| Clown gains flame jumping and paper substitutes | `Flame Jump` and `Paper Figurine Substitute` at `Magician` (7) | Avoids assigning Magician stagecraft tricks to Clown (8). |
| Dream Stealer implies unrestricted dream infiltration | `Thought Theft` as primary; `Dream Intrusion` explicitly marked as gameplay adaptation | Avoids inferring unrestricted dream-world mechanics solely from a sequence title. |
| Faceless can freely change any body | `Disguise` with bounded persona profiles (`Wanderer`, `Archivist`) | Exact physical constraints are bounded to server-validated disguise statuses. |
| Miracle Invoker freely warps reality | `Wish Fulfillment` with accumulated `WishCredits` | Gameplay enforces prerequisites and bounded restoration rather than arbitrary reality edits. |

## 4. Documented Gameplay-vs-Canon Conflicts & Visual Truthfulness

Where existing server mechanics in [`EffectService.lua`](file:///c:/Roblox/src/ServerScriptService/Services/EffectService.lua) intentionally simplify or differ from *Lord of the Mysteries* canon for bounded multiplayer balance, gameplay is **preserved without silent balance changes** and visuals depict what the executor actually does:

| Ability ID & Name | Sequence | Canon Motif vs. Server Executor Conflict | Visual & UI Resolution |
|---|---|---|---|
| `Seer_2_Secondary` — **Miracle of Recovery** | Fool Seq 2 (*Miracle Invoker*) | Row tuple lists `"NPC"` as default target, but `Operation.Secondary` specifies `Target="Self", Kind="Wish", Power=0.6`, which [`AbilityData.lua`](file:///c:/Roblox/src/ReplicatedStorage/Shared/AbilityData.lua) resolves to a **self-targeted** heal + spirituality restoration consuming `WishCredits`. | Presented as a self-centered restorative miracle (`MiracleMend` cupped-hands gesture, converging golden thread beams into the caster's chest, `StarBurst`, and `Hourglass` renewal stencil) rather than a false outbound projectile. |
| `Seer_1` — **Grafting** | Fool Seq 1 (*Attendant of Mysteries*) | In canon, Grafting splices physical/conceptual connections broadly; in gameplay, `Kind="Graft"` links nearby enemies within radius to reflect a portion of incoming damage (`GraftReflected`). | Visualized with a splicing hand gesture, a central `Thread` + `Seal` knot at the target point, spirit threads linking confirmed `e.Affected` targets, and a reactive beam flare only when `GraftReflected` actually fires. |
| `Seer_1_Secondary` — **Realm of Mysteries** | Fool Seq 1 (*Attendant of Mysteries*) | "Realm of Mysteries" is a gameplay-proposed name for lowering a veiled mystery curtain/domain; executor applies AoE damage and `Stasis` for 4s. | Visualized as a descending `Crown` + flanking grey-fog `Veil` curtains and `Seal` stasis marks on confirmed `e.Affected` victims. |
| `Marauder_5_Secondary` — **Dream Intrusion** | Error Seq 5 (*Dream Stealer*) | In canon, Dream Stealers infiltrate dreams to influence or steal from targets; the server executor implements this as a direct hit plus `Burning` damage-over-time (`Status="Burning", Duration=5`). | Visualized as a crimson nightmare slash (`Dream` tear gesture, crimson `Cut`, dark `Veil`, and rising crimson ember motes) and described in the Journal as searing nightmare damage over time so the burning status is visually coherent. |
| `Marauder_3_Secondary` — **Belief Misdirection** | Error Seq 3 (*Mentor of Deceit*) | Proposed gameplay name; server executor uses `Kind="Control", Duration=10` to temporarily convert an eligible hostile NPC's allegiance (`Controlled`). | Visualized with an inverted-allegiance `Belief` gesture, a crimson `Crown` above the target's head, and a control thread beam, matching the actual temporary summon/control state. |
| `Marauder_2_Secondary` — **Hidden Destiny Payload** | Error Seq 2 (*Trojan Horse of Destiny*) | Proposed gameplay name; plants a caster-private `Payload` status that detonates (`PayloadTriggered`) when the victim acts or the timer expires. | Pre-detonation status remains strictly private to the authorizing caster; public crimson `Cut` + `Star` + `Split` burst renders only when the server broadcasts `PayloadTriggered`. |
| `Apprentice_8_Secondary` — **Wind Trick** | Door Seq 8 (*Trickmaster*) | In canon, Wind Trick creates gusts to push, cushion, or deflect; the server executor applies AoE damage and `TimeSlow` (`Duration=4`) without physics knockback. | Visualized with swirling wind-current beams, a grounded vortex ring, and `Circle` slow marks on confirmed `e.Affected` targets, without fake root displacement. |
| `Apprentice_7_Secondary` — **Danger Reading** | Door Seq 7 (*Astrologer*) | Astrological danger premonition is represented in gameplay as a self `Shielded` buff (`Duration=12`) that reduces incoming damage. | Visualized with a protective `Ward` forearm guard gesture, an astral `DoorFrame` threshold, and an `Arch` + `Star` premonition ward. |
| `Apprentice_6` / `Apprentice_6_Secondary` / `Apprentice_2` — **Record / Release Recording / Replication** | Door Seq 6 (*Scribe*) & Seq 2 (*Planeswalker*) | Instead of copying arbitrary player scripts, the server records an allowlisted NPC power (`ArcBolt`) with 3 charges (`RecordedCharges`) and releases it as a scaled offensive projection. | HUD slots and Journal explicitly display the recorded power name and remaining charge count (`1`–`3`); `Record` pulls a `Star` symbol into an open `Book` stencil, while `Release Recording` and `Replication` project outbound beams and star bursts from single or dual astral tomes. |

## 5. Complete 54-Ability Choreography & Motif Audit (`[UNVERIFIED]` Canon Scope)

| Pathway | Seq | Sequence Name | Primary Ability (Profile / Stencil) | Secondary Ability (Profile / Stencil) |
|---|---|---|---|---|
| **Seer / Fool** | 9 | Seer | `Seer_9` Divination (`Divination` / `Card`) | `Seer_9_Secondary` Spirit Vision (`Reading` / `Eye`) |
| **Seer / Fool** | 8 | Clown | `Seer_8` Acrobatic Evasion (`Acrobat` / `Circle`) | `Seer_8_Secondary` Composure (`Composure` / `Scale`) |
| **Seer / Fool** | 7 | Magician | `Seer_7` Flame Jump (`Flame` / `Flame`) | `Seer_7_Secondary` Paper Figurine Substitute (`Paper` / `Card`) |
| **Seer / Fool** | 6 | Faceless | `Seer_6` Disguise (`Veil` / `Mask`) | `Seer_6_Secondary` Voice Mimicry (`Voice` / `Circle`) |
| **Seer / Fool** | 5 | Marionettist | `Seer_5` Spirit Body Threads (`Puppet` / `Thread`) | `Seer_5_Secondary` Marionette Command (`Command` / `Thread`) |
| **Seer / Fool** | 4 | Bizarro Sorcerer | `Seer_4` Marionette Exchange (`Exchange` / `Thread`) | `Seer_4_Secondary` Bizarre Illusion (`Illusion` / `Mask`) |
| **Seer / Fool** | 3 | Scholar of Yore | `Seer_3` Historical Projection (`History` / `Hourglass`) | `Seer_3_Secondary` Historical Recall (`Recovery` / `Hourglass`) |
| **Seer / Fool** | 2 | Miracle Invoker | `Seer_2` Wish Fulfillment (`Miracle` / `Star`) | `Seer_2_Secondary` Miracle of Recovery (`MiracleMend` / `Star`) |
| **Seer / Fool** | 1 | Attendant of Mysteries | `Seer_1` Grafting (`Graft` / `Thread`) | `Seer_1_Secondary` Realm of Mysteries (`Domain` / `Crown`) |
| **Marauder / Error** | 9 | Marauder | `Marauder_9` Pickpocket (`Pickpocket` / `Split`) | `Marauder_9_Secondary` Stealth (`Stealth` / `Split`) |
| **Marauder / Error** | 8 | Swindler | `Marauder_8` Deception (`Deceit` / `Split`) | `Marauder_8_Secondary` Misdirection (`Misdirection` / `Cut`) |
| **Marauder / Error** | 7 | Cryptologist | `Marauder_7` Decipher (`Decipher` / `Book`) | `Marauder_7_Secondary` Information Interpretation (`Interpret` / `Split`) |
| **Marauder / Error** | 6 | Prometheus | `Marauder_6` Ability Theft (`Theft` / `Split`) | `Marauder_6_Secondary` Energy Theft (`EnergyTheft` / `Cut`) |
| **Marauder / Error** | 5 | Dream Stealer | `Marauder_5` Thought Theft (`Thought` / `Split`) | `Marauder_5_Secondary` Dream Intrusion (`Dream` / `Cut`) |
| **Marauder / Error** | 4 | Parasite | `Marauder_4` Parasitism (`Parasite` / `Thread`) | `Marauder_4_Secondary` Vitality Siphon (`Siphon` / `Split`) |
| **Marauder / Error** | 3 | Mentor of Deceit | `Marauder_3` Spiritual Deception (`Mentor` / `Mask`) | `Marauder_3_Secondary` Belief Misdirection (`Belief` / `Crown`) |
| **Marauder / Error** | 2 | Trojan Horse of Destiny | `Marauder_2` Destiny Infiltration (`Destiny` / `Cut`) | `Marauder_2_Secondary` Hidden Destiny Payload (`Payload` / `Star`) |
| **Marauder / Error** | 1 | Worm of Time | `Marauder_1` Time Theft (`Time` / `Clock`) | `Marauder_1_Secondary` Temporal Delay (`TimeDelay` / `Clock`) |
| **Apprentice / Door** | 9 | Apprentice | `Apprentice_9` Door Opening (`Threshold` / `Key`) | `Apprentice_9_Secondary` Passage Sense (`Passage` / `Key`) |
| **Apprentice / Door** | 8 | Trickmaster | `Apprentice_8` Spark Trick (`Trick` / `Star`) | `Apprentice_8_Secondary` Wind Trick (`Wind` / `Circle`) |
| **Apprentice / Door** | 7 | Astrologer | `Apprentice_7` Astrological Divination (`Astrology` / `Star`) | `Apprentice_7_Secondary` Danger Reading (`Ward` / `Arch`) |
| **Apprentice / Door** | 6 | Scribe | `Apprentice_6` Record (`Record` / `Book`) | `Apprentice_6_Secondary` Release Recording (`Release` / `Book`) |
| **Apprentice / Door** | 5 | Traveler | `Apprentice_5` Travel (`Travel` / `Door`) | `Apprentice_5_Secondary` Spatial Door (`Door` / `Key`) |
| **Apprentice / Door** | 4 | Secrets Sorcerer | `Apprentice_4` Concealment (`Conceal` / `Door`) | `Apprentice_4_Secondary` Spatial Seal (`Seal` / `Seal`) |
| **Apprentice / Door** | 3 | Wanderer | `Apprentice_3` Wandering (`Wandering` / `Arch`) | `Apprentice_3_Secondary` Spatial Concealment (`Pocket` / `Door`) |
| **Apprentice / Door** | 2 | Planeswalker | `Apprentice_2` Replication (`Replica` / `Book`) | `Apprentice_2_Secondary` Planar Travel (`Planar` / `Arch`) |
| **Apprentice / Door** | 1 | Key of Stars | `Apprentice_1` Star Gate (`Gate` / `Key`) | `Apprentice_1_Secondary` Spatial Closure (`Closure` / `Seal`) |

## 6. F–I Original World & Character Art Additions

[EXISTING] Gasworks Court, Ashen Depot, Masked Conservatory, Silent Cloister, Broken Observatory and Sanctum of Seals are original game district names. Lamplight Ruffian, Veiled Penitent, Brass-Masked Prowler, Cloister Apparition, Bound Astronomer and Warden of the Last Arch are original enemy designs. None is asserted to be a canon location, creature or named character.

[EXISTING] Coats, top hats, veils, bronze mechanisms, door arches and seals express the Art Bible's canon-inspired Victorian mood. Exact clothing, choreography, proportions, phase cues and combat silhouettes are original gameplay/art interpretations. All existing unverified ability placement/scope metadata remains `[UNVERIFIED]`.
