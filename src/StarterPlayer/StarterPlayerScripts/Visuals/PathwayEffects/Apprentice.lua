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
return Apprentice
