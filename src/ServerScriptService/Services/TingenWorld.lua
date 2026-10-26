--!strict
-- Geography follows the supplied settings-book plate; architecture/roads are interpretive.
local Shared=game:GetService("ReplicatedStorage").Shared
local Layout=require(Shared.TingenLayout)
local Theme=require(Shared.Theme)
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
local function landmark(parent: Instance,spec: any)
    local model=Instance.new("Model");model.Name=string.format("%02d · %s",spec.Id,spec.Name);model.Parent=parent
    model:SetAttribute("MapId",spec.Id);model:SetAttribute("ApproximateLocation",spec.Approximate)
    local at=point(spec.X,spec.Y)
    if spec.Kind=="River" then
        local marker=part(model,spec.Name,Vector3.one,at+Vector3.yAxis*4,water,false);marker.Transparency=1;label(marker,spec.Name);return
    end
    if spec.Kind=="Square" then
        local floor=part(model,spec.Name,Vector3.new(95,1,85),at,stone,true);floor.Material=Enum.Material.Cobblestone
        if spec.Id==16 then
            for x=-3,3 do for z=-2,2 do
                part(model,"Headstone",Vector3.new(3,5,1),at+Vector3.new(x*10,3,z*12),stone,true)
            end end
        end
        label(floor,spec.Name);return
    end
    local cathedral=spec.Kind=="Cathedral"
    local factory=spec.Kind=="Factory"
    local width=if cathedral then 52 elseif factory then 45 elseif spec.Kind=="College" then 48 else 28
    local depth=if cathedral then 65 else 30
    local height=if cathedral then 50 elseif factory then 22 else 24
    local color=if cathedral then stone elseif factory then brick else Color3.fromRGB(112+(spec.Id%4)*9,102+(spec.Id%3)*8,91)
    local function b(name: string,s: Vector3,p: Vector3,c: Color3,solid: boolean?): Part
        return part(model,name,s,at+p,c,solid)
    end
    b("Foundation",Vector3.new(width+4,1,depth+4),Vector3.zero,stone,true)
    for _,side in ipairs({-1,1}) do
        b("Brick wall",Vector3.new(1,height,depth),Vector3.new(side*width/2,height/2,0),color,true).Material=Enum.Material.Brick
        local front=(width-10)/2
        b("Entrance wall",Vector3.new(front,height,1),Vector3.new(side*(5+front/2),height/2,-depth/2),color,true).Material=Enum.Material.Brick
        for floor=0,1 do
            b("Window",Vector3.new(5,6,0.3),Vector3.new(side*(width/2-6),7+floor*11,-depth/2-0.6),Color3.fromRGB(207,180,120),false).Material=Enum.Material.Glass
        end
    end
    b("Door lintel",Vector3.new(10,height-12,1),Vector3.new(0,(height+12)/2,-depth/2),color,true)
    b("Rear wall",Vector3.new(width,height,1),Vector3.new(0,height/2,depth/2),color,true).Material=Enum.Material.Brick
    b("Cornice",Vector3.new(width+3,1,depth+3),Vector3.new(0,height,0),stone,true)
    b("Slate roof",Vector3.new(width+2,3,depth+2),Vector3.new(0,height+2,0),slate,true).Material=Enum.Material.Slate
    if cathedral then
        for _,side in ipairs({-1,1}) do
            b("Bell tower",Vector3.new(10,70,12),Vector3.new(side*(width/2-4),35,-depth/2+6),stone,true)
            b("Tower crown",Vector3.new(12,4,14),Vector3.new(side*(width/2-4),72,-depth/2+6),slate,true)
        end
    elseif factory then
        b("Chimney",Vector3.new(5,43,5),Vector3.new(width/2-4,22,depth/2-4),brick,true).Material=Enum.Material.Brick
    end
    local sign=b("Address",Vector3.new(8,2,0.4),Vector3.new(0,13,-depth/2-1),slate,false)
    label(sign,tostring(spec.Id).." · "..spec.Name..(if spec.Approximate then " (approximate site)" else ""))
end
function City.Build(world: any)
    local parent=world.Folder
    parent:SetAttribute("Map","Tingen");parent:SetAttribute("North","-Z")
    for x=0,3 do for z=0,3 do
        local ground=part(parent,"Tingen ground",Vector3.new(1000,8,800),point(540,340,-5)+Vector3.new((x-1.5)*1000,0,(z-1.5)*800),Color3.fromRGB(100,110,84),true)
        ground.Material=Enum.Material.Grass
    end end
    -- Navigable flat river surfaces are visual water; no Terrain mutation outside this world folder.
    local function river(name: string,points: {{number}},width: number)
        for i=2,#points do
            local a,b=points[i-1],points[i]
            local p=line(parent,name,point(a[1],a[2],-0.3),point(b[1],b[2],-0.3),width,0.4,water)
            p.Material=Enum.Material.Glass;p.Reflectance=0.12
        end
    end
    river("66 · Tussock River",{{25,267},{130,320},{220,410},{355,451},{445,500},{530,578},{650,580},{770,609},{860,700},{900,785}},120)
    river("67 · Khoy River",{{900,0},{880,75},{850,150},{843,193},{900,243},{953,324},{951,405},{887,450},{797,470},{766,560},{770,609}},36)
    local roads={
        {{345,110},{360,260},{425,325},{540,340},{655,310},{820,280},{934,314}},
        {{580,15},{578,130},{555,250},{550,390},{550,570}},
        {{360,355},{450,300},{520,265},{650,215},{790,210},{865,237}},
        {{390,405},{520,418},{680,430},{780,457},{923,420}},
        {{460,90},{485,230},{500,310},{530,490}},
        {{735,80},{730,200},{748,315},{775,390},{760,545}},
        {{340,180},{500,150},{650,160},{810,165}},
        {{600,520},{730,530},{775,545}},
    }
    for _,road in ipairs(roads) do for i=2,#road do
        local a,b=road[i-1],road[i]
        line(parent,"Pavement",point(a[1],a[2],0),point(b[1],b[2],0),32,0.5,stone)
        line(parent,"Carriageway",point(a[1],a[2],0.35),point(b[1],b[2],0.35),22,0.3,slate).Material=Enum.Material.Cobblestone
    end end
    -- Every plotted site has a walkable spur to the nearest road segment.
    for _,spec in ipairs(Layout.Landmarks) do
        if spec.Kind~="River" and spec.Id~=47 then
            local entry=point(spec.X,spec.Y-10,0.4)
            local best=Vector3.zero;local distance=math.huge
            for _,road in ipairs(roads) do for i=2,#road do
                local a,b=point(road[i-1][1],road[i-1][2],0.4),point(road[i][1],road[i][2],0.4)
                local d=b-a;local closest=a+d*math.clamp((entry-a):Dot(d)/d:Dot(d),0,1)
                if (entry-closest).Magnitude<distance then best=closest;distance=(entry-closest).Magnitude end
            end end
            if distance>1 then line(parent,"Access lane",entry,best,10,0.3,stone) end
        end
        if spec.Id==5 then
            for index,name in ipairs({"Veterans Club","Divination Club","Harrods Department Store"}) do
                local club=table.clone(spec);club.Name=name;club.Y=spec.Y+(index-2)*10
                landmark(parent,club)
            end
        else landmark(parent,spec) end
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
        local at=point(365+index*60,540,0)
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
    for _,road in ipairs(roads) do for _,p in ipairs(road) do Art.Lamp(parent,point(p[1]+5,p[2])) end end
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
