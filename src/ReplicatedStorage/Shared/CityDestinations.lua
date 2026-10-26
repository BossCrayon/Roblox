--!strict
-- Stable IDs only cross the travel remote; coordinates always come from this registry.
local layout=require(script.Parent.TingenLayout)
local plan=require(script.Parent.TingenPlan)
local entries: {any}={}
local byId: {[string]: any}={}
for index,p in ipairs(plan.Plots) do
    local id=tostring(p[1])..":"..index
    local entry={Id=id,MapId=p[1],Name=p[2],X=p[3],Y=p[4],LandingX=p[3],LandingY=p[4]-p[6]/2-4,Approximate=p[1]==68}
    if p[1]==47 then entry.LandingX=655;entry.LandingY=310 end
    table.insert(entries,entry);byId[id]=entry
end
for _,r in ipairs({{66,550,546},{67,833,171}}) do
    local item=layout.Landmarks[r[1]]
    local entry={Id=tostring(r[1]),MapId=r[1],Name=item.Name,X=item.X,Y=item.Y,LandingX=r[2],LandingY=r[3],Approximate=false}
    table.insert(entries,entry);byId[entry.Id]=entry
end
return require(script.Parent.Freeze)({Entries=entries,ById=byId,Cost=10,Cooldown=5})
