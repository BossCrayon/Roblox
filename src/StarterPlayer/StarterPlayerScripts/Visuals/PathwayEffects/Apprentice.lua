--!strict
-- Door/travel motifs; does not create gateways, move rigs or change collisions.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Apprentice={}
function Apprentice.Build(a: any,e: any,c: any): (any,number?)
    if a.Id=="Apprentice_9" then
        local target=e.Target
        if typeof(target)~="Instance" or not target:IsA("BasePart") or not target.Parent then return nil,nil end
        local at=target.Position-Vector3.yAxis*(target.Size.Y/2)
        return {c.Layer("DoorFrame",at,{Frame=CFrame.new(at)*target.CFrame.Rotation,Scale=1/C.Tier[e.Tier].Scale,
            Width=target.Size.X+C.Ability.DoorMargin,Height=target.Size.Y+C.Ability.DoorMargin})},C.Composition.ResultLife
    elseif a.Id=="Apprentice_5" then
        local layers={}
        for _,endpoint in ipairs({e.Origin,e.Destination}) do
            local at=endpoint+Vector3.yAxis*C.Ability.GroundOffset
            table.insert(layers,c.Layer("DoorFrame",at,{Frame=c.Frame(at),Scale=C.Ability.TravelScale}))
        end
        return layers,C.Ability.EndpointLife
    end
    return nil,nil
end
return Apprentice
