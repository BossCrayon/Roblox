--!strict
-- Geography follows the supplied settings-book plate; architecture/roads are interpretive.
local Shared=game:GetService("ReplicatedStorage").Shared
local Layout=require(Shared.TingenLayout)
local Theme=require(Shared.Theme)
local Plan=require(Shared.TingenPlan)
local Architecture=require(script.Parent.TingenArchitecture)
local Art=require(script.Parent.WorldArt)
local Collection=game:GetService("CollectionService")
local City={}
local stone=Color3.fromRGB(139,132,116)
local brick=Color3.fromRGB(113,80,69)
local slate=Color3.fromRGB(49,57,65)
local water=Color3.fromRGB(49,91,108)
local function point(x: number,y: number,h: number?): Vector3
    return Vector3.new((x-Layout.OriginX)*Layout.Scale,h or 0,(y-Layout.OriginY)*Layout.Scale)
end
local function part(parent: Instance,name: string,dimensions: Vector3,at: Vector3,color: Color3,solid: boolean?): Part
    return Art.Part(parent,name,dimensions,CFrame.new(at),color,solid)
end
local function line(parent: Instance,name: string,a: Vector3,b: Vector3,width: number,depth: number,color: Color3): Part
    return Art.Part(parent,name,Vector3.new(width,depth,(b-a).Magnitude+1),CFrame.lookAt((a+b)/2,b),color,true)
end
local function label(p: BasePart,text: string)
    p:SetAttribute("VisualName",text)
    local gui=Instance.new("BillboardGui");gui.Name="LandmarkName";gui.Size=UDim2.fromOffset(260,52)
    gui.StudsOffset=Vector3.new(0,4,0);gui.MaxDistance=110;gui.AlwaysOnTop=false;gui.Parent=p
    local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundColor3=slate;t.BackgroundTransparency=0.15
    t.TextColor3=Color3.fromRGB(244,229,193);t.TextSize=15;t.TextWrapped=true;t.Font=Enum.Font.Garamond;t.Text=text;t.Parent=gui
end
local function landmark(parent: Instance,p: any)
    local id,name,x,y,w,d,kind=p[1],p[2],p[3],p[4],p[5],p[6],p[7]
    local at=point(x,y)
    local model: Model
    if kind=="Square" or kind=="Market" then
        model=Instance.new("Model");model.Name=name;model.Parent=parent
        part(model,"Paving",Vector3.new(w*4,1,d*4),at,stone,true).Material=Enum.Material.Cobblestone
        if id==16 then
            for gx=-3,3 do for gz=-3,3 do
                part(model,"Headstone",Vector3.new(2,4,1),at+Vector3.new(gx*9,2,gz*9),stone,true)
            end end
        elseif kind=="Market" then
            for gx=-2,2 do for gz=-1,1 do
                local center=at+Vector3.new(gx*10,0,gz*13)
                part(model,"Market stall",Vector3.new(7,3,4),center+Vector3.yAxis*1.5,brick,true)
                part(model,"Canvas canopy",Vector3.new(8,.3,6),center+Vector3.yAxis*8,Color3.fromRGB(146,123,88),false)
            end end
        end
    else
        model=Architecture.Build(parent,{Id=id,Name=name,Kind=kind,Position=at,Width=w*4,Depth=d*4,Seed=id})
    end
    model:SetAttribute("MapId",id);model:SetAttribute("ApproximateLocation",id==68)
    model:SetAttribute("MapX",x);model:SetAttribute("MapY",y)
end
function City.Build(world: any)
    local parent=world.Folder
    parent:SetAttribute("Map","Tingen");parent:SetAttribute("North","-Z")
    parent:SetAttribute("UnnamedBuildingCount",#Plan.Buildings)
    for _,r in ipairs(Plan.Ground) do
        local ground=part(parent,"Riverbank ground",Vector3.new(r[3]*4,12,r[4]*4),point(r[1],r[2],-6.5),Color3.fromRGB(107,110,90),true)
        ground.Material=Enum.Material.Ground
    end
    for _,r in ipairs(Plan.Water) do
        local surface=part(parent,"River surface",Vector3.new(r[3]*4,.2,r[4]*4),point(r[1],r[2],-3),water,false)
        surface.Material=Enum.Material.Glass;surface.Transparency=.25;surface.Reflectance=.1
        part(parent,"Riverbed",Vector3.new(r[3]*4,1,r[4]*4),point(r[1],r[2],-10),slate,true)
    end
    for _,r in ipairs(Plan.Roads) do
        local a,b=point(r[1],r[2],0),point(r[3],r[4],0)
        line(parent,r[6].." pavement",a,b,(r[5]+1.2)*4,.6,stone)
        line(parent,r[6].." carriageway",a+Vector3.yAxis*.35,b+Vector3.yAxis*.35,r[5]*4,.25,slate).Material=Enum.Material.Cobblestone
    end
    local neighborhoods=Instance.new("Folder");neighborhoods.Name="Unnamed street frontage";neighborhoods.Parent=parent
    for index,r in ipairs(Plan.Buildings) do
        Architecture.Build(neighborhoods,{Name=r[6].." "..index,Kind=r[6],Position=point(r[1],r[2]),
            Width=r[3]*4,Depth=r[4]*4,Angle=r[5],Floors=r[7],Seed=index})
        if index%100==0 then task.wait() end
    end
    for _,p in ipairs(Plan.Plots) do landmark(parent,p) end
    for _,id in ipairs({66,67}) do
        local spec=Layout.Landmarks[id]
        local marker=part(parent,spec.Name,Vector3.one,point(spec.X,spec.Y),water,false)
        marker.Transparency=1;marker:SetAttribute("MapId",id);label(marker,spec.Name)
    end
    local spawn=Instance.new("SpawnLocation");spawn.Name="CivicSquareSpawn";spawn.Size=Vector3.new(8,1,8)
    spawn.Position=Vector3.new(0,1,0);spawn.Neutral=true;spawn.Duration=0;spawn.Transparency=1;spawn.Parent=parent
    for _,spec in ipairs(Theme.World.Services) do
        local desk=Art.ServiceBuilding(parent,spec)
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText=spec.Name;prompt.ObjectText="Civic Square services"
        prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.RequiresLineOfSight=true;prompt:SetAttribute("InteractionId",spec.Action);prompt.Parent=desk
        prompt.Triggered:Connect(function(player)
            local root=world:Root(player)
            if root and (root.Position-desk.Position).Magnitude<=Theme.Interaction.ServerDistance and world.OnInteraction then world.OnInteraction(player,spec.Action) end
        end)
    end
    -- Combat remains in reserved open yards; positions are gameplay additions, not canon.
    for index,tier in ipairs(world.Data.Runtime.EnemyTiers) do
        local yard=Plan.Yards[index]
        local at=point(yard[1],yard[2],0)
        part(parent,"Encounter yard",Vector3.new(80,1,70),at,stone,true)
        for offset=1,3 do table.insert(world.Spawns,{Position=at+Vector3.new((offset-2)*12,4,8),Tier=tier,Entity=nil,NextSpawn=0}) end
        if tier<=4 then
            local exposure=part(parent,"WhisperZone",Vector3.one,at+Vector3.yAxis*6,slate,false);exposure.Transparency=1
            Collection:AddTag(exposure,"MysticalExposure")
        end
    end
    for i=1,4 do
        local door=part(parent,"PracticeDoor",Vector3.new(4,7,1),Vector3.new(-35+i*14,3.5,35),brick,true)
        Collection:AddTag(door,"MysticDoor");Collection:AddTag(door,"MysteriesInteractable")
    end
    for _,spec in ipairs({{Name="Civic Square",X=655,Y=310},{Name="North Tingen",X=620,Y=115},{Name="West District",X=420,Y=350},{Name="University District",X=850,Y=365},{Name="Industrial District",X=660,Y=470}}) do
        local z=part(parent,spec.Name,Vector3.one,point(spec.X,spec.Y),stone,false);z.Transparency=1
        z:SetAttribute("VisualName",spec.Name);z:SetAttribute("Radius",100);Collection:AddTag(z,"MysteriesZone")
    end
    -- Bounded lamps along primary roads; infill has no individual point lights.
    for index,r in ipairs(Plan.Roads) do
        if r[6]=="Avenue" and index%2==0 then Art.Lamp(parent,point(r[1],r[2])) end
    end
    -- Railway runs north from the mapped station, away from city streets.
    for _,offset in ipairs({-3,3}) do line(parent,"Rail",point(581,29)+Vector3.new(offset,0.8,0),point(581,-45)+Vector3.new(offset,0.8,0),0.5,0.5,slate) end
    for y=-45,29,3 do part(parent,"Sleeper",Vector3.new(9,0.5,1),point(581,y,0.5),brick,true) end
    local lighting=game:GetService("Lighting")
    for _,spec in ipairs({{Class="Atmosphere",Name="MysteriesAtmosphere",Properties=Theme.World.Atmosphere},{Class="BloomEffect",Name="MysteriesBloom",Properties=Theme.World.Bloom}}) do
        local old=lighting:FindFirstChild(spec.Name);if old then old:Destroy() end
        local object=Instance.new(spec.Class :: any);object.Name=spec.Name
        for key,value in pairs(spec.Properties) do (object :: any)[key]=value end
        object.Parent=lighting
    end
    for key,value in pairs(Theme.World.Lighting) do (game:GetService("Lighting") :: any)[key]=value end
end
return City
