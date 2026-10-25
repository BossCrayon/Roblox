--!strict
-- Original Error motifs. Dreams, payloads and bounded slows remain gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Choreography=require(script.Parent.Parent.Choreography)
local Marauder={}
local function build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    local function cut(at: Vector3,scale: number?): any
        return c.Mark("Cut",at,scale or C.Ability.Medium,{Tint=C.Ability.TheftTint})
    end
    if id=="Marauder_9" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Gesture
        local layers={
            c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.DefaultScale,{MoveTo=to}),
        }
        if not c.Simplified then table.insert(layers,cut(from,C.Ability.Small)) end
        return layers,C.Ability.PickpocketLife
    elseif id=="Marauder_9_Secondary" then
        local layers={c.Glitch(c.Chest,C.Ability.Small),c.Veil(c.Chest)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Split",c.Gesture,C.Ability.Small))
            table.insert(layers,c.Burst(c.Ground(),C.Ability.Small))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_8" then
        local layers={c.Mark("Split",c.TargetHead,C.Ability.Medium),c.Glitch(c.Target,C.Ability.Medium)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Mask",c.TargetHead,C.Ability.Small,{Tint=C.Ability.TheftTint}))
            table.insert(layers,c.Beam(c.Gesture,c.TargetHead,C.Ability.TheftTint))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.GhostSpacing
        local layers={
            c.Glitch(c.Target+offset,C.Ability.Medium),
            c.Ghost(c.Target,c.Target+offset),
            c.Beam(c.Target,c.Target+offset,C.Ability.TheftTint),
        }
        if not c.Simplified then table.insert(layers,cut(c.Target,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_7" then
        local layers={c.Mark("Book",c.Gesture,C.Ability.Medium),c.Mark("Split",c.Head,C.Ability.Small),c.Ring(c.Ground())}
        if not c.Simplified then table.insert(layers,c.Mark("Eye",c.Head,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_7_Secondary" then
        if e.Outcome=="Obscured" then
            return {cut(c.Chest,C.Ability.Small),c.Glitch(c.Chest,C.Ability.Small)},C.Ability.Life
        end
        local layers={c.Mark("Split",c.Head,C.Ability.Large),c.Glitch(c.Gesture,C.Ability.Small)}
        if not c.Simplified then
            table.insert(layers,c.Mark("Scale",c.Gesture,C.Ability.Small))
            table.insert(layers,c.Ring(c.Ground()))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_6" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Gesture
        if e.Outcome=="Released" then
            from,to=c.Gesture,e.Position+Vector3.yAxis*C.Ability.HandHeight
            local layers={
                c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
                c.Mark("Split",from,C.Ability.Medium,{MoveTo=to}),
                c.Star(to,C.Ability.Medium,C.Ability.TheftTint),
            }
            if not c.Simplified then table.insert(layers,c.Glitch(to,C.Ability.Small)) end
            return layers,C.Ability.TheftLife
        end
        local layers={
            c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.Medium,{MoveTo=to}),
            c.Glitch(from,C.Ability.Small),
        }
        if not c.Simplified then
            table.insert(layers,cut(from,C.Ability.Small))
            table.insert(layers,c.Mark("Star",to,C.Ability.Small,{Tint=C.Ability.TheftTint}))
        end
        return layers,C.Ability.TheftLife
    elseif id=="Marauder_6_Secondary" then
        local layers={c.Beam(c.TargetChest,c.Chest,C.Ability.TheftTint),c.Motes(c.Chest,C.Ability.Small),cut(c.TargetChest)}
        if not c.Simplified then table.insert(layers,c.Mark("Split",c.TargetChest,C.Ability.Small,{MoveTo=c.Chest})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_5" then
        local at=c.TargetHead
        local layers={c.Mark("Split",at,C.Ability.Small,{MoveTo=c.Gesture}),c.Beam(at,c.Gesture),cut(at)}
        if not c.Simplified then table.insert(layers,c.Mark("Eye",at,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_5_Secondary" then
        local layers={
            cut(c.TargetHead),
            c.Motes(c.Target,C.Ability.Small,C.Ability.TheftTint),
            c.Mark("Split",c.TargetChest,C.Ability.Small),
        }
        if not c.Simplified then table.insert(layers,c.Veil(c.Target,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_4" then
        local layers={c.Beam(c.Gesture,c.TargetChest),c.Mark("Split",c.TargetChest,C.Ability.Small),c.Veil(c.Target)}
        if not c.Simplified then
            table.insert(layers,c.Beam(c.Chest,c.TargetHead,C.Ability.TheftTint))
            table.insert(layers,c.Mark("Thread",c.TargetChest,C.Ability.Small,{Tint=C.Ability.TheftTint}))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_4_Secondary" then
        local layers={
            c.Beam(c.TargetChest,c.Chest,C.Ability.TheftTint),
            c.Beam(c.TargetHead,c.Gesture),
            c.Ring(c.Ground()),
        }
        if not c.Simplified then
            table.insert(layers,cut(c.TargetChest,C.Ability.Small))
            table.insert(layers,c.Motes(c.Self,C.Ability.Small,C.Ability.TheftTint))
        end
        return layers,C.Ability.Life
    elseif id=="Marauder_3" then
        local layers={
            c.Glitch(c.Target,C.Ability.Medium),
            c.Mark("Eye",c.TargetHead,C.Ability.Small,{Tint=C.Ability.TheftTint}),
            c.Mark("Mask",c.TargetChest,C.Ability.Medium),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Split",c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_3_Secondary" then
        local layers={
            c.Veil(c.Target),
            c.Beam(c.Gesture,c.TargetHead,C.Ability.TheftTint),
            c.Mark("Split",c.TargetChest,C.Ability.Large),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Crown",c.TargetHead,C.Ability.Medium,{Tint=C.Ability.TheftTint})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_2" then
        local layers={cut(c.Origin),cut(c.Self),c.Ghost(c.Origin,c.Self),c.Mark("Split",c.Target,C.Ability.Small)}
        if not c.Simplified then table.insert(layers,c.Beam(c.Self,c.Target,C.Ability.TheftTint)) end
        return layers,C.Ability.EndpointLife
    elseif id=="Marauder_2_Secondary" then
        if e.Trigger=="PayloadTriggered" then
            local layers={
                cut(e.Position),
                c.Mark("Star",e.Position,C.Ability.Medium,{Tint=C.Ability.TheftTint}),
                c.Mark("Split",e.Position,C.Ability.Large),
            }
            if not c.Simplified then table.insert(layers,c.Glitch(e.Position,C.Ability.Medium)) end
            return layers,C.Ability.TriggerLife
        end
        local layers={
            c.Mark("Split",c.TargetChest,C.Ability.Small),
            c.Beam(c.Target,c.Target+Vector3.yAxis*C.Ability.Medium,C.Ability.TheftTint),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Star",c.TargetChest,C.Ability.Small,{Tint=C.Ability.TheftTint})) end
        return layers,C.Ability.Life
    elseif id=="Marauder_1" then
        local layers={
            c.Mark("Clock",c.TargetHead,C.Ability.Large),
            c.Beam(c.TargetHead,c.Gesture,C.Ability.TheftTint),
            c.Mark("Cut",c.TargetHead,C.Ability.Small,{MoveTo=c.Gesture,Tint=C.Ability.TheftTint}),
        }
        if not c.Simplified then table.insert(layers,c.Mark("Clock",c.Gesture,C.Ability.Small)) end
        return layers,C.Ability.Life
    elseif id=="Marauder_1_Secondary" then
        local layers={
            c.Ring(c.Ground(),c.Radius),
            c.Mark("Clock",e.Position,C.Ability.Large),
            c.Glitch(e.Position,C.Ability.Medium),
        }
        if not c.Simplified then
            for _,target in ipairs(e.Affected or {}) do
                if #layers>=C.Composition.MaxLayers then break end
                table.insert(layers,c.Mark("Clock",target.Position+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small))
            end
        end
        return layers,C.Ability.Life
    end
    return nil,nil
end
function Marauder.Build(a: any,e: any,c: any): (any,number?)
    local layers,life=build(a,e,c)
    return Choreography.Finish(layers,life,a,c,"Marauder")
end
return Marauder
