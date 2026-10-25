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
    CastProfiles={
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
})
