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
