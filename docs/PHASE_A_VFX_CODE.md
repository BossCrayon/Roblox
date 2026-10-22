# Phase A — full animation and VFX framework code

The 17 scripts below are supplied in full. Install with Play stopped. Create matching Folder parents and replace the existing same-name scripts. Keep the unchanged foundation modules; do not run duplicate Mysteries or Bootstrap entrypoints. Theme is listed first. The ready-to-open place is `studio/Mysteries.rbxlx`.

This is Phase A only. The test room previews reusable building blocks; pathway-specific ability choreography starts in Phase B. Animation, texture and sound slots are empty/0 until original assets are supplied.

| File name | Class | Exact Explorer path |
|---|---|---|
| `src/ReplicatedStorage/Shared/Theme.lua` | ModuleScript | `ReplicatedStorage/Shared/Theme` |
| `src/ReplicatedStorage/Shared/AnimConfig.lua` | ModuleScript | `ReplicatedStorage/Shared/AnimConfig` |
| `src/ReplicatedStorage/Shared/VfxConfig.lua` | ModuleScript | `ReplicatedStorage/Shared/VfxConfig` |
| `src/ReplicatedStorage/Shared/VisualBudget.lua` | ModuleScript | `ReplicatedStorage/Shared/VisualBudget` |
| `src/ServerScriptService/Services/WorldService.lua` | ModuleScript | `ServerScriptService/Services/WorldService` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/AnimationController.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/AnimationController` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/VfxService.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/VfxService` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Feedback` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Menus` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Developer` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Presentation` |
| `src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua` | LocalScript | `StarterPlayer/StarterPlayerScripts/Mysteries` |

## src/ReplicatedStorage/Shared/Theme.lua

**Class:** ModuleScript

**Explorer path:** `ReplicatedStorage/Shared/Theme`

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
    CameraFeel={SmallStuds=0.10,MajorStuds=0.22,SmallDegrees=0.25,MajorDegrees=0.55,
        SmallDuration=0.12,MajorDuration=0.22,FovKick=1.8,MaxFovKick=2.5,FovMin=1,FovMax=120,
        Frequency=11,HitStop=0.045,MaxHitStop=0.06,StepCap=0.05,Epsilon=0.00001,DefaultTier=1,MajorTier=3,
        BeforePriorityOffset=-1,AfterPriorityOffset=1,KickGap=0.10,
        ShakeAxis={X=1,Y=0.6,Z=0.35},RotationAxis={X=0.5,Y=1,Z=0.4},
        FrequencyRatio={X=1,Y=0.83,Z=1.17},Phase={X=0,Y=1.7,Z=3.2}},
    Visuals={FlashGap=0.34,FlashOpacity=0.16,MaxDistance=120,LegacyPriority=1,
        LegacyLife=0.5,LegacyStart=1,LegacyEnd=7,LegacyAlpha=0.25,RevealPriority=3,
        GrayscaleSaturation=-1,AnimationViewDistance=120},
    TestRoom={Width=420,Height=540,Margin=12,Header=48,Row=44,Gap=8,Pad=12,StatusHeight=54,
        PreviewDistance=14,PreviewHeight=-2,PreviewSpacing=8,TargetOffset=8,
        FloorSize={32,0.15,26,2,3,1},HeadSize=1.5,HeadHeight=2.2,FloorAlpha=0.25,FloorOffset=-3,ButtonColumns=3,
        DefaultTier=1,DefaultPalette="Seer",StatInterval=0.25,PreviewDamage=24,OrientationEpsilon=0.01},
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


## src/ReplicatedStorage/Shared/AnimConfig.lua

**Class:** ModuleScript

**Explorer path:** `ReplicatedStorage/Shared/AnimConfig`

```lua
--!strict
-- Original, asset-free animation library. Optional uploaded assets override each entry.
-- Degrees and studs below describe rendered joints only; no root physics are changed.
local freeze=require(script.Parent.Freeze)
type Pose={[string]: CFrame}
local function frame(y: number,pitch: number,yaw: number,roll: number): CFrame
    return CFrame.new(0,y,0)*CFrame.Angles(math.rad(pitch),math.rad(yaw),math.rad(roll))
end
local function still(entry: any,_time: number,_speed: number): Pose
    local result: Pose={}
    for role,value in pairs(entry.Pose) do result[role]=frame(value[1],value[2],value[3],value[4]) end
    return result
end
local function breathe(entry: any,time: number,_speed: number): Pose
    local wave=math.sin(time*math.pi*2/entry.Period)
    return {Root=frame(wave*entry.Rise,0,0,0),Neck=frame(0,wave*entry.Nod,0,0)}
end
local function locomotion(entry: any,time: number,speed: number): Pose
    local wave=math.sin(time*math.pi*2/entry.Period)
    return {Root=frame(0,entry.Lean*speed,0,wave*entry.Sway*speed),Neck=frame(0,-entry.Lean*entry.CounterLean*speed,0,0)}
end
local function roll(entry: any,time: number,_speed: number): Pose
    local progress=math.clamp(time/entry.Duration,0,1)
    -- A compact torso tuck, rather than a root-part rotation or a movement grant.
    local arc=math.sin(progress*math.pi)
    return {Root=frame(-entry.Tuck*arc,entry.Pitch*arc,0,entry.Roll*arc),
        LeftShoulder=frame(0,entry.ArmPitch*arc,0,0),RightShoulder=frame(0,entry.ArmPitch*arc,0,0)}
end
return freeze({
    Spring={Frequency=8,MaxStep=0.1},
    Blend={Default=0.12,MinFade=0.016,MaxFade=2,WeightEpsilon=0.001,MaxWeight=1,ReducedScale=0.3},
    Locomotion={MinSpeed=0.1,RunSpeed=18,SpeedReference=16,MaxSpeedRatio=1.5,LandingVelocity=-3},
    Safety={MaxPause=0.08,MaxFrameDelta=0.1,AssetLoadGrace=1.5,MaxAssetSpeed=2,MinAssetSpeed=0.1},
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
            Duration=0.3,FadeIn=0.06,FadeOut=0.12,Pose={Root={0.04,-6,0,0},Neck={0,4,0,0},LeftShoulder={0,-12,0,-5},RightShoulder={0,-12,0,5}}},
        Land={AnimationId="",Procedural=still,Priority=3,AssetPriority=Enum.AnimationPriority.Action,Loop=false,
            Duration=0.22,FadeIn=0.045,FadeOut=0.14,Pose={Root={-0.14,9,0,0},Neck={0,-5,0,0},LeftShoulder={0,10,0,-7},RightShoulder={0,10,0,7}}},
        CastWindup={AnimationId="",Procedural=still,Priority=4,AssetPriority=Enum.AnimationPriority.Action2,Loop=true,
            Duration=0.38,FadeIn=0.12,FadeOut=0.08,Pose={Root={0,-4,-7,0},Waist={0,0,-4,0},Neck={0,2,7,0},LeftShoulder={0,-28,-12,-18},RightShoulder={0,-45,8,18}}},
        CastRelease={AnimationId="",Procedural=still,Priority=5,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.3,FadeIn=0.05,FadeOut=0.17,Pose={Root={0,6,6,0},Waist={0,0,4,0},Neck={0,-3,-6,0},LeftShoulder={0,-48,-12,-14},RightShoulder={0,-72,12,14}}},
        HitReact={AnimationId="",Procedural=still,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.24,FadeIn=0.04,FadeOut=0.15,Pose={Root={0,-9,0,-4},Neck={0,5,0,3},LeftShoulder={0,-9,0,-5},RightShoulder={0,-9,0,5}}},
        Dodge={AnimationId="",Procedural=roll,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.36,FadeIn=0.05,FadeOut=0.09,Tuck=0.15,Pitch=18,Roll=16,ArmPitch=-22},
        Roll={AnimationId="",Procedural=roll,Priority=6,AssetPriority=Enum.AnimationPriority.Action3,Loop=false,
            Duration=0.48,FadeIn=0.05,FadeOut=0.12,Tuck=0.24,Pitch=62,Roll=0,ArmPitch=-50},
        Death={AnimationId="",Procedural=still,Priority=8,AssetPriority=Enum.AnimationPriority.Action4,Loop=true,
            Duration=0.8,FadeIn=0.4,FadeOut=0.25,Pose={Root={-0.24,28,0,16},Neck={0,18,0,0},LeftShoulder={0,12,0,-12},RightShoulder={0,12,0,12}}},
        Victory={AnimationId="",Procedural=still,Priority=7,AssetPriority=Enum.AnimationPriority.Action4,Loop=false,
            Duration=1.4,FadeIn=0.25,FadeOut=0.3,Pose={Root={0.03,-3,0,0},Neck={0,-4,0,0},LeftShoulder={0,-100,0,-24},RightShoulder={0,-100,0,24}}},
    },
})
```


## src/ReplicatedStorage/Shared/VfxConfig.lua

**Class:** ModuleScript

**Explorer path:** `ReplicatedStorage/Shared/VfxConfig`

```lua
--!strict
-- Original procedural visuals. Empty texture/sound IDs need no uploaded assets.
local freeze=require(script.Parent.Freeze)
local T=require(script.Parent.Theme)
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
    },
})
```


## src/ReplicatedStorage/Shared/VisualBudget.lua

**Class:** ModuleScript

**Explorer path:** `ReplicatedStorage/Shared/VisualBudget`

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


## src/ServerScriptService/Services/WorldService.lua

**Class:** ModuleScript

**Explorer path:** `ServerScriptService/Services/WorldService`

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


## src/StarterPlayer/StarterPlayerScripts/Visuals/AnimationController.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/AnimationController`

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
    Track: AnimationTrack?,Animation: Animation?,AssetAge: number,AssetFailed: boolean}
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
function AnimationController.Play(self: Controller,name: string,weight: number?,fade: number?): boolean
    if self.Destroyed then return false end
    name=resolve(name)
    local entry=C.Entries[name]
    if not entry then return false end
    local target=if weight and finite(weight) then math.clamp(weight,0,C.Blend.MaxWeight) else C.Blend.MaxWeight
    local transition=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else entry.FadeIn
    local state: EntryState?=self.States[name]
    if not state then
        local created: EntryState={Name=name,Entry=entry,Elapsed=0,Target=target,Fade=transition,Spring=Spring.new(0),
            Track=nil,Animation=nil,AssetAge=0,AssetFailed=false}
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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel`

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
    local envelope=remaining*remaining
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


## src/StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks`

```lua
--!strict
-- Original, texture-free silhouettes. Optional particles supplement, never replace, geometry.
local C: any=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Blocks={}
Blocks.Names={"RingBurst","RisingMotes","ThreadBeam","DoorFrame","StarBurst","GlitchFlicker","GroundRune","ImpactFlash","ScreenEdgePulse","ShockwaveRing","AfterimageTrail"}
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
local function reserve(name: string,c: any,detail: number,low: boolean): (any,number,number)
    local segments=math.max(C.Blocks.Common.MinSegments,math.floor(C.Blocks.Common.Segments*detail))
    local n=0
    if name=="RingBurst" or name=="ShockwaveRing" then n=segments
    elseif name=="GroundRune" then n=segments+(if low then 0 else c.Spokes)
    elseif name=="DoorFrame" then n=(if low then 1 else c.Nested)*3
    elseif name=="StarBurst" then n=c.Points*2
    elseif name=="GlitchFlicker" then n=4
    elseif name=="ImpactFlash" then n=2
    elseif name=="ThreadBeam" then n=1 end
    local motes=if name=="RisingMotes" then math.max(1,math.floor(c.Count*detail)) else 0
    local trail=if name=="AfterimageTrail" and not low then 1 else 0
    local afterHead=if name=="AfterimageTrail" then 1 else 0
    local host=if name=="ScreenEdgePulse" then 0 else 1
    local emitter=if name=="RisingMotes" and C.Particle.Texture~="" then 1 else 0
    return {Part=host+motes+afterHead,Attachment=n*2+trail*2,Beam=n,Trail=trail,ParticleEmitter=emitter},segments,motes
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
    local detail=self.Service:Detail(position)
    local low=detail<=C.Quality.Low
    local costs,segments,motes=reserve(name,c,detail,low)
    local h=self.Service:Begin(name,position,tier or 1,c.Priority,costs)
    if not h then return nil end
    if pulse then self.LastPulse=now end
    h.Duration=c.Duration
    local p=C.Palettes[paletteName or "Seer"] or C.Palettes.Seer
    local scale=h.Scale
    local common=C.Blocks.Common
    local width=common.Width*scale
    local host: any=nil
    if costs.Part>0 then
        host=take(h,"Part",nil)
        host.Size=Vector3.one*common.HostSize
        host.CFrame=if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position)
    end
    local update: (number,number,number)->() = function() end
    if name=="RingBurst" or name=="ShockwaveRing" or name=="GroundRune" then
        local lines={}
        for _=1,segments do table.insert(lines,segment(h,host,width,p.Accent)) end
        local spokes={}
        if name=="GroundRune" and not low then
            for _=1,c.Spokes do table.insert(spokes,segment(h,host,width,p.Primary)) end
        end
        update=function(_dt: number,age: number,t: number)
            local radius=c.Radius*scale
            if name~="GroundRune" then radius*=c.Start+(1-c.Start)*t end
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
                setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,direction*radius+Vector3.yAxis*common.HeightOffset,fade)
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
                local rise=if h.ReducedMotion then c.Height*(i/motes) else t*c.Height
                part.CFrame=host.CFrame*CFrame.new(math.cos(a)*c.Radius*scale,rise*scale,math.sin(a)*c.Radius*scale)
                part.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            end
        end
    elseif name=="ThreadBeam" then
        local line=segment(h,host,c.Width*scale,p.Accent)
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
        local arch=Vector3.yAxis*c.Height*scale
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
        line.Beam.Segments=c.Segments;line.Beam.Width1=c.Width*scale*c.Taper
        update=function(_dt: number,age: number,_t: number)
            line.Beam.Transparency=NumberSequence.new(common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart))
        end
    elseif name=="DoorFrame" then
        local layers=if low then 1 else c.Nested
        local lines={}
        for _=1,layers*3 do table.insert(lines,segment(h,host,width,p.Primary)) end
        update=function(_dt: number,age: number,_t: number)
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i=1,layers do
                local half=(c.Width/2-(i-1)*c.Inset)*scale
                local base=c.Base*scale
                local top=(c.Height-(i-1)*c.Inset)*scale
                local offset=(i-1)*3
                setLine(lines[offset+1],point(-half,base,0),point(-half,top,0),fade)
                setLine(lines[offset+2],point(-half,top,0),point(half,top,0),fade)
                setLine(lines[offset+3],point(half,top,0),point(half,base,0),fade)
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
            head.CFrame=host.CFrame*CFrame.new((if h.ReducedMotion then 0 else t*c.Length)*scale,c.Height*scale/2,0)
            head.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            if trail then trail.Enabled=not h.ReducedMotion end
        end
    end
    h.Update=update
    update(0,0,0)
    return h
end
return Blocks
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation`

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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring`

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


## src/StarterPlayer/StarterPlayerScripts/Visuals/VfxService.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/VfxService`

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
    table.clear(self.Objects);self.Update=nil;self.OnFinish=nil
end
Handle.Stop=Handle.Finish
function Service.new(options: any?): any
    local settings=options or {}
    local folder=Instance.new("Folder");folder.Name="LocalVisualFramework";folder.Parent=workspace
    local mobile=if settings.Mobile~=nil then settings.Mobile else UserInputService.TouchEnabled
    local limits=if mobile then Config.Pools.Mobile else Config.Pools.Desktop
    local self: any=setmetatable({Folder=folder,Camera=settings.Camera,Mobile=mobile,
        LowGraphics=settings.LowGraphics==true,ReducedMotion=settings.ReducedMotion==true,
        Pools={},Allocated={},Limits=limits,Active={},Serial=0,Evicted=0,Dropped=0,Errors=0,Destroyed=false,ProfileKey=""},Service)
    for class in pairs(limits) do self.Pools[class]={};self.Allocated[class]=0 end
    self:_Refresh()
    return self
end
function Service._Refresh(self: any)
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
function Service.Begin(self: any,name: string,position: Vector3,tier: number,priority: number,costs: {[string]:number}?): any
    if not self:Visible(position) then self.Dropped+=1;return nil end
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
        Age=0,Duration=Config.Lifetime.Default,Active=true,Update=nil,OnFinish=nil},Handle)
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
        local duration=if finite(effect.Duration) then math.clamp(effect.Duration,0,Config.Lifetime.Maximum) else Config.Lifetime.Default
        if not self:Visible(effect.Position) then effect:Finish();continue end
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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom`

```lua
--!strict
-- Local preview only, launched by the server-authorized F8 panel in Studio.
-- The stage has no collision/query and sends no remote or gameplay intent.
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local A=require(Shared.AnimConfig)
local Kit=require(script.Parent.Parent.UI.Kit)
local Blocks=require(script.Parent.EffectBlocks)
local TestRoom={}
function TestRoom.new(parent: Instance,presentation: any,callbacks: any): any
    local self: any=setmetatable({Presentation=presentation,Callbacks=callbacks,Palette=T.TestRoom.DefaultPalette,
        Reduced=false,Low=false,Gray=false,Elapsed=0,Stage=nil,Position=Vector3.zero},{__index=TestRoom})
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
    for _,name in ipairs(Blocks.Names) do
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
    self.Root.Visible=false
    if self.Stage then self.Stage:Destroy();self.Stage=nil;self.Dummy=nil end
    if self.GrayEffect then self.GrayEffect:Destroy();self.GrayEffect=nil end
    self.Gray=false;self.GrayButton.Text="Silhouette view: color"
    self.Presentation:StopDemoAnimation();self.Callbacks.Modal(false)
end
function TestRoom.Step(self: any,dt: number)
    if not self.Root.Visible then return end
    self.Elapsed+=dt
    if self.Elapsed<T.TestRoom.StatInterval then return end;self.Elapsed=0
    local stats=self.Presentation.VFX:Stats()
    local profile=self.Presentation.VFX:Profile()
    local allocated=0;local reserved=0
    for _,count in pairs(stats.Allocated) do allocated+=count end
    for _,count in pairs(stats.Reserved) do reserved+=count end
    self.Status.Text="Active "..stats.Active.." / "..profile.MaxEffects.." · dropped "..stats.Dropped.." · evicted "..stats.Evicted.."\n"..
        (if profile.Mobile then "Mobile" else "Desktop").." · quality "..profile.Level.." · detail "..string.format("%.2f",profile.Detail)..
        "\nInstances "..allocated.." allocated · "..reserved.." reserved · errors "..stats.Errors
end
return TestRoom
```


## src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/UI/Feedback`

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
            number.Label.Visible=visible and (number.Position-camera.CFrame.Position).Magnitude<=T.Visuals.MaxDistance
            number.Label.Position=UDim2.fromOffset(p.X-origin.X+(number.Index%3-1)*T.Feedback.DamageStagger,p.Y-origin.Y-T.Layout.Damage.Rise*math.min(1,elapsed/T.Timing.DamageRise))
            local alpha=math.clamp((elapsed-T.Timing.DamageRise)/math.max(T.LegacyFX.MinBarFraction,T.Timing.DamageLife-T.Timing.DamageRise),0,1)
            number.Label.TextTransparency=alpha;number.Label.BackgroundTransparency=alpha
        end
    end
end
return Feedback
```


## src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/UI/Menus`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/UI/Developer`

```lua
--!strict
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Kit)
local Developer={}
function Developer.new(parent: Instance,send: any,testRoom: (() -> ())?): any
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
    if testRoom then
        self.TestButton=Kit.Button(self.Scroll,"Studio VFX test room",function()
            if self.Allowed then testRoom() end
        end)
        self.TestButton.Position=UDim2.fromOffset(T.Layout.Developer.Pad,T.Layout.Developer.Row*5+T.Layout.Developer.Gap*3)
        self.TestButton.Size=UDim2.new(1,-T.Layout.Developer.Pad*2,0,T.Layout.Developer.Row)
        self.Scroll.CanvasSize=UDim2.fromOffset(0,T.Layout.Developer.Row*6+T.Layout.Developer.Gap*4)
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


## src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/UI/Presentation`

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
local Presentation={}
function Presentation.new(gui: Instance,data: any,callbacks: any?): any
    local cb=callbacks or {}
    local self: any=setmetatable({GUI=gui,Data=data,Callbacks=cb,SoundCount=0,Controllers={},Reduced=false,Low=false,
        State=nil,Cast=nil,ScanElapsed=0,Demo=false},{__index=Presentation})
    self.VFX=VfxService.new()
    self.Blocks=Blocks.new(self.VFX,{ScreenEdgePulse=function(_color: Color3,_duration: number)
        if not self.Reduced and cb.ScreenEdgePulse then cb.ScreenEdgePulse() end
    end})
    self.Camera=CameraFeel.new()
    self.Hits=HitPresentation.new(self.VFX,self.Blocks)
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
    if not state.Ready then return end
    local controller=self:LocalController()
    if controller and not self.Demo then
        if state.Casting and state.Casting~=self.Cast then controller:Play("CastWindup")
        elseif not state.Casting and self.Cast then controller:Stop("CastWindup") end
        if previous and previous.Ready and state.Health<previous.Health then
            controller:Play("HitReact");self.Camera:Kick(1);self.Camera:HitStop()
        end
    end
    self.Cast=state.Casting or nil
end
function Presentation.Event(self: any,event: any)
    if not self.VFX:Visible(event.Position) then return end
    if event.Kind=="Damage" then
        self.Hits:Hit(event)
        if self.Callbacks.Damage then self.Callbacks.Damage(event) end
        if event.Owner==Players.LocalPlayer.UserId then self.Camera:Kick(1);self.Camera:HitStop() end
        return
    end
    if event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch);return end
    local ability=self.Data.Abilities[event.Kind]
    if ability then self:Audio(ability.SFXHook) end
    if event.Owner then
        local caster=Players:GetPlayerByUserId(event.Owner)
        local controller=caster and self:Controller(caster.Character)
        if controller and (ability or event.Kind=="Melee") then
            controller:Stop("CastWindup");controller:Play("CastRelease")
        end
    end
    if event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        local h=self.VFX:Begin("Reveal",event.Position,1,T.Visuals.RevealPriority,{Highlight=1})
        if not h then return end
        h.Duration=C.Hit.RevealLife
        local highlight=h:Acquire("Highlight")
        highlight.Adornee=event.Target;highlight.FillColor=T.Colors.Sanity;highlight.OutlineColor=T.Colors.Fog
        highlight.FillTransparency=T.LegacyFX.HighlightAlpha
    elseif event.Kind~="Whisper" then
        -- Preserve the old neutral pulse during Phase A. Pathway-specific layering
        -- is deliberately deferred until the user continues to Phases B-D.
        local h=self.VFX:Begin("LegacyPulse",event.Position,1,T.Visuals.LegacyPriority,{Part=1})
        if not h then return end
        h.Duration=T.Visuals.LegacyLife
        local p=h:Acquire("Part")
        p.Shape=Enum.PartType.Ball;p.Color=if ability then Kit.PathColor(ability.PathwayId) else T.Colors.Fog
        p.Position=event.Position;p.Size=Vector3.one*T.Visuals.LegacyStart;p.Transparency=T.Visuals.LegacyAlpha
        h.Update=function(_dt: number,_age: number,t: number)
            p.Size=Vector3.one*(T.Visuals.LegacyStart+(T.Visuals.LegacyEnd-T.Visuals.LegacyStart)*t)
            p.Transparency=T.Visuals.LegacyAlpha+(1-T.Visuals.LegacyAlpha)*t
        end
    end
end
function Presentation.Step(self: any,dt: number)
    self.VFX:Step(dt);self.ScanElapsed+=dt
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
function Presentation.StopDemoAnimation(self: any)
    if not self.Demo then return end
    self.Demo=false
    local controller=self:LocalController()
    if controller then controller:Stop();controller.AutoState=nil;controller.AutoLocomotion=true end
end
function Presentation.Destroy(self: any)
    self.Camera:Destroy();self.VFX:Destroy()
    for _,controller in pairs(self.Controllers) do controller:Destroy() end
    table.clear(self.Controllers)
end
return Presentation
```


## src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua

**Class:** LocalScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Mysteries`

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
local menus: any=nil
local hud: any=nil
local presentation: any=nil
local testRoom: any=nil
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
    if roomModal then return end
    if menus.Root.Visible and menus.Tab==tab and menus.View=="Page" then menus:Close() else menus:Open(tab) end
end})
local function updateModal()
    modal=menuModal or roomModal;promptUI:SetModal(modal);hud.Tooltip.Visible=false
end
local function visualSettings(reduced: boolean,low: boolean)
    feedback:SetReducedMotion(reduced)
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
presentation=Presentation.new(gui,data,{Damage=function(event: any) feedback:Damage(event) end,
    ScreenEdgePulse=function() feedback:Flash() end})
local developer: any=nil
testRoom=VfxTestRoom.new(safeRoot,presentation,{Modal=function(open: boolean) roomModal=open;updateModal() end,
    ReducedMotion=function(reduced: boolean) menus.ReducedMotion=reduced;visualSettings(reduced,menus.LowGraphics) end,
    LowGraphics=function(low: boolean) menus.LowGraphics=low;visualSettings(menus.ReducedMotion,low) end,
    Damage=function(event: any) feedback:Damage(event) end})
developer=Developer.new(safeRoot,send,if RunService:IsStudio() then function()
    if menus.Root.Visible then menus:Close() end
    testRoom:Toggle(developer.Allowed);developer.Root.Visible=false
end else nil)
promptUI.OnVisibility=function(visible: boolean)
    hud.Pathway.Visible=not visible and not cinematic;hud.Wordmark.Visible=not visible and not cinematic
end
promptUI.Exclusions={hud.Pathway,hud.Cast,feedback.Notice,feedback.Advance,developer.Root}
local function resize()
    local size=safeRoot.AbsoluteSize
    if size.X<=0 or size.Y<=0 then return end
    local layout=Layout.Resolve(T,size.X,size.Y,UserInputService.TouchEnabled)
    hud:Resize(layout);menus:Resize(layout);feedback:Resize(layout);developer:Resize(layout);promptUI.Layout=layout
    testRoom:Resize(size.X,size.Y)
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
    presentation:Update(update)
    if not developer.Allowed and testRoom.Root.Visible then testRoom:Close() end
    if update.Dead and menus.Root.Visible then menus:Close() end
end)
effectEvent.OnClientEvent:Connect(function(event: any)
    if type(event)~="table" or typeof(event.Position)~="Vector3" or type(event.Kind)~="string" then return end
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
    -- E belongs to an active prompt, preventing a simultaneous slot-2 cast.
    if promptUI.Current and input.KeyCode==promptUI.Current.KeyboardKeyCode then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then melee();return end
    for i,key in ipairs(T.Input.Keys) do if input.KeyCode==key then cast(i);return end end
end)
local accumulator=0
RunService.Heartbeat:Connect(function(dt: number)
    presentation:Step(dt);testRoom:Step(dt)
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
script.Destroying:Connect(function() testRoom:Close();presentation:Destroy() end)
```


---

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
