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
