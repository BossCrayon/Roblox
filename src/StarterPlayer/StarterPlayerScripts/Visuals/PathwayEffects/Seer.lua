--!strict
-- Canon-inspired motifs; geometry/poses are original gameplay presentation [UNVERIFIED].
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Seer={}
function Seer.Build(a: any,e: any,c: any): (any,number?)
    if a.Id=="Seer_9_Secondary" then
        local at=e.Destination+Vector3.yAxis*C.Ability.ReadHeight
        local layers={c.Layer("SigilStencil",at,{Frame=c.Frame(at),Glyph=C.Ability.EyeGlyph,LowGlyph=C.Ability.LowEyeGlyph,Scale=C.Ability.EyeScale})}
        if not c.Simplified then table.insert(layers,c.Layer("GroundRune",e.Destination+Vector3.yAxis*C.Ability.GroundOffset,
            {Scale=C.Ability.DefaultScale,Detail=C.Ability.ReadGroundDetail})) end
        return layers,C.Composition.ResultLife
    elseif a.Id=="Seer_7" then
        local layers={}
        for _,at in ipairs({e.Origin,e.Destination}) do
            table.insert(layers,c.Layer("RingBurst",at+Vector3.yAxis*C.Ability.GroundOffset,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameRim}))
            table.insert(layers,c.Layer("RisingMotes",at,{Scale=C.Ability.FlameScale,Tint=C.Ability.FlameTint}))
        end
        return layers,C.Ability.EndpointLife
    end
    return nil,nil
end
return Seer
