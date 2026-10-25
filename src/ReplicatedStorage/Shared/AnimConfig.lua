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
return freeze(config)
