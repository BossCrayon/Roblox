# Phase 1 — complete copy/paste code

All 17 production Luau files are supplied in full, including later admin-control updates. Create Folder parents, keep every existing unchanged module, and **replace** same-name scripts rather than running duplicate Bootstrap/Mysteries entrypoints. Install while Play is stopped. Theme is deliberately first. The complete built place is `studio/Mysteries.rbxlx`.

This UI source export includes later integrations. Install the current framework from docs/PHASE_FI_VISUALS_CODE.md, or use docs/FULL_SOURCE.md for a blank place. The reference concept images were not received; the UI follows the Art Bible. Permanent label replacement and map redesign remain later phases.

| File | Class | Explorer path |
|---|---|---|
| `src/ReplicatedStorage/Shared/Theme.lua` | ModuleScript | `ReplicatedStorage/Shared/Theme` |
| `src/ReplicatedStorage/Shared/VisualLayout.lua` | ModuleScript | `ReplicatedStorage/Shared/VisualLayout` |
| `src/ReplicatedStorage/Shared/VisualModel.lua` | ModuleScript | `ReplicatedStorage/Shared/VisualModel` |
| `src/ReplicatedStorage/Shared/RuntimeConfig.lua` | ModuleScript | `ReplicatedStorage/Shared/RuntimeConfig` |
| `src/ServerScriptService/AdminConfig.lua` | ModuleScript | `ServerScriptService/AdminConfig` |
| `src/ServerScriptService/Domain/VisualAccess.lua` | ModuleScript | `ServerScriptService/Domain/VisualAccess` |
| `src/ServerScriptService/Domain/AdminProgression.lua` | ModuleScript | `ServerScriptService/Domain/AdminProgression` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Kit.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Kit` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Hud` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Menus` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Prompts.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Prompts` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Feedback` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Developer` |
| `src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua` | ModuleScript | `StarterPlayer/StarterPlayerScripts/UI/Presentation` |
| `src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua` | LocalScript | `StarterPlayer/StarterPlayerScripts/Mysteries` |
| `src/ServerScriptService/Services/WorldService.lua` | ModuleScript | `ServerScriptService/Services/WorldService` |
| `src/ServerScriptService/Bootstrap.server.lua` | Script | `ServerScriptService/Bootstrap` |

## src/ReplicatedStorage/Shared/Theme.lua

**Class:** ModuleScript

**Explorer:** `ReplicatedStorage/Shared/Theme`

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
            CompleteScale=4,IncompleteScale=2,CompleteLift=14,IncompleteLift=5,FloatHeight=0.65,
            FoolCloakAlpha=0.38,FoolEndLife=1.2,FoolAuraInterval=1.4,FoolAuraLife=1.6,
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
        SpiritVortex={{{0.5500,0.5000},{0.5529,0.5406},{0.5216,0.5805},{0.4617,0.5924},{0.3990,0.5583},{0.3678,0.4826},{0.3939,0.3939},{0.4782,0.3348},{0.5917,0.3412},{0.6848,0.4235},{0.7093,0.5561},{0.6420,0.6851},{0.5000,0.7500},{0.3377,0.7116},{0.2263,0.5733},{0.2228,0.3852},{0.3417,0.2258},{0.5435,0.1695},{0.7475,0.2525},{0.8635,0.4521},{0.8320,0.6917},{0.6531,0.8696},{0.3922,0.9025},{0.1562,0.7638},{0.0500,0.5000}}},
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


## src/ReplicatedStorage/Shared/VisualLayout.lua

**Class:** ModuleScript

**Explorer:** `ReplicatedStorage/Shared/VisualLayout`

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

**Class:** ModuleScript

**Explorer:** `ReplicatedStorage/Shared/VisualModel`

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


## src/ReplicatedStorage/Shared/RuntimeConfig.lua

**Class:** ModuleScript

**Explorer:** `ReplicatedStorage/Shared/RuntimeConfig`

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


## src/ServerScriptService/AdminConfig.lua

**Class:** ModuleScript

**Explorer:** `ServerScriptService/AdminConfig`

```lua
--!strict
-- Server-only allowlist. Roblox resolves these configured usernames to numeric IDs.
-- Add numeric IDs for stable access after a username change. Never accept client names.
return table.freeze({AdminUserIds=table.freeze({}),AdminUsernames=table.freeze({"johnskie816"}),
    LookupAttempts=3,LookupRetrySeconds=2})
```


## src/ServerScriptService/Domain/VisualAccess.lua

**Class:** ModuleScript

**Explorer:** `ServerScriptService/Domain/VisualAccess`

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


## src/ServerScriptService/Domain/AdminProgression.lua

**Class:** ModuleScript

**Explorer:** `ServerScriptService/Domain/AdminProgression`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Kit.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Kit`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Hud.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Hud`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Menus.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Menus`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Prompts.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Prompts`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Feedback.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Feedback`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Developer.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Developer`

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


## src/StarterPlayer/StarterPlayerScripts/UI/Presentation.lua

**Class:** ModuleScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/UI/Presentation`

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
        local gesture=event.Position+Vector3.yAxis*(C.Ultimate.GestureHeight+(if event.Stage=="Complete" then T.CharacterArt.Mythical.CompleteLift else T.CharacterArt.Mythical.IncompleteLift))
        -- Six layers, one reservation: intake -> unfold -> domain/aftermath.
        -- This is a cinematic interpretation, never a client-side damage or time-stop grant.
        local ultSpecs: {any}={
            {Name="RisingMotes",Position=gesture,Palette=palette,Options={Scale=C.Ultimate.IntakeScale,Intake=true,Life=C.Ultimate.Release}},
            {Name="SigilStencil",Position=gesture,Palette=palette,Options={Scale=scale,Glyph=if palette=="Seer" and event.Stage=="Complete" then "SpiritVortex" else stencil,LowGlyph=stencil,Frame=CFrame.new(gesture)*frame.Rotation}},
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


## src/StarterPlayer/StarterPlayerScripts/Mysteries.client.lua

**Class:** LocalScript

**Explorer:** `StarterPlayer/StarterPlayerScripts/Mysteries`

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


## src/ServerScriptService/Services/WorldService.lua

**Class:** ModuleScript

**Explorer:** `ServerScriptService/Services/WorldService`

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


## src/ServerScriptService/Bootstrap.server.lua

**Class:** Script

**Explorer:** `ServerScriptService/Bootstrap`

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


---

## Studio checklist — run after installing all code

### Desktop

1. Open a fresh copy of the updated place; use a viewport close to **1920×1080**, then **1280×720**. In **View → Output**, check there are no red errors. Verify there is no storage/session/“Normal” banner.
2. Before drinking, all six slots should show dashed seals. No slot may show “Empty.” Press B, open Inventory, select a starter potion and cancel. Quantity and pathway must not change. Repeat and confirm: one potion is consumed, the server advances, two powers appear, and the sequence text animates once.
3. Open Journal, choose a slot, equip a power and hover it. Check glyph, name, spirituality cost, keyboard badge and 32-segment cooldown. Re-equip across slots to produce gaps; no menu errors or blank-scroll failures should occur.
4. Fight a nearby enemy: verify server damage numbers, health flash, resource tween and cast feedback. The presentation must not alter damage or cooldowns. Turn on Reduced motion in Journal; breathing/flash should stop, while numeric feedback remains readable.
5. Approach Potion Altar: only one compact custom prompt should show; old floating labels should be hidden during its presentation. Hold its displayed key. Check preview and Confirm/Cancel are visible. Cancel: no gold deducted. Earn 100 gold, reopen and confirm: one next potion, one charge. Buying does not itself advance you.
6. Open the altar, walk away before confirming, and try confirmation. It must not charge. Reopen, wait over 15 seconds, then check the button is disabled. Reopen again for a valid purchase. While a menu is open, ability/strike inputs and background prompts must not fire; walking is not a pause of the server simulation.
7. Verify E uses the active interaction prompt without also casting hotbar slot 2. Leave the prompt's range and confirm labels restore. Test an existing spatial gate's custom prompt after unlocking a Traveler power.
8. Press F8 as the creator/allowlisted account, then close it with F8. Check diagnostics stay inside that panel. In a two-client test, unprivileged synthetic/other accounts must not open it or gain mastery. Group ownership alone must not authorize arbitrary group members.

### Phone emulator

Use Studio's **Test → Device Emulator** (device controls may appear in the Test toolbar), select a phone around **390×844**, and test both portrait and landscape around **844×390**. Keep default Roblox touch controls enabled.

- Check top/device insets: resource icons and numbers, book button and all six slots must be visible. No text under a notch/top bar; no hotbar under joystick/jump. Smallest slot hit area stays at least 44×44.
- Tap the journal icon. All three tabs, slot-picker horizontal scroll, ability-list vertical scroll, close control and Inventory preview must work. Confirm/Cancel stay fixed while preview content scrolls.
- Tap ability/Strike buttons while aiming the camera at an NPC; the target uses the center reticle, not the tapped button's screen position.
- Approach altar and tap/hold the custom prompt. Check readability, hold progress, menu opening and no collision with vitals/hotbar/remaining labels. Rotate while open and while casting; card bounds and scroll controls must recalculate.
- Check toast, touch Strike button, casting strip and cooldown rings do not stack over one another. In cramped landscape, masthead/pathway content may yield to active feedback or prompts.

### Tablet emulator

Use approximately **768×1024 portrait** and **1024×768 landscape** with touch controls enabled.

- Verify vitals and masthead do not touch, all six slots remain tappable, and the collapsed pathway can expand without covering combat controls.
- Verify Journal/Pathway/Inventory tabs, slot selection, modal centering, potion preview and fixed actions in both orientations. Check long names such as “Attendant of Mysteries” and “Trojan Horse of Destiny.”
- Repeat one cast, one prompt interaction, one cancellation and one legitimate purchase. Watch Output for errors during resize, respawn, repeated open/close and device rotation.

### Finishing checks

At graphics quality 1 and again at a higher quality, text must stay readable on opaque dark panels. Check at 100% OS scaling and your normal OS scaling. After several respawns there must still be one MysteriesHUD and one MysteriesSanity effect. If low sanity is reached naturally, capture the vignette with resource numbers readable; do not weaken server rules merely for the screenshot. Audio is intentionally silent until IDs are configured; after setting originals, verify hover/click/confirm/reject sounds with no asset permission errors.

Do not delete script errors, suppress assertions, turn on DataStore access, or change enemy/progression balance just to make a visual check pass. Report the exact error and device size instead.

## Exactly which screenshots to send

Send full **game viewport** images at 100% image scale, keeping every HUD edge and default touch control visible. Include the emulator's device/resolution in the filename or message; a second wider Studio-window image is useful if an inset/device issue occurs. Do not crop away the hotbar, top bar, notch or bottom controls.

1. **`01-desktop-idle.png`** — fresh uninitiated desktop HUD; all six dashed seals, masthead and pathway row visible; developer panel closed.
2. **`02-desktop-combat.png`** — after drinking a starter potion, with at least one cooldown ring/countdown and spirituality cost visible. Include cast feedback or a damage number if you can catch it.
3. **`03-journal.png`** — Journal tab open, selected slot and ability rows visible. Choose a long ability name if available.
4. **`04-altar-confirm.png`** — Potion Altar preview showing current/target sequence, owned count, gold cost, digestion requirements and both Confirm/Cancel. Capture before confirming.
5. **`05-phone-portrait.png`** — 390×844 or closest phone, normal gameplay with default joystick/jump, touch Strike and all six slots visible.
6. **`06-phone-inventory.png`** — same phone, potion preview with fixed actions visible after scrolling; include the entire modal and safe edges.
7. **`07-phone-landscape.png`** — 844×390 or closest landscape phone during a cooldown or cast, showing touch controls and compact HUD.
8. **`08-tablet-portrait.png`** — 768×1024 or closest tablet, expanded pathway/digestion panel plus hotbar and touch controls.
9. **`09-tablet-landscape.png`** — 1024×768 or closest tablet, Journal or Altar menu open with its bottom actions visible.
10. **`10-developer-f8.png`** — authorized F8 panel open. Also state whether an unprivileged client stayed unchanged when pressing F8; do not include personal identifiers you do not wish to share.

If errors occur, add **`output-errors.png`** with the full red error and script/line number; also paste its text so it is searchable. If sanity becomes low during testing, add **`sanity-low.png`** with the full HUD. Short recordings are optional for hover sounds, collapse animation, cooldown movement, hit flash and the advance title; still screenshots cannot verify timing or audio.

Please also reattach the original hub and HUD concept images; they did not arrive with the request. Those are references, separate from the verification screenshots.

Stop after Phase 1. Phase 2 starts only after “continue.”
