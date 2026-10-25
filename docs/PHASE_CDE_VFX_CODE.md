# Phases C–E — full copy-ready code

[EXISTING] These 29 complete scripts include new modules, changed integrations and reused framework dependencies. Apply to the existing Mysteries foundation with Play stopped; replace matching scripts and create Folder parents. For a blank place use docs/FULL_SOURCE.md. The built studio/Mysteries.rbxlx already contains everything.

[EXISTING] All 54 abilities have explicit procedural compositions and cast-pose profiles, retaining the twelve-state framework and eleven original primitives. This historical export includes later integration updates; install docs/PHASE_FI_VISUALS_CODE.md for the complete current F–I code. Studio rendering and engine/device performance remain unverified. [NEEDS NEW ASSET] Optional original uploaded audio/animation polish; every supplied slot remains 0/empty.

| File | Class | Exact Explorer path |
|---|---|---|
| `src/ReplicatedStorage/Shared/Theme.lua` | ModuleScript | `ReplicatedStorage/Shared/Theme` |
| `src/ReplicatedStorage/Shared/AnimConfig.lua` | ModuleScript | `ReplicatedStorage/Shared/AnimConfig` |
| `src/ReplicatedStorage/Shared/VfxConfig.lua` | ModuleScript | `ReplicatedStorage/Shared/VfxConfig` |
| `src/ReplicatedStorage/Shared/VisualBudget.lua` | ModuleScript | `ReplicatedStorage/Shared/VisualBudget` |
| `src/ServerScriptService/Bootstrap.server.lua` | Script | `ServerScriptService/Bootstrap` |
| `src/ServerScriptService/Services/WorldService.lua` | ModuleScript | `ServerScriptService/Services/WorldService` |
| `src/ServerScriptService/Services/EffectService.lua` | ModuleScript | `ServerScriptService/Services/EffectService` |
| `src/ServerScriptService/Services/VisualEventService.lua` | ModuleScript | `ServerScriptService/Services/VisualEventService` |
| `src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua` | LocalScript | `StarterPlayer/StarterPlayerScripts/Mysteries` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Hud` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Menus` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Presentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/AnimationController.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/AnimationController` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/CameraFeel` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/Choreography.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/Choreography` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/EffectBlocks` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/EnemyPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/EnemyPresentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/HitPresentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/MotionSpring` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/StatusPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/StatusPresentation` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/VfxService.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/VfxService` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/VfxTestRoom` |
| `src/StarterPlayer/StarterPlayerScripts/Visuals/WorldPresentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/Visuals/WorldPresentation` |

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
        Stone=rgb("68615D"),Wood=rgb("42342D"),Iron=rgb("2B3037"),Mist=rgb("8B96A4"),Hit=rgb("E17986"),Warm=rgb("FFD39A"),ClearTint=rgb("FFFFFF"),MadnessTint=rgb("F0B4C3"),LostTint=rgb("AA82B4")},
    Skins={
        Seer={Accent=rgb("C6A56B"),Backing=rgb("25202F"),Glyph="Thread",Name="Veiled cards",Rotation=-5},
        Marauder={Accent=rgb("B88A5A"),Backing=rgb("191B22"),Glyph="Split",Name="Split ledger",Rotation=7},
        Apprentice={Accent=rgb("C6D0D9"),Backing=rgb("172A30"),Glyph="Door",Name="Threshold folio",Rotation=0},
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
        CapeExtra=0.5,CapeDepth=0.2,CollarSeal={0.45,0.12,0.18},BodyScaleMin=0.8,BodyScaleMax=1.5,CoatClearance=0.1},
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
    CameraFeel={SmallStuds=0.10,MajorStuds=0.22,SmallDegrees=0.25,MajorDegrees=0.55,
        SmallDuration=0.12,MajorDuration=0.22,FovKick=1.8,MaxFovKick=2.5,FovMin=1,FovMax=120,
        Frequency=11,HitStop=0.045,MaxHitStop=0.06,StepCap=0.05,Epsilon=0.00001,DefaultTier=1,MajorTier=3,
        BeforePriorityOffset=-1,AfterPriorityOffset=1,KickGap=0.10,
        ShakeAxis={X=1,Y=0.6,Z=0.35},RotationAxis={X=0.5,Y=1,Z=0.4},
        FrequencyRatio={X=1,Y=0.83,Z=1.17},Phase={X=0,Y=1.7,Z=3.2}},
    Visuals={FlashGap=0.34,FlashOpacity=0.16,MaxDistance=120,LegacyPriority=1,
        LegacyLife=0.5,LegacyStart=1,LegacyEnd=7,LegacyAlpha=0.25,RevealPriority=3,
        GrayscaleSaturation=-1,AnimationViewDistance=120},
    AbilityUI={StoredSize=14,StoredPad=3,StoredSymbol="◆",StoredPrefix="Stored: ",CastGrace=1,PowerNames={ArcBolt="Arc Bolt"}},
    StatusUI={Width=160,Height=28,TextSize=13,Max=4,MobileMax=2,Distance=40,OffsetStuds=3.8,BackgroundAlpha=0.1,
        Priorities={Controlled=100,Threaded=95,Parasite=90,Payload=85,Stasis=80,Grafted=75,Substitute=70},RequiredThreads=3},
    TestRoom={Width=420,Height=540,Margin=12,Header=48,Row=44,Gap=8,Pad=12,StatusHeight=54,
        PreviewDistance=14,PreviewHeight=-2,PreviewSpacing=8,TargetOffset=8,
        FloorSize={32,0.15,26,2,3,1},HeadSize=1.5,HeadHeight=2.2,FloorAlpha=0.25,FloorOffset=-3,ButtonColumns=3,
        DefaultTier=1,DefaultPalette="Seer",StatInterval=0.25,PreviewDamage=24,OrientationEpsilon=0.01,
        AbilityOffset=-7,PreviewBeyond=10,PreviewDoorSize={7,9,0.3}},
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
local T=require(script.Parent.Theme)
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
local config={
    Spring={Frequency=8,MaxStep=0.1},
    Blend={Default=0.12,MinFade=0.016,MaxFade=2,WeightEpsilon=0.001,MaxWeight=1,ReducedScale=0.3},
    Locomotion={MinSpeed=0.1,RunSpeed=18,SpeedReference=16,MaxSpeedRatio=1.5,LandingVelocity=-3},
    Safety={MaxPause=0.08,MaxFrameDelta=0.1,AssetLoadGrace=1.5,MaxAssetSpeed=2,MinAssetSpeed=0.1},
    CastProfiles={
        Potion={CastRelease={AnimationId="",Duration=T.Ritual.DrinkTime,Pose={Root={0,-3,0,0},Neck={0,-10,0,0},RightShoulder={0,-112,0,12},LeftShoulder={0,-16,0,-8}}}},
        Pickpocket={CastWindup={AnimationId="",Pose={Root={0,4,9,-3},RightShoulder={0,-48,-8,12}}},
            CastRelease={AnimationId="",Duration=0.16,Pose={Root={0,-2,-6,0},RightShoulder={0,-24,-16,6}}}},
        Travel={CastWindup={AnimationId="",Pose={Root={0,0,0,0},LeftShoulder={0,-52,-8,-16},RightShoulder={0,-52,8,16}}},
            CastRelease={AnimationId="",Duration=0.20,Pose={Root={0,2,0,0},LeftShoulder={0,-65,-8,-26},RightShoulder={0,-65,8,26}}}},
        Reading={CastWindup={AnimationId="",Pose={Root={0,0,0,0},Neck={0,-3,0,0},LeftShoulder={0,-20,0,-12},RightShoulder={0,-72,0,14}}},
            CastRelease={AnimationId="",Duration=0.18,Pose={Neck={0,-2,0,0},RightShoulder={0,-55,0,20}}}},
        Flame={CastWindup={AnimationId="",Pose={Root={0,-4,-12,0},LeftShoulder={0,-22,0,-8},RightShoulder={0,-40,10,20}}},
            CastRelease={AnimationId="",Duration=0.18,Pose={Root={0,5,9,0},RightShoulder={0,-68,0,30}}}},
        Theft={CastWindup={AnimationId="",Pose={Root={0,4,9,-3},Neck={0,0,-5,0},RightShoulder={0,-48,-8,12}}},
            CastRelease={AnimationId="",Duration=0.22,Pose={Root={0,-2,-6,0},RightShoulder={0,-24,-16,6},LeftShoulder={0,-8,0,-4}}}},
        Threshold={CastWindup={AnimationId="",Pose={Root={0,0,0,0},LeftShoulder={0,-52,-8,-16},RightShoulder={0,-52,8,16}}},
            CastRelease={AnimationId="",Duration=0.25,Pose={Root={0,2,0,0},LeftShoulder={0,-65,-8,-26},RightShoulder={0,-65,8,26}}}},
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
}
-- The twelve animation states remain intact. Ability profiles select original
-- joint poses and optional asset slots without changing authoritative cast time.
local poses={
    Divination={{0,0,0,0},{0,-25,0,-14},{0,-25,0,14}},
    Acrobat={{-0.08,10,-10,-5},{0,-18,0,-12},{0,-30,0,20}},
    Composure={{0,-2,0,0},{0,-10,0,-6},{0,-10,0,6}},
    Paper={{0,2,0,0},{0,-42,-10,-12},{0,-42,10,12}},
    Veil={{0,0,-5,0},{0,-14,0,-8},{0,-75,10,12}},
    Voice={{0,0,5,0},{0,-10,0,-6},{0,-54,0,8}},
    Puppet={{0,-3,-4,0},{0,-58,-8,-24},{0,-58,8,24}},
    Exchange={{0,-2,10,0},{0,-44,-20,-25},{0,-62,20,25}},
    Illusion={{0,-3,-8,0},{0,-65,0,-30},{0,-38,10,18}},
    History={{0,-5,0,0},{0,-52,-16,-26},{0,-52,16,26}},
    Recovery={{0,-4,0,0},{0,-40,-14,-10},{0,-40,14,10}},
    Miracle={{0,-5,0,0},{0,-55,-15,-28},{0,-55,15,28}},
    Graft={{0,0,8,0},{0,-66,-15,-22},{0,-34,15,22}},
    Domain={{0,-4,0,0},{0,-72,-12,-32},{0,-72,12,32}},
    Stealth={{-0.04,6,8,-3},{0,-10,0,-5},{0,-18,0,8}},
    Deceit={{0,0,-9,0},{0,-20,-12,-8},{0,-48,18,22}},
    Decipher={{0,4,0,0},{0,-48,-8,-12},{0,-48,8,12}},
    Thought={{0,-2,7,0},{0,-18,0,-8},{0,-67,-12,10}},
    Parasite={{0,5,5,0},{0,-22,0,-8},{0,-58,12,10}},
    Destiny={{0,-2,-12,0},{0,-25,-10,-8},{0,-68,20,20}},
    Time={{0,-2,0,0},{0,-35,-15,-10},{0,-70,15,16}},
    Trick={{0,3,-8,0},{0,-18,-10,-8},{0,-48,12,20}},
    Astrology={{0,-6,0,0},{0,-50,-14,-18},{0,-50,14,18}},
    Record={{0,0,7,0},{0,-58,-8,-14},{0,-44,12,14}},
    Release={{0,3,0,0},{0,-40,-8,-18},{0,-74,8,20}},
    Conceal={{0,-3,0,0},{0,-48,-16,-10},{0,-48,16,10}},
    Seal={{0,2,0,0},{0,-62,-16,-32},{0,-62,16,32}},
    Replica={{0,-3,0,0},{0,-64,-8,-20},{0,-64,8,20}},
    Gate={{0,-4,0,0},{0,-72,-15,-30},{0,-72,15,30}},
    Closure={{0,4,0,0},{0,-60,16,-12},{0,-60,-16,12}},
}
local families: {[string]: {{string}}}={
    Seer={{"Divination","Reading"},{"Acrobat","Composure"},{"Flame","Paper"},{"Veil","Voice"},{"Puppet","Puppet"},
        {"Exchange","Illusion"},{"History","Recovery"},{"Miracle","Recovery"},{"Graft","Domain"}},
    Marauder={{"Pickpocket","Stealth"},{"Deceit","Deceit"},{"Decipher","Reading"},{"Theft","Theft"},{"Thought","Thought"},
        {"Parasite","Parasite"},{"Deceit","Puppet"},{"Destiny","Destiny"},{"Time","Time"}},
    Apprentice={{"Threshold","Reading"},{"Trick","Trick"},{"Astrology","Seal"},{"Record","Release"},{"Travel","Gate"},
        {"Conceal","Seal"},{"Travel","Conceal"},{"Replica","Gate"},{"Gate","Closure"}},
}
local release: {[string]: {{number}}}={
    Seer={{0.22,0.18},{0.20,0.25},{0.18,0.24},{0.30,0.20},{0.25,0.18},{0.18,0.32},{0.35,0.30},{0.35,0.35},{0.25,0.40}},
    Marauder={{0.16,0.20},{0.20,0.18},{0.25,0.22},{0.22,0.25},{0.20,0.25},{0.25,0.30},{0.25,0.30},{0.20,0.22},{0.25,0.35}},
    Apprentice={{0.25,0.20},{0.16,0.25},{0.28,0.22},{0.30,0.20},{0.20,0.30},{0.35,0.30},{0.25,0.30},{0.30,0.30},{0.40,0.30}},
}
local legacy={Seer_9_Secondary="Reading",Seer_7="Flame",Marauder_9="Pickpocket",Marauder_6="Theft",Apprentice_9="Threshold",Apprentice_5="Travel"}
config.AbilityProfiles={};config.AbilityTimings={}
for pathway,rows in pairs(families) do
    for index,row in ipairs(rows) do
        local sequence=10-index
        for choice,family in ipairs(row) do
            local id=pathway.."_"..sequence..(if choice==2 then "_Secondary" else "")
            local profile=legacy[id] or id
            local source=config.CastProfiles[family]
            if not source then
                local pose=poses[family]
                source={CastWindup={AnimationId="",Pose={Root=pose[1],LeftShoulder=pose[2],RightShoulder=pose[3]}},
                    CastRelease={AnimationId="",Pose={Root=pose[1],LeftShoulder=pose[2],RightShoulder=pose[3]}}}
            end
            local wind=table.clone(source.CastWindup)
            local cast=table.clone(source.CastRelease)
            cast.Duration=release[pathway][index][choice]
            config.CastProfiles[profile]={CastWindup=wind,CastRelease=cast}
            config.AbilityProfiles[id]=profile
            config.AbilityTimings[id]={Windup=if sequence<=4 then 1.5 else 0.5,Release=cast.Duration,Family=family}
        end
    end
end
return freeze(config)
```


## src/ReplicatedStorage/Shared/VfxConfig.lua

**Class:** ModuleScript

**Explorer path:** `ReplicatedStorage/Shared/VfxConfig`

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
            Vision="Spirit sight",CipherSight="Cipher sight",Substitute="Substitute armed",Composed="Composed",Shielded="Shielded",Invulnerable="Evading"}},
    Composition={MaxLayers=6,MaxAnchors=12,MobileDetail=0.35,Priority=3,WindupPriority=2,ResultLife=0.85,CancelFade=0.12,MinWidth=0.04,MobileMinWidth=0.06},
    Ability={GroundOffset=-2.8,HandHeight=0.5,ReadHeight=1.8,DefaultScale=0.38,
        WindupScale=0.24,EyeScale=1,ReadGroundDetail=0.35,TransferScale=0.3,DoorScale=1,
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
        WindupGlyphs={Divination="Book",Acrobat="Seal",Composure="Seal",Paper="Seal",Veil="Eye",Voice="Seal",Puppet="Thread",Exchange="Thread",
            Illusion="Eye",History="Book",Recovery="Eye",Miracle="Star",Graft="Thread",Domain="Seal",Stealth="Split",Deceit="Split",Decipher="Book",
            Thought="Eye",Parasite="Split",Destiny="Cut",Time="Clock",Trick="Star",Astrology="Star",Record="Book",Release="Book",Conceal="Door",Seal="Door",
            Replica="Book",Gate="Star",Closure="Key"},
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
        SigilStencil={Duration=0.85,Priority=3,Size=1.5,Paths={Eye=T.Glyphs.Eye,Split=T.Glyphs.Split,Door=T.Glyphs.Door,
            Book=T.Glyphs.Book,Star=T.Glyphs.Star,Thread=T.Glyphs.Thread,Seal=T.Glyphs.Seal,
            Key={{{0.4,0.12},{0.6,0.12},{0.7,0.25},{0.6,0.4},{0.4,0.4},{0.3,0.25},{0.4,0.12}},{{0.5,0.4},{0.5,0.9},{0.7,0.9}},{{0.5,0.72},{0.65,0.72}}},
            Clock={{{0.5,0.08},{0.5,0.2}},{{0.9,0.5},{0.78,0.5}},{{0.5,0.92},{0.5,0.8}},{{0.1,0.5},{0.22,0.5}},{{0.5,0.5},{0.5,0.3}},{{0.5,0.5},{0.68,0.6}}},
            Cut={{{0.25,0.85},{0.7,0.15}},{{0.4,0.85},{0.85,0.15}}},
            EyeLow={{{0,0.5},{0.5,0.2},{1,0.5},{0.5,0.8},{0,0.5}}},
            DoorLow={{{0.24,0.9},{0.24,0.15},{0.76,0.15},{0.76,0.9}}}}},
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


## src/ServerScriptService/Bootstrap.server.lua

**Class:** Script

**Explorer path:** `ServerScriptService/Bootstrap`

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
    local character=player.Character
    if character then
        character:SetAttribute("MysteriesPathway",p.PathwayId or "")
        character:SetAttribute("MysteriesSequence",p.Sequence or 9)
        character:SetAttribute("MysteriesDisguised",s.Statuses.Disguised~=nil)
    end
    stateEvent:FireClient(player,{Ready=true,Developer=isDeveloper(player),
        DeveloperInfo=if isDeveloper(player) then {SessionOnly=sessionOnly,Mode=s.Mode,Ready=s.Ready} else nil,PathwayId=p.PathwayId,Sequence=p.Sequence,
        Digestion=p.Digestion,ActingProgress=p.ActingProgress,Health=s.Health,MaxHealth=s.Stats.Health,
        Spirituality=s.Spirituality,MaxSpirituality=s.Stats.Spirituality,Sanity=s.Sanity,Mode=s.Mode,
        Gold=p.Gold,WishCredits=p.WishCredits,Inventory=Domain.Copy(p.Inventory),Loadout=Domain.Copy(p.AbilityLoadout),
        Cooldowns=cooldowns,Statuses=statuses,Dead=s.Dead,RecordedCharges=s.RecordedPower and s.RecordedPower.Charges or 0,RecordedPowerId=s.RecordedPower and s.RecordedPower.Id or false,StolenPower=s.StolenPower or false,
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


## src/ServerScriptService/Services/EffectService.lua

**Class:** ModuleScript

**Explorer path:** `ServerScriptService/Services/EffectService`

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

**Class:** ModuleScript

**Explorer path:** `ServerScriptService/Services/VisualEventService`

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
local feedback=Feedback.new(safeRoot,data,function(active: boolean)
    cinematic=active
    if hud then hud.Wordmark.Visible=not active and not promptUI.Root.Visible;hud.Pathway.Visible=not active and not zoneTitle and not promptUI.Root.Visible end
end)
hud=Hud.new(safeRoot,data,{Cast=cast,Melee=melee,Touch=UserInputService.TouchEnabled,TouchAim=touchAim,ReducedMotion=function() return menus and menus.ReducedMotion end,Journal=function(tab: string)
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
    -- E belongs to an active prompt, preventing a simultaneous slot-2 cast.
    if promptUI.Current and input.KeyCode==promptUI.Current.KeyboardKeyCode then return end
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


## src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/UI/Hud`

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
        local stored=Kit.Text(face,T.AbilityUI.StoredSymbol,T.Type.Small,T.Fonts.Number)
        stored.Name="StoredPower";stored.TextColor3=T.Colors.Bronze;stored.Visible=false;stored.TextXAlignment=Enum.TextXAlignment.Center
        stored.Size=UDim2.fromOffset(T.AbilityUI.StoredSize,T.AbilityUI.StoredSize)
        stored.Position=UDim2.new(1,-T.AbilityUI.StoredSize-T.AbilityUI.StoredPad,0,T.AbilityUI.StoredPad)
        local recorded=Kit.Text(face,"",T.Type.Small,T.Fonts.Number)
        recorded.Name="RecordedCharges";recorded.TextColor3=T.Colors.Teal;recorded.Visible=false
        recorded.Size=stored.Size;recorded.Position=stored.Position;recorded.TextXAlignment=Enum.TextXAlignment.Center
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
                self.TooltipText.Text=a.Name.." · "..tostring(a.SpiritualityCost).." spirituality"
                if a.Id=="Marauder_6" and self.State.StolenPower then self.TooltipText.Text..=" · "..T.AbilityUI.StoredPrefix..(T.AbilityUI.PowerNames[self.State.StolenPower] or self.State.StolenPower) end
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
    if self.SkinPath~=state.PathwayId then
        self.SkinPath=state.PathwayId
        Kit.Skin(self.Pathway,state.PathwayId)
        Kit.Skin(self.Hotbar,state.PathwayId)
        local skin=T.Skins[state.PathwayId] or T.Skins.Seer
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
    for i,slot in ipairs(self.Slots) do
        local id=state.Loadout[i];local a=id and self.Data.Abilities[id]
        slot.Stored.Visible=id=="Marauder_6" and type(state.StolenPower)=="string"
        slot.Recorded.Visible=a~=nil and a.PathwayId=="Apprentice" and (a.Operation.Kind=="Record" or a.Operation.Kind=="Release") and (state.RecordedCharges or 0)>0
        slot.Recorded.Text=tostring(state.RecordedCharges or 0)
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
    Kit.Skin(self.Card,self.State and self.State.PathwayId)
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
        if type(state.RecordedPowerId)=="string" and (state.RecordedCharges or 0)>0 then
            self:TextRow("Recorded: "..(T.AbilityUI.PowerNames[state.RecordedPowerId] or state.RecordedPowerId).." · "..state.RecordedCharges.." uses remaining.")
        end
        if type(state.StolenPower)=="string" then
            self:TextRow(T.AbilityUI.StoredPrefix..(T.AbilityUI.PowerNames[state.StolenPower] or state.StolenPower).." · use Ability Theft again to release it.")
        end
        self:TextRow((T.Skins[state.PathwayId] or T.Skins.Seer).Name.." · The acting method",true)
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
    local keys={tostring(state.PathwayId),tostring(state.Sequence),table.concat(inventory,","),table.concat(loadout,"|"),
        tostring(state.RecordedPowerId),tostring(state.RecordedCharges),tostring(state.StolenPower),tostring(state.Digestion),tostring(state.ActingProgress)}
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
        or event.Kind=="GateSnapshot" or event.Kind=="EchoSnapshot" then self.Abilities:Event(event);return end
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


## src/StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/AbilityPresentation`

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
        local at=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local family=Anim.AbilityTimings[a.Id] and Anim.AbilityTimings[a.Id].Family
        local glyph=C.Ability.WindupGlyphs[family] or (if a.PathwayId=="Seer" then C.Ability.EyeGlyph elseif a.PathwayId=="Marauder" then C.Ability.TheftGlyph else C.Ability.DoorGlyph)
        local lowGlyph=if a.PathwayId=="Seer" then C.Ability.LowEyeGlyph elseif a.PathwayId=="Marauder" then glyph else C.Ability.LowDoorGlyph
        local root=e.Character and (e.Character.PrimaryPart or e.Character:FindFirstChild("HumanoidRootPart"))
        return {layer("SigilStencil",at,{Frame=self:Frame(at),Glyph=glyph,LowGlyph=lowGlyph,Scale=C.Ability.WindupScale,
            Follow=root,Offset=Vector3.yAxis*C.Ability.HandHeight})},
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


## src/StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/CharacterArt`

```lua
--!strict
-- Cosmetic, locally welded clothing. Never writes body colors/scales or Humanoid state.
local Players=game:GetService("Players")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local A=T.CharacterArt
local Outfit={}
function Outfit.new(service: any,blocks: any): any
    return setmetatable({Service=service,Blocks=blocks,Records={},Elapsed=0,AuraAt=0},{__index=Outfit})
end
function Outfit.Clear(self: any,character: Model)
    local record=self.Records[character]
    if record then record.Model:Destroy();self.Records[character]=nil end
end
function Outfit.Build(self: any,character: Model,path: string,sequence: number,torso: BasePart,head: BasePart)
    self:Clear(character)
    local model=Instance.new("Model");model.Name="LocalMysteriesOutfit";model.Parent=character
    local count=0;local cloth=A.Cloth[path];local trim=A.Trim[path]
    local function piece(name: string,base: BasePart,size: {number},offset: CFrame,color: Color3)
        if count>=A.MaxParts then return end;count+=1
        local part=Instance.new("Part");part.Name=name;part.Size=Vector3.new(table.unpack(size));part.CFrame=base.CFrame*offset
        part.Anchored=false;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Massless=true;part.CastShadow=false
        part.Material=Enum.Material.Fabric;part.Color=color;part.Parent=model
        local weld=Instance.new("WeldConstraint");weld.Part0=base;weld.Part1=part;weld.Parent=part
    end
    local bodyScale=math.clamp(torso.Size.X/2,A.BodyScaleMin,A.BodyScaleMax)
    local coat={A.Coat[1]*bodyScale,math.max(A.Coat[2],torso.Size.Y),math.max(A.Coat[3],torso.Size.Z+A.CoatClearance)}
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
    self.Records[character]={Model=model,Path=path,Sequence=sequence,Torso=torso,Head=head}
end
function Outfit.Step(self: any,dt: number)
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
    if aura then self.AuraAt=now+A.AuraInterval end
    for i,item in ipairs(candidates) do
        if i>A.MaxPlayers then break end
        local character=item.Character;local path=character:GetAttribute("MysteriesPathway");local seq=character:GetAttribute("MysteriesSequence")
        local torso=character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso");local head=character:FindFirstChild("Head")
        if not A.Cloth[path] or type(seq)~="number" or character:GetAttribute("MysteriesDisguised")==true
            or not torso or not torso:IsA("BasePart") or not head or not head:IsA("BasePart") then continue end
        wanted[character]=true
        local record=self.Records[character]
        if not record or record.Path~=path or record.Sequence~=seq or record.Torso~=torso or record.Head~=head then self:Build(character,path,seq,torso,head) end
        local profile=self.Service:Profile()
        if aura and seq<=6 and not self.Service.LowGraphics and not self.Service.ReducedMotion and not profile.Low and self.Service:Visible(item.Root.Position) then
            self.Blocks:Compose({{Name=if seq<=3 then "VeilRibbon" else "RisingMotes",Position=torso.Position,Palette=path,Options={Scale=A.AuraScale}}},1,0,A.AuraLife)
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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/Choreography`

```lua
--!strict
-- Shared original composition vocabulary; no targets, statuses or outcomes are decided here.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography={}
function Choreography.Root(target: any): any
    if typeof(target)~="Instance" then return nil end
    if target:IsA("BasePart") then return target end
    if target:IsA("Model") then return target.PrimaryPart or target:FindFirstChild("HumanoidRootPart") end
    return nil
end
function Choreography.Extend(a: any,e: any,c: any): any
    c.Root=Choreography.Root
    c.Self=e.Destination or e.Position
    c.Origin=e.Origin or e.Position
    c.Head=c.Self+Vector3.yAxis*C.Ability.HeadHeight
    c.Chest=c.Self+Vector3.yAxis*C.Ability.ChestHeight
    c.Target=e.Position
    c.Radius=e.Radius or math.max(C.Ability.PreviewRadius,a.RadiusStuds)
    c.Ground=function(at: Vector3?): Vector3
        if at then return at+Vector3.yAxis*C.Blocks.Common.HeightOffset end
        return if a.Target=="Position" then e.Position+Vector3.yAxis*C.Blocks.Common.HeightOffset else c.Self+Vector3.yAxis*C.Ability.GroundOffset
    end
    c.Mark=function(glyph: string,at: Vector3,scale: number?,options: any?): any
        local opts=table.clone(options or {})
        opts.Frame=opts.Frame or c.Frame(at);opts.Glyph=glyph
        opts.LowGlyph=opts.LowGlyph or (if glyph=="Eye" then "EyeLow" elseif glyph=="Door" then "DoorLow" else glyph)
        opts.Scale=scale or C.Ability.Medium
        return c.Layer("SigilStencil",at,opts)
    end
    c.Ring=function(at: Vector3,radius: number?): any
        local opts: any={Scale=if radius then 1 else C.Ability.Medium,Detail=C.Ability.Detail}
        if radius then opts.Radius=radius/C.Tier[e.Tier].Scale end
        return c.Layer("GroundRune",at,opts)
    end
    c.Beam=function(from: Vector3,to: Vector3,tint: Color3?): any
        return c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.ThreadScale,Tint=tint})
    end
    c.Ghost=function(at: Vector3,to: Vector3?): any
        return c.Layer("ContourEcho",at,{Frame=c.Frame(at),Scale=C.Ability.Medium,MoveTo=to})
    end
    c.Veil=function(at: Vector3): any
        return c.Layer("VeilRibbon",at,{Frame=c.Frame(at),Scale=C.Ability.VeilScale})
    end
    c.Door=function(at: Vector3,scale: number?): any
        return c.Layer("DoorFrame",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium})
    end
    return c
end
return Choreography
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
    local motes=if name=="RisingMotes" then math.max(1,math.floor(c.Count*detail)) else 0
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
        update=function(_dt: number,age: number,_t: number)
            local fade=c.Alpha+(1-c.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,line in ipairs(lines) do
                local side=if i%2==0 then 1 else -1
                setLine(line,point(side*c.Offset*scale,-c.Height*scale/2,0),point(side*c.Offset*scale,c.Height*scale/2,0),fade)
                line.Beam.CurveSize0=c.Curve*scale;line.Beam.CurveSize1=-c.Curve*scale
            end
        end
    elseif name=="SigilStencil" then
        local paths=stencil(c,low,opts)
        local lines={}
        for _,path in ipairs(paths) do
            for i=1,#path-1 do table.insert(lines,{Line=segment(h,host,width,p.Accent),A=path[i],B=path[i+1]}) end
        end
        update=function(_dt: number,age: number,_t: number)
            if opts.MoveTo then
                local t=if h.ReducedMotion then 1 else math.clamp(age/c.Duration,0,1)
                host.CFrame=(if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position))+(opts.MoveTo-position)*t
            end
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for _,entry in ipairs(lines) do
                local function vertex(v: any): Vector3 return point((v[1]-0.5)*c.Size*scale,(0.5-v[2])*c.Size*scale,0) end
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
        local line=segment(h,host,math.max(c.Width*scale,opts.MinWidth or 0),p.Accent)
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
        line.Beam.Segments=c.Segments;line.Beam.Width1=math.max(c.Width*scale*c.Taper,opts.MinWidth or 0)
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
    local wrapped=function(dt: number,age: number,t: number)
        if host and opts.MoveTo and name~="SigilStencil" then
            local fraction=if h.ReducedMotion then 1 else t
            host.CFrame=(opts.Frame or CFrame.new(position))+(opts.MoveTo-position)*fraction
        end
        if host and opts.Follow then
            if not opts.Follow.Parent then h:Finish();return end
            host.CFrame=CFrame.new(opts.Follow.Position+(opts.Offset or Vector3.zero))*(if opts.Frame then opts.Frame.Rotation else CFrame.identity)
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
            local visible=self.Service:Visible(group.Anchor)
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
                opts.Lease=child;opts.Detail=math.min(detail,opts.Detail or math.huge);opts.Duration=duration
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
                group.Child.Update(dt,age,math.clamp(age/duration,0,1))
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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/EnemyPresentation`

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


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Apprentice`

```lua
--!strict
-- Original threshold/recording language. No visual creates a dimension, wall or gameplay gate.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Apprentice={}
function Apprentice.Build(a: any,e: any,c: any): (any,number?)
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
        if typeof(target)~="Instance" or not target:IsA("BasePart") or not target.Parent then return {c.Mark("Key",e.Position)},C.Ability.Life end
        local at=target.Position-Vector3.yAxis*(target.Size.Y/2)
        return {c.Layer("DoorFrame",at,{Frame=CFrame.new(at)*target.CFrame.Rotation,Scale=1/C.Tier[e.Tier].Scale,
            Width=target.Size.X+C.Ability.DoorMargin,Height=target.Size.Y+C.Ability.DoorMargin}),
            c.Mark("Key",target.Position,C.Ability.Small)},C.Composition.ResultLife
    elseif id=="Apprentice_9_Secondary" then
        return {c.Mark("Key",c.Chest,C.Ability.Medium),c.Mark("Star",c.Head,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_8" then
        return {c.Mark("Star",c.Target,C.Ability.Small),c.Beam(c.Chest,c.Target)},C.Ability.Life
    elseif id=="Apprentice_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.Medium
        return {c.Beam(e.Position-offset,e.Position+offset),c.Beam(e.Position-offset+Vector3.yAxis*C.Ability.Small,e.Position+offset+Vector3.yAxis*C.Ability.Small),
            c.Ring(c.Ground(),c.Radius)},C.Ability.Life
    elseif id=="Apprentice_7" then
        if e.Outcome=="Obscured" then return {c.Mark("Split",c.Chest,C.Ability.Small)},C.Ability.Life end
        return {c.Mark("Star",c.Head,C.Ability.Large),c.Ring(c.Ground()),c.Beam(c.Chest,c.Head)},C.Ability.Life
    elseif id=="Apprentice_7_Secondary" then
        return {c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset),c.Mark("Star",c.Head,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_6" then
        return {c.Mark("Book",c.Target),c.Beam(c.Target,c.Chest),c.Mark("Door",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_6_Secondary" then
        return {c.Mark("Book",c.Chest,C.Ability.Small),c.Beam(c.Chest,c.Target),c.Mark("Star",c.Target,C.Ability.Medium)},C.Ability.Life
    elseif id=="Apprentice_5" then return pair(false,false),C.Ability.EndpointLife
    elseif id=="Apprentice_5_Secondary" then
        if e.Preview then return pair(false,false),C.Ability.Life end
        return {c.Mark("Key",c.Origin,C.Ability.Medium),c.Mark("Key",e.Position,C.Ability.Medium)},C.Ability.Life
    elseif id=="Apprentice_4" then
        return {c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset),c.Veil(c.Chest),c.Mark("Key",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_4_Secondary" then
        local radius=c.Radius
        local layers={c.Ring(c.Ground(),radius)}
        for _,direction in ipairs({Vector3.xAxis,-Vector3.xAxis,Vector3.zAxis,-Vector3.zAxis}) do
            table.insert(layers,c.Door(c.Ground()+direction*radius,C.Ability.CornerScale))
            if c.Simplified and #layers>=3 then break end
        end
        return layers,C.Ability.Life
    elseif id=="Apprentice_3" then return pair(true,false),C.Ability.Life
    elseif id=="Apprentice_3_Secondary" then
        return {c.Door(c.Self+Vector3.yAxis*C.Ability.GroundOffset,C.Ability.Small),c.Veil(c.Chest),c.Mark("Star",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_2" then
        return {c.Mark("Book",c.Chest),c.Mark("Book",c.Chest+Vector3.xAxis*C.Ability.Medium,C.Ability.Small),
            c.Beam(c.Chest,c.Target),c.Mark("Star",c.Target,C.Ability.Medium)},C.Ability.Life
    elseif id=="Apprentice_2_Secondary" then return pair(false,true),C.Ability.Life
    elseif id=="Apprentice_1" then
        if e.Preview then return pair(false,true),C.Ability.Life end
        return {c.Mark("Star",c.Origin,C.Ability.Large),c.Mark("Star",e.Position,C.Ability.Large),c.Mark("Door",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Apprentice_1_Secondary" then
        return {c.Ring(c.Ground(),c.Radius),c.Door(e.Position,C.Ability.Small),c.Mark("Key",e.Position,C.Ability.Small)},C.Ability.Life
    end
    return nil,nil
end
return Apprentice
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Marauder`

```lua
--!strict
-- Original Error motifs. Dreams, payloads and bounded slows remain gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Marauder={}
function Marauder.Build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    local function cut(at: Vector3): any return c.Mark("Cut",at,C.Ability.Medium,{Tint=C.Ability.TheftTint}) end
    if id=="Marauder_9" or id=="Marauder_6" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Chest
        if e.Outcome=="Released" then from,to=to,from end
        return {c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.DefaultScale,{MoveTo=to})},if id=="Marauder_9" then C.Ability.PickpocketLife else C.Ability.TheftLife
    elseif id=="Marauder_9_Secondary" then
        return {c.Layer("GlitchFlicker",c.Chest,{Frame=c.Frame(c.Chest),Scale=C.Ability.Small}),c.Veil(c.Chest)},C.Ability.Life
    elseif id=="Marauder_8" then
        return {c.Mark("Split",c.Target+Vector3.yAxis*C.Ability.HeadHeight),c.Layer("GlitchFlicker",c.Target,{Scale=C.Ability.Medium})},C.Ability.Life
    elseif id=="Marauder_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.GhostSpacing
        return {c.Layer("GlitchFlicker",c.Target+offset,{Frame=c.Frame(c.Target),Scale=C.Ability.Medium}),
            c.Beam(c.Target,c.Target+offset,C.Ability.TheftTint)},C.Ability.Life
    elseif id=="Marauder_7" then
        return {c.Mark("Book",c.Chest),c.Mark("Split",c.Head,C.Ability.Small),c.Ring(c.Ground())},C.Ability.Life
    elseif id=="Marauder_7_Secondary" then
        if e.Outcome=="Obscured" then return {cut(c.Chest)},C.Ability.Life end
        return {c.Mark("Split",c.Head,C.Ability.Large),c.Layer("GlitchFlicker",c.Chest,{Scale=C.Ability.Small})},C.Ability.Life
    elseif id=="Marauder_6_Secondary" then
        return {c.Beam(c.Target,c.Chest,C.Ability.TheftTint),c.Layer("RisingMotes",c.Chest,{Scale=C.Ability.Small}),cut(c.Target)},C.Ability.Life
    elseif id=="Marauder_5" then
        local at=c.Target+Vector3.yAxis*C.Ability.HeadHeight
        return {c.Mark("Split",at,C.Ability.Small,{MoveTo=c.Chest}),c.Beam(at,c.Chest),cut(at)},C.Ability.Life
    elseif id=="Marauder_5_Secondary" then
        return {cut(c.Target),c.Layer("RisingMotes",c.Target,{Scale=C.Ability.Small,Tint=C.Ability.TheftTint}),
            c.Mark("Split",c.Target,C.Ability.Small)},C.Ability.Life
    elseif id=="Marauder_4" then
        return {c.Beam(c.Chest,c.Target),c.Mark("Split",c.Target,C.Ability.Small),c.Veil(c.Target)},C.Ability.Life
    elseif id=="Marauder_4_Secondary" then
        return {c.Beam(c.Target,c.Chest,C.Ability.TheftTint),c.Beam(c.Target+Vector3.yAxis*C.Ability.Small,c.Chest),
            c.Ring(c.Ground())},C.Ability.Life
    elseif id=="Marauder_3" then
        return {c.Layer("GlitchFlicker",c.Target,{Frame=c.Frame(c.Target),Scale=C.Ability.Medium}),
            c.Mark("Eye",c.Target+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small,{Tint=C.Ability.TheftTint})},C.Ability.Life
    elseif id=="Marauder_3_Secondary" then
        return {c.Veil(c.Target),c.Beam(c.Chest,c.Target),c.Mark("Split",c.Target,C.Ability.Large)},C.Ability.Life
    elseif id=="Marauder_2" then
        return {cut(c.Origin),cut(c.Self),c.Ghost(c.Self),c.Mark("Split",c.Target,C.Ability.Small)},C.Ability.EndpointLife
    elseif id=="Marauder_2_Secondary" then
        if e.Trigger=="PayloadTriggered" then
            return {cut(e.Position),c.Mark("Star",e.Position,C.Ability.Medium,{Tint=C.Ability.TheftTint}),c.Mark("Split",e.Position,C.Ability.Large)},C.Ability.TriggerLife
        end
        return {c.Mark("Split",c.Target,C.Ability.Small),c.Beam(c.Target,c.Target+Vector3.yAxis*C.Ability.Medium,C.Ability.TheftTint)},C.Ability.Life
    elseif id=="Marauder_1" then
        return {c.Mark("Clock",c.Target),c.Beam(c.Target,c.Chest),c.Mark("Cut",c.Target,C.Ability.Small,{MoveTo=c.Chest})},C.Ability.Life
    elseif id=="Marauder_1_Secondary" then
        return {c.Ring(c.Ground(),c.Radius),c.Mark("Clock",e.Position,C.Ability.Large),c.Layer("GlitchFlicker",e.Position,{Scale=C.Ability.Medium})},C.Ability.Life
    end
    return nil,nil
end
return Marauder
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/PathwayEffects/Seer`

```lua
--!strict
-- Canon-inspired concepts; exact geometry and bounded gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Seer={}
function Seer.Build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    if id=="Seer_9" then
        if e.Outcome=="Obscured" then return {c.Mark("Split",c.Chest,C.Ability.Small)},C.Ability.Life end
        return {c.Layer("CardFan",c.Chest,{Frame=c.Frame(c.Chest)}),c.Ring(c.Ground()),c.Mark("Star",c.Head,C.Ability.Small)},C.Ability.Life
    elseif id=="Seer_9_Secondary" then
        local at=c.Head
        local layers={c.Mark("Eye",at,C.Ability.EyeScale)}
        if not c.Simplified then table.insert(layers,c.Ring(c.Ground())) end
        return layers,C.Composition.ResultLife
    elseif id=="Seer_8" then
        return {c.Ghost(c.Origin),c.Layer("RingBurst",c.Origin+Vector3.yAxis*C.Ability.GroundOffset,{Scale=C.Ability.Small}),
            c.Mark("Seal",c.Self,C.Ability.Small)},C.Ability.EndpointLife
    elseif id=="Seer_8_Secondary" then
        return {c.Mark("Seal",c.Chest,C.Ability.Medium),c.Ring(c.Ground())},C.Ability.Life
    elseif id=="Seer_7" then
        local layers={}
        for _,at in ipairs({c.Origin,c.Self}) do
            table.insert(layers,c.Layer("RingBurst",at+Vector3.yAxis*C.Ability.GroundOffset,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameRim}))
            table.insert(layers,c.Layer("RisingMotes",at,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameTint}))
        end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_7_Secondary" then
        if e.Trigger=="SubstituteTriggered" then
            return {c.Layer("PaperFold",e.Position,{Frame=c.Frame(e.Position),Scale=C.Ability.Large,Break=true}),
                c.Layer("CardFan",e.Position,{Frame=c.Frame(e.Position),Scale=C.Ability.Small})},C.Ability.TriggerLife
        end
        return {c.Layer("PaperFold",c.Chest,{Frame=c.Frame(c.Chest),Scale=C.Ability.Medium}),c.Mark("Seal",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Seer_6" then
        return {c.Veil(c.Head),c.Ghost(c.Self),c.Mark("Eye",c.Head,C.Ability.Small)},C.Ability.Life
    elseif id=="Seer_6_Secondary" then
        return {c.Veil(c.Chest),c.Beam(c.Chest-Vector3.xAxis*C.Ability.Small,c.Chest+Vector3.xAxis*C.Ability.Small),
            c.Mark("Seal",c.Head,C.Ability.Small)},C.Ability.Life
    elseif id=="Seer_5" then
        local layers={c.Beam(c.Chest,c.Target),c.Mark("Thread",c.Target,C.Ability.Medium)}
        if not c.Simplified then table.insert(layers,c.Beam(c.Chest+Vector3.xAxis*C.Ability.Small,c.Target+Vector3.yAxis*C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_5_Secondary" then
        local layers={c.Beam(c.Chest,c.Target),c.Mark("Thread",c.Target,C.Ability.Small)}
        local hit=e.Affected and e.Affected[1]
        if hit then table.insert(layers,c.Beam(c.Target,hit.Position)) end
        return layers,C.Ability.Life
    elseif id=="Seer_4" then
        return {c.Ghost(c.Origin,c.Self),c.Ghost(c.Self,c.Origin),c.Beam(c.Origin,c.Self)},C.Ability.EndpointLife
    elseif id=="Seer_4_Secondary" then
        local layers={c.Ring(c.Ground(),c.Radius),c.Ghost(e.Position)}
        if not c.Simplified then
            table.insert(layers,c.Ghost(e.Position+Vector3.xAxis*C.Ability.GhostSpacing))
            table.insert(layers,c.Ghost(e.Position-Vector3.xAxis*C.Ability.GhostSpacing))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_3" then
        local root=c.Root(e.Echo)
        local at=if root then root.Position else e.Position
        return {c.Veil(at),c.Ghost(at),c.Ring(c.Ground(at))},C.Ability.Life
    elseif id=="Seer_3_Secondary" then
        return {c.Ghost(c.Self+Vector3.xAxis*C.Ability.RecallOffset,c.Self),c.Beam(c.Chest+Vector3.xAxis*C.Ability.RecallOffset,c.Chest),
            c.Mark("Eye",c.Chest,C.Ability.Small)},C.Ability.Life
    elseif id=="Seer_2" then
        return {c.Ring(c.Ground()),c.Mark("Seal",c.Chest,C.Ability.Large),c.Layer("RisingMotes",c.Self,{Scale=C.Ability.Medium})},C.Ability.Life
    elseif id=="Seer_2_Secondary" then
        return {c.Beam(c.Chest-Vector3.xAxis*C.Ability.Medium,c.Chest),c.Beam(c.Chest+Vector3.xAxis*C.Ability.Medium,c.Chest),
            c.Mark("Star",c.Chest,C.Ability.Medium)},C.Ability.Life
    elseif id=="Seer_1" then
        if e.Trigger=="GraftReflected" then return {c.Mark("Thread",e.Position,C.Ability.Large),c.Beam(e.Position,c.Chest)},C.Ability.TriggerLife end
        local layers={c.Mark("Thread",e.Position,C.Ability.Large)}
        for i,target in ipairs(e.Affected or {}) do
            if c.Simplified and i>1 then break end
            table.insert(layers,c.Beam(c.Chest,target.Position))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_1_Secondary" then
        local layers={c.Ring(c.Ground(),c.Radius),c.Veil(e.Position+Vector3.xAxis*C.Ability.GhostSpacing)}
        if not c.Simplified then table.insert(layers,c.Veil(e.Position-Vector3.xAxis*C.Ability.GhostSpacing)) end
        return layers,C.Ability.Life
    end
    return nil,nil
end
return Seer
```


## src/StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe.lua

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/PerformanceProbe`

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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/StatusPresentation`

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

**Class:** ModuleScript

**Explorer path:** `StarterPlayer/StarterPlayerScripts/Visuals/WorldPresentation`

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


---

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

[EXISTING] This milestone ended at Phase E; the subsequent F–I implementation is documented in PHASE_FI_VISUALS.md.
