--!strict
-- Canon-inspired concepts; exact geometry and bounded gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography=require(script.Parent.Parent.Choreography)
local Seer={}
local function build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    if id=="Seer_9" then
        if e.Outcome=="Obscured" then
            return {c.Mark("Split",c.Gesture,C.Ability.Small),c.Veil(c.Chest,C.Ability.Small)},C.Ability.Life
        end
        local layers={c.Cards(c.Gesture,C.Ability.Medium),c.Ring(c.Ground()),c.Mark("Card",c.Head,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Mark("Star",c.Head+Vector3.yAxis*C.Ability.Small,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_9_Secondary" then
        local layers={c.Mark("Eye",c.Head,C.Ability.EyeScale),c.Veil(c.Head,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Ring(c.Ground()))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Composition.ResultLife
    elseif id=="Seer_8" then
        local layers={
            c.Ghost(c.Origin,c.Self),
            c.Burst(c.Origin+Vector3.yAxis*C.Ability.GroundOffset,C.Ability.Small),
            c.Mark("Circle",c.Self,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Trail(c.Origin,C.Ability.Small,c.Self)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_8_Secondary" then
        local layers={c.Mark("Scale",c.Gesture,C.Ability.Medium),c.Ring(c.Ground())}
        if not c.Simplified then
            table.insert(layers,c.Mark("Mask",c.Head,C.Ability.Small))
            table.insert(layers,c.Burst(c.Ground(),C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_7" then
        local layers={}
        for _,at in ipairs({c.Origin,c.Self}) do
            table.insert(layers,c.Layer("RingBurst",at+Vector3.yAxis*C.Ability.GroundOffset,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameRim}))
            table.insert(layers,c.Layer("RisingMotes",at,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameTint}))
        end
        if not c.Simplified then
            table.insert(layers,c.Beam(c.OriginGesture,c.Gesture,C.Ability.FlameTint))
            table.insert(layers,c.Mark("Flame",c.Gesture,C.Ability.Small))
        end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_7_Secondary" then
        if e.Trigger=="SubstituteTriggered" then
            local layers={
                c.Paper(e.Position,true,C.Ability.Large),
                c.Cards(e.Position,C.Ability.Small),
                c.Mark("Thread",e.Position,C.Ability.Small),
            }
            if not c.Simplified then table.insert(layers,c.Burst(e.Position,C.Ability.Small)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={c.Paper(c.Gesture,false,C.Ability.Medium),c.Mark("Card",c.Chest,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Beam(c.Gesture,c.Head)) end
        return layers,C.Ability.Life
    elseif id=="Seer_6" then
        local layers={c.Mark("Mask",c.Head,C.Ability.Medium),c.Veil(c.Head),c.Ghost(c.Self)}
        if not c.Simplified then table.insert(layers,c.Motes(c.Self,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_6_Secondary" then
        local layers={
            c.Mark("Circle",c.Gesture,C.Ability.Small),
            c.Beam(c.Gesture-Vector3.xAxis*C.Ability.Small,c.Gesture+Vector3.xAxis*C.Ability.Small),
            c.Veil(c.Chest,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Burst(c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Seer_5" then
        local stageScale=if e.Controlled then C.Ability.Large else C.Ability.Medium
        local layers={c.Beam(c.Gesture,c.Target),c.Mark("Thread",c.Target,stageScale)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture+Vector3.xAxis*C.Ability.Small,c.Target+Vector3.yAxis*C.Ability.Small))
            if (e.Threads and e.Threads>=2) or e.Controlled then
                table.insert(layers,c.Beam(c.Gesture-Vector3.xAxis*C.Ability.Small,c.TargetHead))
            end
            if e.Controlled then
                table.insert(layers,c.Mark("Seal",c.TargetHead,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    elseif id=="Seer_5_Secondary" then
        local layers={c.Beam(c.Gesture,c.Target),c.Mark("Thread",c.Target,C.Ability.Small)}
        local hit=e.Affected and e.Affected[1]
        if hit then
            table.insert(layers,c.Beam(c.Target,hit.Position))
            if not c.Simplified then table.insert(layers,c.Mark("Star",hit.Position,C.Ability.Small)) end
        elseif not c.Simplified then
            table.insert(layers,c.Mark("Crown",c.TargetHead,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_4" then
        local layers={c.Ghost(c.Origin,c.Self),c.Ghost(c.Self,c.Origin),c.Beam(c.Origin,c.Self),c.Mark("Thread",c.Self,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Mark("Thread",c.Origin,C.Ability.Small)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Seer_4_Secondary" then
        local layers={c.Ring(c.Ground(),c.Radius),c.Mark("Mask",e.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Medium),c.Ghost(e.Position)}
        if not c.Simplified then
            table.insert(layers,c.Ghost(e.Position+Vector3.xAxis*C.Ability.GhostSpacing))
            table.insert(layers,c.Ghost(e.Position-Vector3.xAxis*C.Ability.GhostSpacing))
            local hit=e.Affected and e.Affected[1]
            if hit then table.insert(layers,c.Mark("Eye",hit.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small)) end
        end
        return layers,C.Ability.Life
    elseif id=="Seer_3" then
        local root=c.Root(e.Echo)
        local at=if root then root.Position else e.Position
        local layers={c.Veil(at),c.Ghost(at),c.Ring(c.Ground(at)),c.Mark("Hourglass",at+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture,at+Vector3.yAxis*C.Ability.ChestHeight))
            table.insert(layers,c.Motes(at,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_3_Secondary" then
        local past=c.Self+Vector3.xAxis*C.Ability.RecallOffset
        local layers={
            c.Ghost(past,c.Self),
            c.Beam(c.Chest+Vector3.xAxis*C.Ability.RecallOffset,c.Chest),
            c.Mark("Hourglass",c.Gesture,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Ring(c.Ground()))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_2" then
        local layers={
            c.Ring(c.Ground()),
            c.Mark("Star",c.Gesture,C.Ability.Large),
            c.Motes(c.Self,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Gesture,c.Chest))
            table.insert(layers,c.Mark("Seal",c.Chest,C.Ability.Medium))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_2_Secondary" then
        local layers={
            c.Beam(c.Chest-Vector3.xAxis*C.Ability.Medium,c.Chest),
            c.Beam(c.Chest+Vector3.xAxis*C.Ability.Medium,c.Chest),
            c.Star(c.Chest,C.Ability.Medium),
        }
        if not c.Simplified then
            table.insert(layers,c.Mark("Hourglass",c.Head,C.Ability.Small))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_1" then
        if e.Trigger=="GraftReflected" then
            local layers={c.Mark("Thread",e.Position,C.Ability.Large),c.Beam(e.Position,c.Chest)}
            if not c.Simplified then table.insert(layers,c.Star(e.Position,C.Ability.Small)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={c.Mark("Thread",e.Position,C.Ability.Large),c.Mark("Seal",e.Position,C.Ability.Small)}
        for i,target in ipairs(e.Affected or {}) do
            if (c.Simplified and i>1) or #layers>=C.Composition.MaxLayers then break end
            table.insert(layers,c.Beam(c.Gesture,target.Position))
        end
        return layers,C.Ability.Life
    elseif id=="Seer_1_Secondary" then
        local layers={
            c.Ring(c.Ground(),c.Radius),
            c.Mark("Crown",e.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Large),
            c.Veil(e.Position+Vector3.xAxis*C.Ability.GhostSpacing),
        }
        if not c.Simplified then
            table.insert(layers,c.Veil(e.Position-Vector3.xAxis*C.Ability.GhostSpacing))
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Seal",target.Position+Vector3.yAxis*C.Ability.ChestHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    end
    return nil,nil
end
function Seer.Build(a: any,e: any,c: any): (any,number?)
    local layers,life=build(a,e,c)
    return Choreography.Finish(layers,life,a,c,"Seer")
end
return Seer
