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
