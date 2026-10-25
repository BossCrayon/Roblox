# Full source — Mysteries Roblox foundation

# Mysteries — playable Roblox foundation

> **[EXISTING] Through Phase I:** all **54** dedicated ability packages plus pathway HUD/Journal skins, confirmed potion/acting feedback, a larger Victorian sanctuary and six arenas, tiered R6/R15 outfits, six original enemy silhouettes/health widgets, scheduled threat cues, local atmosphere/lighting/labels and an authorized Studio stress harness. [Full source, classes and exact Explorer paths](docs/PHASE_FI_VISUALS_CODE.md) · [Phase F–I scope, Studio checklist and exact captures](docs/PHASE_FI_VISUALS.md). **[PROPOSED]** Rendered acceptance and measured device performance still need Studio; implementation is complete through I.

> **Admin powers:** `johnskie816` is configured in the server allowlist. Click **ADMIN**, choose a pathway and Sequence 9–1, then **Apply pathway & sequence**. [Setup, behavior and Studio checks](docs/ADMIN_POWERS.md). Published-server selections save to your profile; Studio session-only selections reset when you stop Play.

> **Animation/VFX — Phase A:** bounded client pools, 12 procedural animations, 11 reusable effect blocks, quality/120-stud LOD, reduced motion, low graphics and an authorized F8 Studio preview room. Phases B–E reuse these and add pooled stencil, card, paper, veil and contour compositions. [Framework code and script destinations](docs/PHASE_A_VFX_CODE.md) · [Numeric properties and framework tests](docs/PHASE_A_VFX.md).

> **Visual overhaul — Phase 1:** the current build includes a themed HUD, Journal/Pathway/Inventory tabs, confirmation-based potion UI, custom prompts, feedback and authorized developer diagnostics. [Full copy-ready code and script destinations](docs/PHASE1_UI_CODE.md) · [Studio checklist and exact screenshot requests](docs/PHASE1_UI.md). The F–I pass now includes world relayout, local landmark labels and zone cards.

The six requested implementation phases are represented in this project: data, server progression/persistence, all 54 selected ability executors across Sequences 9–1, HUD/input, procedural NPCs/world, and a first balance pass. The roster remains **Seer/Fool, Marauder/Error, and Apprentice/Door only**, with no Sequence 0.

This is a playable foundation with bounded gameplay interpretations of the powers, not an exhaustive recreation of every canonical technique. All lore claims remain `[UNVERIFIED]` because source access was blocked. Audio hooks await original sound assets; disguises use original face masks, color/identity changes and R15 body scaling rather than arbitrary species or live voice cloning. See `docs/LORE_REVIEW.md`.

## Open and play

1. Download **[studio/Mysteries.rbxlx](studio/Mysteries.rbxlx)** using GitHub's **Download raw file**, open it in desktop **Roblox Studio → File → Open from File**, and press **Play**. The server generates the sanctuary, potion altar, archives, practice doors, flame anchors, six arenas, and 18 procedural enemies. The client creates its HUD in PlayerGui from modules under StarterPlayerScripts/UI.
2. Open the **journal [B]**, drink one of the three starter potions, and aim at nearby enemies or ground when using abilities.
3. Use **Q, E, R, F, Z, X** for the six equipped abilities. **Left click** is a basic strike. Touch users have hotbar, journal, and strike buttons; touch targeting uses the center of the camera.
4. In the journal select a numbered slot, then select an unlocked ability to equip it. Earlier powers remain available as sequence numbers decrease.

Studio defaults to **session-only storage**, with storage diagnostics restricted to the authorized F8 developer panel. No Studio API access is required for that demo and progress does not survive the server closing. Published servers always use real DataStoreService; they never silently fall back to volatile storage.

The **ADMIN button** and **F8 shortcut** open pathway/sequence controls for the individual creator or a server-allowlisted account. `johnskie816` is configured by username and resolved to its numeric ID on the Roblox server; explicit numeric IDs also work. The server validates every change. The VFX test-room button remains Studio-only. See [admin setup](docs/ADMIN_POWERS.md).

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
- **701 executor/target assertions:** all 54 abilities across 28 handlers, with the production visual-event adapter and unchanged ownership/range/visibility checks, limited loot/recordings, safe teleports, damage decisions, substitutes, graft reflections and resistance. Roblox engine dependencies are mocked.
- **299 UI assertions:** responsive geometry, confirmation/cancellation, prompt lifecycle, role/admin controls, stored-power badge and synchronized cast-bar lifecycle with engine stand-ins.
- **572 admin progression assertions:** authorization denial, malformed inputs, all 27 pathway/sequence choices, valid loadouts/stats, persistence compatibility and cleanup bookkeeping.
- Animation/VFX assertions cover atomic budgets, seven pooled classes, culling/quality, all eleven blocks, animation blending/cleanup, camera caps/restoration and server-confirmed death presentation with engine stand-ins.
- **1,336 ability/status assertions:** all 54 dedicated recipes at three qualities with/without Reduced Motion, mobile packages, atomic multi-anchor admission/culling, private reveals/statuses, monotonic tokens, cancellation/stale-event rejection, bounded status labels, gate fallback/cleanup and late-join gate/echo snapshots. [Details](docs/PHASE_CDE_VFX.md).
- **1,476 F–I assertions:** native world construction/bounds/tags, all R6/R15 outfit choices and disguise cleanup, six enemy silhouettes/health pools, unchanged threat clocks, local lighting/labels/accessibility and actual stress overfill/drain adapters.
- **11,114 assertions total**, followed by compilation of **68 Luau files** and source verification of **54 ModuleScripts, one Script and one LocalScript** in the built place.
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


## src/ReplicatedStorage/Shared/AnimConfig.lua

**ModuleScript** at `ReplicatedStorage/Shared/AnimConfig`. Create matching Folder parents.

```lua
--!strict
-- Original, asset-free animation library. Optional uploaded assets override each entry.
-- Degrees and studs below describe rendered joints only; no root physics are changed.
local freeze=require(script.Parent.Freeze)
local T=require(script.Parent.Theme)
local MotionTracks=require(script.Parent.MotionTracks)
type Pose={[string]: CFrame}
local function frame(y: number,pitch: number,yaw: number,roll: number): CFrame
    return CFrame.new(0,y,0)*CFrame.Angles(math.rad(pitch),math.rad(yaw),math.rad(roll))
end
local function still(entry: any,_time: number,_speed: number): Pose
    local result: Pose={}
    for role,value in pairs(entry.Pose) do result[role]=frame(value[1],value[2],value[3],value[4]) end
    return result
end
local function lerpPose(a: any,b: any,t: number): Pose
    local result: Pose={}
    for role,va in pairs(a) do
        local vb=b and b[role] or {0,0,0,0}
        result[role]=frame(va[1]+(vb[1]-va[1])*t,va[2]+(vb[2]-va[2])*t,va[3]+(vb[3]-va[3])*t,va[4]+(vb[4]-va[4])*t)
    end
    return result
end
local function releaseCurve(entry: any,time: number,_speed: number): Pose
    if not entry.FollowPose then return still(entry,time,_speed) end
    local progress=math.clamp(time/math.max(0.01,entry.Duration),0,1)
    local beat=T.Choreography
    if entry.AnticipationPose and progress<beat.ReleaseStrike then
        local t=progress/beat.ReleaseStrike
        return lerpPose(entry.AnticipationPose,entry.Pose,t*t)
    elseif progress<beat.FollowEnd then
        local t=if entry.AnticipationPose then (progress-beat.ReleaseStrike)/(beat.FollowEnd-beat.ReleaseStrike) else progress/beat.FollowEnd
        return lerpPose(entry.Pose,entry.FollowPose,1-(1-t)^3)
    end
    local recovery=(progress-beat.FollowEnd)/(1-beat.FollowEnd)
    return lerpPose(entry.FollowPose,entry.RecoveryPose or {
        Root={0,0,0,0},Waist={0,0,0,0},Neck={0,0,0,0},LeftShoulder={0,0,0,0},RightShoulder={0,0,0,0},LeftHip={0,0,0,0},RightHip={0,0,0,0},
    },recovery*beat.Recovery)
end
local function windupCurve(entry: any,time: number,_speed: number): Pose
    local gain=T.Choreography.WindupStart+(1-T.Choreography.WindupStart)*math.min(1,time/T.Choreography.WindupSnap)
    local result: Pose={}
    for role,value in pairs(entry.Pose) do
        result[role]=frame(value[1]*gain,value[2]*gain,value[3]*gain,value[4]*gain)
    end
    return result
end
local function breathe(entry: any,time: number,_speed: number): Pose
    local wave=math.sin(time*math.pi*2/entry.Period)
    return {Root=frame(wave*entry.Rise,0,0,0),Waist=frame(0,wave*0.35,0,0),Neck=frame(0,wave*entry.Nod,0,0)}
end
local function locomotion(entry: any,time: number,speed: number): Pose
    local wave=math.sin(time*math.pi*2/entry.Period)
    return {Root=frame(0,entry.Lean*speed,0,wave*entry.Sway*speed),
        Waist=frame(0,entry.Lean*0.35*speed,-wave*entry.Sway*0.6*speed,0),
        Neck=frame(0,-entry.Lean*entry.CounterLean*speed,0,0)}
end
local function roll(entry: any,time: number,_speed: number): Pose
    local progress=math.clamp(time/entry.Duration,0,1)
    -- A compact torso tuck, rather than a root-part rotation or a movement grant.
    local arc=math.sin(progress*math.pi)
    return {Root=frame(-entry.Tuck*arc,entry.Pitch*arc,0,entry.Roll*arc),
        Waist=frame(0,entry.Pitch*0.3*arc,0,entry.Roll*0.25*arc),
        LeftShoulder=frame(0,entry.ArmPitch*arc,0,0),RightShoulder=frame(0,entry.ArmPitch*arc,0,0)}
end
local function pose7(root,waist,neck,leftArm,rightArm,leftHip,rightHip)
    return {
        Root=root,
        Waist=waist or {0,0,0,0},
        Neck=neck or {0,0,0,0},
        LeftShoulder=leftArm,
        RightShoulder=rightArm,
        LeftHip=leftHip or {0,0,0,0},
        RightHip=rightHip or {0,0,0,0},
    }
end
local config: any={
    Spring={Frequency=8,MaxStep=0.1},
    Blend={Default=0.12,MinFade=0.016,MaxFade=2,WeightEpsilon=0.001,MaxWeight=1,ReducedScale=0.3},
    Locomotion={MinSpeed=0.1,RunSpeed=14,SpeedReference=16,MaxSpeedRatio=1.5,LandingVelocity=-3},
    Safety={MaxPause=0.08,MaxFrameDelta=0.1,AssetLoadGrace=1.5,MaxAssetSpeed=2,MinAssetSpeed=0.1},
    CastProfiles={
        Potion={CastRelease={AnimationId="",Duration=T.Ritual.DrinkTime,Pose=pose7(
            {0,-3,0,0},{0,-2,0,0},{0,-10,0,0},{0,-16,0,-8},{0,-112,0,12},{0,-2,0,0},{0,2,0,0}
        )}},
        MeleeRight={
            CastRelease={
                AnimationId="",Duration=0.40,Procedural=releaseCurve,
                AnticipationPose=pose7({-0.05,6,-24,-4},{0,5,-18,-3},{0,-4,18,0},{0,-28,14,-14},{0,-92,-28,28},{0,-12,0,0},{0,12,0,0}),
                Pose=pose7({0.03,-8,26,4},{0,-6,22,4},{0,4,-18,0},{0,18,-12,-18},{0,-58,28,-22},{0,12,0,0},{0,-12,0,0}),
                FollowPose=pose7({-0.02,-4,32,3},{0,-4,26,2},{0,2,-22,0},{0,24,-16,-20},{0,-32,38,-30},{0,8,0,0},{0,-8,0,0}),
            },
        },
        MeleeLeft={
            CastRelease={
                AnimationId="",Duration=0.40,Procedural=releaseCurve,
                AnticipationPose=pose7({-0.05,6,24,4},{0,5,18,3},{0,-4,-18,0},{0,-92,28,-28},{0,-28,-14,14},{0,12,0,0},{0,-12,0,0}),
                Pose=pose7({0.03,-8,-26,-4},{0,-6,-22,-4},{0,4,18,0},{0,-58,-28,22},{0,18,12,18},{0,-12,0,0},{0,12,0,0}),
                FollowPose=pose7({-0.02,-4,-32,-3},{0,-4,-26,-2},{0,2,22,0},{0,-32,-38,30},{0,24,16,20},{0,-8,0,0},{0,8,0,0}),
            },
        },
        UltimateSeer={
            CastRelease={
                AnimationId="",Duration=0.62,Procedural=releaseCurve,
                AnticipationPose=pose7({-0.06,8,0,0},{0,6,0,0},{0,-10,0,0},{0,-54,24,-12},{0,-54,-24,12},{0,-8,0,0},{0,8,0,0}),
                Pose=pose7({0.06,-10,0,0},{0,-8,0,0},{0,14,0,0},{0,-108,-22,-34},{0,-108,22,34},{0,6,0,0},{0,-6,0,0}),
                FollowPose=pose7({0.02,-4,0,0},{0,-3,0,0},{0,6,0,0},{0,-76,-18,-26},{0,-76,18,26},{0,4,0,0},{0,-4,0,0}),
            },
        },
        UltimateMarauder={
            CastRelease={
                AnimationId="",Duration=0.62,Procedural=releaseCurve,
                AnticipationPose=pose7({-0.05,6,-14,-4},{0,5,-10,-3},{0,-6,10,0},{0,-68,16,-14},{0,-84,-18,20},{0,-8,0,0},{0,8,0,0}),
                Pose=pose7({0.05,-8,14,4},{0,-6,10,3},{0,8,-10,0},{0,-96,-14,-24},{0,-112,18,32},{0,8,0,0},{0,-8,0,0}),
                FollowPose=pose7({0.02,-4,6,2},{0,-3,4,0},{0,4,-4,0},{0,-64,-12,-18},{0,-82,14,22},{0,4,0,0},{0,-4,0,0}),
            },
        },
        UltimateApprentice={
            CastRelease={
                AnimationId="",Duration=0.62,Procedural=releaseCurve,
                AnticipationPose=pose7({-0.04,6,0,0},{0,5,0,0},{0,-8,0,0},{0,-64,20,-16},{0,-64,-20,16},{0,-6,0,0},{0,6,0,0}),
                Pose=pose7({0.06,-8,0,0},{0,-6,0,0},{0,12,0,0},{0,-102,-24,-36},{0,-102,24,36},{0,8,0,0},{0,-8,0,0}),
                FollowPose=pose7({0.02,-3,0,0},{0,-2,0,0},{0,4,0,0},{0,-74,-18,-28},{0,-74,18,28},{0,4,0,0},{0,-4,0,0}),
            },
        },
        Pickpocket={
            CastWindup={AnimationId="",Pose=pose7({0,4,9,-3},{0,3,6,-2},{0,-2,-6,0},{0,-14,4,-8},{0,-48,-8,12},{0,-8,0,0},{0,8,0,0})},
            CastRelease={AnimationId="",Duration=0.16,Pose=pose7({0,-2,-6,0},{0,-2,-4,0},{0,2,4,0},{0,-10,0,-6},{0,-24,-16,6},{0,4,0,0},{0,-4,0,0})},
        },
        Travel={
            CastWindup={AnimationId="",Pose=pose7({0,0,0,0},{0,2,0,0},{0,-2,0,0},{0,-52,-8,-16},{0,-52,8,16},{0,-6,0,0},{0,6,0,0})},
            CastRelease={AnimationId="",Duration=0.20,Pose=pose7({0,2,0,0},{0,-3,0,0},{0,3,0,0},{0,-65,-8,-26},{0,-65,8,26},{0,8,0,0},{0,-8,0,0})},
        },
        Reading={
            CastWindup={AnimationId="",Pose=pose7({0,0,0,0},{0,-2,-3,0},{0,-3,0,0},{0,-20,0,-12},{0,-72,0,14},{0,-3,0,0},{0,3,0,0})},
            CastRelease={AnimationId="",Duration=0.18,Pose=pose7({0,1,3,0},{0,2,3,0},{0,-2,0,0},{0,-26,-6,-14},{0,-55,0,20},{0,3,0,0},{0,-3,0,0})},
        },
        Flame={
            CastWindup={AnimationId="",Pose=pose7({0,-4,-12,0},{0,4,-8,0},{0,-3,8,0},{0,-22,0,-8},{0,-40,10,20},{0,-8,0,0},{0,8,0,0})},
            CastRelease={AnimationId="",Duration=0.18,Pose=pose7({0,5,9,0},{0,-4,8,0},{0,5,-6,0},{0,-34,-8,-16},{0,-68,0,30},{0,6,0,0},{0,-6,0,0})},
        },
        Theft={
            CastWindup={AnimationId="",Pose=pose7({0,4,9,-3},{0,4,8,-2},{0,0,-5,0},{0,-18,6,-10},{0,-48,-8,12},{0,-10,0,0},{0,10,0,0})},
            CastRelease={AnimationId="",Duration=0.22,Pose=pose7({0,-2,-6,0},{0,-3,-6,0},{0,3,5,0},{0,-8,0,-4},{0,-24,-16,6},{0,6,0,0},{0,-6,0,0})},
        },
        Threshold={
            CastWindup={AnimationId="",Pose=pose7({0,0,0,0},{0,2,0,0},{0,-2,0,0},{0,-52,-8,-16},{0,-52,8,16},{0,-4,0,0},{0,4,0,0})},
            CastRelease={AnimationId="",Duration=0.25,Pose=pose7({0,2,0,0},{0,-2,0,0},{0,2,0,0},{0,-65,-8,-26},{0,-65,8,26},{0,4,0,0},{0,-4,0,0})},
        },
    },
    MotorRoles={RootJoint="Root",Root="Root",Waist="Waist",Neck="Neck",["Left Shoulder"]="LeftShoulder",
        ["Right Shoulder"]="RightShoulder",LeftShoulder="LeftShoulder",RightShoulder="RightShoulder",
        ["Left Hip"]="LeftHip",["Right Hip"]="RightHip",LeftHip="LeftHip",RightHip="RightHip"},
    Aliases={["idle"]="Idle",["idle-breathing"]="Idle",["walk"]="Walk",["walk-lean"]="Walk",["run"]="Run",
        ["jump"]="Jump",["land"]="Land",["cast-windup"]="CastWindup",["cast-release"]="CastRelease",
        ["hit-react"]="HitReact",["dodge"]="Dodge",["roll"]="Roll",["death"]="Death",["victory"]="Victory"},
    Entries={
        Idle={AnimationId="",Procedural=breathe,Priority=0,AssetPriority=Enum.AnimationPriority.Idle,Loop=true,
            Duration=2.8,FadeIn=0.2,FadeOut=0.2,Period=2.8,Rise=0.025,Nod=0.6},
        Walk={AnimationId="",Procedural=locomotion,Priority=1,AssetPriority=Enum.AnimationPriority.Movement,Loop=true,
            Duration=0.7,FadeIn=0.16,FadeOut=0.16,Period=0.7,Lean=3,Sway=0.7,CounterLean=0.5},
        Run={AnimationId="",Procedural=locomotion,Priority=2,AssetPriority=Enum.AnimationPriority.Movement,Loop=true,
            Duration=0.48,FadeIn=0.16,FadeOut=0.16,Period=0.48,Lean=7,Sway=1.2,CounterLean=0.5},
        Jump={AnimationId="",Procedural=still,Priority=3,AssetPriority=Enum.AnimationPriority.Action,Loop=false,
            Duration=0.3,FadeIn=0.06,FadeOut=0.12,Pose=pose7({0.04,-6,0,0},{0,-3,0,0},{0,4,0,0},{0,-12,0,-5},{0,-12,0,5},{0,-10,0,0},{0,6,0,0})},
        Land={AnimationId="",Procedural=still,Priority=3,AssetPriority=Enum.AnimationPriority.Action,Loop=false,
            Duration=0.22,FadeIn=0.045,FadeOut=0.14,Pose=pose7({-0.14,9,0,0},{0,5,0,0},{0,-5,0,0},{0,10,0,-7},{0,10,0,7},{0,12,0,0},{0,-12,0,0})},
        CastWindup={AnimationId="",Procedural=still,Priority=4,AssetPriority=Enum.AnimationPriority.Action2,Loop=true,
            Duration=0.38,FadeIn=0.12,FadeOut=0.08,Pose=pose7({0,-4,-7,0},{0,0,-4,0},{0,2,7,0},{0,-28,-12,-18},{0,-45,8,18},{0,-4,0,0},{0,4,0,0})},
        CastRelease={AnimationId="",Procedural=releaseCurve,Priority=5,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.3,FadeIn=0.05,FadeOut=0.17,Pose=pose7({0,6,6,0},{0,0,4,0},{0,-3,-6,0},{0,-48,-12,-14},{0,-72,12,14},{0,5,0,0},{0,-5,0,0})},
        HitReact={AnimationId="",Procedural=still,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.24,FadeIn=0.04,FadeOut=0.15,Pose=pose7({0,-9,0,-4},{0,-5,0,-2},{0,5,0,3},{0,-9,0,-5},{0,-9,0,5},{0,4,0,0},{0,-4,0,0})},
        Dodge={AnimationId="",Procedural=roll,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.36,FadeIn=0.05,FadeOut=0.09,Tuck=0.15,Pitch=18,Roll=16,ArmPitch=-22},
        Roll={AnimationId="",Procedural=roll,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.48,FadeIn=0.05,FadeOut=0.12,Tuck=0.24,Pitch=62,Roll=0,ArmPitch=-50},
        Death={AnimationId="",Procedural=still,Priority=8,AssetPriority=Enum.AnimationPriority.Action4,Loop=true,
            Duration=0.8,FadeIn=0.4,FadeOut=0.25,Pose=pose7({-0.24,28,0,16},{0,12,0,8},{0,18,0,0},{0,12,0,-12},{0,12,0,12},{0,14,0,0},{0,-10,0,0})},
        Victory={AnimationId="",Procedural=still,Priority=7,AssetPriority=Enum.AnimationPriority.Action4,Loop=false,
            Duration=1.4,FadeIn=0.25,FadeOut=0.3,Pose=pose7({0.03,-3,0,0},{0,-3,0,0},{0,-4,0,0},{0,-100,0,-24},{0,-100,0,24},{0,-3,0,0},{0,3,0,0})},
    },
}
-- Distinct Windup (anticipation) and Release (projection/follow-through) poses across all 7 motor roles,
-- plus gesture origin offsets (right, up, forward) and windup stencil glyphs.
local choreography: {[string]: {W: any,R: any,Origin: {number},Stencil: string}}={
    -- Seer / Fool
    Divination={
        W=pose7({0,2,-4,0},{0,2,-4,0},{0,-8,3,0},{0,-46,14,-10},{0,-64,-14,18},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,6,0},{0,-2,6,0},{0,3,-6,0},{0,-36,-8,-14},{0,-82,18,28},{0,4,0,0},{0,-4,0,0}),
        Origin={0.35,0.55,-1.15},Stencil="Card",
    },
    Reading={
        W=pose7({0,0,0,0},{0,-2,-3,0},{0,-3,0,0},{0,-20,0,-12},{0,-72,0,14},{0,-3,0,0},{0,3,0,0}),
        R=pose7({0,1,3,0},{0,2,3,0},{0,-2,0,0},{0,-26,-6,-14},{0,-55,0,20},{0,3,0,0},{0,-3,0,0}),
        Origin={0.15,1.35,-0.75},Stencil="Eye",
    },
    Acrobat={
        W=pose7({-0.12,14,-14,-6},{0,8,-8,0},{0,-6,10,0},{0,24,-10,-18},{0,-36,12,22},{0,-18,0,-4},{0,14,0,4}),
        R=pose7({0.06,-8,12,4},{0,-6,10,0},{0,4,-8,0},{0,-68,-14,-28},{0,-44,14,20},{0,14,0,4},{0,-14,0,-4}),
        Origin={0,-0.85,-0.65},Stencil="Circle",
    },
    Composure={
        W=pose7({-0.03,4,0,0},{0,3,0,0},{0,-6,0,0},{0,-34,14,-8},{0,-34,-14,8},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0.02,-3,0,0},{0,-2,0,0},{0,2,0,0},{0,-24,18,-6},{0,-24,-18,6},{0,2,0,0},{0,-2,0,0}),
        Origin={0,0.35,-0.65},Stencil="Scale",
    },
    Flame={
        W=pose7({0,-4,-12,0},{0,4,-8,0},{0,-3,8,0},{0,-22,0,-8},{0,-40,10,20},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0,5,9,0},{0,-4,8,0},{0,5,-6,0},{0,-34,-8,-16},{0,-68,0,30},{0,6,0,0},{0,-6,0,0}),
        Origin={0.45,0.25,-0.95},Stencil="Flame",
    },
    Paper={
        W=pose7({0,3,0,0},{0,4,0,0},{0,-7,0,0},{0,-52,22,-10},{0,-52,-22,10},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,6,0},{0,-3,6,0},{0,2,-4,0},{0,-36,-12,-18},{0,-74,16,24},{0,4,0,0},{0,-4,0,0}),
        Origin={0,0.45,-1.05},Stencil="Card",
    },
    Veil={
        W=pose7({0,2,-8,0},{0,2,-6,0},{0,-5,6,0},{0,-20,6,-10},{0,-84,-24,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,6,0},{0,-2,6,0},{0,3,-4,0},{0,-28,-8,-14},{0,-58,22,26},{0,4,0,0},{0,-4,0,0}),
        Origin={0.1,1.25,-0.7},Stencil="Mask",
    },
    Voice={
        W=pose7({0,2,4,0},{0,2,3,0},{0,-4,-4,0},{0,-16,0,-8},{0,-68,-20,10},{0,-3,0,0},{0,3,0,0}),
        R=pose7({0,-3,-4,0},{0,-3,0,0},{0,6,0,0},{0,-24,-6,-12},{0,-52,14,20},{0,3,0,0},{0,-3,0,0}),
        Origin={0.1,0.95,-0.65},Stencil="Circle",
    },
    Puppet={
        W=pose7({0,-3,-6,0},{0,-2,-4,0},{0,3,4,0},{0,-66,-10,-24},{0,-66,10,24},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,4,4,0},{0,3,4,0},{0,-4,-3,0},{0,-44,12,-14},{0,-48,-12,14},{0,5,0,0},{0,-5,0,0}),
        Origin={0,0.85,-1.25},Stencil="Thread",
    },
    Command={
        W=pose7({0,-2,-10,0},{0,0,-8,0},{0,2,8,0},{0,-84,-8,-20},{0,-32,18,16},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,5,12,0},{0,4,10,0},{0,-2,-8,0},{0,-76,-12,-24},{0,-88,-6,12},{0,8,0,0},{0,-8,0,0}),
        Origin={0.45,0.75,-1.35},Stencil="Thread",
    },
    Exchange={
        W=pose7({-0.04,4,-10,0},{0,4,-8,0},{0,-4,8,0},{0,-58,28,-12},{0,-58,-28,12},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.04,-4,12,0},{0,-4,10,0},{0,3,-8,0},{0,-72,-26,-32},{0,-72,26,32},{0,8,0,0},{0,-8,0,0}),
        Origin={0,0.65,-1.1},Stencil="Thread",
    },
    Illusion={
        W=pose7({-0.05,8,-12,-4},{0,6,-8,-4},{0,-6,10,4},{0,-74,-12,-32},{0,-36,18,14},{0,-10,0,0},{0,10,0,0}),
        R=pose7({0.03,-6,8,4},{0,-5,6,4},{0,5,-6,-3},{0,-82,-20,-38},{0,-82,20,38},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.9,-1.15},Stencil="Mask",
    },
    History={
        W=pose7({-0.04,7,0,0},{0,6,0,0},{0,-6,0,0},{0,-68,16,-12},{0,-68,-16,12},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.04,-6,0,0},{0,-5,0,0},{0,4,0,0},{0,-54,-18,-28},{0,-54,18,28},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.55,-1.35},Stencil="Hourglass",
    },
    Recovery={
        W=pose7({-0.03,5,-6,0},{0,4,-4,0},{0,-8,4,0},{0,-48,20,-10},{0,-48,-20,10},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0.03,-5,0,0},{0,-4,0,0},{0,6,0,0},{0,-38,-16,-22},{0,-38,16,22},{0,4,0,0},{0,-4,0,0}),
        Origin={0,0.45,-0.75},Stencil="Hourglass",
    },
    Miracle={
        W=pose7({0,-4,-6,0},{0,-4,-4,0},{0,10,4,0},{0,-32,-8,-14},{0,-96,8,22},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,3,4,0},{0,2,4,0},{0,-2,-2,0},{0,-48,-12,-20},{0,-62,12,26},{0,5,0,0},{0,-5,0,0}),
        Origin={0.25,1.55,-0.85},Stencil="Star",
    },
    MiracleMend={
        W=pose7({0,-3,0,0},{0,-2,0,0},{0,-5,0,0},{0,-64,18,-14},{0,-64,-18,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0.03,-5,0,0},{0,-4,0,0},{0,7,0,0},{0,-56,-16,-28},{0,-56,16,28},{0,4,0,0},{0,-4,0,0}),
        Origin={0,0.85,-0.95},Stencil="Star",
    },
    Graft={
        W=pose7({0,-2,-10,0},{0,0,-8,0},{0,2,6,0},{0,-72,-24,-22},{0,-72,24,22},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,4,8,0},{0,3,6,0},{0,-3,0,0},{0,-66,18,-8},{0,-66,-18,8},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.75,-1.25},Stencil="Thread",
    },
    Domain={
        W=pose7({0.02,-6,0,0},{0,-5,0,0},{0,8,0,0},{0,-92,-14,-28},{0,-92,14,28},{0,-6,0,0},{0,6,0,0}),
        R=pose7({-0.02,4,0,0},{0,3,0,0},{0,-3,0,0},{0,-58,-18,-36},{0,-58,18,36},{0,5,0,0},{0,-5,0,0}),
        Origin={0,1.45,-0.95},Stencil="Crown",
    },
    -- Marauder / Error
    Pickpocket={
        W=pose7({0,4,9,-3},{0,3,6,-2},{0,-2,-6,0},{0,-14,4,-8},{0,-48,-8,12},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0,-2,-6,0},{0,-2,-4,0},{0,2,4,0},{0,-10,0,-6},{0,-24,-16,6},{0,4,0,0},{0,-4,0,0}),
        Origin={0.45,0.25,-1.25},Stencil="Split",
    },
    Stealth={
        W=pose7({-0.08,10,10,-4},{0,6,8,-3},{0,-6,-8,0},{0,-44,18,-10},{0,-52,-20,12},{0,-12,0,0},{0,10,0,0}),
        R=pose7({-0.05,6,-6,2},{0,4,-4,0},{0,-3,6,0},{0,-22,6,-8},{0,-28,-8,10},{0,-6,0,0},{0,6,0,0}),
        Origin={0,0.15,-0.65},Stencil="Split",
    },
    Deceit={
        W=pose7({0,5,-10,-3},{0,4,-8,-2},{0,-4,8,3},{0,-18,-8,-10},{0,-76,-14,18},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,-3,10,2},{0,-2,8,2},{0,2,-8,-2},{0,-26,-12,-14},{0,-54,22,26},{0,6,0,0},{0,-6,0,0}),
        Origin={0.35,1.15,-0.85},Stencil="Split",
    },
    Misdirection={
        W=pose7({-0.03,4,14,4},{0,4,12,4},{0,-2,-12,0},{0,-64,-18,-26},{0,-22,10,8},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.02,-3,-14,-4},{0,-3,-12,-4},{0,3,10,0},{0,-24,8,-10},{0,-72,20,28},{0,8,0,0},{0,-8,0,0}),
        Origin={-0.45,0.65,-1.1},Stencil="Cut",
    },
    Decipher={
        W=pose7({0,3,-4,0},{0,2,-4,0},{0,-5,4,2},{0,-52,12,-12},{0,-82,-18,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,4,0},{0,-2,4,0},{0,2,-4,0},{0,-44,8,-10},{0,-58,10,20},{0,4,0,0},{0,-4,0,0}),
        Origin={0.2,1.3,-0.8},Stencil="Book",
    },
    Interpret={
        W=pose7({0,2,0,0},{0,2,0,0},{0,-3,0,0},{0,-64,16,-14},{0,-64,-16,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,0,0},{0,-2,0,0},{0,3,0,0},{0,-56,-18,-24},{0,-56,18,24},{0,4,0,0},{0,-4,0,0}),
        Origin={0,1.1,-1.05},Stencil="Split",
    },
    Theft={
        W=pose7({0,4,9,-3},{0,4,8,-2},{0,0,-5,0},{0,-18,6,-10},{0,-48,-8,12},{0,-10,0,0},{0,10,0,0}),
        R=pose7({0,-2,-6,0},{0,-3,-6,0},{0,3,5,0},{0,-8,0,-4},{0,-24,-16,6},{0,6,0,0},{0,-6,0,0}),
        Origin={0.5,0.55,-1.35},Stencil="Split",
    },
    EnergyTheft={
        W=pose7({-0.03,6,6,0},{0,5,6,0},{0,-3,-4,0},{0,-54,10,-14},{0,-64,-10,16},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.03,-4,-4,0},{0,-4,-4,0},{0,4,4,0},{0,-32,22,-8},{0,-36,-22,8},{0,6,0,0},{0,-6,0,0}),
        Origin={0.25,0.45,-1.2},Stencil="Cut",
    },
    Thought={
        W=pose7({0,-2,8,0},{0,-2,6,0},{0,2,-6,0},{0,-68,-8,-16},{0,-84,-16,12},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,3,-6,0},{0,2,-6,0},{0,-3,6,0},{0,-36,16,-10},{0,-76,12,20},{0,5,0,0},{0,-5,0,0}),
        Origin={0.2,1.35,-0.95},Stencil="Split",
    },
    Dream={
        W=pose7({-0.02,4,-8,-4},{0,3,-6,-3},{0,-6,6,6},{0,-28,-8,-12},{0,-72,14,22},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0.02,6,10,3},{0,5,8,2},{0,4,-8,-3},{0,-38,-14,-18},{0,-42,-18,8},{0,6,0,0},{0,-6,0,0}),
        Origin={0.35,0.95,-1.2},Stencil="Cut",
    },
    Parasite={
        W=pose7({-0.04,7,10,-2},{0,6,8,-2},{0,-4,-8,0},{0,-26,8,-12},{0,-74,-12,14},{0,-10,0,0},{0,10,0,0}),
        R=pose7({0.02,-3,-8,2},{0,-2,-6,2},{0,3,6,0},{0,-42,-12,-18},{0,-52,18,24},{0,8,0,0},{0,-8,0,0}),
        Origin={0.45,0.55,-1.4},Stencil="Thread",
    },
    Siphon={
        W=pose7({-0.05,8,0,0},{0,6,0,0},{0,-5,0,0},{0,-48,-20,-26},{0,-48,20,26},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.04,-5,0,0},{0,-4,0,0},{0,6,0,0},{0,-62,24,-8},{0,-62,-24,8},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.5,-1.0},Stencil="Split",
    },
    Mentor={
        W=pose7({0,-3,-10,-3},{0,-2,-8,-2},{0,4,8,4},{0,16,12,-8},{0,-84,-14,18},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,3,10,3},{0,2,8,2},{0,-2,-8,-3},{0,-34,-12,-16},{0,-68,24,28},{0,5,0,0},{0,-5,0,0}),
        Origin={0.35,1.2,-0.95},Stencil="Mask",
    },
    Belief={
        W=pose7({0,-4,6,0},{0,-3,4,0},{0,5,-4,0},{0,-72,-12,-22},{0,-72,12,22},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,4,-6,0},{0,3,-4,0},{0,-3,4,0},{0,-58,18,-12},{0,-58,-18,12},{0,5,0,0},{0,-5,0,0}),
        Origin={0,1.05,-1.15},Stencil="Crown",
    },
    Destiny={
        W=pose7({-0.04,4,-14,-4},{0,3,-10,-3},{0,-2,10,0},{0,-30,-10,-14},{0,-88,16,20},{0,-8,0,0},{0,8,0,0}),
        R=pose7({0.03,-3,12,3},{0,-2,10,2},{0,3,-8,0},{0,-44,-14,-20},{0,-46,-12,14},{0,8,0,0},{0,-8,0,0}),
        Origin={0.4,0.85,-1.25},Stencil="Cut",
    },
    Payload={
        W=pose7({0,3,10,0},{0,2,8,0},{0,-4,-8,0},{0,-48,16,-10},{0,-58,-22,12},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,-2,-8,0},{0,-2,-6,0},{0,2,6,0},{0,-28,-8,-12},{0,-74,14,22},{0,5,0,0},{0,-5,0,0}),
        Origin={0.35,0.65,-1.15},Stencil="Star",
    },
    Time={
        W=pose7({0,-3,-6,0},{0,-2,-4,0},{0,4,4,0},{0,-96,-6,-14},{0,-54,18,28},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,4,8,0},{0,3,6,0},{0,-3,-6,0},{0,-62,14,-22},{0,-84,-14,16},{0,6,0,0},{0,-6,0,0}),
        Origin={0.25,1.15,-1.15},Stencil="Clock",
    },
    TimeDelay={
        W=pose7({0.02,-4,0,0},{0,-3,0,0},{0,5,0,0},{0,-76,-16,-24},{0,-76,16,24},{0,-5,0,0},{0,5,0,0}),
        R=pose7({-0.03,5,0,0},{0,4,0,0},{0,-4,0,0},{0,-44,-20,-32},{0,-44,20,32},{0,5,0,0},{0,-5,0,0}),
        Origin={0,0.85,-1.1},Stencil="Clock",
    },
    -- Apprentice / Door
    Threshold={
        W=pose7({0,0,0,0},{0,2,0,0},{0,-2,0,0},{0,-52,-8,-16},{0,-52,8,16},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,2,0,0},{0,-2,0,0},{0,2,0,0},{0,-65,-8,-26},{0,-65,8,26},{0,4,0,0},{0,-4,0,0}),
        Origin={0,0.65,-1.25},Stencil="Key",
    },
    Passage={
        W=pose7({0,2,-6,0},{0,2,-4,0},{0,-6,4,0},{0,-46,12,-10},{0,-64,-12,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,6,0},{0,-2,4,0},{0,3,-4,0},{0,-58,-8,-18},{0,-42,10,16},{0,4,0,0},{0,-4,0,0}),
        Origin={-0.25,0.65,-1.05},Stencil="Key",
    },
    Trick={
        W=pose7({0,3,-8,0},{0,2,-6,0},{0,-2,6,0},{0,-18,-10,-8},{0,-52,-14,16},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,-2,10,0},{0,-2,8,0},{0,3,-8,0},{0,-26,-12,-12},{0,-78,14,24},{0,5,0,0},{0,-5,0,0}),
        Origin={0.45,0.75,-1.3},Stencil="Star",
    },
    Wind={
        W=pose7({-0.02,4,12,3},{0,3,10,2},{0,-3,-8,0},{0,-54,-18,-22},{0,-58,22,12},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0.02,-3,-12,-3},{0,-2,-10,-2},{0,3,8,0},{0,-48,18,-12},{0,-68,-18,28},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.55,-1.15},Stencil="Circle",
    },
    Astrology={
        W=pose7({0,-5,0,0},{0,-4,0,0},{0,8,0,0},{0,-72,14,-18},{0,-72,-14,18},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,2,6,0},{0,2,6,0},{0,4,-6,0},{0,-48,-12,-16},{0,-86,8,22},{0,5,0,0},{0,-5,0,0}),
        Origin={0.15,1.35,-1.0},Stencil="Star",
    },
    Ward={
        W=pose7({-0.02,4,0,0},{0,3,0,0},{0,-4,0,0},{0,-62,24,-10},{0,-62,-24,10},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0.02,-3,0,0},{0,-2,0,0},{0,3,0,0},{0,-52,-14,-22},{0,-52,14,22},{0,5,0,0},{0,-5,0,0}),
        Origin={0,0.85,-0.85},Stencil="Arch",
    },
    Record={
        W=pose7({0,2,-6,0},{0,2,-4,0},{0,-5,4,0},{0,-58,16,-12},{0,-76,-10,18},{0,-4,0,0},{0,4,0,0}),
        R=pose7({0,-2,4,0},{0,-2,4,0},{0,-7,-2,0},{0,-56,14,-12},{0,-52,16,12},{0,4,0,0},{0,-4,0,0}),
        Origin={-0.15,0.65,-1.05},Stencil="Book",
    },
    Release={
        W=pose7({0,3,-4,0},{0,2,-4,0},{0,-6,2,0},{0,-56,14,-12},{0,-54,16,12},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,-3,10,0},{0,-2,8,0},{0,4,-6,0},{0,-44,-10,-18},{0,-84,8,22},{0,6,0,0},{0,-6,0,0}),
        Origin={0.35,0.75,-1.25},Stencil="Book",
    },
    Travel={
        W=pose7({0,0,0,0},{0,2,0,0},{0,-2,0,0},{0,-52,-8,-16},{0,-52,8,16},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,2,0,0},{0,-3,0,0},{0,3,0,0},{0,-65,-8,-26},{0,-65,8,26},{0,8,0,0},{0,-8,0,0}),
        Origin={0,0.55,-1.15},Stencil="Door",
    },
    Door={
        W=pose7({0,-2,-8,0},{0,-2,-6,0},{0,2,6,0},{0,-68,-14,-22},{0,-74,-8,16},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,3,6,0},{0,2,6,0},{0,-2,-4,0},{0,-62,-18,-28},{0,-78,18,32},{0,5,0,0},{0,-5,0,0}),
        Origin={0.35,0.85,-1.3},Stencil="Key",
    },
    Conceal={
        W=pose7({0,-3,0,0},{0,-2,0,0},{0,2,0,0},{0,-64,-22,-26},{0,-64,22,26},{0,-5,0,0},{0,5,0,0}),
        R=pose7({-0.03,4,0,0},{0,3,0,0},{0,-5,0,0},{0,-52,20,-10},{0,-52,-20,10},{0,5,0,0},{0,-5,0,0}),
        Origin={0,0.65,-0.95},Stencil="Door",
    },
    Seal={
        W=pose7({0,-4,0,0},{0,-3,0,0},{0,4,0,0},{0,-76,-14,-24},{0,-76,14,24},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,5,0,0},{0,4,0,0},{0,-4,0,0},{0,-58,12,-14},{0,-58,-12,14},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.85,-1.25},Stencil="Seal",
    },
    Wandering={
        W=pose7({0.03,-4,-10,-3},{0,-3,-8,-2},{0,4,8,0},{0,-74,-12,-24},{0,-42,16,18},{0,12,0,0},{0,-12,0,0}),
        R=pose7({0.05,4,10,3},{0,3,8,2},{0,-2,-8,0},{0,-54,-20,-30},{0,-82,12,28},{0,-10,0,0},{0,10,0,0}),
        Origin={0,0.75,-1.2},Stencil="Arch",
    },
    Pocket={
        W=pose7({0,-2,6,0},{0,-2,4,0},{0,3,-4,0},{0,-48,10,-14},{0,-86,-12,14},{0,-4,0,0},{0,4,0,0}),
        R=pose7({-0.02,3,-6,0},{0,2,-4,0},{0,-4,4,0},{0,-56,-12,-18},{0,-54,18,10},{0,4,0,0},{0,-4,0,0}),
        Origin={0.15,0.75,-0.95},Stencil="Door",
    },
    Replica={
        W=pose7({0,-4,0,0},{0,-3,0,0},{0,5,0,0},{0,-74,12,-18},{0,-74,-12,18},{0,-5,0,0},{0,5,0,0}),
        R=pose7({0,4,0,0},{0,3,0,0},{0,-3,0,0},{0,-68,-14,-26},{0,-68,14,26},{0,5,0,0},{0,-5,0,0}),
        Origin={0,0.95,-1.25},Stencil="Book",
    },
    Planar={
        W=pose7({0.04,-6,0,0},{0,-5,0,0},{0,8,0,0},{0,-88,-16,-28},{0,-88,16,28},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0.02,3,0,0},{0,2,0,0},{0,-2,0,0},{0,-68,-24,-36},{0,-68,24,36},{0,6,0,0},{0,-6,0,0}),
        Origin={0,1.25,-1.15},Stencil="Arch",
    },
    Gate={
        W=pose7({0.04,-7,0,0},{0,-6,0,0},{0,10,0,0},{0,-98,-14,-26},{0,-98,14,26},{0,-6,0,0},{0,6,0,0}),
        R=pose7({0,4,0,0},{0,3,0,0},{0,-2,0,0},{0,-72,-18,-32},{0,-72,18,32},{0,6,0,0},{0,-6,0,0}),
        Origin={0,1.45,-1.15},Stencil="Key",
    },
    Closure={
        W=pose7({0,-4,0,0},{0,-3,0,0},{0,4,0,0},{0,-72,-24,-34},{0,-72,24,34},{0,-6,0,0},{0,6,0,0}),
        R=pose7({-0.03,6,0,0},{0,5,0,0},{0,-5,0,0},{0,-62,22,-10},{0,-62,-22,10},{0,6,0,0},{0,-6,0,0}),
        Origin={0,0.85,-1.2},Stencil="Seal",
    },
}
local families: {[string]: {{string}}}={
    Seer={{"Divination","Reading"},{"Acrobat","Composure"},{"Flame","Paper"},{"Veil","Voice"},{"Puppet","Command"},
        {"Exchange","Illusion"},{"History","Recovery"},{"Miracle","MiracleMend"},{"Graft","Domain"}},
    Marauder={{"Pickpocket","Stealth"},{"Deceit","Misdirection"},{"Decipher","Interpret"},{"Theft","EnergyTheft"},{"Thought","Dream"},
        {"Parasite","Siphon"},{"Mentor","Belief"},{"Destiny","Payload"},{"Time","TimeDelay"}},
    Apprentice={{"Threshold","Passage"},{"Trick","Wind"},{"Astrology","Ward"},{"Record","Release"},{"Travel","Door"},
        {"Conceal","Seal"},{"Wandering","Pocket"},{"Replica","Planar"},{"Gate","Closure"}},
}
local release: {[string]: {{number}}}={
    Seer={{0.22,0.18},{0.20,0.25},{0.18,0.24},{0.30,0.20},{0.25,0.18},{0.18,0.32},{0.35,0.30},{0.35,0.35},{0.25,0.40}},
    Marauder={{0.16,0.20},{0.20,0.18},{0.25,0.22},{0.22,0.25},{0.20,0.25},{0.25,0.30},{0.25,0.30},{0.20,0.22},{0.25,0.35}},
    Apprentice={{0.25,0.20},{0.16,0.25},{0.28,0.22},{0.30,0.20},{0.20,0.30},{0.35,0.30},{0.25,0.30},{0.30,0.30},{0.40,0.30}},
}
local legacy={Seer_9_Secondary="Reading",Seer_7="Flame",Marauder_9="Pickpocket",Marauder_6="Theft",Apprentice_9="Threshold",Apprentice_5="Travel"}
config.AbilityProfiles={};config.AbilityTimings={};config.GestureOrigins={}
local function makeFollow(w: any,r: any): {[string]: {number}}
    local out: {[string]: {number}}={}
    for role,rv in pairs(r) do
        local wv=w[role] or {0,0,0,0}
        out[role]={
            rv[1]*0.55,
            rv[2]+(rv[2]-wv[2])*T.Choreography.FollowOvershoot,
            rv[3]+(rv[3]-wv[3])*T.Choreography.FollowOvershoot,
            rv[4]+(rv[4]-wv[4])*T.Choreography.FollowOvershoot,
        }
    end
    return out
end
for family,spec in pairs(choreography) do
    local follow=makeFollow(spec.W,spec.R)
    if not config.CastProfiles[family] then
        config.CastProfiles[family]={
            CastWindup={AnimationId="",Pose=spec.W},
            CastRelease={AnimationId="",Duration=0.22,Pose=spec.R,FollowPose=follow},
        }
    else
        config.CastProfiles[family].CastRelease.FollowPose=follow
    end
end
for pathway,rows in pairs(families) do
    for index,row in ipairs(rows) do
        local sequence=10-index
        for choice,family in ipairs(row) do
            local id=pathway.."_"..sequence..(if choice==2 then "_Secondary" else "")
            local profile=legacy[id] or id
            local spec=choreography[family]
            local source=config.CastProfiles[family] or {
                CastWindup={AnimationId="",Pose=spec.W},
                CastRelease={AnimationId="",Pose=spec.R,FollowPose=makeFollow(spec.W,spec.R)},
            }
            local wind=table.clone(source.CastWindup)
            local cast=table.clone(source.CastRelease)
            wind.Procedural=windupCurve;wind.FadeIn=T.Choreography.WindupFade
            cast.Duration=release[pathway][index][choice]
            config.CastProfiles[profile]={CastWindup=wind,CastRelease=cast}
            config.AbilityProfiles[id]=profile
            config.AbilityTimings[id]={
                Windup=if sequence<=4 then 1.5 else 0.5,
                Release=cast.Duration,
                Family=family,
                Origin=spec.Origin,
                Stencil=spec.Stencil,
            }
            config.GestureOrigins[id]={Offset=spec.Origin,Stencil=spec.Stencil,Family=family}
        end
    end
end
for _,profile in ipairs({"MeleeRight","MeleeLeft"}) do
    config.CastProfiles[profile].CastRelease.Duration=T.Choreography.MeleeDuration
end
for _,profile in ipairs({"UltimateSeer","UltimateMarauder","UltimateApprentice"}) do
    config.CastProfiles[profile].CastRelease.Duration=T.Choreography.UltimateDuration
end
-- Original combat staging: amplify silhouette, not the ability's canonical powers.
-- Procedural overlays retain Animator ownership and never move the physical root.
local function accent(pose: any): any
    if not pose then return nil end
    local result={}
    for role,values in pairs(pose) do
        local gain=if role=="LeftShoulder" or role=="RightShoulder" then T.Choreography.ArmGain else T.Choreography.BodyGain
        result[role]={values[1],math.clamp(values[2]*gain,-T.Choreography.MaxPoseDegrees,T.Choreography.MaxPoseDegrees),
            values[3]*gain,values[4]*gain}
    end
    return result
end
for name,profile in pairs(config.CastProfiles) do
    if name~="Potion" then
        for _,phase in ipairs({"CastWindup","CastRelease"}) do
            local entry=profile[phase]
            if entry then
                entry.Pose=accent(entry.Pose)
                entry.FollowPose=accent(entry.FollowPose)
                entry.AnticipationPose=accent(entry.AnticipationPose)
            end
        end
    end
end
-- Sample the same authored accents used by the editable Blender motion studies.
for name,profile in pairs(config.CastProfiles) do
    if name=="Potion" then continue end
    local family=if MotionTracks[name] then name elseif string.find(name,"Marauder") or name=="Theft" or name=="Pickpocket" then "Marauder"
        elseif string.find(name,"Apprentice") or name=="Travel" or name=="Threshold" then "Apprentice" else "Seer"
    local track=MotionTracks[family]
    local entry=profile.CastRelease
    if not entry then continue end
    local base=entry.Procedural or releaseCurve
    entry.Procedural=function(spec: any,time: number,speed: number): Pose
        local result=base(spec,time,speed)
        local progress=math.clamp(time/math.max(spec.Duration,0.01),0,1)
        for i=2,#track do
            local a,b=track[i-1],track[i]
            if progress<=b.Time then
                local t=(progress-a.Time)/(b.Time-a.Time)
                t=t*t*(3-2*t)
                for role,angles in pairs(a.Pose) do
                    local other=b.Pose[role]
                    result[role]=(result[role] or CFrame.identity)*frame(0,
                        angles[1]+(other[1]-angles[1])*t,angles[2]+(other[2]-angles[2])*t,angles[3]+(other[3]-angles[3])*t)
                end
                break
            end
        end
        return result
    end
end
return freeze(config)
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


## src/ReplicatedStorage/Shared/MotionTracks.lua

**ModuleScript** at `ReplicatedStorage/Shared/MotionTracks`. Create matching Folder parents.

```lua
--!strict
-- Original animation staging, not a claim about canonical combat gestures.
-- Generated by scripts/art/build_motion_studies.py; shared with the Blender studies.
return {["Seer"]={{["Time"]=0,["Pose"]={["Root"]={-3.6,5.4,1.8},["Waist"]={-2.25,3.6,1.35},["Neck"]={2.7,-3.6,-0.9},["LeftShoulder"]={8.1,6.3,9.0},["RightShoulder"]={11.25,-8.1,-10.8},["LeftHip"]={3.6,-0.0,1.8},["RightHip"]={-3.6,-0.0,-1.8}}},{["Time"]=0.16,["Pose"]={["Root"]={8,-12,-4},["Waist"]={5,-8,-3},["Neck"]={-6,8,2},["LeftShoulder"]={-18,-14,-20},["RightShoulder"]={-25,18,24},["LeftHip"]={-8,0,-4},["RightHip"]={8,0,4}}},{["Time"]=0.3,["Pose"]={["Root"]={6.4,-9.6,-3.2},["Waist"]={4.0,-6.4,-2.4},["Neck"]={-4.8,6.4,1.6},["LeftShoulder"]={-14.4,-11.2,-16.0},["RightShoulder"]={-20.0,14.4,19.2},["LeftHip"]={-6.4,0.0,-3.2},["RightHip"]={6.4,0.0,3.2}}},{["Time"]=0.56,["Pose"]={["Root"]={-2.56,3.84,1.28},["Waist"]={-1.6,2.56,0.96},["Neck"]={1.92,-2.56,-0.64},["LeftShoulder"]={5.76,4.48,6.4},["RightShoulder"]={8.0,-5.76,-7.68},["LeftHip"]={2.56,-0.0,1.28},["RightHip"]={-2.56,-0.0,-1.28}}},{["Time"]=0.78,["Pose"]={["Root"]={0.96,-1.44,-0.48},["Waist"]={0.6,-0.96,-0.36},["Neck"]={-0.72,0.96,0.24},["LeftShoulder"]={-2.16,-1.68,-2.4},["RightShoulder"]={-3.0,2.16,2.88},["LeftHip"]={-0.96,0.0,-0.48},["RightHip"]={0.96,0.0,0.48}}},{["Time"]=1,["Pose"]={["Root"]={0,0,0},["Waist"]={0,0,0},["Neck"]={0,0,0},["LeftShoulder"]={0,0,0},["RightShoulder"]={0,0,0},["LeftHip"]={0,0,0},["RightHip"]={0,0,0}}}},["Marauder"]={{["Time"]=0,["Pose"]={["Root"]={-4.5,-9.0,-2.7},["Waist"]={-3.15,-7.2,-1.8},["Neck"]={2.25,5.4,1.35},["LeftShoulder"]={-5.4,7.2,5.4},["RightShoulder"]={12.6,-10.8,-8.1},["LeftHip"]={5.4,-0.0,-1.8},["RightHip"]={-5.4,-0.0,1.8}}},{["Time"]=0.16,["Pose"]={["Root"]={10,20,6},["Waist"]={7,16,4},["Neck"]={-5,-12,-3},["LeftShoulder"]={12,-16,-12},["RightShoulder"]={-28,24,18},["LeftHip"]={-12,0,4},["RightHip"]={12,0,-4}}},{["Time"]=0.3,["Pose"]={["Root"]={8.0,16.0,4.8},["Waist"]={5.6,12.8,3.2},["Neck"]={-4.0,-9.6,-2.4},["LeftShoulder"]={9.6,-12.8,-9.6},["RightShoulder"]={-22.4,19.2,14.4},["LeftHip"]={-9.6,0.0,3.2},["RightHip"]={9.6,0.0,-3.2}}},{["Time"]=0.56,["Pose"]={["Root"]={-3.2,-6.4,-1.92},["Waist"]={-2.24,-5.12,-1.28},["Neck"]={1.6,3.84,0.96},["LeftShoulder"]={-3.84,5.12,3.84},["RightShoulder"]={8.96,-7.68,-5.76},["LeftHip"]={3.84,-0.0,-1.28},["RightHip"]={-3.84,-0.0,1.28}}},{["Time"]=0.78,["Pose"]={["Root"]={1.2,2.4,0.72},["Waist"]={0.84,1.92,0.48},["Neck"]={-0.6,-1.44,-0.36},["LeftShoulder"]={1.44,-1.92,-1.44},["RightShoulder"]={-3.36,2.88,2.16},["LeftHip"]={-1.44,0.0,0.48},["RightHip"]={1.44,0.0,-0.48}}},{["Time"]=1,["Pose"]={["Root"]={0,0,0},["Waist"]={0,0,0},["Neck"]={0,0,0},["LeftShoulder"]={0,0,0},["RightShoulder"]={0,0,0},["LeftHip"]={0,0,0},["RightHip"]={0,0,0}}}},["Apprentice"]={{["Time"]=0,["Pose"]={["Root"]={-2.7,-0.0,-0.0},["Waist"]={-2.25,-0.0,-0.0},["Neck"]={3.6,-0.0,-0.0},["LeftShoulder"]={10.8,9.0,9.9},["RightShoulder"]={10.8,-9.0,-9.9},["LeftHip"]={3.6,-0.0,1.35},["RightHip"]={-3.6,-0.0,-1.35}}},{["Time"]=0.16,["Pose"]={["Root"]={6,0,0},["Waist"]={5,0,0},["Neck"]={-8,0,0},["LeftShoulder"]={-24,-20,-22},["RightShoulder"]={-24,20,22},["LeftHip"]={-8,0,-3},["RightHip"]={8,0,3}}},{["Time"]=0.3,["Pose"]={["Root"]={4.8,0.0,0.0},["Waist"]={4.0,0.0,0.0},["Neck"]={-6.4,0.0,0.0},["LeftShoulder"]={-19.2,-16.0,-17.6},["RightShoulder"]={-19.2,16.0,17.6},["LeftHip"]={-6.4,0.0,-2.4},["RightHip"]={6.4,0.0,2.4}}},{["Time"]=0.56,["Pose"]={["Root"]={-1.92,-0.0,-0.0},["Waist"]={-1.6,-0.0,-0.0},["Neck"]={2.56,-0.0,-0.0},["LeftShoulder"]={7.68,6.4,7.04},["RightShoulder"]={7.68,-6.4,-7.04},["LeftHip"]={2.56,-0.0,0.96},["RightHip"]={-2.56,-0.0,-0.96}}},{["Time"]=0.78,["Pose"]={["Root"]={0.72,0.0,0.0},["Waist"]={0.6,0.0,0.0},["Neck"]={-0.96,0.0,0.0},["LeftShoulder"]={-2.88,-2.4,-2.64},["RightShoulder"]={-2.88,2.4,2.64},["LeftHip"]={-0.96,0.0,-0.36},["RightHip"]={0.96,0.0,0.36}}},{["Time"]=1,["Pose"]={["Root"]={0,0,0},["Waist"]={0,0,0},["Neck"]={0,0,0},["LeftShoulder"]={0,0,0},["RightShoulder"]={0,0,0},["LeftHip"]={0,0,0},["RightHip"]={0,0,0}}}},["MeleeRight"]={{["Time"]=0,["Pose"]={["Root"]={-3.6,9.9,2.7},["Waist"]={-2.7,8.1,1.8},["Neck"]={1.8,-5.4,-0.9},["LeftShoulder"]={-6.3,-0.0,5.4},["RightShoulder"]={12.6,8.1,-8.1},["LeftHip"]={5.4,-0.0,2.25},["RightHip"]={-5.4,-0.0,-2.25}}},{["Time"]=0.16,["Pose"]={["Root"]={8,-22,-6},["Waist"]={6,-18,-4},["Neck"]={-4,12,2},["LeftShoulder"]={14,0,-12},["RightShoulder"]={-28,-18,18},["LeftHip"]={-12,0,-5},["RightHip"]={12,0,5}}},{["Time"]=0.3,["Pose"]={["Root"]={6.4,-17.6,-4.8},["Waist"]={4.8,-14.4,-3.2},["Neck"]={-3.2,9.6,1.6},["LeftShoulder"]={11.2,0.0,-9.6},["RightShoulder"]={-22.4,-14.4,14.4},["LeftHip"]={-9.6,0.0,-4.0},["RightHip"]={9.6,0.0,4.0}}},{["Time"]=0.56,["Pose"]={["Root"]={-2.56,7.04,1.92},["Waist"]={-1.92,5.76,1.28},["Neck"]={1.28,-3.84,-0.64},["LeftShoulder"]={-4.48,-0.0,3.84},["RightShoulder"]={8.96,5.76,-5.76},["LeftHip"]={3.84,-0.0,1.6},["RightHip"]={-3.84,-0.0,-1.6}}},{["Time"]=0.78,["Pose"]={["Root"]={0.96,-2.64,-0.72},["Waist"]={0.72,-2.16,-0.48},["Neck"]={-0.48,1.44,0.24},["LeftShoulder"]={1.68,0.0,-1.44},["RightShoulder"]={-3.36,-2.16,2.16},["LeftHip"]={-1.44,0.0,-0.6},["RightHip"]={1.44,0.0,0.6}}},{["Time"]=1,["Pose"]={["Root"]={0,0,0},["Waist"]={0,0,0},["Neck"]={0,0,0},["LeftShoulder"]={0,0,0},["RightShoulder"]={0,0,0},["LeftHip"]={0,0,0},["RightHip"]={0,0,0}}}},["MeleeLeft"]={{["Time"]=0,["Pose"]={["Root"]={-3.6,-9.9,-2.7},["Waist"]={-2.7,-8.1,-1.8},["Neck"]={1.8,5.4,0.9},["LeftShoulder"]={12.6,-8.1,8.1},["RightShoulder"]={-6.3,-0.0,-5.4},["LeftHip"]={-5.4,-0.0,2.25},["RightHip"]={5.4,-0.0,-2.25}}},{["Time"]=0.16,["Pose"]={["Root"]={8,22,6},["Waist"]={6,18,4},["Neck"]={-4,-12,-2},["LeftShoulder"]={-28,18,-18},["RightShoulder"]={14,0,12},["LeftHip"]={12,0,-5},["RightHip"]={-12,0,5}}},{["Time"]=0.3,["Pose"]={["Root"]={6.4,17.6,4.8},["Waist"]={4.8,14.4,3.2},["Neck"]={-3.2,-9.6,-1.6},["LeftShoulder"]={-22.4,14.4,-14.4},["RightShoulder"]={11.2,0.0,9.6},["LeftHip"]={9.6,0.0,-4.0},["RightHip"]={-9.6,0.0,4.0}}},{["Time"]=0.56,["Pose"]={["Root"]={-2.56,-7.04,-1.92},["Waist"]={-1.92,-5.76,-1.28},["Neck"]={1.28,3.84,0.64},["LeftShoulder"]={8.96,-5.76,5.76},["RightShoulder"]={-4.48,-0.0,-3.84},["LeftHip"]={-3.84,-0.0,1.6},["RightHip"]={3.84,-0.0,-1.6}}},{["Time"]=0.78,["Pose"]={["Root"]={0.96,2.64,0.72},["Waist"]={0.72,2.16,0.48},["Neck"]={-0.48,-1.44,-0.24},["LeftShoulder"]={-3.36,2.16,-2.16},["RightShoulder"]={1.68,0.0,1.44},["LeftHip"]={1.44,0.0,-0.6},["RightHip"]={-1.44,0.0,0.6}}},{["Time"]=1,["Pose"]={["Root"]={0,0,0},["Waist"]={0,0,0},["Neck"]={0,0,0},["LeftShoulder"]={0,0,0},["RightShoulder"]={0,0,0},["LeftHip"]={0,0,0},["RightHip"]={0,0,0}}}}}
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
    {"Apprentice", "Door Opening", "Open a server-designated locked passage", "LockedPassageOpened", "Turn an astral key to unseal and pass through a server-designated practice door or threshold [UNVERIFIED].", "Instinctive sensitivity to doors, walls, and passages", "Position", {"Passage Sense", "Self", "Align an astral compass to reveal nearby doors and hidden passages [UNVERIFIED]."}, {Primary={Kind="OpenDoor", Target="Position", Range=30, Signal="LockedPassageOpened"}, Secondary={Kind="SenseDoors", Target="Self", Status="Vision", Duration=20}}},
    {"Trickmaster", "Spark Trick", "Distract an eligible hostile NPC using a trick", "HostileDistracted", "Snap a blinding flash of starlight sparks at a target, dealing damage and confusing them [UNVERIFIED].", "Repertoire of flash, wind, fog, and shock tricks", "Position", {"Wind Trick", "Position", "Conjure swirling silver-teal gusts across an area to damage and slow caught enemies [UNVERIFIED]."}, {Primary={Kind="Debuff", Target="NPC", Status="Confused", Duration=4, Power=1, Signal="HostileDistracted"}, Secondary={Kind="Area", Target="Position", Status="TimeSlow", Duration=4, Power=0.5}}},
    {"Astrologer", "Astrological Divination", "Resolve a star reading against a server-known outcome", "StarReadingResolved", "Project a celestial star chart to divine outcomes and reveal nearby spiritual signatures [UNVERIFIED].", "Star-chart divination and anti-divination intuition", "Self", {"Danger Reading", "Self", "Read imminent omens in the stars to raise an astral ward that reduces incoming damage [UNVERIFIED]."}, {Primary={Kind="Sense", Target="Self", Status="Vision", Duration=20, Signal="StarReadingResolved"}, Secondary={Kind="Buff", Target="Self", Status="Shielded", Duration=12}}},
    {"Scribe", "Record", "Record an eligible observed power", "EligiblePowerRecorded", "Inscribe an eligible NPC's supernatural power into your illusory tome with bounded charges [UNVERIFIED].", "I Came, I Saw, I Recorded — astral tome inscriptions", "NPC", {"Release Recording", "NPC", "Project a previously recorded power from your tome against a hostile target [UNVERIFIED]."}, {Primary={Kind="Record", Target="NPC", Signal="EligiblePowerRecorded"}, Secondary={Kind="Release", Target="NPC", Power=1.7}}},
    {"Traveler", "Travel", "Reach a server-designated destination through travel", "TravelDestinationReached", "Part a teal spirit-world threshold to step instantaneously to a validated destination [UNVERIFIED].", "Spirit-world traversal and invisible spatial strides", "Position", {"Spatial Door", "Position", "Anchor a persistent pair of linked spatial doors connecting your origin and target point [UNVERIFIED]."}, {Primary={Kind="Travel", Target="Position", Signal="TravelDestinationReached"}, Secondary={Kind="Portal", Target="Position", Duration=25}}},
    {"Secrets Sorcerer", "Concealment", "Protect a scripted secret with spatial concealment", "SecretProtected", "Fold surrounding space into a private pocket threshold that conceals you from sight [UNVERIFIED].", "Mastery of pocket spaces and secret partitions", "Position", {"Spatial Seal", "Position", "Erect a four-cornered spatial prison that damages and locks enemies within the area in stasis [UNVERIFIED]."}, {Primary={Kind="Conceal", Target="Self", Status="Concealed", Duration=18, Signal="SecretProtected"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=5, Power=1}}},
    {"Wanderer", "Wandering", "Reach a marked remote location through spatial wandering", "WanderingDestinationReached", "Step through nested astral arches to traverse long distances and emerge concealed [UNVERIFIED].", "Traversal of the astral cosmos and spirit world", "Position", {"Spatial Concealment", "Self", "Slip into an inner spatial fold to gain prolonged concealment [UNVERIFIED]."}, {Primary={Kind="Travel", Target="Position", Status="Concealed", Duration=15, Signal="WanderingDestinationReached"}, Secondary={Kind="Buff", Target="Self", Status="Concealed", Duration=15}}},
    {"Planeswalker", "Replication", "Reproduce an eligible recorded phenomenon", "PhenomenonReplicated", "Open dual astral archives to replicate and unleash a high-potency recorded phenomenon [UNVERIFIED].", "Symbolization into astral projections and replication", "Position", {"Planar Travel", "Position", "Part star-crowned thresholds to teleport to a destination and gain an astral shield [UNVERIFIED]."}, {Primary={Kind="Release", Target="NPC", Power=3, Signal="PhenomenonReplicated"}, Secondary={Kind="Travel", Target="Position", Status="Shielded", Duration=10}}},
    {"Key of Stars", "Star Gate", "Connect two authorized locations with a stable gate", "AuthorizedGateConnected", "Invoke the Key of Stars to anchor a long-lasting pair of celestial gates between two points [UNVERIFIED].", "Supreme authority over doors, position, and space", "Position", {"Spatial Closure", "Position", "Collapse and lock a target region of space, dealing heavy damage and sealing foes in stasis [UNVERIFIED]."}, {Primary={Kind="Portal", Target="Position", Duration=40, Signal="AuthorizedGateConnected"}, Secondary={Kind="CloseSpace", Target="Position", Status="Stasis", Duration=6, Power=2}}},
}, "https://lordofthemysteries.fandom.com/wiki/Door_Pathway/Abilities")
```


## src/ReplicatedStorage/Shared/Pathways/Marauder.lua

**ModuleScript** at `ReplicatedStorage/Shared/Pathways/Marauder`. Create matching Folder parents.

```lua
--!strict
local make = require(script.Parent.Parent.PathwayFactory)
return make("Marauder", "Error", {
    {"Marauder", "Pickpocket", "Steal a marked item from an eligible hostile NPC", "HostileItemStolen", "Snatch a marked valuable and deal a deft strike to a nearby hostile target within reach [UNVERIFIED].", "Nimble fingers andkeen observation of valuables", "NPC", {"Stealth", "Self", "Slip into offset shadows to obscure your presence for a brief duration [UNVERIFIED]."}, {Primary={Kind="Theft", Range=8, Signal="HostileItemStolen"}, Secondary={Kind="Buff", Status="Disguised", Duration=12}}},
    {"Swindler", "Deception", "Complete a scripted deception against a hostile NPC", "HostileNPCDeceived", "Fracture a target's judgment with persuasive falsehoods, damaging and confusing them [UNVERIFIED].", "Silver-tongued persuasion and social misdirection", "NPC", {"Misdirection", "NPC", "Project a lateral decoy cut that distracts and confuses an eligible hostile target [UNVERIFIED]."}, {Primary={Kind="Debuff", Status="Confused", Duration=10, Signal="HostileNPCDeceived"}, Secondary={Kind="Debuff", Status="Confused", Duration=6}}},
    {"Cryptologist", "Decipher", "Solve a server-generated cipher", "CipherSolved", "Focus a monocle-like analytical lens to gain Cipher Sight and decode nearby cryptograms [UNVERIFIED].", "Cryptographic deduction and structural pattern analysis", "Self", {"Information Interpretation", "Self", "Reconstruct hidden traces and structural flaws to reveal nearby targets [UNVERIFIED]."}, {Primary={Kind="Cipher", Target="Self", Status="CipherSight", Duration=30}, Secondary={Kind="Sense", Target="Self", Status="Vision", Duration=20}}},
    {"Prometheus", "Ability Theft", "Steal a temporary power from an eligible hostile NPC", "HostileAbilityStolen", "Extract and silence a target's power; cast again while holding a stolen power to unleash it [UNVERIFIED].", "Theft of Beyonder powers, skills, and intentions", "NPC", {"Energy Theft", "NPC", "Siphon vitality and spirituality from a target directly into yourself [UNVERIFIED]."}, {Primary={Kind="StealPower", Status="Silenced", Duration=10, Signal="HostileAbilityStolen"}, Secondary={Kind="Siphon", Power=1.3}}},
    {"Dream Stealer", "Thought Theft", "Remove an eligible thought during a scripted encounter", "HostileThoughtStolen", "Pluck a conscious thought from the target's mind, dealing damage and lulling them to sleep [UNVERIFIED].", "Infiltration of dreams and extraction of thoughts", "NPC", {"Dream Intrusion", "NPC", "Tear into a target's dreamscape to inflict searing nightmare damage over time [UNVERIFIED gameplay adaptation]."}, {Primary={Kind="Debuff", Status="Sleep", Duration=8, Signal="HostileThoughtStolen"}, Secondary={Kind="Debuff", Status="Burning", Duration=5, Power=0.8}}},
    {"Parasite", "Parasitism", "Complete a controlled hostile-NPC parasitism encounter", "HostileParasitismCompleted", "Thread a parasitic link into an eligible host, damaging them and marking them for siphoning [UNVERIFIED].", "Worm of Time parasitism and host concealment", "NPC", {"Vitality Siphon", "NPC", "Drain amplified vitality and spirituality from a parasitized or targeted host [UNVERIFIED]."}, {Primary={Kind="Parasite", Status="Parasite", Duration=12, Signal="HostileParasitismCompleted"}, Secondary={Kind="Siphon", RequiresHost=true, Power=2}}},
    {"Mentor of Deceit", "Spiritual Deception", "Misdirect an eligible hostile spiritual sense", "SpiritualSenseDeceived", "Distort the rules of perception around a target, dealing heavy damage and deceiving their senses [UNVERIFIED].", "Exploitation of loopholes and deception of rules", "NPC", {"Belief Misdirection", "NPC", "Invert an eligible NPC's recognition so they fight under your command for a short duration [UNVERIFIED]."}, {Primary={Kind="Debuff", Status="Deceived", Duration=14, Signal="SpiritualSenseDeceived"}, Secondary={Kind="Control", Duration=10}}},
    {"Trojan Horse of Destiny", "Destiny Infiltration", "Complete a scripted infiltration of a marked destiny", "DestinyInfiltrationCompleted", "Slice through a seam of fate to step beside your target and plant a delayed destiny payload [UNVERIFIED].", "Manipulation of fate fragments and destiny loopholes", "NPC", {"Hidden Destiny Payload", "NPC", "Seed a concealed knot of fate on a target that detonates for heavy damage when they act or expire [UNVERIFIED]."}, {Primary={Kind="Infiltrate", Target="NPC", Status="Payload", Duration=12, Signal="DestinyInfiltrationCompleted"}, Secondary={Kind="Debuff", Status="Payload", Duration=10}}},
    {"Worm of Time", "Time Theft", "Resolve a scripted time-theft encounter", "TimeTheftEncounterResolved", "Wrench seconds from a target's personal clock, dealing severe damage and slowing their actions [UNVERIFIED].", "Authority over time, errors, and clockwork avatars", "NPC", {"Temporal Delay", "NPC", "Stall the flow of time across a bounded area, locking caught foes in stasis [UNVERIFIED]."}, {Primary={Kind="Debuff", Status="TimeSlow", Duration=10, Power=2, Signal="TimeTheftEncounterResolved"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=4, Power=2}}},
}, "https://lordofthemysteries.fandom.com/wiki/Error_Pathway/Abilities")
```


## src/ReplicatedStorage/Shared/Pathways/Seer.lua

**ModuleScript** at `ReplicatedStorage/Shared/Pathways/Seer`. Create matching Folder parents.

```lua
--!strict
local make = require(script.Parent.Parent.PathwayFactory)
return make("Seer", "Fool", {
    {"Seer", "Divination", "Resolve a divination against a server-known outcome", "DivinationResolved", "Draw a tarot and pendulum reading to sense nearby anomalies and hidden clues [UNVERIFIED gameplay scope].", "Spiritual sensitivity and ritual intuition", "Self", {"Spirit Vision", "Self", "Open spiritual sight at the brow to perceive nearby aura traces; server filters revealed targets [UNVERIFIED]."}, {Primary={Kind="Sense", Signal="DivinationResolved"}, Secondary={Kind="Sense", Status="Vision", Duration=20}}},
    {"Clown", "Acrobatic Evasion", "Evade a hostile strike during a server-validated dodge", "HostileStrikeEvaded", "Spring into a nimble acrobatic vault that grants brief invulnerability against incoming strikes [UNVERIFIED].", "Superhuman balance, agility, and prophetic intuition", "Self", {"Composure", "Self", "Steady body and expression behind a calm mask, reducing incoming damage under pressure [UNVERIFIED]."}, {Primary={Kind="Dodge", Status="Invulnerable", Duration=2}, Secondary={Kind="Buff", Status="Composed", Duration=20}}},
    {"Magician", "Flame Jump", "Escape pursuit using a valid flame anchor", "PursuitEscaped", "Snap your fingers to vanish in crimson-gold embers and reappear at a validated position within range [UNVERIFIED].", "Stagecraft sleight of hand and spell preparation", "Position", {"Paper Figurine Substitute", "Self", "Fold a paper cutout that swaps places with you to absorb one eligible hit [UNVERIFIED]."}, {Primary={Kind="FlameJump", Target="Position", Range=36, Signal="PursuitEscaped"}, Secondary={Kind="Buff", Status="Substitute", Duration=45}}},
    {"Faceless", "Disguise", "Complete an infiltration while maintaining a disguise", "DisguisedInfiltrationCompleted", "Reshape facial features and silhouette under a grey veil to adopt an infiltration persona [UNVERIFIED].", "Mastery of bone, muscle, and facial disguise", "Self", {"Voice Mimicry", "Self", "Modulate vocal cords to project an archivist disguise profile and mask your presence [UNVERIFIED]."}, {Primary={Kind="Disguise", Profile="Wanderer", Status="Disguised", Duration=40}, Secondary={Kind="Disguise", Profile="Archivist", Status="Disguised", Duration=25}}},
    {"Marionettist", "Spirit Body Threads", "Complete control of an eligible hostile NPC", "MarionetteControlCompleted", "Seize a target's Spirit Body Threads; three confirmed stages convert an eligible NPC into a marionette [UNVERIFIED].", "Perception and manipulation of Spirit Body Threads", "NPC", {"Marionette Command", "NPC", "Direct your controlled marionette to strike a nearby hostile target with amplified force [UNVERIFIED]."}, {Primary={Kind="Control", RequiredHits=3, Duration=20, Signal="MarionetteControlCompleted"}, Secondary={Kind="Command", Power=2}}},
    {"Bizarro Sorcerer", "Marionette Exchange", "Survive an encounter using a marionette exchange", "MarionetteEscapeCompleted", "Instantly swap positions with your active marionette or target along taut spirit threads [UNVERIFIED].", "Decentralized worm-of-spirit vitality and thread mastery", "NPC", {"Bizarre Illusion", "Position", "Drape an area in uncanny phantom contours that damage and confuse nearby foes [UNVERIFIED]."}, {Primary={Kind="Exchange", Target="NPC", Signal="MarionetteEscapeCompleted"}, Secondary={Kind="Area", Status="Confused", Duration=8, Power=1.5}}},
    {"Scholar of Yore", "Historical Projection", "Resolve a historical clue using an authenticated record", "HistoricalClueResolved", "Reach into the Fog of History to summon a temporary phantom echo from past records [UNVERIFIED].", "Immersion in the Fog of History and ancient lore", "Position", {"Historical Recall", "Self", "Draw upon your past historical state to restore a bounded portion of health and spirituality [UNVERIFIED]."}, {Primary={Kind="Echo", Target="Position", Duration=20, Signal="HistoricalClueResolved"}, Secondary={Kind="Recall", Target="Self", Power=0.25}}},
    {"Miracle Invoker", "Wish Fulfillment", "Fulfill a server-assigned wish within its constraints", "WishFulfilled", "Expend accumulated Wish Credits to invoke a restorative miracle upon yourself [UNVERIFIED].", "Accumulation of wishes and walking-miracle authority", "Position", {"Miracle of Recovery", "NPC", "Weave golden threads of miracle light to mend your wounds and replenish spirituality [UNVERIFIED]."}, {Primary={Kind="Wish", Target="Self", Signal="WishFulfilled"}, Secondary={Kind="Wish", Target="Self", Power=0.6}}},
    {"Attendant of Mysteries", "Grafting", "Resolve a scripted encounter using a valid graft", "GraftEncounterResolved", "Splice spiritual knots between yourself and nearby foes so incoming harm is reflected along the graft [UNVERIFIED].", "Sovereignty over the curtain of mysteries and grafting", "Position", {"Realm of Mysteries", "Position", "Lower a veiled curtain of grey fog that locks nearby enemies in stasis and deals heavy damage [UNVERIFIED]."}, {Primary={Kind="Graft", Target="Position", Duration=12, Signal="GraftEncounterResolved"}, Secondary={Kind="Area", Target="Position", Status="Stasis", Duration=4, Power=3}}},
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
    WalkSpeedBase=11.5, RunSpeedBase=16, AgilityWalkScale=0.14, AgilityRunScale=0.25, MaxWalkSpeed=24, MaxRunSpeed=42,
    DashDistance=14, DashCooldown=2.2, DashGraceSeconds=0.75,
    Ultimate={
        UnlockSequence=4,
        CompleteSequence=2,
        CooldownSeconds=45,
        SpiritualityCost=45,
        IncompleteDuration=10,
        CompleteDuration=14,
        IncompleteSanityCost=12,
        IncompleteSanityDrainPerSecond=1.2,
        CompleteSanityCost=4,
        IncompletePowerMultiplier=1.2,
        CompletePowerMultiplier=1.35,
        SpeedBonus=4,
        PulseRadius=16,
        PulseBaseDamage=32,
        Forms={
            Seer={
                Id="Seer_Ultimate",
                Name="Worms of Spirit",
                IncompleteTitle="Incomplete Saint Form · Vortex of Spirit Worms",
                CompleteTitle="Complete Mythical Form · Cloak & Tentacles of the Fool",
                Status="Confused",
                StatusDuration=3.5,
            },
            Marauder={
                Id="Marauder_Ultimate",
                Name="Worms of Time",
                IncompleteTitle="Incomplete Saint Form · Ringed Swarm of Time Worms",
                CompleteTitle="Complete Mythical Form · 12-Ringed Clock of Error",
                Status="TimeSlow",
                StatusDuration=5,
            },
            Apprentice={
                Id="Apprentice_Ultimate",
                Name="Worms of Star",
                IncompleteTitle="Incomplete Saint Form · Cluster of Star-Door Worms",
                CompleteTitle="Complete Mythical Form · Astral Door of All Doors",
                Status="Stasis",
                StatusDuration=3.5,
            },
        },
    },
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
return freeze({Madness={Id="Madness", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksCasting=true, BlocksAdvancement=true}, LostControl={Id="LostControl", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksCasting=true, BlocksAdvancement=true}, Invulnerable={Id="Invulnerable", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, PreventsDamage=true}, Substitute={Id="Substitute", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, PreventsOneLethalHit=true}, Disguised={Id="Disguised", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, AggroMultiplier=0.2}, Concealed={Id="Concealed", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, AggroMultiplier=0}, Vision={Id="Vision", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Reveal=true}, CipherSight={Id="CipherSight", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Decode=true}, Composed={Id="Composed", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MentalDamageMultiplier=0.5}, Shielded={Id="Shielded", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageMultiplier=0.35}, MythicalForm={Id="MythicalForm", DurationSeconds=14, Stacking="Refresh", MaxStacks=1, DamageMultiplier=0.75}, Threaded={Id="Threaded", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MoveMultiplier=0.4}, Controlled={Id="Controlled", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, Ally=true}, Confused={Id="Confused", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true}, Silenced={Id="Silenced", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAbilities=true}, Sleep={Id="Sleep", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true, MoveMultiplier=0}, Parasite={Id="Parasite", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageOverTime=true}, Deceived={Id="Deceived", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true}, Payload={Id="Payload", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, TriggeredOnAttack=true}, TimeSlow={Id="TimeSlow", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, MoveMultiplier=0.25}, Stasis={Id="Stasis", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, BlocksAttacks=true, MoveMultiplier=0}, Burning={Id="Burning", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, DamageOverTime=true}, Grafted={Id="Grafted", DurationSeconds=10, Stacking="Refresh", MaxStacks=1, ReflectsDamage=true}})
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
        Stone=rgb("68615D"),Wood=rgb("42342D"),Iron=rgb("2B3037"),Mist=rgb("8B96A4"),Hit=rgb("E17986"),Warm=rgb("FFD39A"),ClearTint=rgb("FFFFFF"),MadnessTint=rgb("F0B4C3"),LostTint=rgb("AA82B4")},
    Skins={
        Seer={Accent=rgb("C6A56B"),Backing=rgb("25202F"),Glyph="Thread",Name="Veiled cards",Rotation=-5,UltimateGlyph="Worm",UltimateName="Worms of Spirit"},
        Marauder={Accent=rgb("B88A5A"),Backing=rgb("191B22"),Glyph="Split",Name="Split ledger",Rotation=7,UltimateGlyph="Clock",UltimateName="Worms of Time"},
        Apprentice={Accent=rgb("C6D0D9"),Backing=rgb("172A30"),Glyph="Door",Name="Threshold folio",Rotation=0,UltimateGlyph="Arch",UltimateName="Worms of Star"},
        Spine=3,Inset=5,CornerLength=0.2,Ornament=18,OrnamentAlpha=0.55,ReadyTime=0.55,ReadyAlpha=0.12,
    },
    Ritual={DrinkTime=0.9,Pose="Potion",DigestionTime=1.4,DigestionText="Acting recognised · +",SanityText="Your thoughts are fraying",MadnessText="Hold to your identity",LostText="Control lost · seek Stabilization"},
    World={
        Kit={GroundDepth=4,HubDepth=0.1,RoadDepth=0.12,PavementDepth=0.2,ArenaDepth=0.18,Reflectance=0.04,
            SpawnSize={12,1,12},FoundationDepth=0.2,JambWidth=0.7,JambDepth=1.5,ArchDepth=1,ArchThickness=0.5,ArchAngle=35,
            Window={3,5,0.15},Cabinet={2,8,3},Shelf={2.1,0.15,3.1},Desk={6,3,3},DeskRim={6.3,0.2,3.3},
            Bottle={0.65,1.2,0.65},Stopper={0.3,0.3,0.3},Book={1.1,0.3,1.5},LampPost=0.3,LampGlass={0.8,1.2,0.8},LampCap={1,0.2,1},
            Buttress={2,12,2},HighButtress={2,20,2},DistantPier={3,30,3},DistantCrown={43,3,3},Exposure={50,12,50},
            PracticeDoor={4,7,0.5},PracticeJamb={0.5,8,1},ClockFaceDepth=0.3,ClockHandWidth=0.18,ClockHandDepth=0.1},
        Scan=1,Ground=800,Hub=96,Road=20,Pavement=4,ArenaRadius=238,ArenaSizes={[9]={96,112},[7]={96,112},[5]={120,120},[4]={120,120},[2]={144,144},[1]={144,144}},
        Building={Width=28,Depth=28,Height=28,Storey=12,Wall=1,DoorWidth=8,DoorHeight=11,RoofHeight=4},
        Tower={Height=64,Width=12,ClockSize=8,Hands={2.5,1.7}},
        Lamp={Height=9,Spacing=24,Range=18,Brightness=1.8,DesktopMax=8,LowMax=3,MaxDistance=120,Flicker=0.04,Period=3.8,Tick=0.25},
        Services={{Name="Potion Altar",Action="Buy",X=-34,Z=-64,Glyph="Bottle"},{Name="Stabilization",Action="Recover",X=34,Z=-64,Glyph="Seal"},
            {Name="Hidden Archive",Action="Archive",X=-34,Z=64,Glyph="Book"},{Name="Cipher Archive",Action="Cipher",X=34,Z=64,Glyph="Split"}},
        Zones={[9]="Gasworks Court",[7]="Ashen Depot",[5]="Masked Conservatory",[4]="Silent Cloister",[2]="Broken Observatory",[1]="Sanctum of Seals"},
        Zone={HubRadius=68,Blend=0.25,Transition=1.2,Enter=0.35,Hold=2,Leave=0.55,Repeat=8,TitleWidth=480,TitleHeight=68,TitleTop=82,
            HubTint=rgb("D9E2F2"),LowTint=rgb("D3DBE5"),HighTint=rgb("C6C7DE")},
        Labels={Max=6,Width=156,Height=28,Distance=40,Full=28,Pad=8,Slots={0,-32,32},Offset=3.6,Scan=0.25,TextSize=13},
        Ambient={Interval=3,DesktopMax=2,MobileMax=1,Life=1.2,Scale=0.18,Priority=0},
        Lighting={ClockTime=20.25,GeographicLatitude=42,Brightness=2,ExposureCompensation=-0.05,Ambient=rgb("464A55"),OutdoorAmbient=rgb("67717B"),
            GlobalShadows=true,ShadowSoftness=0.45,EnvironmentDiffuseScale=0.4,EnvironmentSpecularScale=0.55,FogColor=rgb("8B96A4"),FogStart=120,FogEnd=600},
        Atmosphere={Density=0.32,Offset=0.12,Color=rgb("8B96A4"),Decay=rgb("394253"),Glare=0.08,Haze=1.7},
        Correction={Brightness=0.02,Contrast=0.1,Saturation=-0.12,TintColor=rgb("D9E2F2")},Bloom={Intensity=0.18,Size=24,Threshold=1.6},
        Sky={Bk="",Dn="",Ft="",Lf="",Rt="",Up=""},
    },
    CharacterArt={MaxPlayers=8,Distance=80,Scan=0.25,MaxParts=10,AuraInterval=4,AuraScale=0.16,
        Cloth={Seer=rgb("41334F"),Marauder=rgb("0C0E12"),Apprentice=rgb("172A30")},
        Trim={Seer=rgb("C6A56B"),Marauder=rgb("B88A5A"),Apprentice=rgb("C6D0D9")},
        Coat={2.15,2.15,1.15},Tail={0.9,1.2,0.2},Brim={2.2,0.12,1.7},Crown={1.4,0.65,1.25},Collar={2.25,0.3,1.2},
        Pendant={0.28,0.4,0.12},AuraLife=0.8,LapelWidth=0.18,LapelDepth=0.1,LapelFraction=0.65,LapelAngle=15,
        CapeExtra=0.5,CapeDepth=0.2,CollarSeal={0.45,0.12,0.18},BodyScaleMin=0.8,BodyScaleMax=1.5,CoatClearance=0.1,
        Mythical={
            -- Original cinematic interpretations; these silhouettes do not assert Sequence 0 anatomy at Sequence 2.
            SpiritAlpha=0.76,GlowAlpha=0.42,RevealTime=0.62,IdlePeriod=3.8,IdleRise=0.09,
            IdleDegrees=12,HaloSpeed=0.32,HandSpeed=0.55,WormSpeed=1.7,AlphaPulse=0.06,
            ClockDiameter=5.4,ClockDepth=0.16,ClockSegments=12,ClockCanvas=256,ClockRadius=0.43,
            ClockTickWidth=0.012,ClockTickHeight=0.065,ClockTickAlpha=0.18,ClockMaxDistance=80,
            HaloStroke=2,HaloInset=0.08,HaloReveal=0.4,
            AuraScale=0.55,AuraLife=1.6,AuraInterval=2.2,
            CloakAlpha=0.32,WormAlpha=0.22,ClockAlpha=0.25,DoorAlpha=0.28,
            SeerMask={1.32,1.55,0.35},SeerTentacle={0.28,1.95,0.28},SeerWorm={0.32,0.95,0.32},
            MarauderRing={0.34,1.35,0.34},MarauderClockRim={5.4,5.4,0.18},MarauderHand={0.16,1.85,0.14},
            ApprenticeWorm={0.28,1.05,0.24},ApprenticeJamb={0.24,3.4,0.24},ApprenticeLintel={2.5,0.24,0.24},
        }},
    EnemyArt={Geometry={Coat={2.4,2.8,1.35},Sleeve={0.65,2.7,0.8},Boot={0.85,1.2,1},Mask={1.3,1.6,0.9},
        Brim={2.4,0.15,1.8},Crown={1.5,0.9,1.2},Ear={0.4,1.3,0.5},Veil={2.2,4,0.18},Arch={0.25,4,0.25},Lintel={3.4,0.25,0.25}},
        PhaseScale=0.6,PhasePriority=2,MinimumSize=0.05,MinimumLife=0.01,Max=18,MaxParts=12,Distance=120,Scan=0.1,MaxBars=4,MobileBars=2,BarDistance=40,BarWidth=176,BarHeight=40,BarTrack=4,
        IdlePeriod=3.6,IdleRise=0.035,AttackLean=12,HitLean=8,HitTime=0.2,DeathTime=0.8,WarningLead=0.65,
        WarningAlpha=0.88,FillAlpha=0.8,GroundOffset=-3.85,GroundThickness=0.04,SpellRadius=2.6,ThreatPriority=5,
        IntroGap=8,PhaseRatio=0.5,Sound={Intro="Enemy.Intro",Phase="Enemy.Phase",Death="Enemy.Death",Melee="Enemy.Melee",Spell="Enemy.Spell"},
        Profiles={
            [9]={Name="Lamplight Ruffian",Scale=1,Width=1,Color=rgb("42342D"),Mask=rgb("B8B4AC"),Motif="Hat"},
            [7]={Name="Veiled Penitent",Scale=1.1,Width=0.9,Color=rgb("41334F"),Mask=rgb("E9DFC6"),Motif="Veil"},
            [5]={Name="Brass-Masked Prowler",Scale=1.15,Width=1.4,Color=rgb("2B3037"),Mask=rgb("B88A5A"),Motif="Beast"},
            [4]={Name="Cloister Apparition",Scale=1.5,Width=0.72,Color=rgb("252C36"),Mask=rgb("A8ADB7"),Motif="Veil"},
            [2]={Name="Bound Astronomer",Scale=1.8,Width=0.85,Color=rgb("41334F"),Mask=rgb("C6D0D9"),Motif="Seal"},
            [1]={Name="Warden of the Last Arch",Scale=2.1,Width=1.3,Color=rgb("172A30"),Mask=rgb("C6D0D9"),Motif="Arch"},
        }},
    QA={Duration=10,Drain=3,SpawnInterval=0.4,Overfill=4,Samples=600,ReportPrefix="[Mysteries visual QA] ",MaxReports=12,Scale=0.3,Priority=1},
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
        Hit={Id=0,Volume=0.16},Abilities={["Enemy.Intro"]=0,["Enemy.Phase"]=0,["Enemy.Death"]=0,["Enemy.Melee"]=0,["Enemy.Spell"]=0,["Trigger.SubstituteTriggered"]=0,["Trigger.GraftReflected"]=0,["Trigger.PayloadTriggered"]=0},MaxPlaying=8,AbilityVolume=0.4,MinPitch=0.5,MaxPitch=2},
    Camera={MinZoom=8,MaxZoom=32},
    Choreography={BodyGain=1.3,ArmGain=1.18,MaxPoseDegrees=125,RecoilGain=0.12,WindupSnap=0.08,WindupStart=0.75,WindupFade=0.045,ReleaseStrike=0.2,FollowEnd=0.55,
        Recovery=0.82,FollowOvershoot=0.24,MeleeDuration=0.34,UltimateDuration=0.9},
    CameraFeel={SmallStuds=0.10,MajorStuds=0.22,SmallDegrees=0.25,MajorDegrees=0.55,
        Attack=0.018,SettlePower=3,
        SmallDuration=0.12,MajorDuration=0.22,FovKick=1.8,MaxFovKick=2.5,FovMin=1,FovMax=120,
        Frequency=11,HitStop=0.045,MaxHitStop=0.06,StepCap=0.05,Epsilon=0.00001,DefaultTier=1,MajorTier=3,
        BeforePriorityOffset=-1,AfterPriorityOffset=1,KickGap=0.10,
        ShakeAxis={X=1,Y=0.6,Z=0.35},RotationAxis={X=0.5,Y=1,Z=0.4},
        FrequencyRatio={X=1,Y=0.83,Z=1.17},Phase={X=0,Y=1.7,Z=3.2}},
    Visuals={FlashGap=0.34,FlashOpacity=0.16,MaxDistance=120,LegacyPriority=1,
        LegacyLife=0.5,LegacyStart=1,LegacyEnd=7,LegacyAlpha=0.25,RevealPriority=3,
        GrayscaleSaturation=-1,AnimationViewDistance=120},
    AbilityUI={StoredSize=14,StoredPad=3,StoredSymbol="◆",StoredPrefix="Stored: ",CastGrace=1,PowerNames={ArcBolt="Arc Bolt"},
        UltimateLocked="Seq 4",UltimatePartial="Saint",UltimateComplete="Angel",DashReady="Dash [Q]",WalkLabel="Walk [Ctrl]",RunLabel="Run [Ctrl]"},
    StatusUI={Width=160,Height=28,TextSize=13,Max=4,MobileMax=2,Distance=40,OffsetStuds=3.8,BackgroundAlpha=0.1,
        Priorities={Controlled=100,Threaded=95,Parasite=90,Payload=85,Stasis=80,Grafted=75,MythicalForm=72,Substitute=70},RequiredThreads=3},
    TestRoom={Width=420,Height=540,Margin=12,Header=48,Row=44,Gap=8,Pad=12,StatusHeight=54,
        PreviewDistance=14,PreviewHeight=-2,PreviewSpacing=8,TargetOffset=8,
        FloorSize={32,0.15,26,2,3,1},HeadSize=1.5,HeadHeight=2.2,FloorAlpha=0.25,FloorOffset=-3,ButtonColumns=3,
        DefaultTier=1,DefaultPalette="Seer",StatInterval=0.25,PreviewDamage=24,OrientationEpsilon=0.01,
        AbilityOffset=-7,PreviewBeyond=10,PreviewDoorSize={7,9,0.3}},
    Input={Keys={Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four,Enum.KeyCode.Five,Enum.KeyCode.Six},
        KeyNames={"1","2","3","4","5","6"},Ultimate=Enum.KeyCode.R,UltimateName="R",Dash=Enum.KeyCode.Q,DashName="Q",
        SprintLeft=Enum.KeyCode.LeftControl,SprintRight=Enum.KeyCode.RightControl,SprintName="Ctrl",
        Journal=Enum.KeyCode.B,Developer=Enum.KeyCode.F8,
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
            TooltipWidth=300,TooltipHeight=44,TooltipGap=10,DashedCount=3,DashInset=0.12,DashLength=0.16,DashThickness=1,
            SealSize=0.42,CostPad=2,UltimateGap=8,AuxWidth=84,AuxHeight=44,AuxGap=6},
        Modal={Header=54,Tabs=44,Footer=30,Gap=8,BodyPad=12,Close=44,NavGap=6,RowHeight=72,
            AbilityRow=84,SlotHeight=44,SectionGap=12,Icon=44,Bottle=80,PreviewHeight=152,
            ConfirmHeight=44,CardWidth=440,CardHeight=388,TitleHeight=36,TabMinimum=64},
        Notice={Width=560,Height=48,CompactHeight=36,BottomGap=18},Advance={Width=560,Height=100,Top=84},
        Cast={Width=236,Height=34,CenterOffset=66,Track=3,Reticle=14},
        Actions={Width=100,Height=44,Gap=8,Bottom=32,PhoneBottom=218,TouchSize=48},
        Developer={Width=400,Height=524,Top=72,Pad=12,Row=44,Gap=8,Columns=3,
            ButtonWidth=88,ButtonHeight=44,ButtonGap=8},
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
        Card={{{0.26,0.12},{0.74,0.12},{0.74,0.88},{0.26,0.88},{0.26,0.12}},{{0.5,0.32},{0.64,0.5},{0.5,0.68},{0.36,0.5},{0.5,0.32}}},
        Flame={{{0.5,0.10},{0.74,0.44},{0.68,0.78},{0.5,0.90},{0.32,0.78},{0.26,0.44},{0.5,0.10}},{{0.5,0.38},{0.58,0.64},{0.5,0.80},{0.42,0.64},{0.5,0.38}}},
        Mask={{{0.20,0.24},{0.5,0.14},{0.80,0.24},{0.74,0.68},{0.5,0.88},{0.26,0.68},{0.20,0.24}},{{0.30,0.44},{0.44,0.44}},{{0.56,0.44},{0.70,0.44}}},
        Scale={{{0.5,0.14},{0.5,0.86}},{{0.18,0.34},{0.82,0.34}},{{0.18,0.34},{0.12,0.62},{0.28,0.62},{0.18,0.34}},{{0.82,0.34},{0.72,0.62},{0.88,0.62},{0.82,0.34}}},
        Crown={{{0.16,0.76},{0.16,0.34},{0.38,0.54},{0.5,0.20},{0.62,0.54},{0.84,0.34},{0.84,0.76},{0.16,0.76}}},
        Hourglass={{{0.24,0.14},{0.76,0.14},{0.24,0.86},{0.76,0.86},{0.24,0.14}},{{0.36,0.5},{0.64,0.5}}},
        Arch={{{0.18,0.90},{0.18,0.36},{0.5,0.12},{0.82,0.36},{0.82,0.90}},{{0.34,0.90},{0.34,0.46},{0.5,0.28},{0.66,0.46},{0.66,0.90}}},
        Circle={{{0.5,0.12},{0.78,0.24},{0.88,0.5},{0.78,0.76},{0.5,0.88},{0.22,0.76},{0.12,0.5},{0.22,0.24},{0.5,0.12}}},
        Key={{{0.4,0.12},{0.6,0.12},{0.7,0.25},{0.6,0.4},{0.4,0.4},{0.3,0.25},{0.4,0.12}},{{0.5,0.4},{0.5,0.9},{0.7,0.9}},{{0.5,0.72},{0.65,0.72}}},
        Clock={{{0.5,0.08},{0.5,0.2}},{{0.9,0.5},{0.78,0.5}},{{0.5,0.92},{0.5,0.8}},{{0.1,0.5},{0.22,0.5}},{{0.5,0.5},{0.5,0.3}},{{0.5,0.5},{0.68,0.6}}},
        Cut={{{0.25,0.85},{0.7,0.15}},{{0.4,0.85},{0.85,0.15}}},
        Worm={{{0.22,0.84},{0.18,0.62},{0.36,0.46},{0.64,0.44},{0.78,0.28},{0.58,0.14},{0.32,0.20}},{{0.28,0.66},{0.44,0.58}},{{0.52,0.40},{0.68,0.34}}},
        Wing={{{0.16,0.76},{0.46,0.48},{0.84,0.24}},{{0.30,0.84},{0.58,0.58},{0.86,0.40}}},
    },
    AbilityGlyphs={
        Seer_9="Card",Seer_9_Secondary="Eye",Seer_8="Circle",Seer_8_Secondary="Scale",
        Seer_7="Flame",Seer_7_Secondary="Card",Seer_6="Mask",Seer_6_Secondary="Circle",
        Seer_5="Thread",Seer_5_Secondary="Thread",Seer_4="Thread",Seer_4_Secondary="Mask",
        Seer_3="Hourglass",Seer_3_Secondary="Hourglass",Seer_2="Star",Seer_2_Secondary="Star",
        Seer_1="Thread",Seer_1_Secondary="Crown",
        Marauder_9="Split",Marauder_9_Secondary="Split",Marauder_8="Split",Marauder_8_Secondary="Cut",
        Marauder_7="Book",Marauder_7_Secondary="Split",Marauder_6="Split",Marauder_6_Secondary="Cut",
        Marauder_5="Split",Marauder_5_Secondary="Cut",Marauder_4="Thread",Marauder_4_Secondary="Split",
        Marauder_3="Mask",Marauder_3_Secondary="Crown",Marauder_2="Cut",Marauder_2_Secondary="Star",
        Marauder_1="Clock",Marauder_1_Secondary="Clock",
        Apprentice_9="Key",Apprentice_9_Secondary="Key",Apprentice_8="Star",Apprentice_8_Secondary="Circle",
        Apprentice_7="Star",Apprentice_7_Secondary="Arch",Apprentice_6="Book",Apprentice_6_Secondary="Book",
        Apprentice_5="Door",Apprentice_5_Secondary="Key",Apprentice_4="Door",Apprentice_4_Secondary="Seal",
        Apprentice_3="Arch",Apprentice_3_Secondary="Door",Apprentice_2="Book",Apprentice_2_Secondary="Arch",
        Apprentice_1="Key",Apprentice_1_Secondary="Seal",
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


## src/ReplicatedStorage/Shared/VfxConfig.lua

**ModuleScript** at `ReplicatedStorage/Shared/VfxConfig`. Create matching Folder parents.

```lua
--!strict
-- Original procedural visuals. Empty texture/sound IDs need no uploaded assets.
local freeze=require(script.Parent.Freeze)
local T=require(script.Parent.Theme)
local Anim=require(script.Parent.AnimConfig)
return freeze({
    Palettes={
        Seer={Primary=T.Colors.Fog,Secondary=T.Colors.DeepPurple,Accent=T.Colors.Gold},
        Marauder={Primary=T.Colors.Crimson,Secondary=T.Colors.Black,Accent=T.Colors.Bronze},
        Apprentice={Primary=T.Colors.Teal,Secondary=T.Colors.Silver,Accent=T.Colors.Starlight},
    },
    TierSequences={Low=7,Middle=4},
    Tier={
        {Scale=1,Emission=0.7}, -- Sequence 9-7
        {Scale=1.35,Emission=1}, -- Sequence 6-4
        {Scale=1.7,Emission=1.2}, -- Sequence 3-1; no full-screen geometry
    },
    Quality={LowLevel=3,MediumLevel=6,AutoLevel=5,Low=0.35,Medium=0.65,High=1,
        Near=30,Middle=70,MaximumDistance=120,FarScale=0.5,MiddleScale=0.75,
        LowEffects=4,MediumEffects=8,HighEffects=16,MobileEffects=8},
    Pools={
        Desktop={Part=160,Attachment=192,Beam=96,Trail=16,ParticleEmitter=24,PointLight=4,Highlight=8},
        Mobile={Part=96,Attachment=112,Beam=56,Trail=8,ParticleEmitter=12,PointLight=2,Highlight=4},
    },
    Lifetime={Default=0.8,Maximum=8,MaxStep=0.1},
    Protocol={MaxReveals=16,RevealLife=5,MaxAge=8,FutureTolerance=2,ResultGrace=1,MaxOwners=64,MaxStatuses=16,
        MaxAffected=4,MaxTrackedStatuses=256,MaxStatusRecords=64,MaxStatusLife=60,SyncInterval=5},
    Status={Retry=0.5,Lease=8,GatePriority=2,MaxGatePairs=8,MaxEchoes=8,EchoAlpha=0.4,EchoColor=T.Colors.Fog,
        Private={Threaded=true,Parasite=true,Payload=true,Disguised=true,Concealed=true,Vision=true,CipherSight=true,Substitute=true,Composed=true,Shielded=true,Invulnerable=true},
        Labels={Threaded="Threads",Controlled="Controlled",Parasite="Parasitized",Payload="Payload",Confused="Confused",Silenced="Silenced",Sleep="Asleep",
            Deceived="Deceived",TimeSlow="Slowed",Stasis="Stasis",Burning="Burning",Grafted="Grafted",Disguised="Disguised",Concealed="Concealed",
            Vision="Spirit sight",CipherSight="Cipher sight",Substitute="Substitute armed",Composed="Composed",Shielded="Shielded",MythicalForm="Mythical Form",Invulnerable="Evading"}},
    Composition={MaxLayers=6,MaxAnchors=12,MobileDetail=0.35,Priority=3,WindupPriority=2,ResultLife=0.85,CancelFade=0.12,MinWidth=0.04,MobileMinWidth=0.06},
    Melee={TrailLife=0.34,ImpactLife=0.32,ArcSpan=2.4,ArcForward=2.6,ArcHeight=0.45,SlashScale=0.42,ImpactScale=0.48,
        Windup=0.06,ArcEndForward=3.6,ArcCurve=1.7,TrailScale=0.38,MotifScale=0.48,MotifDelay=0.12},
    Dash={Life=0.42,Scale=0.42},
    Ultimate={Life=1.8,IncompleteScale=0.85,CompleteScale=1.3,Release=0.18,Aftermath=0.46,
        GestureHeight=1.8,GroundOffset=-2.7,IntakeScale=0.65,DomainScale=1.45,VeilHeight=5.4},
    Cinematic={Intake=0.16,Release=0.08,Aftermath=0.24,SigilSpin=0.45,RuneSpin=0.18,
        VeilSway=0.22,DoorDepth=0.30,DoorOpen=0.16,BeamDraw=0.09,TrailTravel=0.16,
        SaintScale=1.12,AngelScale=1.25,VeilHeight=3.8,IntakeRadius=0.2,Afterglow=0.95},
    Ability={GroundOffset=-2.8,HandHeight=0.5,ReadHeight=1.8,DefaultScale=0.38,
        WindupScale=0.42,EyeScale=1,ReadGroundDetail=0.35,TransferScale=0.3,DoorScale=1,
        FlameScale=0.45,TravelScale=1,EndpointLife=0.75,PickpocketLife=0.65,TheftLife=0.85,
        FlameTint=T.Colors.Warm,FlameRim=T.Colors.Fog,TheftTint=T.Colors.Crimson,DoorMargin=0.12,EndpointOffset=0.1,
        RevealFill=0.9,RevealOutline=0.15,RevealPriority=2,StoredScale=0.24,StoredAlpha=0.35,
        EyeGlyph="Eye",LowEyeGlyph="EyeLow",TheftGlyph="Split",DoorGlyph="Door",LowDoorGlyph="DoorLow",
        Profiles=Anim.AbilityProfiles,
        Detail=0.35,Life=1.1,Small=0.3,Medium=0.6,Large=0.9,VeilScale=0.65,
        HeadHeight=1.8,ChestHeight=0.5,GhostSpacing=2,CornerScale=0.35,GateStarScale=0.3,GateStarOffset=0.35,
        LowAreaSegments=4,NormalAreaSegments=12,ThreadScale=0.45,RecallOffset=0.6,DepthOffset=0.3,
        TriggerLife=0.8,
        PreviewRadius=4,
        WindupGlyphs={
            Divination="Card",Reading="Eye",Acrobat="Circle",Composure="Scale",Flame="Flame",Paper="Card",
            Veil="Mask",Voice="Circle",Puppet="Thread",Command="Thread",Exchange="Thread",Illusion="Mask",
            History="Hourglass",Recovery="Hourglass",Miracle="Star",MiracleMend="Star",Graft="Thread",Domain="Crown",
            Pickpocket="Split",Stealth="Split",Deceit="Split",Misdirection="Cut",Decipher="Book",Interpret="Split",
            Theft="Split",EnergyTheft="Cut",Thought="Split",Dream="Cut",Parasite="Thread",Siphon="Split",
            Mentor="Mask",Belief="Crown",Destiny="Cut",Payload="Star",Time="Clock",TimeDelay="Clock",
            Threshold="Key",Passage="Key",Trick="Star",Wind="Circle",Astrology="Star",Ward="Arch",
            Record="Book",Release="Book",Travel="Door",Door="Key",Conceal="Door",Seal="Seal",
            Wandering="Arch",Pocket="Door",Replica="Book",Planar="Arch",Gate="Key",Closure="Seal",
        },
        Defaults={Seer="RingBurst",Marauder="GlitchFlicker",Apprentice="DoorFrame"},
        Pilots={"Seer_9_Secondary","Seer_7","Marauder_9","Marauder_6","Apprentice_9","Apprentice_5"}},
    DefaultCosts={Part=1,Attachment=8,Beam=4},
    Safety={MinimumPulseInterval=1/3,MaximumLightsPerEffect=1,PositionLimit=1000000},
    Part={Size=Vector3.new(0.05,0.05,0.05),Color=T.Colors.Fog,Transparency=1,
        Material=Enum.Material.Neon,Shape=Enum.PartType.Block},
    Attachment={CFrame=CFrame.identity},
    -- Rate stays zero: explicit bounded bursts only; no texture means geometric fallback.
    Particle={Texture="",Rate=0,Lifetime=NumberRange.new(0.35,0.65),Speed=NumberRange.new(0.5,1.5),
        SpreadAngle=Vector2.new(18,18),Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.10),NumberSequenceKeypoint.new(1,0)}),
        Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.35),NumberSequenceKeypoint.new(1,1)}),
        Color=ColorSequence.new(T.Colors.Fog,T.Colors.Gold),LightEmission=0.15,LightInfluence=0.8,
        Drag=1.5,Acceleration=Vector3.new(0,0.7,0),Rotation=NumberRange.new(0,180),RotSpeed=NumberRange.new(-15,15),
        VelocityInheritance=0,LockedToPart=false,Orientation=Enum.ParticleOrientation.FacingCamera,
        EmissionDirection=Enum.NormalId.Top,ZOffset=0,TimeScale=1},
    Beam={Texture="",TextureLength=1,TextureSpeed=0,TextureMode=Enum.TextureMode.Stretch,
        Width0=0.055,Width1=0.055,Segments=12,CurveSize0=0,CurveSize1=0,FaceCamera=true,
        Transparency=NumberSequence.new(0.25),Color=ColorSequence.new(T.Colors.Gold),
        LightEmission=0.1,LightInfluence=0.9,ZOffset=0},
    Trail={Texture="",TextureLength=1,TextureMode=Enum.TextureMode.Stretch,Lifetime=0.22,MinLength=0.03,MaxLength=8,
        WidthScale=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),
        Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.4),NumberSequenceKeypoint.new(1,1)}),
        Color=ColorSequence.new(T.Colors.Fog,T.Colors.Gold),LightEmission=0.1,LightInfluence=0.9,FaceCamera=true},
    Light={Enabled=false,Brightness=0,Range=0,Shadows=false,Color=T.Colors.Gold},
    Highlight={FillTransparency=0.65,OutlineTransparency=1,FillColor=T.Colors.Hit,OutlineColor=T.Colors.Fog,
        DepthMode=Enum.HighlightDepthMode.Occluded},
    Hit={Life=0.26,HighlightFill=0.65,Outline=1,KnockbackDistance=0.35,KnockbackLife=0.18,
        DeathLife=0.8,DeathMotes=6,Priority=5,RevealPriority=2,RevealLife=T.Timing.Reveal,
        Costs={Highlight=1,Part=1},DeathCosts={},MinimumHealth=0,MaxParts=12,DeathHold=2.1,
        GhostAlpha=0.65,MinFlashGap=0.34},
    Blocks={
        Common={HostSize=0.05,Width=0.055,Alpha=0.25,Segments=12,MinSegments=4,FadeStart=0.18,
            HeightOffset=0.10,ParticleCount=8,ParticleEmitScale=1,MoteThickness=0.06,MinimumLength=0.01,TangentVertical=0.95},
        RingBurst={Duration=0.7,Priority=2,Radius=3,Start=0.35,Gap=0.25},
        RisingMotes={Duration=1.2,Priority=1,Count=6,Height=3,Radius=1.8,Size=0.10,Orbit=0.3},
        ThreadBeam={Duration=0.85,Priority=3,Length=7,Height=2,Width=0.045,Segments=16,Taper=0.55},
        DoorFrame={Duration=1.1,Priority=3,Width=3,Height=5,Nested=2,Inset=0.3,Base=0.1},
        StarBurst={Duration=0.65,Priority=2,Radius=2.4,Inner=0.3,Points=4,Start=0.35},
        GlitchFlicker={Duration=1.1,Priority=2,Width=3,Height=3,Shift=0.3,Transitions=2,Split=0.2},
        GroundRune={Duration=1.2,Priority=2,Radius=3,Inner=0.65,Spokes=4},
        ImpactFlash={Duration=0.32,Priority=4,Radius=0.9,Inner=0.35,Alpha=0.42},
        ScreenEdgePulse={Duration=0.5,Priority=4},
        ShockwaveRing={Duration=0.8,Priority=2,Radius=4,Start=0.4},
        AfterimageTrail={Duration=1,Priority=2,Length=5,Height=2,Width=0.12,Head=0.18},
        SigilStencil={Duration=0.85,Priority=3,Size=1.5,IntakeCount=2,IntakeSize=0.09,Paths={
            Eye=T.Glyphs.Eye,Split=T.Glyphs.Split,Door=T.Glyphs.Door,
            Book=T.Glyphs.Book,Star=T.Glyphs.Star,Thread=T.Glyphs.Thread,Seal=T.Glyphs.Seal,
            Card=T.Glyphs.Card,Flame=T.Glyphs.Flame,Mask=T.Glyphs.Mask,Scale=T.Glyphs.Scale,
            Crown=T.Glyphs.Crown,Hourglass=T.Glyphs.Hourglass,Arch=T.Glyphs.Arch,Circle=T.Glyphs.Circle,
            Key=T.Glyphs.Key,Clock=T.Glyphs.Clock,Cut=T.Glyphs.Cut,Worm=T.Glyphs.Worm,Wing=T.Glyphs.Wing,
            EyeLow={{{0,0.5},{0.5,0.2},{1,0.5},{0.5,0.8},{0,0.5}}},
            DoorLow={{{0.24,0.9},{0.24,0.15},{0.76,0.15},{0.76,0.9}}},
            CardLow={{{0.26,0.12},{0.74,0.12},{0.74,0.88},{0.26,0.88},{0.26,0.12}}},
            FlameLow={{{0.5,0.10},{0.72,0.55},{0.5,0.90},{0.28,0.55},{0.5,0.10}}},
            MaskLow={{{0.20,0.24},{0.80,0.24},{0.5,0.88},{0.20,0.24}}},
            ScaleLow={{{0.5,0.14},{0.5,0.86}},{{0.18,0.34},{0.82,0.34}}},
            CrownLow={{{0.16,0.76},{0.32,0.30},{0.5,0.60},{0.68,0.30},{0.84,0.76}}},
            HourglassLow={{{0.24,0.14},{0.76,0.14},{0.24,0.86},{0.76,0.86},{0.24,0.14}}},
            ArchLow={{{0.18,0.90},{0.18,0.36},{0.5,0.12},{0.82,0.36},{0.82,0.90}}},
            CircleLow={{{0.5,0.12},{0.88,0.5},{0.5,0.88},{0.12,0.5},{0.5,0.12}}},
            WormLow={{{0.22,0.84},{0.36,0.46},{0.78,0.28},{0.32,0.20}}},
        }},
        CardFan={Duration=1.1,Priority=3,Count=3,LowCount=1,Size=Vector3.new(0.55,0.85,0.025),Spread=18,Offset=0.22,Color=T.Colors.Text,Alpha=0.15},
        PaperFold={Duration=1.1,Priority=3,Color=T.Colors.Text,Alpha=0.15,BreakDistance=1.2,
            Pieces={{0,0.6,0,0.26,0.26,0.04},{0,0.12,0,0.35,0.55,0.04},{-0.3,0.25,0,0.35,0.14,0.04},{0.3,0.25,0,0.35,0.14,0.04},
                {-0.12,-0.4,0,0.14,0.5,0.04},{0.12,-0.4,0,0.14,0.5,0.04}},LowPieces={1,2,5,6}},
        VeilRibbon={Duration=1.1,Priority=3,Count=2,LowCount=1,Width=0.14,Height=2.8,Offset=0.8,Curve=0.55,Alpha=0.6},
        ContourEcho={Duration=1.1,Priority=3,Alpha=0.72,Drift=0.35,
            Pieces={{0,1.7,0,0.7,0.7,0.35},{0,0.7,0,1.1,1.4,0.3},{-0.8,0.7,0,0.35,1.3,0.25},{0.8,0.7,0,0.35,1.3,0.25},
                {-0.3,-0.6,0,0.4,1.2,0.25},{0.3,-0.6,0,0.4,1.2,0.25}},LowPieces={1,2,5,6}},
    },
})
```


## src/ReplicatedStorage/Shared/VisualBudget.lua

**ModuleScript** at `ReplicatedStorage/Shared/VisualBudget`. Create matching Folder parents.

```lua
--!strict
-- Pure admission policy: reservations are atomic; equal/higher priority effects survive.
local Budget={}
Budget.__index=Budget
type Counts={ [string]: number }
type Entry={Costs: Counts, Priority: number, Serial: number}
type Fields={Limits: Counts,Used: Counts,MaxEffects: number,Count: number,Serial: number,Entries:{[string]: Entry}}
export type VisualBudget=typeof(setmetatable({} :: Fields,Budget))
local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end
local function valid(costs: Counts,limits: Counts): boolean
    for class,count in pairs(costs) do
        if type(count)~="number" or not finite(count) or count<0 or count%1~=0 or limits[class]==nil or count>limits[class] then return false end
    end
    return true
end
function Budget.new(limits: Counts,maxEffects: number): VisualBudget
    assert(finite(maxEffects) and maxEffects>0 and maxEffects%1==0,"Invalid effect cap")
    local used: Counts={}
    for class,count in pairs(limits) do
        assert(finite(count) and count>=0 and count%1==0,"Invalid pool cap")
        used[class]=0
    end
    return setmetatable({Limits=table.clone(limits),Used=used,MaxEffects=maxEffects,Count=0,Serial=0,Entries={}},Budget)
end
local function fits(self: VisualBudget,costs: Counts,used: Counts,count: number): boolean
    if count>=self.MaxEffects then return false end
    for class,cost in pairs(costs) do
        if (used[class] or 0)+cost>self.Limits[class] then return false end
    end
    return true
end
function Budget.Plan(self: VisualBudget,costs: Counts,priority: number): {string}?
    if not finite(priority) or not valid(costs,self.Limits) then return nil end
    local used=table.clone(self.Used)
    if fits(self,costs,used,self.Count) then return {} end
    local candidates: {{Id:string,Entry:Entry}}={}
    for id,entry in pairs(self.Entries) do
        if entry.Priority<priority then table.insert(candidates,{Id=id,Entry=entry}) end
    end
    table.sort(candidates,function(a,b)
        return if a.Entry.Priority==b.Entry.Priority then a.Entry.Serial<b.Entry.Serial else a.Entry.Priority<b.Entry.Priority
    end)
    local victims: {string}={}
    local count=self.Count
    for _,candidate in ipairs(candidates) do
        table.insert(victims,candidate.Id);count-=1
        for class,cost in pairs(candidate.Entry.Costs) do used[class]-=cost end
        if fits(self,costs,used,count) then return victims end
    end
    return nil
end
function Budget.Add(self: VisualBudget,id: string,costs: Counts,priority: number): boolean
    if self.Entries[id] or not finite(priority) or not valid(costs,self.Limits) or not fits(self,costs,self.Used,self.Count) then return false end
    self.Serial+=1;self.Count+=1
    self.Entries[id]={Costs=table.clone(costs),Priority=priority,Serial=self.Serial}
    for class,count in pairs(costs) do self.Used[class]+=count end
    return true
end
function Budget.Remove(self: VisualBudget,id: string)
    local entry=self.Entries[id]
    if not entry then return end
    self.Entries[id]=nil;self.Count-=1
    for class,count in pairs(entry.Costs) do self.Used[class]-=count end
end
function Budget.Stats(self: VisualBudget): any
    return {Count=self.Count,Used=table.clone(self.Used),Limits=table.clone(self.Limits),MaxEffects=self.MaxEffects}
end
return Budget
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
    local ultW=p.Slot+p.BarPad*2
    local ultimate=rectangle(bar.X+bar.W+l.Hotbar.UltimateGap,bar.Y,ultW,bar.H)
    if ultimate.X+ultimate.W>width-p.Margin then
        ultimate=rectangle(math.max(p.Margin,action.X-l.Hotbar.UltimateGap-ultW),action.Y,ultW,l.Actions.Height)
    end
    local auxW=math.max(48,math.min(l.Hotbar.AuxWidth,math.floor((bar.W-l.Hotbar.AuxGap)/2)))
    local dashRect=rectangle(math.max(p.Margin,bar.X-l.Hotbar.UltimateGap-auxW*2-l.Hotbar.AuxGap),bar.Y+(bar.H-l.Hotbar.AuxHeight)/2,auxW,l.Hotbar.AuxHeight)
    local sprintRect=rectangle(dashRect.X+auxW+l.Hotbar.AuxGap,dashRect.Y,auxW,l.Hotbar.AuxHeight)
    if dashRect.X<=p.Margin or Layout.Intersects(dashRect,pathway,l.Modal.Gap) then
        local rowY=if touch then action.Y else math.max(p.Margin,bar.Y-l.Hotbar.AuxHeight-l.Hotbar.AuxGap)
        dashRect=rectangle(bar.X,rowY,auxW,l.Hotbar.AuxHeight)
        sprintRect=rectangle(bar.X+auxW+l.Hotbar.AuxGap,rowY,auxW,l.Hotbar.AuxHeight)
    end
    return {Name=name,Profile=p,Width=width,Height=height,Resources=resources,Hotbar=bar,Pathway=pathway,
        CanExpand=expandedFits,DefaultCollapsed=touch or name=="Phone" or not expandedFits,
        Wordmark=wordmark,
        Journal=rectangle(width-p.Margin-p.JournalButton[1],p.Margin,p.JournalButton[1],p.JournalButton[2]),
        Modal=rectangle((width-modalW)/2,(height-modalH)/2,modalW,modalH),
        Confirm=rectangle((width-confirmW)/2,(height-confirmH)/2,confirmW,confirmH),
        Notice=notice,Action=action,Ultimate=ultimate,Dash=dashRect,Sprint=sprintRect,
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
function Model.Ultimate(data: any,state: any,elapsed: number): any
    local u=data and data.Runtime and data.Runtime.Ultimate
    if not u or not state or not state.Ready or not state.PathwayId or type(state.Sequence)~="number" then
        return {Unlocked=false,Stage=false,Name="Mythical Form",Title="Unlocks at Sequence 4 (Saint)",Active=false,Remaining=0,Duration=10,Cooldown=0,Cost=u and u.SpiritualityCost or 45}
    end
    local form=u.Forms[state.PathwayId] or u.Forms.Seer
    local unlocked=state.Sequence<=u.UnlockSequence
    local stage=if not unlocked then false elseif state.Sequence<=u.CompleteSequence then "Complete" else "Incomplete"
    local duration=if stage=="Complete" then u.CompleteDuration else u.IncompleteDuration
    local remaining=if state.UltimateStage then math.max(0,(state.UltimateRemaining or 0)-math.max(0,elapsed)) else 0
    local active=unlocked and remaining>0
    local cd=Model.Cooldown(state,"Ultimate",elapsed)
    local title=if not unlocked then form.Name.." · Locked until Sequence 4 (Saint)"
        elseif stage=="Complete" then form.CompleteTitle
        else form.IncompleteTitle
    return {
        Unlocked=unlocked,
        Stage=stage,
        Name=form.Name,
        Title=title,
        Active=active,
        Remaining=remaining,
        Duration=duration,
        Cooldown=cd,
        Cost=u.SpiritualityCost,
        SanityCost=if stage=="Complete" then u.CompleteSanityCost else u.IncompleteSanityCost,
    }
end
return table.freeze(Model)
```


## src/ServerScriptService/AdminConfig.lua

**ModuleScript** at `ServerScriptService/AdminConfig`. Create matching Folder parents.

```lua
--!strict
-- Server-only allowlist. Roblox resolves these configured usernames to numeric IDs.
-- Add numeric IDs for stable access after a username change. Never accept client names.
return table.freeze({AdminUserIds=table.freeze({}),AdminUsernames=table.freeze({"johnskie816"}),
    LookupAttempts=3,LookupRetrySeconds=2})
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
local adminIds=table.clone(AdminConfig.AdminUserIds)
task.spawn(function()
    for _,username in ipairs(AdminConfig.AdminUsernames) do
        local resolved=false
        for attempt=1,AdminConfig.LookupAttempts do
            local ok,id=pcall(function() return Players:GetUserIdFromNameAsync(username) end)
            if ok and type(id)=="number" and id>0 and id%1==0 then
                if not table.find(adminIds,id) then table.insert(adminIds,id) end
                resolved=true;break
            end
            if attempt<AdminConfig.LookupAttempts then task.wait(AdminConfig.LookupRetrySeconds) end
        end
        if not resolved then warn("Admin username could not be resolved: "..username..". Configure its numeric ID in AdminConfig.") end
    end
end)
local function isDeveloper(player: Player): boolean
    return Access.IsDeveloper(player.UserId,game.CreatorId,game.CreatorType==Enum.CreatorType.User,adminIds)
end
local Domain=require(script.Parent.Domain.PlayerDomain)
local AdminProgression=require(script.Parent.Domain.AdminProgression)
local Sessions=require(script.Parent.Domain.SessionStore)
local RateLimiter=require(script.Parent.Domain.RateLimiter)
local World=require(script.Parent.Services.WorldService)
local Effects=require(script.Parent.Services.EffectService)
local VisualEvents=require(script.Parent.Services.VisualEventService)
local VfxConfig=require(ReplicatedStorage.Shared.VfxConfig)
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
local visualEvents=VisualEvents.new(world,VfxConfig.Protocol,function() return workspace:GetServerTimeNow() end,VfxConfig.Status)
world.Visuals=visualEvents
local effects=Effects.new(world,domain,notify)
world:Build()
local function applyStats(player: Player,s: any,refill: boolean)
    local hum=world:Humanoid(player)
    if not hum then return end
    hum.MaxHealth=s.Stats.Health
    if refill then hum.Health=s.Stats.Health else hum.Health=math.min(hum.Health,hum.MaxHealth) end
    hum.WalkSpeed=domain:MoveSpeed(s,os.clock())
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
    local myth=s.Statuses.MythicalForm
    local mythActive=myth and myth.ExpiresAt>now
    local mythStage=if mythActive then (myth.Stage or "Incomplete") else false
    local mythRemaining=if mythActive then math.max(0,myth.ExpiresAt-now) else 0
    local character=player.Character
    if character then
        character:SetAttribute("MysteriesPathway",p.PathwayId or "")
        character:SetAttribute("MysteriesSequence",p.Sequence or 9)
        character:SetAttribute("MysteriesDisguised",s.Statuses.Disguised~=nil)
        character:SetAttribute("MysteriesMythicalForm",mythStage or "")
    end
    stateEvent:FireClient(player,{Ready=true,Developer=isDeveloper(player),
        DeveloperInfo=if isDeveloper(player) then {SessionOnly=sessionOnly,Mode=s.Mode,Ready=s.Ready} else nil,PathwayId=p.PathwayId,Sequence=p.Sequence,
        Digestion=p.Digestion,ActingProgress=p.ActingProgress,Health=s.Health,MaxHealth=s.Stats.Health,
        Spirituality=s.Spirituality,MaxSpirituality=s.Stats.Spirituality,Sanity=s.Sanity,Mode=s.Mode,
        Gold=p.Gold,WishCredits=p.WishCredits,Inventory=Domain.Copy(p.Inventory),Loadout=Domain.Copy(p.AbilityLoadout),
        Cooldowns=cooldowns,Statuses=statuses,Dead=s.Dead,RecordedCharges=s.RecordedPower and s.RecordedPower.Charges or 0,RecordedPowerId=s.RecordedPower and s.RecordedPower.Id or false,StolenPower=s.StolenPower or false,
        Running=s.Running~=false,UltimateStage=mythStage,UltimateRemaining=mythRemaining,
        Casting=s.Pending and s.Pending.Id or false,CastRemaining=s.Pending and math.max(0,s.Pending.EndsAt-now) or 0,CastSerial=s.CastSerial,VisualToken=s.VisualToken or 0})
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
        s.Dead=false;s.Pending=nil;s.Statuses={};s.RecordedPower=nil;s.StolenPower=nil;s.DisguiseUntil=nil;s.OriginalDisplayName=nil;s.UltimateStage=false
        character:SetAttribute("MysteriesMythicalForm","")
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
                current.Dead=true;domain:CancelCast(current,false);current.Statuses={};current.UltimateStage=false
                character:SetAttribute("MysteriesMythicalForm","")
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
        applyStats(player,s,false)
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
    visualEvents:Remove(player)
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
    if action=="Sync" then sendState(player);visualEvents:Sync(player);return end
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
    elseif action=="AdminSet" then
        local hum=world:Humanoid(player)
        local authorized=isDeveloper(player)
        local ok,message=false,"Wait until your character is alive and loaded"
        if not authorized or (hum and hum.Health>0) then
            ok,message=AdminProgression.Apply(domain,s,payload.PathwayId,payload.Sequence,now,authorized)
        end
        if ok then
            effects:RemoveGates(player);world:Cleanup(player);applyStats(player,s,true)
        end
        notify(player,message)
    elseif action=="DevMastery" then
        if isDeveloper(player) and sessionOnly and RunService:IsStudio() and type(payload.PathwayId)=="string" and data.Pathways[payload.PathwayId] then
            local interact=world.OnInteraction
            if interact then interact(player,"Studio:"..payload.PathwayId) end
        end
    elseif action=="Drink" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local ok,message=domain:Drink(s,payload.Id,now)
        if ok then
            applyStats(player,s,true);world:Cleanup(player);effects:RemoveGates(player)
            local root=world:Root(player)
            if root then fx:FireClient(player,{Kind="PotionConfirmed",Position=root.Position,PathwayId=s.Profile.PathwayId,At=workspace:GetServerTimeNow()}) end
        end
        notify(player,message)
    elseif action=="Equip" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local _,message=domain:Equip(s,payload.Slot,payload.Id);notify(player,message)
    elseif action=="ToggleRun" then
        local ok=domain:ToggleRun(s,payload.Running)
        if ok then applyStats(player,s,false) end
    elseif action=="Dash" then
        local root=world:Root(player);local hum=world:Humanoid(player)
        if not root or not world:FiniteVector(root.Position) or not hum or hum.Health<=0 then return end
        local ok,distance,reason=domain:BeginDash(s,now)
        if not ok then notify(player,reason);return end
        local dir=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        if world:FiniteVector(payload.Direction) then
            local cand=Vector3.new(payload.Direction.X,0,payload.Direction.Z)
            if cand.Magnitude>0.05 then dir=cand.Unit end
        end
        if dir.Magnitude<=0.05 then dir=Vector3.new(0,0,-1) else dir=dir.Unit end
        local origin=root.Position
        local destination=origin
        for _,fraction in ipairs({1,0.75,0.5,0.25}) do
            local candidate=origin+dir*(distance*fraction)
            if world:LineOfSight(origin,candidate,player.Character,nil) then
                local safe=world:SafeDestination(player,candidate)
                if safe then destination=safe;break end
            end
        end
        if (destination-origin).Magnitude>0.5 and player.Character then
            s.TeleportGraceUntil=now+(data.Runtime.DashGraceSeconds or 0.75)
            s.LastPosition=destination
            player.Character:PivotTo(CFrame.new(destination)*root.CFrame.Rotation)
            root.AssemblyLinearVelocity=Vector3.zero
        end
        fx:FireAllClients({Kind="Dash",Position=destination,Origin=origin,Destination=destination,
            PathwayId=s.Profile.PathwayId or "Seer",Owner=player.UserId,Character=player.Character,At=workspace:GetServerTimeNow()})
    elseif action=="Ultimate" then
        local root=world:Root(player);local hum=world:Humanoid(player)
        if not root or not world:FiniteVector(root.Position) or not hum or hum.Health<=0 then return end
        local ok,message,info=domain:ActivateUltimate(s,now)
        if not ok or not info then notify(player,message);sendState(player);return end
        applyStats(player,s,false)
        local u=data.Runtime.Ultimate
        local mult=domain:PowerMultiplier(s,now)
        for _,e in ipairs(world:Targets(root.Position,u.PulseRadius,6,player)) do
            if world:LineOfSight(root.Position,e.Root.Position,player.Character,e.Model) then
                world:Damage(e,u.PulseBaseDamage*mult,player,now)
                if info.Form.Status then world:Status(e,info.Form.Status,info.Form.StatusDuration or 4,now,player,u.PulseBaseDamage*0.2) end
            end
        end
        fx:FireAllClients({Kind="UltimateVisual",Position=root.Position,PathwayId=s.Profile.PathwayId,Stage=info.Stage,
            Owner=player.UserId,Character=player.Character,At=workspace:GetServerTimeNow()})
        notify(player,message)
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
        visualEvents:Begin(context,now)
    elseif action=="Melee" then
        local root=world:Root(player)
        if not root or not world:FiniteVector(root.Position) or s.Mode~="Normal" or s.Pending or now-s.LastMelee<data.Runtime.MeleeCooldown then return end
        local canMove=domain:CanMove(s,now)
        if not canMove then return end
        s.LastMelee=now;s.LastCombat=now
        s.MeleeCombo=((s.MeleeCombo or 0)%2)+1
        local direction=root.CFrame.LookVector
        if world:FiniteVector(payload.Position) and (payload.Position-root.Position).Magnitude>0.1 then direction=(payload.Position-root.Position).Unit end
        local hitModel: Instance?=nil
        local hitPos=root.Position+direction*3
        local mult=domain:PowerMultiplier(s,now)
        for _,e in ipairs(world:Targets(root.Position,data.Runtime.MeleeRange,8,player)) do
            local delta=e.Root.Position-root.Position
            if delta.Magnitude<0.1 or delta.Unit:Dot(direction)>0.25 then
                if world:LineOfSight(root.Position,e.Root.Position,player.Character,e.Model) then
                    if world:Damage(e,s.Stats.Strength*data.Runtime.MeleePowerMultiplier*mult,player,now) then
                        hitModel=e.Model;hitPos=e.Root.Position
                    end
                    break
                end
            end
        end
        fx:FireAllClients({Kind="Melee",Position=hitPos,Origin=root.Position,Direction=direction,
            Combo=s.MeleeCombo,PathwayId=s.Profile.PathwayId or "Seer",Owner=player.UserId,Character=player.Character,Target=hitModel})
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
                hum.WalkSpeed=domain:MoveSpeed(s,now)
                -- Horizontal movement guard; server-authorized travel has an explicit grace window.
                if s.LastPosition and now>(s.TeleportGraceUntil or 0) then
                    local horizontal=Vector3.new(root.Position.X-s.LastPosition.X,0,root.Position.Z-s.LastPosition.Z).Magnitude
                    if horizontal>math.max(16,hum.WalkSpeed)*math.min(dt,2)*2+8 then
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
        world:Step(math.min(dt,1),now);effects:Step(now);visualEvents:Step(now)
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


## src/ServerScriptService/Domain/AdminProgression.lua

**ModuleScript** at `ServerScriptService/Domain/AdminProgression`. Create matching Folder parents.

```lua
--!strict
-- Only Bootstrap supplies authorization, derived from the creator/server allowlist.
-- This explicit admin override never runs through normal potion advancement.
local Admin={}
function Admin.Apply(domain: any,state: any,pathway: any,sequence: any,now: number,authorized: boolean): (boolean,string)
    if authorized~=true then return false,"Admin access required" end
    if not state or not state.Ready or state.Dead then return false,"Wait until your character is alive and loaded" end
    if type(pathway)~="string" or #pathway>80 or not domain.Data.Pathways[pathway]
        or not domain.Finite(sequence) or sequence%1~=0 or not domain.Data.Pathways[pathway].Sequences[sequence] then
        return false,"Choose a valid pathway and Sequence 9–1"
    end
    local profile=domain:Snapshot(state)
    profile.PathwayId=pathway;profile.Sequence=sequence
    profile.Digestion=domain.Data.Progression.Digestion.Default
    profile.ActingProgress=domain.Data.Progression.Acting.Default
    profile.ObjectiveProgress={};profile.AbilityLoadout={};profile.Sanity=domain.Data.Progression.Sanity.Max
    local replacement=domain:NewState(profile,now)
    domain:AutoEquip(replacement)
    local serial=state.CastSerial
    -- Keep this state table and its save/movement bookkeeping: autosave callbacks
    -- and Humanoid callbacks can already reference it. Appearance restoration
    -- metadata is retained for EffectService.Step after statuses are cleared.
    for key,value in pairs(replacement) do state[key]=value end
    state.Pending=nil;state.RecordedPower=nil;state.StolenPower=nil;state.AltarTicket=nil
    state.ArchiveRead=nil;state.SecretUntil=nil;state.FailureApplied=false
    state.CastSerial=serial+1
    return true,"Admin: "..pathway.." · Sequence "..sequence.." · "..domain.Data.Pathways[pathway].Sequences[sequence].Name
end
return table.freeze(Admin)
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
        RecordedPower=nil,StolenPower=nil,LastMelee=-100,LastRitual=-100,
        Running=true,MeleeCombo=0,UltimateStage=false}
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
function Domain.CanMove(self: Domain, s: any, now: number): (boolean,string?)
    if not s or not s.Ready or s.Dead or s.Mode~="Normal" then return false,"You cannot move right now" end
    if s.Pending then return false,"Finish casting first" end
    for id,st in pairs(s.Statuses or {}) do
        if st.ExpiresAt>now then
            local def=self.Data.StatusEffects[id]
            if def and (def.MoveMultiplier==0 or def.BlocksAttacks) then
                return false,"Movement is restricted by "..id
            end
        end
    end
    return true,nil
end
function Domain.MoveSpeed(self: Domain, s: any, now: number): number
    local r=self.Data.Runtime
    local running=s.Running~=false
    local base=if running
        then math.clamp((r.RunSpeedBase or 16)+s.Stats.Agility*(r.AgilityRunScale or 0.25),r.RunSpeedBase or 16,r.MaxRunSpeed or 42)
        else math.clamp((r.WalkSpeedBase or 11.5)+s.Stats.Agility*(r.AgilityWalkScale or 0.14),r.WalkSpeedBase or 11.5,r.MaxWalkSpeed or 24)
    local myth=s.Statuses and s.Statuses.MythicalForm
    if myth and myth.ExpiresAt>now and r.Ultimate then
        base=math.min(r.MaxRunSpeed or 42,base+(r.Ultimate.SpeedBonus or 4))
    end
    local mult=1
    for id,st in pairs(s.Statuses or {}) do
        if st.ExpiresAt>now then
            local def=self.Data.StatusEffects[id]
            if def and type(def.MoveMultiplier)=="number" then mult=math.min(mult,def.MoveMultiplier) end
        end
    end
    return base*mult
end
function Domain.ToggleRun(self: Domain, s: any, running: any?): (boolean,string)
    if not s or not s.Ready or s.Dead or s.Mode~="Normal" then return false,"Cannot change pace now" end
    if type(running)=="boolean" then s.Running=running else s.Running=s.Running==false end
    return true,if s.Running then "Running pace" else "Measured walk"
end
function Domain.BeginDash(self: Domain, s: any, now: number): (boolean,number,string)
    local ok,reason=self:CanMove(s,now)
    if not ok then return false,0,reason or "Cannot dash now" end
    if now<(s.Cooldowns.Dash or 0) then return false,0,"Dash is cooling down" end
    local r=self.Data.Runtime
    local mult=1
    for id,st in pairs(s.Statuses or {}) do
        if st.ExpiresAt>now then
            local def=self.Data.StatusEffects[id]
            if def and type(def.MoveMultiplier)=="number" then mult=math.min(mult,def.MoveMultiplier) end
        end
    end
    local dist=(r.DashDistance or 14)*mult
    if dist<=0 then return false,0,"Movement is immobilized" end
    s.Cooldowns.Dash=now+(r.DashCooldown or 2.2)
    return true,dist,"Dash"
end
function Domain.PowerMultiplier(self: Domain, s: any, now: number): number
    local u=self.Data.Runtime and self.Data.Runtime.Ultimate
    local myth=s and s.Statuses and s.Statuses.MythicalForm
    if u and myth and myth.ExpiresAt>now then
        return if myth.Stage=="Complete" then (u.CompletePowerMultiplier or 1.35) else (u.IncompletePowerMultiplier or 1.2)
    end
    return 1
end
function Domain.ActivateUltimate(self: Domain, s: any, now: number): (boolean,string,any?)
    local u=self.Data.Runtime and self.Data.Runtime.Ultimate
    if not u or not s or not s.Ready or s.Dead or s.Mode~="Normal" or s.Pending then return false,"Cannot manifest Mythical Creature Form now",nil end
    local p=s.Profile
    if not p.PathwayId or type(p.Sequence)~="number" or p.Sequence>u.UnlockSequence then
        return false,"Mythical Creature Form unlocks at Sequence 4 (Saint)",nil
    end
    if s.Statuses.MythicalForm and s.Statuses.MythicalForm.ExpiresAt>now then
        return false,"Mythical Creature Form is already active",nil
    end
    if now<(s.Cooldowns.Ultimate or 0) then return false,"Mythical Creature Form is cooling down",nil end
    if s.Spirituality<u.SpiritualityCost then return false,"Not enough spirituality",nil end
    if s.Sanity<=self.Data.Progression.Sanity.BlockAdvancementAtOrBelow then
        return false,"Recover your sanity before manifesting your Mythical Creature Form",nil
    end
    local stage=if p.Sequence<=u.CompleteSequence then "Complete" else "Incomplete"
    local duration=if stage=="Complete" then u.CompleteDuration else u.IncompleteDuration
    local sanityCost=if stage=="Complete" then u.CompleteSanityCost else u.IncompleteSanityCost
    s.Spirituality-=u.SpiritualityCost
    s.LastCast=now; s.LastCombat=now
    self:DrainSanity(s,sanityCost,now)
    if s.Mode~="Normal" then
        return false,"Mythical manifestation overwhelmed your sanity",nil
    end
    s.Cooldowns.Ultimate=now+u.CooldownSeconds
    s.Statuses.MythicalForm={ExpiresAt=now+duration,Stage=stage,PathwayId=p.PathwayId}
    s.UltimateStage=stage
    local form=u.Forms[p.PathwayId] or u.Forms.Seer
    local title=if stage=="Complete" then form.CompleteTitle else form.IncompleteTitle
    return true,title,{Stage=stage,Duration=duration,Form=form}
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
    s.ObjectiveLast={}; s.SeenEvents={}; s.SeenOrder={}; s.Statuses={}; s.UltimateStage=false
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
    local myth=s.Statuses.MythicalForm
    if myth and myth.ExpiresAt>now then
        s.UltimateStage=myth.Stage or "Incomplete"
        if s.UltimateStage=="Incomplete" and not s.Dead and s.Mode=="Normal" then
            local u=self.Data.Runtime and self.Data.Runtime.Ultimate
            local drain=u and u.IncompleteSanityDrainPerSecond or 1.2
            self:DrainSanity(s,drain*dt,now)
            if s.Mode~="Normal" then
                s.Statuses.MythicalForm=nil
                s.UltimateStage=false
            end
        end
    else
        s.UltimateStage=false
    end
    if s.Mode=="Madness" and now>=s.MadnessUntil then s.Mode="LostControl"; s.Health=0; s.Statuses.MythicalForm=nil; s.UltimateStage=false end
    if not s.Dead and s.Mode=="Normal" then
        if now-s.LastCast>=2 then
            local combat=if now-s.LastCombat<5 then self.Data.Progression.Spirituality.CombatRegenMultiplier else 1
            s.Spirituality=math.min(s.Stats.Spirituality,s.Spirituality+s.Stats.SpiritualityRegen*dt*combat)
        end
        if not (s.Statuses.MythicalForm and s.UltimateStage=="Incomplete") then
            s.Sanity=math.min(100,s.Sanity+self.Data.Progression.Sanity.RecoveryPerSecond*dt)
        end
    end
end
function Domain.Recover(self: Domain, s: any): (boolean,string)
    if s.Mode=="Normal" and s.Sanity>=100 then return false,"You are already well" end
    s.Mode="Normal"; s.Sanity=100; s.Statuses={}; s.Pending=nil; s.UltimateStage=false
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
    local visuals=self.World.Visuals
    local before=visuals and visuals:Capture(context)
    local ok,message,evidence=handler(self,context,op,now)
    if visuals then visuals:Result(context,before,ok,evidence,now) end
    if ok then
        local world=self.World
        if not visuals then world:Effect(context.Position,a.Id,context.Player,context.Entity and context.Entity.Model) end
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
local function affected(c: any,e: any)
    c.VisualAffected=c.VisualAffected or {}
    table.insert(c.VisualAffected,{Target=e.Model,Position=e.Root.Position})
end
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
    if self.World.Visuals then self.World.Visuals:Reveal(c,enemies,now)
    else for _,e in ipairs(enemies) do self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=e.Root.Position,Target=e.Model}) end end
    if enemies[1] then
        local e=enemies[1]
        self.Notify(c.Player,"Reading: omen "..tostring(e.Model:GetAttribute("Omen")).." · target HP "..tostring(math.ceil(e.Humanoid.Health)))
    end
    return true,"Spiritual traces revealed"
end
handlers.SenseDoors=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    local revealed={}
    for _,door in ipairs(CollectionService:GetTagged("MysticDoor")) do
        if door:IsA("BasePart") and (door.Position-c.Root.Position).Magnitude<=c.State.Stats.Perception then
            if self.World.Visuals then table.insert(revealed,{Part=door,Position=door.Position})
            else self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=door.Position,Target=door}) end
        end
    end
    if self.World.Visuals then self.World.Visuals:Reveal(c,revealed,now) end
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
    affected(c,foes[1])
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
    c.VisualRadius=radius
    local enemies=self.World:Targets(c.Position,radius,c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No enemies in the area" end
    for _,e in ipairs(enemies) do
        if self.World:LineOfSight(c.Position,e.Root.Position,c.Player.Character,e.Model) then
            self.World:Damage(e,power(c,op),c.Player,now)
            affected(c,e)
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
    c.VisualEcho=e.Model;c.VisualExpires=e.ExpiresAt
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
    c.VisualRadius=math.max(15,c.Ability.RadiusStuds)
    local enemies=self.World:Targets(c.Position,math.max(15,c.Ability.RadiusStuds),c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No hostile attacks to graft" end
    for _,e in ipairs(enemies) do self.World:Status(e,"Grafted",op.Duration or 10,now,c.Player);affected(c,e) end
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
    c.VisualTarget=nearest;c.VisualExpires=self.OpenDoors[nearest]
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
    c.VisualGates=gate.Parts;c.VisualExpires=gate.EndsAt
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
    if gate and self.World.Visuals then self.World.Visuals:RemoveGates(player) end
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


## src/ServerScriptService/Services/VisualEventService.lua

**ModuleScript** at `ServerScriptService/Services/VisualEventService`. Create matching Folder parents.

```lua
--!strict
-- Server-only evidence adapter. It observes accepted casts; it never changes outcomes.
local Visual={}
function Visual.new(world: any,config: any,clock: ()->number,statusConfig: any?): any
    return setmetatable({World=world,Config=config,Clock=clock,Active={},Counters={},StatusRecords={},Revision=0,CueSerial=0,LastSync={},Gates={},Echoes={},StatusConfig=statusConfig or {Labels={},Private={}}},{__index=Visual})
end
function Visual.Packet(self: any,c: any,phase: string,position: any): any
    if not self.World:FiniteVector(position) then return nil end
    return {Kind="AbilityVisual",Phase=phase,AbilityId=c.Ability.Id,Owner=c.Player.UserId,
        Token=c.State.VisualToken or c.State.CastSerial,Character=c.Player.Character,Position=position,Tier=if c.Ability.UnlockSequence>=7 then 1 elseif c.Ability.UnlockSequence>=4 then 2 else 3,
        At=self.Clock()}
end
function Visual.Begin(self: any,c: any,now: number)
    local pending=c.State.Pending
    if not pending then return end
    self.Counters[c.Player]=(self.Counters[c.Player] or 0)+1
    c.State.VisualToken=self.Counters[c.Player]
    local packet=self:Packet(c,"Begin",c.Root.Position)
    if not packet then return end
    packet.EndsAt=packet.At+math.max(0,pending.EndsAt-now)
    self.Active[c.Player]={Ability=c.Ability,Token=packet.Token,DomainToken=pending.Token,Position=packet.Position,Character=c.Player.Character}
    self.World.FX:FireAllClients(packet)
end
function Visual.Capture(self: any,c: any): any
    return {Origin=c.Root.Position,Stored=c.State.StolenPower,Record=c.State.RecordedPower and c.State.RecordedPower.Id}
end
function Visual.Result(self: any,c: any,before: any,ok: boolean,evidence: any,now: number)
    local packet=self:Packet(c,if ok then "Result" else "Cancel",if ok then c.Position else before.Origin)
    self.Active[c.Player]=nil
    if not packet then return end
    packet.Origin=before.Origin;packet.Destination=c.Root.Position
    packet.Target=c.VisualTarget or (c.Entity and c.Entity.Model)
    packet.Affected=c.VisualAffected;packet.Radius=c.VisualRadius;packet.Gates=c.VisualGates;packet.Echo=c.VisualEcho
    if c.State.RecordedPower then packet.RecordedId=c.State.RecordedPower.Id;packet.RecordedCharges=c.State.RecordedPower.Charges end
    if c.Entity then packet.Threads=c.Entity.Threads;packet.Controlled=c.Entity.Owner==c.Player end
    packet.Outcome=if evidence==false and c.Ability.Operation.Kind=="Sense" then "Obscured" else "Confirmed"
    if c.Ability.Operation.Kind=="Theft" then packet.Outcome="Taken"
    elseif c.Ability.Operation.Kind=="StealPower" then
        packet.Outcome=if before.Stored then "Released" else "Captured"
        packet.PowerId=before.Stored or c.State.StolenPower
    end
    if c.VisualExpires then packet.ExpiresAt=packet.At+math.max(0,c.VisualExpires-now) end
    if ok and packet.Gates then self.Gates[c.Player]=table.clone(packet) end
    if ok and packet.Echo then self.Echoes[packet.Echo]=table.clone(packet) end
    self.World.FX:FireAllClients(packet)
end
function Visual.Reveal(self: any,c: any,entries: {any},now: number)
    local packet=self:Packet(c,"Reveal",c.Root.Position)
    if not packet then return end
    local targets={}
    for _,entry in ipairs(entries) do
        if #targets>=self.Config.MaxReveals then break end
        local target=entry.Model or entry.Part
        local position=if entry.Root then entry.Root.Position else entry.Position
        if target and self.World:FiniteVector(position) then table.insert(targets,{Target=target,Position=position}) end
    end
    if #targets==0 then return end
    packet.Targets=targets
    local status=c.State.Statuses.Vision
    local duration=if status then math.max(0,status.ExpiresAt-now) else self.Config.RevealLife
    packet.ExpiresAt=packet.At+math.min(duration,self.Config.RevealLife)
    -- Perception evidence remains private to the player the server authorized.
    self.World.FX:FireClient(c.Player,packet)
end
function Visual.Step(self: any,now: number?)
    for player,cast in pairs(self.Active) do
        local state=self.World.States[player]
        local pending=state and state.Pending
        if not state or not state.Ready or state.Dead or player.Character~=cast.Character or not pending or pending.Token~=cast.DomainToken then
            self.Active[player]=nil
            if state then
                local packet=self:Packet({Player=player,State=state,Ability=cast.Ability},"Cancel",cast.Position)
                if packet then packet.Token=cast.Token;self.World.FX:FireAllClients(packet) end
            end
        end
    end
    self:Statuses(now or os.clock())
    for model,packet in pairs(self.Echoes) do if not model.Parent or packet.ExpiresAt<=self.Clock() then self.Echoes[model]=nil end end
end
function Visual.Remove(self: any,player: any)
    local cast=self.Active[player]
    if cast then
        local state=self.World.States[player]
        if state then
            local packet=self:Packet({Player=player,State=state,Ability=cast.Ability},"Cancel",cast.Position)
            if packet then packet.Token=cast.Token;self.World.FX:FireAllClients(packet) end
        end
        self.Active[player]=nil
    end
    self.Counters[player]=nil
    self.LastSync[player]=nil
    self.Gates[player]=nil
    for model,packet in pairs(self.Echoes) do if packet.Owner==player.UserId then self.Echoes[model]=nil end end
    for target,records in pairs(self.StatusRecords) do
        for id,record in pairs(records) do
            if record.Owner==player then self:StatusPacket(record,"Remove");records[id]=nil end
        end
        if next(records)==nil then self.StatusRecords[target]=nil end
    end
end
function Visual.Trigger(self: any,player: any,trigger: string,abilityId: string,position: Vector3,target: any)
    local state=self.World.States[player]
    local ability=self.World.Data and self.World.Data.Abilities[abilityId]
    if not state or not ability then return end
    local packet=self:Packet({Player=player,State=state,Ability=ability},"Trigger",position)
    if not packet then return end
    self.CueSerial+=1
    packet.Kind="VisualTrigger";packet.CueId=self.CueSerial;packet.Trigger=trigger;packet.Target=target
    local root=self.World:Root(player)
    packet.Origin=if root then root.Position else position;packet.Destination=position;packet.Outcome="Confirmed"
    self.World.FX:FireAllClients(packet)
end
function Visual.RemoveGates(self: any,player: any)
    self.Gates[player]=nil
    self.CueSerial+=1
    self.World.FX:FireAllClients({Kind="GateRemoval",Owner=player.UserId,At=self.Clock(),CueId=self.CueSerial})
end
function Visual.StatusPacket(self: any,record: any,action: string,recipient: any?)
    -- A sync is a fresh observation: old revisions could be below a late joiner's
    -- newest live receipt, causing otherwise-current statuses to be discarded.
    self.Revision+=1;record.Revision=self.Revision
    local packet={Kind="StatusVisual",Action=action,Owner=record.Owner.UserId,Target=record.Target,StatusId=record.Id,
        Position=record.Position,ExpiresAt=record.ExpiresAt,PathwayId=record.PathwayId,Count=record.Count,
        Revision=record.Revision,Required=record.Required,Private=self.StatusConfig.Private[record.Id]==true,At=self.Clock()}
    if recipient then
        if not packet.Private or recipient==record.Owner then self.World.FX:FireClient(recipient,packet) end
    elseif packet.Private then
        local state=self.World.States[record.Owner]
        if state and state.Ready then self.World.FX:FireClient(record.Owner,packet) end
    else self.World.FX:FireAllClients(packet) end
end
function Visual.Statuses(self: any,now: number)
    local current={};local count=0
    local function collect(target: any,root: any,statuses: any,defaultOwner: any,threads: number?)
        if not target or not root or not self.World:FiniteVector(root.Position) then return end
        for id,status in pairs(statuses or {}) do
            local owner=status.Owner or defaultOwner
            local state=owner and self.World.States[owner]
            if self.StatusConfig.Labels[id] and state and state.Ready and not state.Dead and status.ExpiresAt>now
                and count<self.Config.MaxTrackedStatuses then
                count+=1;current[target]=current[target] or {}
                local old=self.StatusRecords[target] and self.StatusRecords[target][id]
                local record={Target=target,Owner=owner,Id=id,Until=status.ExpiresAt,Position=root.Position,
                    ExpiresAt=self.Clock()+math.max(0,status.ExpiresAt-now),PathwayId=state.Profile and state.Profile.PathwayId or "Seer",
                    Count=if id=="Threaded" then threads or 0 else 0}
                if id=="Threaded" then
                    local a=self.World.Data and self.World.Data.Abilities and self.World.Data.Abilities.Seer_5
                    record.Required=if record.PathwayId=="Seer" and a then a.Operation.RequiredHits else 1
                end
                if not old or old.Owner~=owner or old.Until~=record.Until or old.Count~=record.Count or old.PathwayId~=record.PathwayId then
                    if old and old.Owner~=owner then self:StatusPacket(old,"Remove") end
                    self:StatusPacket(record,"Set")
                else record.Revision=old.Revision end
                current[target][id]=record
            end
        end
    end
    for _,entity in pairs(self.World.Entities or {}) do
        if entity.Model.Parent and entity.Humanoid.Health>0 then collect(entity.Model,entity.Root,entity.Statuses,nil,entity.Threads) end
    end
    for player,state in pairs(self.World.States) do
        if state.Ready and not state.Dead and player.Character then
            local root=if self.World.Root then self.World:Root(player) else player.Character.PrimaryPart
            collect(player.Character,root,state.Statuses,player,nil)
        end
    end
    for target,records in pairs(self.StatusRecords) do
        for id,record in pairs(records) do
            if not current[target] or not current[target][id] then self:StatusPacket(record,"Remove") end
        end
    end
    self.StatusRecords=current
end
function Visual.Sync(self: any,player: any)
    local now=self.Clock()
    if now-(self.LastSync[player] or -math.huge)<self.Config.SyncInterval then return end
    self.LastSync[player]=now
    local records={}
    for _,targetRecords in pairs(self.StatusRecords) do
        for _,record in pairs(targetRecords) do
            if not self.StatusConfig.Private[record.Id] or record.Owner==player then table.insert(records,record) end
        end
    end
    table.sort(records,function(a,b) return a.Revision<b.Revision end)
    for i,record in ipairs(records) do
        if i>self.Config.MaxStatusRecords then break end
        self:StatusPacket(record,"Set",player)
    end
    for _,source in pairs(self.Gates) do
        if source.ExpiresAt>now then
            local packet=table.clone(source);packet.Kind="GateSnapshot";packet.At=now
            self.World.FX:FireClient(player,packet)
        end
    end
    for model,source in pairs(self.Echoes) do
        if model.Parent and source.ExpiresAt>now then
            local packet=table.clone(source);packet.Kind="EchoSnapshot";packet.At=now
            self.World.FX:FireClient(player,packet)
        end
    end
end
return Visual
```


## src/ServerScriptService/Services/WorldArt.lua

**ModuleScript** at `ServerScriptService/Services/WorldArt`. Create matching Folder parents.

```lua
--!strict
-- Original native-part architecture. No assets, NPC statistics or authority live here.
local Collection=game:GetService("CollectionService")
local Lighting=game:GetService("Lighting")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local W=T.World
local K=W.Kit
local function size(values: {number}): Vector3 return Vector3.new(table.unpack(values)) end
local Art={}
function Art.Part(parent: Instance,name: string,size: Vector3,frame: CFrame,color: Color3,solid: boolean?): Part
    local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=frame;p.Color=color;p.Anchored=true
    p.Material=Enum.Material.SmoothPlastic;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
    p.CanCollide=solid==true;p.CanQuery=solid==true;p.CanTouch=false;p.CastShadow=solid==true;p.Parent=parent
    return p
end
local function block(parent: Instance,name: string,size: Vector3,position: Vector3,color: Color3,solid: boolean?): Part
    return Art.Part(parent,name,size,CFrame.new(position),color,solid)
end
function Art.Lamp(parent: Instance,at: Vector3)
    local h=W.Lamp.Height
    block(parent,"Iron lamp post",Vector3.new(K.LampPost,h,K.LampPost),at+Vector3.yAxis*h/2,T.Colors.Iron)
    local glass=block(parent,"Gas lamp",size(K.LampGlass),at+Vector3.yAxis*h,T.Colors.Warm)
    glass.Material=Enum.Material.Glass
    block(parent,"Lantern cap",size(K.LampCap),at+Vector3.yAxis*(h+0.7),T.Colors.Iron)
    local light=Instance.new("PointLight");light.Name="Gaslight";light.Color=T.Colors.Warm;light.Brightness=W.Lamp.Brightness
    light.Range=W.Lamp.Range;light.Shadows=false;light.Enabled=false;light.Parent=glass
    Collection:AddTag(glass,"MysteriesLamp");Collection:AddTag(glass,"FlameAnchor")
end
local function zone(parent: Instance,name: string,center: Vector3,radius: number,tier: number?)
    local z=block(parent,"Zone · "..name,Vector3.one,center,T.Colors.Ink)
    z.Transparency=1;z:SetAttribute("VisualName",name);z:SetAttribute("Radius",radius);z:SetAttribute("Sequence",tier)
    Collection:AddTag(z,"MysteriesZone")
end
local function building(parent: Instance,spec: any): Part
    local b=W.Building;local center=Vector3.new(spec.X,0,spec.Z)
    local f=CFrame.lookAt(center,Vector3.zero)
    local model=Instance.new("Model");model.Name=spec.Name.." architecture";model.Parent=parent
    local function piece(name: string,size: Vector3,pos: Vector3,color: Color3,solid: boolean?): Part
        return Art.Part(model,name,size,f*CFrame.new(pos),color,solid)
    end
    piece("Stone foundation",Vector3.new(b.Width,K.FoundationDepth,b.Depth),Vector3.new(0,0,b.Depth*0),T.Colors.Stone,true).Material=Enum.Material.Cobblestone
    for _,x in ipairs({-1,1}) do
        piece("Brick side",Vector3.new(b.Wall,b.Height,b.Depth),Vector3.new(x*b.Width/2,b.Height/2,0),T.Colors.Slate,true).Material=Enum.Material.Brick
        local side=(b.Width-b.DoorWidth)/2
        piece("Brick frontage",Vector3.new(side,b.Height,b.Wall),Vector3.new(x*(b.DoorWidth+side)/2,b.Height/2,-b.Depth/2),T.Colors.Slate,true).Material=Enum.Material.Brick
        piece("Arch jamb",Vector3.new(K.JambWidth,b.DoorHeight,K.JambDepth),Vector3.new(x*(b.DoorWidth/2+0.35),b.DoorHeight/2,-b.Depth/2),T.Colors.Stone)
        for floor=0,1 do
            local window=piece("Frosted amber window",size(K.Window),Vector3.new(x*(b.Width/2-4),5+floor*b.Storey,-b.Depth/2-0.55),T.Colors.Warm)
            window.Material=Enum.Material.Glass
        end
        for shelf=0,2 do
            local z=-4+shelf*5
            piece("Archive cabinet",size(K.Cabinet),Vector3.new(x*(b.Width/2-2),4,z),T.Colors.Wood,true)
            for row=1,3 do piece("Shelf brass edge",size(K.Shelf),Vector3.new(x*(b.Width/2-2),row*2,z),T.Colors.Gold) end
        end
    end
    piece("Entrance lintel",Vector3.new(b.DoorWidth,b.Height-b.DoorHeight,b.Wall),Vector3.new(0,(b.Height+b.DoorHeight)/2,-b.Depth/2),T.Colors.Slate,true)
    for _,side in ipairs({-1,1}) do
        local arch=piece("Pointed arch",Vector3.new(b.DoorWidth*0.65,K.ArchThickness,K.ArchDepth),Vector3.new(side*b.DoorWidth/4,b.DoorHeight,-b.Depth/2-0.5),T.Colors.Gold)
        arch.CFrame*=CFrame.Angles(0,0,math.rad(side*K.ArchAngle))
    end
    piece("Back wall",Vector3.new(b.Width,b.Height,b.Wall),Vector3.new(0,b.Height/2,b.Depth/2),T.Colors.Slate,true).Material=Enum.Material.Brick
    piece("Slate roof",Vector3.new(b.Width+2,b.RoofHeight,b.Depth+2),Vector3.new(0,b.Height+b.RoofHeight/2,0),T.Colors.Iron,true).Material=Enum.Material.Slate
    piece("Cornice",Vector3.new(b.Width+1,0.5,b.Depth+1),Vector3.new(0,b.Height,0),T.Colors.Stone)
    local desk=Art.Part(parent,spec.Name,size(K.Desk),f*CFrame.new(0,1.5,-4),T.Colors.Wood,true)
    desk:SetAttribute("VisualName",spec.Name);Collection:AddTag(desk,"MysteriesInteractable")
    piece("Brass desk rim",size(K.DeskRim),Vector3.new(0,3.1,-4),T.Colors.Gold)
    if spec.Action=="Buy" then
        for i,path in ipairs({"Seer","Marauder","Apprentice"}) do
            local bottle=piece("Original potion vessel",size(K.Bottle),Vector3.new((i-2)*1.5,3.8,-4),T.CharacterArt.Trim[path])
            bottle.Material=Enum.Material.Glass
            piece("Potion stopper",size(K.Stopper),Vector3.new((i-2)*1.5,4.5,-4),T.Colors.Gold)
        end
    else
        for i=-1,1 do piece("Closed unmarked folio",size(K.Book),Vector3.new(i*1.5,3.4,-4),T.Colors.DeepPurple) end
    end
    Art.Lamp(model,(f*CFrame.new(b.DoorWidth/2+2,0,-b.Depth/2-3)).Position)
    return desk
end
function Art.Build(world: any)
    local parent=world.Folder
    local ground=block(parent,"TrainingGround",Vector3.new(W.Ground,K.GroundDepth,W.Ground),Vector3.new(0,-2,0),T.Colors.Stone,true)
    ground.Material=Enum.Material.Cobblestone;ground.Reflectance=K.Reflectance
    block(parent,"Sanctuary Square",Vector3.new(W.Hub,K.HubDepth,W.Hub),Vector3.zero,T.Colors.Slate,true).Material=Enum.Material.Cobblestone
    local spawn=Instance.new("SpawnLocation");spawn.Name="SanctuarySpawn";spawn.Size=size(K.SpawnSize);spawn.Position=Vector3.new(0,0.5,0)
    spawn.Neutral=true;spawn.Duration=0;spawn.Transparency=1;spawn.Parent=parent
    zone(parent,"Sanctuary Square",Vector3.zero,W.Zone.HubRadius,nil)
    local tower=W.Tower
    block(parent,"Clock tower",Vector3.new(tower.Width,tower.Height,tower.Width),Vector3.new(0,tower.Height/2,-W.Hub/2+8),T.Colors.Slate,true).Material=Enum.Material.Brick
    local clock=block(parent,"Unlettered clock face",Vector3.new(tower.ClockSize,tower.ClockSize,K.ClockFaceDepth),Vector3.new(0,tower.Height-10,-W.Hub/2+8+tower.Width/2+0.2),T.Colors.Text)
    for i,length in ipairs(tower.Hands) do
        local hand=block(parent,"Clock hand",Vector3.new(K.ClockHandWidth,length,K.ClockHandDepth),clock.Position+Vector3.new(0,length/2,0.2),T.Colors.Iron)
        hand.CFrame=CFrame.new(clock.Position+Vector3.zAxis*0.2)*CFrame.Angles(0,0,math.rad(if i==1 then -60 else 120))*CFrame.new(0,length/2,0)
    end
    for _,spec in ipairs(W.Services) do
        local desk=building(parent,spec)
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText=if spec.Action=="Buy" then "Open potion altar" else spec.Name
        prompt.ObjectText=spec.Name;prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.RequiresLineOfSight=true;prompt:SetAttribute("InteractionId",spec.Action);prompt.Parent=desk
        prompt.Triggered:Connect(function(player)
            local root=world:Root(player)
            if root and (root.Position-desk.Position).Magnitude<=T.Interaction.ServerDistance and world.OnInteraction then world.OnInteraction(player,spec.Action) end
        end)
    end
    for index,tier in ipairs(world.Data.Runtime.EnemyTiers) do
        local angle=(index-1)*math.pi/3
        local center=Vector3.new(math.cos(angle)*W.ArenaRadius,0,math.sin(angle)*W.ArenaRadius)
        local sizes=W.ArenaSizes[tier];local frame=CFrame.lookAt(center,Vector3.zero)
        local road=CFrame.lookAt(center/2,center)
        Art.Part(parent,"Carriageway",Vector3.new(W.Road,K.RoadDepth,W.ArenaRadius),road,T.Colors.Iron,true).Material=Enum.Material.Cobblestone
        for _,side in ipairs({-1,1}) do
            Art.Part(parent,"Pavement",Vector3.new(W.Pavement,K.PavementDepth,W.ArenaRadius),road*CFrame.new(side*(W.Road+W.Pavement)/2,0,0),T.Colors.Stone,true)
            for distance=W.Hub/2,W.ArenaRadius-sizes[2]/2,W.Lamp.Spacing do
                local at=(CFrame.lookAt(Vector3.zero,center)*CFrame.new(side*(W.Road/2+W.Pavement),0,-distance)).Position
                Art.Lamp(parent,at)
            end
            for n=-1,1 do
                local at=(frame*CFrame.new(side*(sizes[1]/2-1),0,n*sizes[2]/3)).Position
                block(parent,"Arena buttress",size(if tier<=2 then K.HighButtress else K.Buttress),at+Vector3.yAxis*(if tier<=2 then 10 else 6),T.Colors.Stone,true)
            end
        end
        Art.Part(parent,"Arena terrace · "..tier,Vector3.new(sizes[1],K.ArenaDepth,sizes[2]),frame,T.Colors.Slate,true).Material=Enum.Material.Slate
        zone(parent,W.Zones[tier],center,math.min(sizes[1],sizes[2])/2,tier)
        if tier<=4 then
            local z=block(parent,"WhisperZone",size(K.Exposure),center+Vector3.yAxis*6,T.Colors.DeepPurple)
            z.Transparency=1;z:SetAttribute("Radius",world.Data.Runtime.ExposureRadius);Collection:AddTag(z,"MysticalExposure")
        end
        for _,x in ipairs({-24,24}) do
            for _,z in ipairs({-24,24}) do Art.Lamp(parent,(frame*CFrame.new(x,0,z)).Position) end
        end
        -- Preserve real enemy tiers/statistics and the original three spawn offsets.
        for offset=1,3 do table.insert(world.Spawns,{Position=center+Vector3.new((offset-2)*12,4,8),Tier=tier,Entity=nil,NextSpawn=0}) end
        -- Large background arches stay outside the combat lane; two approaches stay clear.
        if tier<=2 then
            for _,side in ipairs({-1,1}) do
                Art.Part(parent,"Distant arch pier",size(K.DistantPier),frame*CFrame.new(side*20,15,sizes[2]/2+6),T.Colors.Stone,true)
            end
            Art.Part(parent,"Distant arch crown",size(K.DistantCrown),frame*CFrame.new(0,30,sizes[2]/2+6),T.Colors.Stone,true)
        end
    end
    for i=1,4 do
        local x=-35+i*14
        local door=block(parent,"PracticeDoor",size(K.PracticeDoor),Vector3.new(x,3.5,-30),T.Colors.Wood,true)
        door:SetAttribute("VisualName","Sealed practice passage");Collection:AddTag(door,"MysticDoor");Collection:AddTag(door,"MysteriesInteractable")
        for _,side in ipairs({-1,1}) do block(parent,"Practice door jamb",size(K.PracticeJamb),Vector3.new(x+side*2.5,4,-30),T.Colors.Stone,true) end
    end
    for key,value in pairs(W.Lighting) do (Lighting :: any)[key]=value end
    for _,spec in ipairs({{Class="Atmosphere",Name="MysteriesAtmosphere",Properties=W.Atmosphere},
        {Class="BloomEffect",Name="MysteriesBloom",Properties=W.Bloom}}) do
        local old=Lighting:FindFirstChild(spec.Name);if old then old:Destroy() end
        local object=Instance.new(spec.Class :: any);object.Name=spec.Name
        for key,value in pairs(spec.Properties) do (object :: any)[key]=value end
        object.Parent=Lighting
    end
    -- LightingStyle/Technology remain Studio properties; no restricted runtime assignment.
end
return Art
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
    Visuals: any?,
}
type World = typeof(setmetatable({} :: Fields, World))

local function part(parent: Instance,name: string,size: Vector3,position: Vector3,color: Color3): Part
    local p=Instance.new("Part")
    p.Name=name; p.Size=size; p.Position=position; p.Color=color; p.Anchored=true
    p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent
    return p
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
    require(script.Parent.WorldArt).Build(self)
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
    self.FX:FireAllClients({Kind="Damage",Position=e.Root.Position,Amount=applied,Owner=owner.UserId,Target=e.Model,Dead=e.Humanoid.Health<=0})
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
    if s.Statuses.MythicalForm then amount*=0.75 end
    if source.Statuses.Grafted and source.Statuses.Grafted.Owner==player then
        if self:Damage(source,amount,player,now) then
            if self.Visuals then self.Visuals:Trigger(player,"GraftReflected","Seer_1",source.Root.Position,source.Model) end
            self.Domain:Act(s,"GraftEncounterResolved","graft:"..source.Serial..":"..tostring(math.floor(now)),now)
        end
        return
    end
    if s.Statuses.Substitute and hum.Health<=amount then
        s.Statuses.Substitute=nil;hum.Health=math.max(1,hum.MaxHealth*0.2)
        self:Buff(s,"Invulnerable",2,now)
        local position=hum.RootPart and hum.RootPart.Position or Vector3.zero
        if self.Visuals then self.Visuals:Trigger(player,"SubstituteTriggered","Seer_7_Secondary",position,player.Character)
        else self:Effect(position,"Substitute",player) end
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
    hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    model:SetAttribute("VisualTier",tier);model:SetAttribute("VisualEcho",owner~=nil)
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
-- These attributes describe existing attack eligibility/times; they never reserve or delay a hit.
function World.Threat(self: World,e: any,nearest: Player?,blocked: boolean,now: number)
    local model=e.Model
    local target=nearest and self:Root(nearest)
    local eligible=target and not blocked and self:LineOfSight(e.Root.Position,target.Position,model,nearest and nearest.Character)
    local userId=if eligible and nearest then nearest.UserId else 0
    if model:GetAttribute("VisualThreatUserId")~=userId then model:SetAttribute("VisualThreatUserId",userId) end
    model:SetAttribute("VisualSpellAllowed",eligible~=nil and eligible~=false and e.Tier<=6 and not self:Has(e,"Silenced",now))
    if e.VisualMeleeObserved~=e.LastAttack then
        e.VisualMeleeObserved=e.LastAttack
        model:SetAttribute("VisualMeleeDue",workspace:GetServerTimeNow()+e.LastAttack+self.Data.Runtime.NPCAttackInterval-now)
    end
    local spell=e.LastSpell or -100
    if e.VisualSpellObserved~=spell then
        e.VisualSpellObserved=spell
        model:SetAttribute("VisualSpellDue",workspace:GetServerTimeNow()+spell+self.Data.Runtime.NPCSpellCooldown-now)
    end
end
function World.AttackVisual(self: World,e: any,kind: string)
    e.VisualAttackSerial=(e.VisualAttackSerial or 0)+1
    e.Model:SetAttribute("VisualAttackKind",kind)
    e.Model:SetAttribute("VisualAttackAt",workspace:GetServerTimeNow())
    e.Model:SetAttribute("VisualAttackSerial",e.VisualAttackSerial)
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
            self:Threat(e,nil,true,now)
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
        self:Threat(e,nearest,blocked,now)
        if nearest and not blocked then
            local root=self:Root(nearest)
            if root and e.Tier<=6 and distance<self.Data.Runtime.NPCSpellRange and now-(e.LastSpell or -100)>self.Data.Runtime.NPCSpellCooldown and not self:Has(e,"Silenced",now) and self:LineOfSight(e.Root.Position,root.Position,model,nearest.Character) then
                e.LastSpell=now;self:AttackVisual(e,"Spell")
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
                    e.LastAttack=now;self:AttackVisual(e,"Melee")
                    local payload=e.Statuses.Payload
                    if payload and payload.Owner then
                        e.Statuses.Payload=nil;self:Damage(e,payload.Power,payload.Owner,now)
                        if self.Visuals then self.Visuals:Trigger(payload.Owner,"PayloadTriggered","Marauder_2_Secondary",e.Root.Position,model) end
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
local WorldPresentation=require(script.Parent.Visuals.WorldPresentation)
local VfxTestRoom=require(script.Parent.Visuals.VfxTestRoom)
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
local menuModal=false
local roomModal=false
local cinematic=false
local worldView: any=nil
local zoneTitle=false
local menus: any=nil
local hud: any=nil
local presentation: any=nil
local testRoom: any=nil
local developer: any=nil
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
local function dashDirection(): Vector3
    local character=player.Character
    local hum=character and character:FindFirstChildOfClass("Humanoid")
    if hum and hum.MoveDirection.Magnitude>0.05 then
        local flat=Vector3.new(hum.MoveDirection.X,0,hum.MoveDirection.Z)
        if flat.Magnitude>0.05 then return flat.Unit end
    end
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        local look=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
        if look.Magnitude>0.05 then return look.Unit end
    end
    local camera=workspace.CurrentCamera
    if camera then
        local look=Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z)
        if look.Magnitude>0.05 then return look.Unit end
    end
    return Vector3.new(0,0,-1)
end
local function dash()
    if not modal and state and state.Ready and not state.Dead then send("Dash",{Direction=dashDirection()}) end
end
local function ultimate()
    if not modal and state and state.Ready and not state.Dead then send("Ultimate",{}) end
end
local function toggleRun()
    if not modal and state and state.Ready and not state.Dead then send("ToggleRun",{}) end
end
local feedback=Feedback.new(safeRoot,data,function(active: boolean)
    cinematic=active
    if hud then hud.Wordmark.Visible=not active and not promptUI.Root.Visible;hud.Pathway.Visible=not active and not zoneTitle and not promptUI.Root.Visible end
end)
hud=Hud.new(safeRoot,data,{Cast=cast,Melee=melee,Dash=dash,Ultimate=ultimate,ToggleRun=toggleRun,Touch=UserInputService.TouchEnabled,TouchAim=touchAim,ReducedMotion=function() return menus and menus.ReducedMotion end,Journal=function(tab: string)
    if roomModal then return end
    if menus.Root.Visible and menus.Tab==tab and menus.View=="Page" then menus:Close() else menus:Open(tab) end
end})
local function updateModal()
    modal=menuModal or roomModal;promptUI:SetModal(modal);hud.Tooltip.Visible=false
    if developer then developer:SetSuppressed(modal) end
end
local function visualSettings(reduced: boolean,low: boolean)
    feedback:SetReducedMotion(reduced)
    if worldView then worldView:SetSettings(reduced,low) end
    if presentation then presentation:SetSettings(reduced,low) end
    if testRoom then
        testRoom.Reduced=reduced;testRoom.Low=low
        testRoom.ReducedButton.Text="Reduced motion: "..(if reduced then "on" else "off")
        testRoom.LowButton.Text="Low graphics: "..(if low then "on" else "off")
    end
end
menus=Menus.new(safeRoot,data,{Intent=send,Modal=function(open: boolean)
    menuModal=open;updateModal()
end,ReducedMotion=function(reduced: boolean) visualSettings(reduced,menus.LowGraphics) end,
    LowGraphics=function(low: boolean) visualSettings(menus.ReducedMotion,low) end})
presentation=Presentation.new(gui,data,{Notice=function(text: string) feedback:Tell(text) end,Damage=function(event: any) feedback:Damage(event) end,
    CastVisual=function(event: any) hud:SetVisualCast(event) end,
    ScreenEdgePulse=function() feedback:Flash() end})
testRoom=VfxTestRoom.new(safeRoot,presentation,{Modal=function(open: boolean) roomModal=open;updateModal() end,
    ReducedMotion=function(reduced: boolean) menus.ReducedMotion=reduced;visualSettings(reduced,menus.LowGraphics) end,
    LowGraphics=function(low: boolean) menus.LowGraphics=low;visualSettings(menus.ReducedMotion,low) end,
    Damage=function(event: any) feedback:Damage(event) end})
developer=Developer.new(safeRoot,send,if RunService:IsStudio() then function()
    if menus.Root.Visible then menus:Close() end
    testRoom:Toggle(developer.Allowed);developer.Root.Visible=false
end else nil)
promptUI.OnVisibility=function(visible: boolean)
    hud.Pathway.Visible=not visible and not cinematic and not zoneTitle;hud.Wordmark.Visible=not visible and not cinematic
end
promptUI.Exclusions={hud.Pathway,hud.Cast,feedback.Notice,feedback.Advance,feedback.Acting,feedback.SanityWarning,developer.Root}
worldView=WorldPresentation.new(safeRoot,presentation,{
    Modal=function() return modal or cinematic end,
    Prompt=function() return promptUI.Current end,
    Exclusions=function() return {hud.Pathway,hud.Cast,promptUI.Root,feedback.Notice,feedback.Advance,feedback.Acting,feedback.SanityWarning,developer.Root,worldView.Compass,worldView.Title} end,
    Title=function(active: boolean)
        zoneTitle=active;hud.Pathway.Visible=not active and not cinematic and not promptUI.Root.Visible
    end,
})
local function resize()
    local size=safeRoot.AbsoluteSize
    if size.X<=0 or size.Y<=0 then return end
    local layout=Layout.Resolve(T,size.X,size.Y,UserInputService.TouchEnabled)
    hud:Resize(layout);menus:Resize(layout);feedback:Resize(layout);developer:Resize(layout);promptUI.Layout=layout
    testRoom:Resize(size.X,size.Y);worldView:Resize(layout)
    hud.Wordmark.Visible=not cinematic and not promptUI.Root.Visible;hud.Pathway.Visible=not cinematic and not promptUI.Root.Visible and not zoneTitle
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
    presentation:Update(update)
    if not developer.Allowed and testRoom.Root.Visible then testRoom:Close() end
    if update.Dead and menus.Root.Visible then menus:Close() end
end)
effectEvent.OnClientEvent:Connect(function(event: any)
    if type(event)~="table" or type(event.Kind)~="string" then return end
    if event.Kind~="GateRemoval" and typeof(event.Position)~="Vector3" then return end
    presentation:Event(event)
end)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==T.Input.Developer then
        if testRoom.Root.Visible then testRoom:Close() else developer:Toggle() end
        return
    end
    if processed then return end
    if input.KeyCode==T.Input.Journal then
        if roomModal then return end
        if menus.Root.Visible then menus:Close() else menus:Open("Journal") end
        return
    end
    if input.KeyCode==Enum.KeyCode.Escape then
        if testRoom.Root.Visible then testRoom:Close();return end
        if menus.Root.Visible then menus:Close();return end
    end
    if modal then return end
    -- E belongs to an active prompt, preventing any simultaneous shortcut conflict.
    if promptUI.Current and input.KeyCode==promptUI.Current.KeyboardKeyCode then return end
    if input.KeyCode==T.Input.SprintLeft or input.KeyCode==T.Input.SprintRight then toggleRun();return end
    if input.KeyCode==T.Input.Dash then dash();return end
    if input.KeyCode==T.Input.Ultimate then ultimate();return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then melee();return end
    for i,key in ipairs(T.Input.Keys) do if input.KeyCode==key then cast(i);return end end
end)
local accumulator=0
RunService.Heartbeat:Connect(function(dt: number)
    presentation:Step(dt);testRoom:Step(dt);worldView:Step(dt)
    accumulator+=dt
    if accumulator<T.Timing.Step then return end
    accumulator=0
    local now=os.clock()
    hud:Step(now);menus:Step(now);feedback:Step(now)
    feedback.Notice.Visible=now<(feedback.NoticeUntil or 0) and not hud.Cast.Visible and not cinematic and not modal
    hud.Wordmark.Visible=false -- the zone compass occupies the Art Bible's top-center strip.
    feedback.Acting.Position=UDim2.fromOffset(hud.Layout.Pathway.X,hud.Layout.Pathway.Y+hud.Pathway.AbsoluteSize.Y+T.World.Labels.Pad)
    local actingBottom=feedback.Acting.Position.Y.Offset+T.Feedback.SubtitleHeight
    feedback.Acting.Visible=feedback.Acting.Visible and not modal and not promptUI.Root.Visible and not zoneTitle and actingBottom<hud.Layout.Hotbar.Y
    feedback.SanityWarning.Visible=feedback.SanityWarning.Visible and not modal and not cinematic and not hud.Cast.Visible and not feedback.Notice.Visible
end)
resize()
send("Sync",{})
script.Destroying:Connect(function() testRoom:Close();worldView:Destroy();presentation:Destroy() end)
```


## src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/UI/Developer`. Create matching Folder parents.

```lua
--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Data=require(Shared.GameData)
local Kit=require(script.Parent.Kit)
local Developer={}
function Developer.new(parent: Instance,send: any,testRoom: (() -> ())?): any
    local D=T.Layout.Developer
    local self: any=setmetatable({Allowed=false,State=nil,Pathway="Seer",Sequence=9,Initialized=false,Dirty=false,Waiting=false,Suppressed=false,
        PathButtons={},SequenceButtons={},Buttons={}},{__index=Developer})
    self.Root=Kit.Panel(parent,"DeveloperPanel");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    self.ToggleButton=Kit.Button(parent,"ADMIN",function() self:Toggle() end)
    self.ToggleButton.Name="AdminPowersButton";self.ToggleButton.ZIndex=T.Layers.Developer;self.ToggleButton.Visible=false
    local title=Kit.Text(self.Root,"ADMIN POWERS · F8",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(D.Pad,0);title.Size=UDim2.new(1,-D.Pad*2,0,D.Row)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{Name="DeveloperControls",BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=T.Style.Stroke,ScrollingDirection=Enum.ScrollingDirection.Y,
        Position=UDim2.fromOffset(0,D.Row),Size=UDim2.new(1,0,1,-D.Row)})
    self.Info=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Number)
    self.Info.Position=UDim2.fromOffset(D.Pad,0);self.Info.Size=UDim2.new(1,-D.Pad*2,0,D.Row*2)
    local y=D.Row*2
    local label=Kit.Text(self.Scroll,"Choose pathway",T.Type.Body,T.Fonts.Heading)
    label.Position=UDim2.fromOffset(D.Pad,y);label.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row
    local function cell(button: TextButton,column: number,top: number)
        button.Size=UDim2.new(1/D.Columns,-(D.Pad*2+D.Gap*(D.Columns-1))/D.Columns,0,D.Row)
        button.Position=UDim2.new(column/D.Columns,D.Pad+column*D.Gap/D.Columns,0,top)
        button.TextSize=T.Type.Small
    end
    for i,id in ipairs({"Seer","Marauder","Apprentice"}) do
        local b=Kit.Button(self.Scroll,id,function()
            if not self:CanChange() then return end
            self.Pathway=id;self.Dirty=true;self:Selection()
        end)
        cell(b,i-1,y);self.PathButtons[id]=b;table.insert(self.Buttons,b)
    end
    y+=D.Row+D.Gap
    self.Selected=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Heading)
    self.Selected.Position=UDim2.fromOffset(D.Pad,y);self.Selected.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row
    for sequence=9,1,-1 do
        local index=9-sequence
        local b=Kit.Button(self.Scroll,"Seq "..sequence,function()
            if not self:CanChange() then return end
            self.Sequence=sequence;self.Dirty=true;self:Selection()
        end)
        cell(b,index%D.Columns,y+math.floor(index/D.Columns)*(D.Row+D.Gap))
        self.SequenceButtons[sequence]=b;table.insert(self.Buttons,b)
    end
    y+=math.ceil(9/D.Columns)*(D.Row+D.Gap)
    self.Apply=Kit.Button(self.Scroll,"Apply pathway & sequence",function()
        if not self:CanChange() then return end
        self.Waiting=true;self:Selection()
        send("AdminSet",{PathwayId=self.Pathway,Sequence=self.Sequence})
    end)
    self.Apply.Position=UDim2.fromOffset(D.Pad,y);self.Apply.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row+D.Gap
    if testRoom then
        self.TestButton=Kit.Button(self.Scroll,"Studio VFX test room",function() if self.Allowed then testRoom() end end)
        self.TestButton.Position=UDim2.fromOffset(D.Pad,y);self.TestButton.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row+D.Gap
    end
    self.Scroll.CanvasSize=UDim2.fromOffset(0,y)
    self:Selection()
    return self
end
function Developer.CanChange(self: any): boolean
    return self.Allowed and self.State~=nil and self.State.Ready==true and not self.State.Dead and not self.Waiting
end
function Developer.Selection(self: any)
    local sequence=Data.Pathways[self.Pathway].Sequences[self.Sequence]
    self.Selected.Text="Sequence "..self.Sequence.." · "..sequence.Name
    local enabled=self:CanChange()
    for id,b in pairs(self.PathButtons) do
        b.Interactable=enabled;b.BackgroundColor3=if id==self.Pathway then T.Colors.Gold else T.Colors.Slate
        b.TextColor3=if id==self.Pathway then T.Colors.Ink else T.Colors.Text
    end
    for number,b in pairs(self.SequenceButtons) do
        b.Interactable=enabled;b.BackgroundColor3=if number==self.Sequence then T.Colors.Gold else T.Colors.Slate
        b.TextColor3=if number==self.Sequence then T.Colors.Ink else T.Colors.Text
    end
    self.Apply.Interactable=enabled;self.Apply.Text=if self.Waiting then "Applying…" else "Apply pathway & sequence"
end
function Developer.Resize(self: any,layout: any)
    local D=T.Layout.Developer
    local width=math.min(D.Width,layout.Width-layout.Profile.Margin*2)
    local buttonY=layout.Journal.Y+layout.Journal.H+D.ButtonGap
    local buttonX=layout.Width-layout.Profile.Margin-D.ButtonWidth
    if buttonX<layout.Resources.X+layout.Resources.W+D.ButtonGap and buttonY<layout.Resources.Y+layout.Resources.H+D.ButtonGap then
        buttonY=layout.Resources.Y+layout.Resources.H+D.ButtonGap
    end
    local panelY=buttonY+D.ButtonHeight+D.ButtonGap
    self.Root.Size=UDim2.fromOffset(width,math.min(D.Height,math.max(D.Row,layout.Height-panelY-layout.Profile.Margin)))
    self.Root.Position=UDim2.fromOffset(layout.Width-layout.Profile.Margin-width,panelY)
    self.ToggleButton.Size=UDim2.fromOffset(D.ButtonWidth,D.ButtonHeight)
    self.ToggleButton.Position=UDim2.fromOffset(buttonX,buttonY)
end
function Developer.Update(self: any,state: any)
    self.State=state;self.Allowed=state~=nil and state.Developer==true
    self.ToggleButton.Visible=self.Allowed and not self.Suppressed
    if not self.Allowed then self.Root.Visible=false;self.Waiting=false;self:Selection();return end
    local info=state.DeveloperInfo
    self.Info.Text=if info then (if info.SessionOnly then "Studio · changes last this session" else "Live · changes save to your profile")..
        "\nCurrent: "..(state.PathwayId or "Uninitiated").." · "..(if state.Sequence then "Seq "..state.Sequence else "No sequence") else "Loading admin controls…"
    if state.Ready then
        if not self.Initialized or not self.Dirty then
            self.Pathway=state.PathwayId or "Seer";self.Sequence=state.Sequence or 9;self.Initialized=true
        end
        if self.Waiting and state.PathwayId==self.Pathway and state.Sequence==self.Sequence then self.Dirty=false end
        self.Waiting=false
    end
    self:Selection()
end
function Developer.Toggle(self: any)
    if self.Allowed and not self.Suppressed then self.Root.Visible=not self.Root.Visible end
end
function Developer.SetSuppressed(self: any,suppressed: boolean)
    self.Suppressed=suppressed;self.ToggleButton.Visible=self.Allowed and not suppressed
    if suppressed then self.Root.Visible=false end
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
    local self: any={SafeRoot=parent,Data=data,Cinematic=cinematic,State=nil,ReducedMotion=false,FlashTweens={},NoticeSerial=0,AdvanceSerial=0,Numbers={},Pool={},Layout=nil}
    self.Root=Kit.New("Frame",parent,{Name="Feedback",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=T.Layers.Feedback})
    self.Notice=Kit.New("CanvasGroup",self.Root,{Name="Notice",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Notice);Kit.Stroke(self.Notice)
    self.NoticeText=Kit.Text(self.Notice,"",T.Type.Number,T.Fonts.Number);self.NoticeText.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,1,0);self.NoticeText.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,0);self.NoticeText.TextXAlignment=Enum.TextXAlignment.Center
    self.Advance=Kit.New("CanvasGroup",self.Root,{Name="SequenceAdvance",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Advance);Kit.Stroke(self.Advance)
    self.AdvanceSmall=Kit.Text(self.Advance,"",T.Type.Small,T.Fonts.Number);self.AdvanceSmall.Size=UDim2.new(1,0,0,T.Feedback.SubtitleHeight);self.AdvanceSmall.TextXAlignment=Enum.TextXAlignment.Center
    self.AdvanceTitle=Kit.Text(self.Advance,"",T.Type.Title,T.Fonts.Title);self.AdvanceTitle.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,0,T.Feedback.AdvanceTitleHeight);self.AdvanceTitle.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,T.Feedback.SubtitleHeight);self.AdvanceTitle.TextXAlignment=Enum.TextXAlignment.Center
    self.Acting=Kit.Text(self.Root,"",T.Type.Small,T.Fonts.Number);self.Acting.BackgroundColor3=T.Colors.Ink;self.Acting.BackgroundTransparency=0;self.Acting.Visible=false
    self.Acting.TextXAlignment=Enum.TextXAlignment.Center;Kit.Corner(self.Acting);Kit.Stroke(self.Acting,T.Colors.Gold,T.Style.BorderAlpha)
    self.SanityWarning=Kit.Text(self.Root,"",T.Type.Small,T.Fonts.Number);self.SanityWarning.BackgroundColor3=T.Colors.Ink;self.SanityWarning.BackgroundTransparency=0;self.SanityWarning.Visible=false
    self.SanityWarning.TextXAlignment=Enum.TextXAlignment.Center;self.SanityWarning.TextColor3=T.Colors.Danger;Kit.Corner(self.SanityWarning);Kit.Stroke(self.SanityWarning,T.Colors.Danger,T.Style.BorderAlpha)
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
    Kit.Rect(self.Acting,{X=layout.Pathway.X,Y=layout.Pathway.Y+layout.Profile.PathwayCollapsed,W=layout.Pathway.W,H=T.Feedback.SubtitleHeight})
    Kit.Rect(self.SanityWarning,layout.Notice)
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
    local now=os.clock()
    if now-(self.LastFlash or -math.huge)<T.Visuals.FlashGap then return end
    self.LastFlash=now
    for _,tween in ipairs(self.FlashTweens) do tween:Cancel() end
    table.clear(self.FlashTweens)
    for _,f in ipairs(self.Flashes) do
        local tween=Kit.Tween(f,T.Timing.FlashIn,{BackgroundTransparency=1-math.min(T.Visuals.FlashOpacity,T.Layout.Vignette.FlashAlpha)})
        table.insert(self.FlashTweens,tween)
        tween.Completed:Once(function()
            if f.Parent and not self.ReducedMotion then table.insert(self.FlashTweens,Kit.Tween(f,T.Timing.FlashOut,{BackgroundTransparency=1})) end
        end)
    end
end
function Feedback.SetReducedMotion(self: any,reduced: boolean)
    self.ReducedMotion=reduced
    if reduced then
        for _,tween in ipairs(self.FlashTweens) do tween:Cancel() end
        table.clear(self.FlashTweens)
        for _,f in ipairs(self.Flashes) do f.BackgroundTransparency=1 end
    end
end
function Feedback.Sequence(self: any,state: any)
    self.AdvanceSerial+=1;local serial=self.AdvanceSerial
    local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
    Kit.Skin(self.Advance,state.PathwayId)
    local stroke=self.Advance:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color=Kit.PathColor(state.PathwayId) end
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
        if state.PathwayId==previous.PathwayId and state.Sequence==previous.Sequence and state.Digestion>previous.Digestion then
            self.Acting.Text=T.Ritual.DigestionText..string.format("%.1f%%",state.Digestion-previous.Digestion)
            local stroke=self.Acting:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color=Kit.PathColor(state.PathwayId) end
            self.ActingUntil=os.clock()+T.Ritual.DigestionTime
        end
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
    self.Acting.Visible=now<(self.ActingUntil or 0) and not self.Advance.Visible
    self.SanityWarning.Visible=state~=nil and state.Ready and (state.Sanity<T.Layout.Vignette.Low or state.Mode~="Normal")
    if self.SanityWarning.Visible then
        self.SanityWarning.Text=if state.Mode=="LostControl" then T.Ritual.LostText elseif state.Mode=="Madness" then T.Ritual.MadnessText else T.Ritual.SanityText
    end
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
            number.Label.Visible=visible and (number.Position-camera.CFrame.Position).Magnitude<=T.Visuals.MaxDistance
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
    self.Dash=Kit.Button(self.Root,"Dash [Q]",function() if callbacks.Dash then callbacks.Dash() end end)
    self.Dash.Name="DashButton"
    self.Sprint=Kit.Button(self.Root,"Run [Ctrl]",function() if callbacks.ToggleRun then callbacks.ToggleRun() end end)
    self.Sprint.Name="SprintButton"
    self.Hotbar=Kit.Panel(self.Root,"AbilityHotbar")
    self.Cards=Kit.New("Frame",self.Hotbar,{BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
    self.CardPadding=Kit.Padding(self.Cards,T.Layout.Desktop.BarPad)
    self.CardList=Kit.List(self.Cards,T.Layout.Desktop.SlotGap,true)
    self.Tooltip=Kit.Panel(self.Root,"AbilityTooltip");self.Tooltip.Visible=false
    self.TooltipText=Kit.Text(self.Tooltip,"",T.Type.Small);self.TooltipText.Size=UDim2.new(1,-T.Layout.Modal.Gap*2,1,0);self.TooltipText.Position=UDim2.fromOffset(T.Layout.Modal.Gap,0)
    -- Mythical Creature Ultimate button [R]
    self.UltimateCard=Kit.New("Frame",self.Root,{Name="UltimateSlot",BackgroundTransparency=1})
    self.UltimateFace=Kit.Button(self.UltimateCard,"",function() if callbacks.Ultimate then callbacks.Ultimate() end end)
    self.UltimateFace.Name="Ultimate";Kit.New("UIAspectRatioConstraint",self.UltimateFace,{AspectRatio=1})
    self.UltimateGlyph=Kit.New("Frame",self.UltimateFace,{Name="Icon",BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5)})
    self.UltimateSeal=Kit.New("Frame",self.UltimateFace,{Name="LockedSeal",BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
    self.UltimateEmptyGlyph=Kit.Glyph(self.UltimateSeal,"Seal",T.Layout.Desktop.Slot*T.Layout.Hotbar.SealSize,T.Colors.Muted)
    self.UltimateEmptyGlyph.AnchorPoint=Vector2.new(0.5,0.5);self.UltimateEmptyGlyph.Position=UDim2.fromScale(0.5,0.5)
    self.UltimateBadge=Kit.Panel(self.UltimateFace,"KeyBadge")
    self.UltimateKey=Kit.Text(self.UltimateBadge,T.Input.UltimateName,T.Type.Micro,T.Fonts.Number);self.UltimateKey.Size=UDim2.fromScale(1,1);self.UltimateKey.TextXAlignment=Enum.TextXAlignment.Center
    self.UltimateCost=Kit.Text(self.UltimateCard,T.AbilityUI.UltimateLocked,T.Type.Micro,T.Fonts.Number);self.UltimateCost.TextColor3=T.Colors.Muted;self.UltimateCost.TextXAlignment=Enum.TextXAlignment.Center
    self.UltimateCountdown=Kit.Text(self.UltimateFace,"",T.Type.Number,T.Fonts.Number);self.UltimateCountdown.AnchorPoint=Vector2.new(0.5,0.5);self.UltimateCountdown.Position=UDim2.fromScale(0.5,0.5);self.UltimateCountdown.BackgroundColor3=T.Colors.Ink;self.UltimateCountdown.BackgroundTransparency=T.Style.PanelFade;self.UltimateCountdown.Visible=false
    self.UltimateSegments={}
    for segment=1,T.Layout.Hotbar.Segments do
        local angle=(segment-1)/T.Layout.Hotbar.Segments*math.pi*2-math.pi/2
        table.insert(self.UltimateSegments,Kit.New("Frame",self.UltimateFace,{Name="CooldownSegment",BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,
            AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5+math.cos(angle)*T.Layout.Hotbar.RingRadius,0.5+math.sin(angle)*T.Layout.Hotbar.RingRadius),
            Size=UDim2.fromOffset(T.Layout.Hotbar.SegmentWidth,T.Layout.Hotbar.SegmentHeight),Rotation=math.deg(angle)+90,Visible=false}))
    end
    local function showUltimateTooltip()
        if callbacks.Touch or not self.State then return end
        local ult=Model.Ultimate(data,self.State,os.clock()-self.ReceivedAt)
        local summary=ult.Name.." ["..T.Input.UltimateName.."] · "..ult.Title
        if not ult.Unlocked then
            summary..=" · Unlocks at Sequence 4 (Incomplete Saint) and Sequence 2 (Complete Angel)"
        else
            summary..=" · "..tostring(ult.Cost).." spirituality · "..string.format("%.0fs",ult.Duration).." duration"
        end
        self.TooltipText.Text=summary
        self.Tooltip.Visible=true
    end
    self.UltimateFace.MouseEnter:Connect(showUltimateTooltip);self.UltimateFace.SelectionGained:Connect(showUltimateTooltip)
    self.UltimateFace.MouseLeave:Connect(function() self.Tooltip.Visible=false end);self.UltimateFace.SelectionLost:Connect(function() self.Tooltip.Visible=false end)
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
        local stored=Kit.Text(face,T.AbilityUI.StoredSymbol,T.Type.Small,T.Fonts.Number)
        stored.Name="StoredPower";stored.TextColor3=T.Colors.Bronze;stored.Visible=false;stored.TextXAlignment=Enum.TextXAlignment.Center
        stored.BackgroundColor3=T.Colors.Ink;stored.BackgroundTransparency=0.15
        stored.Size=UDim2.fromOffset(T.AbilityUI.StoredSize,T.AbilityUI.StoredSize)
        stored.Position=UDim2.new(1,-T.AbilityUI.StoredSize-T.AbilityUI.StoredPad,0,T.AbilityUI.StoredPad)
        Kit.Corner(stored,T.Style.FillCorner);Kit.Stroke(stored,T.Colors.Bronze,T.Style.BorderAlpha)
        local recorded=Kit.Text(face,"",T.Type.Small,T.Fonts.Number)
        recorded.Name="RecordedCharges";recorded.TextColor3=T.Colors.Teal;recorded.Visible=false
        recorded.BackgroundColor3=T.Colors.Ink;recorded.BackgroundTransparency=0.15
        recorded.Size=stored.Size;recorded.Position=stored.Position;recorded.TextXAlignment=Enum.TextXAlignment.Center
        Kit.Corner(recorded,T.Style.FillCorner);Kit.Stroke(recorded,T.Colors.Teal,T.Style.BorderAlpha)
        for segment=1,T.Layout.Hotbar.Segments do
            local angle=(segment-1)/T.Layout.Hotbar.Segments*math.pi*2-math.pi/2
            table.insert(segments,Kit.New("Frame",face,{Name="CooldownSegment",BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5+math.cos(angle)*T.Layout.Hotbar.RingRadius,0.5+math.sin(angle)*T.Layout.Hotbar.RingRadius),
                Size=UDim2.fromOffset(T.Layout.Hotbar.SegmentWidth,T.Layout.Hotbar.SegmentHeight),Rotation=math.deg(angle)+90,Visible=false}))
        end
        self.Slots[i]={Card=card,Face=face,Glyph=glyph,Seal=seal,EmptyGlyph=emptyGlyph,KeyBadge=badge,Key=key,Cost=cost,Countdown=countdown,Segments=segments,Stored=stored,Recorded=recorded,Id=false}
        local function show()
            if callbacks.Touch then return end
            local id=self.State and self.State.Loadout and self.State.Loadout[i]
            local a=id and data.Abilities[id]
            if a then
                local summary=a.Name.." ["..T.Input.KeyNames[i].."] · "..tostring(a.SpiritualityCost).." spirituality · "..string.format("%.0fs CD",a.CooldownSeconds)
                if a.Id=="Marauder_6" and self.State.StolenPower then
                    summary..=" · "..T.AbilityUI.StoredPrefix..(T.AbilityUI.PowerNames[self.State.StolenPower] or tostring(self.State.StolenPower))
                elseif a.PathwayId=="Apprentice" and (a.Operation.Kind=="Record" or a.Operation.Kind=="Release") and (self.State.RecordedCharges or 0)>0 then
                    local recName=self.State.RecordedPowerId and (T.AbilityUI.PowerNames[self.State.RecordedPowerId] or tostring(self.State.RecordedPowerId)) or "Power"
                    summary..=" · Recorded: "..recName.." ("..tostring(self.State.RecordedCharges).."x)"
                end
                self.TooltipText.Text=summary
                self.Tooltip.Visible=true
            end
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
    Kit.Rect(self.UltimateCard,layout.Ultimate);Kit.Rect(self.Dash,layout.Dash);Kit.Rect(self.Sprint,layout.Sprint)
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
    local badge=if layout.Name=="Phone" or layout.Name=="Landscape" then l.Hotbar.KeyPhone else l.Hotbar.KeySize
    for _,slot in ipairs(self.Slots) do
        slot.Card.Size=UDim2.fromOffset(p.Slot,p.HotbarHeight-l.Hotbar.Top)
        slot.Face.Size=UDim2.fromOffset(p.Slot,p.Slot)
        slot.Glyph.Size=UDim2.fromScale(l.Hotbar.GlyphFraction,l.Hotbar.GlyphFraction);slot.Glyph.AnchorPoint=Vector2.new(0.5,0.5);slot.Glyph.Position=UDim2.fromScale(0.5,0.5)
        slot.EmptyGlyph.Size=UDim2.fromOffset(p.Slot*l.Hotbar.SealSize,p.Slot*l.Hotbar.SealSize)
        slot.KeyBadge.Position=UDim2.fromOffset(l.Hotbar.KeyPad,l.Hotbar.KeyPad)
        slot.KeyBadge.Size=UDim2.fromOffset(badge,badge)
        slot.Cost.Position=UDim2.fromOffset(0,p.Slot+l.Hotbar.CostPad);slot.Cost.Size=UDim2.fromOffset(p.Slot,l.Hotbar.CostHeight)
        slot.Countdown.Size=UDim2.fromOffset(p.Slot-l.Modal.Gap,l.Hotbar.CountdownHeight)
        slot.Id=false
    end
    self.UltimateFace.Position=UDim2.fromOffset(0,l.Hotbar.Top)
    self.UltimateFace.Size=UDim2.fromOffset(p.Slot,p.Slot)
    self.UltimateGlyph.Size=UDim2.fromScale(l.Hotbar.GlyphFraction,l.Hotbar.GlyphFraction)
    self.UltimateEmptyGlyph.Size=UDim2.fromOffset(p.Slot*l.Hotbar.SealSize,p.Slot*l.Hotbar.SealSize)
    self.UltimateBadge.Position=UDim2.fromOffset(l.Hotbar.KeyPad,l.Hotbar.KeyPad)
    self.UltimateBadge.Size=UDim2.fromOffset(badge,badge)
    self.UltimateCost.Position=UDim2.fromOffset(0,l.Hotbar.Top+p.Slot+l.Hotbar.CostPad)
    self.UltimateCost.Size=UDim2.fromOffset(p.Slot,l.Hotbar.CostHeight)
    self.UltimateCountdown.Size=UDim2.fromOffset(p.Slot-l.Modal.Gap,l.Hotbar.CountdownHeight)
    self.UltimateSkinKey=nil
    self.Tooltip.Size=UDim2.fromOffset(math.min(l.Hotbar.TooltipWidth,layout.Width-p.Margin*2),l.Hotbar.TooltipHeight)
    self.Tooltip.AnchorPoint=Vector2.new(0.5,1);self.Tooltip.Position=UDim2.fromOffset(layout.Hotbar.X+layout.Hotbar.W/2,layout.Hotbar.Y-l.Hotbar.TooltipGap)
    self.Strike.Visible=self.Callbacks.Touch
    Kit.Rect(self.Strike,layout.Action)
    self:Render(self.State,self.ReceivedAt)
end
function Hud.Render(self: any,state: any,receivedAt: number)
    self.State=state;self.ReceivedAt=receivedAt
    if not state or not state.Ready then self.PathTitle.Text="Opening journal…";return end
    if self.SkinPath~=state.PathwayId then
        self.SkinPath=state.PathwayId
        Kit.Skin(self.Pathway,state.PathwayId)
        Kit.Skin(self.Hotbar,state.PathwayId)
        Kit.Skin(self.UltimateFace,state.PathwayId,true)
        Kit.Skin(self.Dash,state.PathwayId,true)
        Kit.Skin(self.Sprint,state.PathwayId,true)
        local skin=T.Skins[state.PathwayId] or T.Skins.Seer
        self.UltimateFace.BackgroundColor3=skin.Backing
        for _,segment in ipairs(self.UltimateSegments) do segment.BackgroundColor3=skin.Accent end
        for _,slot in ipairs(self.Slots) do
            Kit.Skin(slot.Face,state.PathwayId,true)
            slot.Face.BackgroundColor3=skin.Backing
            for _,segment in ipairs(slot.Segments) do segment.BackgroundColor3=skin.Accent end
        end
    end
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
    local ult=Model.Ultimate(self.Data,state,0)
    local ultSkinKey=tostring(state.PathwayId)..":"..tostring(ult.Unlocked)..":"..tostring(ult.Stage)
    if self.UltimateSkinKey~=ultSkinKey and self.Layout then
        self.UltimateSkinKey=ultSkinKey
        Kit.Clear(self.UltimateGlyph)
        self.UltimateSeal.Visible=not ult.Unlocked
        if ult.Unlocked then
            local skin=T.Skins[state.PathwayId] or T.Skins.Seer
            local icon=Kit.Glyph(self.UltimateGlyph,skin.UltimateGlyph or "Worm",self.Layout.Profile.Slot*T.Layout.Hotbar.GlyphFraction,Kit.PathColor(state.PathwayId))
            icon.Size=UDim2.fromScale(1,1)
        end
    end
    local running=state.Running~=false
    self.Sprint.Text=(if running then T.AbilityUI.RunLabel else T.AbilityUI.WalkLabel).." ["..T.Input.SprintName.."]"
    self.Sprint.TextColor3=if running then Kit.PathColor(state.PathwayId) else T.Colors.Muted
    for i,slot in ipairs(self.Slots) do
        local id=state.Loadout[i];local a=id and self.Data.Abilities[id]
        slot.Stored.Visible=id=="Marauder_6" and type(state.StolenPower)=="string"
        slot.Recorded.Visible=a~=nil and a.PathwayId=="Apprentice" and (a.Operation.Kind=="Record" or a.Operation.Kind=="Release") and (state.RecordedCharges or 0)>0
        slot.Recorded.Text=tostring(state.RecordedCharges or 0)
        if a then
            slot.Cost.TextColor3=if (state.Spirituality or 0)>=a.SpiritualityCost then T.Colors.Spirituality else T.Colors.Muted
        end
        if slot.Id~=id then
            slot.Id=id;Kit.Clear(slot.Glyph)
            slot.Seal.Visible=not a;slot.KeyBadge.Visible=a~=nil;slot.Cost.Text=if a then "✦ "..tostring(a.SpiritualityCost) else ""
            for _,child in ipairs(slot.Face:GetChildren()) do if child:IsA("UIStroke") then child.Transparency=if a then T.Style.BorderAlpha else 1 end end
            if a and self.Layout then
                local icon=Kit.Glyph(slot.Glyph,Kit.AbilityGlyph(a),self.Layout.Profile.Slot*T.Layout.Hotbar.GlyphFraction,Kit.PathColor(a.PathwayId))
                icon.Size=UDim2.fromScale(1,1)
            end
        end
    end
    self:Step(os.clock())
end
function Hud.SetVisualCast(self: any,event: any)
    if event and event.Phase=="Begin" then self.VisualCast=event
    else
        self.VisualCast=nil
        if event then self.FinishedVisualToken=math.max(self.FinishedVisualToken or 0,event.Token) end
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
        if (slot.PreviousCooldown or 0)>0 and remaining==0 then slot.ReadyUntil=now+T.Skins.ReadyTime end
        slot.PreviousCooldown=remaining
        local reduced=self.Callbacks.ReducedMotion and self.Callbacks.ReducedMotion()
        local ready=not reduced and now<(slot.ReadyUntil or 0)
        for _,child in ipairs(slot.Face:GetChildren()) do
            if child:IsA("UIStroke") then child.Transparency=if not a then 1 elseif ready then T.Skins.ReadyAlpha else T.Style.BorderAlpha end
        end
        slot.Countdown.Visible=remaining>0
        slot.Countdown.Text=if remaining>0 then string.format("%.1f",remaining) else ""
        for i,segment in ipairs(slot.Segments) do segment.Visible=i<=n end
    end
    local ult=Model.Ultimate(self.Data,state,elapsed)
    local ultTotal=math.max(1,self.Data.Runtime.Ultimate and self.Data.Runtime.Ultimate.CooldownSeconds or 45)
    local ultSegs=if ult.Active then math.ceil(math.clamp(ult.Remaining/math.max(1,ult.Duration),0,1)*T.Layout.Hotbar.Segments)
        elseif ult.Unlocked then math.ceil(math.clamp(ult.Cooldown/ultTotal,0,1)*T.Layout.Hotbar.Segments) else 0
    for i,segment in ipairs(self.UltimateSegments) do segment.Visible=i<=ultSegs end
    self.UltimateCountdown.Visible=ult.Active or ult.Cooldown>0
    self.UltimateCountdown.Text=if ult.Active then string.format("%.1f",ult.Remaining) elseif ult.Cooldown>0 then string.format("%.0f",ult.Cooldown) else ""
    self.UltimateCost.Text=if not ult.Unlocked then T.AbilityUI.UltimateLocked elseif ult.Active then ult.Stage elseif ult.Stage=="Complete" then T.AbilityUI.UltimateComplete else T.AbilityUI.UltimatePartial
    self.UltimateCost.TextColor3=if not ult.Unlocked then T.Colors.Muted elseif ult.Active then Kit.PathColor(state.PathwayId) else T.Colors.Spirituality
    for _,child in ipairs(self.UltimateFace:GetChildren()) do
        if child:IsA("UIStroke") then child.Transparency=if not ult.Unlocked then 0.65 elseif ult.Active then T.Skins.ReadyAlpha else T.Style.BorderAlpha end
    end
    local dashRem=Model.Cooldown(state,"Dash",elapsed)
    self.Dash.Text=if dashRem>0 then string.format("Dash %.1fs",dashRem) else T.AbilityUI.DashReady.." ["..T.Input.DashName.."]"
    self.Dash.TextColor3=if dashRem>0 then T.Colors.Muted else T.Colors.Text
    local visual=self.VisualCast
    if visual and workspace:GetServerTimeNow()>visual.EndsAt+T.AbilityUI.CastGrace then self.VisualCast=nil;visual=nil end
    local stale=(self.FinishedVisualToken or 0)>0 and (state.VisualToken or 0)<=(self.FinishedVisualToken or 0)
    local a=if visual then self.Data.Abilities[visual.AbilityId] elseif not stale and state.Casting then self.Data.Abilities[state.Casting] else nil
    self.Cast.Visible=a~=nil
    if a then
        local remaining=if visual then math.max(0,visual.EndsAt-workspace:GetServerTimeNow()) else math.max(0,(state.CastRemaining or a.CastTimeSeconds)-elapsed)
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
    local function enter()
        Kit.Sound(b,"Hover")
        local base=b:GetAttribute("SkinBase") or T.Colors.Slate
        local accent=b:GetAttribute("SkinAccent") or T.Colors.Gold
        Kit.Tween(b,T.Timing.Hover,{BackgroundColor3=base:Lerp(accent,T.Style.HoverBlend)})
    end
    local function leave() Kit.Tween(b,T.Timing.Return,{BackgroundColor3=b:GetAttribute("SkinBase") or T.Colors.Slate}) end
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
function Kit.AbilityGlyph(a: any): string
    return (a and T.AbilityGlyphs and T.AbilityGlyphs[a.Id]) or (a and a.Operation and T.OperationGlyph[a.Operation.Kind]) or "Seal"
end
-- All ornaments are original line geometry with no input surface or external image.
function Kit.Skin(parent: Instance,pathway: any,small: boolean?): any
    local old=parent:FindFirstChild("PathwaySkin");if old then old:Destroy() end
    local spec=T.Skins[pathway] or T.Skins.Seer
    if parent:IsA("TextButton") then parent:SetAttribute("SkinBase",spec.Backing);parent:SetAttribute("SkinAccent",spec.Accent) end
    local root=Kit.New("Frame",parent,{Name="PathwaySkin",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=1})
    local spine=Kit.New("Frame",root,{Name="Spine",BorderSizePixel=0,BackgroundColor3=spec.Accent,
        BackgroundTransparency=T.Skins.OrnamentAlpha,Size=UDim2.new(0,T.Skins.Spine,1,-T.Skins.Inset*2),Position=UDim2.fromOffset(T.Skins.Inset,T.Skins.Inset)})
    if small then
        spine.Visible=false
        for _,side in ipairs({0,1}) do
            for _,edge in ipairs({0,1}) do
                Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                    AnchorPoint=Vector2.new(side,edge),Position=UDim2.new(side,if side==0 then T.Skins.Inset else -T.Skins.Inset,edge,if edge==0 then T.Skins.Inset else -T.Skins.Inset),
                    Size=UDim2.new(T.Skins.CornerLength,0,0,T.Style.Stroke),Rotation=if pathway=="Marauder" then spec.Rotation else 0})
            end
        end
        if pathway=="Seer" then
            Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,T.Skins.Inset),Size=UDim2.new(0.5,0,0,T.Style.Stroke),Rotation=spec.Rotation})
            Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-T.Skins.Inset),Size=UDim2.new(0.36,0,0,T.Style.Stroke),Rotation=-spec.Rotation})
        elseif pathway=="Marauder" then
            Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-T.Skins.Inset,0.5,0),Size=UDim2.new(0,T.Style.Stroke,0.34,0),Rotation=spec.Rotation})
        elseif pathway=="Apprentice" then
            for _,side in ipairs({0,1}) do
                Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                    Position=UDim2.new(side,if side==0 then T.Skins.Inset else -T.Skins.Inset,0,T.Skins.Inset),Size=UDim2.new(0,T.Style.Stroke,1,-T.Skins.Inset*2)})
            end
            Kit.New("Frame",root,{BorderSizePixel=0,BackgroundColor3=spec.Accent,BackgroundTransparency=T.Skins.OrnamentAlpha,
                AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,T.Skins.Inset+2),Size=UDim2.new(0.56,0,0,T.Style.Stroke)})
        end
    else
        -- Large panel folio ornament: top/bottom hairlines and pathway motif accents
        Kit.New("Frame",root,{Name="TopRule",BorderSizePixel=0,BackgroundColor3=spec.Accent,
            BackgroundTransparency=T.Style.GoldHairlineAlpha,Position=UDim2.fromOffset(T.Skins.Inset+T.Skins.Spine+4,T.Skins.Inset),
            Size=UDim2.new(1,-(T.Skins.Inset*2+T.Skins.Spine+8),0,T.Style.Stroke),Rotation=if pathway=="Marauder" then 0.5 else 0})
        if pathway=="Seer" then
            Kit.New("Frame",root,{Name="BottomRule",BorderSizePixel=0,BackgroundColor3=spec.Accent,
                BackgroundTransparency=T.Style.GoldHairlineAlpha,Position=UDim2.new(0,T.Skins.Inset+T.Skins.Spine+4,1,-T.Skins.Inset-1),
                Size=UDim2.new(0.65,0,0,T.Style.Stroke)})
        elseif pathway=="Marauder" then
            Kit.New("Frame",root,{Name="SplitRule",BorderSizePixel=0,BackgroundColor3=spec.Accent,
                BackgroundTransparency=T.Skins.OrnamentAlpha,AnchorPoint=Vector2.new(1,1),
                Position=UDim2.new(1,-T.Skins.Inset,1,-T.Skins.Inset),Size=UDim2.new(0.28,0,0,T.Style.Stroke),Rotation=spec.Rotation})
        elseif pathway=="Apprentice" then
            Kit.New("Frame",root,{Name="RightJamb",BorderSizePixel=0,BackgroundColor3=spec.Accent,
                BackgroundTransparency=T.Skins.OrnamentAlpha,AnchorPoint=Vector2.new(1,0),
                Position=UDim2.new(1,-T.Skins.Inset,0,T.Skins.Inset),Size=UDim2.new(0,T.Style.Stroke,1,-T.Skins.Inset*2)})
        end
    end
    return root
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
    local self: any={Data=data,Callbacks=callbacks,State=nil,Tab="Journal",SelectedSlot=1,View="Page",PreviewId=nil,Purchase=false,Waiting=false,Rows={},LastKey="",ReducedMotion=false,LowGraphics=false}
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
    local state=self.State
    local pathAccent=Kit.PathColor(state and state.PathwayId)
    Kit.Skin(self.Card,state and state.PathwayId)
    local oldScroll=self.Scroll.CanvasPosition
    Kit.Clear(self.PreviewActions);Kit.Clear(self.Scroll);Kit.List(self.Scroll,T.Layout.Modal.Gap);self.Rows={}
    self.Title.Text=if self.View=="Preview" then (if self.Purchase then "POTION ALTAR" else "POTION RITUAL") else "BEYONDER "..string.upper(self.Tab)
    self.Footer.Text=if self.View=="Preview" then "The altar seals only what you confirm." else "1–6 · skills  |  R · ultimate  |  Q · dash  |  Ctrl · walk/run  |  B · close"
    for name,b in pairs(self.Tabs) do
        local active=name==self.Tab
        b.BackgroundColor3=if active then T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend) else T.Colors.Slate
        b.TextColor3=if active then pathAccent else T.Colors.Text
        local stroke=b:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color=if active then pathAccent else T.Colors.Gold;stroke.Transparency=if active then T.Skins.ReadyAlpha else T.Style.BorderAlpha end
    end
    if not state or not state.Ready then self:TextRow("Your journal is opening…");return end
    if self.View=="Preview" then
        local view=Model.Potion(self.Data,state,self.PreviewId,self.Purchase)
        local potion=view.Potion
        if potion then
            local row=Kit.New("Frame",self.Scroll,{Size=UDim2.new(1,0,0,T.Layout.Modal.Bottle),BackgroundTransparency=1})
            Kit.Glyph(row,"Bottle",T.Layout.Modal.Bottle,Kit.PathColor(potion.PathwayId))
            local title=Kit.Text(row,potion.Name,self.Layout.Profile.HeadingSize,T.Fonts.Heading)
            title.Position=UDim2.fromOffset(T.Layout.Modal.Bottle+T.Layout.Modal.Gap,0);title.Size=UDim2.new(1,-T.Layout.Modal.Bottle-T.Layout.Modal.Gap,1,0)
            self:TextRow(potion.PathwayId.." · "..(if potion.TargetSequence==9 then "Uninitiated → Sequence 9" else "Sequence "..tostring(potion.RequiredSequence).." → Sequence "..tostring(potion.TargetSequence)))
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
        if type(state.RecordedPowerId)=="string" and (state.RecordedCharges or 0)>0 then
            self:TextRow("Recorded inscription: "..(T.AbilityUI.PowerNames[state.RecordedPowerId] or state.RecordedPowerId).." · "..state.RecordedCharges.." uses remaining.")
        end
        if type(state.StolenPower)=="string" then
            self:TextRow(T.AbilityUI.StoredPrefix..(T.AbilityUI.PowerNames[state.StolenPower] or state.StolenPower).." · cast Ability Theft again to release it.")
        end
        self:TextRow((T.Skins[state.PathwayId] or T.Skins.Seer).Name.." · The acting method",true)
        if state.PathwayId then
            local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
            self:TextRow(seq.ActingObjectives[1].Label)
            self:TextRow(string.format("Digestion %.1f%% · Acting progress %d",state.Digestion,state.ActingProgress))
        else self:TextRow("Choose one starter potion in Inventory. Its pathway becomes your permanent path.") end
        self:TextRow("Select a hotbar slot (1–6), then click an unlocked ability below to bind it.")
        local slots=Kit.New("ScrollingFrame",self.Scroll,{Name="SlotPicker",Size=UDim2.new(1,0,0,T.Layout.Modal.SlotHeight),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
            ScrollingDirection=Enum.ScrollingDirection.X,BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,ScrollBarImageColor3=T.Colors.Gold})
        Kit.List(slots,T.Layout.Modal.NavGap,true)
        for i=1,T.Layout.Hotbar.Slots do
            local keyLabel=T.Input.KeyNames[i] or tostring(i)
            local label=tostring(i).."·"..keyLabel
            local b=Kit.Button(slots,label,function() self.SelectedSlot=i;self:Render() end)
            b.Size=UDim2.fromOffset(math.max(T.Layout.Modal.SlotHeight,54),T.Layout.Modal.SlotHeight);b.LayoutOrder=i
            local active=self.SelectedSlot==i
            if active then
                b.BackgroundColor3=T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend)
                b.TextColor3=pathAccent
                local stroke=b:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color=pathAccent;stroke.Transparency=T.Skins.ReadyAlpha end
            elseif state.Loadout and state.Loadout[i] then
                b.TextColor3=T.Colors.Text
            else
                b.TextColor3=T.Colors.Muted
            end
        end
        for _,id in ipairs(Model.Unlocked(self.Data,state)) do
            local ability=self.Data.Abilities[id]
            local equippedSlots={}
            for slotIdx=1,T.Layout.Hotbar.Slots do
                if state.Loadout and state.Loadout[slotIdx]==id then
                    table.insert(equippedSlots,T.Input.KeyNames[slotIdx] or tostring(slotIdx))
                end
            end
            local isCurrentSlot=state.Loadout and state.Loadout[self.SelectedSlot]==id
            local b=self:ActionRow("",function() self.Callbacks.Intent("Equip",{Id=id,Slot=self.SelectedSlot}) end)
            b.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,T.Layout.Modal.AbilityRow)
            if isCurrentSlot then
                b.BackgroundColor3=T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend)
                local stroke=b:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color=pathAccent;stroke.Transparency=T.Skins.ReadyAlpha end
            end
            local glyph=Kit.Glyph(b,Kit.AbilityGlyph(ability),T.Layout.Modal.Icon,Kit.PathColor(ability.PathwayId))
            glyph.Position=UDim2.fromOffset(T.Layout.Modal.Gap,(T.Layout.Modal.AbilityRow-T.Layout.Modal.Icon)/2)
            local x=T.Layout.Modal.Icon+T.Layout.Modal.Gap*2
            local titleStr=ability.Name..(if #equippedSlots>0 then "  ·  Equipped ["..table.concat(equippedSlots,",").."]" else "")
            local text=Kit.Text(b,titleStr,self.Layout.Profile.BodySize,T.Fonts.Heading)
            text.Position=UDim2.fromOffset(x,4);text.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,24)
            if #equippedSlots>0 then text.TextColor3=pathAccent end
            local desc=Kit.Text(b,ability.Description or "",T.Type.Micro,T.Fonts.Body)
            desc.Position=UDim2.fromOffset(x,28);desc.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,28);desc.TextColor3=T.Colors.Text
            local info=Kit.Text(b,"Seq "..ability.UnlockSequence.." · "..ability.SpiritualityCost.." spirit · "..ability.CooldownSeconds.."s CD · Target: "..ability.Target,T.Type.Micro,T.Fonts.Number)
            info.Position=UDim2.new(0,x,1,-T.Layout.Modal.Footer+4);info.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,T.Layout.Modal.Footer-4);info.TextColor3=T.Colors.Muted
        end
        self:ActionRow("Reduced motion: "..(if self.ReducedMotion then "on" else "off"),function()
            self.ReducedMotion=not self.ReducedMotion;self.Callbacks.ReducedMotion(self.ReducedMotion);self:Render()
        end)
        self:ActionRow("Low graphics: "..(if self.LowGraphics then "on" else "off"),function()
            self.LowGraphics=not self.LowGraphics
            if self.Callbacks.LowGraphics then self.Callbacks.LowGraphics(self.LowGraphics) end
            self:Render()
        end)
    elseif self.Tab=="Pathway" then
        if state.PathwayId then
            local path=self.Data.Pathways[state.PathwayId];local seq=path.Sequences[state.Sequence]
            self:TextRow(path.Name.." / "..path.Alias,true);self:TextRow("Sequence "..state.Sequence.." — "..seq.Name,true)
            self:TextRow(seq.ActingObjectives[1].Label)
            local ult=Model.Ultimate(self.Data,state,0)
            self:TextRow("Mythical Creature Form ["..T.Input.UltimateName.."] — "..ult.Name,true)
            if not ult.Unlocked then
                self:TextRow("Locked (Sequences 9–5) · Unlocks Incomplete Saint form at Sequence 4 and Complete Angel form at Sequence 2.")
            elseif ult.Stage=="Incomplete" then
                self:TextRow(ult.Title.." (Sequences 4–3) · "..tostring(ult.Cost).." spirit · "..string.format("%.0fs",ult.Duration).." duration · Continuous sanity strain while manifested.")
            else
                self:TextRow(ult.Title.." (Sequences 2–1) · "..tostring(ult.Cost).." spirit · "..string.format("%.0fs",ult.Duration).." duration · Stable Angelic manifestation.")
            end
            if seq.PassiveTraits and #seq.PassiveTraits>0 then
                self:TextRow("Sequence passives",true)
                for _,trait in ipairs(seq.PassiveTraits) do
                    self:TextRow(if type(trait)=="string" then trait else tostring(trait.Name).." — "..tostring(trait.Description))
                end
            end
            self:TextRow("Attributes",true)
            for _,key in ipairs({"Health","Spirituality","Strength","Agility","Perception","Intuition","Resistance"}) do
                self:TextRow(key.."   "..tostring(seq.BaseStats[key]))
            end
            self:TextRow("Earlier sequence abilities remain retained in your journal.")
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
    local keys={tostring(state.PathwayId),tostring(state.Sequence),table.concat(inventory,","),table.concat(loadout,"|"),
        tostring(state.RecordedPowerId),tostring(state.RecordedCharges),tostring(state.StolenPower),tostring(state.Digestion),tostring(state.ActingProgress),
        tostring(state.UltimateStage)}
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
-- Coordinator for server-confirmed cosmetics; no outcomes are computed here.
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local C=require(Shared.VfxConfig)
local Kit=require(script.Parent.Kit)
local Visuals=script.Parent.Parent.Visuals
local VfxService=require(Visuals.VfxService)
local Blocks=require(Visuals.EffectBlocks)
local AnimationController=require(Visuals.AnimationController)
local CameraFeel=require(Visuals.CameraFeel)
local HitPresentation=require(Visuals.HitPresentation)
local AbilityPresentation=require(Visuals.AbilityPresentation)
local CharacterArt=require(Visuals.CharacterArt)
local EnemyPresentation=require(Visuals.EnemyPresentation)
local Presentation={}
function Presentation.new(gui: Instance,data: any,callbacks: any?): any
    local cb=callbacks or {}
    local self: any=setmetatable({GUI=gui,Data=data,Callbacks=cb,SoundCount=0,Controllers={},Reduced=false,Low=false,
        State=nil,Cast=nil,ScanElapsed=0,Demo=false},{__index=Presentation})
    self.VFX=VfxService.new()
    self.Blocks=Blocks.new(self.VFX,{ScreenEdgePulse=function(_color: Color3,_duration: number)
        if not self.Reduced and cb.ScreenEdgePulse then cb.ScreenEdgePulse() end
    end})
    self.Outfits=CharacterArt.new(self.VFX,self.Blocks)
    self.Enemies=EnemyPresentation.new(self.VFX,self.Blocks,data.Runtime,cb.Notice,function(hook: string) self:Audio(hook) end)
    self.Camera=CameraFeel.new()
    self.Hits=HitPresentation.new(self.VFX,self.Blocks)
    self.Abilities=AbilityPresentation.new(self.VFX,self.Blocks,data,{
        Clock=function() return workspace:GetServerTimeNow() end,
        Camera=function() return workspace.CurrentCamera end,
        LocalUserId=Players.LocalPlayer.UserId,
        Player=function(id: number) return Players:GetPlayerByUserId(id) end,
        Controller=function(character: Model) return self:Controller(character) end,
        Audio=function(hook: string) self:Audio(hook) end,
        Cast=cb.CastVisual,
    })
    self.Camera.OnHitStop=function(seconds: number)
        local controller=self:LocalController()
        if controller then controller:Pause(seconds) end
    end
    return self
end
function Presentation.Audio(self: any,hook: string,pitch: number?)
    local id=T.Sound.Abilities[hook]
    if type(id)~="number" or id<=0 or self.SoundCount>=T.Sound.MaxPlaying then return end
    self.SoundCount+=1
    local sound=Kit.New("Sound",self.GUI,{SoundId="rbxassetid://"..tostring(math.floor(id)),Volume=T.Sound.AbilityVolume,
        PlaybackSpeed=math.clamp(pitch or T.LegacyFX.Pitch,T.Sound.MinPitch,T.Sound.MaxPitch)})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();self.SoundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Presentation.Controller(self: any,character: Model?): any
    if not character or not character.Parent or not character:FindFirstChildOfClass("Humanoid") then return nil end
    if not self.Controllers[character] then
        self.Controllers[character]=AnimationController.new(character,{ReducedMotion=self.Reduced})
    end
    return self.Controllers[character]
end
function Presentation.LocalController(self: any): any
    return self:Controller(Players.LocalPlayer.Character)
end
function Presentation.SetSettings(self: any,reduced: boolean,low: boolean)
    self.Reduced=reduced;self.Low=low
    self.VFX:SetSettings(reduced,low);self.Camera:SetReducedMotion(reduced)
    for _,controller in pairs(self.Controllers) do controller:SetReducedMotion(reduced) end
end
function Presentation.Update(self: any,state: any)
    local previous=self.State;self.State=state
    self.Abilities:Update(state)
    if not state.Ready then return end
    local controller=self:LocalController()
    if controller and not self.Demo and previous and previous.Ready and state.Health<previous.Health then
        controller:Play("HitReact");self.Camera:Kick(1);self.Camera:HitStop()
    end
end
function Presentation.Event(self: any,event: any)
    if event.Kind=="AbilityVisual" or event.Kind=="StatusVisual" or event.Kind=="VisualTrigger" or event.Kind=="GateRemoval"
        or event.Kind=="GateSnapshot" or event.Kind=="EchoSnapshot" then
        local accepted=self.Abilities:Event(event)
        if accepted and event.Kind=="AbilityVisual" and event.Phase=="Result" and event.Owner==Players.LocalPlayer.UserId
            and self.VFX:Visible(event.Position) then
            self.Camera:Kick(event.Tier)
        end
        return
    end
    if event.Kind=="PotionConfirmed" then
        if type(event.At)~="number" or math.abs(workspace:GetServerTimeNow()-event.At)>C.Protocol.MaxAge or not T.CharacterArt.Trim[event.PathwayId] then return end
        local controller=self:LocalController();if controller then controller:Play("CastRelease",nil,nil,T.Ritual.Pose) end
        self.Blocks:Compose({{Name="RisingMotes",Position=event.Position,Palette=event.PathwayId,Options={Scale=T.CharacterArt.AuraScale}}},1,2,T.Ritual.DrinkTime)
        return
    end
    if not self.VFX:Visible(event.Position) then return end
    if event.Kind=="Damage" then
        self.Hits:Hit(event)
        if self.Callbacks.Damage then self.Callbacks.Damage(event) end
        if event.Owner==Players.LocalPlayer.UserId then self.Camera:Kick(1);self.Camera:HitStop() end
    elseif event.Kind=="Melee" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=if typeof(event.Character)=="Instance" and event.Character:IsA("Model") then event.Character elseif ownerPlayer then ownerPlayer.Character else nil
        local controller=self:Controller(character)
        local profile=if event.Combo==2 then "MeleeLeft" else "MeleeRight"
        if controller then controller:Play("CastRelease",nil,nil,profile) end
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local origin=if typeof(event.Origin)=="Vector3" then event.Origin else event.Position
        local dir=if typeof(event.Direction)=="Vector3" and event.Direction.Magnitude>0.01 then event.Direction.Unit else Vector3.new(0,0,-1)
        local side=Vector3.new(-dir.Z,0,dir.X)
        local sign=if event.Combo==2 then -1 else 1
        local arcStart=origin+dir*C.Melee.ArcForward+side*(sign*C.Melee.ArcSpan)+Vector3.yAxis*(C.Melee.ArcHeight*sign)
        local arcEnd=origin+dir*C.Melee.ArcEndForward-side*(sign*C.Melee.ArcSpan)-Vector3.yAxis*(C.Melee.ArcHeight*sign)
        local specs: {any}={
            {Name="ThreadBeam",Position=arcStart,Palette=palette,Options={EndPosition=arcEnd,Scale=C.Melee.SlashScale,Curve=C.Melee.ArcCurve,Draw=true,Delay=C.Melee.Windup}},
            {Name="AfterimageTrail",Position=arcStart,Palette=palette,Options={EndPosition=arcEnd,Scale=C.Melee.TrailScale,Delay=C.Melee.Windup}},
        }
        -- Cosmetic pathway vocabulary; an ordinary punch gains no supernatural outcome.
        if not self.Reduced and not self.Low then
            local motif=if palette=="Seer" then "VeilRibbon" elseif palette=="Marauder" then "GlitchFlicker" else "StarBurst"
            table.insert(specs,{Name=motif,Position=arcEnd,Palette=palette,
                Options={Scale=C.Melee.MotifScale,Delay=C.Melee.MotifDelay,Frame=CFrame.lookAt(arcEnd,arcEnd+dir)}})
        end
        if event.Target then
            table.insert(specs,{Name="ImpactFlash",Position=event.Position,Palette=palette,Options={Scale=C.Melee.ImpactScale,Delay=C.Melee.Windup}})
            table.insert(specs,{Name="RingBurst",Position=event.Position,Palette=palette,Options={Scale=C.Melee.ImpactScale,Delay=C.Melee.Windup}})
        end
        self.Blocks:Compose(specs,1,C.Composition.Priority,C.Melee.TrailLife)
    elseif event.Kind=="Dash" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=ownerPlayer and ownerPlayer.Character
        local controller=self:Controller(character)
        if controller then controller:Play("Dodge") end
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local origin=if typeof(event.Origin)=="Vector3" then event.Origin else event.Position
        local dest=if typeof(event.Destination)=="Vector3" then event.Destination else event.Position
        local dashSpecs: {any}={
            {Name="AfterimageTrail",Position=origin,Palette=palette,Options={EndPosition=dest,Scale=C.Dash.Scale}},
            {Name="RingBurst",Position=origin,Palette=palette,Options={Scale=C.Dash.Scale*0.82}},
        }
        self.Blocks:Compose(dashSpecs,1,C.Composition.Priority,C.Dash.Life)
    elseif event.Kind=="UltimateVisual" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=if typeof(event.Character)=="Instance" and event.Character:IsA("Model") then event.Character elseif ownerPlayer then ownerPlayer.Character else nil
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local controller=self:Controller(character)
        if controller then controller:Play("CastRelease",nil,nil,"Ultimate"..palette) end
        local scale=if event.Stage=="Complete" then C.Ultimate.CompleteScale else C.Ultimate.IncompleteScale
        local stencil=if palette=="Seer" then "Worm" elseif palette=="Marauder" then "Clock" else "Arch"
        local motif=if palette=="Seer" then "VeilRibbon" elseif palette=="Marauder" then "GlitchFlicker" else "DoorFrame"
        local facing=if character then character:FindFirstChild("HumanoidRootPart") else nil
        local frame=CFrame.new(event.Position)*(if facing and facing:IsA("BasePart") then facing.CFrame.Rotation else CFrame.identity)
        local ground=event.Position+Vector3.yAxis*C.Ultimate.GroundOffset
        local gesture=event.Position+Vector3.yAxis*C.Ultimate.GestureHeight
        -- Six layers, one reservation: intake -> unfold -> domain/aftermath.
        -- This is a cinematic interpretation, never a client-side damage or time-stop grant.
        local ultSpecs: {any}={
            {Name="RisingMotes",Position=gesture,Palette=palette,Options={Scale=C.Ultimate.IntakeScale,Intake=true,Life=C.Ultimate.Release}},
            {Name="SigilStencil",Position=gesture,Palette=palette,Options={Scale=scale,Glyph=stencil,LowGlyph=stencil,Frame=CFrame.new(gesture)*frame.Rotation}},
            {Name=motif,Position=ground,Palette=palette,Options={Scale=scale,Frame=CFrame.new(ground)*frame.Rotation,
                Height=C.Ultimate.VeilHeight,Delay=C.Ultimate.Release}},
            {Name="GroundRune",Position=ground,Palette=palette,Options={Scale=scale,InnerRing=true,Delay=C.Ultimate.Release}},
            {Name="ShockwaveRing",Position=ground,Palette=palette,Options={Scale=scale*C.Ultimate.DomainScale,Delay=C.Ultimate.Aftermath}},
            {Name=if palette=="Seer" then "CardFan" elseif palette=="Marauder" then "SigilStencil" else "StarBurst",
                Position=gesture,Palette=palette,Options={Scale=scale,Glyph="Clock",Frame=CFrame.new(gesture)*frame.Rotation,Delay=C.Ultimate.Aftermath}},
        }
        local handle=self.Blocks:Compose(ultSpecs,3,C.Composition.Priority+1,C.Ultimate.Life)
        if handle and event.Owner==Players.LocalPlayer.UserId then
            local update=handle.Update;local released=false
            handle.Update=function(dt: number,age: number,t: number)
                update(dt,age,t)
                if not released and age>=C.Ultimate.Release then
                    released=true
                    if self.VFX:Visible(event.Position) then self.Camera:Kick(3);self.Camera:HitStop() end
                end
            end
        end
    elseif event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch)
    elseif event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        -- Compatibility for old server reveal packets; current servers send private batches.
        self.Abilities.Status:Reveal({Targets={{Target=event.Target,Position=event.Position}},
            ExpiresAt=workspace:GetServerTimeNow()+C.Protocol.RevealLife},"Seer")
    elseif event.Kind~="Whisper" then
        local name=if event.Kind=="Defeat" then "RisingMotes" elseif event.Kind=="Substitute" then "RingBurst" else "ImpactFlash"
        self.Blocks:Compose({{Name=name,Position=event.Position,Palette="Seer",Options={Scale=C.Ability.DefaultScale}}},1,
            C.Composition.Priority,C.Composition.ResultLife)
    end
end
function Presentation.Step(self: any,dt: number)
    self.VFX:Step(dt);self.Abilities:Step();self.Outfits:Step(dt);self.Enemies:Step(dt);self.ScanElapsed+=dt
    if self.AbilityDemo and workspace:GetServerTimeNow()>=self.AbilityDemo.EndsAt then
        local demo=self.AbilityDemo;self.AbilityDemo=nil
        if demo.Windup then demo.Windup:Finish() end
        local controller=self:LocalController()
        if controller then
            controller:Stop("CastWindup",C.Composition.CancelFade)
            if not demo.Cancel then controller:Play("CastRelease",nil,nil,C.Ability.Profiles[demo.Id]) end
        end
        if not demo.Cancel then self.Abilities:Preview(demo.Id,demo.Variant,demo.Origin,demo.Destination,demo.Target) end
    end
    if self.ScanElapsed<T.TestRoom.StatInterval then return end;self.ScanElapsed=0
    local wanted={}
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if character and root and root:IsA("BasePart") and (player==Players.LocalPlayer or self.VFX:Visible(root.Position)) then
            wanted[character]=true;self:Controller(character)
        end
    end
    for character,controller in pairs(self.Controllers) do
        if not wanted[character] then controller:Destroy();self.Controllers[character]=nil end
    end
end
function Presentation.DemoAnimation(self: any,name: string)
    local controller=self:LocalController()
    if not controller then return end
    controller:Stop();controller.AutoLocomotion=false;self.Demo=true;controller:Play(name)
end
function Presentation.PreviewAbility(self: any,id: string,variant: string,origin: Vector3,destination: Vector3,target: Instance?,cancel: boolean?)
    self:StopDemoAnimation()
    local a=self.Data.Abilities[id]
    if not a then return end
    local controller=self:LocalController()
    if controller then controller:Play("CastWindup",nil,nil,C.Ability.Profiles[id]) end
    local windup=self.Abilities:Preview(id,variant,origin,destination,target,"Begin")
    self.AbilityDemo={Id=id,Variant=variant,Origin=origin,Destination=destination,Target=target,Cancel=cancel,
        Windup=windup,EndsAt=workspace:GetServerTimeNow()+a.CastTimeSeconds}
end
function Presentation.StopDemoAnimation(self: any)
    if self.AbilityDemo then
        if self.AbilityDemo.Windup then self.AbilityDemo.Windup:Finish() end
        self.AbilityDemo=nil
        local active=self:LocalController();if active then active:Stop("CastWindup",C.Composition.CancelFade) end
    end
    self.Abilities:ClearPreviews()
    if not self.Demo then return end
    self.Demo=false
    local controller=self:LocalController()
    if controller then controller:Stop();controller.AutoState=nil;controller.AutoLocomotion=true end
end
function Presentation.PreviewTrigger(self: any,id: string,trigger: string,origin: Vector3,destination: Vector3,target: Instance?)
    self:StopDemoAnimation()
    self.Abilities:Preview(id,"Confirmed",origin,destination,target,"Result",trigger)
end
function Presentation.Destroy(self: any)
    self.Outfits:Destroy();self.Enemies:Destroy();self.Abilities:Destroy();self.Camera:Destroy();self.VFX:Destroy()
    for _,controller in pairs(self.Controllers) do controller:Destroy() end
    table.clear(self.Controllers)
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
        elseif object:IsA("BillboardGui") and object.Name~="MysteriesStatus" and object.Name~="MysteriesEnemyHealth" then
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


## src/StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation`. Create matching Folder parents.

```lua
--!strict
-- Original, cosmetic choreography. Only server-authored ability packets enter Event.
local Shared=game:GetService("ReplicatedStorage").Shared
local C=require(Shared.VfxConfig)
local Anim=require(Shared.AnimConfig)
local VfxService=require(script.Parent.VfxService)
local Status=require(script.Parent.StatusPresentation)
local Choreography=require(script.Parent.Choreography)
local Families={Seer=require(script.Parent.PathwayEffects.Seer),Marauder=require(script.Parent.PathwayEffects.Marauder),Apprentice=require(script.Parent.PathwayEffects.Apprentice)}
local Ability={}
local function finite(n: any): boolean return type(n)=="number" and n==n and math.abs(n)<math.huge end
local function point(p: any): boolean
    return typeof(p)=="Vector3" and finite(p.X) and finite(p.Y) and finite(p.Z) and p.Magnitude<=C.Safety.PositionLimit
end
function Ability.new(service: any,blocks: any,data: any,callbacks: any): any
    local self: any=setmetatable({Service=service,Blocks=blocks,Data=data,Callbacks=callbacks,Records={},Previews={},LocalPath=nil,
        Status=Status.new(service,callbacks.Clock,blocks),LastCue=0,LastGateCue=0},{__index=Ability})
    return self
end
function Ability.Frame(self: any,position: Vector3): CFrame
    local camera=self.Callbacks.Camera()
    if not camera then return CFrame.new(position) end
    local direction=Vector3.new(camera.CFrame.Position.X-position.X,0,camera.CFrame.Position.Z-position.Z)
    return if direction.Magnitude>C.Blocks.Common.MinimumLength then CFrame.lookAt(position,position+direction) else CFrame.new(position)
end
function Ability.Layers(self: any,a: any,e: any): (any,number)
    local function layer(name: string,position: Vector3,opts: any?): any
        return {Name=name,Position=position,Palette=a.PathwayId,Options=opts or {}}
    end
    local profile=self.Service:Profile()
    local context={Layer=layer,Frame=function(position: Vector3) return self:Frame(position) end,Simplified=profile.Low or profile.Mobile}
    context=Choreography.Extend(a,e,context)
    if e.Phase=="Begin" then
        local timing=Anim.AbilityTimings[a.Id]
        local gestureHeight=Choreography.GestureHeight(a)
        local offset=Vector3.yAxis*gestureHeight
        local at=e.Position+offset
        local family=timing and timing.Family
        local glyph=(timing and timing.Stencil) or C.Ability.WindupGlyphs[family] or (if a.PathwayId=="Seer" then C.Ability.EyeGlyph elseif a.PathwayId=="Marauder" then C.Ability.TheftGlyph else C.Ability.DoorGlyph)
        local lowKey=glyph.."Low"
        local lowGlyph=if C.Blocks.SigilStencil.Paths[lowKey] then lowKey elseif a.PathwayId=="Seer" then C.Ability.LowEyeGlyph elseif a.PathwayId=="Marauder" then glyph else C.Ability.LowDoorGlyph
        local root=e.Character and (e.Character.PrimaryPart or e.Character:FindFirstChild("HumanoidRootPart"))
        return {layer("SigilStencil",at,{Frame=self:Frame(at),Glyph=glyph,LowGlyph=lowGlyph,Scale=C.Ability.WindupScale,
            Follow=root,Offset=offset})},
            math.max(C.Composition.CancelFade,e.EndsAt-self.Callbacks.Clock())
    end
    local layers,duration=Families[a.PathwayId].Build(a,e,context)
    if layers then return layers,duration or C.Composition.ResultLife end
    local name=C.Ability.Defaults[a.PathwayId]
    local at=e.Position
    if name=="RingBurst" or name=="DoorFrame" then at+=Vector3.yAxis*C.Ability.GroundOffset end
    local opts: any={Scale=C.Ability.DefaultScale}
    if name~="RingBurst" then opts.Frame=self:Frame(at) end
    -- Obscured readings are a small incomplete mark, never a successful reveal.
    if e.Outcome=="Obscured" then name="SigilStencil";opts.Glyph=C.Ability.TheftGlyph;opts.LowGlyph=opts.Glyph;opts.Frame=self:Frame(at) end
    return {layer(name,at,opts)},C.Composition.ResultLife
end
function Ability.Stop(self: any,record: any)
    if record.Handle then record.Handle:Finish();record.Handle=nil end
    if record.Controller then record.Controller:Stop("CastWindup",C.Composition.CancelFade) end
    if record.Active and record.Owner==self.Callbacks.LocalUserId and self.Callbacks.Cast then self.Callbacks.Cast({Phase="End",Token=record.Token}) end
    record.Active=false
end
function Ability.Valid(self: any,e: any): any
    if type(e)~="table" or e.Kind~="AbilityVisual" or type(e.AbilityId)~="string" or not self.Data.Abilities[e.AbilityId] then return nil end
    if not finite(e.Owner) or e.Owner%1~=0 or not finite(e.Token) or e.Token<1 or e.Token%1~=0 then return nil end
    if not finite(e.At) or not point(e.Position) or not finite(e.Tier) or e.Tier%1~=0 or e.Tier<1 or e.Tier>#C.Tier then return nil end
    local age=self.Callbacks.Clock()-e.At
    if age>C.Protocol.MaxAge or age< -C.Protocol.FutureTolerance then return nil end
    local player=self.Callbacks.Player(e.Owner)
    if not player or player.Character~=e.Character or typeof(e.Character)~="Instance" or not e.Character:IsA("Model") or not e.Character.Parent then return nil end
    if e.Phase=="Begin" then
        if not finite(e.EndsAt) or e.EndsAt<e.At or e.EndsAt-e.At>C.Lifetime.Maximum then return nil end
    elseif e.Phase=="Result" then
        if not point(e.Origin) or not point(e.Destination) or type(e.Outcome)~="string" then return nil end
        if e.Radius~=nil and (not finite(e.Radius) or e.Radius<0 or e.Radius>C.Safety.PositionLimit) then return nil end
        if e.Affected then
            if type(e.Affected)~="table" or #e.Affected>C.Protocol.MaxAffected then return nil end
            for _,item in ipairs(e.Affected) do if type(item)~="table" or not point(item.Position) then return nil end end
        end
        if (e.Gates or e.Echo) and (not finite(e.ExpiresAt) or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife) then return nil end
    elseif e.Phase=="Reveal" then
        if e.Owner~=self.Callbacks.LocalUserId or type(e.Targets)~="table" or #e.Targets>C.Protocol.MaxReveals or not finite(e.ExpiresAt) then return nil end
        for _,target in ipairs(e.Targets) do if type(target)~="table" or not point(target.Position) then return nil end end
    elseif e.Phase~="Cancel" then return nil end
    return player
end
function Ability.Record(self: any,e: any): any
    local record=self.Records[e.Owner]
    if record and record.Character~=e.Character then self:Stop(record);record=nil end
    if record and e.Token<record.Token then return nil end
    if record and e.Token==record.Token and record.AbilityId~=e.AbilityId then return nil end
    if not record or e.Token>record.Token then
        if record then self:Stop(record) end
        local count=0;local oldestOwner=nil;local oldest=math.huge
        for owner,item in pairs(self.Records) do
            count+=1;if item.At<oldest then oldest=item.At;oldestOwner=owner end
        end
        if count>=C.Protocol.MaxOwners and oldestOwner then self:Stop(self.Records[oldestOwner]);self.Records[oldestOwner]=nil end
        record={Owner=e.Owner,Token=e.Token,AbilityId=e.AbilityId,Character=e.Character,At=e.At,Active=false,Completed=false,Revealed=false}
        self.Records[e.Owner]=record
    end
    return record
end
function Ability.Event(self: any,e: any): boolean
    if e.Kind=="StatusVisual" or e.Kind=="GateRemoval" or e.Kind=="VisualTrigger" or e.Kind=="GateSnapshot" or e.Kind=="EchoSnapshot" then return self:Auxiliary(e) end
    local player=self:Valid(e)
    if not player then return false end
    local record=self:Record(e)
    if not record then return false end
    local a=self.Data.Abilities[e.AbilityId]
    if e.Phase=="Reveal" then
        if record.Revealed then return false end
        record.Revealed=true;self.Status:Reveal(e,a.PathwayId);return true
    end
    if e.Phase=="Begin" then
        if record.Active or record.Completed or e.EndsAt<=self.Callbacks.Clock() then return false end
        record.Active=true;record.EndsAt=e.EndsAt
        local visible=self.Service:Visible(e.Position)
        if visible or e.Owner==self.Callbacks.LocalUserId then
            record.Controller=self.Callbacks.Controller(player.Character)
            if record.Controller then record.Controller:Play("CastWindup",nil,nil,C.Ability.Profiles[a.Id]) end
            local layers,duration=self:Layers(a,e)
            record.Handle=self.Blocks:Compose(layers,e.Tier,C.Composition.WindupPriority,math.min(duration,C.Lifetime.Maximum))
            if record.Handle then record.Handle.CasterId=e.Owner;record.Handle.Character=e.Character end
        end
        if e.Owner==self.Callbacks.LocalUserId and self.Callbacks.Cast then self.Callbacks.Cast(e) end
        return true
    end
    if record.Completed then return false end
    self:Stop(record);record.Completed=true;record.At=e.At
    if e.Phase=="Cancel" then return true end
    if e.Gates then self.Status:Gate(e) end
    if e.Echo then self.Status:Echo(e) end
    local visible=self.Service:Visible(e.Position) or self.Service:Visible(e.Origin) or self.Service:Visible(e.Destination)
    if not visible then return true end
    local controller=self.Callbacks.Controller(player.Character)
    if controller then controller:Play("CastRelease",nil,nil,C.Ability.Profiles[a.Id]) end
    local layers,duration=self:Layers(a,e)
    record.Result=self.Blocks:Compose(layers,e.Tier,C.Composition.Priority,duration)
    if record.Result then record.Result.CasterId=e.Owner;record.Result.Character=e.Character end
    self.Callbacks.Audio(a.SFXHook)
    return true
end
function Ability.Update(self: any,state: any)
    local path=if state and state.Ready then tostring(state.PathwayId)..":"..tostring(state.Sequence) else nil
    if self.LocalPath~=path or not state or state.Dead or not state.Ready then
        self.Status:ClearLocal(self.Callbacks.LocalUserId)
        local record=self.Records[self.Callbacks.LocalUserId]
        if record then self:Stop(record);record.Completed=true;if record.Result then record.Result:Finish() end end
        local finishing={}
        for _,handle in pairs(self.Service.Active) do if handle.CasterId==self.Callbacks.LocalUserId then table.insert(finishing,handle) end end
        for _,handle in ipairs(finishing) do handle:Finish() end
    end
    self.LocalPath=path
end
function Ability.Auxiliary(self: any,e: any): boolean
    if not finite(e.Owner) or not finite(e.At) then return false end
    local age=self.Callbacks.Clock()-e.At
    if age>C.Protocol.MaxAge or age< -C.Protocol.FutureTolerance then return false end
    if e.Kind=="GateSnapshot" or e.Kind=="EchoSnapshot" then
        if not point(e.Position) or not finite(e.ExpiresAt) or e.ExpiresAt<=self.Callbacks.Clock()
            or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife then return false end
        if e.Kind=="GateSnapshot" and (e.AbilityId=="Apprentice_5_Secondary" or e.AbilityId=="Apprentice_1") then self.Status:Gate(e);return true end
        if e.Kind=="EchoSnapshot" and e.AbilityId=="Seer_3" then self.Status:Echo(e);return true end
        return false
    end
    if e.Kind=="StatusVisual" then
        if not point(e.Position) or not finite(e.Revision) or not finite(e.ExpiresAt) or (e.Action~="Set" and e.Action~="Remove") then return false end
        if e.Action=="Set" and (e.ExpiresAt<=self.Callbacks.Clock() or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife) then return false end
        if e.Count~=nil and (not finite(e.Count) or e.Count<0) then return false end
        if e.Required~=nil and (not finite(e.Required) or e.Required<1 or e.Required%1~=0) then return false end
        if e.Action=="Set" and e.Owner==self.Callbacks.LocalUserId and self.LocalPath
            and e.PathwayId~=string.match(self.LocalPath,"^[^:]+") then return false end
        return self.Status:Event(e,self.Callbacks.LocalUserId)
    end
    if not finite(e.CueId) or e.CueId<1 or e.CueId%1~=0 then return false end
    if e.Kind=="GateRemoval" then
        if e.CueId<=self.LastGateCue then return false end
        self.LastGateCue=e.CueId;self.Status:RemoveGates(e.Owner);return true
    end
    local expected={SubstituteTriggered="Seer_7_Secondary",GraftReflected="Seer_1",PayloadTriggered="Marauder_2_Secondary"}
    if e.CueId<=self.LastCue or expected[e.Trigger]~=e.AbilityId or not point(e.Position) or not point(e.Origin)
        or not finite(e.Tier) or e.Tier<1 or e.Tier>#C.Tier or e.Tier%1~=0 then return false end
    local player=self.Callbacks.Player(e.Owner)
    if not player or player.Character~=e.Character then return false end
    self.LastCue=e.CueId
    local event=table.clone(e);event.Phase="Result";event.Destination=e.Origin
    local layers,duration=self:Layers(self.Data.Abilities[e.AbilityId],event)
    local handle=self.Blocks:Compose(layers,e.Tier,C.Hit.Priority,duration)
    if handle then handle.CasterId=e.Owner;handle.Character=e.Character end
    if handle and self.Callbacks.Audio then self.Callbacks.Audio("Trigger."..e.Trigger) end
    return true
end
function Ability.Step(self: any)
    local now=self.Callbacks.Clock()
    for owner,record in pairs(self.Records) do
        local player=self.Callbacks.Player(owner)
        if not player or player.Character~=record.Character or not record.Character.Parent then
            self:Stop(record);if record.Result then record.Result:Finish() end;self.Records[owner]=nil
        elseif record.Active and now>record.EndsAt+C.Protocol.ResultGrace then self:Stop(record);record.Completed=true end
        if now-record.At>C.Protocol.MaxAge then self:Stop(record);self.Records[owner]=nil end
    end
    self.Status:Step()
    local finishing={}
    for _,handle in pairs(self.Service.Active) do
        if handle.Character and not handle.Character.Parent then table.insert(finishing,handle) end
    end
    for _,handle in ipairs(finishing) do handle:Finish() end
    for i=#self.Previews,1,-1 do if not self.Previews[i].Active then table.remove(self.Previews,i) end end
end
function Ability.Preview(self: any,id: string,variant: string,origin: Vector3,destination: Vector3,target: Instance?,phase: string?,trigger: string?): any
    local a=self.Data.Abilities[id]
    if not a then return nil end
    local now=self.Callbacks.Clock()
    local event={Phase=phase or "Result",Position=if a.Target=="NPC" then destination else origin,Origin=origin,Destination=if a.Target=="NPC" then origin else destination,
        Outcome=variant,Target=target,Tier=VfxService.PowerTier(a.UnlockSequence),EndsAt=now+a.CastTimeSeconds,Preview=true,Trigger=trigger,
        Radius=C.Ability.PreviewRadius,Affected={{Target=target,Position=destination}},Echo=if id=="Seer_3" then target else nil}
    local layers,duration=self:Layers(a,event)
    local handle=self.Blocks:Compose(layers,event.Tier,C.Composition.Priority,duration)
    if handle then table.insert(self.Previews,handle) end
    return handle
end
function Ability.ClearPreviews(self: any)
    for _,handle in ipairs(self.Previews) do handle:Finish() end;table.clear(self.Previews)
end
function Ability.Destroy(self: any)
    for _,record in pairs(self.Records) do self:Stop(record);if record.Result then record.Result:Finish() end end
    table.clear(self.Records);self:ClearPreviews();self.Status:Clear()
end
return Ability
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/AnimationController.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/AnimationController`. Create matching Folder parents.

```lua
--!strict
-- Local, additive Motor6D presentation. Never moves a root, changes a Humanoid
-- property, disables Animate, or changes a track loaded by another controller.
local RunService=game:GetService("RunService")
local C=require(game:GetService("ReplicatedStorage").Shared.AnimConfig)
local Spring=require(script.Parent.MotionSpring)
local AnimationController={}
AnimationController.__index=AnimationController
type MotorState={Motor: Motor6D,Role: string,Base: CFrame?,Applied: CFrame?}
type EntryState={Name: string,Entry: any,Elapsed: number,Target: number,Fade: number,Spring: any,
    Track: AnimationTrack?,Animation: Animation?,AssetAge: number,AssetFailed: boolean,Profile: string?}
type Fields={Character: Model,Humanoid: Humanoid?,Root: BasePart?,Animator: Animator?,Motors: {MotorState},
    States: {[string]: EntryState},Connections: {RBXScriptConnection},ReducedMotion: boolean,
    AutoLocomotion: boolean,AutoState: string?,PauseLeft: number,Destroyed: boolean,WasAirborne: boolean,LastVertical: number}
export type Controller=typeof(setmetatable({} :: Fields,AnimationController))
local function finite(value: number): boolean return value==value and math.abs(value)<math.huge end
local function resolve(name: string): string return C.Aliases[name] or name end
local function contentId(value: any): string?
    if type(value)~="string" or value=="" then return nil end
    local digits=string.match(value,"^rbxassetid://(%d+)$") or string.match(value,"^(%d+)$")
    local number=if digits then tonumber(digits) else nil
    return if number and number>0 then "rbxassetid://"..(digits :: string) else nil
end
local function dispose(state: EntryState)
    if state.Track then state.Track:Stop();state.Track:Destroy();state.Track=nil end
    if state.Animation then state.Animation:Destroy();state.Animation=nil end
end
function AnimationController.new(character: Model,options: any?): Controller
    local opts=options or {}
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    local root=character:FindFirstChild("HumanoidRootPart")
    local self: Controller=setmetatable({Character=character,Humanoid=humanoid,
        Root=if root and root:IsA("BasePart") then root else character.PrimaryPart,
        Animator=if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil,
        Motors={},States={},Connections={},ReducedMotion=opts.ReducedMotion==true,
        AutoLocomotion=opts.AutoLocomotion~=false,AutoState=nil,PauseLeft=0,Destroyed=false,WasAirborne=false,LastVertical=0},AnimationController)
    local function motor(instance: Instance)
        if instance:IsA("Motor6D") then
            local role=C.MotorRoles[instance.Name]
            if role then table.insert(self.Motors,{Motor=instance,Role=role,Base=nil,Applied=nil}) end
        elseif instance:IsA("BasePart") and instance.Name=="HumanoidRootPart" then
            self.Root=instance
        elseif instance:IsA("Animator") and instance.Parent==self.Humanoid then
            self.Animator=instance
        end
    end
    for _,descendant in ipairs(character:GetDescendants()) do motor(descendant) end
    table.insert(self.Connections,character.DescendantAdded:Connect(motor))
    table.insert(self.Connections,character.DescendantRemoving:Connect(function(instance: Instance)
        if instance==self.Root then self.Root=nil end
        if instance==self.Animator then self.Animator=nil end
        for i=#self.Motors,1,-1 do
            if self.Motors[i].Motor==instance then
                local m=self.Motors[i]
                if m.Applied and m.Base and m.Motor.Transform==m.Applied then m.Motor.Transform=m.Base end
                table.remove(self.Motors,i)
            end
        end
    end))
    if opts.AutoStep~=false then
        -- Animator writes after PreAnimation and before PreSimulation. Undo only
        -- our exact last transform, then compose onto that frame's authored pose.
        table.insert(self.Connections,RunService.PreAnimation:Connect(function() self:Restore() end))
        table.insert(self.Connections,RunService.PreSimulation:Connect(function(dt: number) self:Step(dt) end))
    end
    if humanoid then
        table.insert(self.Connections,humanoid.Died:Connect(function() self:Play("Death") end))
        table.insert(self.Connections,humanoid.StateChanged:Connect(function(_old: Enum.HumanoidStateType,new: Enum.HumanoidStateType)
            if new==Enum.HumanoidStateType.Jumping then self:Play("Jump") end
        end))
    end
    return self
end
function AnimationController.Restore(self: Controller)
    for _,m in ipairs(self.Motors) do
        if m.Motor.Parent and m.Base and m.Applied and m.Motor.Transform==m.Applied then m.Motor.Transform=m.Base end
        m.Base=nil;m.Applied=nil
    end
end
function AnimationController.Play(self: Controller,name: string,weight: number?,fade: number?,profile: string?): boolean
    if self.Destroyed then return false end
    name=resolve(name)
    local entry=C.Entries[name]
    if not entry then return false end
    local override=profile and C.CastProfiles[profile] and C.CastProfiles[profile][name]
    if override then
        entry=table.clone(entry)
        for key,value in pairs(override) do
            if key~="AnimationId" or value~="" then entry[key]=value end
        end
    end
    local target=if weight and finite(weight) then math.clamp(weight,0,C.Blend.MaxWeight) else C.Blend.MaxWeight
    local transition=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else entry.FadeIn
    local state: EntryState?=self.States[name]
    if state and state.Profile~=profile then dispose(state);self.States[name]=nil;state=nil end
    if not state then
        local created: EntryState={Name=name,Entry=entry,Elapsed=0,Target=target,Fade=transition,Spring=Spring.new(0),
            Track=nil,Animation=nil,AssetAge=0,AssetFailed=false,Profile=profile}
        self.States[name]=created;state=created
        local id=contentId(entry.AnimationId)
        if id and self.Animator then
            local animation=Instance.new("Animation");animation.AnimationId=id;created.Animation=animation
            local ok,track=pcall(function() return (self.Animator :: Animator):LoadAnimation(animation) end)
            if ok then
                created.Track=track;track.Priority=entry.AssetPriority;track.Looped=entry.Loop
            else
                created.AssetFailed=true;animation:Destroy();created.Animation=nil
            end
        end
    end
    assert(state)
    state.Elapsed=0;state.AssetAge=0;state.Target=target;state.Fade=transition
    local track=state.Track
    if track and not state.AssetFailed then
        track:Play(transition,target,if self.PauseLeft>0 then 0 else 1)
    end
    return true
end
function AnimationController.Stop(self: Controller,name: string?,fade: number?)
    local wanted=if name then resolve(name) else nil
    for key,state in pairs(self.States) do
        if not wanted or key==wanted then
            state.Target=0
            state.Fade=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else state.Entry.FadeOut
            if state.Track then state.Track:Stop(state.Fade) end
        end
    end
end
function AnimationController.Blend(self: Controller,name: string,weight: number,fade: number?): boolean
    if self.Destroyed or not finite(weight) then return false end
    name=resolve(name)
    local state=self.States[name]
    if not state then return self:Play(name,weight,fade) end
    state.Target=math.clamp(weight,0,C.Blend.MaxWeight)
    state.Fade=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else C.Blend.Default
    if state.Track then state.Track:AdjustWeight(state.Target,state.Fade) end
    return true
end
function AnimationController.Pause(self: Controller,duration: number)
    if not finite(duration) then return end
    self.PauseLeft=math.max(self.PauseLeft,math.clamp(duration,0,C.Safety.MaxPause))
    for _,state in pairs(self.States) do
        if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(0) end
    end
end
function AnimationController.SetReducedMotion(self: Controller,reduced: boolean)
    self.ReducedMotion=reduced
    if reduced then
        self.PauseLeft=0
        for _,state in pairs(self.States) do
            if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(1) end
        end
    end
end
function AnimationController.Locomotion(self: Controller): number
    local humanoid,root=self.Humanoid,self.Root
    if not self.AutoLocomotion or not humanoid or not root then return 0 end
    if humanoid.Health<=0 then
        if not self.States.Death then self:Play("Death") end
        return 0
    end
    local velocity=root.AssemblyLinearVelocity
    local speed=Vector3.new(velocity.X,0,velocity.Z).Magnitude
    local airborne=humanoid.FloorMaterial==Enum.Material.Air
    if self.WasAirborne and not airborne and self.LastVertical<C.Locomotion.LandingVelocity then self:Play("Land") end
    self.WasAirborne=airborne;self.LastVertical=velocity.Y
    local name=if airborne or speed<C.Locomotion.MinSpeed then "Idle" elseif speed>=C.Locomotion.RunSpeed then "Run" else "Walk"
    if self.AutoState~=name then
        if self.AutoState then self:Stop(self.AutoState) end
        self.AutoState=name;self:Play(name)
    end
    return math.clamp(speed/C.Locomotion.SpeedReference,0,C.Locomotion.MaxSpeedRatio)
end
function AnimationController.Step(self: Controller,delta: number)
    if self.Destroyed or not finite(delta) or delta<0 then return end
    self:Restore()
    local dt=math.min(delta,C.Safety.MaxFrameDelta)
    local paused=self.PauseLeft>0
    self.PauseLeft=math.max(0,self.PauseLeft-dt)
    if paused and self.PauseLeft==0 then
        for _,state in pairs(self.States) do
            if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(1) end
        end
    end
    local elapsed=if paused then 0 else dt
    local speed=self:Locomotion()
    local ordered: {EntryState}={}
    local assetPriority=-math.huge
    for name,state in pairs(self.States) do
        state.Elapsed+=elapsed;state.AssetAge+=dt
        if not state.Entry.Loop and state.Elapsed>=state.Entry.Duration then
            state.Target=0;state.Fade=state.Entry.FadeOut
        end
        state.Spring.Frequency=1/state.Fade
        state.Spring:Step(elapsed,state.Target)
        if state.Track then
            local track=state.Track
            if track.Length>0 and track.IsPlaying then
                assetPriority=math.max(assetPriority,state.Entry.Priority)
                track:AdjustWeight(state.Target,state.Fade)
            elseif state.AssetAge>=C.Safety.AssetLoadGrace then
                -- Invalid/unpermitted/unloaded real assets never leave an empty pose.
                track:Stop();track:Destroy();state.Track=nil;state.AssetFailed=true
                if state.Animation then state.Animation:Destroy();state.Animation=nil end
            end
        end
        if state.Target==0 and state.Spring.Value<C.Blend.WeightEpsilon then
            dispose(state);self.States[name]=nil
        else table.insert(ordered,state) end
    end
    table.sort(ordered,function(a: EntryState,b: EntryState)
        if a.Entry.Priority==b.Entry.Priority then return a.Name<b.Name end
        return a.Entry.Priority<b.Entry.Priority
    end)
    local poses: {[string]: CFrame}={}
    for _,state in ipairs(ordered) do
        if state.Entry.Priority>assetPriority then
            local weight=math.clamp(state.Spring.Value,0,C.Blend.MaxWeight)
            if self.ReducedMotion then weight*=C.Blend.ReducedScale end
            local pose=state.Entry.Procedural(state.Entry,state.Elapsed,speed)
            for role,transform in pairs(pose) do
                poses[role]=(poses[role] or CFrame.identity):Lerp(transform,weight)
            end
        end
    end
    for _,m in ipairs(self.Motors) do
        if m.Motor.Parent then
            local offset=poses[m.Role]
            if offset then
                m.Base=m.Motor.Transform;m.Motor.Transform=(m.Base :: CFrame)*offset
                -- Store the engine's read-back value, including its precision.
                m.Applied=m.Motor.Transform
            end
        end
    end
end
function AnimationController.Destroy(self: Controller)
    if self.Destroyed then return end
    self.Destroyed=true;self:Restore()
    for _,connection in ipairs(self.Connections) do connection:Disconnect() end
    for _,state in pairs(self.States) do dispose(state) end
    table.clear(self.Connections);table.clear(self.States);table.clear(self.Motors)
end
return AnimationController
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel`. Create matching Folder parents.

```lua
--!strict
-- Additive presentation only. No physics, player input, simulation time or default
-- camera updates are paused. The prior contribution is removed before Camera.
local RunService=game:GetService("RunService")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local C=T.CameraFeel
local CameraFeel={}
local nextId=0

local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end

local function unitOrZero(x: number,y: number,z: number): Vector3
    local vector=Vector3.new(x,y,z)
    return if vector.Magnitude>C.Epsilon then vector.Unit else Vector3.zero
end

function CameraFeel.Restore(self: any)
    local camera: Camera?=self.LastCamera
    if not camera then return end
    -- An unrelated camera script may have written after this module. Preserve its
    -- new value; only undo a value we can identify as our own exact contribution.
    if self.LastOutput and camera.CFrame==self.LastOutput then camera.CFrame=self.LastBase end
    if self.LastOutputFov and math.abs(camera.FieldOfView-self.LastOutputFov)<=C.Epsilon then
        camera.FieldOfView=self.LastBaseFov
    end
    self.LastCamera=nil;self.LastOutput=nil;self.LastOutputFov=nil
end

function CameraFeel.Step(self: any,delta: number)
    if self.Destroyed then return end
    self.SinceKick+=delta
    if self.ReducedMotion or self.Life<=0 then return end
    local dt=math.clamp(delta,0,C.StepCap)
    local held=math.min(self.Hold,dt)
    self.Hold-=held;self.Elapsed+=dt-held
    if self.Elapsed>=self.Life then self.Life=0;return end
    local camera=workspace.CurrentCamera
    if not camera then return end
    local remaining=1-self.Elapsed/self.Life
    -- A short attack and a firm settle, with the existing displacement/FOV caps.
    local attack=math.clamp((self.Elapsed+self.Hold)/C.Attack,0,1)
    local envelope=attack*remaining^C.SettlePower
    local time=self.Elapsed*C.Frequency*math.pi*2
    local ratio=C.FrequencyRatio
    local phase=C.Phase
    local axis=C.ShakeAxis
    local rotation=C.RotationAxis
    local x=math.sin(time*ratio.X+phase.X)
    local y=math.sin(time*ratio.Y+phase.Y)
    local z=math.sin(time*ratio.Z+phase.Z)
    -- Normalize the direction, then scale by the envelope. Simultaneous events
    -- share this single envelope, so vector magnitude cannot add past the cap.
    local translation=unitOrZero(x*axis.X,y*axis.Y,z*axis.Z)*self.Studs*envelope
    local angles=unitOrZero(y*rotation.X,z*rotation.Y,x*rotation.Z)*math.rad(self.Degrees)*envelope
    local base=camera.CFrame
    local baseFov=camera.FieldOfView
    local output=base*CFrame.new(translation)*CFrame.Angles(angles.X,angles.Y,angles.Z)
    local outputFov=math.clamp(baseFov+self.Fov*envelope,C.FovMin,C.FovMax)
    self.LastCamera=camera;self.LastBase=base;self.LastOutput=output
    self.LastBaseFov=baseFov;self.LastOutputFov=outputFov
    camera.CFrame=output;camera.FieldOfView=outputFov
end

function CameraFeel.new(): any
    nextId+=1
    local self: any=setmetatable({Destroyed=false,ReducedMotion=false,Elapsed=0,Life=0,
        Hold=0,Studs=0,Degrees=0,Fov=0,SinceKick=math.huge,OnHitStop=nil,
        BeforeName="MysteriesCameraRestore"..nextId,AfterName="MysteriesCameraFeel"..nextId}, {__index=CameraFeel})
    RunService:BindToRenderStep(self.BeforeName,Enum.RenderPriority.Camera.Value+C.BeforePriorityOffset,function()
        self:Restore()
    end)
    RunService:BindToRenderStep(self.AfterName,Enum.RenderPriority.Camera.Value+C.AfterPriorityOffset,function(dt: number)
        self:Step(dt)
    end)
    return self
end

function CameraFeel.Kick(self: any,tier: number?): boolean
    if self.Destroyed or self.ReducedMotion then return false end
    local selected=if type(tier)=="number" and finite(tier) then tier else C.DefaultTier
    local fraction=math.clamp((selected-C.DefaultTier)/(C.MajorTier-C.DefaultTier),0,1)
    local studs=C.SmallStuds+(C.MajorStuds-C.SmallStuds)*fraction
    if self.SinceKick<C.KickGap and studs<=self.Studs then return false end
    self.Studs=math.min(studs,C.MajorStuds)
    self.Degrees=math.min(C.SmallDegrees+(C.MajorDegrees-C.SmallDegrees)*fraction,C.MajorDegrees)
    self.Life=C.SmallDuration+(C.MajorDuration-C.SmallDuration)*fraction
    self.Fov=math.min(C.FovKick*self.Studs/C.MajorStuds,C.MaxFovKick)
    self.Elapsed=0;self.Hold=0;self.SinceKick=0
    return true
end

function CameraFeel.HitStop(self: any,duration: number?): number
    if self.Destroyed or self.ReducedMotion then return 0 end
    local selected=if type(duration)=="number" and finite(duration) then duration else C.HitStop
    local seconds=math.clamp(selected,0,C.MaxHitStop)
    self.Hold=math.max(self.Hold,seconds)
    -- The caller can pause its procedural character overlay for the same time.
    -- This never changes Animator playback speed or delays a gameplay action.
    if seconds>0 and self.OnHitStop then self.OnHitStop(seconds) end
    return seconds
end

function CameraFeel.SetReducedMotion(self: any,reduced: boolean)
    self.ReducedMotion=reduced==true
    if self.ReducedMotion then
        self.Life=0;self.Hold=0;self.SinceKick=math.huge;self:Restore()
    end
end

function CameraFeel.Destroy(self: any)
    if self.Destroyed then return end
    self.Destroyed=true
    RunService:UnbindFromRenderStep(self.BeforeName)
    RunService:UnbindFromRenderStep(self.AfterName)
    self:Restore();self.OnHitStop=nil
end

return CameraFeel
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt`. Create matching Folder parents.

```lua
--!strict
-- Cosmetic, locally welded clothing and procedural Mythical Creature Form manifestations.
-- Never writes body colors/scales or Humanoid state.
local Players=game:GetService("Players")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local A=T.CharacterArt
local M=A.Mythical
local Outfit={}
function Outfit.new(service: any,blocks: any): any
    return setmetatable({Service=service,Blocks=blocks,Records={},Elapsed=0,AuraAt=0},{__index=Outfit})
end
function Outfit.Clear(self: any,character: Model)
    local record=self.Records[character]
    if record then record.Model:Destroy();self.Records[character]=nil end
end
function Outfit.Build(self: any,character: Model,path: string,sequence: number,torso: BasePart,head: BasePart,myth: string?)
    self:Clear(character)
    local stage=if myth=="Incomplete" or myth=="Complete" then myth else ""
    local model=Instance.new("Model");model.Name="LocalMysteriesOutfit";model.Parent=character
    local count=0;local cloth=A.Cloth[path];local trim=A.Trim[path]
    local motions: {any}={};local faces: {any}={};local ornaments: {any}={}
    local function piece(name: string,base: BasePart,size: {number},offset: CFrame,color: Color3,material: Enum.Material?,alpha: number?): any
        if count>=A.MaxParts then return end;count+=1
        local part=Instance.new("Part");part.Name=name;part.Size=Vector3.new(table.unpack(size));part.CFrame=base.CFrame*offset
        part.Anchored=false;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Massless=true;part.CastShadow=false
        part.Material=material or Enum.Material.Fabric;part.Color=color;part.Transparency=alpha or 0;part.Parent=model
        local pose=offset
        local lower=string.lower(name)
        local clock=string.find(lower,"clock wheel") or string.find(lower,"bezel") or string.find(lower,"clock arc")
        local halo=string.find(lower,"halo") or string.find(lower,"crown ring") or string.find(lower,"key-seal") or string.find(lower,"time ring")
        local worm=string.find(lower,"worm") or string.find(lower,"tentacle")
        local hand=string.find(lower,"hand")
        if stage~="" and clock then
            part.Shape=Enum.PartType.Cylinder
            part.Size=Vector3.new(M.ClockDepth,size[1],size[2])
            pose=offset*CFrame.Angles(0,math.pi/2,0)
            if string.find(lower,"clock wheel") then
                -- Two fixed, occluded faces: 12 radial sections, no extra Parts or unpooled Beams.
                for _,face in ipairs({Enum.NormalId.Left,Enum.NormalId.Right}) do
                    local gui=Instance.new("SurfaceGui");gui.Name="Twelve temporal sections";gui.Face=face
                    gui.CanvasSize=Vector2.new(M.ClockCanvas,M.ClockCanvas);gui.AlwaysOnTop=false
                    gui.LightInfluence=1;gui.MaxDistance=M.ClockMaxDistance;gui.Enabled=false;gui.Parent=part
                    table.insert(faces,gui)
                    for i=1,M.ClockSegments do
                        local angle=(i-1)*math.pi*2/M.ClockSegments
                        local tick=Instance.new("Frame");tick.Name="Clock sector "..i
                        tick.AnchorPoint=Vector2.new(0.5,0.5)
                        tick.Position=UDim2.fromScale(0.5+math.sin(angle)*M.ClockRadius,0.5-math.cos(angle)*M.ClockRadius)
                        tick.Size=UDim2.fromScale(M.ClockTickWidth,M.ClockTickHeight);tick.Rotation=math.deg(angle)
                        tick.BorderSizePixel=0;tick.BackgroundColor3=T.Colors.Bronze
                        tick.BackgroundTransparency=M.ClockTickAlpha;tick.Parent=gui
                    end
                end
            end
        elseif stage~="" and halo then
            part.Shape=Enum.PartType.Cylinder;part.Size=Vector3.new(size[2],size[1],size[3])
            pose=offset*CFrame.Angles(0,0,math.pi/2)
            part.Transparency=math.max(part.Transparency,M.SpiritAlpha)
            for _,face in ipairs({Enum.NormalId.Left,Enum.NormalId.Right}) do
                local gui=Instance.new("SurfaceGui");gui.Name="Spirit halo engraving";gui.Face=face
                gui.CanvasSize=Vector2.new(M.ClockCanvas,M.ClockCanvas);gui.AlwaysOnTop=false
                gui.LightInfluence=1;gui.MaxDistance=M.ClockMaxDistance;gui.Enabled=false;gui.Parent=part
                table.insert(ornaments,gui)
                local ring=Instance.new("Frame");ring.BackgroundTransparency=1
                ring.Position=UDim2.fromScale(M.HaloInset,M.HaloInset)
                ring.Size=UDim2.fromScale(1-M.HaloInset*2,1-M.HaloInset*2);ring.Parent=gui
                local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0.5,0);corner.Parent=ring
                local stroke=Instance.new("UIStroke");stroke.Color=color;stroke.Thickness=M.HaloStroke;stroke.Transparency=M.GlowAlpha;stroke.Parent=ring
            end
        elseif stage~="" and worm then
            part.Shape=Enum.PartType.Ball
        end
        local weld=Instance.new("Weld");weld.Part0=base;weld.Part1=part;weld.C0=pose;weld.Parent=part
        table.insert(motions,{Part=part,Weld=weld,Base=pose,Alpha=part.Transparency,
            Phase=count,Kind=if hand then "Hand" elseif halo then "Halo" elseif worm then "Worm" else "Float",
            Sign=if string.find(lower,"minute") then -1 else 1})
        if stage~="" and not self.Service.ReducedMotion and not self.Service.LowGraphics then part.Transparency=1 end
        return part
    end
    local bodyScale=math.clamp(torso.Size.X/2,A.BodyScaleMin,A.BodyScaleMax)
    local coat={A.Coat[1]*bodyScale,math.max(A.Coat[2],torso.Size.Y),math.max(A.Coat[3],torso.Size.Z+A.CoatClearance)}
    if stage=="Complete" then
        if path=="Seer" then
            -- Original cinematic Angel interpretation: Worms of Spirit (dark translucent cloak + blank mask + tentacled spirit-worm collective)
            piece("Spirit cloak mantle",torso,{coat[1]*1.14,coat[2]*1.12,coat[3]*1.14},CFrame.identity,T.Colors.DeepPurple,Enum.Material.Glass,M.CloakAlpha)
            piece("Boiling fog shroud",torso,{coat[1]*1.22,coat[2]*0.95,coat[3]*1.2},CFrame.new(0,-0.15,0.12),T.Colors.Fog,Enum.Material.Neon,M.SpiritAlpha)
            piece("Cold blank mask",head,M.SeerMask,CFrame.new(0,0,-head.Size.Z/2-0.08),T.Colors.Text,Enum.Material.SmoothPlastic,0.08)
            piece("Antique spirit halo",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.35,0.2)*CFrame.Angles(math.rad(72),0,0),T.Colors.Gold,Enum.Material.Neon,M.GlowAlpha)
            for idx,angle in ipairs({-45,0,45}) do
                local rad=math.rad(angle)
                local first=piece("Worm of Spirit tentacle "..idx,torso,M.SeerWorm,
                    CFrame.new(math.sin(rad)*1.05,-coat[2]/2-0.35,math.cos(rad)*0.65)*CFrame.Angles(math.rad(24),rad,math.rad(angle*0.4)),
                    T.Colors.DeepPurple,Enum.Material.SmoothPlastic,M.WormAlpha)
                if first then
                    piece("Spirit tentacle tip "..idx,first,M.SeerWorm,CFrame.new(0,-M.SeerWorm[2]*0.8,0)*CFrame.Angles(math.rad(-24),0,rad),
                        T.Colors.Fog,Enum.Material.Glass,M.GlowAlpha)
                end
            end
        elseif path=="Marauder" then
            -- Original cinematic Angel interpretation: Worms of Time (12-section ancient stone clock phantom + ringed Worms of Time)
            piece("Chronos dark shroud",torso,{coat[1]*1.1,coat[2]*1.06,coat[3]*1.1},CFrame.identity,T.Colors.Black,Enum.Material.SmoothPlastic,0.12)
            piece("Ancient stone clock wheel",torso,M.MarauderClockRim,CFrame.new(0,0.45,coat[3]/2+0.55),T.Colors.Stone,Enum.Material.Slate,0.08)
            piece("Clockwork bronze bezel",torso,{M.MarauderClockRim[1]*0.86,M.MarauderClockRim[2]*0.86,0.18},CFrame.new(0,0.45,coat[3]/2+0.48),T.Colors.Bronze,Enum.Material.Metal,0.05)
            piece("Crimson hour hand",torso,M.MarauderHand,CFrame.new(0.28,0.85,coat[3]/2+0.42)*CFrame.Angles(0,0,math.rad(-36)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            piece("Bronze minute hand",torso,{M.MarauderHand[1]*0.85,M.MarauderHand[2]*1.28,M.MarauderHand[3]},CFrame.new(-0.35,1.05,coat[3]/2+0.4)*CFrame.Angles(0,0,math.rad(28)),T.Colors.Bronze,Enum.Material.Neon,M.GlowAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Ringed Worm of Time "..tostring(idx),torso,M.MarauderRing,CFrame.new(side*1.05,0.15,-0.1)*CFrame.Angles(math.rad(32),0,math.rad(side*38)),T.Colors.Silver,Enum.Material.Glass,M.GlowAlpha)
                piece("Time pattern ring "..tostring(idx),torso,{0.85,0.14,0.85},CFrame.new(side*1.05,-0.45,0.15)*CFrame.Angles(math.rad(-22),0,math.rad(side*-28)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Temporal crown ring",head,{1.65,0.14,1.65},CFrame.new(0,head.Size.Y/2+0.28,0)*CFrame.Angles(math.rad(14),0,math.rad(-16)),T.Colors.Bronze,Enum.Material.Neon,M.GlowAlpha)
        else
            -- Original cinematic Angel interpretation: Worms of Star ("Door of All Doors" — nested astral doorways of starlight & teal)
            piece("Astral light core",torso,{coat[1]*1.08,coat[2]*1.06,coat[3]*1.08},CFrame.identity,T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
            for _,side in ipairs({-1,1}) do
                piece("Outer astral door jamb",torso,M.ApprenticeJamb,CFrame.new(side*1.55,0.35,coat[3]/2+0.42),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
                piece("Inner silver door jamb",torso,{M.ApprenticeJamb[1]*0.85,M.ApprenticeJamb[2]*0.78,M.ApprenticeJamb[3]},CFrame.new(side*1.05,0.2,coat[3]/2+0.24),T.Colors.Silver,Enum.Material.Metal,0.08)
                piece("Worm of Star arc",torso,M.ApprenticeWorm,CFrame.new(side*1.25,0.65,-0.15)*CFrame.Angles(0,math.rad(side*24),math.rad(side*35)),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Outer astral door lintel",torso,M.ApprenticeLintel,CFrame.new(0,2.25,coat[3]/2+0.42),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
            piece("Inner silver door lintel",torso,{M.ApprenticeLintel[1]*0.72,M.ApprenticeLintel[2]*0.85,M.ApprenticeLintel[3]},CFrame.new(0,1.68,coat[3]/2+0.24),T.Colors.Silver,Enum.Material.Metal,0.08)
            piece("Threshold starlight key-seal",head,{1.45,0.2,1.45},CFrame.new(0,head.Size.Y/2+0.36,0),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
        end
    elseif stage=="Incomplete" then
        -- Original incomplete Saint visual manifestation (Sequence 4–3): Victorian attire fracturing into partial Worms
        piece("Victorian waistcoat",torso,coat,CFrame.identity,cloth)
        if path=="Seer" then
            piece("Top hat brim",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.08,0),cloth)
            piece("Top hat crown",head,A.Crown,CFrame.new(0,head.Size.Y/2+A.Crown[2]/2+0.1,0),cloth)
            piece("Spirit vortex shroud",torso,{coat[1]*1.14,coat[2]*0.82,coat[3]*1.14},CFrame.new(0,-0.1,0.06),T.Colors.Fog,Enum.Material.Glass,M.SpiritAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Spirit tendril "..tostring(idx),torso,M.SeerWorm,CFrame.new(side*0.92,-0.35,0.22)*CFrame.Angles(math.rad(24),0,math.rad(side*30)),T.Colors.Fog,Enum.Material.Neon,M.GlowAlpha)
                piece("Spirit tentacle coil "..tostring(idx),torso,M.SeerWorm,CFrame.new(side*0.76,0.35,-0.2)*CFrame.Angles(math.rad(-18),0,math.rad(side*-26)),T.Colors.DeepPurple,Enum.Material.Neon,M.GlowAlpha)
            end
            piece("Unstable spirit-worm core",torso,A.Pendant,CFrame.new(0,0.25,-coat[3]/2-0.16),T.Colors.Gold,Enum.Material.Neon,0.08)
        elseif path=="Marauder" then
            piece("Offset bronze pin",torso,A.Pendant,CFrame.new(0.65,0.55,-coat[3]/2-0.1)*CFrame.Angles(0,0,math.rad(45)),trim)
            piece("Short shoulder mantle",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),cloth)
            piece("Phantom clock arc",torso,{2.2,2.2,0.16},CFrame.new(0,0.35,coat[3]/2+0.36),T.Colors.Bronze,Enum.Material.Metal,0.18)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Time coil "..tostring(idx),torso,M.MarauderRing,CFrame.new(side*0.95,0.2,0.1)*CFrame.Angles(math.rad(28),0,math.rad(side*34)),T.Colors.Silver,Enum.Material.Glass,M.GlowAlpha)
                piece("Etched time ring "..tostring(idx),torso,{0.78,0.14,0.78},CFrame.new(side*0.82,-0.35,-0.12)*CFrame.Angles(math.rad(-20),0,math.rad(side*-24)),T.Colors.Crimson,Enum.Material.Neon,M.GlowAlpha)
            end
        else
            piece("Travel cloak collar",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),trim)
            piece("Traveller cape",torso,{coat[1],coat[2]+A.CapeExtra,A.CapeDepth},CFrame.new(0,-0.25,coat[3]/2+0.12),cloth)
            piece("Threshold arch lintel",torso,{2.45,0.26,0.24},CFrame.new(0,1.55,coat[3]/2+0.34),T.Colors.Teal,Enum.Material.Neon,M.GlowAlpha)
            for idx,side in ipairs({-1,1}) do
                piece("Worm of Star door-arc "..tostring(idx),torso,M.ApprenticeWorm,CFrame.new(side*1.05,0.45,0.22)*CFrame.Angles(0,math.rad(side*18),math.rad(side*32)),T.Colors.Starlight,Enum.Material.Neon,M.GlowAlpha)
                piece("Astral pillar shard "..tostring(idx),torso,{0.24,2.1,0.24},CFrame.new(side*1.12,0.15,coat[3]/2+0.34),T.Colors.Silver,Enum.Material.Neon,M.GlowAlpha)
            end
        end
    else
        piece("Victorian waistcoat",torso,coat,CFrame.identity,cloth)
        for _,side in ipairs({-1,1}) do
            piece("Split coat tail",torso,A.Tail,CFrame.new(side*0.48,-coat[2]/2-0.45,0.35),cloth)
            piece("Lapel",torso,{A.LapelWidth,coat[2]*A.LapelFraction,A.LapelDepth},CFrame.new(side*0.4,0,-coat[3]/2-0.06)*CFrame.Angles(0,0,math.rad(side*A.LapelAngle)),trim)
        end
        if path=="Seer" then
            piece("Top hat brim",head,A.Brim,CFrame.new(0,head.Size.Y/2+0.08,0),cloth)
            piece("Top hat crown",head,A.Crown,CFrame.new(0,head.Size.Y/2+A.Crown[2]/2+0.1,0),cloth)
        elseif path=="Marauder" then
            piece("Offset bronze pin",torso,A.Pendant,CFrame.new(0.65,0.55,-coat[3]/2-0.1)*CFrame.Angles(0,0,math.rad(45)),trim)
            piece("Short shoulder mantle",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),cloth)
        else
            piece("Travel cloak collar",torso,A.Collar,CFrame.new(0,coat[2]/2,0.2),trim)
            piece("Traveller cape",torso,{coat[1],coat[2]+A.CapeExtra,A.CapeDepth},CFrame.new(0,-0.25,coat[3]/2+0.12),cloth)
        end
        if sequence<=4 then piece("Sequence crest",torso,A.Pendant,CFrame.new(0,0.2,-coat[3]/2-0.15),trim) end
        if sequence<=2 then piece("Silvered collar seal",torso,A.CollarSeal,CFrame.new(0,coat[2]/2,-coat[3]/2-0.08),trim) end
    end
    self.Records[character]={Model=model,Path=path,Sequence=sequence,Mythical=stage,Torso=torso,Head=head,
        Motions=motions,Faces=faces,Ornaments=ornaments,Age=0,Time=0}
end
function Outfit.Step(self: any,dt: number)
    local profile=self.Service:Profile()
    local reduced=self.Service.ReducedMotion or profile.ReducedMotion
    local low=self.Service.LowGraphics or profile.Low
    for _,record in pairs(self.Records) do
        if record.Mythical~="" and record.Torso.Parent and self.Service:Visible(record.Torso.Position) then
            record.Age+=math.min(dt,A.Scan);record.Time+=math.min(dt,A.Scan)
            local reveal=if reduced or low then 1 else math.clamp(record.Age/M.RevealTime,0,1)
            for _,motion in ipairs(record.Motions) do
                local wave=if reduced or low then 0 else math.sin(record.Time*math.pi*2/M.IdlePeriod+motion.Phase)
                local spin=if reduced or low then 0 else record.Time
                local offset=CFrame.identity
                if motion.Kind=="Hand" then
                    -- Rotate around the clock hub, not the hand's midpoint.
                    local center=Vector3.new(0,0.45,motion.Base.Position.Z)
                    offset=CFrame.new(center)*CFrame.Angles(0,0,spin*M.HandSpeed*motion.Sign)*CFrame.new(-center)
                    motion.Weld.C0=offset*motion.Base
                else
                    offset=CFrame.new(0,wave*M.IdleRise,0)*CFrame.Angles(
                        if motion.Kind=="Worm" then wave*math.rad(M.IdleDegrees) else 0,
                        if motion.Kind=="Halo" then spin*M.HaloSpeed else 0,
                        if motion.Kind=="Worm" then math.sin(spin*M.WormSpeed+motion.Phase)*math.rad(M.IdleDegrees) else 0)
                    if reduced or low then offset=CFrame.identity end
                    motion.Weld.C0=motion.Base*offset
                end
                motion.Part.Transparency=math.clamp(1-(1-motion.Alpha)*reveal+math.abs(wave)*M.AlphaPulse,0,1)
            end
            for _,face in ipairs(record.Faces) do face.Enabled=not low and reveal>=M.HaloReveal end
            for _,face in ipairs(record.Ornaments) do face.Enabled=not low and reveal>=M.HaloReveal end
        end
    end
    self.Elapsed+=dt;if self.Elapsed<A.Scan then return end;self.Elapsed=0
    local camera=workspace.CurrentCamera;if not camera then return end
    local candidates={};local wanted={}
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local hum=character and character:FindFirstChildOfClass("Humanoid")
        if root and root:IsA("BasePart") and hum and hum.Health>0 then
            local distance=(root.Position-camera.CFrame.Position).Magnitude
            if distance<=A.Distance then table.insert(candidates,{Character=character,Distance=distance,Root=root}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local now=os.clock();local aura=now>=self.AuraAt
    if aura then self.AuraAt=now+M.AuraInterval end
    for i,item in ipairs(candidates) do
        if i>A.MaxPlayers then break end
        local character=item.Character;local path=character:GetAttribute("MysteriesPathway");local seq=character:GetAttribute("MysteriesSequence")
        local mythAttr=character:GetAttribute("MysteriesMythicalForm")
        local myth=if mythAttr=="Incomplete" or mythAttr=="Complete" then mythAttr else ""
        local torso=character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");local head=character:FindFirstChild("Head")
        if not A.Cloth[path] or type(seq)~="number" or character:GetAttribute("MysteriesDisguised")==true
            or not torso or not torso:IsA("BasePart") or not head or not head:IsA("BasePart") then continue end
        wanted[character]=true
        local record=self.Records[character]
        if not record or record.Path~=path or record.Sequence~=seq or record.Mythical~=myth or record.Torso~=torso or record.Head~=head then
            self:Build(character,path,seq,torso,head,myth)
        end
        if aura and (seq<=6 or myth~="") and not self.Service.LowGraphics and not self.Service.ReducedMotion and not profile.Low and self.Service:Visible(item.Root.Position) then
            local blockName=if myth=="Complete" then "SigilStencil" elseif myth=="Incomplete" or seq<=3 then "VeilRibbon" else "RisingMotes"
            local stencil=if path=="Seer" then "Worm" elseif path=="Marauder" then "Clock" else "Arch"
            local layers: {any}={{Name=blockName,Position=torso.Position,Palette=path,
                Options={Scale=if myth~="" then M.AuraScale else A.AuraScale,Glyph=stencil,LowGlyph=stencil,Follow=torso}}}
            if myth~="" then
                table.insert(layers,{Name="VeilRibbon",Position=torso.Position,Palette=path,
                    Options={Scale=M.AuraScale,Height=M.ApprenticeJamb[2],Coil=true,Follow=torso}})
            end
            self.Blocks:Compose(layers,1,0,if myth~="" then M.AuraLife else A.AuraLife)
            aura=false -- one subtle nearby aura per interval; it shares the global effect cap.
        end
    end
    for character in pairs(self.Records) do if not wanted[character] then self:Clear(character) end end
end
function Outfit.Destroy(self: any)
    for character in pairs(self.Records) do self:Clear(character) end
end
return Outfit
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/Choreography.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/Choreography`. Create matching Folder parents.

```lua
--!strict
-- Shared original composition vocabulary; no targets, statuses or outcomes are decided here.
local Shared=game:GetService("ReplicatedStorage").Shared
local C=require(Shared.VfxConfig)
local Anim=require(Shared.AnimConfig)
local Choreography={}
function Choreography.Root(target: any): any
    if typeof(target)~="Instance" then return nil end
    if target:IsA("BasePart") then return target end
    if target:IsA("Model") then return target.PrimaryPart or target:FindFirstChild("HumanoidRootPart") end
    return nil
end
function Choreography.GestureHeight(a: any): number
    local timing=Anim.AbilityTimings[a.Id]
    local spec=timing and timing.Origin
    return if spec and type(spec[2])=="number" then spec[2] else C.Ability.HandHeight
end
function Choreography.Extend(a: any,e: any,c: any): any
    local gestureY=Choreography.GestureHeight(a)
    local sequence=tonumber(string.match(a.Id,"_(%d+)")) or 9
    local scale=if sequence<=2 then C.Cinematic.AngelScale elseif sequence<=4 then C.Cinematic.SaintScale else 1
    local layer=c.Layer
    -- Every route retains its own vocabulary, endpoints and confirmed targets.
    -- Timing lives inside one pooled composition, with no delayed task queue.
    c.Layer=function(name: string,at: Vector3,options: any?): any
        local opts=table.clone(options or {})
        if not c.Simplified then
            if name=="RisingMotes" or name=="ContourEcho" or name=="VeilRibbon" then
                opts.Delay=opts.Delay or C.Cinematic.Aftermath
            elseif name=="StarBurst" or name=="GlitchFlicker" or name=="RingBurst" then
                opts.Delay=opts.Delay or C.Cinematic.Release
            end
            if name=="VeilRibbon" and sequence<=4 then opts.Height=C.Cinematic.VeilHeight end
            if name=="GroundRune" then opts.InnerRing=sequence<=4 end
        end
        if name=="ThreadBeam" then opts.Draw=true end
        if not opts.Radius and not opts.Width then opts.Scale=(opts.Scale or 1)*scale end
        return layer(name,at,opts)
    end
    c.Root=Choreography.Root
    c.Self=e.Destination or e.Origin or e.Position
    c.Origin=e.Origin or e.Position
    c.Head=c.Self+Vector3.yAxis*C.Ability.HeadHeight
    c.Chest=c.Self+Vector3.yAxis*C.Ability.ChestHeight
    local timing=Anim.AbilityTimings[a.Id]
    local offset=timing and timing.Origin
    local gesture=if offset then Vector3.new(offset[1],offset[2],offset[3]) else Vector3.yAxis*gestureY
    c.Gesture=c.Frame(c.Self):PointToWorldSpace(gesture)
    c.OriginGesture=c.Frame(c.Origin):PointToWorldSpace(gesture)
    c.Target=e.Position
    c.TargetHead=e.Position+Vector3.yAxis*C.Ability.HeadHeight
    c.TargetChest=e.Position+Vector3.yAxis*C.Ability.ChestHeight
    c.Radius=e.Radius or math.max(C.Ability.PreviewRadius,a.RadiusStuds)
    c.Ground=function(at: Vector3?): Vector3
        if at then return at+Vector3.yAxis*C.Blocks.Common.HeightOffset end
        return if a.Target=="Position" then e.Position+Vector3.yAxis*C.Blocks.Common.HeightOffset else c.Self+Vector3.yAxis*C.Ability.GroundOffset
    end
    c.Mark=function(glyph: string,at: Vector3,scale: number?,options: any?): any
        local opts=table.clone(options or {})
        opts.Frame=opts.Frame or c.Frame(at);opts.Glyph=glyph
        local lowKey=glyph.."Low"
        opts.LowGlyph=opts.LowGlyph or (if C.Blocks.SigilStencil.Paths[lowKey] then lowKey elseif glyph=="Eye" then "EyeLow" elseif glyph=="Door" then "DoorLow" else glyph)
        opts.Scale=scale or C.Ability.Medium
        return c.Layer("SigilStencil",at,opts)
    end
    c.Ring=function(at: Vector3,radius: number?): any
        local opts: any={Scale=if radius then 1 else C.Ability.Medium,Detail=C.Ability.Detail}
        if radius then opts.Radius=radius/C.Tier[e.Tier].Scale end
        return c.Layer("GroundRune",at,opts)
    end
    c.Burst=function(at: Vector3,scale: number?,tint: Color3?): any
        return c.Layer("RingBurst",at,{Scale=scale or C.Ability.Medium,Detail=C.Ability.Detail,Tint=tint})
    end
    c.Shock=function(at: Vector3,scale: number?,tint: Color3?): any
        return c.Layer("ShockwaveRing",at,{Scale=scale or C.Ability.Medium,Detail=C.Ability.Detail,Tint=tint})
    end
    c.Motes=function(at: Vector3,scale: number?,tint: Color3?): any
        return c.Layer("RisingMotes",at,{Scale=scale or C.Ability.Small,Detail=C.Ability.Detail,Tint=tint})
    end
    c.Star=function(at: Vector3,scale: number?,tint: Color3?): any
        return c.Layer("StarBurst",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,Tint=tint})
    end
    c.Glitch=function(at: Vector3,scale: number?,tint: Color3?): any
        return c.Layer("GlitchFlicker",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,Tint=tint})
    end
    c.Cards=function(at: Vector3,scale: number?,moveTo: Vector3?): any
        return c.Layer("CardFan",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,MoveTo=moveTo})
    end
    c.Paper=function(at: Vector3,broken: boolean?,scale: number?): any
        return c.Layer("PaperFold",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,Break=broken})
    end
    c.Trail=function(at: Vector3,scale: number?,moveTo: Vector3?): any
        return c.Layer("AfterimageTrail",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,EndPosition=moveTo})
    end
    c.Flash=function(at: Vector3,scale: number?): any
        return c.Layer("ImpactFlash",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Small})
    end
    c.Beam=function(from: Vector3,to: Vector3,tint: Color3?): any
        return c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.ThreadScale,Tint=tint})
    end
    c.Ghost=function(at: Vector3,to: Vector3?): any
        return c.Layer("ContourEcho",at,{Frame=c.Frame(at),Scale=C.Ability.Medium,MoveTo=to})
    end
    c.Veil=function(at: Vector3,scale: number?): any
        return c.Layer("VeilRibbon",at,{Frame=c.Frame(at),Scale=scale or C.Ability.VeilScale})
    end
    c.Door=function(at: Vector3,scale: number?,nested: number?): any
        return c.Layer("DoorFrame",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,Nested=nested})
    end
    return c
end
function Choreography.Finish(layers: any,life: number?,a: any,c: any,pathway: string): (any,number?)
    if not layers or c.Simplified then return layers,life end
    local sequence=tonumber(string.match(a.Id,"_(%d+)")) or 9
    if sequence<=4 and #layers<C.Composition.MaxLayers then
        local layer=if pathway=="Seer" then c.Veil(c.Gesture,C.Ability.Medium)
            elseif pathway=="Marauder" then c.Glitch(c.Gesture,C.Ability.Large)
            else c.Door(c.Ground(),C.Ability.Large)
        table.insert(layers,layer)
    end
    return layers,life
end
return Choreography
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks`. Create matching Folder parents.

```lua
--!strict
-- Original, texture-free silhouettes. Optional particles supplement, never replace, geometry.
local C: any=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Blocks={}
Blocks.Names={"RingBurst","RisingMotes","ThreadBeam","DoorFrame","StarBurst","GlitchFlicker","GroundRune","ImpactFlash","ScreenEdgePulse","ShockwaveRing","AfterimageTrail"}
Blocks.AbilityNames={"SigilStencil","CardFan","PaperFold","VeilRibbon","ContourEcho"}
local TAU=math.pi*2
local function take(handle: any,class: string,parent: Instance?): any
    local object=handle:Acquire(class,parent)
    assert(object,"EffectBlocks exceeded reserved "..class.." budget")
    return object
end
local function alpha(age: number,duration: number,start: number): number
    return math.clamp((age/duration-start)/(1-start),0,1)
end
local function color(value: Color3): ColorSequence return ColorSequence.new(value) end
local function point(x: number,y: number,z: number): Vector3 return Vector3.new(x,y,z) end
local function segment(handle: any,host: BasePart,width: number,tint: Color3): any
    local a=take(handle,"Attachment",host) :: Attachment
    local b=take(handle,"Attachment",host) :: Attachment
    local beam=take(handle,"Beam",host) :: Beam
    beam.Attachment0=a;beam.Attachment1=b;beam.Color=color(tint);beam.Width0=width;beam.Width1=width
    return {A=a,B=b,Beam=beam}
end
local function setLine(line: any,a: Vector3,b: Vector3,transparency: number)
    line.A.Position=a;line.B.Position=b;line.Beam.Transparency=NumberSequence.new(transparency)
end
local function stencil(c: any,low: boolean,opts: any): any
    return c.Paths[(if low then opts.LowGlyph or opts.Glyph else opts.Glyph) or C.Ability.EyeGlyph] or c.Paths[C.Ability.EyeGlyph]
end
local function reserve(name: string,c: any,detail: number,low: boolean,opts: any?): (any,number,number)
    local segments=math.max(C.Blocks.Common.MinSegments,math.floor(C.Blocks.Common.Segments*detail))
    local n=0
    if name=="RingBurst" or name=="ShockwaveRing" then n=segments
    elseif name=="GroundRune" then n=segments+(if low then 0 else c.Spokes)
    elseif name=="DoorFrame" then n=(if low then 1 else c.Nested)*3
    elseif name=="StarBurst" then n=c.Points*2
    elseif name=="GlitchFlicker" then n=4
    elseif name=="ImpactFlash" then n=2
    elseif name=="ThreadBeam" then n=1
    elseif name=="VeilRibbon" then n=if low then c.LowCount else c.Count
    elseif name=="SigilStencil" then
        for _,path in ipairs(stencil(c,low,opts or {})) do n+=math.max(0,#path-1) end
    end
    local motes=if name=="RisingMotes" then math.max(1,math.floor(c.Count*detail))
        elseif name=="SigilStencil" and opts and opts.Follow and not low then c.IntakeCount else 0
    local trail=if name=="AfterimageTrail" and not low then 1 else 0
    local afterHead=if name=="AfterimageTrail" then 1 else 0
    local host=if name=="ScreenEdgePulse" then 0 else 1
    local pieces=0
    if name=="CardFan" then pieces=if low then c.LowCount else c.Count
    elseif name=="PaperFold" or name=="ContourEcho" then pieces=if low then #c.LowPieces else #c.Pieces end
    local emitter=if name=="RisingMotes" and C.Particle.Texture~="" then 1 else 0
    return {Part=host+motes+afterHead+pieces,Attachment=n*2+trail*2,Beam=n,Trail=trail,ParticleEmitter=emitter},segments,motes
end
function Blocks.new(service: any,callbacks: any?): any
    return setmetatable({Service=service,Callbacks=callbacks or {},LastPulse=nil},{__index=Blocks})
end
function Blocks.Play(self: any,name: string,position: Vector3,paletteName: string?,tier: number?,options: any?): any
    local c=C.Blocks[name]
    if not c or typeof(position)~="Vector3" then return nil end
    local pulse=name=="ImpactFlash" or name=="ScreenEdgePulse"
    local now=os.clock()
    if pulse then
        if self.Service:Profile().ReducedMotion then return nil end
        if self.LastPulse and now-self.LastPulse<C.Safety.MinimumPulseInterval then return nil end
    end
    local opts=options or {}
    local detail=math.min(self.Service:Detail(position),opts.Detail or math.huge)
    local low=detail<=C.Quality.Low
    if opts.Duration then c=table.clone(c);c.Duration=opts.Duration end
    if opts.Width or opts.Height then
        c=table.clone(c);c.Width=opts.Width or c.Width;c.Height=opts.Height or c.Height
    end
    if opts.Radius then c=table.clone(c);c.Radius=opts.Radius end
    local costs,segments,motes=reserve(name,c,detail,low,opts)
    local h=opts.Lease or self.Service:Begin(name,position,tier or 1,c.Priority,costs)
    if not h then return nil end
    h.Scale*=opts.Scale or 1
    if pulse then self.LastPulse=now end
    h.Duration=c.Duration
    local p=C.Palettes[paletteName or "Seer"] or C.Palettes.Seer
    if opts.Tint then p=table.clone(p);p.Primary=opts.Tint;p.Accent=opts.Tint end
    local scale=h.Scale
    local common=C.Blocks.Common
    local width=math.max(common.Width*scale,opts.MinWidth or 0)
    local host: any=nil
    if costs.Part>0 then
        host=take(h,"Part",nil)
        host.Size=Vector3.one*common.HostSize
        host.CFrame=if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position)
    end
    local update: (number,number,number)->() = function() end
    if name=="CardFan" or name=="PaperFold" or name=="ContourEcho" then
        local pieces={}
        local count=costs.Part-1
        for i=1,count do
            local part=take(h,"Part",nil)
            part.Color=if name=="ContourEcho" then p.Primary else c.Color
            part.Material=Enum.Material.SmoothPlastic
            local shape=nil
            if name~="CardFan" then shape=c.Pieces[if low then c.LowPieces[i] else i] end
            part.Size=if shape then point(shape[4],shape[5],shape[6])*scale else c.Size*scale
            table.insert(pieces,{Part=part,Shape=shape})
        end
        update=function(_dt: number,age: number,t: number)
            local fade=c.Alpha+(1-c.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,entry in ipairs(pieces) do
                local offset: Vector3
                local rotation=CFrame.identity
                if name=="CardFan" then
                    local index=i-(count+1)/2
                    offset=point(index*c.Offset,0,0)*scale
                    rotation=CFrame.Angles(0,0,math.rad(index*c.Spread))
                else
                    local shape=entry.Shape
                    offset=point(shape[1],shape[2],shape[3])*scale
                    if name=="PaperFold" and opts.Break and not h.ReducedMotion then
                        local direction=if offset.Magnitude>common.MinimumLength then offset.Unit else Vector3.yAxis
                        offset+=direction*t*c.BreakDistance*scale
                    elseif name=="ContourEcho" and not h.ReducedMotion then offset+=Vector3.xAxis*t*c.Drift*scale end
                end
                entry.Part.CFrame=host.CFrame*CFrame.new(offset)*rotation;entry.Part.Transparency=fade
            end
        end
    elseif name=="VeilRibbon" then
        local lines={}
        for _=1,costs.Beam do table.insert(lines,segment(h,host,c.Width*scale,p.Primary)) end
        update=function(_dt: number,age: number,t: number)
            local fade=c.Alpha+(1-c.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,line in ipairs(lines) do
                local side=if i%2==0 then 1 else -1
                if opts.Coil and not h.ReducedMotion then
                    local angle=t*TAU+side*math.pi/2
                    local radius=c.Offset*scale
                    setLine(line,point(math.cos(angle)*radius,-c.Height*scale/2,math.sin(angle)*radius),
                        point(-math.cos(angle)*radius,c.Height*scale/2,-math.sin(angle)*radius),fade)
                else
                    setLine(line,point(side*c.Offset*scale,-c.Height*scale/2,0),point(side*c.Offset*scale,c.Height*scale/2,0),fade)
                end
                local wave=if h.ReducedMotion or low then 0 else math.sin(t*TAU+i)*C.Cinematic.VeilSway
                line.Beam.CurveSize0=(c.Curve+wave)*scale;line.Beam.CurveSize1=(-c.Curve+wave)*scale
            end
        end
    elseif name=="SigilStencil" then
        local paths=stencil(c,low,opts)
        local lines={}
        local intake={}
        for _=1,motes do
            local part=take(h,"Part",nil) :: Part
            part.Shape=Enum.PartType.Ball;part.Size=Vector3.one*c.IntakeSize*scale;part.Color=p.Accent
            table.insert(intake,part)
        end
        for _,path in ipairs(paths) do
            for i=1,#path-1 do table.insert(lines,{Line=segment(h,host,width,p.Accent),A=path[i],B=path[i+1]}) end
        end
        update=function(_dt: number,age: number,_t: number)
            if opts.MoveTo then
                local t=if h.ReducedMotion then 1 else math.clamp(age/c.Duration,0,1)
                host.CFrame=((if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position))+(opts.MoveTo-position)*t)
                    *CFrame.Angles(0,0,if h.ReducedMotion or low then 0 else age*(opts.Spin or C.Cinematic.SigilSpin))
            end
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            local progress=math.min(1,age/C.Cinematic.Intake)
            for i,part in ipairs(intake) do
                local angle=(i-1)/motes*TAU+progress*math.pi
                local radius=c.Size*scale*(1-progress)
                part.CFrame=host.CFrame*CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,0)
                part.Transparency=if h.ReducedMotion then 1 else common.Alpha+(1-common.Alpha)*progress
            end
            for _,entry in ipairs(lines) do
                local intakeScale=if h.ReducedMotion then 1 else 1+C.Cinematic.IntakeRadius*(1-math.clamp(age/C.Cinematic.Intake,0,1))
                local function vertex(v: any): Vector3 return point((v[1]-0.5)*c.Size*scale*intakeScale,(0.5-v[2])*c.Size*scale*intakeScale,0) end
                setLine(entry.Line,vertex(entry.A),vertex(entry.B),fade)
            end
        end
    elseif name=="RingBurst" or name=="ShockwaveRing" or name=="GroundRune" then
        local lines={}
        for _=1,segments do table.insert(lines,segment(h,host,width,p.Accent)) end
        local spokes={}
        if name=="GroundRune" and not low then
            for _=1,c.Spokes do table.insert(spokes,segment(h,host,width,p.Primary)) end
        end
        update=function(_dt: number,age: number,t: number)
            local radius=c.Radius*scale
            if name~="GroundRune" and not h.ReducedMotion then radius*=c.Start+(1-c.Start)*t end
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,line in ipairs(lines) do
                local a=(i-1)/segments*TAU
                local b=i/segments*TAU
                if name=="RingBurst" then b-=c.Gap/segments end
                setLine(line,point(math.cos(a)*radius,common.HeightOffset,math.sin(a)*radius),point(math.cos(b)*radius,common.HeightOffset,math.sin(b)*radius),fade)
            end
            for i,line in ipairs(spokes) do
                local a=(i-1)/c.Spokes*TAU
                local direction=point(math.cos(a),0,math.sin(a))
                if opts.InnerRing then
                    local b=a+TAU/c.Spokes
                    setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,
                        point(math.cos(b),0,math.sin(b))*radius*c.Inner+Vector3.yAxis*common.HeightOffset,fade)
                else
                    setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,direction*radius+Vector3.yAxis*common.HeightOffset,fade)
                end
            end
        end
    elseif name=="RisingMotes" then
        local pieces={}
        for i=1,motes do
            local part=take(h,"Part",nil) :: Part
            part.Shape=Enum.PartType.Ball;part.Color=if i%2==0 then p.Accent else p.Primary
            part.Size=Vector3.one*c.Size*scale
            table.insert(pieces,part)
        end
        if costs.ParticleEmitter>0 then
            local emitter=take(h,"ParticleEmitter",host) :: ParticleEmitter
            emitter.Color=color(p.Primary)
            emitter:Emit(math.max(1,math.floor(common.ParticleCount*h.Detail*common.ParticleEmitScale)))
        end
        update=function(_dt: number,age: number,t: number)
            for i,part in ipairs(pieces) do
                local a=(i-1)/motes*TAU+(if h.ReducedMotion then 0 else t*c.Orbit)
                local intake=if opts.Intake then 1-t else math.min(1,t/C.Cinematic.Intake)
                local radius=c.Radius*(if h.ReducedMotion then 1 else C.Cinematic.IntakeRadius+(1-C.Cinematic.IntakeRadius)*intake)
                local rise=if h.ReducedMotion then c.Height*(i/motes) elseif opts.Intake then (1-t)*c.Height else t*c.Height
                part.CFrame=host.CFrame*CFrame.new(math.cos(a)*radius*scale,rise*scale,math.sin(a)*radius*scale)
                part.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            end
        end
    elseif name=="ThreadBeam" then
        local line=segment(h,host,math.max(c.Width*scale,opts.MinWidth or 0),p.Accent)
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
        local arch=Vector3.yAxis*(opts.Curve or c.Height)*scale
        local a=Vector3.zero
        local tangent0=endpoint/3+arch
        local tangent1=endpoint/3-arch
        -- Beams use +X on each attachment as their cubic Bezier tangent.
        local function tangentFrame(at: Vector3,tangent: Vector3): CFrame
            local right=if tangent.Magnitude>common.MinimumLength then tangent.Unit else Vector3.xAxis
            local up=if math.abs(right:Dot(Vector3.yAxis))<common.TangentVertical then Vector3.yAxis else Vector3.zAxis
            local back=right:Cross(up).Unit
            return CFrame.fromMatrix(at,right,back:Cross(right).Unit,back)
        end
        line.A.CFrame=tangentFrame(a,tangent0);line.B.CFrame=tangentFrame(endpoint,tangent1)
        line.Beam.CurveSize0=tangent0.Magnitude;line.Beam.CurveSize1=tangent1.Magnitude
        line.Beam.Segments=c.Segments;line.Beam.Width1=math.max(c.Width*scale*c.Taper,opts.MinWidth or 0)
        update=function(_dt: number,age: number,_t: number)
            local draw=if h.ReducedMotion or not opts.Draw then 1 else math.min(1,age/C.Cinematic.BeamDraw)
            line.B.Position=endpoint*draw
            line.Beam.Width0=math.max(c.Width*scale,opts.MinWidth or 0)*(1+C.Cinematic.Afterglow*(1-draw))
            line.Beam.Transparency=NumberSequence.new(common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart))
        end
    elseif name=="DoorFrame" then
        local layers=if low then 1 else c.Nested
        local lines={}
        for _=1,layers*3 do table.insert(lines,segment(h,host,width,p.Primary)) end
        update=function(_dt: number,age: number,_t: number)
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i=1,layers do
                local opening=if h.ReducedMotion then 1 else C.Cinematic.DoorOpen+(1-C.Cinematic.DoorOpen)*math.min(1,age/C.Cinematic.Intake)
                local half=(c.Width/2-(i-1)*c.Inset)*scale*opening
                local base=c.Base*scale
                local top=(c.Height-(i-1)*c.Inset)*scale
                local offset=(i-1)*3
                local depth=(i-1)*C.Cinematic.DoorDepth*scale
                setLine(lines[offset+1],point(-half,base,depth),point(-half,top,depth),fade)
                setLine(lines[offset+2],point(-half,top,depth),point(half,top,depth),fade)
                setLine(lines[offset+3],point(half,top,depth),point(half,base,depth),fade)
            end
        end
    elseif name=="StarBurst" or name=="ImpactFlash" then
        local lines={}
        local count=if name=="ImpactFlash" then 2 else c.Points*2
        for _=1,count do table.insert(lines,segment(h,host,width,p.Accent)) end
        update=function(_dt: number,age: number,t: number)
            local fade=(c.Alpha or common.Alpha)+(1-(c.Alpha or common.Alpha))*alpha(age,c.Duration,common.FadeStart)
            local radius=c.Radius*scale*(if h.ReducedMotion then 1 else (c.Start or c.Inner)+(1-(c.Start or c.Inner))*t)
            for i,line in ipairs(lines) do
                if name=="ImpactFlash" then
                    local direction=if i==1 then Vector3.xAxis else Vector3.yAxis
                    setLine(line,-direction*radius,direction*radius,fade)
                else
                    local a=(i-1)/count*TAU
                    local b=i/count*TAU
                    local r0=if i%2==1 then radius else radius*c.Inner
                    local r1=if i%2==1 then radius*c.Inner else radius
                    setLine(line,point(math.cos(a)*r0,math.sin(a)*r0,0),point(math.cos(b)*r1,math.sin(b)*r1,0),fade)
                end
            end
        end
    elseif name=="GlitchFlicker" then
        local lines={}
        for _=1,4 do table.insert(lines,segment(h,host,width,p.Accent)) end
        update=function(_dt: number,age: number,t: number)
            -- Two positional edits over 1.1s; opacity never oscillates or flashes.
            local step=if h.ReducedMotion or low then 0 else math.floor(t*c.Transitions)
            local shift=(if step%2==0 then -1 else 1)*c.Shift*scale
            local x=c.Width/2*scale;local y=c.Height/2*scale
            local gap=c.Split*scale
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            setLine(lines[1],point(-x+shift,-y,0),point(-x+shift,y,0),fade)
            setLine(lines[2],point(-x+shift,y,0),point(-gap+shift,y,0),fade)
            setLine(lines[3],point(x-shift,y,0),point(x-shift,-y,0),fade)
            setLine(lines[4],point(x-shift,-y,0),point(gap-shift,-y,0),fade)
        end
    elseif name=="ScreenEdgePulse" then
        if self.Callbacks.ScreenEdgePulse then self.Callbacks.ScreenEdgePulse(p.Primary,c.Duration) end
    elseif name=="AfterimageTrail" then
        local head=take(h,"Part",nil) :: Part
        head.Size=point(c.Head,c.Height,c.Head)*scale;head.Color=p.Primary
        local trail: Trail?=nil
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
        if costs.Trail>0 then
            local a=take(h,"Attachment",head) :: Attachment
            local b=take(h,"Attachment",head) :: Attachment
            a.Position=Vector3.yAxis*c.Height*scale/2;b.Position=-Vector3.yAxis*c.Height*scale/2
            local ribbon=take(h,"Trail",head) :: Trail
            ribbon.Attachment0=a;ribbon.Attachment1=b
            ribbon.Color=color(p.Primary);ribbon.Enabled=not h.ReducedMotion
            trail=ribbon
        end
        update=function(_dt: number,age: number,t: number)
            local travel=if h.ReducedMotion then 1 else math.min(1,age/C.Cinematic.TrailTravel)
            head.CFrame=host.CFrame*CFrame.new(endpoint*travel+Vector3.yAxis*c.Height*scale/2)
            head.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            if trail then trail.Enabled=not h.ReducedMotion end
        end
    end
    local wrapped=function(dt: number,age: number,t: number)
        if host and opts.MoveTo and name~="SigilStencil" then
            local fraction=if h.ReducedMotion then 1 else t
            host.CFrame=(opts.Frame or CFrame.new(position))+(opts.MoveTo-position)*fraction
        end
        if host and opts.Follow then
            if not opts.Follow.Parent then h:Finish();return end
            host.CFrame=CFrame.new(opts.Follow.Position+(opts.Offset or Vector3.zero))*(if opts.Frame then opts.Frame.Rotation else CFrame.identity)
        end
        if host and (name=="SigilStencil" or name=="GroundRune") and not opts.MoveTo then
            local base=if opts.Follow then host.CFrame else opts.Frame or CFrame.new(position)
            local spin=if h.ReducedMotion or low then 0 else age*(opts.Spin or (if name=="GroundRune" then C.Cinematic.RuneSpin else C.Cinematic.SigilSpin))
            host.CFrame=base*(if name=="GroundRune" then CFrame.Angles(0,spin,0) else CFrame.Angles(0,0,spin))
        end
        update(dt,age,t)
    end
    h.Update=wrapped
    wrapped(0,0,0)
    return h
end
-- One atomic reservation for the entire cast. Endpoints instantiate lazily and
-- park independently when outside the viewport/120-stud limit.
function Blocks.Compose(self: any,layers: {any},tier: number,priority: number,duration: number): any
    if #layers==0 or #layers>C.Composition.MaxLayers or duration~=duration or duration<=0 or duration>C.Lifetime.Maximum then return nil end
    local profile=self.Service:Profile()
    local accepted={}
    for _,layer in ipairs(layers) do
        local pulse=layer.Name=="ImpactFlash" or layer.Name=="ScreenEdgePulse"
        if not pulse or (not profile.ReducedMotion and (not self.LastPulse or os.clock()-self.LastPulse>=C.Safety.MinimumPulseInterval)) then
            table.insert(accepted,layer)
        end
    end
    layers=accepted
    if #layers==0 then return nil end
    local detail=if profile.Mobile then math.min(profile.Detail,C.Composition.MobileDetail) else profile.Detail
    local costs={};local anchors={}
    for _,layer in ipairs(layers) do
        local config=C.Blocks[layer.Name]
        if not config or typeof(layer.Position)~="Vector3" then return nil end
        local layerDetail=math.min(detail,(layer.Options and layer.Options.Detail) or math.huge)
        local budget=reserve(layer.Name,config,layerDetail,layerDetail<=C.Quality.Low,layer.Options)
        for class,count in pairs(budget) do costs[class]=(costs[class] or 0)+count end
        table.insert(anchors,layer.Position)
    end
    for _,layer in ipairs(layers) do
        if layer.Options and layer.Options.MoveTo then table.insert(anchors,layer.Options.MoveTo) end
    end
    local h=self.Service:Begin("AbilityComposition",anchors[1],tier,priority,costs,anchors)
    if not h then return nil end
    h.Duration=duration
    local groups={}
    for _,layer in ipairs(layers) do table.insert(groups,{Layer=layer,Anchor=layer.Position,Objects={},Built=false,Child=nil,Visible=false}) end
    h.ResolveAnchors=function()
        for i,group in ipairs(groups) do
            local layer=group.Layer
            if layer.Options and layer.Options.Follow then
                if not layer.Options.Follow.Parent then h:Finish();return end
                layer.Position=layer.Options.Follow.Position+(layer.Options.Offset or Vector3.zero)
            end
            local anchor=layer.Position
            if layer.Options and layer.Options.MoveTo then
                local t=if h.ReducedMotion then 1 else math.clamp(h.Age/duration,0,1)
                anchor+=(layer.Options.MoveTo-anchor)*t
            end
            group.Anchor=anchor;h.Anchors[i]=anchor
        end
    end
    local function update(dt: number,age: number,_progress: number)
        for _,group in ipairs(groups) do
            local layer=group.Layer
            local delay=math.clamp((layer.Options and layer.Options.Delay) or 0,0,duration)
            local life=math.clamp((layer.Options and layer.Options.Life) or (duration-delay),C.Blocks.Common.MinimumLength,math.max(C.Blocks.Common.MinimumLength,duration-delay))
            local visible=age>=delay and age<delay+life and self.Service:Visible(group.Anchor)
            if layer.Options and layer.Options.EndPosition then visible=visible and self.Service:Visible(layer.Options.EndPosition) end
            if visible and not group.Built then
                local child: any={Scale=h.Scale,Detail=detail,ReducedMotion=h.ReducedMotion,Duration=duration}
                function child:Acquire(class: string,parent: Instance?): any
                    local object=h:Acquire(class,parent)
                    if object then table.insert(group.Objects,{Object=object,Parent=object.Parent}) end
                    return object
                end
                function child:Finish() h:Finish() end
                local opts=table.clone(layer.Options or {})
                opts.Lease=child;opts.Detail=math.min(detail,opts.Detail or math.huge);opts.Duration=life
                child.Detail=opts.Detail
                opts.MinWidth=if profile.Mobile then C.Composition.MobileMinWidth else C.Composition.MinWidth
                group.Child=self:Play(layer.Name,layer.Position,layer.Palette,tier,opts)
                group.Built=true
            end
            if group.Visible~=visible then
                for _,entry in ipairs(group.Objects) do entry.Object.Parent=if visible then entry.Parent else nil end
                group.Visible=visible
            end
            if visible and group.Child and group.Child.Update then
                group.Child.Update(dt,age-delay,math.clamp((age-delay)/life,0,1))
            end
        end
    end
    h.Update=update
    local ok=pcall(function() h.ResolveAnchors();if h.Active then update(0,0,0) end end)
    if not ok then self.Service.Errors+=1;h:Finish();return nil end
    return h
end
return Blocks
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/EnemyPresentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/EnemyPresentation`. Create matching Folder parents.

```lua
--!strict
-- Original silhouettes; the real registered root/humanoid remains the sole combat entity.
local Collection=game:GetService("CollectionService")
local Players=game:GetService("Players")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Parent.UI.Kit)
local A=T.EnemyArt
local Enemies={}
function Enemies.new(service: any,blocks: any,runtime: any,notice: ((string)->())?,audio: ((string)->())?): any
    return setmetatable({Service=service,Blocks=blocks,Runtime=runtime,Notice=notice,Audio=audio,Records={},Bars={},BarCount=0,Elapsed=0,IntroAt=0,Seen=setmetatable({},{__mode="k"})},{__index=Enemies})
end
function Enemies.Bar(self: any): any
    local pooled=table.remove(self.Bars)
    if pooled then return pooled end
    if self.BarCount>=A.MaxBars then return nil end;self.BarCount+=1
    local gui=Kit.New("BillboardGui",self.Service.Folder,{Name="MysteriesEnemyHealth",Size=UDim2.fromOffset(A.BarWidth,A.BarHeight),
        MaxDistance=A.BarDistance,AlwaysOnTop=false})
    local title=Kit.Text(gui,"",T.Type.Micro,T.Fonts.Number);title.Name="Title";title.Size=UDim2.new(1,0,1,-A.BarTrack)
    title.BackgroundColor3=T.Colors.Ink;title.BackgroundTransparency=0;title.TextXAlignment=Enum.TextXAlignment.Center
    local track=Kit.New("Frame",gui,{Name="Track",BorderSizePixel=0,BackgroundColor3=T.Colors.Slate,
        Position=UDim2.new(0,0,1,-A.BarTrack),Size=UDim2.new(1,0,0,A.BarTrack)})
    Kit.New("Frame",track,{Name="Fill",BorderSizePixel=0,BackgroundColor3=T.Colors.Health,Size=UDim2.fromScale(1,1)})
    return gui
end
function Enemies.ReleaseBar(self: any,r: any)
    if r.Bar then r.Bar.Enabled=false;r.Bar.Adornee=nil;table.insert(self.Bars,r.Bar);r.Bar=nil end
end
function Enemies.Clear(self: any,model: Model)
    local r=self.Records[model];if not r then return end
    if r.Cue then r.Cue:Finish() end;self:ReleaseBar(r)
    for _,old in ipairs(r.Hidden) do if old.Part.Parent and r.Humanoid.Health>0 then old.Part.LocalTransparencyModifier=old.Alpha end end
    r.Art:Destroy();self.Records[model]=nil
end
function Enemies.Build(self: any,model: Model,root: BasePart,humanoid: Humanoid,tier: number): any
    local spec=A.Profiles[tier];if not spec then return nil end
    local art=Instance.new("Model");art.Name="Local silhouette · "..spec.Name;art.Parent=self.Service.Folder
    local r: any={Art=art,Parts={},Hidden={},Root=root,Humanoid=humanoid,Model=model,Spec=spec,Tier=tier,LastHealth=humanoid.Health,Attack=0,HitAt=-math.huge}
    local scale,width=spec.Scale,spec.Width
    local function geometry(name: string,x: number?,y: number?): Vector3
        local g=A.Geometry[name];return Vector3.new(g[1]*(x or 1),g[2]*(y or 1),g[3])
    end
    local function piece(name: string,size: Vector3,at: Vector3,color: Color3,roll: number?)
        if #r.Parts>=A.MaxParts then return end
        local p=Instance.new("Part");p.Name=name;p.Size=size;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
        p.Material=Enum.Material.SmoothPlastic;p.Color=color;p.Parent=art
        table.insert(r.Parts,{Part=p,Offset=CFrame.new(at)*CFrame.Angles(0,0,math.rad(roll or 0))})
    end
    local feet=A.GroundOffset;local body=feet+2.4*scale
    piece("Coat",geometry("Coat",width,scale),Vector3.new(0,body,0),spec.Color)
    for _,side in ipairs({-1,1}) do
        piece("Sleeve",geometry("Sleeve",width,scale),Vector3.new(side*1.5*width,body-0.1,0),spec.Color,side*8)
        piece("Boot",geometry("Boot",1,scale),Vector3.new(side*0.55,feet+0.6*scale,0),T.Colors.Iron)
    end
    local top=body+2.2*scale
    piece("Unmarked mask",geometry("Mask",width,scale),Vector3.new(0,top,0),spec.Mask)
    if spec.Motif=="Hat" then
        piece("Hat brim",geometry("Brim"),Vector3.new(0,top+0.9*scale,0),T.Colors.Iron)
        piece("Hat crown",geometry("Crown"),Vector3.new(0,top+1.35*scale,0),T.Colors.Iron)
    elseif spec.Motif=="Beast" then
        for _,side in ipairs({-1,1}) do piece("Angular ear",geometry("Ear"),Vector3.new(side*0.7,top+0.7,0),spec.Mask,side*25) end
    elseif spec.Motif=="Veil" then
        piece("Long veil",geometry("Veil",width,scale),Vector3.new(0,body+0.4,0.8),spec.Color)
    else
        for _,side in ipairs({-1,1}) do piece("Bound arch",geometry("Arch",1,scale),Vector3.new(side*1.7*width,body,0.8),spec.Mask) end
        piece("Arch lintel",geometry("Lintel",width),Vector3.new(0,body+2*scale,0.8),spec.Mask)
    end
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
            table.insert(r.Hidden,{Part=part,Alpha=part.LocalTransparencyModifier});part.LocalTransparencyModifier=1
        end
    end
    self.Records[model]=r
    local seen=self.Seen[model] or {};self.Seen[model]=seen;r.Phase=seen.Phase
    if not seen.Intro and tier<=2 and os.clock()>=self.IntroAt then
        seen.Intro=true;self.IntroAt=os.clock()+A.IntroGap
        if self.Audio then self.Audio(A.Sound.Intro) end
        if self.Notice then self.Notice(spec.Name.." · Sequence "..tier) end
    end
    return r
end
function Enemies.Warning(self: any,r: any,now: number)
    if r.Humanoid.Health<=0 then if r.Cue then r.Cue:Finish();r.Cue=nil end;return end
    local threat=r.Model:GetAttribute("VisualThreatUserId")
    local player=type(threat)=="number" and Players:GetPlayerByUserId(threat)
    local target=player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local due=nil;local kind="Melee"
    if target and target:IsA("BasePart") then
        local distance=(target.Position-r.Root.Position).Magnitude
        local melee=r.Model:GetAttribute("VisualMeleeDue")
        if type(melee)=="number" and melee>now and melee-now<=A.WarningLead and distance<=self.Runtime.NPCAttackRange then due=melee end
        local spell=r.Model:GetAttribute("VisualSpellDue")
        if r.Model:GetAttribute("VisualSpellAllowed")==true and r.Tier<=6 and type(spell)=="number" and spell>now and spell-now<=A.WarningLead and distance<=self.Runtime.NPCSpellRange and (not due or spell<due) then due=spell;kind="Spell" end
    end
    if not due then if r.Cue then r.Cue:Finish();r.Cue=nil end;return end
    if r.Cue and r.Cue.Active and r.Due==due then return end
    if r.Cue then r.Cue:Finish() end
    local radius=if kind=="Melee" then self.Runtime.NPCAttackRange else A.SpellRadius
    local h=self.Service:Begin("Enemy telegraph",r.Root.Position,1,A.ThreatPriority,{Part=2})
    if not h then return end
    r.Cue=h;r.Due=due;r.WarningKind=kind;h.Duration=math.max(A.MinimumLife,due-now)
    local rim=h:Acquire("Part");local fill=h:Acquire("Part")
    for _,p in ipairs({rim,fill}) do p.Shape=Enum.PartType.Cylinder;p.Color=T.Colors.Danger;p.Material=Enum.Material.SmoothPlastic end
    h.Update=function()
        if not r.Model.Parent or r.Humanoid.Health<=0 then h:Finish();return end
        h.Position=r.Root.Position
        local t=math.clamp(1-(due-workspace:GetServerTimeNow())/A.WarningLead,0,1)
        local at=r.Root.Position+Vector3.yAxis*A.GroundOffset
        local frame=CFrame.new(at)*CFrame.Angles(0,0,math.pi/2)
        rim.Size=Vector3.new(A.GroundThickness,radius*2,radius*2);rim.CFrame=frame;rim.Transparency=A.WarningAlpha
        fill.Size=Vector3.new(A.GroundThickness,math.max(A.MinimumSize,radius*2*t),math.max(A.MinimumSize,radius*2*t));fill.CFrame=frame+Vector3.yAxis*A.GroundThickness;fill.Transparency=A.FillAlpha
    end
end
function Enemies.Step(self: any,dt: number)
    self.Elapsed+=dt;if self.Elapsed<A.Scan then return end;self.Elapsed=0
    local camera=workspace.CurrentCamera;if not camera then return end
    local now=workspace:GetServerTimeNow();local candidates={};local wanted={}
    for _,model in ipairs(Collection:GetTagged("Enemy")) do
        if model:IsA("Model") and not model:GetAttribute("VisualEcho") then
            local root=model.PrimaryPart;local hum=model:FindFirstChildOfClass("Humanoid")
            if root and hum and (hum.Health>0 or self.Records[model]) and self.Service:Visible(root.Position) then table.insert(candidates,{Model=model,Root=root,Humanoid=hum,Distance=(root.Position-camera.CFrame.Position).Magnitude}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local bars=0;local limit=if self.Service:Profile().Mobile then A.MobileBars else A.MaxBars
    for i,item in ipairs(candidates) do
        if i>A.Max then break end
        local model=item.Model;local r=self.Records[model]
        if not r then r=self:Build(model,item.Root,item.Humanoid,model:GetAttribute("VisualTier")) end
        if not r then continue end;wanted[model]=true
        if r.Humanoid.Health<r.LastHealth then r.HitAt=now end;r.LastHealth=r.Humanoid.Health
        local health=math.clamp(r.Humanoid.Health/math.max(1,r.Humanoid.MaxHealth),0,1)
        if health<=A.PhaseRatio and not r.Phase and r.Tier<=2 and health>0 then
            r.Phase=true;self.Seen[model].Phase=true
            if self.Audio then self.Audio(A.Sound.Phase) end
            self.Blocks:Compose({{Name="SigilStencil",Position=r.Root.Position,Palette="Apprentice",Options={Glyph="Seal",Scale=A.PhaseScale}}},1,A.PhasePriority,A.DeathTime)
            if self.Notice then self.Notice(r.Spec.Name.." · seal fractured") end
        end
        if health<=0 then
            if not r.DiedAt and self.Audio then self.Audio(A.Sound.Death) end
            r.DiedAt=r.DiedAt or now;self:ReleaseBar(r)
        end
        local deadFade=if r.DiedAt then math.clamp((now-r.DiedAt)/A.DeathTime,0,1) else 0
        local reduced=self.Service.ReducedMotion or self.Service.LowGraphics
        local rise=if reduced then 0 else math.sin(now/A.IdlePeriod*math.pi*2)*A.IdleRise
        local serial=model:GetAttribute("VisualAttackSerial") or 0
        if serial>r.Attack then
            r.Attack=serial
            if self.Audio then self.Audio(if model:GetAttribute("VisualAttackKind")=="Spell" then A.Sound.Spell else A.Sound.Melee) end
        end
        local attackAt=model:GetAttribute("VisualAttackAt")
        local attack=if type(attackAt)=="number" then math.clamp(1-(now-attackAt)/A.HitTime,0,1) else 0
        local hit=math.clamp(1-(now-r.HitAt)/A.HitTime,0,1)
        local frame=r.Root.CFrame*CFrame.new(0,rise,0)*CFrame.Angles(math.rad(if reduced then 0 else -attack*A.AttackLean+hit*A.HitLean),0,0)
        for _,part in ipairs(r.Parts) do part.Part.CFrame=frame*part.Offset;part.Part.Transparency=deadFade end
        self:Warning(r,now)
        if health>0 and item.Distance<=A.BarDistance and bars<limit then
            bars+=1;r.Bar=r.Bar or self:Bar()
            if r.Bar then
                r.Bar.Adornee=r.Root;r.Bar.StudsOffset=Vector3.yAxis*(r.Spec.Scale*5);r.Bar.Enabled=true
                r.Bar.Title.Text=(if r.Cue and r.Cue.Active then r.WarningKind.." · " else "")..r.Spec.Name.." · "..math.ceil(r.Humanoid.Health).."/"..math.ceil(r.Humanoid.MaxHealth)
                r.Bar.Track.Fill.Size=UDim2.fromScale(health,1)
            end
        else self:ReleaseBar(r) end
    end
    for model in pairs(self.Records) do if not wanted[model] then self:Clear(model) end end
end
function Enemies.Destroy(self: any)
    for model in pairs(self.Records) do self:Clear(model) end
    for _,bar in ipairs(self.Bars) do bar:Destroy() end;table.clear(self.Bars)
end
return Enemies
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation`. Create matching Folder parents.

```lua
--!strict
-- Confirmed hits only. Recoil is a disposable silhouette; target physics never move.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local HitPresentation={}
function HitPresentation.new(vfx: any,blocks: any): any
    return setmetatable({VFX=vfx,Blocks=blocks,Flashes=setmetatable({},{__mode="k"}),Deaths=setmetatable({},{__mode="k"})},{__index=HitPresentation})
end
function HitPresentation.Hit(self: any,event: any)
    local target=event.Target
    if typeof(target)~="Instance" or not target:IsA("Model") or not target.Parent then return end
    if not self.VFX:Visible(event.Position) then return end
    local humanoid=target:FindFirstChildOfClass("Humanoid")
    if event.Dead==true or (humanoid and humanoid.Health<=C.Hit.MinimumHealth) then self:Death(target,event.Position);return end
    if self.VFX:Profile().ReducedMotion then return end
    local now=os.clock()
    if now-(self.Flashes[target] or -math.huge)<C.Hit.MinFlashGap then return end
    self.Flashes[target]=now
    local handle=self.VFX:Begin("ConfirmedHit",event.Position,1,C.Hit.Priority,C.Hit.Costs)
    if not handle then return end
    handle.Duration=C.Hit.Life
    local highlight=handle:Acquire("Highlight")
    if highlight then
        highlight.Adornee=target;highlight.FillColor=C.Highlight.FillColor
        highlight.FillTransparency=C.Hit.HighlightFill;highlight.OutlineTransparency=C.Hit.Outline
        highlight.Enabled=true
    end
    local body=target:FindFirstChild("UpperTorso") or target:FindFirstChild("Torso") or target.PrimaryPart
    local ghost=handle:Acquire("Part")
    local start: CFrame?=nil
    local direction=Vector3.zero
    if ghost and body and body:IsA("BasePart") then
        start=body.CFrame;direction=body.CFrame.LookVector
        ghost.Size=body.Size;ghost.CFrame=start;ghost.Color=C.Highlight.FillColor;ghost.Transparency=C.Hit.GhostAlpha
    end
    handle.Update=function(_dt: number,age: number)
        if not target.Parent then handle:Finish();return end
        if highlight then highlight.FillTransparency=C.Hit.HighlightFill+(1-C.Hit.HighlightFill)*math.clamp(age/C.Hit.Life,0,1) end
        if ghost and start then
            local alpha=math.clamp(age/C.Hit.KnockbackLife,0,1)
            ghost.CFrame=start+direction*C.Hit.KnockbackDistance*math.sin(alpha*math.pi)
            ghost.Transparency=C.Hit.GhostAlpha+(1-C.Hit.GhostAlpha)*alpha
        end
    end
end
function HitPresentation.Death(self: any,target: Model,position: Vector3)
    if self.Deaths[target] then return end
    local handle=self.VFX:Begin("DeathDissolve",position,1,C.Hit.Priority,C.Hit.DeathCosts)
    if not handle then return end
    self.Deaths[target]=true;handle.Duration=C.Hit.DeathHold
    local parts={}
    for _,item in ipairs(target:GetDescendants()) do
        if item:IsA("BasePart") and #parts<C.Hit.MaxParts then table.insert(parts,{Part=item,Original=item.LocalTransparencyModifier}) end
    end
    handle.OnFinish=function()
        self.Deaths[target]=nil
        for _,entry in ipairs(parts) do
            if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Original end
        end
    end
    handle.Update=function(_dt: number,age: number)
        if not target.Parent then handle:Finish();return end
        local alpha=math.clamp(age/C.Hit.DeathLife,0,1)
        for _,entry in ipairs(parts) do
            if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Original+(1-entry.Original)*alpha end
        end
    end
    self.Blocks:Play("RisingMotes",position,"Seer",1)
end
return HitPresentation
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring`. Create matching Folder parents.

```lua
--!strict
-- Critically damped scalar spring. Stable closed form; no physics or server time.
local C=require(game:GetService("ReplicatedStorage").Shared.AnimConfig)
local MotionSpring={}
MotionSpring.__index=MotionSpring
type Fields={Value: number,Velocity: number,Frequency: number}
export type Spring=typeof(setmetatable({} :: Fields,MotionSpring))
function MotionSpring.new(value: number,frequency: number?): Spring
    return setmetatable({Value=value,Velocity=0,Frequency=frequency or C.Spring.Frequency},MotionSpring)
end
function MotionSpring.Reset(self: Spring,value: number)
    self.Value=value;self.Velocity=0
end
function MotionSpring.Step(self: Spring,delta: number,target: number): number
    if delta<=0 then return self.Value end
    local omega=math.max(0,self.Frequency)*math.pi*2
    if omega==0 then self.Value=target;self.Velocity=0;return target end
    local dt=math.min(delta,C.Spring.MaxStep)
    local difference=self.Value-target
    local tangent=self.Velocity+omega*difference
    local decay=math.exp(-omega*dt)
    self.Value=target+(difference+tangent*dt)*decay
    self.Velocity=(self.Velocity-omega*tangent*dt)*decay
    return self.Value
end
function MotionSpring.Smoothstep(value: number): number
    local t=math.clamp(value,0,1)
    return t*t*(3-2*t)
end
return MotionSpring
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice`. Create matching Folder parents.

```lua
--!strict
-- Original threshold/recording language. No visual creates a dimension, wall or gameplay gate.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography=require(script.Parent.Parent.Choreography)
local Apprentice={}
local function build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    local function pair(nested: boolean,stars: boolean): {any}
        local layers={}
        for _,endpoint in ipairs({c.Origin,c.Self}) do
            local at=endpoint+Vector3.yAxis*C.Ability.GroundOffset
            table.insert(layers,c.Door(at,C.Ability.TravelScale))
            if nested and not c.Simplified then table.insert(layers,c.Door(at+Vector3.zAxis*C.Ability.DepthOffset,C.Ability.Medium)) end
            if stars then table.insert(layers,c.Mark("Star",endpoint+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small)) end
        end
        return layers
    end
    if id=="Apprentice_9" then
        local target=e.Target
        if typeof(target)~="Instance" or not target:IsA("BasePart") or not target.Parent then
            return {c.Mark("Key",e.Position,C.Ability.Medium),c.Mark("Door",c.Gesture,C.Ability.Small)},C.Ability.Life
        end
        local at=target.Position-Vector3.yAxis*(target.Size.Y/2)
        local layers={
            c.Layer("DoorFrame",at,{Frame=CFrame.new(at)*target.CFrame.Rotation,Scale=1/C.Tier[e.Tier].Scale,
                Width=target.Size.X+C.Ability.DoorMargin,Height=target.Size.Y+C.Ability.DoorMargin}),
            c.Mark("Key",target.Position,C.Ability.Small),
        }
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture,target.Position))
            table.insert(layers,c.Mark("Star",target.Position,C.Ability.Small))
        end
        return layers,C.Composition.ResultLife
    elseif id=="Apprentice_9_Secondary" then
        local layers={c.Mark("Key",c.Gesture,C.Ability.Medium),c.Mark("Arch",c.Head,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Ring(c.Ground()))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_8" then
        local layers={
            c.Star(c.TargetChest,C.Ability.Medium),
            c.Beam(c.Gesture,c.TargetChest),
            c.Mark("Star",c.TargetHead,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Flash(c.TargetChest,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.Medium
        local layers={
            c.Beam(e.Position-offset,e.Position+offset),
            c.Beam(e.Position-offset+Vector3.yAxis*C.Ability.Small,e.Position+offset+Vector3.yAxis*C.Ability.Small),
            c.Ring(c.Ground(),c.Radius),
            c.Mark("Circle",e.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Medium),
        }
        if not c.Simplified then
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Circle",target.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_7" then
        if e.Outcome=="Obscured" then
            return {c.Mark("Split",c.Gesture,C.Ability.Small),c.Veil(c.Chest,C.Ability.Small)},C.Ability.Life
        end
        local layers={c.Mark("Star",c.Head,C.Ability.Large),c.Ring(c.Ground()),c.Beam(c.Gesture,c.Head)}
        if not c.Simplified then
            table.insert(layers,c.Star(c.Head,C.Ability.Small))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_7_Secondary" then
        local layers={
            c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset),
            c.Mark("Arch",c.Gesture,C.Ability.Medium),
            c.Mark("Star",c.Head,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Ring(c.Ground())) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_6" then
        local layers={
            c.Mark("Book",c.Gesture,C.Ability.Medium),
            c.Beam(c.TargetChest,c.Gesture),
            c.Mark("Star",c.TargetChest,C.Ability.Small,{MoveTo=c.Gesture}),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Key",c.Chest,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_6_Secondary" then
        local layers={
            c.Mark("Book",c.Gesture,C.Ability.Medium),
            c.Beam(c.Gesture,c.TargetChest),
            c.Star(c.TargetChest,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Mark("Star",c.Gesture,C.Ability.Small,{MoveTo=c.TargetChest}))
            if (e.RecordedCharges or 0)>0 then
                table.insert(layers,c.Mark("Key",c.Head,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_5" then
        local layers=pair(false,false)
        if not c.Simplified then
            table.insert(layers,c.Beam(c.OriginGesture,c.Gesture))
            table.insert(layers,c.Mark("Key",c.Gesture,C.Ability.Small))
        end
        return layers,C.Ability.EndpointLife
    elseif id=="Apprentice_5_Secondary" then
        if e.Preview then return pair(false,false),C.Ability.Life end
        local layers={
            c.Mark("Key",c.Origin,C.Ability.Medium),
            c.Mark("Key",e.Position,C.Ability.Medium),
            c.Mark("Arch",c.Gesture,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Beam(c.Origin,e.Position)) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_4" then
        local layers={
            c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset),
            c.Veil(c.Chest),
            c.Mark("Key",c.Gesture,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Arch",c.Head,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_4_Secondary" then
        local radius=c.Radius
        local layers={c.Ring(c.Ground(),radius)}
        for _,direction in ipairs({Vector3.xAxis,-Vector3.xAxis,Vector3.zAxis,-Vector3.zAxis}) do
            table.insert(layers,c.Door(c.Ground()+direction*radius,C.Ability.CornerScale))
            if c.Simplified and #layers>=3 then break end
        end
        if not c.Simplified and #layers<C.Composition.MaxLayers then
            table.insert(layers,c.Mark("Seal",e.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Medium))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_3" then
        local layers=pair(true,false)
        if not c.Simplified then
            table.insert(layers,c.Mark("Arch",c.Self+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Large))
            table.insert(layers,c.Veil(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_3_Secondary" then
        local layers={
            c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset,C.Ability.Small),
            c.Mark("Arch",c.Gesture,C.Ability.Medium),
            c.Veil(c.Chest),
            c.Mark("Star",c.Head,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Ghost(c.Self)) end
        return layers,C.Ability.Life
    elseif id=="Apprentice_2" then
        local layers={
            c.Mark("Book",c.Gesture-Vector3.xAxis*C.Ability.Small,C.Ability.Medium),
            c.Mark("Book",c.Gesture+Vector3.xAxis*C.Ability.Small,C.Ability.Small),
            c.Beam(c.Gesture,c.TargetChest),
            c.Star(c.TargetChest,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Mark("Arch",c.Gesture,C.Ability.Small))
            table.insert(layers,c.Mark("Star",c.TargetHead,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_2_Secondary" then
        local layers=pair(false,true)
        if not c.Simplified then
            table.insert(layers,c.Trail(c.Origin,C.Ability.Medium,c.Self))
            table.insert(layers,c.Star(c.Self+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_1" then
        if e.Preview then return pair(false,true),C.Ability.Life end
        local layers={
            c.Mark("Star",c.Origin,C.Ability.Large),
            c.Mark("Star",e.Position,C.Ability.Large),
            c.Mark("Key",c.Gesture,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Mark("Arch",c.Origin+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Medium))
            table.insert(layers,c.Mark("Arch",e.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Medium))
            table.insert(layers,c.Motes(c.Self,C.Ability.Medium))
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_1_Secondary" then
        local layers={
            c.Ring(c.Ground(),c.Radius),
            c.Door(e.Position,C.Ability.Small),
            c.Mark("Seal",e.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Large),
            c.Mark("Key",e.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small),
        }
        if not c.Simplified then
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Seal",target.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    end
    return nil,nil
end
function Apprentice.Build(a: any,e: any,c: any): (any,number?)
    local layers,life=build(a,e,c)
    return Choreography.Finish(layers,life,a,c,"Apprentice")
end
return Apprentice
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder`. Create matching Folder parents.

```lua
--!strict
-- Original Error motifs. Dreams, payloads and bounded slows remain gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography=require(script.Parent.Parent.Choreography)
local Marauder={}
local function build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    local function cut(at: Vector3,scale: number?): any
        return c.Mark("Cut",at,scale or C.Ability.Medium,{Tint=C.Ability.TheftTint})
    end
    if id=="Marauder_9" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Gesture
        local layers={
            c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.DefaultScale,{MoveTo=to}),
        }
        if not c.Simplified then table.insert(layers,cut(from,C.Ability.Small)) end
        return layers,C.Ability.PickpocketLife
    elseif id=="Marauder_9_Secondary" then
        local layers={c.Glitch(c.Chest,C.Ability.Small),c.Veil(c.Chest)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Split",c.Gesture,C.Ability.Small))
            table.insert(layers,c.Burst(c.Ground(),C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_8" then
        local layers={c.Mark("Split",c.TargetHead,C.Ability.Medium),c.Glitch(c.Target,C.Ability.Medium)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Mask",c.TargetHead,C.Ability.Small,{Tint=C.Ability.TheftTint}))
            table.insert(layers,c.Beam(c.Gesture,c.TargetHead,C.Ability.TheftTint))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.GhostSpacing
        local layers={
            c.Glitch(c.Target+offset,C.Ability.Medium),
            c.Ghost(c.Target,c.Target+offset),
            c.Beam(c.Target,c.Target+offset,C.Ability.TheftTint),
        }
        if not c.Simplified then table.insert(layers,cut(c.Target,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_7" then
        local layers={c.Mark("Book",c.Gesture,C.Ability.Medium),c.Mark("Split",c.Head,C.Ability.Small),c.Ring(c.Ground())}
        if not c.Simplified then table.insert(layers,c.Mark("Eye",c.Head,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_7_Secondary" then
        if e.Outcome=="Obscured" then
            return {cut(c.Chest,C.Ability.Small),c.Glitch(c.Chest,C.Ability.Small)},C.Ability.Life
        end
        local layers={c.Mark("Split",c.Head,C.Ability.Large),c.Glitch(c.Gesture,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Scale",c.Gesture,C.Ability.Small))
            table.insert(layers,c.Ring(c.Ground()))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_6" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Gesture
        if e.Outcome=="Released" then
            from,to=c.Gesture,e.Position+Vector3.yAxis*C.Ability.HandHeight
            local layers={
                c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
                c.Mark("Split",from,C.Ability.Medium,{MoveTo=to}),
                c.Star(to,C.Ability.Medium,C.Ability.TheftTint),
            }
            if not c.Simplified then table.insert(layers,c.Glitch(to,C.Ability.Small)) end
            return layers,C.Ability.TheftLife
        end
        local layers={
            c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.Medium,{MoveTo=to}),
            c.Glitch(from,C.Ability.Small),
        }
        if not c.Simplified then
            table.insert(layers,cut(from,C.Ability.Small))
            table.insert(layers,c.Mark("Star",to,C.Ability.Small,{Tint=C.Ability.TheftTint}))
        end
        return layers,C.Ability.TheftLife
    elseif id=="Marauder_6_Secondary" then
        local layers={c.Beam(c.TargetChest,c.Chest,C.Ability.TheftTint),c.Motes(c.Chest,C.Ability.Small),cut(c.TargetChest)}
        if not c.Simplified then table.insert(layers,c.Mark("Split",c.TargetChest,C.Ability.Small,{MoveTo=c.Chest})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_5" then
        local at=c.TargetHead
        local layers={c.Mark("Split",at,C.Ability.Small,{MoveTo=c.Gesture}),c.Beam(at,c.Gesture),cut(at)}
        if not c.Simplified then table.insert(layers,c.Mark("Eye",at,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_5_Secondary" then
        local layers={
            cut(c.TargetHead),
            c.Motes(c.Target,C.Ability.Small,C.Ability.TheftTint),
            c.Mark("Split",c.TargetChest,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Veil(c.Target,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_4" then
        local layers={c.Beam(c.Gesture,c.TargetChest),c.Mark("Split",c.TargetChest,C.Ability.Small),c.Veil(c.Target)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Chest,c.TargetHead,C.Ability.TheftTint))
            table.insert(layers,c.Mark("Thread",c.TargetChest,C.Ability.Small,{Tint=C.Ability.TheftTint}))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_4_Secondary" then
        local layers={
            c.Beam(c.TargetChest,c.Chest,C.Ability.TheftTint),
            c.Beam(c.TargetHead,c.Gesture),
            c.Ring(c.Ground()),
        }
        if not c.Simplified then
            table.insert(layers,cut(c.TargetChest,C.Ability.Small))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small,C.Ability.TheftTint))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_3" then
        local layers={
            c.Glitch(c.Target,C.Ability.Medium),
            c.Mark("Eye",c.TargetHead,C.Ability.Small,{Tint=C.Ability.TheftTint}),
            c.Mark("Mask",c.TargetChest,C.Ability.Medium),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Split",c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_3_Secondary" then
        local layers={
            c.Veil(c.Target),
            c.Beam(c.Gesture,c.TargetHead,C.Ability.TheftTint),
            c.Mark("Split",c.TargetChest,C.Ability.Large),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Crown",c.TargetHead,C.Ability.Medium,{Tint=C.Ability.TheftTint})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_2" then
        local layers={cut(c.Origin),cut(c.Self),c.Ghost(c.Origin,c.Self),c.Mark("Split",c.Target,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Beam(c.Self,c.Target,C.Ability.TheftTint)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Marauder_2_Secondary" then
        if e.Trigger=="PayloadTriggered" then
            local layers={
                cut(e.Position),
                c.Mark("Star",e.Position,C.Ability.Medium,{Tint=C.Ability.TheftTint}),
                c.Mark("Split",e.Position,C.Ability.Large),
            }
            if not c.Simplified then table.insert(layers,c.Glitch(e.Position,C.Ability.Medium)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={
            c.Mark("Split",c.TargetChest,C.Ability.Small),
            c.Beam(c.Target,c.Target+Vector3.yAxis*C.Ability.Medium,C.Ability.TheftTint),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Star",c.TargetChest,C.Ability.Small,{Tint=C.Ability.TheftTint})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_1" then
        local layers={
            c.Mark("Clock",c.TargetHead,C.Ability.Large),
            c.Beam(c.TargetHead,c.Gesture,C.Ability.TheftTint),
            c.Mark("Cut",c.TargetHead,C.Ability.Small,{MoveTo=c.Gesture,Tint=C.Ability.TheftTint}),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Clock",c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_1_Secondary" then
        local layers={
            c.Ring(c.Ground(),c.Radius),
            c.Mark("Clock",e.Position,C.Ability.Large),
            c.Glitch(e.Position,C.Ability.Medium),
        }
        if not c.Simplified then
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Clock",target.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    end
    return nil,nil
end
function Marauder.Build(a: any,e: any,c: any): (any,number?)
    local layers,life=build(a,e,c)
    return Choreography.Finish(layers,life,a,c,"Marauder")
end
return Marauder
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer`. Create matching Folder parents.

```lua
--!strict
-- Canon-inspired concepts; exact geometry and bounded gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography=require(script.Parent.Parent.Choreography)
local Seer={}
local function build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    if id=="Seer_9" then
        if e.Outcome=="Obscured" then
            return {c.Mark("Split",c.Gesture,C.Ability.Small),c.Veil(c.Chest,C.Ability.Small)},C.Ability.Life
        end
        local layers={c.Cards(c.Gesture,C.Ability.Medium),c.Ring(c.Ground()),c.Mark("Card",c.Head,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Mark("Star",c.Head+Vector3.yAxis*C.Ability.Small,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_9_Secondary" then
        local layers={c.Mark("Eye",c.Head,C.Ability.EyeScale),c.Veil(c.Head,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Ring(c.Ground()))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Composition.ResultLife
    elseif id=="Seer_8" then
        local layers={
            c.Ghost(c.Origin,c.Self),
            c.Burst(c.Origin+Vector3.yAxis*C.Ability.GroundOffset,C.Ability.Small),
            c.Mark("Circle",c.Self,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Trail(c.Origin,C.Ability.Small,c.Self)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_8_Secondary" then
        local layers={c.Mark("Scale",c.Gesture,C.Ability.Medium),c.Ring(c.Ground())}
        if not c.Simplified then
            table.insert(layers,c.Mark("Mask",c.Head,C.Ability.Small))
            table.insert(layers,c.Burst(c.Ground(),C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_7" then
        local layers={}
        for _,at in ipairs({c.Origin,c.Self}) do
            table.insert(layers,c.Layer("RingBurst",at+Vector3.yAxis*C.Ability.GroundOffset,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameRim}))
            table.insert(layers,c.Layer("RisingMotes",at,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameTint}))
        end
        if not c.Simplified then
            table.insert(layers,c.Beam(c.OriginGesture,c.Gesture,C.Ability.FlameTint))
            table.insert(layers,c.Mark("Flame",c.Gesture,C.Ability.Small))
        end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_7_Secondary" then
        if e.Trigger=="SubstituteTriggered" then
            local layers={
                c.Paper(e.Position,true,C.Ability.Large),
                c.Cards(e.Position,C.Ability.Small),
                c.Mark("Thread",e.Position,C.Ability.Small),
            }
            if not c.Simplified then table.insert(layers,c.Burst(e.Position,C.Ability.Small)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={c.Paper(c.Gesture,false,C.Ability.Medium),c.Mark("Card",c.Chest,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Beam(c.Gesture,c.Head)) end
        return layers,C.Ability.Life
    elseif id=="Seer_6" then
        local layers={c.Mark("Mask",c.Head,C.Ability.Medium),c.Veil(c.Head),c.Ghost(c.Self)}
        if not c.Simplified then table.insert(layers,c.Motes(c.Self,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_6_Secondary" then
        local layers={
            c.Mark("Circle",c.Gesture,C.Ability.Small),
            c.Beam(c.Gesture-Vector3.xAxis*C.Ability.Small,c.Gesture+Vector3.xAxis*C.Ability.Small),
            c.Veil(c.Chest,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Burst(c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_5" then
        local stageScale=if e.Controlled then C.Ability.Large else C.Ability.Medium
        local layers={c.Beam(c.Gesture,c.Target),c.Mark("Thread",c.Target,stageScale)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture+Vector3.xAxis*C.Ability.Small,c.Target+Vector3.yAxis*C.Ability.Small))
            if (e.Threads and e.Threads>=2) or e.Controlled then
                table.insert(layers,c.Beam(c.Gesture-Vector3.xAxis*C.Ability.Small,c.TargetHead))
            end
            if e.Controlled then
                table.insert(layers,c.Mark("Seal",c.TargetHead,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    elseif id=="Seer_5_Secondary" then
        local layers={c.Beam(c.Gesture,c.Target),c.Mark("Thread",c.Target,C.Ability.Small)}
        local hit=e.Affected and e.Affected[1]
        if hit then
            table.insert(layers,c.Beam(c.Target,hit.Position))
            if not c.Simplified then table.insert(layers,c.Mark("Star",hit.Position,C.Ability.Small)) end
        elseif not c.Simplified then
            table.insert(layers,c.Mark("Crown",c.TargetHead,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_4" then
        local layers={c.Ghost(c.Origin,c.Self),c.Ghost(c.Self,c.Origin),c.Beam(c.Origin,c.Self),c.Mark("Thread",c.Self,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Mark("Thread",c.Origin,C.Ability.Small)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_4_Secondary" then
        local layers={c.Ring(c.Ground(),c.Radius),c.Mark("Mask",e.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Medium),c.Ghost(e.Position)}
        if not c.Simplified then
            table.insert(layers,c.Ghost(e.Position+Vector3.xAxis*C.Ability.GhostSpacing))
            table.insert(layers,c.Ghost(e.Position-Vector3.xAxis*C.Ability.GhostSpacing))
            local hit=e.Affected and e.Affected[1]
            if hit then table.insert(layers,c.Mark("Eye",hit.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small)) end
        end
        return layers,C.Ability.Life
    elseif id=="Seer_3" then
        local root=c.Root(e.Echo)
        local at=if root then root.Position else e.Position
        local layers={c.Veil(at),c.Ghost(at),c.Ring(c.Ground(at)),c.Mark("Hourglass",at+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture,at+Vector3.yAxis*C.Ability.ChestHeight))
            table.insert(layers,c.Motes(at,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_3_Secondary" then
        local past=c.Self+Vector3.xAxis*C.Ability.RecallOffset
        local layers={
            c.Ghost(past,c.Self),
            c.Beam(c.Chest+Vector3.xAxis*C.Ability.RecallOffset,c.Chest),
            c.Mark("Hourglass",c.Gesture,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Ring(c.Ground()))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_2" then
        local layers={
            c.Ring(c.Ground()),
            c.Mark("Star",c.Gesture,C.Ability.Large),
            c.Motes(c.Self,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture,c.Chest))
            table.insert(layers,c.Mark("Seal",c.Chest,C.Ability.Medium))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_2_Secondary" then
        local layers={
            c.Beam(c.Chest-Vector3.xAxis*C.Ability.Medium,c.Chest),
            c.Beam(c.Chest+Vector3.xAxis*C.Ability.Medium,c.Chest),
            c.Star(c.Chest,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Mark("Hourglass",c.Head,C.Ability.Small))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_1" then
        if e.Trigger=="GraftReflected" then
            local layers={c.Mark("Thread",e.Position,C.Ability.Large),c.Beam(e.Position,c.Chest)}
            if not c.Simplified then table.insert(layers,c.Star(e.Position,C.Ability.Small)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={c.Mark("Thread",e.Position,C.Ability.Large),c.Mark("Seal",e.Position,C.Ability.Small)}
        for i,target in ipairs(e.Affected or {}) do
            if (c.Simplified and i>1) or #layers>=C.Composition.MaxLayers then break end
            table.insert(layers,c.Beam(c.Gesture,target.Position))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_1_Secondary" then
        local layers={
            c.Ring(c.Ground(),c.Radius),
            c.Mark("Crown",e.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Large),
            c.Veil(e.Position+Vector3.xAxis*C.Ability.GhostSpacing),
        }
        if not c.Simplified then
            table.insert(layers,c.Veil(e.Position-Vector3.xAxis*C.Ability.GhostSpacing))
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Seal",target.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    end
    return nil,nil
end
function Seer.Build(a: any,e: any,c: any): (any,number?)
    local layers,life=build(a,e,c)
    return Choreography.Finish(layers,life,a,c,"Seer")
end
return Seer
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe`. Create matching Folder parents.

```lua
--!strict
-- Studio-only, bounded local stress harness. Measures Heartbeat intervals, not GPU time.
local RunService=game:GetService("RunService")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Probe={}
local function total(counts: any): number local n=0;for _,v in pairs(counts) do n+=v end;return n end
function Probe.new(service: any,blocks: any): any
    return setmetatable({Service=service,Blocks=blocks,Running=false,Reports=0,Last=nil,Handles={},Frames={}},{__index=Probe})
end
function Probe.Start(self: any,position: Vector3,palette: string): boolean
    if not RunService:IsStudio() or self.Running or self.Reports>=T.QA.MaxReports then return false end
    self.Running=true;self.Elapsed=0;self.NextBurst=0;self.Position=position;self.Palette=palette
    self.Frames={};self.FrameSerial=0;self.Peak=0;self.Violations=0;self.Attempts=0;self.Handles={};self.Before=self.Service:Stats()
    self.BeforeInstances=#workspace:GetDescendants()
    return true
end
function Probe.Cancel(self: any)
    for _,handle in ipairs(self.Handles) do if handle.Active then handle:Finish() end end
    self.Handles={};self.Running=false
end
function Probe.Finish(self: any)
    local stats=self.Service:Stats();local frames=table.clone(self.Frames);table.sort(frames)
    local function percentile(fraction: number): number return frames[math.max(1,math.ceil(#frames*fraction))] or 0 end
    local profile=self.Service:Profile();local pools=true
    for class,count in pairs(stats.Allocated) do if count>self.Service.Limits[class] then pools=false end end
    self.Reports+=1
    self.Last={MedianMs=percentile(0.5),P95Ms=percentile(0.95),MaxMs=frames[#frames] or 0,Samples=#frames,Peak=self.Peak,Cap=profile.MaxEffects,
        Allocated=total(stats.Allocated),Reserved=total(stats.Reserved),Active=stats.Active,Errors=stats.Errors-self.Before.Errors,
        BudgetViolations=self.Violations,BeforeActive=self.Before.Active,BeforeReserved=total(self.Before.Reserved),
        Dropped=stats.Dropped-self.Before.Dropped,Evicted=stats.Evicted-self.Before.Evicted,PoolsBounded=pools,
        InstancesBefore=self.BeforeInstances,InstancesAfter=#workspace:GetDescendants(),Attempts=self.Attempts,Mobile=profile.Mobile,Quality=profile.Level,
        Reduced=self.Service.ReducedMotion,Low=self.Service.LowGraphics}
    self:Cancel()
    print(T.QA.ReportPrefix..game:GetService("HttpService"):JSONEncode(self.Last))
end
function Probe.Step(self: any,dt: number)
    if not self.Running then return end
    self.Elapsed+=dt;self.FrameSerial+=1
    self.Frames[(self.FrameSerial-1)%T.QA.Samples+1]=dt*1000
    local stats=self.Service:Stats();self.Peak=math.max(self.Peak,stats.Active)
    if stats.Active>self.Service:Profile().MaxEffects then self.Violations+=1 end
    if self.Elapsed>=T.QA.Duration+T.QA.Drain then self:Finish();return end
    if self.Elapsed>T.QA.Duration or self.Elapsed<self.NextBurst then return end
    self.NextBurst=self.Elapsed+T.QA.SpawnInterval
    local alive={};for _,handle in ipairs(self.Handles) do if handle.Active then table.insert(alive,handle) end end;self.Handles=alive
    local names={"CardFan","VeilRibbon","GroundRune","SigilStencil"}
    for i=1,self.Service:Profile().MaxEffects+T.QA.Overfill do
        self.Attempts+=1
        local at=self.Position+Vector3.xAxis*((i%3)-1)
        local h=self.Blocks:Compose({{Name=names[(i-1)%#names+1],Position=at,Palette=self.Palette,
            Options={Scale=T.QA.Scale,Glyph="Seal",Frame=CFrame.new(at)}}},1,T.QA.Priority,T.World.Ambient.Life)
        if h then table.insert(self.Handles,h) end
    end
    self.Peak=math.max(self.Peak,self.Service:Stats().Active)
end
return Probe
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/StatusPresentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/StatusPresentation`. Create matching Folder parents.

```lua
--!strict
-- Private sensing targets are granted by the server. No discovery/raycast runs here.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Root=require(script.Parent.Choreography).Root
local Status={}
function Status.new(service: any,clock: ()->number,blocks: any?): any
    return setmetatable({Service=service,Clock=clock,Entries={},Blocks=blocks,Records={},GuiPool={},Widgets=0,Gates={},Echoes={},LastRevision=0,RecordSerial=0},{__index=Status})
end
function Status.Reveal(self: any,event: any,pathway: string)
    local life=math.clamp((event.ExpiresAt or 0)-self.Clock(),0,C.Protocol.RevealLife)
    if life<=0 then return end
    local palette=C.Palettes[pathway]
    local count=0
    for target,entry in pairs(self.Entries) do
        if not entry.Active then self.Entries[target]=nil else count+=1 end
    end
    for _,item in ipairs(event.Targets) do
        local target=item.Target
        if typeof(target)~="Instance" or not target.Parent or not self.Service:Visible(item.Position) then continue end
        local previous=self.Entries[target]
        if previous and previous.Active then previous.Age=0;previous.Duration=life;continue end
        if count>=C.Protocol.MaxStatuses then break end
        local h=self.Service:Begin("PrivateReveal",item.Position,1,C.Ability.RevealPriority,{Highlight=1})
        if not h then continue end
        count+=1;self.Entries[target]=h;h.Duration=life
        local highlight=h:Acquire("Highlight")
        highlight.Adornee=target;highlight.FillColor=palette.Primary;highlight.OutlineColor=palette.Accent
        highlight.FillTransparency=C.Ability.RevealFill;highlight.OutlineTransparency=C.Ability.RevealOutline
        h.Update=function(_dt: number,_age: number,t: number)
            if not target.Parent then h:Finish();return end
            if target:IsA("BasePart") then h.Position=target.Position
            elseif target:IsA("Model") then
                local root=target.PrimaryPart or target:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then h.Position=root.Position end
            end
            highlight.FillTransparency=C.Ability.RevealFill+(1-C.Ability.RevealFill)*t
            highlight.OutlineTransparency=C.Ability.RevealOutline+(1-C.Ability.RevealOutline)*t
        end
    end
end
function Status.Step(self: any)
    self:Reconcile()
    for target,entry in pairs(self.Entries) do if not entry.Active then self.Entries[target]=nil end end
end
function Status.Clear(self: any)
    for _,entry in pairs(self.Entries) do entry:Finish() end;table.clear(self.Entries)
    for _,record in pairs(self.Records) do self:ReleaseBadge(record) end;table.clear(self.Records)
    for owner in pairs(self.Gates) do self:RemoveGates(owner) end
    for _,echo in pairs(self.Echoes) do self:RestoreEcho(echo) end;table.clear(self.Echoes)
end
function Status.Badge(self: any): any
    local pooled=table.remove(self.GuiPool)
    if pooled then return pooled end
    if self.Widgets>=T.StatusUI.Max then return nil end
    self.Widgets+=1
    local gui=Instance.new("BillboardGui");gui.Name="MysteriesStatus";gui.Size=UDim2.fromOffset(T.StatusUI.Width,T.StatusUI.Height)
    gui.StudsOffset=Vector3.new(0,T.StatusUI.OffsetStuds,0);gui.AlwaysOnTop=false;gui.MaxDistance=T.StatusUI.Distance
    local label=Instance.new("TextLabel");label.Name="Status";label.Size=UDim2.fromScale(1,1)
    label.BackgroundColor3=T.Colors.Ink;label.BackgroundTransparency=T.StatusUI.BackgroundAlpha;label.BorderSizePixel=0
    label.TextColor3=T.Colors.Text;label.Font=T.Fonts.Number;label.TextSize=T.StatusUI.TextSize;label.TextTruncate=Enum.TextTruncate.AtEnd
    label.Parent=gui;gui.Parent=self.Service.Folder
    return gui
end
function Status.ReleaseBadge(self: any,record: any)
    if record.Widget then record.Widget.Enabled=false;record.Widget.Adornee=nil;table.insert(self.GuiPool,record.Widget);record.Widget=nil end
end
function Status.Event(self: any,e: any,localId: number): boolean
    if typeof(e.Target)~="Instance" or not C.Status.Labels[e.StatusId] or not C.Palettes[e.PathwayId] then return false end
    if C.Status.Private[e.StatusId] and e.Owner~=localId then return false end
    if e.Revision<=self.LastRevision then return false end
    self.LastRevision=e.Revision
    local records=self.Records[e.Target]
    if not records then
        local count=0;for _ in pairs(self.Records) do count+=1 end
        if count>=C.Protocol.MaxStatusRecords then return false end
        self.RecordSerial+=1
        records={Target=e.Target,States={},Serial=self.RecordSerial};self.Records[e.Target]=records
    end
    local old=records.States[e.StatusId]
    if old and old.Revision>=e.Revision then return false end
    if e.Action=="Remove" then records.States[e.StatusId]={Revision=e.Revision,Removed=true,Owner=e.Owner};return true end
    records.States[e.StatusId]={Revision=e.Revision,Owner=e.Owner,ExpiresAt=e.ExpiresAt,PathwayId=e.PathwayId,Count=e.Count or 0,Required=e.Required}
    return true
end
function Status.RemoveGates(self: any,owner: number)
    local gate=self.Gates[owner]
    if not gate then return end
    if gate.Handle then gate.Handle:Finish() end
    for _,entry in ipairs(gate.Parts) do
        if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Alpha;entry.Part.Color=entry.Color end
    end
    self.Gates[owner]=nil
end
function Status.Gate(self: any,e: any)
    if not self.Blocks or type(e.Gates)~="table" or #e.Gates~=2 or not e.ExpiresAt then return end
    self:RemoveGates(e.Owner)
    local count=0;for _ in pairs(self.Gates) do count+=1 end
    if count>=C.Status.MaxGatePairs then return end
    local parts={}
    for _,part in ipairs(e.Gates) do
        if typeof(part)~="Instance" or not part:IsA("BasePart") or not part.Parent then return end
        table.insert(parts,{Part=part,Alpha=part.LocalTransparencyModifier,Color=part.Color})
    end
    for _,entry in ipairs(parts) do entry.Part.Color=C.Palettes.Apprentice.Primary end
    self.Gates[e.Owner]={Parts=parts,ExpiresAt=e.ExpiresAt,Owner=e.Owner,AbilityId=e.AbilityId,NextAttempt=0}
end
function Status.GateStep(self: any,gate: any,now: number)
    for _,entry in ipairs(gate.Parts) do if not entry.Part.Parent then self:RemoveGates(gate.Owner);return end end
    if now>=gate.ExpiresAt then self:RemoveGates(gate.Owner);return end
    if gate.Handle and gate.Handle.Active then return end
    if now<gate.NextAttempt then return end
    gate.NextAttempt=now+C.Status.Retry
    local layers={};local star=gate.AbilityId=="Apprentice_1"
    for _,entry in ipairs(gate.Parts) do
        local part=entry.Part
        local at=part.Position-Vector3.yAxis*(part.Size.Y/2)
        table.insert(layers,{Name="DoorFrame",Position=at,Palette="Apprentice",Options={Frame=CFrame.new(at)*part.CFrame.Rotation,
            Scale=1,Width=part.Size.X+C.Ability.DoorMargin,Height=part.Size.Y+C.Ability.DoorMargin}})
        if star then
            local top=part.Position+Vector3.yAxis*(part.Size.Y/2+C.Ability.GateStarOffset)
            table.insert(layers,{Name="SigilStencil",Position=top,Palette="Apprentice",
                Options={Frame=CFrame.new(top)*part.CFrame.Rotation,Glyph="Star",LowGlyph="Star",Scale=C.Ability.GateStarScale}})
        end
    end
    local handle=self.Blocks:Compose(layers,1,C.Status.GatePriority,math.min(C.Status.Lease,gate.ExpiresAt-now))
    if not handle then return end
    gate.Handle=handle
    -- Only suppress the old pane while the budget admits a replacement frame.
    for _,entry in ipairs(gate.Parts) do entry.Part.LocalTransparencyModifier=1 end
    handle.OnFinish=function()
        for _,entry in ipairs(gate.Parts) do if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Alpha end end
    end
end
function Status.Echo(self: any,e: any)
    local model=e.Echo
    if typeof(model)~="Instance" or not model:IsA("Model") or not e.ExpiresAt then return end
    local count=0;for _ in pairs(self.Echoes) do count+=1 end
    if count>=C.Status.MaxEchoes or self.Echoes[model] then return end
    local parts={}
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency<1 and #parts<C.Hit.MaxParts then
            table.insert(parts,{Part=part,Color=part.Color,Alpha=part.LocalTransparencyModifier})
            part.Color=C.Status.EchoColor;part.LocalTransparencyModifier=C.Status.EchoAlpha
        end
    end
    self.Echoes[model]={Model=model,Parts=parts,ExpiresAt=e.ExpiresAt,Owner=e.Owner}
end
function Status.RestoreEcho(self: any,echo: any)
    for _,entry in ipairs(echo.Parts) do
        if entry.Part.Parent then entry.Part.Color=entry.Color;entry.Part.LocalTransparencyModifier=entry.Alpha end
    end
end
function Status.ClearLocal(self: any,owner: number)
    for _,entry in pairs(self.Entries) do entry:Finish() end;table.clear(self.Entries)
    for _,record in pairs(self.Records) do
        for id,state in pairs(record.States) do if state.Owner==owner then record.States[id]=nil end end
    end
    self:RemoveGates(owner)
    for model,echo in pairs(self.Echoes) do if echo.Owner==owner then self:RestoreEcho(echo);self.Echoes[model]=nil end end
end
function Status.Reconcile(self: any)
    local now=self.Clock();local candidates={}
    for target,record in pairs(self.Records) do
        local live={};local priority=0
        for id,state in pairs(record.States) do
            if state.Removed or state.ExpiresAt<=now then record.States[id]=nil
            else
                local text=C.Status.Labels[id]
                if id=="Threaded" then text..=" "..state.Count.."/"..(state.Required or T.StatusUI.RequiredThreads) end
                if id=="Controlled" and state.PathwayId=="Seer" then text="Marionette" end
                table.insert(live,{Text=text,Priority=T.StatusUI.Priorities[id] or 0});priority=math.max(priority,T.StatusUI.Priorities[id] or 0)
            end
        end
        local root=Root(target)
        local hum=target:IsA("Model") and target:FindFirstChildOfClass("Humanoid")
        if not target.Parent or not root or (hum and hum.Health<=0) or #live==0 then
            self:ReleaseBadge(record);self.Records[target]=nil
        elseif self.Service:Visible(root.Position) and (root.Position-(self.Service.Camera or workspace.CurrentCamera).CFrame.Position).Magnitude<=T.StatusUI.Distance then
            table.sort(live,function(a,b) return if a.Priority==b.Priority then a.Text<b.Text else a.Priority>b.Priority end)
            record.Text=live[1].Text..(if live[2] then " · "..live[2].Text else "");record.Priority=priority;record.Root=root
            record.Distance=(root.Position-(self.Service.Camera or workspace.CurrentCamera).CFrame.Position).Magnitude
            table.insert(candidates,record)
        else self:ReleaseBadge(record) end
    end
    table.sort(candidates,function(a,b)
        if a.Priority~=b.Priority then return a.Priority>b.Priority end
        return if a.Distance==b.Distance then a.Serial<b.Serial else a.Distance<b.Distance
    end)
    local limit=if self.Service:Profile().Mobile then T.StatusUI.MobileMax else T.StatusUI.Max
    for i,record in ipairs(candidates) do
        if i>limit then self:ReleaseBadge(record)
        else
            record.Widget=record.Widget or self:Badge()
            if record.Widget then record.Widget.Adornee=record.Root;record.Widget.Status.Text=record.Text;record.Widget.Enabled=true end
        end
    end
    for _,gate in pairs(self.Gates) do self:GateStep(gate,now) end
    for model,echo in pairs(self.Echoes) do
        if not model.Parent or now>=echo.ExpiresAt then self:RestoreEcho(echo);self.Echoes[model]=nil end
    end
end
return Status
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/VfxService.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/VfxService`. Create matching Folder parents.

```lua
--!strict
-- Client-only bounded pool/reservation owner. Nothing here can decide a hit or move a character.
local Shared=game:GetService("ReplicatedStorage").Shared
local Config=require(Shared.VfxConfig)
local Budget=require(Shared.VisualBudget)
local UserInputService=game:GetService("UserInputService")
local Service={}
Service.__index=Service
local Handle={}
Handle.__index=Handle
local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end
local function validPosition(position: any): boolean
    return typeof(position)=="Vector3" and finite(position.X) and finite(position.Y) and finite(position.Z)
        and position.Magnitude<=Config.Safety.PositionLimit
end
local function qualityLevel(): number
    local ok,value=pcall(function() return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value end)
    return if ok and type(value)=="number" and value>0 then value else Config.Quality.AutoLevel
end
local function camera(self: any): Camera?
    return self.Camera or workspace.CurrentCamera
end
local function defaults(object: any,class: string)
    local props: any
    if class=="ParticleEmitter" then props=Config.Particle
    elseif class=="PointLight" then props=Config.Light
    else props=Config[class] end
    if props then for property,value in pairs(props) do object[property]=value end end
    if class=="Part" then
        object.Anchored=true;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false
        object.CastShadow=false;object.CFrame=CFrame.identity
    elseif class=="Beam" or class=="Trail" then
        object.Attachment0=nil;object.Attachment1=nil;object.Enabled=true
        if class=="Trail" then object:Clear() end
    elseif class=="ParticleEmitter" then object.Enabled=false;object:Clear()
    elseif class=="Highlight" then object.Adornee=nil;object.Enabled=true end
end
local function park(object: any,class: string)
    if class=="Beam" or class=="Trail" then
        object.Enabled=false;object.Attachment0=nil;object.Attachment1=nil
        if class=="Trail" then object:Clear() end
    elseif class=="ParticleEmitter" then object.Enabled=false;object:Clear()
    elseif class=="PointLight" then object.Enabled=false
    elseif class=="Highlight" then object.Enabled=false;object.Adornee=nil end
    object.Parent=nil
end
function Handle.Acquire(self: any,class: string,parent: Instance?): any
    if not self.Active or (self.Acquired[class] or 0)>=(self.Costs[class] or 0) then return nil end
    local owner=self.Owner
    local pool=owner.Pools[class]
    if not pool then return nil end
    local object=table.remove(pool)
    if not object then
        if owner.Allocated[class]>=owner.Limits[class] then return nil end
        object=Instance.new(class :: any);owner.Allocated[class]+=1
    end
    local acquired: any=object
    defaults(acquired,class)
    acquired.Name="VFX_"..class;acquired.Parent=parent or owner.Folder
    self.Acquired[class]=(self.Acquired[class] or 0)+1
    table.insert(self.Objects,{Object=acquired,Class=class})
    return acquired
end
function Handle.Finish(self: any)
    if not self.Active then return end
    self.Active=false
    local owner=self.Owner
    owner.Active[self.Id]=nil;owner.Budget:Remove(self.Id)
    if self.OnFinish then
        local ok=pcall(self.OnFinish)
        if not ok then owner.Errors+=1 end
    end
    for _,entry in ipairs(self.Objects) do
        park(entry.Object,entry.Class);table.insert(owner.Pools[entry.Class],entry.Object)
    end
    table.clear(self.Objects);self.Update=nil;self.OnFinish=nil;self.ResolveAnchors=nil;self.Anchors=nil;self.Character=nil;self.CasterId=nil
end
Handle.Stop=Handle.Finish
function Service.new(options: any?): any
    local settings=options or {}
    local folder=Instance.new("Folder");folder.Name="LocalVisualFramework";folder.Parent=workspace
    local mobile=if settings.Mobile~=nil then settings.Mobile else UserInputService.TouchEnabled
    local limits=if mobile then Config.Pools.Mobile else Config.Pools.Desktop
    local self: any=setmetatable({Folder=folder,Camera=settings.Camera,Mobile=mobile,MobileOverride=settings.Mobile,
        LowGraphics=settings.LowGraphics==true,ReducedMotion=settings.ReducedMotion==true,
        Pools={},Allocated={},Limits=limits,Active={},Serial=0,Evicted=0,Dropped=0,Errors=0,Destroyed=false,ProfileKey=""},Service)
    for class in pairs(limits) do self.Pools[class]={};self.Allocated[class]=0 end
    self:_Refresh()
    return self
end
function Service._Refresh(self: any)
    local mobile=if self.MobileOverride~=nil then self.MobileOverride else UserInputService.TouchEnabled
    if mobile~=self.Mobile then
        local finishing={}
        for _,effect in pairs(self.Active) do table.insert(finishing,effect) end
        for _,effect in ipairs(finishing) do effect:Finish() end
        self.Mobile=mobile;self.Limits=if mobile then Config.Pools.Mobile else Config.Pools.Desktop
        for class,pool in pairs(self.Pools) do
            while self.Allocated[class]>self.Limits[class] do
                local object=table.remove(pool)
                if not object then break end
                object:Destroy();self.Allocated[class]-=1
            end
        end
        self.ProfileKey=""
    end
    local level=qualityLevel()
    local q=Config.Quality
    local low=self.LowGraphics or level<=q.LowLevel
    local detail=if low then q.Low else (if level<=q.MediumLevel then q.Medium else q.High)
    local maxEffects=if low then q.LowEffects else (if level<=q.MediumLevel then q.MediumEffects else q.HighEffects)
    if self.Mobile then maxEffects=math.min(maxEffects,q.MobileEffects) end
    local key=tostring(detail)..":"..tostring(self.ReducedMotion)
    if self.ProfileKey~=key then
        local finishing={}
        for _,effect in pairs(self.Active) do table.insert(finishing,effect) end
        for _,effect in ipairs(finishing) do effect:Finish() end
        self.Budget=Budget.new(self.Limits,maxEffects);self.ProfileKey=key
    end
    self.CurrentProfile={Detail=detail,Low=low,ReducedMotion=self.ReducedMotion,Mobile=self.Mobile,Level=level,MaxEffects=maxEffects}
end
function Service.Profile(self: any): any
    self:_Refresh()
    return table.clone(self.CurrentProfile)
end
function Service.Visible(self: any,position: any): boolean
    if self.Destroyed or not validPosition(position) then return false end
    local current=camera(self)
    if not current or (position-current.CFrame.Position).Magnitude>Config.Quality.MaximumDistance then return false end
    local point,onScreen=current:WorldToViewportPoint(position)
    return onScreen and point.Z>0
end
function Service.Detail(self: any,position: Vector3): number
    local profile=self:Profile()
    local current=camera(self)
    if not current then return profile.Detail end
    local distance=(position-current.CFrame.Position).Magnitude
    if distance>Config.Quality.Middle then return profile.Detail*Config.Quality.FarScale end
    if distance>Config.Quality.Near then return profile.Detail*Config.Quality.MiddleScale end
    return profile.Detail
end
function Service.PowerTier(sequence: number): number
    if sequence>=Config.TierSequences.Low then return 1 end
    if sequence>=Config.TierSequences.Middle then return 2 end
    return #Config.Tier
end
function Service.Begin(self: any,name: string,position: Vector3,tier: number,priority: number,costs: {[string]:number}?,anchors: {Vector3}?): any
    if not validPosition(position) then self.Dropped+=1;return nil end
    if anchors then
        if #anchors==0 or #anchors>Config.Composition.MaxAnchors then self.Dropped+=1;return nil end
        local visible=false
        for _,anchor in ipairs(anchors) do
            if not validPosition(anchor) then self.Dropped+=1;return nil end
            visible=self:Visible(anchor) or visible
        end
        if not visible then self.Dropped+=1;return nil end
    elseif not self:Visible(position) then self.Dropped+=1;return nil end
    self:_Refresh()
    if not finite(tier) then self.Dropped+=1;return nil end
    local request=costs or Config.DefaultCosts
    if (request.PointLight or 0)>Config.Safety.MaximumLightsPerEffect then self.Dropped+=1;return nil end
    local victims=self.Budget:Plan(request,priority)
    if not victims then self.Dropped+=1;return nil end
    for _,id in ipairs(victims) do
        local victim=self.Active[id]
        if victim then victim:Finish();self.Evicted+=1 end
    end
    self.Serial+=1
    local id=tostring(self.Serial)
    if not self.Budget:Add(id,request,priority) then self.Dropped+=1;return nil end
    local resolvedTier=math.clamp(math.floor(tier),1,#Config.Tier)
    local effect: any=setmetatable({Owner=self,Id=id,Name=name,Position=position,Tier=resolvedTier,
        Scale=Config.Tier[resolvedTier].Scale,Detail=self:Detail(position),Low=self.CurrentProfile.Low,
        ReducedMotion=self.ReducedMotion,Priority=priority,Costs=table.clone(request),Acquired={},Objects={},
        Age=0,Duration=Config.Lifetime.Default,Active=true,Update=nil,OnFinish=nil,Anchors=anchors and table.clone(anchors)},Handle)
    self.Active[id]=effect
    return effect
end
function Service.SetSettings(self: any,reduced: boolean,low: boolean)
    if self.Destroyed then return end
    self.ReducedMotion=reduced;self.LowGraphics=low;self:_Refresh()
end
function Service.Step(self: any,dt: number)
    if self.Destroyed or not finite(dt) or dt<0 then return end
    self:_Refresh()
    local snapshot={}
    for _,effect in pairs(self.Active) do table.insert(snapshot,effect) end
    for _,effect in ipairs(snapshot) do
        if not effect.Active then continue end
        effect.Age+=dt
        if effect.ResolveAnchors then
            local ok=pcall(effect.ResolveAnchors)
            if not ok then self.Errors+=1;effect:Finish() end
            if not effect.Active then continue end
        end
        local duration=if finite(effect.Duration) then math.clamp(effect.Duration,0,Config.Lifetime.Maximum) else Config.Lifetime.Default
        local visible=false
        if effect.Anchors then for _,anchor in ipairs(effect.Anchors) do visible=self:Visible(anchor) or visible end
        else visible=self:Visible(effect.Position) end
        if not visible then effect:Finish();continue end
        local progress=if duration>0 then math.clamp(effect.Age/duration,0,1) else 1
        if effect.Update then
            local ok=pcall(effect.Update,math.min(dt,Config.Lifetime.MaxStep),effect.Age,progress)
            if not ok then self.Errors+=1;effect:Finish() end
        end
        if effect.Age>=duration then effect:Finish() end
    end
end
function Service.Stats(self: any): any
    local stats=self.Budget:Stats()
    local pools={}
    for class,pool in pairs(self.Pools) do pools[class]=#pool end
    return {Active=stats.Count,Reserved=stats.Used,Limits=table.clone(self.Limits),Allocated=table.clone(self.Allocated),
        Pools=pools,MaxEffects=stats.MaxEffects,Evicted=self.Evicted,Dropped=self.Dropped,Errors=self.Errors}
end
function Service.Destroy(self: any)
    if self.Destroyed then return end
    self.Destroyed=true
    local snapshot={}
    for _,effect in pairs(self.Active) do table.insert(snapshot,effect) end
    for _,effect in ipairs(snapshot) do effect:Finish() end
    for _,pool in pairs(self.Pools) do for _,object in ipairs(pool) do object:Destroy() end;table.clear(pool) end
    self.Folder:Destroy()
end
return Service
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom`. Create matching Folder parents.

```lua
--!strict
-- Local preview only, launched by the server-authorized F8 panel in Studio.
-- The stage has no collision/query and sends no remote or gameplay intent.
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local A=require(Shared.AnimConfig)
local V=require(Shared.VfxConfig)
local Data=require(Shared.GameData)
local Kit=require(script.Parent.Parent.UI.Kit)
local Blocks=require(script.Parent.EffectBlocks)
local Probe=require(script.Parent.PerformanceProbe)
local TestRoom={}
function TestRoom.new(parent: Instance,presentation: any,callbacks: any): any
    local self: any=setmetatable({Presentation=presentation,Callbacks=callbacks,Palette=T.TestRoom.DefaultPalette,
        Reduced=false,Low=false,Gray=false,Elapsed=0,Stage=nil,Position=Vector3.zero},{__index=TestRoom})
    self.Probe=Probe.new(presentation.VFX,presentation.Blocks)
    self.Root=Kit.Panel(parent,"VFXTestRoom");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    local title=Kit.Text(self.Root,"VFX TEST ROOM · STUDIO",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(T.TestRoom.Pad,0);title.Size=UDim2.new(1,-T.TestRoom.Header-T.TestRoom.Pad,0,T.TestRoom.Header)
    local close=Kit.Button(self.Root,T.Style.CloseSymbol,function() self:Close() end)
    close.Position=UDim2.new(1,-T.TestRoom.Header,0,0);close.Size=UDim2.fromOffset(T.TestRoom.Header,T.TestRoom.Header)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{BackgroundTransparency=1,BorderSizePixel=0,
        Position=UDim2.fromOffset(T.TestRoom.Pad,T.TestRoom.Header),Size=UDim2.new(1,-T.TestRoom.Pad*2,1,-T.TestRoom.Header-T.TestRoom.StatusHeight),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromOffset(0,0),ScrollBarThickness=T.Style.Stroke})
    Kit.New("UIListLayout",self.Scroll,{Padding=UDim.new(0,T.TestRoom.Gap),SortOrder=Enum.SortOrder.LayoutOrder})
    local order=0
    local function row(text: string,action: ()->())
        order+=1
        local button=Kit.Button(self.Scroll,text,action)
        button.Size=UDim2.new(1,-T.TestRoom.Gap,0,T.TestRoom.Row);button.LayoutOrder=order
        return button
    end
    row("Run bounded stress · "..T.QA.Duration.." s + "..T.QA.Drain.." s drain",function()
        if not self.Stage then self:StageAtCamera() end
        self.Probe:Start(self.Position,self.Palette)
    end)
    row("Cancel stress run",function() self.Probe:Cancel() end)
    self.PaletteButton=row("Palette: "..self.Palette,function()
        self.Palette=if self.Palette=="Seer" then "Marauder" elseif self.Palette=="Marauder" then "Apprentice" else "Seer"
        self.PaletteButton.Text="Palette: "..self.Palette
    end)
    row("Recenter local preview stage",function() self:StageAtCamera() end)
    self.ReducedButton=row("Reduced motion: off",function()
        self.Reduced=not self.Reduced;callbacks.ReducedMotion(self.Reduced)
        self.ReducedButton.Text="Reduced motion: "..(if self.Reduced then "on" else "off")
    end)
    self.LowButton=row("Low graphics: off",function()
        self.Low=not self.Low;callbacks.LowGraphics(self.Low)
        self.LowButton.Text="Low graphics: "..(if self.Low then "on" else "off")
    end)
    self.GrayButton=row("Silhouette view: color",function()
        self.Gray=not self.Gray
        if self.Gray and not self.GrayEffect then
            self.GrayEffect=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesSilhouettePreview",Saturation=T.Visuals.GrayscaleSaturation})
        elseif self.GrayEffect then self.GrayEffect:Destroy();self.GrayEffect=nil end
        self.GrayButton.Text="Silhouette view: "..(if self.Gray then "grayscale" else "color")
    end)
    local function abilityPreview(id: string,variant: string,cancel: boolean?,mode: string?)
        if not self.Stage then self:StageAtCamera() end
        local camera=workspace.CurrentCamera
        if not camera then return end
        local origin=self.Position
        local destination=origin+camera.CFrame.RightVector*T.TestRoom.AbilityOffset
        local target=self.Dummy
        if id=="Apprentice_9" then target=self.PreviewDoor end
        if mode=="HiddenOrigin" then origin=camera.CFrame.Position-camera.CFrame.LookVector*T.TestRoom.PreviewDistance
        elseif mode=="DistantArrival" then destination=camera.CFrame.Position+camera.CFrame.LookVector*(V.Quality.MaximumDistance+T.TestRoom.PreviewBeyond) end
        if mode=="SubstituteTriggered" or mode=="GraftReflected" or mode=="PayloadTriggered" then
            presentation:PreviewTrigger(id,mode,origin,destination,target)
        else presentation:PreviewAbility(id,variant,origin,destination,target,cancel) end
    end
    local catalog={}
    for id in pairs(Data.Abilities) do table.insert(catalog,id) end
    local pathwayOrder={Seer=1,Marauder=2,Apprentice=3}
    table.sort(catalog,function(left: string,right: string)
        local a,b=Data.Abilities[left],Data.Abilities[right]
        if a.PathwayId~=b.PathwayId then return pathwayOrder[a.PathwayId]<pathwayOrder[b.PathwayId] end
        return if a.UnlockSequence==b.UnlockSequence then left<right else a.UnlockSequence>b.UnlockSequence
    end)
    local selected=1
    local picker: any
    local function updatePicker()
        local ability=Data.Abilities[catalog[selected]]
        picker.Text="Preview "..selected.."/"..#catalog.." · "..ability.PathwayId.." "..ability.UnlockSequence.." · "..ability.Name
    end
    picker=row("",function() abilityPreview(catalog[selected],"Confirmed") end)
    picker.TextSize=T.Type.Small;picker.TextWrapped=true;updatePicker()
    row("Next ability →",function() selected=selected%#catalog+1;updatePicker() end)
    row("← Previous ability",function() selected=(selected-2)%#catalog+1;updatePicker() end)
    row("Cancel selected windup",function() abilityPreview(catalog[selected],"Confirmed",true) end)
    row("Paper substitute · confirmed trigger",function() abilityPreview("Seer_7_Secondary","Confirmed",false,"SubstituteTriggered") end)
    row("Graft · confirmed reflection",function() abilityPreview("Seer_1","Confirmed",false,"GraftReflected") end)
    row("Payload · confirmed trigger",function() abilityPreview("Marauder_2_Secondary","Confirmed",false,"PayloadTriggered") end)
    for _,id in ipairs(V.Ability.Pilots) do
        row("Ability · "..Data.Abilities[id].Name,function() abilityPreview(id,if id=="Marauder_9" then "Taken" elseif id=="Marauder_6" then "Captured" else "Confirmed") end)
    end
    row("Ability Theft · release stored power",function() abilityPreview("Marauder_6","Released") end)
    row("Cancel windup · no release",function() abilityPreview("Seer_9_Secondary","Confirmed",true) end)
    row("Travel · origin behind camera",function() abilityPreview("Apprentice_5","Confirmed",false,"HiddenOrigin") end)
    row("Travel · arrival beyond 120 studs",function() abilityPreview("Apprentice_5","Confirmed",false,"DistantArrival") end)
    for _,id in ipairs({"Seer_1","Marauder_1","Apprentice_1"}) do
        row("Tier 3 package · "..Data.Abilities[id].PathwayId.." tier 3",function() abilityPreview(id,"Confirmed") end)
    end
    local primitiveNames=table.clone(Blocks.Names)
    for _,name in ipairs(Blocks.AbilityNames) do table.insert(primitiveNames,name) end
    for _,name in ipairs(primitiveNames) do
        for tier=1,#require(Shared.VfxConfig).Tier do
            row(name.." · Tier "..tier,function()
                if not self.Stage then self:StageAtCamera() end
                local grounded=name=="RingBurst" or name=="GroundRune" or name=="ShockwaveRing" or name=="DoorFrame"
                local origin=if grounded then self.Position+Vector3.new(0,T.TestRoom.FloorOffset,0) else self.Position
                local frame=CFrame.new(origin)
                local camera=workspace.CurrentCamera
                if camera and name~="RingBurst" and name~="GroundRune" and name~="ShockwaveRing" then
                    local direction=Vector3.new(camera.CFrame.Position.X-origin.X,0,camera.CFrame.Position.Z-origin.Z)
                    if direction.Magnitude>T.TestRoom.OrientationEpsilon then frame=CFrame.lookAt(origin,origin+direction) end
                end
                presentation.Blocks:Play(name,origin,self.Palette,tier,{Frame=frame,EndPosition=self.Position+Vector3.new(T.TestRoom.TargetOffset,0,0),Target=self.Dummy})
            end)
        end
    end
    local names={}
    for name in pairs(A.Entries) do table.insert(names,name) end;table.sort(names)
    for _,name in ipairs(names) do row("Animation · "..name,function() presentation:DemoAnimation(name) end) end
    row("Stop animation preview",function() presentation:StopDemoAnimation() end)
    row("Camera · small hit",function() presentation.Camera:Kick(1);presentation.Camera:HitStop() end)
    row("Camera · major cast",function() presentation.Camera:Kick(#require(Shared.VfxConfig).Tier) end)
    row("Confirmed hit preview",function()
        if not self.Dummy then self:StageAtCamera() end
        presentation.Hits:Hit({Target=self.Dummy,Position=self.Position})
        callbacks.Damage({Owner=game:GetService("Players").LocalPlayer.UserId,Position=self.Position,Amount=T.TestRoom.PreviewDamage})
    end)
    row("Death dissolve preview",function()
        if not self.Dummy then self:StageAtCamera() end
        presentation.Hits:Death(self.Dummy,self.Position)
    end)
    self.Status=Kit.Text(self.Root,"",T.Type.Micro,T.Fonts.Number)
    self.Status.Position=UDim2.new(0,T.TestRoom.Pad,1,-T.TestRoom.StatusHeight)
    self.Status.Size=UDim2.new(1,-T.TestRoom.Pad*2,0,T.TestRoom.StatusHeight)
    return self
end
function TestRoom.StageAtCamera(self: any)
    if self.Stage then self.Stage:Destroy();self.Stage=nil;self.Dummy=nil end
    local camera=workspace.CurrentCamera
    if not camera then return end
    local center=camera.CFrame.Position+camera.CFrame.LookVector*T.TestRoom.PreviewDistance+Vector3.new(0,T.TestRoom.PreviewHeight,0)
    self.Position=center
    self.Stage=Kit.New("Folder",workspace,{Name="LocalVfxPreviewStage"})
    local size=T.TestRoom.FloorSize
    Kit.New("Part",self.Stage,{Name="PreviewFloor",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(size[1],size[2],size[3]),Position=center+Vector3.new(0,T.TestRoom.FloorOffset,0),
        Color=T.Colors.Ink,Transparency=T.TestRoom.FloorAlpha,CastShadow=false})
    self.Dummy=Kit.New("Model",self.Stage,{Name="Local preview mannequin"})
    local body=Kit.New("Part",self.Dummy,{Name="Torso",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(size[4],size[5],size[6]),Position=center,Color=T.Colors.Slate,CastShadow=false})
    self.Dummy.PrimaryPart=body
    local doorSize=T.TestRoom.PreviewDoorSize
    local doorCenter=center+camera.CFrame.RightVector*T.TestRoom.AbilityOffset+Vector3.yAxis*(T.TestRoom.FloorOffset+doorSize[2]/2)
    local toward=Vector3.new(camera.CFrame.Position.X-doorCenter.X,0,camera.CFrame.Position.Z-doorCenter.Z)
    local doorFrame=if toward.Magnitude>T.TestRoom.OrientationEpsilon then CFrame.lookAt(doorCenter,doorCenter+toward) else CFrame.new(doorCenter)
    self.PreviewDoor=Kit.New("Part",self.Stage,{Name="LocalPreviewDoor",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(doorSize[1],doorSize[2],doorSize[3]),CFrame=doorFrame,Color=T.Colors.Slate,Transparency=T.TestRoom.FloorAlpha,CastShadow=false})
    Kit.New("Part",self.Dummy,{Name="Head",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.one*T.TestRoom.HeadSize,Position=center+Vector3.new(0,T.TestRoom.HeadHeight,0),Color=T.Colors.Muted,CastShadow=false})
    Kit.New("Humanoid",self.Dummy,{RequiresNeck=false,DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None})
end
function TestRoom.Resize(self: any,width: number,height: number)
    self.Root.Size=UDim2.fromOffset(math.min(T.TestRoom.Width,width-T.TestRoom.Margin*2),math.min(T.TestRoom.Height,height-T.TestRoom.Margin*2))
    self.Root.Position=UDim2.new(1,-T.TestRoom.Margin,0,T.TestRoom.Margin);self.Root.AnchorPoint=Vector2.new(1,0)
end
function TestRoom.Toggle(self: any,allowed: boolean)
    if not allowed or not RunService:IsStudio() then self:Close();return end
    if self.Root.Visible then self:Close();return end
    self.Root.Visible=true;self:StageAtCamera();self.Callbacks.Modal(true)
end
function TestRoom.Close(self: any)
    self.Probe:Cancel()
    self.Root.Visible=false
    if self.Stage then self.Stage:Destroy();self.Stage=nil;self.Dummy=nil end
    if self.GrayEffect then self.GrayEffect:Destroy();self.GrayEffect=nil end
    self.Gray=false;self.GrayButton.Text="Silhouette view: color"
    self.Presentation:StopDemoAnimation();self.Callbacks.Modal(false)
end
function TestRoom.Step(self: any,dt: number)
    if not self.Root.Visible then return end
    self.Probe:Step(dt)
    self.Elapsed+=dt
    if self.Elapsed<T.TestRoom.StatInterval then return end;self.Elapsed=0
    local stats=self.Presentation.VFX:Stats()
    local profile=self.Presentation.VFX:Profile()
    local allocated=0;local reserved=0
    for _,count in pairs(stats.Allocated) do allocated+=count end
    for _,count in pairs(stats.Reserved) do reserved+=count end
    self.Status.Text="Active "..stats.Active.." / "..profile.MaxEffects.." · dropped "..stats.Dropped.." · evicted "..stats.Evicted.."\n"..
        (if profile.Mobile then "Mobile" else "Desktop").." · quality "..profile.Level.." · detail "..string.format("%.2f",profile.Detail)..
        "\nInstances "..allocated.." allocated · "..reserved.." reserved · errors "..stats.Errors..(if self.Probe.Running then " · stress running" elseif self.Probe.Last then " · p95 "..string.format("%.1fms",self.Probe.Last.P95Ms) else "")
end
return TestRoom
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/WorldPresentation.lua

**ModuleScript** at `StarterPlayer/StarterPlayerScripts/Visuals/WorldPresentation`. Create matching Folder parents.

```lua
--!strict
-- Local lighting/labels/ambience. All landmarks are tagged by the server.
local Collection=game:GetService("CollectionService")
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Layout=require(Shared.VisualLayout)
local Kit=require(script.Parent.Parent.UI.Kit)
local WorldView={}
function WorldView.new(root: GuiObject,presentation: any,callbacks: any): any
    local self: any=setmetatable({Root=root,Presentation=presentation,Callbacks=callbacks,Labels={},Elapsed=0,AmbientAt=0,
        Lamps={},Zones={},Objects={},LastZone="",Exited={},Reduced=false,Low=false,ZoneSerial=0,NextScan=0},{__index=WorldView})
    self.Compass=Kit.Text(root,"Sanctuary Square",T.Type.Small,T.Fonts.Number);self.Compass.TextXAlignment=Enum.TextXAlignment.Center
    self.Compass.BackgroundColor3=T.Colors.Ink;self.Compass.BackgroundTransparency=0
    self.Title=Kit.New("CanvasGroup",root,{Name="ZoneTitle",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false,ZIndex=T.Layers.Feedback})
    Kit.Corner(self.Title);Kit.Stroke(self.Title)
    self.TitleText=Kit.Text(self.Title,"",T.Type.Heading,T.Fonts.Title);self.TitleText.Size=UDim2.fromScale(1,1);self.TitleText.TextXAlignment=Enum.TextXAlignment.Center
    for i=1,T.World.Labels.Max do
        local label=Kit.Text(root,"",T.World.Labels.TextSize,T.Fonts.Number)
        label.Name="WorldLabel"..i;label.Size=UDim2.fromOffset(T.World.Labels.Width,T.World.Labels.Height)
        label.BackgroundColor3=T.Colors.Ink;label.BackgroundTransparency=0;label.Visible=false;label.TextXAlignment=Enum.TextXAlignment.Center
        Kit.Corner(label);self.Labels[i]=label
    end
    local old=Lighting:FindFirstChild("MysteriesWorldGrade");if old then old:Destroy() end
    self.Grade=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesWorldGrade"})
    for key,value in pairs(T.World.Correction) do self.Grade[key]=value end
    self:Scan()
    return self
end
function WorldView.Scan(self: any)
    self.Lamps=Collection:GetTagged("MysteriesLamp");self.Zones=Collection:GetTagged("MysteriesZone");self.Objects=Collection:GetTagged("MysteriesInteractable")
end
function WorldView.Resize(self: any,layout: any)
    self.Layout=layout;Kit.Rect(self.Compass,layout.Wordmark)
    local width=math.min(T.World.Zone.TitleWidth,layout.Width-layout.Profile.Margin*2)
    local top=math.max(T.World.Zone.TitleTop,layout.Resources.Y+layout.Resources.H+T.World.Labels.Pad)
    local height=math.min(T.World.Zone.TitleHeight,math.max(0,layout.Hotbar.Y-top-T.World.Labels.Pad))
    Kit.Rect(self.Title,{X=(layout.Width-width)/2,Y=top,W=width,H=height})
    self.TitleText.TextSize=layout.Profile.HeadingSize
end
function WorldView.SetSettings(self: any,reduced: boolean,low: boolean)
    self.Reduced=reduced;self.Low=low
    local bloom=Lighting:FindFirstChild("MysteriesBloom")
    if bloom and bloom:IsA("BloomEffect") then bloom.Enabled=not low end
end
function WorldView.Enter(self: any,zone: any,now: number)
    local name=if zone then zone:GetAttribute("VisualName") else "Outskirts"
    if type(name)~="string" then return end
    if name==self.LastZone then return end
    if self.LastZone~="" then self.Exited[self.LastZone]=now end
    self.LastZone=name
    local tier=zone and zone:GetAttribute("Sequence")
    local tint=if type(tier)=="number" then (if tier<=4 then T.World.Zone.HighTint else T.World.Zone.LowTint) else T.World.Zone.HubTint
    local color=T.World.Zone.HubTint:Lerp(tint,T.World.Zone.Blend)
    if self.Reduced then self.Grade.TintColor=color else Kit.Tween(self.Grade,T.World.Zone.Transition,{TintColor=color}) end
    if now-(self.Exited[name] or -math.huge)<T.World.Zone.Repeat then return end
    self.ZoneSerial+=1;local serial=self.ZoneSerial
    self.TitleText.Text=name..(if type(tier)=="number" then " · Sequence "..tier else "")
    self.Title.GroupTransparency=if self.Reduced then 0 else 1;self.Title.Visible=true
    if not self.Reduced then Kit.Tween(self.Title,T.World.Zone.Enter,{GroupTransparency=0}) end
    task.delay(T.World.Zone.Enter+T.World.Zone.Hold,function()
        if serial~=self.ZoneSerial then return end
        if self.Reduced then self.Title.Visible=false;return end
        local tween=Kit.Tween(self.Title,T.World.Zone.Leave,{GroupTransparency=1})
        tween.Completed:Once(function() if serial==self.ZoneSerial then self.Title.Visible=false end end)
    end)
end
function WorldView.ClearRay(self: any,from: Vector3,to: Vector3,target: Instance): boolean
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    local ignore: {Instance}={self.Presentation.VFX.Folder}
    if Players.LocalPlayer.Character then table.insert(ignore,Players.LocalPlayer.Character) end
    params.FilterDescendantsInstances=ignore
    local hit=workspace:Raycast(from,to-from,params)
    return not hit or hit.Instance==target or hit.Instance:IsDescendantOf(target)
end
function WorldView.ProjectLabels(self: any,camera: Camera,root: BasePart)
    for _,label in ipairs(self.Labels) do label.Visible=false end
    if not self.Layout or self.Callbacks.Modal() then return end
    local cfg=T.World.Labels;local accepted={};local candidates={}
    for _,object in ipairs(self.Objects) do
        if object:IsA("BasePart") and object.Parent then
            local distance=(root.Position-object.Position).Magnitude
            if distance<=cfg.Distance then table.insert(candidates,{Part=object,Distance=distance}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local count=0;local origin=self.Root.AbsolutePosition
    local exclusions={self.Layout.Resources,self.Layout.Hotbar,self.Layout.Journal,self.Layout.Action}
    for _,gui in ipairs(self.Callbacks.Exclusions()) do
        if gui.Visible then
            local p=gui.AbsolutePosition-origin;local size=gui.AbsoluteSize
            table.insert(exclusions,{X=p.X,Y=p.Y,W=size.X,H=size.Y})
        end
    end
    for _,item in ipairs(candidates) do
        if count>=cfg.Max then break end
        local object=item.Part
        local prompt=self.Callbacks.Prompt()
        if prompt and prompt.Parent==object then continue end
        local at=object.Position+Vector3.yAxis*cfg.Offset
        local point,visible=camera:WorldToViewportPoint(at)
        if not visible or not self:ClearRay(camera.CFrame.Position,object.Position,object) then continue end
        for _,offset in ipairs(cfg.Slots) do
            local r={X=point.X-origin.X-cfg.Width/2,Y=point.Y-origin.Y+offset,W=cfg.Width,H=cfg.Height}
            if r.X<0 or r.Y<0 or r.X+r.W>self.Layout.Width or r.Y+r.H>self.Layout.Height then continue end
            local blocked=false
            for _,other in ipairs(exclusions) do if Layout.Intersects(r,other,cfg.Pad) then blocked=true;break end end
            for _,other in ipairs(accepted) do if Layout.Intersects(r,other,cfg.Pad) then blocked=true;break end end
            if blocked then continue end
            count+=1;local label=self.Labels[count]
            label.Text=object:GetAttribute("VisualName") or object.Name
            local fade=math.clamp((item.Distance-cfg.Full)/(cfg.Distance-cfg.Full),0,1)
            label.TextTransparency=fade;label.BackgroundTransparency=fade;Kit.Rect(label,r);label.Visible=true
            table.insert(accepted,r);break
        end
    end
end
function WorldView.Step(self: any,dt: number)
    self.Elapsed+=dt;if self.Elapsed<T.World.Lamp.Tick then return end;self.Elapsed=0
    local bloom=Lighting:FindFirstChild("MysteriesBloom")
    if bloom and bloom:IsA("BloomEffect") then bloom.Enabled=not self.Low end
    local now=os.clock();if now>=self.NextScan then self:Scan();self.NextScan=now+T.World.Scan end
    local camera=workspace.CurrentCamera
    local character=Players.LocalPlayer.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if not camera or not root or not root:IsA("BasePart") then
        for _,label in ipairs(self.Labels) do label.Visible=false end
        for _,lamp in ipairs(self.Lamps) do local light=lamp:FindFirstChild("Gaslight");if light and light:IsA("PointLight") then light.Enabled=false end end
        return
    end
    local zone=nil;local closest=math.huge
    for _,object in ipairs(self.Zones) do
        if object:IsA("BasePart") then
            local distance=(root.Position-object.Position).Magnitude
            if distance<(object:GetAttribute("Radius") or 0) and distance<closest then closest=distance;zone=object end
        end
    end
    self:Enter(zone,now)
    local look=camera.CFrame.LookVector
    local heading=math.floor((math.deg(math.atan2(-look.X,-look.Z))+360)%360)
    self.Compass.Text=heading.."° · "..self.LastZone
    self.Compass.Visible=not self.Callbacks.Modal() and not self.Title.Visible
    if self.Callbacks.Title then self.Callbacks.Title(self.Title.Visible) end
    self:ProjectLabels(camera,root)
    local lamps={}
    for _,lamp in ipairs(self.Lamps) do
        if lamp:IsA("BasePart") and lamp.Parent then
            local light=lamp:FindFirstChild("Gaslight")
            if light and light:IsA("PointLight") then
                light.Enabled=false
                local distance=(camera.CFrame.Position-lamp.Position).Magnitude
                if distance<=T.World.Lamp.MaxDistance and self.Presentation.VFX:Visible(lamp.Position) then table.insert(lamps,{Part=lamp,Light=light,Distance=distance}) end
            end
        end
    end
    table.sort(lamps,function(a,b) return a.Distance<b.Distance end)
    local profile=self.Presentation.VFX:Profile()
    local limit=if self.Low or profile.Mobile or profile.Low then T.World.Lamp.LowMax else T.World.Lamp.DesktopMax
    for i=1,math.min(limit,#lamps) do
        local light=lamps[i].Light;light.Enabled=true;light.Shadows=false
        light.Brightness=T.World.Lamp.Brightness*(if self.Reduced then 1 else 1+math.sin(now/T.World.Lamp.Period+lamps[i].Part.Position.X)*T.World.Lamp.Flicker)
    end
    if now>=self.AmbientAt then
        self.AmbientAt=now+T.World.Ambient.Interval
        if not self.Low and not profile.Low and not self.Reduced then
            local count=if profile.Mobile then T.World.Ambient.MobileMax else T.World.Ambient.DesktopMax
            for i=1,math.min(count,#lamps) do
                local at=lamps[i].Part.Position
                self.Presentation.Blocks:Compose({{Name="RisingMotes",Position=at,Palette="Seer",Options={Scale=T.World.Ambient.Scale,Tint=T.Colors.Warm}}},1,T.World.Ambient.Priority,T.World.Ambient.Life)
            end
        end
    end
end
function WorldView.Destroy(self: any)
    self.ZoneSerial+=1;self.Grade:Destroy();self.Title:Destroy();self.Compass:Destroy()
    for _,label in ipairs(self.Labels) do label:Destroy() end
    for _,lamp in ipairs(self.Lamps) do local light=lamp:FindFirstChild("Gaslight");if light and light:IsA("PointLight") then light.Enabled=false end end
end
return WorldView
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
