--!strict
-- Original transfer geometry. Captured/released outcomes are supplied by the server.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Marauder={}
function Marauder.Build(a: any,e: any,c: any): (any,number?)
    if a.Id~="Marauder_9" and a.Id~="Marauder_6" then return nil,nil end
    local from=e.Position+Vector3.yAxis*C.Ability.HandHeight
    local to=e.Destination+Vector3.yAxis*C.Ability.HandHeight
    if e.Outcome=="Released" then from,to=to,from end
    return {c.Layer("ThreadBeam",from,{EndPosition=to,Scale=C.Ability.TransferScale,Tint=C.Ability.TheftTint}),
        c.Layer("SigilStencil",from,{Frame=c.Frame(from),Glyph=C.Ability.TheftGlyph,LowGlyph=C.Ability.TheftGlyph,
            MoveTo=to,Scale=C.Ability.DefaultScale})},if a.Id=="Marauder_9" then C.Ability.PickpocketLife else C.Ability.TheftLife
end
return Marauder
