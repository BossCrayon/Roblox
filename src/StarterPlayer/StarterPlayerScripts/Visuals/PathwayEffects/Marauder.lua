--!strict
-- Original Error motifs. Dreams, payloads and bounded slows remain gameplay interpretations [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Marauder={}
function Marauder.Build(a: any,e: any,c: any): (any,number?)
    local id=a.Id
    local function cut(at: Vector3): any return c.Mark("Cut",at,C.Ability.Medium,{Tint=C.Ability.TheftTint}) end
    if id=="Marauder_9" or id=="Marauder_6" then
        local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local to=c.Chest
        if e.Outcome=="Released" then from,to=to,from end
        return {c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
            c.Mark("Split",from,C.Ability.DefaultScale,{MoveTo=to})},if id=="Marauder_9" then C.Ability.PickpocketLife else C.Ability.TheftLife
    elseif id=="Marauder_9_Secondary" then
        return {c.Layer("GlitchFlicker",c.Chest,{Frame=c.Frame(c.Chest),Scale=C.Ability.Small}),c.Veil(c.Chest)},C.Ability.Life
    elseif id=="Marauder_8" then
        return {c.Mark("Split",c.Target+Vector3.yAxis*C.Ability.HeadHeight),c.Layer("GlitchFlicker",c.Target,{Scale=C.Ability.Medium})},C.Ability.Life
    elseif id=="Marauder_8_Secondary" then
        local offset=Vector3.xAxis*C.Ability.GhostSpacing
        return {c.Layer("GlitchFlicker",c.Target+offset,{Frame=c.Frame(c.Target),Scale=C.Ability.Medium}),
            c.Beam(c.Target,c.Target+offset,C.Ability.TheftTint)},C.Ability.Life
    elseif id=="Marauder_7" then
        return {c.Mark("Book",c.Chest),c.Mark("Split",c.Head,C.Ability.Small),c.Ring(c.Ground())},C.Ability.Life
    elseif id=="Marauder_7_Secondary" then
        if e.Outcome=="Obscured" then return {cut(c.Chest)},C.Ability.Life end
        return {c.Mark("Split",c.Head,C.Ability.Large),c.Layer("GlitchFlicker",c.Chest,{Scale=C.Ability.Small})},C.Ability.Life
    elseif id=="Marauder_6_Secondary" then
        return {c.Beam(c.Target,c.Chest,C.Ability.TheftTint),c.Layer("RisingMotes",c.Chest,{Scale=C.Ability.Small}),cut(c.Target)},C.Ability.Life
    elseif id=="Marauder_5" then
        local at=c.Target+Vector3.yAxis*C.Ability.HeadHeight
        return {c.Mark("Split",at,C.Ability.Small,{MoveTo=c.Chest}),c.Beam(at,c.Chest),cut(at)},C.Ability.Life
    elseif id=="Marauder_5_Secondary" then
        return {cut(c.Target),c.Layer("RisingMotes",c.Target,{Scale=C.Ability.Small,Tint=C.Ability.TheftTint}),
            c.Mark("Split",c.Target,C.Ability.Small)},C.Ability.Life
    elseif id=="Marauder_4" then
        return {c.Beam(c.Chest,c.Target),c.Mark("Split",c.Target,C.Ability.Small),c.Veil(c.Target)},C.Ability.Life
    elseif id=="Marauder_4_Secondary" then
        return {c.Beam(c.Target,c.Chest,C.Ability.TheftTint),c.Beam(c.Target+Vector3.yAxis*C.Ability.Small,c.Chest),
            c.Ring(c.Ground())},C.Ability.Life
    elseif id=="Marauder_3" then
        return {c.Layer("GlitchFlicker",c.Target,{Frame=c.Frame(c.Target),Scale=C.Ability.Medium}),
            c.Mark("Eye",c.Target+Vector3.yAxis*C.Ability.HeadHeight,C.Ability.Small,{Tint=C.Ability.TheftTint})},C.Ability.Life
    elseif id=="Marauder_3_Secondary" then
        return {c.Veil(c.Target),c.Beam(c.Chest,c.Target),c.Mark("Split",c.Target,C.Ability.Large)},C.Ability.Life
    elseif id=="Marauder_2" then
        return {cut(c.Origin),cut(c.Self),c.Ghost(c.Self),c.Mark("Split",c.Target,C.Ability.Small)},C.Ability.EndpointLife
    elseif id=="Marauder_2_Secondary" then
        if e.Trigger=="PayloadTriggered" then
            return {cut(e.Position),c.Mark("Star",e.Position,C.Ability.Medium,{Tint=C.Ability.TheftTint}),c.Mark("Split",e.Position,C.Ability.Large)},C.Ability.TriggerLife
        end
        return {c.Mark("Split",c.Target,C.Ability.Small),c.Beam(c.Target,c.Target+Vector3.yAxis*C.Ability.Medium,C.Ability.TheftTint)},C.Ability.Life
    elseif id=="Marauder_1" then
        return {c.Mark("Clock",c.Target),c.Beam(c.Target,c.Chest),c.Mark("Cut",c.Target,C.Ability.Small,{MoveTo=c.Chest})},C.Ability.Life
    elseif id=="Marauder_1_Secondary" then
        return {c.Ring(c.Ground(),c.Radius),c.Mark("Clock",e.Position,C.Ability.Large),c.Layer("GlitchFlicker",e.Position,{Scale=C.Ability.Medium})},C.Ability.Life
    end
    return nil,nil
end
return Marauder
