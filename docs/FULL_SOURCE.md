# Full source — Mysteries Roblox foundation

# Mysteries — playable Roblox foundation

> **Visual overhaul — Phase 1:** the current build includes a themed HUD, Journal/Pathway/Inventory tabs, confirmation-based potion UI, custom prompts, feedback and F8-only developer diagnostics. [Full copy-ready code and script destinations](docs/PHASE1_UI_CODE.md) · [Studio checklist and exact screenshot requests](docs/PHASE1_UI.md). World relayout and permanent label replacement remain later visual phases.

The six requested implementation phases are represented in this project: data, server progression/persistence, all 54 selected ability executors across Sequences 9–1, HUD/input, procedural NPCs/world, and a first balance pass. The roster remains **Seer/Fool, Marauder/Error, and Apprentice/Door only**, with no Sequence 0.

This is a playable foundation with bounded gameplay interpretations of the powers, not an exhaustive recreation of every canonical technique. All lore claims remain `[UNVERIFIED]` because source access was blocked. Audio hooks await original sound assets; disguises use original face masks, color/identity changes and R15 body scaling rather than arbitrary species or live voice cloning. See `docs/LORE_REVIEW.md`.

## Open and play

1. Open the supplied **`build/Mysteries.rbxlx`** in desktop Roblox Studio and press **Play**. The server generates the sanctuary, potion altar, archives, practice doors, flame anchors, six arenas, and 18 procedural enemies. The client creates its HUD in PlayerGui from modules under StarterPlayerScripts/UI.
2. Open the **journal [B]**, drink one of the three starter potions, and aim at nearby enemies or ground when using abilities.
3. Use **Q, E, R, F, Z, X** for the six equipped abilities. **Left click** is a basic strike. Touch users have hotbar, journal, and strike buttons; touch targeting uses the center of the camera.
4. In the journal select a numbered slot, then select an unlocked ability to equip it. Earlier powers remain available as sequence numbers decrease.

Studio defaults to **session-only storage**, clearly marked in the HUD. No Studio API access is required for that demo and progress does not survive the server closing. Published servers always use real DataStoreService; they never silently fall back to volatile storage.

**F8 developer controls** provide Studio-only mastery for the individual creator or a server-allowlisted user. They require Studio and session-only storage; public mastery stones are removed. See `docs/PHASE1_UI.md` for unpublished-place setup. Unauthorized remote requests cannot grant mastery.

## Progression loop

Each successful current-sequence acting objective awards **5 digestion**, with a **30-second reward cooldown** and server event deduplication. Read the objective in the HUD. Normal advancement requires 100 digestion; unsafe attempts are rejected and drain sanity. Completing an objective also accumulates a wish credit for later miracles.

Enemy kills award 25 gold. Open the sanctuary's **Potion Altar**, review and confirm the 100-gold purchase, then drink the next potion through Inventory's confirmation card. The transaction requires the correct pathway, exactly the next sequence, inventory ownership, a living normal-state character, adequate sanity and full digestion. It consumes one potion atomically without yielding and resets digestion/acting progress. Sequence 1 has no next potion.

The **Stabilization** pillar restores sanity and ends madness/loss of control at a cost of 20 digestion. Zero sanity enters 10 seconds of madness, followed by death and loss of control. After respawning, use Stabilization before casting again. High-tier arenas cause mystical exposure and whispers; mental resistance reduces sanity damage. Spirituality regenerates on a fixed scheduler, more slowly in combat.

Some acting objectives require interactions rather than simply pressing an ability:

| Sequence | How to complete the objective |
|---|---|
| Seer 8 | Let an actual hostile strike land during Acrobatic Evasion's invulnerability window. |
| Seer 7 | Flame-jump away from a nearby pursuing enemy using an orange anchor. |
| Seer 6 | Use Disguise, then interact with the Hidden Archive. |
| Seer 5 | Apply Spirit Body Threads three times to one eligible NPC before threads expire. |
| Seer 4 | Exchange with your own marionette while another enemy threatens the original position. |
| Seer 3 | Read the Hidden Archive, then invoke a historical echo. |
| Seer 2 | Fulfill a real recovery need, spending an accumulated wish credit. |
| Seer 1 | Graft an enemy, then let its actual attack reflect back to it. |
| Marauder 7 | Cast Decipher, then interact with the Cipher Archive while Cipher Sight lasts. |
| Apprentice 6 | Observe an eligible enemy casting, then Record its allowlisted power. |
| Apprentice 4 | Use Concealment, then protect the Hidden Archive by interacting while concealed. |
| Apprentice 2 | Equip retained Record and Replication; record a witnessed power, then release it. |

Other objectives complete on the corresponding successful server-validated theft, deception, divination, hostile influence, travel, or gate creation. Divination can fail; Intuition improves its accuracy. Targets that are too strong resist longer control/debuff effects. Direct marionette control and parasitism reject stronger-sequence NPCs. There is no PvP or player mind control.

## Studio persistence verification

To test actual persistence, publish a development place you control, set `RuntimeConfig.StudioSessionOnly=false`, and enable **Game Settings → Security → Enable Studio Access to API Services**. Use a separate development DataStore name rather than a production save. Restart the test server and confirm saved state returns. These real Roblox API checks were **not run** in the Linux cloud environment.

The store uses owner tokens and expiring leases acquired via UpdateAsync, bounded exponential backoff with jitter, owner-checked save/refresh/release, 45-second lease refresh/full saves, and PlayerRemoving/BindToClose handling. Failed loads never become default saves; malformed or future schemas are rejected. Schema version 1 is supported. Sanity, pathway, sequence, digestion, acting counts, computed stat snapshots, inventory, currency, credits and loadout are saved. Max stats are recomputed from data on load; health/spirituality refill on spawn. Runtime statuses, temporary copied powers and cooldowns are not persisted.

## Project layout and Studio placement

```text
ReplicatedStorage/Shared                  ModuleScripts: immutable data/types/config
  Pathways/{Seer,Marauder,Apprentice}      ModuleScripts: each pathway's 9 rows
ServerScriptService
  Bootstrap                              Script: Bootstrap.server.lua
  Domain/{PlayerDomain,SessionStore,RateLimiter}  ModuleScripts: pure server rules
  Services/{WorldService,EffectService}   ModuleScripts: Roblox engine adapters
StarterPlayer/StarterPlayerScripts
  Mysteries                              LocalScript: Mysteries.client.lua
StarterGui                               Reserved; HUD is created in PlayerGui
```

For manual copy/paste, `docs/FULL_SOURCE.md` includes every production script, its exact Studio destination and class, and the Rojo configuration. Folders must match the hierarchy. Do not insert server modules under ReplicatedStorage. No extra toolbox assets, packages, remotes, or prebuilt GUIs are needed; the server creates its remotes.

Rojo 7.5.1 can synchronize this layout using `default.project.json`. You can build the standalone place with:

```sh
cd /workspace/Roblox
/workspace/lotm-tools/rojo/rojo build default.project.json -o build/Mysteries.rbxlx
```

Use the existing isolated checkout for cloud tasks; do not create a worktree unless explicitly requested.

## Validation and reusable tooling

The tools install outside the repository under `/workspace/lotm-tools`. The installer pins Luau 0.693 to its full Git commit, Rojo 7.5.1, luau-lsp 1.70.1, and the matching Roblox API definitions. Download and extracted-file hashes are checked using `scripts/tools.json`; these are reproducibility pins from the TLS-verified upstream downloads, not upstream signature claims. Existing modified Luau sources are preserved and rejected for builds.

```sh
cd /workspace/Roblox
python3 scripts/setup_tools.py
python3 scripts/check.py
python3 scripts/package.py
```

Validation covers:

- **1,306 data assertions:** roster, references, stats, jumps, bounds and immutability.
- **2,163 domain assertions:** complete 9→1 advancement, acting deduplication, sanity, resources, cast reservations, lease contention/expiry, corrupt saves, retries and ambiguous committed responses.
- **388 executor/target assertions:** all 54 abilities across 28 handlers, ownership/range/visibility checks, limited loot and recordings, safe teleport rejection, real adapter damage decisions, one-use substitutes, graft reflections, and high-tier resistance. Roblox engine dependencies are mocked.
- **221 UI assertions:** responsive geometry, preview/confirm/cancel behavior, prompt lifecycle, role checks and GUI component updates with engine stand-ins.
- Compilation of production and test Luau, strict Roblox API/type analysis, a real Rojo place build, and inspection that every script in the place exactly matches its source.

The domain and adapter boundaries deliberately accept validated dynamic profile/config/entity tables (`any`); strict mode does not replace runtime checks. No errors are suppressed with `--!nocheck`.

Roblox rendering, physics, live multiplayer remotes, actual DataStore access, and Studio import/play remain unverified here. `docs/STUDIO_TESTS.md` supplies the engine verification checklist. Neither Roblox publication nor cloud environment publication has been performed.

## Data and extension points

`GameData` provides deeply frozen registries. Each sequence exports base stats, absolute multipliers, two selected powers, passive descriptions and an acting objective. See `docs/STATS.md` for all 27 numeric rows. Digestion is separate progression state; sanity remains capped at 100. Perception is Spirit Vision range in studs; Resistance is a rating.

Add a ModuleScript under `Shared/Pathways` returning the `Types.Pathway` schema or calling `PathwayFactory`. Discovery, potion generation and ability registries require no central roster edits. A factory module supplies nine rows ordered **9 → 1**, a source URL, and optional custom base stats as the fifth argument. Row structure:

```lua
{sequenceName, primaryName, actingLabel, serverSignal, primaryDescription,
 passiveDescription, primaryTarget,
 {secondaryName, secondaryTarget, secondaryDescription},
 {Primary={Kind="Buff", Status="Shielded", Duration=10},
  Secondary={Kind="Sense", Status="Vision", Duration=20}}}
```

Targets are `Self`, `NPC`, or `Position`. Existing operation kinds can be composed through data; a genuinely new mechanic requires a server handler. The current release's tests intentionally assert three pathways and 54 selected abilities and must be expanded with the roster. Reuse documented internal signals for event-based acting, never client-claimed completions. Keep stable IDs when persistence exists.

Generic cooldown/cost/range/scaling lives in `AbilityData`/`StatData`; per-power operation options live in the pathway modules. NPC, exposure, purchase, hit and resource settings live in the shared configuration modules. Clients may read this public balance data but cannot authorize mutations. See `docs/SERVER_CONTRACTS.md` for the implementation boundaries.


## src/ReplicatedStorage/Shared/AbilityData.lua

**ModuleScript** at `ReplicatedStorage/Shared/AbilityData`. Create matching Folder parents.

```lua
--!strict
local Pathways = require(script.Parent.PathwayData)
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
local byId: {[string]: Types.Ability} = {}
for pathwayId, pathway in pairs(Pathways) do
    for n, sequence in pairs(pathway.Sequences) do
        local tier = sequence.StatMultipliers.Health
        local sourceModule = script.Parent.Pathways:FindFirstChild(pathwayId)
        assert(sourceModule, "Missing pathway module")
        -- Authored ability metadata lives in each pathway's AbilityDefinitions.
        for _, definition in ipairs(pathway.AbilityDefinitions) do
            if definition.UnlockSequence ~= n then continue end
            local ability: any = table.clone(definition)
            ability.PathwayId = pathwayId
            ability.Canon = sequence.Canon
            ability.CooldownSeconds = 5 + (9-n)*2
            ability.SpiritualityCost = math.round(12 * tier)
            ability.CastTimeSeconds = if n <= 4 then 1.5 else 0.5
            ability.RangeStuds = math.round(25 * math.sqrt(tier))
            ability.RadiusStuds = if n <= 4 then math.round(6*math.sqrt(tier)) else 0
            ability.MaxTargets = if n <= 4 then 4 else 1
            -- Abstract effect budget, not unconditional damage. Executor interprets by ability.
            ability.BasePower = math.round(10*tier)
            ability.Hitbox = {Shape=if ability.Target == "NPC" then "SingleTarget" else "None", LineOfSight=true}
            ability.StatusEffects = definition.StatusEffects or {}
            ability.VFXHook = "Ability."..ability.Id..".VFX"
            ability.SFXHook = "Ability."..ability.Id..".SFX"
            local operation=ability.Operation
            ability.Implemented = operation ~= nil
            if operation then
                ability.Target = operation.Target or ability.Target
                ability.RangeStuds = operation.Range or ability.RangeStuds
                ability.StatusEffects = if operation.Status then {operation.Status} else {}
                ability.Hitbox.Shape = if ability.Target == "NPC" then "SingleTarget" else "None"
            end
            assert(byId[ability.Id] == nil, "Duplicate ability ID")
            byId[ability.Id] = ability
        end
    end
end
return freeze(byId)
```


## src/ReplicatedStorage/Shared/Freeze.lua

**ModuleScript** at `ReplicatedStorage/Shared/Freeze`. Create matching Folder parents.

```lua
--!strict
-- Return deeply immutable configuration. Never put live player state in these tables.
local function freeze(value: any): any
    if type(value) == "table" and not table.isfrozen(value) then
        for _, child in pairs(value) do
            freeze(child)
        end
        table.freeze(value)
    end
    return value
end
return freeze
```


## src/ReplicatedStorage/Shared/GameData.lua

**ModuleScript** at `ReplicatedStorage/Shared/GameData`. Create matching Folder parents.

```lua
--!strict
-- Shared data only. The client may read it; only server services mutate player state.
local freeze = require(script.Parent.Freeze)
return freeze({
    Runtime=require(script.Parent.RuntimeConfig),
    Pathways=require(script.Parent.PathwayData),
    Abilities=require(script.Parent.AbilityData),
    Potions=require(script.Parent.PotionData),
    Stats=require(script.Parent.StatData),
    Progression=require(script.Parent.ProgressionConfig),
    StatusEffects=require(script.Parent.StatusEffectData),
})
```


## src/ReplicatedStorage/Shared/PathwayData.lua

**ModuleScript** at `ReplicatedStorage/Shared/PathwayData`. Create matching Folder parents.

```lua
--!strict
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
local byId: {[string]: Types.Pathway} = {}
-- Adding a pathway requires only a ModuleScript in Pathways with this schema.
for _, module in ipairs(script.Parent.Pathways:GetChildren()) do
    if module:IsA("ModuleScript") then
        local pathway = require(module) :: Types.Pathway
        assert(type(pathway.Id) == "string" and byId[pathway.Id] == nil, "Invalid or duplicate pathway ID")
        assert(pathway.Sequences[0] == nil, "Sequence 0 is unavailable")
        for n=1,9 do
            assert(pathway.Sequences[n] and pathway.Sequences[n].Number == n, "Missing sequence")
        end
        byId[pathway.Id] = pathway
    end
end
return freeze(byId)
```


## src/ReplicatedStorage/Shared/PathwayFactory.lua

**ModuleScript** at `ReplicatedStorage/Shared/PathwayFactory`. Create matching Folder parents.

```lua
--!strict
local Stats = require(script.Parent.StatData)
local freeze = require(script.Parent.Freeze)
-- Internal construction helper; no discovery, player state, or runtime systems.
return function(id: string, alias: string, rows: {{any}}, source: string, customBaseStats: any?)
    local base = customBaseStats or Stats.BaseStats[id]
    assert(base, "New pathways must supply custom base stats")
    assert(#rows == 9, "Exactly nine rows required, ordered Sequence 9 to 1")
    local sequences = {}
    local abilities = {}
    for index, row in ipairs(rows) do
        local n = 10-index
        table.insert(abilities, {Id=id.."_"..tostring(n), UnlockSequence=n, Name=row[2],
            Description=row[5], Target=row[7], StatusEffects={}, Operation=row[9] and row[9].Primary})
        local ids = {id.."_"..tostring(n)}
        local extra = row[8]
        if extra then
            local extraId = id.."_"..tostring(n).."_Secondary"
            table.insert(ids, extraId)
            table.insert(abilities, {Id=extraId, UnlockSequence=n, Name=extra[1],
                Description=extra[3], Target=extra[2], StatusEffects={}, Operation=row[9] and row[9].Secondary})
        end
        sequences[n] = {
            Number=n, Name=row[1],
            Canon={status="[UNVERIFIED]", note="Name, power placement and passive require source review; wiki access blocked during authoring.", sources={source}},
            StatMultipliers=Stats.GetMultipliers(n), BaseStats=Stats.Scale(base,n),
            AbilityIds=ids, PassiveTraits={"[UNVERIFIED] "..row[6]},
            ActingObjectives={{Id=id.."_"..tostring(n).."_acting", Label=row[3], ServerSignal=row[4],
                RequiredCount=1, DigestionReward=5, ActingProgressReward=1, CooldownSeconds=30}},
        }
    end
    return freeze({Id=id, Name=id, Alias=alias, BaseStats=base, Sequences=sequences, AbilityDefinitions=abilities})
end
```


## src/ReplicatedStorage/Shared/Pathways/Apprentice.lua

**ModuleScript** at `ReplicatedStorage/Shared/Pathways/Apprentice`. Create matching Folder parents.

```lua
--!strict
local make = require(script.Parent.Parent.PathwayFactory)
return make("Apprentice", "Door", {
    {"Apprentice", "Door Opening", "Open a server-designated locked passage", "LockedPassageOpened", "Gameplay proposal for door opening; exact canon scope and restrictions require review.", "Sensitivity to passages", "Position", {"Passage Sense", "Self", "Proposed sense of tagged passages; exact canon scope unverified."}, {Primary={Kind="OpenDoor", Target="Position", Range=30, Signal="LockedPassageOpened"}, Secondary={Kind="SenseDoors", Target="Self", Status="Vision", Duration=20}}},
    {"Trickmaster", "Spark Trick", "Distract an eligible hostile NPC using a trick", "HostileDistracted", "Gameplay proposal for spark trick; exact canon scope and restrictions require review.", "Minor magical tricks", "Position", {"Wind Trick", "Position", "Create a small wind effect for misdirection."}, {Primary={Kind="Debuff", Target="NPC", Status="Confused", Duration=4, Power=1, Signal="HostileDistracted"}, Secondary={Kind="Area", Target="Position", Status="TimeSlow", Duration=4, Power=0.5}}},
    {"Astrologer", "Astrological Divination", "Resolve a star reading against a server-known outcome", "StarReadingResolved", "Gameplay proposal for astrological divination; exact canon scope and restrictions require review.", "Astrological intuition", "Self", {"Danger Reading", "Self", "Interpret a server-authored omen from an astrological reading."}, {Primary={Kind="Sense", Target="Self", Status="Vision", Duration=20, Signal="StarReadingResolved"}, Secondary={Kind="Buff", Target="Self", Status="Shielded", Duration=12}}},
    {"Scribe", "Record", "Record an eligible observed power", "EligiblePowerRecorded", "Gameplay proposal for record; exact canon scope and restrictions require review.", "Recording of supernatural powers", "NPC", {"Release Recording", "NPC", "Release a previously recorded eligible power; borrowed power must pass server allowlists."}, {Primary={Kind="Record", Target="NPC", Signal="EligiblePowerRecorded"}, Secondary={Kind="Release", Target="NPC", Power=1.7}}},
    {"Traveler", "Travel", "Reach a server-designated destination through travel", "TravelDestinationReached", "Gameplay proposal for travel; exact canon scope and restrictions require review.", "Spirit-world navigation", "Position", {"Spatial Door", "Position", "Connect two validated nearby points through a travel door."}, {Primary={Kind="Travel", Target="Position", Signal="TravelDestinationReached"}, Secondary={Kind="Portal", Target="Position", Duration=25}}},
    {"Secrets Sorcerer", "Concealment", "Protect a scripted secret with spatial concealment", "SecretProtected", "Gameplay proposal for concealment; exact canon scope and restrictions require review.", "Concealment of space", "Position", {"Spatial Seal", "Position", "Proposed temporary seal around a bounded space."}, {Primary={Kind="Conceal", Target="Self", Status="Concealed", Duration=18, Signal="SecretProtected"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=5, Power=1}}},
    {"Wanderer", "Wandering", "Reach a marked remote location through spatial wandering", "WanderingDestinationReached", "Gameplay proposal for wandering; exact canon scope and restrictions require review.", "Extended spatial travel", "Position", {"Spatial Concealment", "Self", "Conceal a traveler in a bounded encounter area."}, {Primary={Kind="Travel", Target="Position", Status="Concealed", Duration=15, Signal="WanderingDestinationReached"}, Secondary={Kind="Buff", Target="Self", Status="Concealed", Duration=15}}},
    {"Planeswalker", "Replication", "Reproduce an eligible recorded phenomenon", "PhenomenonReplicated", "Gameplay proposal for replication; exact canon scope and restrictions require review.", "Knowledge of other planes", "Position", {"Planar Travel", "Position", "Travel between authored destinations rather than arbitrary universes."}, {Primary={Kind="Release", Target="NPC", Power=3, Signal="PhenomenonReplicated"}, Secondary={Kind="Travel", Target="Position", Status="Shielded", Duration=10}}},
    {"Key of Stars", "Star Gate", "Connect two authorized locations with a stable gate", "AuthorizedGateConnected", "Gameplay proposal for star gate; exact canon scope and restrictions require review.", "Authority over space", "Position", {"Spatial Closure", "Position", "Close an eligible spatial connection under server ownership rules."}, {Primary={Kind="Portal", Target="Position", Duration=40, Signal="AuthorizedGateConnected"}, Secondary={Kind="CloseSpace", Target="Position", Status="Stasis", Duration=6, Power=2}}},
}, "https://lordofthemysteries.fandom.com/wiki/Door_Pathway/Abilities")
```


## src/ReplicatedStorage/Shared/Pathways/Marauder.lua

**ModuleScript** at `ReplicatedStorage/Shared/Pathways/Marauder`. Create matching Folder parents.

```lua
--!strict
local make = require(script.Parent.Parent.PathwayFactory)
return make("Marauder", "Error", {
    {"Marauder", "Pickpocket", "Steal a marked item from an eligible hostile NPC", "HostileItemStolen", "Gameplay proposal for pickpocket; exact canon scope and restrictions require review.", "Dexterous hands", "NPC", {"Stealth", "Self", "Gameplay stealth aid; not supernatural invisibility."}, {Primary={Kind="Theft", Range=8, Signal="HostileItemStolen"}, Secondary={Kind="Buff", Status="Disguised", Duration=12}}},
    {"Swindler", "Deception", "Complete a scripted deception against a hostile NPC", "HostileNPCDeceived", "Gameplay proposal for deception; exact canon scope and restrictions require review.", "Persuasive misdirection", "NPC", {"Misdirection", "NPC", "Distract an eligible hostile target through deception."}, {Primary={Kind="Debuff", Status="Confused", Duration=10, Signal="HostileNPCDeceived"}, Secondary={Kind="Debuff", Status="Confused", Duration=6}}},
    {"Cryptologist", "Decipher", "Solve a server-generated cipher", "CipherSolved", "Gameplay proposal for decipher; exact canon scope and restrictions require review.", "Pattern interpretation", "Self", {"Information Interpretation", "Self", "Interpret a designated clue rather than freely reading player secrets."}, {Primary={Kind="Cipher", Target="Self", Status="CipherSight", Duration=30}, Secondary={Kind="Sense", Target="Self", Status="Vision", Duration=20}}},
    {"Prometheus", "Ability Theft", "Steal a temporary power from an eligible hostile NPC", "HostileAbilityStolen", "Gameplay proposal for ability theft; exact canon scope and restrictions require review.", "Theft of supernatural powers", "NPC", {"Energy Theft", "NPC", "Proposed energy transfer; precise canon scope needs review."}, {Primary={Kind="StealPower", Status="Silenced", Duration=10, Signal="HostileAbilityStolen"}, Secondary={Kind="Siphon", Power=1.3}}},
    {"Dream Stealer", "Thought Theft", "Remove an eligible thought during a scripted encounter", "HostileThoughtStolen", "Gameplay proposal for thought theft; exact canon scope and restrictions require review.", "Perception of thoughts", "NPC", {"Dream Intrusion", "NPC", "Proposed scripted dream encounter; availability at this sequence unverified."}, {Primary={Kind="Debuff", Status="Sleep", Duration=8, Signal="HostileThoughtStolen"}, Secondary={Kind="Debuff", Status="Burning", Duration=5, Power=0.8}}},
    {"Parasite", "Parasitism", "Complete a controlled hostile-NPC parasitism encounter", "HostileParasitismCompleted", "Gameplay proposal for parasitism; exact canon scope and restrictions require review.", "Parasitic concealment", "NPC", {"Vitality Siphon", "NPC", "Proposed host-linked vitality transfer with hard duration and target limits."}, {Primary={Kind="Parasite", Status="Parasite", Duration=12, Signal="HostileParasitismCompleted"}, Secondary={Kind="Siphon", RequiresHost=true, Power=2}}},
    {"Mentor of Deceit", "Spiritual Deception", "Misdirect an eligible hostile spiritual sense", "SpiritualSenseDeceived", "Gameplay proposal for spiritual deception; exact canon scope and restrictions require review.", "Deception of spiritual intuition", "NPC", {"Belief Misdirection", "NPC", "Proposed scripted deception of an NPC belief."}, {Primary={Kind="Debuff", Status="Deceived", Duration=14, Signal="SpiritualSenseDeceived"}, Secondary={Kind="Control", Duration=10}}},
    {"Trojan Horse of Destiny", "Destiny Infiltration", "Complete a scripted infiltration of a marked destiny", "DestinyInfiltrationCompleted", "Gameplay proposal for destiny infiltration; exact canon scope and restrictions require review.", "Destiny concealment", "NPC", {"Hidden Destiny Payload", "NPC", "Proposed delayed destiny effect; exact canon mechanism unverified."}, {Primary={Kind="Infiltrate", Target="NPC", Status="Payload", Duration=12, Signal="DestinyInfiltrationCompleted"}, Secondary={Kind="Debuff", Status="Payload", Duration=10}}},
    {"Worm of Time", "Time Theft", "Resolve a scripted time-theft encounter", "TimeTheftEncounterResolved", "Gameplay proposal for time theft; exact canon scope and restrictions require review.", "Temporal perception", "NPC", {"Temporal Delay", "NPC", "Proposed short bounded time distortion, never control of the server clock."}, {Primary={Kind="Debuff", Status="TimeSlow", Duration=10, Power=2, Signal="TimeTheftEncounterResolved"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=4, Power=2}}},
}, "https://lordofthemysteries.fandom.com/wiki/Error_Pathway/Abilities")
```


## src/ReplicatedStorage/Shared/Pathways/Seer.lua

**ModuleScript** at `ReplicatedStorage/Shared/Pathways/Seer`. Create matching Folder parents.

```lua
--!strict
local make = require(script.Parent.Parent.PathwayFactory)
return make("Seer", "Fool", {
    {"Seer", "Divination", "Resolve a divination against a server-known outcome", "DivinationResolved", "Gameplay proposal for divination; exact canon scope and restrictions require review.", "Spiritual sensitivity", "Self", {"Spirit Vision", "Self", "Perceive nearby spiritual traces; server filters revealed information."}, {Primary={Kind="Sense", Signal="DivinationResolved"}, Secondary={Kind="Sense", Status="Vision", Duration=20}}},
    {"Clown", "Acrobatic Evasion", "Evade a hostile strike during a server-validated dodge", "HostileStrikeEvaded", "Gameplay proposal for acrobatic evasion; exact canon scope and restrictions require review.", "Balance and bodily control", "Self", {"Composure", "Self", "Maintain bodily and emotional control under pressure."}, {Primary={Kind="Dodge", Status="Invulnerable", Duration=2}, Secondary={Kind="Buff", Status="Composed", Duration=20}}},
    {"Magician", "Flame Jump", "Escape pursuit using a valid flame anchor", "PursuitEscaped", "Gameplay proposal for flame jump; exact canon scope and restrictions require review.", "Sleight of hand", "Position", {"Paper Figurine Substitute", "Self", "Prepare a substitute against one eligible attack; no unconditional immortality."}, {Primary={Kind="FlameJump", Target="Position", Range=36, Signal="PursuitEscaped"}, Secondary={Kind="Buff", Status="Substitute", Duration=45}}},
    {"Faceless", "Disguise", "Complete an infiltration while maintaining a disguise", "DisguisedInfiltrationCompleted", "Gameplay proposal for disguise; exact canon scope and restrictions require review.", "Control of appearance", "Self", {"Voice Mimicry", "Self", "Adopt a permitted disguise voice profile using original audio."}, {Primary={Kind="Disguise", Profile="Wanderer", Status="Disguised", Duration=40}, Secondary={Kind="Disguise", Profile="Archivist", Status="Disguised", Duration=25}}},
    {"Marionettist", "Spirit Body Threads", "Complete control of an eligible hostile NPC", "MarionetteControlCompleted", "Gameplay proposal for spirit body threads; exact canon scope and restrictions require review.", "Spirit Body Thread perception", "NPC", {"Marionette Command", "NPC", "Issue bounded orders to a server-owned marionette."}, {Primary={Kind="Control", RequiredHits=3, Duration=20, Signal="MarionetteControlCompleted"}, Secondary={Kind="Command", Power=2}}},
    {"Bizarro Sorcerer", "Marionette Exchange", "Survive an encounter using a marionette exchange", "MarionetteEscapeCompleted", "Gameplay proposal for marionette exchange; exact canon scope and restrictions require review.", "Expanded marionette command", "NPC", {"Bizarre Illusion", "Position", "Create a limited deceptive scene; exact canon form needs review."}, {Primary={Kind="Exchange", Target="NPC", Signal="MarionetteEscapeCompleted"}, Secondary={Kind="Area", Status="Confused", Duration=8, Power=1.5}}},
    {"Scholar of Yore", "Historical Projection", "Resolve a historical clue using an authenticated record", "HistoricalClueResolved", "Gameplay proposal for historical projection; exact canon scope and restrictions require review.", "Historical knowledge", "Position", {"Historical Recall", "Self", "Recall an authenticated historical record under explicit limits."}, {Primary={Kind="Echo", Target="Position", Duration=20, Signal="HistoricalClueResolved"}, Secondary={Kind="Recall", Target="Self", Power=0.25}}},
    {"Miracle Invoker", "Wish Fulfillment", "Fulfill a server-assigned wish within its constraints", "WishFulfilled", "Gameplay proposal for wish fulfillment; exact canon scope and restrictions require review.", "Miracle accumulation", "Position", {"Miracle of Recovery", "NPC", "Proposed limited recovery wish with accumulated-wish costs."}, {Primary={Kind="Wish", Target="Self", Signal="WishFulfilled"}, Secondary={Kind="Wish", Target="Self", Power=0.6}}},
    {"Attendant of Mysteries", "Grafting", "Resolve a scripted encounter using a valid graft", "GraftEncounterResolved", "Gameplay proposal for grafting; exact canon scope and restrictions require review.", "Authority over mysteries", "Position", {"Realm of Mysteries", "Position", "Proposed bounded mysterious domain; exact mechanics unverified."}, {Primary={Kind="Graft", Target="Position", Duration=12, Signal="GraftEncounterResolved"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=4, Power=3}}},
}, "https://lordofthemysteries.fandom.com/wiki/Fool_Pathway/Abilities")
```


## src/ReplicatedStorage/Shared/PotionData.lua

**ModuleScript** at `ReplicatedStorage/Shared/PotionData`. Create matching Folder parents.

```lua
--!strict
local Pathways = require(script.Parent.PathwayData)
local freeze = require(script.Parent.Freeze)
local potions = {}
for pathwayId, pathway in pairs(Pathways) do
    for n, sequence in pairs(pathway.Sequences) do
        local id = pathwayId.."_Potion_"..tostring(n)
        potions[id] = {
            Id=id, Name=sequence.Name.." Potion", PathwayId=pathwayId, TargetSequence=n,
            RequiredSequence=if n == 9 then nil else n+1,
            RequiredDigestion=if n == 9 then 0 else 100,
            RequiresUninitiated=n == 9, ConsumedOnSuccess=true,
            InitialDigestion=0, InitialActingProgress=0,
            -- Ingredients and rituals intentionally unavailable pending design/canon review.
            Ingredients={}, RitualId=nil, CraftingEnabled=false,
        }
    end
end
return freeze({ById=potions, Rules={
    StartingSequence=9, HighestSequence=1, AllowPathwaySwitch=false,
    AllowSequenceSkipping=false, AllowEarlyAdvancement=false,
    RequireLivingCharacter=true, RequireInventoryOwnership=true,
    RequireServerTransaction=true, ResetDigestionOnAdvance=true,
    -- If early advancement is enabled later, this penalty must run on the server.
    Risk={BaseChance=0.01, MissingDigestionWeight=0.65, MissingSanityWeight=0.30,
        MinChance=0, MaxChance=0.95, FailureSanityDamage=30},
}})
```


## src/ReplicatedStorage/Shared/ProgressionConfig.lua

**ModuleScript** at `ReplicatedStorage/Shared/ProgressionConfig`. Create matching Folder parents.

```lua
--!strict
local freeze = require(script.Parent.Freeze)
return freeze({
    Digestion={Min=0, Max=100, Default=0, RequireServerVerifiedObjectives=true,
        RewardOnlyCurrentSequence=true, RewardOnlyCurrentPathway=true,
        DeduplicateServerEventIds=true, MaxRewardPerEvent=5},
    Acting={Default=0, Min=0, ObjectiveProgressResetsOnAdvance=true,
        AllowClientReportedCompletion=false, RejectFriendlyTheft=true},
    Sanity={Min=0, Max=100, Default=100, MadnessThreshold=20, FailureThreshold=0,
        MadnessDurationSeconds=10, RecoveryPerSecond=0.2,
        ExposureDrainPerSecond=1, WhisperDrain=3, FailedRitualDrain=15,
        UnsafeRitualDrain=35, RecoveryDigestionPenalty=20,
        LossOfControlState="LostControl", BlockCastingAtZero=true,
        EnterMadnessAtZero=true, TransitionToLostControlAfterMadness=true,
        BlockAdvancementAtOrBelow=20},
    Spirituality={RegenIntervalSeconds=0.5, CombatRegenMultiplier=0.5,
        RegenDelayAfterCastSeconds=2, ClampToMax=true},
    Abilities={RetainEarlierSequenceAbilities=true, MaxEquipped=6,
        ValidateTargetsOnServer=true, ValidateRangeOnServer=true,
        ValidateLineOfSightOnServer=true, RejectUnimplementedAbilities=true,
        InterruptOnDeath=true, GlobalCooldownSeconds=0.2},
    Persistence={SchemaVersion=1, DataStoreName="Mysteries_Player_v1",
        KeyPrefix="Player_", AutosaveSeconds=60, LockLeaseSeconds=180,
        LockRefreshSeconds=45, RetryCount=5, BackoffBaseSeconds=1,
        BackoffMaxSeconds=16, BackoffJitterFraction=0.2,
        UseUpdateAsync=true, RejectSessionLockConflict=true,
        NeverOverwriteOnLoadFailure=true},
    DefaultPlayer={SchemaVersion=1, PathwayId=false, Sequence=false,
        Digestion=0, ActingProgress=0, ObjectiveProgress={},
        Inventory={}, Stats={}, AbilityLoadout={}, StatusEffects={}},
})
```


## src/ReplicatedStorage/Shared/RuntimeConfig.lua

**ModuleScript** at `ReplicatedStorage/Shared/RuntimeConfig`. Create matching Folder parents.

```lua
--!strict
local freeze=require(script.Parent.Freeze)
return freeze({
    -- Only honored in Studio. Published servers always use DataStoreService.
    StudioSessionOnly=true, GenerateDemoWorld=true,
    TickSeconds=0.25, StateIntervalSeconds=0.5, MaxEnemies=18,
    IntentRate=8, IntentBurst=12, MaxMessageLength=180,
    MeleeRange=11, MeleeCooldown=0.55, MeleePowerMultiplier=1.6,
    NPCNoticeRange=65, NPCAttackRange=6, NPCAttackInterval=1.5,
    NPCRespawnSeconds=12, NPCGoldReward=25,
    NPCHealthPerTier=60, NPCMeleeDamagePerTier=6, NPCSpellDamagePerTier=4,
    NPCSpeed=10, NPCSpellRange=28, NPCSpellCooldown=6,
    NPCMentalResistancePerTier=12, MinStatusDurationMultiplier=0.15,
    SummonDamagePerTier=12, SummonAttackInterval=1.5,
    ExposureRadius=30, WhisperInterval=10, NextPotionGoldCost=100,
    MaxOwnedSummons=2, MaxPortalsPerPlayer=2, MaxVFX=48,
    Disguises={
        Wanderer={DisplayName="Unknown Wanderer",Color={100,120,140},VoicePitch=0.85,
            Scales={BodyHeightScale=0.92,BodyWidthScale=1.1,BodyDepthScale=1.05,HeadScale=0.95}},
        Archivist={DisplayName="Archive Custodian",Color={155,125,105},VoicePitch=1.1,
            Scales={BodyHeightScale=1.05,BodyWidthScale=0.9,BodyDepthScale=0.95,HeadScale=1.0}},
    },
    DivinationAccuracy={Base=0.55,Bonus=0.4,IntuitionScale=40},
    CopyableNPCPowers={ArcBolt={Power=1.7,Status="Burning",Duration=3}},
    EnemyTiers={9,7,5,4,2,1},
    SanctuaryRadius=25, WorldRadius=380,
})
```


## src/ReplicatedStorage/Shared/StatData.lua

**ModuleScript** at `ReplicatedStorage/Shared/StatData`. Create matching Folder parents.

```lua
--!strict
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
type Stats = Types.Stats
-- Game balance values, not novel claims. Perception is Spirit Vision range in studs;
-- regen is spirituality/second. Resistance is a rating, not percent immunity.
local bases: {[string]: Stats} = {
    Seer = {Health=100, Spirituality=140, Sanity=100, Strength=10, Agility=12, Perception=45, Intuition=20, Resistance=12, SpiritualityRegen=2.4},
    Marauder = {Health=110, Spirituality=110, Sanity=100, Strength=12, Agility=18, Perception=30, Intuition=14, Resistance=10, SpiritualityRegen=2.0},
    Apprentice = {Health=100, Spirituality=130, Sanity=100, Strength=10, Agility=14, Perception=40, Intuition=16, Resistance=11, SpiritualityRegen=2.2},
}
-- Absolute multipliers relative to Sequence 9; never compound on a player's stats.
local tiers = {[9]=1, [8]=1.25, [7]=1.85, [6]=2.4, [5]=3.5, [4]=7, [3]=10, [2]=18, [1]=28}
local function multipliers(sequence: number): Stats
    local t = assert(tiers[sequence], "Sequence must be an integer from 1 through 9")
    return {
        Health=t, Spirituality=t*math.sqrt(t), Sanity=1,
        Strength=t, Agility=math.sqrt(t), Perception=math.sqrt(t),
        Intuition=t, Resistance=t, SpiritualityRegen=t,
    }
end
local function scale(base: Stats, sequence: number): Stats
    local m: any = multipliers(sequence)
    local result: any = {}
    for key, value in pairs(base :: any) do
        result[key] = math.round(value * m[key] * 100) / 100
    end
    return result :: Stats
end
local function calculate(pathwayId: string, sequence: number): Stats
    return scale(assert(bases[pathwayId], "Unknown pathway"), sequence)
end
return freeze({BaseStats=bases, TierMultipliers=tiers, GetMultipliers=multipliers, Calculate=calculate, Scale=scale,
    Digestion={Min=0, Max=100, StartingValue=0}, Sanity={Min=0, Max=100}})
```


## src/ReplicatedStorage/Shared/StatusEffectData.lua

**ModuleScript** at `ReplicatedStorage/Shared/StatusEffectData`. Create matching Folder parents.

```lua
--!strict
local freeze=require(script.Parent.Freeze)
return freeze({Madness={Id="Madness", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksCasting=true, BlocksAdvancement=true}, LostControl={Id="LostControl", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksCasting=true, BlocksAdvancement=true}, Invulnerable={Id="Invulnerable", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, PreventsDamage=true}, Substitute={Id="Substitute", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, PreventsOneLethalHit=true}, Disguised={Id="Disguised", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, AggroMultiplier=0.2}, Concealed={Id="Concealed", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, AggroMultiplier=0}, Vision={Id="Vision", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Reveal=true}, CipherSight={Id="CipherSight", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Decode=true}, Composed={Id="Composed", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MentalDamageMultiplier=0.5}, Shielded={Id="Shielded", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageMultiplier=0.35}, Threaded={Id="Threaded", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MoveMultiplier=0.4}, Controlled={Id="Controlled", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Ally=true}, Confused={Id="Confused", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true}, Silenced={Id="Silenced", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAbilities=true}, Sleep={Id="Sleep", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true, MoveMultiplier=0}, Parasite={Id="Parasite", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageOverTime=true}, Deceived={Id="Deceived", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true}, Payload={Id="Payload", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, TriggeredOnAttack=true}, TimeSlow={Id="TimeSlow", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MoveMultiplier=0.25}, Stasis={Id="Stasis", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true, MoveMultiplier=0}, Burning={Id="Burning", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageOverTime=true}, Grafted={Id="Grafted", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, ReflectsDamage=true}})
```


## src/ReplicatedStorage/Shared/Theme.lua

**ModuleScript** at `ReplicatedStorage/Shared/Theme`. Create matching Folder parents.

```lua
--!strict
-- Phase 1's single source of visual constants. Asset ID 0 deliberately disables sound.
local freeze=require(script.Parent.Freeze)
local function rgb(hex: string): Color3
    return Color3.fromRGB(tonumber(string.sub(hex,1,2),16) or 0,tonumber(string.sub(hex,3,4),16) or 0,tonumber(string.sub(hex,5,6),16) or 0)
end
return freeze({
    Colors={Ink=rgb("11151D"),Slate=rgb("252C36"),Gold=rgb("C6A56B"),Text=rgb("E9DFC6"),Muted=rgb("B8B4AC"),
        Danger=rgb("E17986"),Health=rgb("B94A61"),Spirituality=rgb("71B9DA"),Sanity=rgb("AD96DD"),
        Fog=rgb("A8ADB7"),DeepPurple=rgb("41334F"),Black=rgb("0C0E12"),Crimson=rgb("9F3148"),Bronze=rgb("B88A5A"),
        Teal=rgb("4AB7BA"),Silver=rgb("C6D0D9"),Starlight=rgb("EEF7FF"),White=rgb("FFFFFF"),
        Hit=rgb("E17986"),Warm=rgb("FFD39A"),ClearTint=rgb("FFFFFF"),MadnessTint=rgb("F0B4C3"),LostTint=rgb("AA82B4")},
    Layers={HUD=10,Prompt=20,Feedback=30,Modal=50,Developer=60},
    Interaction={ServerDistance=12},
    Fonts={Title=Enum.Font.Antique,Heading=Enum.Font.Merriweather,Body=Enum.Font.Gotham,Number=Enum.Font.GothamMedium},
    Type={Title=32,Heading=22,Body=16,Number=14,Small=13,Micro=12,Damage=18},
    Style={Corner=6,ModalCorner=10,Stroke=1,IconStroke=2,PanelGradient=90,PanelFade=0,
        DisabledAlpha=0.60,SealAlpha=0.52,TrackAlpha=0.05,BorderAlpha=0.46,ModalDim=0.25,
        SelectedBorderAlpha=0,FillCorner=3,GradientEnd=0.35,HoverBlend=0.18,ButtonPad=10,
        GoldHairlineAlpha=0.65,FocusAlpha=0.12,CloseSymbol="×",DisclosureOpen="−",DisclosureClosed="+"},
    Timing={Fill=0.18,Hover=0.10,Press=0.08,Return=0.12,Collapse=0.18,Notice=5,NoticeFade=0.25,
        Step=0.05,DamageRise=0.55,DamageLife=0.70,FlashIn=0.08,FlashOut=0.18,
        AdvanceIn=0.25,AdvanceHold=1.6,AdvanceOut=0.45,SanityBreath=2.4,
        SoundHoverGap=0.08,SoundLife=8,PromptFade=0.12,AltarExpiry=15,AltarClientTimeout=2,PurchaseResponseTimeout=6,
        Pulse=0.5,Reveal=5,LoadingHint=8,CastPulse=0.18},
    Sound={Hover={Id=0,Volume=0.12},Click={Id=0,Volume=0.18},Confirm={Id=0,Volume=0.22},
        Reject={Id=0,Volume=0.18},JournalOpen={Id=0,Volume=0.15},Advance={Id=0,Volume=0.28},
        Hit={Id=0,Volume=0.16},Abilities={},MaxPlaying=8,AbilityVolume=0.4,MinPitch=0.5,MaxPitch=2},
    Camera={MinZoom=8,MaxZoom=32},
    Input={Keys={Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.R,Enum.KeyCode.F,Enum.KeyCode.Z,Enum.KeyCode.X},
        KeyNames={"Q","E","R","F","Z","X"},Journal=Enum.KeyCode.B,Developer=Enum.KeyCode.F8,
        RayLength=500,FallbackAim=50,ConfirmGamepad=Enum.KeyCode.ButtonA},
    Layout={DesktopWidth=1024,TabletWidth=720,CompactHeight=450,MinimumWidth=320,
        Desktop={Margin=20,Resources={280,124},ResourceTop=20,PathwayTop=156,PathwayWidth=280,PathwayHeight=142,
            PathwayCollapsed=36,Slot=64,SlotGap=8,BarPad=12,HotbarHeight=96,HotbarBottom=20,
            Wordmark={320,28},WordmarkTop=20,JournalButton={112,44},BodySize=16,HeadingSize=22,NumberSize=14,
            Modal={920,640},ModalMargin=48,PanelPad=12,ResourceRow=32,ResourceGap=4,ResourceIcon=20},
        Tablet={Margin=16,Resources={252,116},ResourceTop=16,PathwayTop=144,PathwayWidth=252,PathwayHeight=136,
            PathwayCollapsed=36,Slot=56,SlotGap=6,BarPad=10,HotbarHeight=86,HotbarBottom=24,
            Wordmark={240,26},WordmarkTop=16,JournalButton={104,44},BodySize=15,HeadingSize=20,NumberSize=14,
            Modal={720,600},ModalMargin=32,PanelPad=10,ResourceRow=30,ResourceGap=4,ResourceIcon=20},
        Phone={Margin=12,Resources={220,104},ResourceTop=44,PathwayTop=156,PathwayWidth=220,PathwayHeight=144,
            PathwayCollapsed=32,Slot=44,SlotGap=4,BarPad=6,HotbarHeight=72,HotbarBottom=168,
            Wordmark={144,24},WordmarkTop=10,JournalButton={44,44},BodySize=14,HeadingSize=18,NumberSize=13,
            Modal={720,720},ModalMargin=24,PanelPad=8,ResourceRow=28,ResourceGap=4,ResourceIcon=18},
        Landscape={Margin=12,Resources={208,72},ResourceTop=12,PathwayTop=92,PathwayWidth=208,PathwayHeight=128,
            PathwayCollapsed=28,Slot=44,SlotGap=4,BarPad=6,HotbarHeight=64,HotbarBottom=160,
            Wordmark={144,24},WordmarkTop=8,JournalButton={44,44},BodySize=14,HeadingSize=18,NumberSize=13,
            Modal={720,600},ModalMargin=24,PanelPad=8,ResourceRow=20,ResourceGap=2,ResourceIcon=16},
        Resource={Pad=12,IconX=10,TextX=40,NumberWidth=138,TextHeight=20,TrackHeight=6,TrackBottom=2},
        Pathway={Pad=12,HeadingHeight=26,SummaryHeight=22,TrackHeight=6,ObjectiveTop=66,ObjectiveHeight=64,Toggle=44,PercentWidth=62},
        Hotbar={Slots=6,Top=8,GlyphFraction=0.54,KeySize=18,KeyPhone=16,KeyPad=2,CostHeight=16,
            Segments=32,RingRadius=0.40,SegmentWidth=2,SegmentHeight=5,CountdownHeight=20,
            TooltipWidth=260,TooltipHeight=42,TooltipGap=10,DashedCount=3,DashInset=0.12,DashLength=0.16,DashThickness=1,
            SealSize=0.42,CostPad=2},
        Modal={Header=54,Tabs=44,Footer=30,Gap=8,BodyPad=12,Close=44,NavGap=6,RowHeight=72,
            AbilityRow=84,SlotHeight=44,SectionGap=12,Icon=44,Bottle=80,PreviewHeight=152,
            ConfirmHeight=44,CardWidth=440,CardHeight=388,TitleHeight=36,TabMinimum=64},
        Notice={Width=560,Height=48,CompactHeight=36,BottomGap=18},Advance={Width=560,Height=100,Top=84},
        Cast={Width=236,Height=34,CenterOffset=66,Track=3,Reticle=14},
        Actions={Width=100,Height=44,Gap=8,Bottom=32,PhoneBottom=218},
        Developer={Width=400,Height=304,Top=72,Pad=12,Row=44,Gap=8},
        Vignette={Thickness=0.12,MaxAlpha=0.22,Low=20,BreathMin=0.6,FlashAlpha=0.16},
        Damage={Rise=22,Width=90,Height=30,Max=12,OffsetStuds=3},
        Prompt={Width=188,Height=52,Icon=28,Pad=10,TextX=46,ActionHeight=22,ObjectHeight=16,
            OffsetX=26,OffsetY=-38,Edge=8,HoldHeight=3,SuppressLabelRadius=18,MaxVisible=1},
        Scale=1,AccessibilityScaleMax=1.15},
    Feedback={NormalSaturation=-0.25,MadnessSaturation=-0.65,SubtitleHeight=26,AdvanceTitleHeight=58,
        AdvanceMobileTitle=24,AdvanceTabletTitle=28,TextFadeStart=0.55,DamageStagger=14},
    LegacyFX={Max=48,StartSize=1,EndSize=7,Alpha=0.25,HighlightAlpha=0.6,Pitch=1,
        GlyphRadius=0.44,MinBarFraction=0.001},
    Glyphs={
        Heart={{{0.5,0.87},{0.10,0.40},{0.14,0.18},{0.34,0.13},{0.5,0.29},{0.66,0.13},{0.86,0.18},{0.9,0.4},{0.5,0.87}}},
        Star={{{0.5,0.08},{0.61,0.38},{0.9,0.5},{0.61,0.61},{0.5,0.92},{0.38,0.61},{0.1,0.5},{0.38,0.38},{0.5,0.08}}},
        Eye={{{0.08,0.5},{0.27,0.28},{0.5,0.2},{0.73,0.28},{0.92,0.5},{0.73,0.72},{0.5,0.8},{0.27,0.72},{0.08,0.5}},{{0.5,0.34},{0.64,0.5},{0.5,0.66},{0.36,0.5},{0.5,0.34}}},
        Door={{{0.24,0.9},{0.24,0.15},{0.76,0.15},{0.76,0.9}},{{0.39,0.87},{0.39,0.3},{0.65,0.3},{0.65,0.87}},{{0.14,0.9},{0.86,0.9}}},
        Split={{{0.43,0.12},{0.12,0.43},{0.43,0.76}},{{0.57,0.24},{0.88,0.57},{0.57,0.88}}},
        Thread={{{0.16,0.18},{0.84,0.82}},{{0.84,0.18},{0.16,0.82}},{{0.5,0.08},{0.5,0.92}},{{0.08,0.5},{0.92,0.5}}},
        Book={{{0.5,0.25},{0.15,0.15},{0.15,0.8},{0.5,0.9},{0.85,0.8},{0.85,0.15},{0.5,0.25},{0.5,0.9}}},
        Bottle={{{0.39,0.10},{0.61,0.10},{0.61,0.32},{0.79,0.5},{0.79,0.86},{0.21,0.86},{0.21,0.5},{0.39,0.32},{0.39,0.10}},{{0.23,0.6},{0.77,0.6}}},
        Seal={{{0.5,0.12},{0.88,0.5},{0.5,0.88},{0.12,0.5},{0.5,0.12}}},
    },
    OperationGlyph={Sense="Eye",SenseDoors="Door",Cipher="Split",Theft="Split",StealPower="Split",Siphon="Split",
        Parasite="Split",Infiltrate="Split",Control="Thread",Command="Thread",Graft="Thread",Exchange="Thread",
        Travel="Door",Portal="Door",OpenDoor="Door",CloseSpace="Door",Record="Book",Release="Star",Wish="Star",
        Echo="Thread",FlameJump="Star",Area="Star",Buff="Seal",Dodge="Seal",Disguise="Eye",Conceal="Door",Debuff="Split",Recall="Eye"},
})
```


## src/ReplicatedStorage/Shared/Types.lua

**ModuleScript** at `ReplicatedStorage/Shared/Types`. Create matching Folder parents.

```lua
--!strict
-- Luau has no numeric singleton types; validate integer bounds at runtime.
export type Sequence = number
export type Stats = {
    Health: number, Spirituality: number, Sanity: number,
    Strength: number, Agility: number, Perception: number,
    Intuition: number, Resistance: number, SpiritualityRegen: number,
}
export type Canon = { status: string, note: string, sources: {string} }
export type Objective = {
    Id: string, Label: string, ServerSignal: string, RequiredCount: number,
    DigestionReward: number, ActingProgressReward: number, CooldownSeconds: number,
}
export type SequenceData = {
    Number: number, Name: string, Canon: Canon, StatMultipliers: Stats,
    BaseStats: Stats, AbilityIds: {string}, PassiveTraits: {string},
    ActingObjectives: {Objective},
}
export type Pathway = {
    Id: string, Name: string, Alias: string, BaseStats: Stats,
    Sequences: {[number]: SequenceData}, AbilityDefinitions: {any},
}
export type Ability = {
    Id: string, PathwayId: string, UnlockSequence: number, Name: string,
    Description: string, Canon: Canon, CooldownSeconds: number,
    SpiritualityCost: number, CastTimeSeconds: number, Target: string,
    RangeStuds: number, RadiusStuds: number, MaxTargets: number,
    BasePower: number, Hitbox: {Shape: string, LineOfSight: boolean},
    StatusEffects: {string}, VFXHook: string, SFXHook: string,
    Implemented: boolean, Operation: any?,
}
return table.freeze({})
```


## src/ReplicatedStorage/Shared/VisualLayout.lua

**ModuleScript** at `ReplicatedStorage/Shared/VisualLayout`. Create matching Folder parents.

```lua
--!strict
-- Pure responsive geometry; measured in the ScreenGui's usable safe area.
local Layout={}
local function rectangle(x: number,y: number,w: number,h: number): any return {X=x,Y=y,W=w,H=h} end
function Layout.Intersects(a: any,b: any,pad: number?): boolean
    local p=pad or 0
    return a.W>0 and a.H>0 and b.W>0 and b.H>0 and a.X<b.X+b.W+p and b.X<a.X+a.W+p and a.Y<b.Y+b.H+p and b.Y<a.Y+a.H+p
end
function Layout.Resolve(theme: any,width: number,height: number,touch: boolean): any
    local l=theme.Layout
    local name=if touch and height<l.CompactHeight then "Landscape" elseif width<l.TabletWidth then "Phone" elseif width<l.DesktopWidth then "Tablet" else "Desktop"
    local p=l[name]
    local barW=l.Hotbar.Slots*p.Slot+(l.Hotbar.Slots-1)*p.SlotGap+p.BarPad*2
    local bx=(width-barW)/2
    local resources=rectangle(p.Margin,p.ResourceTop,p.Resources[1],p.Resources[2])
    if name=="Landscape" and bx<resources.X+resources.W+l.Modal.Gap then
        bx=math.min(width-p.Margin-barW,resources.X+resources.W+l.Modal.Gap)
    end
    local bar=rectangle(bx,height-p.HotbarBottom-p.HotbarHeight,barW,p.HotbarHeight)
    local pathway=rectangle(p.Margin,p.PathwayTop,p.PathwayWidth,p.PathwayHeight)
    local expandedFits=height>=l.CompactHeight and pathway.Y+pathway.H<=height-p.Margin and not Layout.Intersects(pathway,bar,l.Modal.Gap)
    local modalW=math.min(p.Modal[1],width-p.ModalMargin)
    local modalH=math.min(p.Modal[2],height-p.ModalMargin)
    local confirmW=math.min(l.Modal.CardWidth,width-p.ModalMargin)
    local confirmH=math.min(l.Modal.CardHeight,height-p.ModalMargin)
    local wordmark=rectangle((width-p.Wordmark[1])/2,p.WordmarkTop,p.Wordmark[1],p.Wordmark[2])
    if Layout.Intersects(resources,wordmark,l.Modal.Gap) then
        wordmark.W=math.max(1,math.min(wordmark.W,width-2*(resources.X+resources.W+l.Modal.Gap)))
        wordmark.X=(width-wordmark.W)/2
    end
    local action=rectangle(width-p.Margin-l.Actions.Width,bar.Y-l.Actions.Gap-l.Actions.Height,l.Actions.Width,l.Actions.Height)
    local noticeW=math.min(l.Notice.Width,width-p.Margin*2)
    local notice=rectangle((width-noticeW)/2,bar.Y-l.Notice.BottomGap-l.Notice.Height-(if touch then l.Actions.Height+l.Actions.Gap else 0),noticeW,l.Notice.Height)
    if name=="Landscape" then
        notice=rectangle(bar.X,math.max(0,bar.Y-l.Notice.CompactHeight-l.Modal.Gap),math.min(bar.W,action.X-l.Actions.Gap-bar.X),l.Notice.CompactHeight)
    end
    return {Name=name,Profile=p,Width=width,Height=height,Resources=resources,Hotbar=bar,Pathway=pathway,
        CanExpand=expandedFits,DefaultCollapsed=touch or name=="Phone" or not expandedFits,
        Wordmark=wordmark,
        Journal=rectangle(width-p.Margin-p.JournalButton[1],p.Margin,p.JournalButton[1],p.JournalButton[2]),
        Modal=rectangle((width-modalW)/2,(height-modalH)/2,modalW,modalH),
        Confirm=rectangle((width-confirmW)/2,(height-confirmH)/2,confirmW,confirmH),
        Notice=notice,Action=action,
        Cast=rectangle(bar.X+(bar.W-l.Cast.Width)/2,math.max(0,math.min(height/2+l.Cast.CenterOffset,bar.Y-l.Cast.Height-l.Modal.Gap)),l.Cast.Width,l.Cast.Height),
        Advance=rectangle(p.Margin,l.Advance.Top,width-p.Margin*2,l.Advance.Height)}
end
return table.freeze(Layout)
```


## src/ReplicatedStorage/Shared/VisualModel.lua

**ModuleScript** at `ReplicatedStorage/Shared/VisualModel`. Create matching Folder parents.

```lua
--!strict
-- Read-only UI calculations. These never authorize a server transaction.
local Model={}
function Model.Unlocked(data: any,state: any): {string}
    local ids={}
    if not state or not state.Ready or not state.PathwayId then return ids end
    for id,a in pairs(data.Abilities) do
        if a.PathwayId==state.PathwayId and state.Sequence<=a.UnlockSequence then table.insert(ids,id) end
    end
    table.sort(ids,function(a: string,b: string)
        local aa,bb=data.Abilities[a],data.Abilities[b]
        return if aa.UnlockSequence==bb.UnlockSequence then a<b else aa.UnlockSequence<bb.UnlockSequence
    end)
    return ids
end
function Model.NextPotion(state: any): string?
    if not state or not state.PathwayId or not state.Sequence or state.Sequence<=1 then return nil end
    return state.PathwayId.."_Potion_"..tostring(state.Sequence-1)
end
function Model.Potion(data: any,state: any,id: string?,purchase: boolean): any
    local potion=id and data.Potions.ById[id]
    if not state or not state.Ready then return {Allowed=false,Reason="Your journal is still opening"} end
    if not potion then return {Allowed=false,Reason=if state.PathwayId then "No further potion is available" else "Choose a starting potion in Inventory"} end
    local owned=state.Inventory[id] or 0
    local reason=nil
    if state.Dead or state.Mode~="Normal" or state.Casting then reason="You cannot use the altar during this condition"
    elseif purchase then
        if id~=Model.NextPotion(state) then reason="This is not your next potion"
        elseif owned>0 then reason="You already own this potion"
        elseif state.Gold<data.Runtime.NextPotionGoldCost then reason="Not enough gold" end
    elseif owned<1 then reason="You do not own this potion"
    elseif potion.TargetSequence==9 and state.PathwayId then reason="Your pathway is already chosen"
    elseif potion.TargetSequence~=9 and (state.PathwayId~=potion.PathwayId or state.Sequence~=potion.RequiredSequence) then reason="Follow your pathway one sequence at a time"
    elseif state.Digestion<potion.RequiredDigestion then reason="Digest your current potion completely first"
    elseif state.Sanity<=data.Progression.Sanity.BlockAdvancementAtOrBelow then reason="Recover your sanity before advancing" end
    return {Allowed=reason==nil,Reason=reason or (if purchase then "Purchase requires proximity to the altar" else "Your pathway choice and advancement are permanent"),
        Potion=potion,Owned=owned,Cost=if purchase then data.Runtime.NextPotionGoldCost else 0}
end
function Model.Cooldown(state: any,id: string,elapsed: number): number
    return math.max(0,((state and state.Cooldowns and state.Cooldowns[id]) or 0)-math.max(0,elapsed))
end
return table.freeze(Model)
```


## src/ServerScriptService/AdminConfig.lua

**ModuleScript** at `ServerScriptService/AdminConfig`. Create matching Folder parents.

```lua
--!strict
-- Server-only allowlist: enter Roblox numeric user IDs here. Group membership is not authorization.
return table.freeze({AdminUserIds=table.freeze({})})
```


## src/ServerScriptService/Bootstrap.server.lua

**Script** at `ServerScriptService/Bootstrap`. Create matching Folder parents.

```lua
--!strict
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local RunService=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local data=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))
local Theme=require(ReplicatedStorage.Shared.Theme)
local Access=require(script.Parent.Domain.VisualAccess)
local AdminConfig=require(script.Parent.AdminConfig)
local function isDeveloper(player: Player): boolean
    return Access.IsDeveloper(player.UserId,game.CreatorId,game.CreatorType==Enum.CreatorType.User,AdminConfig.AdminUserIds)
end
local Domain=require(script.Parent.Domain.PlayerDomain)
local Sessions=require(script.Parent.Domain.SessionStore)
local RateLimiter=require(script.Parent.Domain.RateLimiter)
local World=require(script.Parent.Services.WorldService)
local Effects=require(script.Parent.Services.EffectService)
local domain=Domain.new(data)
local states: {[Player]: any}={}
local sessions: {[Player]: any}={}
local releasing: {[Player]: boolean}={}
local bound: {[Player]: Model}={}
local connections: {[Player]: RBXScriptConnection}={}
local closing=false
local releaseCount=0
local remotes=Instance.new("Folder");remotes.Name="MysteriesRemotes";remotes.Parent=ReplicatedStorage
local function remote(name: string): RemoteEvent
    local r=Instance.new("RemoteEvent");r.Name=name;r.Parent=remotes;return r
end
local intent,stateEvent,fx=remote("Intent"),remote("State"),remote("Effect")
local limiter=RateLimiter.new(data.Runtime.IntentRate,data.Runtime.IntentBurst)
local sessionOnly=RunService:IsStudio() and data.Runtime.StudioSessionOnly
local store: any
if sessionOnly then
    warn("Mysteries: STUDIO SESSION ONLY — progress is not saved between servers")
    local memory={}
    store={UpdateAsync=function(_self: any,key: string,transform: any)
        local value=transform(Domain.Copy(memory[key]))
        if value~=nil then memory[key]=Domain.Copy(value) end
        return Domain.Copy(value)
    end}
else
    store=DataStoreService:GetDataStore(data.Progression.Persistence.DataStoreName)
end
local persistence=Sessions.new(store,domain,data.Progression.Persistence,os.time,task.wait)
local function notify(player: Player,text: string)
    if player.Parent then stateEvent:FireClient(player,{Message=string.sub(text,1,data.Runtime.MaxMessageLength)}) end
end
local world=World.new(data,domain,states,fx)
local effects=Effects.new(world,domain,notify)
world:Build()
local function applyStats(player: Player,s: any,refill: boolean)
    local hum=world:Humanoid(player)
    if not hum then return end
    hum.MaxHealth=s.Stats.Health
    if refill then hum.Health=s.Stats.Health else hum.Health=math.min(hum.Health,hum.MaxHealth) end
    hum.WalkSpeed=math.clamp(16+s.Stats.Agility*0.25,16,42)
    s.Health=hum.Health
end
local function sendState(player: Player)
    local s=states[player]
    if not s or not s.Ready then
        stateEvent:FireClient(player,{Ready=false,Loading=not releasing[player],Developer=isDeveloper(player)});return
    end
    local now=os.clock();local p=s.Profile;local cooldowns={};local statuses={}
    for id,expiry in pairs(s.Cooldowns) do if expiry>now then cooldowns[id]=expiry-now end end
    for id,st in pairs(s.Statuses) do if st.ExpiresAt>now then table.insert(statuses,id) end end
    table.sort(statuses)
    stateEvent:FireClient(player,{Ready=true,Developer=isDeveloper(player),
        DeveloperInfo=if isDeveloper(player) then {SessionOnly=sessionOnly,Mode=s.Mode,Ready=s.Ready} else nil,PathwayId=p.PathwayId,Sequence=p.Sequence,
        Digestion=p.Digestion,ActingProgress=p.ActingProgress,Health=s.Health,MaxHealth=s.Stats.Health,
        Spirituality=s.Spirituality,MaxSpirituality=s.Stats.Spirituality,Sanity=s.Sanity,Mode=s.Mode,
        Gold=p.Gold,WishCredits=p.WishCredits,Inventory=Domain.Copy(p.Inventory),Loadout=Domain.Copy(p.AbilityLoadout),
        Cooldowns=cooldowns,Statuses=statuses,Dead=s.Dead,RecordedCharges=s.RecordedPower and s.RecordedPower.Charges or 0,
        Casting=s.Pending and s.Pending.Id or false,CastRemaining=s.Pending and math.max(0,s.Pending.EndsAt-now) or 0})
end
local function bindCharacter(player: Player,character: Model)
    if bound[player]==character then return end
    bound[player]=character
    task.spawn(function()
        local hum=character:WaitForChild("Humanoid",15)
        local root=character:WaitForChild("HumanoidRootPart",15)
        if not hum or not hum:IsA("Humanoid") or not root or not root:IsA("BasePart") then return end
        while player.Parent and character==player.Character and states[player] and not states[player].Ready do task.wait(0.1) end
        local s=states[player]
        if not s or not s.Ready or player.Character~=character then return end
        s.Dead=false;s.Pending=nil;s.Statuses={};s.RecordedPower=nil;s.StolenPower=nil;s.DisguiseUntil=nil;s.OriginalDisplayName=nil
        s.Health=s.Stats.Health;s.Spirituality=s.Stats.Spirituality
        s.LastPosition=root.Position;s.LastPositionAt=os.clock();s.TeleportGraceUntil=os.clock()+3
        applyStats(player,s,true)
        hum.HealthChanged:Connect(function(health)
            local current=states[player]
            if current and player.Character==character then current.Health=health end
        end)
        hum.Died:Connect(function()
            local current=states[player]
            if current and player.Character==character then
                current.Dead=true;domain:CancelCast(current,false);current.Statuses={}
                effects:RemoveGates(player);world:Cleanup(player)
            end
        end)
    end)
end
world.OnInteraction=function(player: Player,action: string)
    local s=states[player]
    if not s or not s.Ready or s.Dead or s.Pending or not limiter:Allow(player,os.clock()) then return end
    local now=os.clock()
    local ok,message=false,"No response"
    if action=="Buy" and s.Mode=="Normal" then
        local altar=world.Folder:FindFirstChild("Potion Altar")
        local root=world:Root(player)
        if not altar or not altar:IsA("BasePart") or not root or (root.Position-altar.Position).Magnitude>Theme.Interaction.ServerDistance then return end
        s.AltarTicket={Position=altar.Position,ExpiresAt=now+Theme.Timing.AltarExpiry,PathwayId=s.Profile.PathwayId,Sequence=s.Profile.Sequence}
        stateEvent:FireClient(player,{Menu="Altar",ExpiresIn=Theme.Timing.AltarExpiry})
        return
    elseif action=="Recover" then
        ok,message=domain:Recover(s);s.FailureApplied=false
    elseif action=="Cipher" then
        if s.Mode=="Normal" and s.Statuses.CipherSight and s.Statuses.CipherSight.ExpiresAt>now then
            ok=domain:Act(s,"CipherSolved","archive:"..tostring(now),now)
            message=if ok then "Cipher interpreted" else "Acting objective is not ready"
        else message="Use Cryptologist's Decipher ability first" end
    elseif action=="Archive" and s.Mode=="Normal" then
        s.ArchiveRead=true
        if s.Statuses.Disguised then ok=domain:Act(s,"DisguisedInfiltrationCompleted","infiltration:"..tostring(now),now) end
        if s.Statuses.Concealed then ok=domain:Act(s,"SecretProtected","secret:"..tostring(now),now) or ok end
        message=if ok then "Archive objective complete" else "Historical record read; a Scholar can invoke its echo"
    elseif string.sub(action,1,7)=="Studio:" and isDeveloper(player) and sessionOnly and RunService:IsStudio() then
        local path=string.sub(action,8)
        if data.Pathways[path] then
            local p=domain:Default();p.PathwayId=path;p.Sequence=1;p.Digestion=100;p.Gold=1000;p.WishCredits=100
            for id in pairs(data.Potions.ById) do p.Inventory[id]=1 end
            local replacement=domain:NewState(p,now);domain:AutoEquip(replacement)
            states[player]=replacement;replacement.TeleportGraceUntil=now+3;replacement.FailureApplied=false
            effects:RemoveGates(player);world:Cleanup(player);applyStats(player,replacement,true)
            ok=true;message="Attuned to "..path.." · Sequence 1"
        end
    end
    notify(player,message);sendState(player)
end
local function loadPlayer(player: Player)
    if states[player] then return end
    states[player]={Ready=false,Loading=true}
    connections[player]=player.CharacterAdded:Connect(function(c) bindCharacter(player,c) end)
    if player.Character then bindCharacter(player,player.Character) end
    task.spawn(function()
        local owner=game.JobId..":"..HttpService:GenerateGUID(false)
        local handle,err=persistence:Acquire(player.UserId,owner)
        if not handle then
            if player.Parent then notify(player,err or "Load failed");player:Kick("Save could not be safely loaded. "..(err or "Please rejoin.")) end
            return
        end
        if not player.Parent or closing then persistence:Save(handle,handle.Data,true);return end
        sessions[player]=handle
        local s=domain:NewState(handle.Data,os.clock())
        if next(s.Profile.AbilityLoadout)==nil then domain:AutoEquip(s) end
        s.NextSave=os.clock()+data.Progression.Persistence.LockRefreshSeconds
        states[player]=s
        if player.Character and bound[player]~=player.Character then bindCharacter(player,player.Character) end
        sendState(player)
    end)
end
local function releasePlayer(player: Player)
    if releasing[player] then return end
    releasing[player]=true;releaseCount+=1
    local s=states[player];local handle=sessions[player]
    if s then s.Ready=false;s.Pending=nil end
    effects:RemoveGates(player);world:Cleanup(player)
    if handle and s then
        local deadline=os.clock()+18
        while handle.Busy and os.clock()<deadline do task.wait(0.05) end
        local ok,err=persistence:Save(handle,domain:Snapshot(s),true)
        if not ok then warn("Mysteries final save failed for "..player.UserId..": "..tostring(err)) end
    end
    if connections[player] then connections[player]:Disconnect();connections[player]=nil end
    limiter:Remove(player);states[player]=nil;sessions[player]=nil;bound[player]=nil
    releaseCount-=1;releasing[player]=nil
end
Players.PlayerAdded:Connect(loadPlayer)
Players.PlayerRemoving:Connect(releasePlayer)
for _,player in ipairs(Players:GetPlayers()) do loadPlayer(player) end
intent.OnServerEvent:Connect(function(player: Player,action: any,payload: any)
    if closing or type(action)~="string" or #action>12 or not limiter:Allow(player,os.clock()) then return end
    if action=="Sync" then sendState(player);return end
    local s=states[player]
    if not s or not s.Ready or s.Dead or type(payload)~="table" then return end
    local now=os.clock()
    if action=="Buy" then
        local root=world:Root(player)
        local ticket=s.AltarTicket
        s.AltarTicket=nil
        local valid=root and ticket and Access.AltarValid(ticket,now,(root.Position-ticket.Position).Magnitude,s.Profile.PathwayId,s.Profile.Sequence,Theme.Interaction.ServerDistance)
        local ok,message=false,"Return to the Potion Altar to confirm a purchase"
        if valid and s.Mode=="Normal" and not s.Pending then ok,message=domain:BuyNextPotion(s) end
        stateEvent:FireClient(player,{Purchase={Ok=ok,Message=message}})
        notify(player,message)
    elseif action=="CloseAltar" then
        s.AltarTicket=nil
    elseif action=="DevMastery" then
        if isDeveloper(player) and sessionOnly and RunService:IsStudio() and type(payload.PathwayId)=="string" and data.Pathways[payload.PathwayId] then
            local interact=world.OnInteraction
            if interact then interact(player,"Studio:"..payload.PathwayId) end
        end
    elseif action=="Drink" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local ok,message=domain:Drink(s,payload.Id,now)
        if ok then applyStats(player,s,true);world:Cleanup(player);effects:RemoveGates(player) end
        notify(player,message)
    elseif action=="Equip" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local _,message=domain:Equip(s,payload.Slot,payload.Id);notify(player,message)
    elseif action=="Cast" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local a=data.Abilities[payload.Id]
        if not a then return end
        local input={Position=payload.Position,Target=payload.Target}
        local context,err=effects:Validate(player,s,a,input)
        if not context then notify(player,err or "Invalid target");return end
        local pending,reason=domain:BeginCast(s,payload.Id,now)
        if not pending then notify(player,reason or "Cannot cast");return end
        pending.Input=input
    elseif action=="Melee" then
        local root=world:Root(player)
        if not root or not world:FiniteVector(root.Position) or s.Mode~="Normal" or s.Pending or now-s.LastMelee<data.Runtime.MeleeCooldown then return end
        s.LastMelee=now;s.LastCombat=now
        local direction=root.CFrame.LookVector
        if world:FiniteVector(payload.Position) and (payload.Position-root.Position).Magnitude>0.1 then direction=(payload.Position-root.Position).Unit end
        for _,e in ipairs(world:Targets(root.Position,data.Runtime.MeleeRange,8,player)) do
            local delta=e.Root.Position-root.Position
            if delta.Magnitude<0.1 or delta.Unit:Dot(direction)>0.25 then
                if world:LineOfSight(root.Position,e.Root.Position,player.Character,e.Model) then
                    world:Damage(e,s.Stats.Strength*data.Runtime.MeleePowerMultiplier,player,now);break
                end
            end
        end
        world:Effect(root.Position+direction*3,"Melee",player)
    end
    sendState(player)
end)
task.spawn(function()
    local previous=os.clock();local nextState=0
    while not closing do
        task.wait(data.Runtime.TickSeconds)
        local now=os.clock();local dt=now-previous;previous=now
        for player,s in pairs(states) do
            if not s.Ready then continue end
            domain:Tick(s,dt,now)
            local root=world:Root(player);local hum=world:Humanoid(player)
            if root and hum and hum.Health>0 then
                -- Horizontal movement guard; server-authorized travel has an explicit grace window.
                if s.LastPosition and now>(s.TeleportGraceUntil or 0) then
                    local horizontal=Vector3.new(root.Position.X-s.LastPosition.X,0,root.Position.Z-s.LastPosition.Z).Magnitude
                    if horizontal>hum.WalkSpeed*math.min(dt,2)*2+8 then
                        root.CFrame=CFrame.new(s.LastPosition);domain:CancelCast(s,false)
                    end
                end
                s.LastPosition=root.Position
                s.Health=hum.Health
            end
            if s.Mode=="LostControl" and not s.FailureApplied then
                s.FailureApplied=true
                if hum then hum.Health=0 end
                notify(player,"Loss of control. Return to Stabilization after respawning.")
            end
            local pending=s.Pending
            if pending and now>=pending.EndsAt then
                local a=data.Abilities[pending.Id]
                local context,err=effects:Validate(player,s,a,pending.Input)
                if not context then domain:CancelCast(s,true);notify(player,err or "Cast interrupted")
                else
                    local success,ok,message=pcall(function() return effects:Execute(context,now) end)
                    if not success then
                        domain:CancelCast(s,true);warn("Mysteries executor error: "..tostring(ok));notify(player,"Cast interrupted")
                    else domain:CancelCast(s,not ok);notify(player,message) end
                end
            end
            local handle=sessions[player]
            if handle and not handle.Busy and now>=(s.NextSave or math.huge) then
                s.NextSave=now+data.Progression.Persistence.LockRefreshSeconds
                local snapshot=domain:Snapshot(s)
                task.spawn(function()
                    local ok,err=persistence:Save(handle,snapshot,false)
                    if not ok and player.Parent and not releasing[player] then
                        warn("Mysteries save/lease failure for "..player.UserId..": "..tostring(err))
                        if handle.Closed or os.time()+15>=handle.ExpiresAt then
                            s.Ready=false;player:Kick("Save session ownership could not be maintained. Please rejoin.")
                        else s.NextSave=os.clock()+5;notify(player,"Saving delayed; retrying safely") end
                    end
                end)
            end
        end
        world:Step(math.min(dt,1),now);effects:Step(now)
        if now>=nextState then
            nextState=now+data.Runtime.StateIntervalSeconds
            for player in pairs(states) do if player.Parent then sendState(player) end end
        end
    end
end)
game:BindToClose(function()
    closing=true
    local waiting=0
    for player in pairs(states) do
        waiting+=1
        task.spawn(function() releasePlayer(player);waiting-=1 end)
    end
    local deadline=os.clock()+25
    while (waiting>0 or releaseCount>0) and os.clock()<deadline do task.wait(0.05) end
end)
```


## src/ServerScriptService/Domain/PlayerDomain.lua

**ModuleScript** at `ServerScriptService/Domain/PlayerDomain`. Create matching Folder parents.

```lua
--!strict
-- Pure server-owned rules; no Roblox services, yielding, remotes or client decisions.
local Domain = {}
Domain.__index = Domain
type Fields = {Data: any, Random: () -> number}
type Domain = typeof(setmetatable({} :: Fields, Domain))

local function finite(n: any): boolean
    return type(n)=="number" and n==n and math.abs(n)<math.huge
end
local function copy(value: any): any
    if type(value)~="table" then return value end
    local out={}
    for k,v in pairs(value) do out[k]=copy(v) end
    return out
end
local function bounded(n: any, lo: number, hi: number): boolean
    return finite(n) and n>=lo and n<=hi
end
function Domain.new(data: any, random: (() -> number)?): Domain
    return setmetatable({Data=data, Random=random or math.random} :: Fields, Domain)
end
function Domain.Default(self: Domain): any
    local p=copy(self.Data.Progression.DefaultPlayer)
    p.Sanity=100; p.Gold=0; p.WishCredits=0
    for id,potion in pairs(self.Data.Potions.ById) do
        if potion.TargetSequence==9 then p.Inventory[id]=1 end
    end
    return p
end
function Domain.Stats(self: Domain, profile: any): any
    if profile.PathwayId then
        return copy(self.Data.Pathways[profile.PathwayId].Sequences[profile.Sequence].BaseStats)
    end
    return {Health=100,Spirituality=50,Sanity=100,Strength=8,Agility=10,Perception=20,Intuition=8,Resistance=8,SpiritualityRegen=2}
end
function Domain.Unlocked(self: Domain, p: any, id: any): boolean
    local a=self.Data.Abilities[id]
    return a~=nil and p.PathwayId==a.PathwayId and type(p.Sequence)=="number" and p.Sequence<=a.UnlockSequence
end
function Domain.Validate(self: Domain, raw: any): (any?, string?)
    if type(raw)~="table" or raw.SchemaVersion~=1 then return nil,"Unsupported profile schema" end
    local p=copy(self.Data.Progression.DefaultPlayer)
    if raw.PathwayId~=false then
        local path=self.Data.Pathways[raw.PathwayId]
        if not path or not finite(raw.Sequence) or raw.Sequence%1~=0 or not path.Sequences[raw.Sequence] then
            return nil,"Invalid pathway or sequence"
        end
        p.PathwayId=raw.PathwayId; p.Sequence=raw.Sequence
    elseif raw.Sequence~=false then return nil,"Uninitiated profile has a sequence" end
    for _,key in ipairs({"Digestion","ActingProgress","Sanity","Gold","WishCredits"}) do
        local max=if key=="ActingProgress" or key=="Gold" then 10000000 else 100
        local value=raw[key]
        if value==nil and (key=="Gold" or key=="WishCredits") then value=0 end
        if value==nil and key=="Sanity" then value=100 end
        if not bounded(value,0,max) then return nil,"Invalid "..key end
        p[key]=value
    end
    if type(raw.Inventory)~="table" then return nil,"Invalid inventory" end
    local entries=0
    for id,n in pairs(raw.Inventory) do
        entries+=1
        if entries>100 or not self.Data.Potions.ById[id] or not bounded(n,0,99) or n%1~=0 then return nil,"Invalid inventory item" end
        p.Inventory[id]=n
    end
    if type(raw.ObjectiveProgress)~="table" or type(raw.AbilityLoadout)~="table" then return nil,"Invalid progress/loadout" end
    if p.PathwayId then
        for _,o in ipairs(self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].ActingObjectives) do
            local n=raw.ObjectiveProgress[o.Id] or 0
            if not bounded(n,0,o.RequiredCount) or n%1~=0 then return nil,"Invalid objective count" end
            p.ObjectiveProgress[o.Id]=n
        end
    end
    local seen={}
    for slot=1,6 do
        local id=raw.AbilityLoadout[slot]
        if id~=nil then
            if type(id)~="string" or not self:Unlocked(p,id) or seen[id] then return nil,"Invalid ability loadout" end
            p.AbilityLoadout[slot]=id; seen[id]=true
        end
    end
    -- Never trust persisted maxima: rebalance/migration derives these from the sequence.
    p.Stats=self:Stats(p)
    return p,nil
end
function Domain.NewState(self: Domain, profile: any, now: number): any
    local p,err=self:Validate(profile)
    assert(p,err)
    return {Profile=p,Stats=self:Stats(p),Health=p.Stats.Health,Spirituality=p.Stats.Spirituality,
        Sanity=p.Sanity,Mode=if p.Sanity==0 then "Madness" else "Normal",MadnessUntil=now+10,
        Cooldowns={},GlobalUntil=0,LastCast=-100,LastCombat=-100,Pending=nil,CastSerial=0,
        ObjectiveLast={},SeenEvents={},SeenOrder={},Statuses={},Dead=false,Ready=true,
        RecordedPower=nil,StolenPower=nil,LastMelee=-100,LastRitual=-100}
end
function Domain.Snapshot(self: Domain, s: any): any
    local p=copy(s.Profile)
    p.Stats=copy(s.Stats); p.Sanity=s.Sanity
    return p
end
function Domain.AutoEquip(self: Domain, s: any)
    local ids={}
    for id,a in pairs(self.Data.Abilities) do
        if self:Unlocked(s.Profile,id) then table.insert(ids,id) end
    end
    table.sort(ids,function(a,b)
        local aa,bb=self.Data.Abilities[a],self.Data.Abilities[b]
        return if aa.UnlockSequence==bb.UnlockSequence then a<b else aa.UnlockSequence<bb.UnlockSequence
    end)
    s.Profile.AbilityLoadout={}
    for i=1,math.min(6,#ids) do s.Profile.AbilityLoadout[i]=ids[i] end
end
function Domain.Equip(self: Domain, s: any, slot: any, id: any): (boolean,string)
    if not finite(slot) or slot%1~=0 or slot<1 or slot>6 or type(id)~="string" or not self:Unlocked(s.Profile,id) then return false,"Invalid ability slot" end
    if s.Pending then return false,"Finish casting first" end
    for i,other in pairs(s.Profile.AbilityLoadout) do
        if other==id then s.Profile.AbilityLoadout[i]=nil end
    end
    s.Profile.AbilityLoadout[slot]=id
    return true,"Ability equipped"
end
function Domain.DrainSanity(self: Domain, s: any, amount: number, now: number)
    if amount<=0 or s.Mode=="LostControl" then return end
    local guard=s.Statuses.Composed
    local mitigation=if guard and guard.ExpiresAt>now then 0.5 else 1
    local resistance=100/(100+s.Stats.Resistance)
    s.Sanity=math.max(0,s.Sanity-amount*resistance*mitigation)
    if s.Sanity==0 and s.Mode=="Normal" then
        s.Mode="Madness"; s.MadnessUntil=now+self.Data.Progression.Sanity.MadnessDurationSeconds
        self:CancelCast(s,false)
    end
end
function Domain.Drink(self: Domain, s: any, id: any, now: number): (boolean,string)
    local potion=self.Data.Potions.ById[id]
    if not potion or not s.Ready or s.Dead or s.Mode~="Normal" or s.Pending then return false,"Cannot drink now" end
    if now-s.LastRitual<2 then return false,"Wait before another ritual" end
    local p=s.Profile
    if (p.Inventory[id] or 0)<1 then return false,"You do not own that potion" end
    if potion.TargetSequence==9 then
        if p.PathwayId~=false then return false,"Your pathway is already chosen" end
    elseif p.PathwayId~=potion.PathwayId or p.Sequence~=potion.RequiredSequence then
        return false,"Potions must follow your pathway, one sequence at a time"
    end
    s.LastRitual=now
    if p.Digestion<potion.RequiredDigestion or s.Sanity<=self.Data.Progression.Sanity.BlockAdvancementAtOrBelow then
        local risk=self.Data.Potions.Rules.Risk
        local chance=math.clamp(risk.BaseChance+risk.MissingDigestionWeight*(1-p.Digestion/100)+risk.MissingSanityWeight*(1-s.Sanity/100),risk.MinChance,risk.MaxChance)
        self:DrainSanity(s,if self.Random()<chance then self.Data.Progression.Sanity.UnsafeRitualDrain else self.Data.Progression.Sanity.FailedRitualDrain,now)
        return false,"Unsafe ritual rejected; your sanity suffered"
    end
    p.Inventory[id]-=1; p.PathwayId=potion.PathwayId; p.Sequence=potion.TargetSequence
    p.Digestion=0; p.ActingProgress=0; p.ObjectiveProgress={}
    s.Stats=self:Stats(p); p.Stats=copy(s.Stats)
    s.Health=s.Stats.Health; s.Spirituality=s.Stats.Spirituality
    s.ObjectiveLast={}; s.SeenEvents={}; s.SeenOrder={}; s.Statuses={}
    self:AutoEquip(s)
    return true,"Advanced to "..self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].Name
end
function Domain.Act(self: Domain, s: any, signal: string, eventId: string, now: number): boolean
    local p=s.Profile
    if not s.Ready or s.Dead or s.Mode~="Normal" or not p.PathwayId or s.SeenEvents[eventId] then return false end
    local objectives=self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].ActingObjectives
    for _,o in ipairs(objectives) do
        if o.ServerSignal==signal and now-(s.ObjectiveLast[o.Id] or -1000)>=o.CooldownSeconds then
            s.SeenEvents[eventId]=true; table.insert(s.SeenOrder,eventId)
            if #s.SeenOrder>256 then s.SeenEvents[table.remove(s.SeenOrder,1)]=nil end
            local n=(p.ObjectiveProgress[o.Id] or 0)+1
            p.ObjectiveProgress[o.Id]=n
            if n>=o.RequiredCount then
                p.ObjectiveProgress[o.Id]=0; s.ObjectiveLast[o.Id]=now
                p.Digestion=math.min(100,p.Digestion+o.DigestionReward)
                p.ActingProgress=math.min(10000000,p.ActingProgress+o.ActingProgressReward)
                p.WishCredits=math.min(100,p.WishCredits+1)
            end
            return true
        end
    end
    return false
end
function Domain.BeginCast(self: Domain, s: any, id: any, now: number): (any?,string?)
    local a=self.Data.Abilities[id]
    if not a or not a.Implemented or not self:Unlocked(s.Profile,id) then return nil,"Ability is unavailable" end
    local equipped=false
    for _,v in pairs(s.Profile.AbilityLoadout) do if v==id then equipped=true end end
    if not equipped then return nil,"Equip this ability first" end
    if not s.Ready or s.Dead or s.Mode~="Normal" or s.Pending then return nil,"Cannot cast now" end
    if now<s.GlobalUntil or now<(s.Cooldowns[id] or 0) then return nil,"Ability is cooling down" end
    if s.Spirituality<a.SpiritualityCost then return nil,"Not enough spirituality" end
    s.Spirituality-=a.SpiritualityCost; s.LastCast=now; s.CastSerial+=1
    local pending={Id=id,Token=s.CastSerial,EndsAt=now+a.CastTimeSeconds,Cost=a.SpiritualityCost}
    s.Pending=pending; s.GlobalUntil=now+self.Data.Progression.Abilities.GlobalCooldownSeconds
    s.Cooldowns[id]=now+a.CooldownSeconds
    return pending,nil
end
function Domain.CancelCast(self: Domain, s: any, refund: boolean)
    if s.Pending and refund then s.Spirituality=math.min(s.Stats.Spirituality,s.Spirituality+s.Pending.Cost) end
    s.Pending=nil
end
function Domain.Tick(self: Domain, s: any, dt: number, now: number)
    if not s.Ready then return end
    dt=math.clamp(dt,0,2)
    for key,status in pairs(s.Statuses) do if status.ExpiresAt<=now then s.Statuses[key]=nil end end
    if s.Mode=="Madness" and now>=s.MadnessUntil then s.Mode="LostControl"; s.Health=0 end
    if not s.Dead and s.Mode=="Normal" then
        if now-s.LastCast>=2 then
            local combat=if now-s.LastCombat<5 then self.Data.Progression.Spirituality.CombatRegenMultiplier else 1
            s.Spirituality=math.min(s.Stats.Spirituality,s.Spirituality+s.Stats.SpiritualityRegen*dt*combat)
        end
        s.Sanity=math.min(100,s.Sanity+self.Data.Progression.Sanity.RecoveryPerSecond*dt)
    end
end
function Domain.Recover(self: Domain, s: any): (boolean,string)
    if s.Mode=="Normal" and s.Sanity>=100 then return false,"You are already well" end
    s.Mode="Normal"; s.Sanity=100; s.Statuses={}; s.Pending=nil
    s.Profile.Digestion=math.max(0,s.Profile.Digestion-self.Data.Progression.Sanity.RecoveryDigestionPenalty)
    return true,"Stabilized; 20 digestion sacrificed"
end
function Domain.BuyNextPotion(self: Domain, s: any): (boolean,string)
    local p=s.Profile
    if not p.PathwayId or p.Sequence<=1 then return false,"No next potion" end
    local id=p.PathwayId.."_Potion_"..tostring(p.Sequence-1)
    if (p.Inventory[id] or 0)>0 then return false,"You already have your next potion" end
    if p.Gold<self.Data.Runtime.NextPotionGoldCost then return false,"Requires 100 gold from enemies" end
    p.Gold-=self.Data.Runtime.NextPotionGoldCost; p.Inventory[id]=1
    return true,"Next potion acquired"
end
Domain.Copy=copy
Domain.Finite=finite
return Domain
```


## src/ServerScriptService/Domain/RateLimiter.lua

**ModuleScript** at `ServerScriptService/Domain/RateLimiter`. Create matching Folder parents.

```lua
--!strict
local RateLimiter={}
RateLimiter.__index=RateLimiter
function RateLimiter.new(rate: number, burst: number)
    return setmetatable({Rate=rate,Burst=burst,Buckets={}},RateLimiter)
end
function RateLimiter:Allow(key: any, now: number, cost: number?): boolean
    local amount=cost or 1
    local b=self.Buckets[key] or {Tokens=self.Burst,Time=now}
    b.Tokens=math.min(self.Burst,b.Tokens+math.max(0,now-b.Time)*self.Rate); b.Time=now
    self.Buckets[key]=b
    if b.Tokens<amount then return false end
    b.Tokens-=amount
    return true
end
function RateLimiter:Remove(key: any) self.Buckets[key]=nil end
return RateLimiter
```


## src/ServerScriptService/Domain/SessionStore.lua

**ModuleScript** at `ServerScriptService/Domain/SessionStore`. Create matching Folder parents.

```lua
--!strict
-- DataStore adapter is injected; UpdateAsync callbacks are pure and never yield.
local SessionStore={}
SessionStore.__index=SessionStore
type Fields = {Store: any, Domain: any, Config: any, Clock: () -> number, Sleep: (number) -> (), Random: () -> number}
type SessionStore = typeof(setmetatable({} :: Fields, SessionStore))

function SessionStore.new(store: any, domain: any, config: any, clock: () -> number, sleep: (number)->(), random: (() -> number)?): SessionStore
    return setmetatable({Store=store,Domain=domain,Config=config,Clock=clock,Sleep=sleep,Random=random or math.random} :: Fields, SessionStore)
end
function SessionStore.Update(self: SessionStore, key: string, transform: (any)->any): (boolean,any)
    local last=nil
    for attempt=1,self.Config.RetryCount do
        local ok,result=pcall(function() return self.Store:UpdateAsync(key,transform) end)
        if ok then return true,result end
        last=result
        if attempt<self.Config.RetryCount then
            local backoff=math.min(self.Config.BackoffMaxSeconds,self.Config.BackoffBaseSeconds*2^(attempt-1))
            self.Sleep(backoff*(1+self.Random()*self.Config.BackoffJitterFraction))
        end
    end
    return false,tostring(last)
end
function SessionStore.Acquire(self: SessionStore, userId: number, owner: string): (any?,string?)
    local key=self.Config.KeyPrefix..tostring(userId)
    local reason="Session is locked on another server"
    local ok,result=self:Update(key,function(old)
        local now=self.Clock()
        if old~=nil then
            if type(old)~="table" or old.Version~=1 or not self.Domain.Finite(old.ExpiresAt) or old.ExpiresAt<0 or (old.Owner~=nil and type(old.Owner)~="string") then
                reason="Unsupported or corrupt save envelope"; return nil
            end
            if old.Owner~=nil and old.Owner~=owner and old.ExpiresAt>now then return nil end
        end
        local data,err=self.Domain:Validate(if old==nil then self.Domain:Default() else old.Data)
        if not data then reason=err or "Invalid save"; return nil end
        return {Version=1,Owner=owner,ExpiresAt=now+self.Config.LockLeaseSeconds,Data=data}
    end)
    if not ok then return nil,"DataStore unavailable: "..tostring(result) end
    if not result or result.Owner~=owner then return nil,reason end
    return {Key=key,Owner=owner,Data=result.Data,ExpiresAt=result.ExpiresAt,Busy=false,Closed=false},nil
end
function SessionStore.Save(self: SessionStore, handle: any, profile: any, release: boolean): (boolean,string?)
    if handle.Closed then return false,"Session is closed" end
    if handle.Busy then return false,"Session is busy" end
    -- A stale server must never revive its own expired lease or save without ownership.
    if handle.ExpiresAt<=self.Clock() then handle.Closed=true; return false,"Session lease expired" end
    local clean,err=self.Domain:Validate(profile)
    if not clean then return false,err end
    handle.Busy=true
    handle.SaveSerial=(handle.SaveSerial or 0)+1
    local operation=handle.Owner.."#"..tostring(handle.SaveSerial)
    local ok,result=self:Update(handle.Key,function(old)
        local now=self.Clock()
        if type(old)~="table" or old.Version~=1 then return nil end
        -- A release may have committed before its HTTP response was lost.
        if release and old.Owner==nil and old.LastOperation==operation then return old end
        if old.Owner~=handle.Owner or not self.Domain.Finite(old.ExpiresAt) or old.ExpiresAt<=now then return nil end
        return {Version=1,Owner=if release then nil else handle.Owner,
            ExpiresAt=if release then 0 else now+self.Config.LockLeaseSeconds,Data=clean,LastOperation=operation}
    end)
    handle.Busy=false
    if not ok then return false,"Save unavailable: "..tostring(result) end
    if not result then handle.Closed=true; return false,"Session ownership lost" end
    handle.Data=clean; handle.ExpiresAt=result.ExpiresAt
    if release then handle.Closed=true end
    return true,nil
end
return SessionStore
```


## src/ServerScriptService/Domain/VisualAccess.lua

**ModuleScript** at `ServerScriptService/Domain/VisualAccess`. Create matching Folder parents.

```lua
--!strict
-- Pure authorization and altar-ticket rules. No client-supplied developer flag is trusted.
local Access={}
function Access.IsDeveloper(userId: number,creatorId: number,individualCreator: boolean,admins: {number}): boolean
    if userId>0 and individualCreator and userId==creatorId then return true end
    for _,id in ipairs(admins) do if id>0 and id==userId then return true end end
    return false
end
function Access.AltarValid(ticket: any,now: number,distance: number,pathway: any,sequence: any,radius: number): boolean
    return type(ticket)=="table" and type(ticket.ExpiresAt)=="number" and now<=ticket.ExpiresAt and distance==distance and distance>=0 and distance<=radius
        and ticket.PathwayId==pathway and ticket.Sequence==sequence
end
return table.freeze(Access)
```


## src/ServerScriptService/Services/EffectService.lua

**ModuleScript** at `ServerScriptService/Services/EffectService`. Create matching Folder parents.

```lua
--!strict
-- Data-driven ability executors. Only trusted server definitions select these handlers.
local CollectionService=game:GetService("CollectionService")
local Effects={}
Effects.__index=Effects
type Fields = {
    World: any, Domain: any, Notify: (Player, string) -> (),
    Gates: {[Player]: any}, OpenDoors: {[BasePart]: number},
}
type Effects = typeof(setmetatable({} :: Fields, Effects))

local handlers={}
function Effects.new(world: any,domain: any,notify: any): Effects
    return setmetatable({World=world,Domain=domain,Notify=notify,Gates={},OpenDoors={}} :: Fields, Effects)
end
function Effects.Validate(self: Effects, player: Player,s: any,a: any,input: any): (any?,string?)
    local world=self.World;local root=world:Root(player);local hum=world:Humanoid(player)
    if not root or not world:FiniteVector(root.Position) or not hum or hum.Health<=0 or not s.Ready or s.Dead or s.Mode~="Normal" then return nil,"Your character is unavailable" end
    local context={Player=player,State=s,Ability=a,Root=root,Position=root.Position,Entity=nil}
    if a.Target=="NPC" then
        local entity=world:Entity(input.Target)
        if not entity then return nil,"Aim at a living enemy" end
        local owned=a.Operation.Kind=="Command" or a.Operation.Kind=="Exchange"
        if owned then
            if entity.Owner~=player then return nil,"Target your own marionette" end
        elseif entity.Owner~=nil then return nil,"Target a hostile enemy" end
        context.Entity=entity;context.Position=entity.Root.Position
    elseif a.Target=="Position" then
        if not world:FiniteVector(input.Position) then return nil,"Aim at a location" end
        context.Position=input.Position
    end
    if (context.Position-root.Position).Magnitude>a.RangeStuds+1 then return nil,"Target is out of range" end
    if a.Target~="Self" and a.Hitbox.LineOfSight and not world:LineOfSight(root.Position,context.Position,player.Character,context.Entity and context.Entity.Model) then return nil,"Your target is obstructed" end
    return context,nil
end
function Effects.Execute(self: Effects, context: any,now: number): (boolean,string)
    local a=context.Ability;local op=a.Operation
    local handler=op and handlers[op.Kind]
    if not handler then return false,"No executor exists for this ability" end
    local ok,message,evidence=handler(self,context,op,now)
    if ok then
        local world=self.World
        world:Effect(context.Position,a.Id,context.Player,context.Entity and context.Entity.Model)
        if op.Signal and evidence~=false then
            self.Domain:Act(context.State,op.Signal,"cast:"..tostring(context.State.CastSerial),now)
        end
    end
    return ok,message
end
local function buff(self: any,c: any,op: any,now: number)
    if op.Status then self.World:Buff(c.State,op.Status,op.Duration or 10,now) end
end
local function power(c: any,op: any): number return c.Ability.BasePower*(op.Power or 1) end
local function teleport(self: any,c: any,position: Vector3): boolean
    local safe=self.World:SafeDestination(c.Player,position)
    if not safe or not c.Player.Character then return false end
    local state=self.World.States[c.Player]
    if state then state.TeleportGraceUntil=os.clock()+1;state.LastPosition=safe end
    c.Player.Character:PivotTo(CFrame.new(safe)*c.Root.CFrame.Rotation)
    c.Root.AssemblyLinearVelocity=Vector3.zero
    return true
end
handlers.Buff=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now);return true,"Effect prepared"
end
handlers.Sense=function(self: any,c: any,op: any,now: number)
    local enemies=self.World:Targets(c.Root.Position,c.State.Stats.Perception,16,c.Player)
    if #enemies==0 and op.Signal then return false,"No spiritual trace is close enough" end
    if op.Signal then
        local accuracy=self.World.Data.Runtime.DivinationAccuracy
        local intuition=c.State.Stats.Intuition
        local chance=accuracy.Base+accuracy.Bonus*intuition/(intuition+accuracy.IntuitionScale)
        local random=self.World.Random or math.random
        if random()>chance then
            self.Domain:DrainSanity(c.State,2,now)
            return true,"The omen is obscured; no acting progress earned",false
        end
    end
    buff(self,c,op,now)
    for _,e in ipairs(enemies) do self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=e.Root.Position,Target=e.Model}) end
    if enemies[1] then
        local e=enemies[1]
        self.Notify(c.Player,"Reading: omen "..tostring(e.Model:GetAttribute("Omen")).." · target HP "..tostring(math.ceil(e.Humanoid.Health)))
    end
    return true,"Spiritual traces revealed"
end
handlers.SenseDoors=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    for _,door in ipairs(CollectionService:GetTagged("MysticDoor")) do
        if door:IsA("BasePart") and (door.Position-c.Root.Position).Magnitude<=c.State.Stats.Perception then
            self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=door.Position,Target=door})
        end
    end
    return true,"Passages revealed"
end
handlers.Dodge=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    local destination=c.Root.Position-c.Root.CFrame.LookVector*8
    teleport(self,c,destination)
    return true,"Evade an incoming strike",false
end
handlers.FlameJump=function(self: any,c: any,op: any,now: number)
    local anchor=nil;local distance=12
    for _,p in ipairs(CollectionService:GetTagged("FlameAnchor")) do
        if p:IsA("BasePart") and (p.Position-c.Position).Magnitude<distance then anchor=p;distance=(p.Position-c.Position).Magnitude end
    end
    if not anchor then return false,"Aim near an orange flame anchor" end
    local threats=self.World:Targets(c.Root.Position,20,1,c.Player)
    local origin=c.Root.Position
    if not teleport(self,c,anchor.Position+Vector3.new(3,0,0)) then return false,"The landing is obstructed" end
    local escaped=#threats>0 and (origin-c.Root.Position).Magnitude>=15
    return true,"Flame jump",escaped
end
handlers.Disguise=function(self: any,c: any,op: any,now: number)
    local profile=self.World.Data.Runtime.Disguises[op.Profile or "Wanderer"]
    if not profile then return false,"Unknown disguise profile" end
    buff(self,c,op,now)
    c.State.DisguiseUntil=now+(op.Duration or 30)
    local hum=self.World:Humanoid(c.Player)
    if hum then
        if not c.State.OriginalDisplayName then c.State.OriginalDisplayName=hum.DisplayName end
        hum.DisplayName=profile.DisplayName
        for name,value in pairs(profile.Scales) do
            local scale=hum:FindFirstChild(name)
            if scale and scale:IsA("NumberValue") then
                if scale:GetAttribute("MysteriesOriginalScale")==nil then scale:SetAttribute("MysteriesOriginalScale",scale.Value) end
                scale.Value=value
            end
        end
    end
    local character=c.Player.Character
    if character then
        local oldMask=character:FindFirstChild("MysteriesDisguise")
        if oldMask then oldMask:Destroy() end
        for _,p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                if p:GetAttribute("OriginalColor")==nil then p:SetAttribute("OriginalColor",p.Color) end
                p.Color=Color3.fromRGB(table.unpack(profile.Color))
            end
        end
        local head=character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            -- An original mask replaces the visible face; no marketplace face assets.
            local mask=Instance.new("Part");mask.Name="MysteriesDisguise";mask.Size=head.Size*1.03;mask.CFrame=head.CFrame
            mask.CanCollide=false;mask.CanTouch=false;mask.CanQuery=false;mask.Massless=true
            mask.Color=Color3.fromRGB(table.unpack(profile.Color));mask.Parent=character
            local weld=Instance.new("WeldConstraint");weld.Part0=head;weld.Part1=mask;weld.Parent=mask
        end
    end
    self.World.FX:FireClient(c.Player,{Kind="VoiceProfile",Position=c.Root.Position,Hook=c.Ability.SFXHook,Pitch=profile.VoicePitch})
    return true,"Identity changed: "..profile.DisplayName.."; infiltrate the Hidden Archive"
end
handlers.Control=function(self: any,c: any,op: any,now: number)
    local e=c.Entity
    if e.Tier<c.State.Profile.Sequence then return false,"This enemy is too powerful to control" end
    local owned=0
    for _,other in pairs(self.World.Entities) do if other.Owner==c.Player then owned+=1 end end
    if owned>=self.World.Data.Runtime.MaxOwnedSummons then return false,"Your summon limit is reached" end
    e.Threads+=1
    self.World:Status(e,"Threaded",math.max(20,c.Ability.CooldownSeconds+3),now,c.Player)
    local required=op.RequiredHits or 1
    if e.Threads<required then return true,"Threads "..tostring(e.Threads).." / "..tostring(required),false end
    e.Threads=0;e.Owner=c.Player;e.Statuses.Threaded=nil
    self.World:Status(e,"Controlled",op.Duration or 15,now,c.Player)
    return true,"Marionette secured"
end
handlers.Command=function(self: any,c: any,op: any,now: number)
    local foes=self.World:Targets(c.Entity.Root.Position,45,1,c.Player)
    if not foes[1] then return false,"No hostile target near the marionette" end
    self.World:Damage(foes[1],power(c,op),c.Player,now)
    return true,"Marionette strike"
end
handlers.Exchange=function(self: any,c: any,op: any,now: number)
    local original=c.Root.Position;local other=c.Entity.Root.Position
    local threatened=#self.World:Targets(original,25,1,c.Player)>0
    if not teleport(self,c,other+Vector3.new(4,0,0)) then return false,"Exchange destination is blocked" end
    c.Entity.Model:PivotTo(CFrame.new(original))
    self.World:Buff(c.State,"Invulnerable",2,now)
    return true,"Marionette exchange",threatened
end
handlers.Area=function(self: any,c: any,op: any,now: number)
    local radius=math.max(10,c.Ability.RadiusStuds)
    local enemies=self.World:Targets(c.Position,radius,c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No enemies in the area" end
    for _,e in ipairs(enemies) do
        if self.World:LineOfSight(c.Position,e.Root.Position,c.Player.Character,e.Model) then
            self.World:Damage(e,power(c,op),c.Player,now)
            if op.Status then self.World:Status(e,op.Status,op.Duration or 5,now,c.Player,power(c,op)*0.15) end
        end
    end
    return true,"Area effect released"
end
handlers.Echo=function(self: any,c: any,op: any,now: number)
    if not c.State.ArchiveRead then return false,"Read the Hidden Archive before invoking a past echo" end
    local count=0
    for _,e in pairs(self.World.Entities) do if e.Owner==c.Player then count+=1 end end
    if count>=self.World.Data.Runtime.MaxOwnedSummons then return false,"Your summon limit is reached" end
    local safe=self.World:SafeDestination(c.Player,c.Position)
    if not safe then return false,"Cannot summon here" end
    local e=self.World:Spawn(safe,c.State.Profile.Sequence,c.Player,now+(op.Duration or 20))
    e.IsEcho=true;c.State.ArchiveRead=false
    return true,"Past echo summoned"
end
handlers.Recall=function(self: any,c: any,op: any,now: number)
    local hum=self.World:Humanoid(c.Player)
    if not hum then return false,"Character missing" end
    local fraction=op.Power or 0.25
    if hum.Health>=hum.MaxHealth and c.State.Spirituality>=c.State.Stats.Spirituality-c.Ability.SpiritualityCost then return false,"Nothing needs recovery" end
    hum.Health=math.min(hum.MaxHealth,hum.Health+hum.MaxHealth*fraction)
    c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+c.State.Stats.Spirituality*fraction)
    return true,"A measure of past vitality recalled"
end
handlers.Wish=function(self: any,c: any,op: any,now: number)
    local hum=self.World:Humanoid(c.Player);local p=c.State.Profile
    if not hum or (hum.Health>=hum.MaxHealth and c.State.Sanity>=100) then return false,"No recovery wish can be fulfilled here" end
    if p.WishCredits<1 then return false,"Earn a wish credit by completing acting objectives" end
    p.WishCredits-=1
    hum.Health=math.min(hum.MaxHealth,hum.Health+hum.MaxHealth*(op.Power or 1))
    c.State.Sanity=math.min(100,c.State.Sanity+30)
    self.World:Buff(c.State,"Shielded",8,now)
    return true,"Recovery wish fulfilled"
end
handlers.Graft=function(self: any,c: any,op: any,now: number)
    local enemies=self.World:Targets(c.Position,math.max(15,c.Ability.RadiusStuds),c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No hostile attacks to graft" end
    for _,e in ipairs(enemies) do self.World:Status(e,"Grafted",op.Duration or 10,now,c.Player) end
    return true,"Hostile attacks grafted back to their source",false
end
handlers.Theft=function(self: any,c: any,op: any,now: number)
    if c.Entity.Stolen then return false,"This enemy has already been pickpocketed" end
    c.Entity.Stolen=true;c.State.Profile.Gold=math.min(10000000,c.State.Profile.Gold+5)
    self.World:Status(c.Entity,"Confused",2,now,c.Player)
    return true,"Stole 5 gold"
end
handlers.Debuff=function(self: any,c: any,op: any,now: number)
    if op.Power then self.World:Damage(c.Entity,power(c,op),c.Player,now) end
    if op.Status then self.World:Status(c.Entity,op.Status,op.Duration or 5,now,c.Player,power(c,op)*0.2) end
    if op.Status=="TimeSlow" then c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+c.Ability.SpiritualityCost*0.25) end
    return true,"Hostile influence applied"
end
handlers.Cipher=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    return true,"Cipher sight: use the Cipher Archive while this effect lasts"
end
handlers.StealPower=function(self: any,c: any,op: any,now: number)
    local powerId=c.Entity.Model:GetAttribute("AbilityId")
    if not self.World.Data.Runtime.CopyableNPCPowers[powerId] then return false,"This power cannot be stolen" end
    if c.State.StolenPower then
        local spec=self.World.Data.Runtime.CopyableNPCPowers[c.State.StolenPower]
        c.State.StolenPower=nil
        self.World:Damage(c.Entity,c.Ability.BasePower*spec.Power,c.Player,now)
        self.World:Status(c.Entity,spec.Status,spec.Duration,now,c.Player,c.Ability.BasePower*0.2)
        return true,"Stolen power released",false
    end
    c.State.StolenPower=powerId
    self.World:Status(c.Entity,"Silenced",op.Duration or 10,now,c.Player)
    return true,"Power stolen; cast again to release it"
end
handlers.Siphon=function(self: any,c: any,op: any,now: number)
    local host=c.Entity.Statuses.Parasite
    if op.RequiresHost and (not host or host.Owner~=c.Player or host.ExpiresAt<=now) then return false,"Target your parasitized host" end
    local before=c.Entity.Humanoid.Health
    self.World:Damage(c.Entity,power(c,op),c.Player,now)
    local removed=math.min(before,power(c,op))
    local hum=self.World:Humanoid(c.Player)
    if hum then hum.Health=math.min(hum.MaxHealth,hum.Health+removed*0.5) end
    c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+removed*0.3)
    return true,"Vitality and spirituality siphoned"
end
handlers.Parasite=function(self: any,c: any,op: any,now: number)
    if c.Entity.Tier<c.State.Profile.Sequence then return false,"This host is too powerful" end
    for _,e in pairs(self.World.Entities) do
        local st=e.Statuses.Parasite
        if st and st.Owner==c.Player and e~=c.Entity then e.Statuses.Parasite=nil end
    end
    self.World:Status(c.Entity,"Parasite",op.Duration or 12,now,c.Player,power(c,op)*0.15)
    self.World:Buff(c.State,"Shielded",op.Duration or 12,now)
    return true,"Host parasitized"
end
handlers.Infiltrate=function(self: any,c: any,op: any,now: number)
    local e=c.Entity
    if not teleport(self,c,e.Root.Position-e.Root.CFrame.LookVector*7) then return false,"No safe infiltration point" end
    self.World:Status(e,"Payload",op.Duration or 10,now,c.Player,power(c,op)*2)
    self.World:Buff(c.State,"Invulnerable",1,now)
    return true,"A hidden payload entered the target's destiny"
end
handlers.Record=function(self: any,c: any,op: any,now: number)
    local id=c.Entity.Model:GetAttribute("AbilityId")
    if not self.World.Data.Runtime.CopyableNPCPowers[id] then return false,"This power cannot be recorded" end
    if not c.Entity.LastSpell or now-c.Entity.LastSpell>15 then return false,"Observe an enemy casting its power before recording it" end
    c.State.RecordedPower={Id=id,Charges=3}
    return true,"Power recorded: 3 releases available"
end
handlers.Release=function(self: any,c: any,op: any,now: number)
    local record=c.State.RecordedPower
    if not record or record.Charges<=0 then return false,"Record a permitted enemy power first" end
    local spec=self.World.Data.Runtime.CopyableNPCPowers[record.Id]
    if not spec then return false,"The recording is invalid" end
    record.Charges-=1
    self.World:Damage(c.Entity,power(c,op)*spec.Power,c.Player,now)
    self.World:Status(c.Entity,spec.Status,spec.Duration,now,c.Player,power(c,op)*0.2)
    return true,"Recorded phenomenon released"
end
handlers.OpenDoor=function(self: any,c: any,op: any,now: number)
    local nearest=nil;local distance=10
    for _,door in ipairs(CollectionService:GetTagged("MysticDoor")) do
        if door:IsA("BasePart") and (door.Position-c.Position).Magnitude<distance then nearest=door;distance=(door.Position-c.Position).Magnitude end
    end
    if not nearest or self.OpenDoors[nearest] then return false,"Aim at a closed practice door" end
    nearest.CanCollide=false;nearest.Transparency=0.75;self.OpenDoors[nearest]=now+20
    return true,"Locked passage opened"
end
handlers.Travel=function(self: any,c: any,op: any,now: number)
    if (c.Position-c.Root.Position).Magnitude<10 then return false,"Choose a destination at least 10 studs away" end
    if not teleport(self,c,c.Position) then return false,"The destination is unsafe" end
    buff(self,c,op,now)
    return true,"Travel completed"
end
handlers.Conceal=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    c.State.SecretUntil=now+(op.Duration or 18)
    return true,"Concealed: protect the Hidden Archive",false
end
handlers.Portal=function(self: any,c: any,op: any,now: number)
    local destination=self.World:SafeDestination(c.Player,c.Position)
    local origin=self.World:SafeDestination(c.Player,c.Root.Position)
    if not destination or not origin or (destination-origin).Magnitude<10 then return false,"Choose a safe, more distant gateway destination" end
    self:RemoveGates(c.Player)
    local gate={Owner=c.Player,EndsAt=now+(op.Duration or 25),Parts={},LastUse=-100}
    for _,pair in ipairs({{origin,destination},{destination,origin}}) do
        local p=Instance.new("Part");p.Name="SpatialGate";p.Size=Vector3.new(6,8,0.6);p.CFrame=CFrame.new(pair[1]);p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(100,150,255);p.Transparency=0.4;p.Parent=self.World.Transient
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText="Enter your gate";prompt.MaxActivationDistance=8;prompt.RequiresLineOfSight=true;prompt.Parent=p
        prompt.Triggered:Connect(function(player)
            local root=self.World:Root(player);local s=self.World.States[player]
            local t=os.clock()
            if player~=c.Player or t>=gate.EndsAt or t-gate.LastUse<1 or not root or not s or not s.Ready or s.Dead or s.Mode~="Normal" or (root.Position-p.Position).Magnitude>10 then return end
            gate.LastUse=t
            local result=teleport(self,{Player=player,Root=root},pair[2]+Vector3.new(4,0,0))
            if result then self.Domain:Act(s,"TravelDestinationReached","gate:"..tostring(t),t) end
        end)
        table.insert(gate.Parts,p)
    end
    self.Gates[c.Player]=gate
    return true,"Linked spatial gates created"
end
handlers.CloseSpace=function(self: any,c: any,op: any,now: number)
    local hadGate=self.Gates[c.Player]~=nil
    self:RemoveGates(c.Player)
    local ok,message=handlers.Area(self,c,op,now)
    return hadGate or ok,if hadGate then "Spatial gates closed and area sealed" else message
end
function Effects.RemoveGates(self: Effects, player: Player)
    local gate=self.Gates[player]
    if gate then for _,p in ipairs(gate.Parts) do p:Destroy() end end
    self.Gates[player]=nil
end
function Effects.Step(self: Effects, now: number)
    for player,gate in pairs(self.Gates) do if now>=gate.EndsAt then self:RemoveGates(player) end end
    for door,expires in pairs(self.OpenDoors) do
        if not door.Parent then self.OpenDoors[door]=nil
        elseif now>=expires then
            local occupied=false
            for player in pairs(self.World.States) do
                local root=self.World:Root(player)
                if root and (root.Position-door.Position).Magnitude<6 then occupied=true;break end
            end
            if not occupied then door.CanCollide=true;door.Transparency=0;self.OpenDoors[door]=nil end
        end
    end
    for player,s in pairs(self.World.States) do
        if s.DisguiseUntil and (now>=s.DisguiseUntil or not s.Statuses.Disguised) then
            s.DisguiseUntil=nil
            local hum=self.World:Humanoid(player)
            if hum then
                hum.DisplayName=s.OriginalDisplayName or player.DisplayName
                for _,scale in ipairs(hum:GetChildren()) do
                    if scale:IsA("NumberValue") then
                        local original=scale:GetAttribute("MysteriesOriginalScale")
                        if type(original)=="number" then scale.Value=original;scale:SetAttribute("MysteriesOriginalScale",nil) end
                    end
                end
            end
            s.OriginalDisplayName=nil
            if player.Character then
                local mask=player.Character:FindFirstChild("MysteriesDisguise")
                if mask then mask:Destroy() end
                for _,p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        local color=p:GetAttribute("OriginalColor")
                        if typeof(color)=="Color3" then p.Color=color;p:SetAttribute("OriginalColor",nil) end
                    end
                end
            end
        end
    end
end
-- Exposed names allow schema coverage tests without loading Roblox services.
Effects.Handlers=handlers
return Effects
```


## src/ServerScriptService/Services/WorldService.lua

**ModuleScript** at `ServerScriptService/Services/WorldService`. Create matching Folder parents.

```lua
--!strict
local CollectionService=game:GetService("CollectionService")
local Debris=game:GetService("Debris")
local World={}
World.__index=World
type Fields = {
    Data: any, Domain: any, States: {[Player]: any}, FX: RemoteEvent,
    Folder: Folder, NPCFolder: Folder, Transient: Folder, Entities: {[Model]: any},
    Spawns: {any}, Clock: number, OnInteraction: ((Player, string) -> ())?,
}
type World = typeof(setmetatable({} :: Fields, World))

local function part(parent: Instance,name: string,size: Vector3,position: Vector3,color: Color3): Part
    local p=Instance.new("Part")
    p.Name=name; p.Size=size; p.Position=position; p.Color=color; p.Anchored=true
    p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent
    return p
end
local function label(p: BasePart,text: string)
    local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(260,70);gui.StudsOffset=Vector3.new(0,4,0);gui.AlwaysOnTop=false;gui.Parent=p
    local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextColor3=Color3.new(1,1,1);t.TextStrokeTransparency=0.3;t.TextScaled=true;t.Font=Enum.Font.GothamMedium;t.Parent=gui
end
function World.new(data: any,domain: any,states: any,effects: RemoteEvent): World
    local folder=Instance.new("Folder");folder.Name="MysteriesWorld";folder.Parent=workspace
    local npcs=Instance.new("Folder");npcs.Name="Enemies";npcs.Parent=folder
    local transient=Instance.new("Folder");transient.Name="Transient";transient.Parent=folder
    return setmetatable({Data=data,Domain=domain,States=states,FX=effects,Folder=folder,NPCFolder=npcs,Transient=transient,
        Entities={},Spawns={},Clock=0,OnInteraction=nil} :: Fields, World)
end
function World.Build(self: World)
    if not self.Data.Runtime.GenerateDemoWorld then return end
    part(self.Folder,"TrainingGround",Vector3.new(800,4,800),Vector3.new(0,-2,0),Color3.fromRGB(35,41,49))
    local spawn=Instance.new("SpawnLocation");spawn.Name="SanctuarySpawn";spawn.Size=Vector3.new(12,1,12);spawn.Position=Vector3.new(0,0.5,0);spawn.Neutral=true;spawn.Duration=0;spawn.Color=Color3.fromRGB(95,153,170);spawn.Parent=self.Folder
    label(spawn,"SANCTUARY\nChoose a potion in your journal")
    for _,v in ipairs({{Name="Potion Altar",Action="Buy",Pos=Vector3.new(-12,3,0)},
        {Name="Stabilization",Action="Recover",Pos=Vector3.new(12,3,0)},
        {Name="Cipher Archive",Action="Cipher",Pos=Vector3.new(0,3,-16)},
        {Name="Hidden Archive",Action="Archive",Pos=Vector3.new(0,3,16)}}) do
        local p=part(self.Folder,v.Name,Vector3.new(3,6,3),v.Pos,Color3.fromRGB(112,100,160))
        label(p,v.Name)
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText=if v.Action=="Buy" then "Next potion · 100 gold" else v.Name
        prompt:SetAttribute("InteractionId",v.Action)
        prompt.ObjectText=v.Name;prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.RequiresLineOfSight=true;prompt.Parent=p
        prompt.Triggered:Connect(function(player)
            local root=self:Root(player)
            if root and (root.Position-p.Position).Magnitude<=12 and self.OnInteraction then self.OnInteraction(player,v.Action) end
        end)
    end
    for i=1,4 do
        local door=part(self.Folder,"PracticeDoor",Vector3.new(7,9,1),Vector3.new(-35+i*14,4.5,-34),Color3.fromRGB(123,92,62))
        CollectionService:AddTag(door,"MysticDoor");label(door,"LOCKED PASSAGE")
    end
    for x=-168,168,28 do
        for z=-168,168,28 do
            if Vector3.new(x,0,z).Magnitude>35 then
                local p=part(self.Folder,"FlameAnchor",Vector3.new(0.7,2,0.7),Vector3.new(x,1,z),Color3.fromRGB(255,150,70))
                p.CanCollide=false;p.Material=Enum.Material.Neon;CollectionService:AddTag(p,"FlameAnchor")
            end
        end
    end
    for index,tier in ipairs(self.Data.Runtime.EnemyTiers) do
        local angle=(index-1)*math.pi/3
        local center=Vector3.new(math.cos(angle)*130,0,math.sin(angle)*130)
        local marker=part(self.Folder,"Arena"..tier,Vector3.new(8,0.3,8),center,Color3.fromRGB(75,65,100))
        label(marker,"SEQUENCE "..tier.." ENEMIES")
        if tier<=4 then
            local zone=part(self.Folder,"WhisperZone",Vector3.new(50,12,50),center+Vector3.new(0,6,0),Color3.fromRGB(90,70,120))
            zone.Transparency=1;zone.CanCollide=false;zone.CanTouch=false;zone.CanQuery=false
            zone:SetAttribute("Radius",self.Data.Runtime.ExposureRadius);CollectionService:AddTag(zone,"MysticalExposure")
        end
        for offset=1,3 do
            table.insert(self.Spawns,{Position=center+Vector3.new((offset-2)*12,4,8),Tier=tier,Entity=nil,NextSpawn=0})
        end
    end
end
function World.Root(self: World, player: Player): BasePart?
    local c=player.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    return if root and root:IsA("BasePart") then root else nil
end
function World.Humanoid(self: World, player: Player): Humanoid?
    return if player.Character then player.Character:FindFirstChildOfClass("Humanoid") else nil
end
function World.Entity(self: World, model: any): any
    if typeof(model)~="Instance" or not model:IsA("Model") then return nil end
    local e=self.Entities[model]
    if not e or not model:IsDescendantOf(self.NPCFolder) or not CollectionService:HasTag(model,"Enemy") or e.Humanoid.Health<=0 then return nil end
    return e
end
function World.Has(self: World, e: any,id: string,now: number): boolean
    local st=e.Statuses[id]
    return st~=nil and st.ExpiresAt>now
end
function World.Status(self: World, e: any,id: string,duration: number,now: number,owner: Player?,power: number?)
    assert(self.Data.StatusEffects[id],"Unknown status")
    if owner and id~="Controlled" then
        local s=self.States[owner]
        if s then
            local rating=self.Data.Runtime.NPCMentalResistancePerTier*e.Power
            duration*=math.clamp(s.Stats.Resistance/rating,self.Data.Runtime.MinStatusDurationMultiplier,1)
        end
    end
    e.Statuses[id]={ExpiresAt=now+duration,Owner=owner,Power=power or 0,NextTick=now+1}
end
function World.Buff(self: World, s: any,id: string,duration: number,now: number)
    assert(self.Data.StatusEffects[id],"Unknown buff")
    s.Statuses[id]={ExpiresAt=now+duration}
end
function World.LineOfSight(self: World, from: Vector3,to: Vector3,ignore: Instance?,target: Instance?): boolean
    local delta=to-from
    if delta.Magnitude<0.1 then return true end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    local exclusions: {Instance}={self.Transient}
    if ignore then table.insert(exclusions,ignore) end
    params.FilterDescendantsInstances=exclusions;params.IgnoreWater=true
    local hit=workspace:Raycast(from,delta,params)
    return not hit or (hit.Position-to).Magnitude<1 or (target~=nil and hit.Instance:IsDescendantOf(target))
end
function World.FiniteVector(self: World, v: any): boolean
    return typeof(v)=="Vector3" and self.Domain.Finite(v.X) and self.Domain.Finite(v.Y) and self.Domain.Finite(v.Z)
end
function World.SafeDestination(self: World, player: Player,position: Vector3): Vector3?
    if not self:FiniteVector(position) or math.abs(position.Y)>500 or Vector3.new(position.X,0,position.Z).Magnitude>self.Data.Runtime.WorldRadius then return nil end
    local ignore: {Instance}={self.NPCFolder,self.Transient}
    if player.Character then table.insert(ignore,player.Character) end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances=ignore
    local hit=workspace:Raycast(position+Vector3.new(0,30,0),Vector3.new(0,-100,0),params)
    if not hit or hit.Normal.Y<0.7 or not hit.Instance.CanCollide then return nil end
    if not hit.Instance.Anchored and not hit.Instance:IsA("Terrain") then return nil end
    local destination=Vector3.new(position.X,hit.Position.Y+3.5,position.Z)
    local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances=ignore
    for _,p in ipairs(workspace:GetPartBoundsInBox(CFrame.new(destination),Vector3.new(4,5,4),overlap)) do
        if p.CanCollide then return nil end
    end
    return destination
end
function World.Targets(self: World, position: Vector3,radius: number,maximum: number,owner: Player): {any}
    local found={}
    for _,e in pairs(self.Entities) do
        if e.Humanoid.Health>0 and e.Owner==nil and (e.Root.Position-position).Magnitude<=radius then table.insert(found,e) end
    end
    table.sort(found,function(a,b) return (a.Root.Position-position).Magnitude<(b.Root.Position-position).Magnitude end)
    while #found>maximum do table.remove(found) end
    return found
end
function World.Effect(self: World, position: Vector3,kind: string,owner: Player?,target: Instance?)
    -- Server supplies bounded positions/identities; clients render pooled cosmetics only.
    self.FX:FireAllClients({Position=position,Kind=kind,Owner=owner and owner.UserId,Target=target})
end
function World.Damage(self: World, e: any,amount: number,owner: Player,now: number): boolean
    if e.Humanoid.Health<=0 or e.Owner~=nil or amount<=0 then return false end
    e.LastHit=owner;e.LastHitAt=now
    local applied=math.min(e.Humanoid.Health,amount,100000)
    e.Humanoid:TakeDamage(math.min(amount,100000))
    self.FX:FireAllClients({Kind="Damage",Position=e.Root.Position,Amount=applied,Owner=owner.UserId,Target=e.Model})
    return true
end
function World.DamagePlayer(self: World, player: Player,amount: number,source: any,now: number)
    local s=self.States[player];local hum=self:Humanoid(player)
    if not s or not s.Ready or s.Dead or not hum or hum.Health<=0 then return end
    s.LastCombat=now
    if s.Statuses.Invulnerable then
        self.Domain:Act(s,"HostileStrikeEvaded","dodge:"..tostring(source.Serial)..":"..tostring(math.floor(now)),now)
        return
    end
    if s.Statuses.Shielded then amount*=0.35 end
    if source.Statuses.Grafted and source.Statuses.Grafted.Owner==player then
        if self:Damage(source,amount,player,now) then
            self.Domain:Act(s,"GraftEncounterResolved","graft:"..source.Serial..":"..tostring(math.floor(now)),now)
        end
        return
    end
    if s.Statuses.Substitute and hum.Health<=amount then
        s.Statuses.Substitute=nil;hum.Health=math.max(1,hum.MaxHealth*0.2)
        self:Buff(s,"Invulnerable",2,now);self:Effect(hum.RootPart and hum.RootPart.Position or Vector3.zero,"Substitute",player)
        return
    end
    hum:TakeDamage(amount);s.Health=hum.Health
end
function World.Spawn(self: World, position: Vector3,tier: number,owner: Player?,expiresAt: number?): any
    local model=Instance.new("Model");model.Name=if owner then "Past Echo" else "Sealed Remnant · "..tostring(tier)
    local root=part(model,"HumanoidRootPart",Vector3.new(2,2,1),position,Color3.new(0,0,0));root.Transparency=1;root.CanCollide=false
    local torso=part(model,"Torso",Vector3.new(3,3,1.5),position,if owner then Color3.fromRGB(110,190,205) else Color3.fromRGB(120,75,145));torso.CanCollide=false
    local head=part(model,"Head",Vector3.new(1.8,1.8,1.8),position+Vector3.new(0,2.3,0),Color3.fromRGB(190,170,190));head.Shape=Enum.PartType.Ball;head.CanCollide=false
    local hum=Instance.new("Humanoid");hum.RequiresNeck=false;hum.BreakJointsOnDeath=false
    local t=self.Data.Stats.TierMultipliers[tier];hum.MaxHealth=self.Data.Runtime.NPCHealthPerTier*t;hum.Health=hum.MaxHealth;hum.WalkSpeed=0;hum.Parent=model
    model.PrimaryPart=root;model.Parent=self.NPCFolder
    CollectionService:AddTag(model,"Enemy");model:SetAttribute("AbilityId","ArcBolt");model:SetAttribute("Omen",math.random(1,4))
    self.Clock+=1
    local e: any={Model=model,Root=root,Humanoid=hum,Tier=tier,Power=t,Home=position,Owner=owner,ExpiresAt=expiresAt,
        Statuses={},LastAttack=0,LastHit=nil,LastHitAt=0,Serial=self.Clock,Threads=0,Stolen=false}
    self.Entities[model]=e
    hum.Died:Connect(function()
        if e.Rewarded then return end;e.Rewarded=true
        local killer=e.LastHit;local state=killer and self.States[killer]
        if state and state.Ready and os.clock()-e.LastHitAt<=20 and e.Owner==nil then
            state.Profile.Gold=math.min(10000000,state.Profile.Gold+self.Data.Runtime.NPCGoldReward)
        end
        self:Effect(root.Position,"Defeat",killer)
        Debris:AddItem(model,2)
    end)
    return e
end
function World.Step(self: World, dt: number,now: number)
    for player,s in pairs(self.States) do
        local root=self:Root(player)
        if not s.Ready or s.Dead or not root then continue end
        for _,zone in ipairs(CollectionService:GetTagged("MysticalExposure")) do
            if zone:IsA("BasePart") and (root.Position-zone.Position).Magnitude<self.Data.Runtime.ExposureRadius then
                self.Domain:DrainSanity(s,self.Data.Progression.Sanity.ExposureDrainPerSecond*dt,now)
                if now>=(s.NextWhisper or 0) then
                    s.NextWhisper=now+self.Data.Runtime.WhisperInterval
                    self.Domain:DrainSanity(s,self.Data.Progression.Sanity.WhisperDrain,now)
                    self.FX:FireClient(player,{Position=root.Position,Kind="Whisper"})
                end
                break
            end
        end
    end
    for _,spawn in ipairs(self.Spawns) do
        if spawn.Entity and (not spawn.Entity.Model.Parent or spawn.Entity.Humanoid.Health<=0) then
            spawn.Entity=nil;spawn.NextSpawn=now+self.Data.Runtime.NPCRespawnSeconds
        end
        if not spawn.Entity and now>=spawn.NextSpawn and table.find(self.Spawns,spawn)<=self.Data.Runtime.MaxEnemies then spawn.Entity=self:Spawn(spawn.Position,spawn.Tier,nil,nil) end
    end
    for model,e in pairs(self.Entities) do
        if not model.Parent then self.Entities[model]=nil;continue end
        if e.Humanoid.Health<=0 then continue end
        if e.ExpiresAt and now>=e.ExpiresAt then model:Destroy();self.Entities[model]=nil;continue end
        if e.Owner and not self.States[e.Owner] then
            if e.IsEcho then model:Destroy();self.Entities[model]=nil;continue end
            e.Owner=nil;e.Statuses={}
        end
        for id,st in pairs(e.Statuses) do
            if st.ExpiresAt<=now then
                e.Statuses[id]=nil
                if id=="Controlled" then e.Owner=nil end
                if id=="Threaded" then e.Threads=0 end
            elseif (id=="Burning" or id=="Parasite") and now>=st.NextTick then
                st.NextTick=now+1
                if st.Owner and self.States[st.Owner] then
                    self:Damage(e,st.Power,st.Owner,now)
                    if id=="Parasite" then
                        local h=self:Humanoid(st.Owner);if h then h.Health=math.min(h.MaxHealth,h.Health+st.Power*0.5) end
                    end
                end
            end
        end
        local blocked=false;local speed=self.Data.Runtime.NPCSpeed
        for id in pairs(e.Statuses) do
            local def=self.Data.StatusEffects[id]
            if def.BlocksAttacks then blocked=true end
            if def.MoveMultiplier then speed*=def.MoveMultiplier end
        end
        if e.Owner then
            local foes=self:Targets(e.Root.Position,55,1,e.Owner)
            local foe=foes[1]
            if foe then
                local delta=foe.Root.Position-e.Root.Position
                if delta.Magnitude>5 then model:PivotTo(model:GetPivot()+delta.Unit*math.min(delta.Magnitude-4,speed*dt))
                elseif now-e.LastAttack>=self.Data.Runtime.SummonAttackInterval then e.LastAttack=now;self:Damage(foe,self.Data.Runtime.SummonDamagePerTier*e.Power,e.Owner,now) end
            end
            continue
        end
        local nearest=nil;local distance=self.Data.Runtime.NPCNoticeRange
        for player,s in pairs(self.States) do
            local root=self:Root(player);local hum=self:Humanoid(player)
            if root and hum and hum.Health>0 and s.Ready and not s.Dead and root.Position.Magnitude>self.Data.Runtime.SanctuaryRadius then
                local range=if s.Statuses.Concealed then 0 elseif s.Statuses.Disguised then 12 else distance
                local d=(root.Position-e.Root.Position).Magnitude
                if d<distance and d<range then nearest=player;distance=d end
            end
        end
        if nearest and not blocked then
            local root=self:Root(nearest)
            if root and e.Tier<=6 and distance<self.Data.Runtime.NPCSpellRange and now-(e.LastSpell or -100)>self.Data.Runtime.NPCSpellCooldown and not self:Has(e,"Silenced",now) and self:LineOfSight(e.Root.Position,root.Position,model,nearest.Character) then
                e.LastSpell=now
                self:DamagePlayer(nearest,self.Data.Runtime.NPCSpellDamagePerTier*e.Power,e,now)
                self.Domain:DrainSanity(self.States[nearest],2,now)
                self:Effect(root.Position,"ArcBolt",nil)
            end
            if root then
                local delta=root.Position-e.Root.Position
                if delta.Magnitude>self.Data.Runtime.NPCAttackRange then
                    local step=delta.Unit*math.min(delta.Magnitude-4,speed*dt)
                    if (e.Root.Position+step-e.Home).Magnitude<75 then model:PivotTo(model:GetPivot()+Vector3.new(step.X,0,step.Z)) end
                elseif now-e.LastAttack>=self.Data.Runtime.NPCAttackInterval and self:LineOfSight(e.Root.Position,root.Position,model,nearest.Character) then
                    e.LastAttack=now
                    local payload=e.Statuses.Payload
                    if payload and payload.Owner then
                        e.Statuses.Payload=nil;self:Damage(e,payload.Power,payload.Owner,now)
                    end
                    self:DamagePlayer(nearest,self.Data.Runtime.NPCMeleeDamagePerTier*e.Power,e,now)
                    if e.Tier<=4 and not self:Has(e,"Silenced",now) then self.Domain:DrainSanity(self.States[nearest],3,now) end
                    self:Effect(e.Root.Position,"Strike",nil)
                end
            end
        elseif not nearest and (e.Root.Position-e.Home).Magnitude>2 and speed>0 then
            local delta=e.Home-e.Root.Position
            model:PivotTo(model:GetPivot()+delta.Unit*math.min(delta.Magnitude,dt*speed))
        end
    end
end
function World.Cleanup(self: World, player: Player)
    for model,e in pairs(self.Entities) do
        if e.Owner==player then
            if e.IsEcho then model:Destroy();self.Entities[model]=nil else e.Owner=nil;e.Statuses={} end
        end
        for id,st in pairs(e.Statuses) do if st.Owner==player then e.Statuses[id]=nil end end
    end
end
return World
```


## src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua

**LocalScript** at `StarterPlayer/StarterPlayerScripts/Mysteries`. Create matching Folder parents.

```lua
--!strict
-- Entry LocalScript. All Phase 1 visual tokens live in ReplicatedStorage.Shared.Theme.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local shared=ReplicatedStorage:WaitForChild("Shared")
local data=require(shared:WaitForChild("GameData"))
local T=require(shared:WaitForChild("Theme"))
local Layout=require(shared:WaitForChild("VisualLayout"))
local UI=script.Parent:WaitForChild("UI")
local Kit=require(UI.Kit)
local Hud=require(UI.Hud)
local Menus=require(UI.Menus)
local Prompts=require(UI.Prompts)
local Feedback=require(UI.Feedback)
local Developer=require(UI.Developer)
local Presentation=require(UI.Presentation)
local remotes=ReplicatedStorage:WaitForChild("MysteriesRemotes")
local intent=remotes:WaitForChild("Intent") :: RemoteEvent
local stateEvent=remotes:WaitForChild("State") :: RemoteEvent
local effectEvent=remotes:WaitForChild("Effect") :: RemoteEvent
-- Preserve the working third-person camera for Phase 1; camera feel is revised in Phase 4.
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=T.Camera.MinZoom;player.CameraMaxZoomDistance=T.Camera.MaxZoom
local old=player:WaitForChild("PlayerGui"):FindFirstChild("MysteriesHUD")
if old then old:Destroy() end
local gui=Kit.New("ScreenGui",player.PlayerGui,{Name="MysteriesHUD",ResetOnSpawn=false,IgnoreGuiInset=false,
    ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets,ClipToDeviceSafeArea=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local safeRoot=Kit.New("Frame",gui,{Name="SafeArea",Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
local state: any=nil
local modal=false
local cinematic=false
local menus: any=nil
local hud: any=nil
local promptUI=Prompts.new(safeRoot)
local function send(action: string,payload: any) intent:FireServer(action,payload) end
local function touchAim(): boolean
    return not modal and UserInputService.TouchEnabled and (not UserInputService.MouseEnabled
        or (hud and hud.Layout and hud.Layout.Name~="Desktop") or UserInputService:GetLastInputType()==Enum.UserInputType.Touch)
end
local function aim(): any
    local camera=workspace.CurrentCamera
    if not camera then return {} end
    local point=UserInputService:GetMouseLocation()
    local ray: Ray
    if touchAim() then
        local center=camera.ViewportSize/2
        ray=camera:ViewportPointToRay(center.X,center.Y)
    else ray=camera:ScreenPointToRay(point.X,point.Y) end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    if player.Character then params.FilterDescendantsInstances={player.Character} end
    local hit=workspace:Raycast(ray.Origin,ray.Direction*T.Input.RayLength,params)
    local target: Instance?=hit and hit.Instance or nil
    while target and target~=workspace do
        if target:IsA("Model") and target:FindFirstChildOfClass("Humanoid") then break end
        target=target.Parent
    end
    return {Position=if hit then hit.Position else ray.Origin+ray.Direction*T.Input.FallbackAim,Target=if target==workspace then nil else target}
end
local function cast(slot: number)
    if modal or not state or not state.Ready or state.Dead then return end
    local id=state.Loadout[slot]
    if not id then return end
    local payload=aim();payload.Id=id;send("Cast",payload)
end
local function melee()
    if not modal and state and state.Ready and not state.Dead then send("Melee",aim()) end
end
local feedback=Feedback.new(safeRoot,data,function(active: boolean)
    cinematic=active
    if hud then hud.Wordmark.Visible=not active and not promptUI.Root.Visible;hud.Pathway.Visible=not active and not promptUI.Root.Visible end
end)
hud=Hud.new(safeRoot,data,{Cast=cast,Melee=melee,Touch=UserInputService.TouchEnabled,TouchAim=touchAim,Journal=function(tab: string)
    if menus.Root.Visible and menus.Tab==tab and menus.View=="Page" then menus:Close() else menus:Open(tab) end
end})
menus=Menus.new(safeRoot,data,{Intent=send,Modal=function(open: boolean)
    modal=open;promptUI:SetModal(open);hud.Tooltip.Visible=false
end,ReducedMotion=function(reduced: boolean) feedback.ReducedMotion=reduced end})
local developer=Developer.new(safeRoot,send)
local presentation=Presentation.new(gui,data)
promptUI.OnVisibility=function(visible: boolean)
    hud.Pathway.Visible=not visible and not cinematic;hud.Wordmark.Visible=not visible and not cinematic
end
promptUI.Exclusions={hud.Pathway,hud.Cast,feedback.Notice,feedback.Advance,developer.Root}
local function resize()
    local size=safeRoot.AbsoluteSize
    if size.X<=0 or size.Y<=0 then return end
    local layout=Layout.Resolve(T,size.X,size.Y,UserInputService.TouchEnabled)
    hud:Resize(layout);menus:Resize(layout);feedback:Resize(layout);developer:Resize(layout);promptUI.Layout=layout
    hud.Wordmark.Visible=not cinematic and not promptUI.Root.Visible;hud.Pathway.Visible=not cinematic and not promptUI.Root.Visible
    if menus.Root.Visible then menus:Render() end
end
safeRoot:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(resize)
stateEvent.OnClientEvent:Connect(function(update: any)
    if type(update)~="table" then return end
    if update.Message then
        feedback:Tell(update.Message)
        if menus.Waiting and not menus.Purchase then menus:Close() end
        return
    end
    if update.Menu=="Altar" then menus:Altar(update.ExpiresIn or T.Timing.AltarExpiry);return end
    if update.Purchase then
        Kit.Sound(gui,if update.Purchase.Ok then "Confirm" else "Reject")
        menus:Close();feedback:Tell(update.Purchase.Message,not update.Purchase.Ok);return
    end
    state=update
    developer:Update(update);hud:Render(update,os.clock());menus:Update(update);feedback:Update(update)
    if update.Dead and menus.Root.Visible then menus:Close() end
end)
effectEvent.OnClientEvent:Connect(function(event: any)
    if type(event)~="table" or typeof(event.Position)~="Vector3" or type(event.Kind)~="string" then return end
    if event.Kind=="Damage" then feedback:Damage(event);return end
    presentation:Event(event)
end)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==T.Input.Developer then developer:Toggle();return end
    if processed then return end
    if input.KeyCode==T.Input.Journal then
        if menus.Root.Visible then menus:Close() else menus:Open("Journal") end
        return
    end
    if input.KeyCode==Enum.KeyCode.Escape and menus.Root.Visible then menus:Close();return end
    if modal then return end
    -- E belongs to an active prompt, preventing a simultaneous slot-2 cast.
    if promptUI.Current and input.KeyCode==promptUI.Current.KeyboardKeyCode then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then melee();return end
    for i,key in ipairs(T.Input.Keys) do if input.KeyCode==key then cast(i);return end end
end)
local accumulator=0
RunService.Heartbeat:Connect(function(dt: number)
    accumulator+=dt
    if accumulator<T.Timing.Step then return end
    accumulator=0
    local now=os.clock()
    hud:Step(now);menus:Step(now);feedback:Step(now)
    feedback.Notice.Visible=now<(feedback.NoticeUntil or 0) and not hud.Cast.Visible and not cinematic and not modal
    hud.Wordmark.Visible=not cinematic and not promptUI.Root.Visible and not feedback.Notice.Visible and not hud.Cast.Visible
end)
resize()
send("Sync",{})
```


## src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Developer`. Create matching Folder parents.

```lua
--!strict
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Kit)
local Developer={}
function Developer.new(parent: Instance,send: any): any
    local self: any={Allowed=false,State=nil}
    self.Root=Kit.Panel(parent,"DeveloperPanel");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    local title=Kit.Text(self.Root,"DEVELOPER · F8",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(T.Layout.Developer.Pad,0);title.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{Name="DeveloperControls",BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,
        CanvasSize=UDim2.fromOffset(0,T.Layout.Developer.Height-T.Layout.Developer.Row),ScrollingDirection=Enum.ScrollingDirection.Y,
        Position=UDim2.fromOffset(0,T.Layout.Developer.Row),Size=UDim2.new(1,0,1,-T.Layout.Developer.Row)})
    self.Info=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Number)
    self.Info.Position=UDim2.fromOffset(T.Layout.Developer.Pad,0);self.Info.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row*2)
    self.Buttons={}
    for i,id in ipairs({"Seer","Marauder","Apprentice"}) do
        local b=Kit.Button(self.Scroll,"Studio mastery: "..id,function()
            if self.Allowed then send("DevMastery",{PathwayId=id}) end
        end)
        b.Position=UDim2.fromOffset(T.Layout.Developer.Pad,T.Layout.Developer.Row*2+(i-1)*(T.Layout.Developer.Row+T.Layout.Developer.Gap))
        b.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row);table.insert(self.Buttons,b)
    end
    return setmetatable(self,{__index=Developer})
end
function Developer.Resize(self: any,layout: any)
    local width=math.min(T.Layout.Developer.Width,layout.Width-layout.Profile.Margin*2)
    self.Root.Size=UDim2.fromOffset(width,math.min(T.Layout.Developer.Height,layout.Height-layout.Profile.Margin*2))
    self.Root.Position=UDim2.fromOffset(layout.Width-layout.Profile.Margin-width,math.min(T.Layout.Developer.Top,layout.Profile.Margin))
end
function Developer.Update(self: any,state: any)
    self.State=state;self.Allowed=state and state.Developer==true
    if not self.Allowed then self.Root.Visible=false;return end
    local info=state.DeveloperInfo
    self.Info.Text=if info then (if info.SessionOnly then "Studio session · not saved" else "DataStore session").."\nMode: "..info.Mode.."\nReady: "..tostring(info.Ready) else "Loading developer diagnostics…"
    for _,b in ipairs(self.Buttons) do b.Interactable=info~=nil and info.SessionOnly==true and state.Ready end
end
function Developer.Toggle(self: any)
    if self.Allowed then self.Root.Visible=not self.Root.Visible end
end
return Developer
```


## src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Feedback`. Create matching Folder parents.

```lua
--!strict
local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Kit=require(script.Parent.Kit)
local Feedback={}
function Feedback.new(parent: GuiObject,data: any,cinematic: (boolean)->()): any
    local self: any={SafeRoot=parent,Data=data,Cinematic=cinematic,State=nil,ReducedMotion=false,NoticeSerial=0,AdvanceSerial=0,Numbers={},Pool={},Layout=nil}
    self.Root=Kit.New("Frame",parent,{Name="Feedback",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=T.Layers.Feedback})
    self.Notice=Kit.New("CanvasGroup",self.Root,{Name="Notice",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Notice);Kit.Stroke(self.Notice)
    self.NoticeText=Kit.Text(self.Notice,"",T.Type.Number,T.Fonts.Number);self.NoticeText.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,1,0);self.NoticeText.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,0);self.NoticeText.TextXAlignment=Enum.TextXAlignment.Center
    self.Advance=Kit.New("CanvasGroup",self.Root,{Name="SequenceAdvance",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Advance);Kit.Stroke(self.Advance)
    self.AdvanceSmall=Kit.Text(self.Advance,"",T.Type.Small,T.Fonts.Number);self.AdvanceSmall.Size=UDim2.new(1,0,0,T.Feedback.SubtitleHeight);self.AdvanceSmall.TextXAlignment=Enum.TextXAlignment.Center
    self.AdvanceTitle=Kit.Text(self.Advance,"",T.Type.Title,T.Fonts.Title);self.AdvanceTitle.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,0,T.Feedback.AdvanceTitleHeight);self.AdvanceTitle.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,T.Feedback.SubtitleHeight);self.AdvanceTitle.TextXAlignment=Enum.TextXAlignment.Center
    self.Vignette=Kit.New("Frame",self.Root,{Name="SanityVignette",Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
    self.Edges={}
    self.Flashes={}
    for index=1,4 do
        local horizontal=index<=2
        local pos=if index==1 then UDim2.fromScale(0,0) elseif index==2 then UDim2.fromScale(0,1) elseif index==3 then UDim2.fromScale(0,0) else UDim2.fromScale(1,0)
        local anchor=if index==2 then Vector2.new(0,1) elseif index==4 then Vector2.new(1,0) else Vector2.zero
        local size=if horizontal then UDim2.fromScale(1,T.Layout.Vignette.Thickness) else UDim2.fromScale(T.Layout.Vignette.Thickness,1)
        local rotation=if index==1 then 90 elseif index==2 then 270 elseif index==3 then 0 else 180
        for _,pair in ipairs({{Target=self.Edges,Color=T.Colors.Sanity},{Target=self.Flashes,Color=T.Colors.Hit}}) do
            local f=Kit.New("Frame",self.Vignette,{Size=size,Position=pos,AnchorPoint=anchor,BorderSizePixel=0,BackgroundColor3=pair.Color,BackgroundTransparency=1})
            Kit.New("UIGradient",f,{Rotation=rotation,Transparency=NumberSequence.new(0,1)})
            table.insert(pair.Target,f)
        end
    end
    local old=Lighting:FindFirstChild("MysteriesSanity")
    if old then old:Destroy() end
    self.Correction=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesSanity",Enabled=false})
    return setmetatable(self,{__index=Feedback})
end
function Feedback.Resize(self: any,layout: any)
    self.Layout=layout
    Kit.Rect(self.Notice,layout.Notice)
    local width=math.min(T.Layout.Advance.Width,layout.Width-layout.Profile.Margin*2)
    local x=(layout.Width-width)/2
    local top=T.Layout.Advance.Top
    if x<layout.Resources.X+layout.Resources.W and x+width>layout.Resources.X then top=math.max(top,layout.Resources.Y+layout.Resources.H+T.Layout.Modal.Gap) end
    Kit.Rect(self.Advance,{X=x,Y=top,W=width,H=T.Layout.Advance.Height})
    self.AdvanceTitle.TextSize=if layout.Name=="Phone" or layout.Name=="Landscape" then T.Feedback.AdvanceMobileTitle elseif layout.Name=="Tablet" then T.Feedback.AdvanceTabletTitle else T.Type.Title
end
function Feedback.Tell(self: any,text: string,rejected: boolean?)
    self.NoticeUntil=os.clock()+T.Timing.Notice+T.Timing.NoticeFade
    self.NoticeSerial+=1;local serial=self.NoticeSerial
    self.NoticeText.Text=text;self.NoticeText.TextColor3=if rejected then T.Colors.Danger else T.Colors.Text
    self.Notice.Visible=true;self.Notice.GroupTransparency=0
    if rejected then Kit.Sound(self.Root,"Reject") end
    task.delay(T.Timing.Notice,function()
        if serial~=self.NoticeSerial then return end
        local tween=Kit.Tween(self.Notice,T.Timing.NoticeFade,{GroupTransparency=1})
        tween.Completed:Once(function() if serial==self.NoticeSerial then self.Notice.Visible=false end end)
    end)
end
function Feedback.Flash(self: any)
    Kit.Sound(self.Root,"Hit")
    if self.ReducedMotion then return end
    for _,f in ipairs(self.Flashes) do
        local tween=Kit.Tween(f,T.Timing.FlashIn,{BackgroundTransparency=1-T.Layout.Vignette.FlashAlpha})
        tween.Completed:Once(function() if f.Parent then Kit.Tween(f,T.Timing.FlashOut,{BackgroundTransparency=1}) end end)
    end
end
function Feedback.Sequence(self: any,state: any)
    self.AdvanceSerial+=1;local serial=self.AdvanceSerial
    local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
    self.AdvanceSmall.Text="SEQUENCE "..state.Sequence.." · "..string.upper(state.PathwayId)
    self.AdvanceSmall.TextColor3=Kit.PathColor(state.PathwayId);self.AdvanceTitle.Text=seq.Name
    self.Advance.Visible=true;self.Advance.GroupTransparency=1;self.Cinematic(true);Kit.Sound(self.Root,"Advance")
    Kit.Tween(self.Advance,T.Timing.AdvanceIn,{GroupTransparency=0})
    task.delay(T.Timing.AdvanceIn+T.Timing.AdvanceHold,function()
        if serial~=self.AdvanceSerial then return end
        local tween=Kit.Tween(self.Advance,T.Timing.AdvanceOut,{GroupTransparency=1})
        tween.Completed:Once(function()
            if serial==self.AdvanceSerial then self.Advance.Visible=false;self.Cinematic(false) end
        end)
    end)
end
function Feedback.Update(self: any,state: any)
    local previous=self.State
    self.State=state
    if not state or not state.Ready then return end
    if previous and previous.Ready then
        if state.Health<previous.Health then self:Flash() end
        if state.PathwayId and (state.PathwayId~=previous.PathwayId or state.Sequence~=previous.Sequence) then self:Sequence(state) end
    end
    self.Correction.Enabled=state.Sanity<T.Layout.Vignette.Low or state.Mode~="Normal"
    self.Correction.TintColor=if state.Mode=="LostControl" then T.Colors.LostTint elseif state.Mode=="Madness" then T.Colors.MadnessTint else T.Colors.ClearTint
    self.Correction.Saturation=if state.Mode=="Normal" then T.Feedback.NormalSaturation else T.Feedback.MadnessSaturation
end
function Feedback.Damage(self: any,event: any)
    if event.Owner~=Players.LocalPlayer.UserId or #self.Numbers>=T.Layout.Damage.Max then return end
    local label: TextLabel=table.remove(self.Pool) or Kit.Text(self.Root,"",T.Type.Damage,T.Fonts.Number)
    label.BackgroundColor3=T.Colors.Ink;label.AnchorPoint=Vector2.new(0.5,0.5);label.TextXAlignment=Enum.TextXAlignment.Center
    label.Size=UDim2.fromOffset(T.Layout.Damage.Width,T.Layout.Damage.Height)
    if not label:FindFirstChildOfClass("UIStroke") then Kit.Corner(label);Kit.Stroke(label) end
    label.Text=tostring(math.max(0,math.round(event.Amount or 0)));label.Visible=true;label.BackgroundTransparency=0;label.TextTransparency=0
    table.insert(self.Numbers,{Label=label,Position=event.Position,Started=os.clock(),Index=#self.Numbers})
end
function Feedback.Step(self: any,now: number)
    local state=self.State
    local severity=if state and state.Ready then math.clamp((T.Layout.Vignette.Low-state.Sanity)/T.Layout.Vignette.Low,0,1) else 0
    local breath=if self.ReducedMotion then 1 else T.Layout.Vignette.BreathMin+(1-T.Layout.Vignette.BreathMin)*(math.sin(now*math.pi*2/T.Timing.SanityBreath)+1)/2
    for _,f in ipairs(self.Edges) do f.BackgroundTransparency=1-T.Layout.Vignette.MaxAlpha*severity*breath end
    local camera=workspace.CurrentCamera
    for i=#self.Numbers,1,-1 do
        local number=self.Numbers[i];local elapsed=now-number.Started
        if elapsed>=T.Timing.DamageLife then
            number.Label.Visible=false;table.insert(self.Pool,number.Label);table.remove(self.Numbers,i)
        elseif camera then
            local p,visible=camera:WorldToViewportPoint(number.Position+Vector3.new(0,T.Layout.Damage.OffsetStuds,0))
            local origin=self.SafeRoot.AbsolutePosition
            number.Label.Visible=visible
            number.Label.Position=UDim2.fromOffset(p.X-origin.X+(number.Index%3-1)*T.Feedback.DamageStagger,p.Y-origin.Y-T.Layout.Damage.Rise*math.min(1,elapsed/T.Timing.DamageRise))
            local alpha=math.clamp((elapsed-T.Timing.DamageRise)/math.max(T.LegacyFX.MinBarFraction,T.Timing.DamageLife-T.Timing.DamageRise),0,1)
            number.Label.TextTransparency=alpha;number.Label.BackgroundTransparency=alpha
        end
    end
end
return Feedback
```


## src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Hud`. Create matching Folder parents.

```lua
--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Model=require(Shared.VisualModel)
local Kit=require(script.Parent.Kit)
local Hud={}
function Hud.new(parent: Instance,data: any,callbacks: any): any
    local self: any={Data=data,Callbacks=callbacks,Slots={},Bars={},State=nil,ReceivedAt=0,Collapsed=nil,Layout=nil}
    self.Root=Kit.New("Frame",parent,{Name="HUD",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=T.Layers.HUD})
    Kit.New("UIScale",self.Root,{Scale=T.Layout.Scale})
    self.Resources=Kit.Panel(self.Root,"Vitals")
    self.ResourceInner=Kit.New("Frame",self.Resources,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
    self.ResourcePadding=Kit.Padding(self.ResourceInner,T.Layout.Desktop.PanelPad)
    self.ResourceList=Kit.List(self.ResourceInner,T.Layout.Desktop.ResourceGap)
    for index,spec in ipairs({{Key="Health",Name="HP",Glyph="Heart"},{Key="Spirituality",Name="Spirit",Glyph="Star"},{Key="Sanity",Name="Sanity",Glyph="Eye"}}) do
        local row=Kit.New("Frame",self.ResourceInner,{Name=spec.Key,BackgroundTransparency=1,LayoutOrder=index})
        local icon=Kit.Glyph(row,spec.Glyph,T.Layout.Resource.IconX,T.Colors[spec.Key])
        local text=Kit.Text(row,spec.Name,T.Type.Small,T.Fonts.Number)
        local number=Kit.Text(row,"—",T.Type.Number,T.Fonts.Number);number.TextXAlignment=Enum.TextXAlignment.Right
        local track=Kit.New("Frame",row,{BackgroundColor3=T.Colors.Slate,BorderSizePixel=0})
        local fill=Kit.New("Frame",track,{Size=UDim2.fromScale(0,1),BackgroundColor3=T.Colors[spec.Key],BorderSizePixel=0})
        Kit.Corner(track,T.Style.FillCorner);Kit.Corner(fill,T.Style.FillCorner)
        self.Bars[spec.Key]={Row=row,Icon=icon,Text=text,Number=number,Track=track,Fill=fill,Spec=spec}
    end
    self.Wordmark=Kit.Text(self.Root,"M Y S T E R I E S",T.Type.Heading,T.Fonts.Title);self.Wordmark.TextXAlignment=Enum.TextXAlignment.Center
    self.Pathway=Kit.Panel(self.Root,"Pathway")
    self.PathTitle=Kit.Text(self.Pathway,"Uninitiated",T.Type.Heading,T.Fonts.Heading)
    self.PathTitle.TextScaled=true
    Kit.New("UITextSizeConstraint",self.PathTitle,{MinTextSize=T.Type.Micro,MaxTextSize=T.Type.Heading})
    self.Digestion=Kit.Text(self.Pathway,"Digestion 0%",T.Type.Small,T.Fonts.Number)
    self.DigestionTrack=Kit.New("Frame",self.Pathway,{BorderSizePixel=0,BackgroundColor3=T.Colors.Slate})
    self.DigestionFill=Kit.New("Frame",self.DigestionTrack,{BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,Size=UDim2.fromScale(0,1)})
    Kit.Corner(self.DigestionTrack,T.Style.FillCorner);Kit.Corner(self.DigestionFill,T.Style.FillCorner)
    self.Objective=Kit.Text(self.Pathway,"Choose your first potion in the journal.",T.Type.Small)
    self.Objective.TextYAlignment=Enum.TextYAlignment.Top
    self.Collapse=Kit.Button(self.Pathway,T.Style.DisclosureOpen,function()
        if not self.Layout then return end
        if not self.Layout.CanExpand then callbacks.Journal("Pathway");return end
        self.Collapsed=not self.Collapsed;self:Resize(self.Layout)
    end)
    self.Collapse.BackgroundTransparency=1
    self.Journal=Kit.Button(self.Root,"Journal [B]",function() callbacks.Journal("Journal") end)
    self.Strike=Kit.Button(self.Root,"Strike",function() callbacks.Melee() end)
    self.Hotbar=Kit.Panel(self.Root,"AbilityHotbar")
    self.Cards=Kit.New("Frame",self.Hotbar,{BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
    self.CardPadding=Kit.Padding(self.Cards,T.Layout.Desktop.BarPad)
    self.CardList=Kit.List(self.Cards,T.Layout.Desktop.SlotGap,true)
    self.Tooltip=Kit.Panel(self.Root,"AbilityTooltip");self.Tooltip.Visible=false
    self.TooltipText=Kit.Text(self.Tooltip,"",T.Type.Small);self.TooltipText.Size=UDim2.new(1,-T.Layout.Modal.Gap*2,1,0);self.TooltipText.Position=UDim2.fromOffset(T.Layout.Modal.Gap,0)
    for i=1,T.Layout.Hotbar.Slots do
        local card=Kit.New("Frame",self.Cards,{Name="Slot"..i,BackgroundTransparency=1,LayoutOrder=i})
        local face=Kit.Button(card,"",function() callbacks.Cast(i) end)
        face.Name="Ability";Kit.New("UIAspectRatioConstraint",face,{AspectRatio=1})
        local glyph=Kit.New("Frame",face,{Name="Icon",BackgroundTransparency=1})
        local seal=Kit.New("Frame",face,{Name="VacantSeal",BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
        local emptyGlyph=Kit.Glyph(seal,"Seal",T.Layout.Desktop.Slot*T.Layout.Hotbar.SealSize,T.Colors.Muted)
        emptyGlyph.AnchorPoint=Vector2.new(0.5,0.5);emptyGlyph.Position=UDim2.fromScale(0.5,0.5)
        local dashes={}
        for edge=1,4 do
            for dash=1,T.Layout.Hotbar.DashedCount do
                local p=T.Layout.Hotbar.DashInset+(dash-1)*(1-T.Layout.Hotbar.DashInset*2)/(T.Layout.Hotbar.DashedCount-1)
                local horizontal=edge<=2
                local line=Kit.New("Frame",seal,{BorderSizePixel=0,BackgroundColor3=T.Colors.Muted,BackgroundTransparency=T.Style.SealAlpha,
                    AnchorPoint=Vector2.new(0.5,0.5),Position=if horizontal then UDim2.fromScale(p,if edge==1 then 0 else 1) else UDim2.fromScale(if edge==3 then 0 else 1,p),
                    Size=if horizontal then UDim2.new(T.Layout.Hotbar.DashLength,0,0,T.Layout.Hotbar.DashThickness) else UDim2.new(0,T.Layout.Hotbar.DashThickness,T.Layout.Hotbar.DashLength,0)})
                table.insert(dashes,line)
            end
        end
        local badge=Kit.Panel(face,"KeyBadge");local key=Kit.Text(badge,T.Input.KeyNames[i],T.Type.Micro,T.Fonts.Number);key.Size=UDim2.fromScale(1,1);key.TextXAlignment=Enum.TextXAlignment.Center
        local cost=Kit.Text(card,"",T.Type.Micro,T.Fonts.Number);cost.TextColor3=T.Colors.Spirituality;cost.TextXAlignment=Enum.TextXAlignment.Center
        local countdown=Kit.Text(face,"",T.Type.Number,T.Fonts.Number);countdown.AnchorPoint=Vector2.new(0.5,0.5);countdown.Position=UDim2.fromScale(0.5,0.5);countdown.BackgroundColor3=T.Colors.Ink;countdown.BackgroundTransparency=T.Style.PanelFade;countdown.Visible=false
        local segments={}
        for segment=1,T.Layout.Hotbar.Segments do
            local angle=(segment-1)/T.Layout.Hotbar.Segments*math.pi*2-math.pi/2
            table.insert(segments,Kit.New("Frame",face,{Name="CooldownSegment",BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5+math.cos(angle)*T.Layout.Hotbar.RingRadius,0.5+math.sin(angle)*T.Layout.Hotbar.RingRadius),
                Size=UDim2.fromOffset(T.Layout.Hotbar.SegmentWidth,T.Layout.Hotbar.SegmentHeight),Rotation=math.deg(angle)+90,Visible=false}))
        end
        self.Slots[i]={Card=card,Face=face,Glyph=glyph,Seal=seal,EmptyGlyph=emptyGlyph,KeyBadge=badge,Key=key,Cost=cost,Countdown=countdown,Segments=segments,Id=false}
        local function show()
            if callbacks.Touch then return end
            local id=self.State and self.State.Loadout and self.State.Loadout[i]
            local a=id and data.Abilities[id]
            if a then self.TooltipText.Text=a.Name.." · "..tostring(a.SpiritualityCost).." spirituality";self.Tooltip.Visible=true end
        end
        face.MouseEnter:Connect(show);face.SelectionGained:Connect(show)
        face.MouseLeave:Connect(function() self.Tooltip.Visible=false end);face.SelectionLost:Connect(function() self.Tooltip.Visible=false end)
    end
    self.Cast=Kit.Panel(self.Root,"CastFeedback");self.Cast.Visible=false
    self.CastText=Kit.Text(self.Cast,"",T.Type.Small,T.Fonts.Number);self.CastText.Size=UDim2.fromScale(1,1);self.CastText.TextXAlignment=Enum.TextXAlignment.Center
    self.CastTrack=Kit.New("Frame",self.Cast,{BorderSizePixel=0,BackgroundColor3=T.Colors.Spirituality,AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1)})
    self.Reticle=Kit.Glyph(self.Root,"Seal",T.Layout.Cast.Reticle,T.Colors.Muted)
    self.Reticle.AnchorPoint=Vector2.new(0.5,0.5);self.Reticle.Position=UDim2.fromScale(0.5,0.5);self.Reticle.Visible=false
    return setmetatable(self,{__index=Hud})
end
function Hud.Resize(self: any,layout: any)
    self.Layout=layout
    if self.Collapsed==nil then self.Collapsed=layout.DefaultCollapsed end
    local p,l=layout.Profile,T.Layout
    Kit.Rect(self.Resources,layout.Resources);Kit.Rect(self.Wordmark,layout.Wordmark);Kit.Rect(self.Journal,layout.Journal);Kit.Rect(self.Hotbar,layout.Hotbar);Kit.Rect(self.Cast,layout.Cast)
    self.Wordmark.TextSize=p.HeadingSize
    self.Journal.Text=if layout.Name=="Phone" or layout.Name=="Landscape" then "B" else "Journal [B]"
    self.ResourcePadding.PaddingTop=UDim.new(0,p.PanelPad);self.ResourcePadding.PaddingBottom=UDim.new(0,p.PanelPad)
    self.ResourcePadding.PaddingLeft=UDim.new(0,p.PanelPad);self.ResourcePadding.PaddingRight=UDim.new(0,p.PanelPad)
    self.ResourceList.Padding=UDim.new(0,p.ResourceGap)
    local rowHeight=(p.Resources[2]-p.PanelPad*2-p.ResourceGap*2)/3
    for _,bar in pairs(self.Bars) do
        bar.Row.Size=UDim2.new(1,0,0,rowHeight)
        bar.Icon.Size=UDim2.fromOffset(p.ResourceIcon,p.ResourceIcon);bar.Icon.Position=UDim2.fromOffset(0,0)
        bar.Text.Position=UDim2.fromOffset(p.ResourceIcon+p.ResourceGap,0);bar.Text.Size=UDim2.new(1,-l.Resource.NumberWidth-p.ResourceIcon,0,rowHeight-l.Resource.TrackHeight)
        bar.Text.TextSize=T.Type.Micro;bar.Text.Visible=layout.Name=="Desktop"
        bar.Number.Size=UDim2.new(1,-p.ResourceIcon-p.ResourceGap,0,rowHeight-l.Resource.TrackHeight);bar.Number.Position=UDim2.fromOffset(p.ResourceIcon+p.ResourceGap,0);bar.Number.TextSize=p.NumberSize
        bar.Track.Position=UDim2.new(0,p.ResourceIcon+p.ResourceGap,1,-l.Resource.TrackHeight);bar.Track.Size=UDim2.new(1,-p.ResourceIcon-p.ResourceGap,0,l.Resource.TrackHeight)
    end
    local height=if self.Collapsed or not layout.CanExpand then p.PathwayCollapsed else p.PathwayHeight
    self.Pathway.Position=UDim2.fromOffset(layout.Pathway.X,layout.Pathway.Y)
    Kit.Tween(self.Pathway,T.Timing.Collapse,{Size=UDim2.fromOffset(layout.Pathway.W,height)})
    self.PathTitle.Position=UDim2.fromOffset(l.Pathway.Pad,0);self.PathTitle.Size=UDim2.new(1,-l.Pathway.Pad-l.Pathway.Toggle,0,p.PathwayCollapsed)
    self.Collapse.Size=UDim2.fromOffset(l.Pathway.Toggle,l.Pathway.Toggle);self.Collapse.AnchorPoint=Vector2.new(1,0.5);self.Collapse.Position=UDim2.new(1,0,0,p.PathwayCollapsed/2)
    self.Collapse.Text=if self.Collapsed or not layout.CanExpand then T.Style.DisclosureClosed else T.Style.DisclosureOpen
    local expanded=not self.Collapsed and layout.CanExpand
    self.Digestion.Visible=expanded;self.DigestionTrack.Visible=expanded;self.Objective.Visible=expanded
    self.Digestion.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.HeadingHeight);self.Digestion.Size=UDim2.new(1,-l.Pathway.Pad*2,0,l.Pathway.SummaryHeight)
    self.DigestionTrack.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.HeadingHeight+l.Pathway.SummaryHeight);self.DigestionTrack.Size=UDim2.new(1,-l.Pathway.Pad*2,0,l.Pathway.TrackHeight)
    self.Objective.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.ObjectiveTop);self.Objective.Size=UDim2.new(1,-l.Pathway.Pad*2,0,p.PathwayHeight-l.Pathway.ObjectiveTop-l.Pathway.Pad);self.Objective.TextSize=T.Type.Small
    self.CardPadding.PaddingLeft=UDim.new(0,p.BarPad);self.CardPadding.PaddingRight=UDim.new(0,p.BarPad)
    self.CardPadding.PaddingTop=UDim.new(0,l.Hotbar.Top);self.CardPadding.PaddingBottom=UDim.new(0,0);self.CardList.Padding=UDim.new(0,p.SlotGap)
    for _,slot in ipairs(self.Slots) do
        slot.Card.Size=UDim2.fromOffset(p.Slot,p.HotbarHeight-l.Hotbar.Top)
        slot.Face.Size=UDim2.fromOffset(p.Slot,p.Slot)
        slot.Glyph.Size=UDim2.fromScale(l.Hotbar.GlyphFraction,l.Hotbar.GlyphFraction);slot.Glyph.AnchorPoint=Vector2.new(0.5,0.5);slot.Glyph.Position=UDim2.fromScale(0.5,0.5)
        slot.EmptyGlyph.Size=UDim2.fromOffset(p.Slot*l.Hotbar.SealSize,p.Slot*l.Hotbar.SealSize)
        slot.KeyBadge.Position=UDim2.fromOffset(l.Hotbar.KeyPad,l.Hotbar.KeyPad)
        local badge=if layout.Name=="Phone" or layout.Name=="Landscape" then l.Hotbar.KeyPhone else l.Hotbar.KeySize
        slot.KeyBadge.Size=UDim2.fromOffset(badge,badge)
        slot.Cost.Position=UDim2.fromOffset(0,p.Slot+l.Hotbar.CostPad);slot.Cost.Size=UDim2.fromOffset(p.Slot,l.Hotbar.CostHeight)
        slot.Countdown.Size=UDim2.fromOffset(p.Slot-l.Modal.Gap,l.Hotbar.CountdownHeight)
        slot.Id=false
    end
    self.Tooltip.Size=UDim2.fromOffset(math.min(l.Hotbar.TooltipWidth,layout.Width-p.Margin*2),l.Hotbar.TooltipHeight)
    self.Tooltip.AnchorPoint=Vector2.new(0.5,1);self.Tooltip.Position=UDim2.fromOffset(layout.Hotbar.X+layout.Hotbar.W/2,layout.Hotbar.Y-l.Hotbar.TooltipGap)
    self.Strike.Visible=self.Callbacks.Touch
    Kit.Rect(self.Strike,layout.Action)
    self:Render(self.State,self.ReceivedAt)
end
function Hud.Render(self: any,state: any,receivedAt: number)
    self.State=state;self.ReceivedAt=receivedAt
    if not state or not state.Ready then self.PathTitle.Text="Opening journal…";return end
    for key,bar in pairs(self.Bars) do
        local maximum=if key=="Sanity" then 100 else state["Max"..key]
        bar.Number.Text=string.format("%d / %d",math.ceil(state[key]),math.ceil(maximum))
        Kit.Tween(bar.Fill,T.Timing.Fill,{Size=UDim2.fromScale(math.clamp(state[key]/math.max(1,maximum),0,1),1)})
    end
    if state.PathwayId then
        local path=self.Data.Pathways[state.PathwayId];local seq=path.Sequences[state.Sequence]
        self.PathTitle.Text=path.Alias.." · "..tostring(state.Sequence).."  |  "..math.floor(state.Digestion).."%"
        self.Objective.Text=seq.ActingObjectives[1].Label
        self.Digestion.Text=seq.Name.." · digestion "..string.format("%.1f%%",state.Digestion)
        self.DigestionFill.BackgroundColor3=Kit.PathColor(state.PathwayId)
    else
        self.PathTitle.Text="Uninitiated"
        self.Digestion.Text="Choose a pathway"
        self.Objective.Text="Open the journal to drink your first potion."
    end
    Kit.Tween(self.DigestionFill,T.Timing.Fill,{Size=UDim2.fromScale(math.clamp(state.Digestion/100,0,1),1)})
    for i,slot in ipairs(self.Slots) do
        local id=state.Loadout[i];local a=id and self.Data.Abilities[id]
        if slot.Id~=id then
            slot.Id=id;Kit.Clear(slot.Glyph)
            slot.Seal.Visible=not a;slot.KeyBadge.Visible=a~=nil;slot.Cost.Text=if a then "✦ "..tostring(a.SpiritualityCost) else ""
            for _,child in ipairs(slot.Face:GetChildren()) do if child:IsA("UIStroke") then child.Transparency=if a then T.Style.BorderAlpha else 1 end end
            if a and self.Layout then
                local icon=Kit.Glyph(slot.Glyph,T.OperationGlyph[a.Operation.Kind] or "Seal",self.Layout.Profile.Slot*T.Layout.Hotbar.GlyphFraction,Kit.PathColor(a.PathwayId))
                icon.Size=UDim2.fromScale(1,1)
            end
        end
    end
    self:Step(os.clock())
end
function Hud.Step(self: any,now: number)
    local state=self.State
    if not state or not state.Ready then return end
    self.Reticle.Visible=self.Callbacks.TouchAim and self.Callbacks.TouchAim() or false
    local elapsed=now-self.ReceivedAt
    for _,slot in ipairs(self.Slots) do
        local a=slot.Id and self.Data.Abilities[slot.Id]
        local remaining=if a then Model.Cooldown(state,slot.Id,elapsed) else 0
        local n=if a then math.ceil(math.clamp(remaining/a.CooldownSeconds,0,1)*T.Layout.Hotbar.Segments) else 0
        slot.Countdown.Visible=remaining>0
        slot.Countdown.Text=if remaining>0 then string.format("%.1f",remaining) else ""
        for i,segment in ipairs(slot.Segments) do segment.Visible=i<=n end
    end
    local a=state.Casting and self.Data.Abilities[state.Casting]
    self.Cast.Visible=a~=nil
    if a then
        local remaining=math.max(0,(state.CastRemaining or a.CastTimeSeconds)-elapsed)
        self.CastText.Text=a.Name
        self.CastTrack.Size=UDim2.new(math.clamp(1-remaining/math.max(a.CastTimeSeconds,T.LegacyFX.MinBarFraction),0,1),0,0,T.Layout.Cast.Track)
    end
end
return Hud
```


## src/StarterPlayer/StarterPlayerScripts/UI/Kit.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Kit`. Create matching Folder parents.

```lua
--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local T=require(ReplicatedStorage.Shared.Theme)
local Kit={}
local soundCount=0
local lastHover=-math.huge
function Kit.New(class: string,parent: Instance?,properties: any): any
    local object=Instance.new(class)
    for key,value in pairs(properties or {}) do (object :: any)[key]=value end
    object.Parent=parent
    return object
end
function Kit.Tween(object: Instance,duration: number,properties: any): Tween
    local tween=TweenService:Create(object,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
    tween:Play();return tween
end
function Kit.Sound(parent: Instance,key: string)
    local spec=T.Sound[key]
    if not spec or spec.Id<=0 or soundCount>=T.Sound.MaxPlaying then return end
    local now=os.clock()
    if key=="Hover" then
        if now-lastHover<T.Timing.SoundHoverGap then return end
        lastHover=now
    end
    soundCount+=1
    local sound=Kit.New("Sound",parent,{SoundId="rbxassetid://"..tostring(spec.Id),Volume=spec.Volume})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();soundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Kit.Corner(parent: Instance,radius: number?)
    return Kit.New("UICorner",parent,{CornerRadius=UDim.new(0,radius or T.Style.Corner)})
end
function Kit.Stroke(parent: Instance,color: Color3?,alpha: number?)
    return Kit.New("UIStroke",parent,{Color=color or T.Colors.Gold,Thickness=T.Style.Stroke,Transparency=alpha or T.Style.BorderAlpha,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
end
function Kit.Panel(parent: Instance,name: string): Frame
    local f=Kit.New("Frame",parent,{Name=name,BorderSizePixel=0,BackgroundColor3=T.Colors.Ink,BackgroundTransparency=T.Style.PanelFade})
    Kit.Corner(f);Kit.Stroke(f)
    Kit.New("UIGradient",f,{Rotation=T.Style.PanelGradient,Color=ColorSequence.new(T.Colors.Ink,T.Colors.Ink:Lerp(T.Colors.Slate,T.Style.GradientEnd))})
    return f
end
function Kit.Text(parent: Instance,text: string,size: number?,font: Enum.Font?): TextLabel
    return Kit.New("TextLabel",parent,{BackgroundTransparency=1,BorderSizePixel=0,Text=text,TextColor3=T.Colors.Text,
        Font=font or T.Fonts.Body,TextSize=size or T.Type.Body,TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true,RichText=false})
end
function Kit.Button(parent: Instance,text: string,callback: ()->()): TextButton
    local b=Kit.New("TextButton",parent,{Text=text,BackgroundColor3=T.Colors.Slate,BorderSizePixel=0,
        TextColor3=T.Colors.Text,TextSize=T.Type.Number,Font=T.Fonts.Number,TextWrapped=true,AutoButtonColor=false})
    Kit.Corner(b);Kit.Stroke(b)
    local function enter() Kit.Sound(b,"Hover");Kit.Tween(b,T.Timing.Hover,{BackgroundColor3=T.Colors.Slate:Lerp(T.Colors.Gold,T.Style.HoverBlend)}) end
    local function leave() Kit.Tween(b,T.Timing.Return,{BackgroundColor3=T.Colors.Slate}) end
    b.MouseEnter:Connect(enter);b.SelectionGained:Connect(enter);b.MouseLeave:Connect(leave);b.SelectionLost:Connect(leave)
    b.Activated:Connect(function() Kit.Sound(b,"Click");callback() end)
    return b
end
function Kit.Padding(parent: Instance,pixels: number)
    return Kit.New("UIPadding",parent,{PaddingTop=UDim.new(0,pixels),PaddingBottom=UDim.new(0,pixels),PaddingLeft=UDim.new(0,pixels),PaddingRight=UDim.new(0,pixels)})
end
function Kit.List(parent: Instance,gap: number,horizontal: boolean?)
    return Kit.New("UIListLayout",parent,{Padding=UDim.new(0,gap),SortOrder=Enum.SortOrder.LayoutOrder,
        FillDirection=if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical})
end
function Kit.Rect(object: GuiObject,r: any)
    object.Position=UDim2.fromOffset(r.X,r.Y);object.Size=UDim2.fromOffset(r.W,r.H)
end
function Kit.Glyph(parent: Instance,kind: string,pixels: number,color: Color3?): Frame
    local f=Kit.New("Frame",parent,{Name="Glyph_"..kind,BackgroundTransparency=1,Size=UDim2.fromOffset(pixels,pixels)})
    Kit.New("UIAspectRatioConstraint",f,{AspectRatio=1})
    for _,path in ipairs(T.Glyphs[kind] or T.Glyphs.Seal) do
        for i=1,#path-1 do
            local a,b=path[i],path[i+1]
            local dx,dy=(b[1]-a[1])*pixels,(b[2]-a[2])*pixels
            Kit.New("Frame",f,{BorderSizePixel=0,BackgroundColor3=color or T.Colors.Gold,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale((a[1]+b[1])/2,(a[2]+b[2])/2),
                Size=UDim2.new(math.sqrt(dx*dx+dy*dy)/pixels,0,0,T.Style.IconStroke),Rotation=math.deg(math.atan2(dy,dx))})
        end
    end
    return f
end
function Kit.PathColor(id: any): Color3
    return if id=="Marauder" then T.Colors.Bronze elseif id=="Apprentice" then T.Colors.Teal else T.Colors.Gold
end
function Kit.Clear(parent: Instance)
    for _,child in ipairs(parent:GetChildren()) do child:Destroy() end
end
return Kit
```


## src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Menus`. Create matching Folder parents.

```lua
--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Model=require(Shared.VisualModel)
local Kit=require(script.Parent.Kit)
local Menus={}
function Menus.new(parent: Instance,data: any,callbacks: any): any
    local self: any={Data=data,Callbacks=callbacks,State=nil,Tab="Journal",SelectedSlot=1,View="Page",PreviewId=nil,Purchase=false,Waiting=false,Rows={},LastKey="",ReducedMotion=false}
    self.Root=Kit.New("Frame",parent,{Name="Menus",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false,ZIndex=T.Layers.Modal})
    self.Dim=Kit.New("TextButton",self.Root,{Name="Backdrop",Size=UDim2.fromScale(1,1),Text="",AutoButtonColor=false,BackgroundColor3=T.Colors.Ink,BackgroundTransparency=T.Style.ModalDim,BorderSizePixel=0})
    self.Dim.Activated:Connect(function() self:Close() end)
    self.Card=Kit.Panel(self.Root,"JournalCard");self.Card.Active=true
    Kit.New("UIScale",self.Card,{Scale=T.Layout.Scale})
    self.Title=Kit.Text(self.Card,"BEYONDER JOURNAL",T.Type.Heading,T.Fonts.Title)
    self.Wallet=Kit.Text(self.Card,"",T.Type.Small,T.Fonts.Number);self.Wallet.TextColor3=T.Colors.Muted
    self.CloseButton=Kit.Button(self.Card,T.Style.CloseSymbol,function() self:Close() end)
    self.Navigation=Kit.New("Frame",self.Card,{BackgroundTransparency=1})
    self.NavLayout=Kit.List(self.Navigation,T.Layout.Modal.NavGap,true)
    self.Tabs={}
    for index,tab in ipairs({"Journal","Pathway","Inventory"}) do
        local b=Kit.Button(self.Navigation,tab,function() self.Tab=tab;self.View="Page";self:Render() end);b.LayoutOrder=index
        self.Tabs[tab]=b
    end
    self.Scroll=Kit.New("ScrollingFrame",self.Card,{Name="Content",BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,
        ScrollBarImageColor3=T.Colors.Gold,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.Y})
    self.PreviewActions=Kit.New("Frame",self.Card,{Name="ConfirmationActions",BackgroundTransparency=1})
    self.Footer=Kit.Text(self.Card,"",T.Type.Micro,T.Fonts.Number);self.Footer.TextColor3=T.Colors.Muted
    return setmetatable(self,{__index=Menus})
end
function Menus.Open(self: any,tab: string?)
    self.Tab=tab or "Journal";self.View="Page";self.Purchase=false;self.Root.Visible=true;self.Waiting=false
    Kit.Sound(self.Root,"JournalOpen");self.Callbacks.Modal(true);self:Render()
end
function Menus.Close(self: any)
    if self.Purchase then self.Callbacks.Intent("CloseAltar",{}) end
    self.Root.Visible=false;self.Purchase=false;self.Waiting=false;self.Callbacks.Modal(false)
end
function Menus.Altar(self: any,expiresIn: number)
    self.Purchase=true;self.View="Preview";self.PreviewId=Model.NextPotion(self.State)
    self.ExpiresAt=os.clock()+expiresIn;self.Waiting=false;self.Root.Visible=true;self.Callbacks.Modal(true);self:Render()
end
function Menus.Preview(self: any,id: string)
    self.Purchase=false;self.View="Preview";self.PreviewId=id;self.PreviewOwned=self.State and self.State.Inventory[id];self.Waiting=false;self:Render()
end
function Menus.Resize(self: any,layout: any)
    self.Layout=layout
    local r=if self.View=="Preview" then layout.Confirm else layout.Modal
    Kit.Rect(self.Card,r)
    local m=T.Layout.Modal
    self.Title.Position=UDim2.fromOffset(m.BodyPad,0);self.Title.Size=UDim2.new(1,-m.Close-m.BodyPad*2,0,m.TitleHeight);self.Title.TextSize=layout.Profile.HeadingSize
    self.Wallet.Position=UDim2.fromOffset(m.BodyPad,m.TitleHeight);self.Wallet.Size=UDim2.new(1,-m.BodyPad*2,0,m.Header-m.TitleHeight)
    self.CloseButton.Size=UDim2.fromOffset(m.Close,m.Close);self.CloseButton.Position=UDim2.new(1,-m.Close,0,0)
    self.Navigation.Position=UDim2.fromOffset(m.BodyPad,m.Header);self.Navigation.Size=UDim2.new(1,-m.BodyPad*2,0,m.Tabs)
    for _,b in pairs(self.Tabs) do b.Size=UDim2.new(1/3,-m.NavGap,1,0);b.TextSize=layout.Profile.NumberSize end
    self.Navigation.Visible=self.View=="Page"
    self.PreviewActions.Visible=self.View=="Preview"
    self.PreviewActions.Size=UDim2.new(1,-m.BodyPad*2,0,m.ConfirmHeight);self.PreviewActions.Position=UDim2.new(0,m.BodyPad,1,-m.Footer-m.ConfirmHeight-m.Gap)
    local top=m.Header+(if self.View=="Page" then m.Tabs else 0)+m.Gap
    self.Scroll.Position=UDim2.fromOffset(m.BodyPad,top);self.Scroll.Size=UDim2.new(1,-m.BodyPad*2,1,-top-m.Footer-m.Gap-(if self.View=="Preview" then m.ConfirmHeight+m.Gap else 0))
    self.Footer.Position=UDim2.new(0,m.BodyPad,1,-m.Footer);self.Footer.Size=UDim2.new(1,-m.BodyPad*2,0,m.Footer)
end
function Menus.TextRow(self: any,text: string,heading: boolean?): TextLabel
    local l=Kit.Text(self.Scroll,text,if heading then self.Layout.Profile.HeadingSize else self.Layout.Profile.BodySize,if heading then T.Fonts.Heading else T.Fonts.Body)
    l.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,0);l.AutomaticSize=Enum.AutomaticSize.Y;l.TextYAlignment=Enum.TextYAlignment.Top
    return l
end
function Menus.ActionRow(self: any,text: string,callback: ()->()): TextButton
    local b=Kit.Button(self.Scroll,text,callback);b.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,T.Layout.Modal.ConfirmHeight)
    return b
end
function Menus.Render(self: any)
    if not self.Layout then return end
    self:Resize(self.Layout)
    local oldScroll=self.Scroll.CanvasPosition
    Kit.Clear(self.PreviewActions);Kit.Clear(self.Scroll);Kit.List(self.Scroll,T.Layout.Modal.Gap);self.Rows={}
    self.Title.Text=if self.View=="Preview" then (if self.Purchase then "POTION ALTAR" else "POTION RITUAL") else "BEYONDER "..string.upper(self.Tab)
    self.Footer.Text=if self.View=="Preview" then "The altar seals only what you confirm." else "B · close journal"
    for name,b in pairs(self.Tabs) do
        b.BackgroundColor3=if name==self.Tab then T.Colors.Ink:Lerp(T.Colors.Gold,T.Style.HoverBlend) else T.Colors.Slate
        b.TextColor3=if name==self.Tab then T.Colors.Gold else T.Colors.Text
    end
    local state=self.State
    if not state or not state.Ready then self:TextRow("Your journal is opening…");return end
    if self.View=="Preview" then
        local view=Model.Potion(self.Data,state,self.PreviewId,self.Purchase)
        local potion=view.Potion
        if potion then
            local row=Kit.New("Frame",self.Scroll,{Size=UDim2.new(1,0,0,T.Layout.Modal.Bottle),BackgroundTransparency=1})
            Kit.Glyph(row,"Bottle",T.Layout.Modal.Bottle,Kit.PathColor(potion.PathwayId))
            local title=Kit.Text(row,potion.Name,self.Layout.Profile.HeadingSize,T.Fonts.Heading)
            title.Position=UDim2.fromOffset(T.Layout.Modal.Bottle+T.Layout.Modal.Gap,0);title.Size=UDim2.new(1,-T.Layout.Modal.Bottle-T.Layout.Modal.Gap,1,0)
            self:TextRow(potion.PathwayId.." · "..(if potion.TargetSequence==9 then "Uninitiated → 9" else tostring(potion.RequiredSequence).." → "..tostring(potion.TargetSequence)))
            self:TextRow("Required digestion: "..potion.RequiredDigestion.."%  ·  Yours: "..string.format("%.1f%%",state.Digestion))
            self:TextRow("Owned: "..view.Owned..(if self.Purchase then "  ·  Price: "..view.Cost.." gold" else "  ·  Drinking consumes one potion"))
        end
        self.PreviewReason=self:TextRow(view.Reason)
        self.Confirm=Kit.Button(self.PreviewActions,if self.Purchase then "Confirm purchase" else "Confirm drinking",function()
            local current=Model.Potion(self.Data,self.State,self.PreviewId,self.Purchase)
            if not current.Allowed or self.Waiting or (self.Purchase and os.clock()>(self.ExpiresAt or 0)) then Kit.Sound(self.Root,"Reject");return end
            self.Waiting=true
            self.Callbacks.Intent(if self.Purchase then "Buy" else "Drink",if self.Purchase then {} else {Id=self.PreviewId})
            self.PendingSince=os.clock();self:UpdatePreview()
        end)
        local cancel=Kit.Button(self.PreviewActions,"Cancel",function()
            if self.Purchase then self:Close() else self.View="Page";self.Tab="Inventory";self:Render() end
        end)
        Kit.List(self.PreviewActions,T.Layout.Modal.Gap,true)
        self.Confirm.Size=UDim2.new(0.5,-T.Layout.Modal.Gap/2,1,0);cancel.Size=self.Confirm.Size
        self:UpdatePreview()
    elseif self.Tab=="Journal" then
        self:TextRow("The acting method",true)
        if state.PathwayId then
            local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
            self:TextRow(seq.ActingObjectives[1].Label)
            self:TextRow(string.format("Digestion %.1f%% · Acting progress %d",state.Digestion,state.ActingProgress))
        else self:TextRow("Choose one starter potion in Inventory. Its pathway becomes your permanent path.") end
        self:TextRow("Choose a slot, then select an ability below.")
        local slots=Kit.New("ScrollingFrame",self.Scroll,{Name="SlotPicker",Size=UDim2.new(1,0,0,T.Layout.Modal.SlotHeight),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
            ScrollingDirection=Enum.ScrollingDirection.X,BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,ScrollBarImageColor3=T.Colors.Gold})
        Kit.List(slots,T.Layout.Modal.NavGap,true)
        for i=1,T.Layout.Hotbar.Slots do
            local b=Kit.Button(slots,tostring(i),function() self.SelectedSlot=i;self:Render() end)
            b.Size=UDim2.fromOffset(T.Layout.Modal.SlotHeight,T.Layout.Modal.SlotHeight);b.LayoutOrder=i
            if self.SelectedSlot==i then b.BackgroundColor3=T.Colors.Ink:Lerp(T.Colors.Gold,T.Style.HoverBlend) end
        end
        for _,id in ipairs(Model.Unlocked(self.Data,state)) do
            local ability=self.Data.Abilities[id]
            local b=self:ActionRow("",function() self.Callbacks.Intent("Equip",{Id=id,Slot=self.SelectedSlot}) end)
            b.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,T.Layout.Modal.AbilityRow)
            local glyph=Kit.Glyph(b,T.OperationGlyph[ability.Operation.Kind],T.Layout.Modal.Icon,Kit.PathColor(ability.PathwayId));glyph.Position=UDim2.fromOffset(T.Layout.Modal.Gap,T.Layout.Modal.Gap)
            local text=Kit.Text(b,ability.Name,self.Layout.Profile.BodySize,T.Fonts.Heading)
            local x=T.Layout.Modal.Icon+T.Layout.Modal.Gap*2
            text.Position=UDim2.fromOffset(x,0);text.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,T.Layout.Modal.AbilityRow-T.Layout.Modal.Footer)
            local info=Kit.Text(b,"Seq "..ability.UnlockSequence.." · "..ability.SpiritualityCost.." spirit · "..ability.CooldownSeconds.."s",T.Type.Micro,T.Fonts.Number)
            info.Position=UDim2.new(0,x,1,-T.Layout.Modal.Footer);info.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,T.Layout.Modal.Footer);info.TextColor3=T.Colors.Muted
        end
        self:ActionRow("Reduced motion: "..(if self.ReducedMotion then "on" else "off"),function()
            self.ReducedMotion=not self.ReducedMotion;self.Callbacks.ReducedMotion(self.ReducedMotion);self:Render()
        end)
    elseif self.Tab=="Pathway" then
        if state.PathwayId then
            local path=self.Data.Pathways[state.PathwayId];local seq=path.Sequences[state.Sequence]
            self:TextRow(path.Name.." / "..path.Alias,true);self:TextRow("Sequence "..state.Sequence.." — "..seq.Name,true)
            self:TextRow(seq.ActingObjectives[1].Label)
            for _,key in ipairs({"Health","Spirituality","Strength","Agility","Perception","Intuition","Resistance"}) do
                self:TextRow(key.."   "..tostring(seq.BaseStats[key]))
            end
            self:TextRow("Earlier abilities remain available in your journal.")
        else
            self:TextRow("Three paths into the unknown",true)
            for _,id in ipairs({"Seer","Marauder","Apprentice"}) do
                local path=self.Data.Pathways[id]
                self:TextRow(path.Name.." / "..path.Alias,true)
                self:TextRow("Begins at Sequence 9: "..path.Sequences[9].Name)
            end
            self:ActionRow("Choose a starter potion",function() self.Tab="Inventory";self:Render() end)
        end
    else
        self:TextRow("Potion inventory",true)
        local ids={}
        for id,n in pairs(state.Inventory) do if n>0 and self.Data.Potions.ById[id] then table.insert(ids,id) end end
        table.sort(ids)
        for _,id in ipairs(ids) do
            local potion=self.Data.Potions.ById[id]
            self:ActionRow(potion.Name.."  ×"..state.Inventory[id],function() self:Preview(id) end)
        end
        if #ids==0 then self:TextRow("No potions carried. Visit the Potion Altar for your next formula.") end
        self:TextRow("The Potion Altar exchanges earned gold for your next potion. Stabilization restores sanity at a digestion cost.")
    end
    task.defer(function() if self.Scroll.Parent then self.Scroll.CanvasPosition=oldScroll end end)
end
function Menus.UpdatePreview(self: any)
    if self.View~="Preview" or not self.Confirm or not self.Confirm.Parent then return end
    local view=Model.Potion(self.Data,self.State,self.PreviewId,self.Purchase)
    local expired=self.Purchase and os.clock()>(self.ExpiresAt or 0)
    local allowed=view.Allowed and not expired and not self.Waiting
    self.Confirm.Text=if self.Waiting then "Confirming…" elseif self.Purchase then "Confirm · "..tostring(self.Data.Runtime.NextPotionGoldCost).." gold" else "Drink potion"
    self.Confirm.TextColor3=if allowed then T.Colors.Text else T.Colors.Muted
    self.Confirm.Interactable=allowed
    self.PreviewReason.Text=if expired then "The altar invitation has expired. Approach it again." else view.Reason
end
function Menus.Update(self: any,state: any)
    self.State=state
    if not state or not state.Ready then return end
    self.Wallet.Text="Gold "..state.Gold.."   ·   Wish credits "..state.WishCredits
    local inventory={}
    for id,n in pairs(state.Inventory) do table.insert(inventory,id..":"..n) end
    table.sort(inventory)
    local loadout={}
    for i=1,T.Layout.Hotbar.Slots do loadout[i]=state.Loadout[i] or "-" end
    local keys={tostring(state.PathwayId),tostring(state.Sequence),table.concat(inventory,","),table.concat(loadout,"|")}
    local key=table.concat(keys,";")
    if self.Root.Visible then
        if self.View=="Preview" then
            self:UpdatePreview()
            if self.Waiting and not self.Purchase and state.Inventory[self.PreviewId]~=(self.PreviewOwned or state.Inventory[self.PreviewId]) then self:Close() end
        elseif key~=self.LastKey then self:Render() end
    end
    self.LastKey=key
end
function Menus.Step(self: any,now: number)
    if self.Root.Visible and self.View=="Preview" then
        self:UpdatePreview()
        if self.Waiting and self.Purchase and now-(self.PendingSince or now)>T.Timing.PurchaseResponseTimeout then
            self.Waiting=false;self.ExpiresAt=now-T.LegacyFX.MinBarFraction;self:UpdatePreview()
        end
        if self.Waiting and not self.Purchase and now-(self.PendingSince or now)>T.Timing.AltarClientTimeout then
            self.Waiting=false;self:UpdatePreview()
        end
    end
end
return Menus
```


## src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Presentation`. Create matching Folder parents.

```lua
--!strict
-- Keeps the existing pooled cosmetics working; pathway VFX redesign belongs to Phase 4.
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Kit)
local Presentation={}
function Presentation.new(gui: Instance,data: any): any
    local folder=Kit.New("Folder",workspace,{Name="LocalMysteriesFX"})
    return setmetatable({GUI=gui,Data=data,Folder=folder,Pool={},Active=0,Highlights={},HighlightPool={},HighlightCount=0,SoundCount=0},{__index=Presentation})
end
function Presentation.Audio(self: any,hook: string,pitch: number?)
    local id=T.Sound.Abilities[hook]
    if type(id)~="number" or id<=0 or self.SoundCount>=T.Sound.MaxPlaying then return end
    self.SoundCount+=1
    local sound=Kit.New("Sound",self.GUI,{SoundId="rbxassetid://"..tostring(math.floor(id)),Volume=T.Sound.AbilityVolume,PlaybackSpeed=math.clamp(pitch or T.LegacyFX.Pitch,T.Sound.MinPitch,T.Sound.MaxPitch)})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();self.SoundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Presentation.Event(self: any,event: any)
    if event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch);return end
    local ability=self.Data.Abilities[event.Kind]
    if ability then self:Audio(ability.SFXHook) end
    if event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        if self.Highlights[event.Target] or self.HighlightCount>=T.LegacyFX.Max then return end
        local highlight=table.remove(self.HighlightPool) or Instance.new("Highlight")
        self.Highlights[event.Target]=highlight;self.HighlightCount+=1
        highlight.Adornee=event.Target;highlight.FillColor=T.Colors.Sanity;highlight.OutlineColor=T.Colors.Fog
        highlight.FillTransparency=T.LegacyFX.HighlightAlpha;highlight.Parent=self.Folder;highlight.Enabled=true
        task.delay(T.Timing.Reveal,function()
            self.Highlights[event.Target]=nil;self.HighlightCount-=1
            highlight.Enabled=false;highlight.Adornee=nil;highlight.Parent=nil;table.insert(self.HighlightPool,highlight)
        end)
    elseif event.Kind~="Whisper" and self.Active<T.LegacyFX.Max then
        local p: Part=table.remove(self.Pool) or Instance.new("Part")
        p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Shape=Enum.PartType.Ball;p.Material=Enum.Material.Neon
        p.Size=Vector3.one*T.LegacyFX.StartSize;p.Position=event.Position;p.Transparency=T.LegacyFX.Alpha
        p.Color=if ability then Kit.PathColor(ability.PathwayId) else T.Colors.Fog
        self.Active+=1;p.Parent=self.Folder
        local tween=Kit.Tween(p,T.Timing.Pulse,{Size=Vector3.one*T.LegacyFX.EndSize,Transparency=1})
        tween.Completed:Once(function() self.Active-=1;p.Parent=nil;table.insert(self.Pool,p) end)
    end
end
return Presentation
```


## src/StarterPlayer/StarterPlayerScripts/UI/Prompts.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Prompts`. Create matching Folder parents.

```lua
--!strict
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Layout=require(Shared.VisualLayout)
local Kit=require(script.Parent.Kit)
local Prompts={}
local function position(prompt: ProximityPrompt): Vector3?
    local parent=prompt.Parent
    if not parent then return nil end
    if parent:IsA("Attachment") then return parent.WorldPosition end
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Model") then return parent:GetPivot().Position end
    return nil
end
function Prompts.new(parent: GuiObject): any
    local self: any={SafeRoot=parent,Current=nil,Layout=nil,Modal=false,Hold=nil,RenderConnection=nil,LegacyLabels={},Suppressed={}}
    self.Root=Kit.New("Frame",parent,{Name="ObjectPrompt",BackgroundTransparency=1,Visible=false,ZIndex=T.Layers.Prompt})
    self.Button=Kit.Button(self.Root,"",function() end);self.Button.Size=UDim2.fromScale(1,1)
    self.Badge=Kit.Panel(self.Button,"InputBadge")
    self.Key=Kit.Text(self.Badge,"E",T.Type.Small,T.Fonts.Number);self.Key.Size=UDim2.fromScale(1,1);self.Key.TextXAlignment=Enum.TextXAlignment.Center
    self.Action=Kit.Text(self.Button,"Interact",T.Type.Small,T.Fonts.Number)
    self.Object=Kit.Text(self.Button,"",T.Type.Micro);self.Object.TextColor3=T.Colors.Muted
    self.Fill=Kit.New("Frame",self.Button,{BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,Position=UDim2.fromScale(0,1),AnchorPoint=Vector2.new(0,1)})
    local p=T.Layout.Prompt
    self.Root.Size=UDim2.fromOffset(p.Width,p.Height)
    self.Badge.Position=UDim2.fromOffset(p.Pad,(p.Height-p.Icon)/2);self.Badge.Size=UDim2.fromOffset(p.Icon,p.Icon)
    self.Action.Position=UDim2.fromOffset(p.TextX,p.Pad/2);self.Action.Size=UDim2.new(1,-p.TextX-p.Pad,0,p.ActionHeight)
    self.Object.Position=UDim2.fromOffset(p.TextX,p.ActionHeight+p.Pad/2);self.Object.Size=UDim2.new(1,-p.TextX-p.Pad,0,p.ObjectHeight)
    self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
    local function track(object: Instance)
        if object:IsA("ProximityPrompt") then object.Style=Enum.ProximityPromptStyle.Custom
        elseif object:IsA("BillboardGui") then
            self.LegacyLabels[object]=true
            if self.Root.Visible then self.Suppressed[object]=object.Enabled;object.Enabled=false end
        end
    end
    for _,object in ipairs(workspace:GetDescendants()) do track(object) end
    workspace.DescendantAdded:Connect(track)
    workspace.DescendantRemoving:Connect(function(object) self.LegacyLabels[object]=nil;self.Suppressed[object]=nil end)
    ProximityPromptService.MaxPromptsVisible=p.MaxVisible
    ProximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt,inputType: Enum.ProximityPromptInputType)
        if self.Modal then return end
        self:Hide();self.Current=prompt
        self.Action.Text=if prompt:GetAttribute("InteractionId")=="Buy" then "Open potion altar" else prompt.ActionText
        self.Object.Text=prompt.ObjectText
        self.Key.Text=if inputType==Enum.ProximityPromptInputType.Touch then "Tap" elseif inputType==Enum.ProximityPromptInputType.Gamepad then string.gsub(prompt.GamepadKeyCode.Name,"Button","") else prompt.KeyboardKeyCode.Name
        self.RenderConnection=RunService.RenderStepped:Connect(function() self:Project() end)
        self:Project()
    end)
    ProximityPromptService.PromptHidden:Connect(function(prompt) if self.Current==prompt then self:Hide() end end)
    ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if self.Current~=prompt then return end
        if self.Hold then self.Hold:Cancel() end
        self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
        self.Hold=Kit.Tween(self.Fill,prompt.HoldDuration,{Size=UDim2.new(1,0,0,p.HoldHeight)})
    end)
    ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt)
        if self.Current==prompt then
            if self.Hold then self.Hold:Cancel();self.Hold=nil end
            self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
        end
    end)
    self.Button.InputBegan:Connect(function(input)
        if self.Current and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then self.Current:InputHoldBegin() end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if self.Current and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then self.Current:InputHoldEnd() end
    end)
    return setmetatable(self,{__index=Prompts})
end
function Prompts.Suppress(self: any,visible: boolean)
    -- Phase 1 avoids prompt/sign collisions. Phase 2 replaces these legacy signs properly.
    if visible then
        for label in pairs(self.LegacyLabels) do
            if label.Parent and self.Suppressed[label]==nil then self.Suppressed[label]=label.Enabled;label.Enabled=false end
        end
    else
        for label,enabled in pairs(self.Suppressed) do if label.Parent then label.Enabled=enabled end end
        table.clear(self.Suppressed)
    end
end
function Prompts.Show(self: any,visible: boolean)
    self.Root.Visible=visible
    if self.OnVisibility then self.OnVisibility(visible) end
    self:Suppress(visible)
end
function Prompts.Hide(self: any)
    local previous=self.Current;self.Current=nil
    if previous then previous:InputHoldEnd() end
    if self.RenderConnection then self.RenderConnection:Disconnect();self.RenderConnection=nil end
    if self.Hold then self.Hold:Cancel();self.Hold=nil end
    self.Current=nil;self:Show(false)
end
function Prompts.SetModal(self: any,open: boolean)
    self.Modal=open
    ProximityPromptService.Enabled=not open
    if open then self:Hide() end
end
function Prompts.Project(self: any)
    local prompt=self.Current;local camera=workspace.CurrentCamera
    local root=Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local world=prompt and position(prompt)
    if self.Modal or not prompt or not prompt.Parent or not prompt.Enabled or not camera or not root or not root:IsA("BasePart") or not world then
        self:Show(false);return
    end
    local screen,onScreen=camera:WorldToViewportPoint(world)
    if not onScreen or (root.Position-world).Magnitude>prompt.MaxActivationDistance then self:Show(false);return end
    local p=T.Layout.Prompt
    local origin=self.SafeRoot.AbsolutePosition
    local x,y=screen.X-origin.X,screen.Y-origin.Y
    local size=self.SafeRoot.AbsoluteSize
    -- Interactions outrank the optional pathway/masthead, which can temporarily yield space.
    self:Show(true)
    local candidates={{x+p.OffsetX,y+p.OffsetY},{x-p.Width-p.OffsetX,y+p.OffsetY},{x-p.Width/2,y-p.Height+p.OffsetY}}
    if self.Layout then table.insert(candidates,{(size.X-p.Width)/2,self.Layout.Hotbar.Y-p.Height-p.Edge}) end
    local chosen=nil
    for _,candidate in ipairs(candidates) do
        local r={X=math.clamp(candidate[1],p.Edge,math.max(p.Edge,size.X-p.Width-p.Edge)),Y=math.clamp(candidate[2],p.Edge,math.max(p.Edge,size.Y-p.Height-p.Edge)),W=p.Width,H=p.Height}
        local blocked=false
        if self.Layout then
            for _,other in ipairs({self.Layout.Resources,self.Layout.Hotbar,self.Layout.Journal,self.Layout.Wordmark}) do
                if Layout.Intersects(r,other,p.Edge) then blocked=true;break end
            end
            for _,object in ipairs(self.Exclusions or {}) do
                if object.Visible and object.Parent then
                    local pos=object.AbsolutePosition-self.SafeRoot.AbsolutePosition
                    local bounds=object.AbsoluteSize
                    if Layout.Intersects(r,{X=pos.X,Y=pos.Y,W=bounds.X,H=bounds.Y},p.Edge) then blocked=true;break end
                end
            end
        end
        if not blocked then chosen=r;break end
    end
    if chosen then Kit.Rect(self.Root,chosen) end
    self:Show(chosen~=nil)
end
return Prompts
```


## default.project.json

```json
{
  "name": "MysteriesFoundation",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "Shared": {
        "$path": "src/ReplicatedStorage/Shared"
      }
    },
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "$path": "src/ServerScriptService"
    },
    "StarterPlayer": {
      "$className": "StarterPlayer",
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "$path": "src/StarterPlayer/StarterPlayerScripts"
      }
    },
    "StarterGui": {
      "$className": "StarterGui",
      "$path": "src/StarterGui"
    }
  }
}
```
