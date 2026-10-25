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
    c.Root=Choreography.Root
    c.Self=e.Destination or e.Position
    c.Origin=e.Origin or e.Position
    c.Head=c.Self+Vector3.yAxis*C.Ability.HeadHeight
    c.Chest=c.Self+Vector3.yAxis*C.Ability.ChestHeight
    c.Gesture=c.Self+Vector3.yAxis*gestureY
    c.OriginGesture=c.Origin+Vector3.yAxis*gestureY
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
        return c.Layer("AfterimageTrail",at,{Frame=c.Frame(at),Scale=scale or C.Ability.Medium,MoveTo=moveTo})
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
return Choreography
