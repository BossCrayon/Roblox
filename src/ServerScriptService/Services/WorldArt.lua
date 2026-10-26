--!strict
-- Original native-part architecture. No assets, NPC statistics or authority live here.
local Collection=game:GetService("CollectionService")
local Lighting=game:GetService("Lighting")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local W=T.World
local K=W.Kit
local function size(values: {number}): Vector3 return Vector3.new(table.unpack(values)) end
local Art={}
function Art.Part(parent: Instance,name: string,size: Vector3,frame: CFrame,color: Color3,solid: boolean?): Part
    local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=frame;p.Color=color;p.Anchored=true
    p.Material=Enum.Material.SmoothPlastic;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
    p.CanCollide=solid==true;p.CanQuery=solid==true;p.CanTouch=false;p.CastShadow=solid==true;p.Parent=parent
    return p
end
local function block(parent: Instance,name: string,size: Vector3,position: Vector3,color: Color3,solid: boolean?): Part
    return Art.Part(parent,name,size,CFrame.new(position),color,solid)
end
function Art.Lamp(parent: Instance,at: Vector3)
    local h=W.Lamp.Height
    block(parent,"Iron lamp post",Vector3.new(K.LampPost,h,K.LampPost),at+Vector3.yAxis*h/2,T.Colors.Iron)
    local glass=block(parent,"Gas lamp",size(K.LampGlass),at+Vector3.yAxis*h,T.Colors.Warm)
    glass.Material=Enum.Material.Glass
    block(parent,"Lantern cap",size(K.LampCap),at+Vector3.yAxis*(h+0.7),T.Colors.Iron)
    local light=Instance.new("PointLight");light.Name="Gaslight";light.Color=T.Colors.Warm;light.Brightness=W.Lamp.Brightness
    light.Range=W.Lamp.Range;light.Shadows=false;light.Enabled=false;light.Parent=glass
    Collection:AddTag(glass,"MysteriesLamp");Collection:AddTag(glass,"FlameAnchor")
end
local function zone(parent: Instance,name: string,center: Vector3,radius: number,tier: number?)
    local z=block(parent,"Zone · "..name,Vector3.one,center,T.Colors.Ink)
    z.Transparency=1;z:SetAttribute("VisualName",name);z:SetAttribute("Radius",radius);z:SetAttribute("Sequence",tier)
    Collection:AddTag(z,"MysteriesZone")
end
local function building(parent: Instance,spec: any): Part
    local b=W.Building;local center=Vector3.new(spec.X,0,spec.Z)
    local f=CFrame.lookAt(center,Vector3.zero)
    local model=Instance.new("Model");model.Name=spec.Name.." architecture";model.Parent=parent
    local function piece(name: string,size: Vector3,pos: Vector3,color: Color3,solid: boolean?): Part
        return Art.Part(model,name,size,f*CFrame.new(pos),color,solid)
    end
    piece("Stone foundation",Vector3.new(b.Width,K.FoundationDepth,b.Depth),Vector3.new(0,0,b.Depth*0),T.Colors.Stone,true).Material=Enum.Material.Cobblestone
    for _,x in ipairs({-1,1}) do
        piece("Brick side",Vector3.new(b.Wall,b.Height,b.Depth),Vector3.new(x*b.Width/2,b.Height/2,0),T.Colors.Slate,true).Material=Enum.Material.Brick
        local side=(b.Width-b.DoorWidth)/2
        piece("Brick frontage",Vector3.new(side,b.Height,b.Wall),Vector3.new(x*(b.DoorWidth+side)/2,b.Height/2,-b.Depth/2),T.Colors.Slate,true).Material=Enum.Material.Brick
        piece("Arch jamb",Vector3.new(K.JambWidth,b.DoorHeight,K.JambDepth),Vector3.new(x*(b.DoorWidth/2+0.35),b.DoorHeight/2,-b.Depth/2),T.Colors.Stone)
        for floor=0,1 do
            local window=piece("Frosted amber window",size(K.Window),Vector3.new(x*(b.Width/2-4),5+floor*b.Storey,-b.Depth/2-0.55),T.Colors.Warm)
            window.Material=Enum.Material.Glass
        end
        for shelf=0,2 do
            local z=-4+shelf*5
            piece("Archive cabinet",size(K.Cabinet),Vector3.new(x*(b.Width/2-2),4,z),T.Colors.Wood,true)
            for row=1,3 do piece("Shelf brass edge",size(K.Shelf),Vector3.new(x*(b.Width/2-2),row*2,z),T.Colors.Gold) end
        end
    end
    piece("Entrance lintel",Vector3.new(b.DoorWidth,b.Height-b.DoorHeight,b.Wall),Vector3.new(0,(b.Height+b.DoorHeight)/2,-b.Depth/2),T.Colors.Slate,true)
    for _,side in ipairs({-1,1}) do
        local arch=piece("Pointed arch",Vector3.new(b.DoorWidth*0.65,K.ArchThickness,K.ArchDepth),Vector3.new(side*b.DoorWidth/4,b.DoorHeight,-b.Depth/2-0.5),T.Colors.Gold)
        arch.CFrame*=CFrame.Angles(0,0,math.rad(side*K.ArchAngle))
    end
    piece("Back wall",Vector3.new(b.Width,b.Height,b.Wall),Vector3.new(0,b.Height/2,b.Depth/2),T.Colors.Slate,true).Material=Enum.Material.Brick
    piece("Slate roof",Vector3.new(b.Width+2,b.RoofHeight,b.Depth+2),Vector3.new(0,b.Height+b.RoofHeight/2,0),T.Colors.Iron,true).Material=Enum.Material.Slate
    piece("Cornice",Vector3.new(b.Width+1,0.5,b.Depth+1),Vector3.new(0,b.Height,0),T.Colors.Stone)
    local desk=Art.Part(parent,spec.Name,size(K.Desk),f*CFrame.new(0,1.5,-4),T.Colors.Wood,true)
    desk:SetAttribute("VisualName",spec.Name);Collection:AddTag(desk,"MysteriesInteractable")
    piece("Brass desk rim",size(K.DeskRim),Vector3.new(0,3.1,-4),T.Colors.Gold)
    if spec.Action=="Buy" then
        for i,path in ipairs({"Seer","Marauder","Apprentice"}) do
            local bottle=piece("Original potion vessel",size(K.Bottle),Vector3.new((i-2)*1.5,3.8,-4),T.CharacterArt.Trim[path])
            bottle.Material=Enum.Material.Glass
            piece("Potion stopper",size(K.Stopper),Vector3.new((i-2)*1.5,4.5,-4),T.Colors.Gold)
        end
    else
        for i=-1,1 do piece("Closed unmarked folio",size(K.Book),Vector3.new(i*1.5,3.4,-4),T.Colors.DeepPurple) end
    end
    Art.Lamp(model,(f*CFrame.new(b.DoorWidth/2+2,0,-b.Depth/2-3)).Position)
    return desk
end
Art.ServiceBuilding=building
function Art.Build(world: any)
    local parent=world.Folder
    local ground=block(parent,"TrainingGround",Vector3.new(W.Ground,K.GroundDepth,W.Ground),Vector3.new(0,-2,0),T.Colors.Stone,true)
    ground.Material=Enum.Material.Cobblestone;ground.Reflectance=K.Reflectance
    block(parent,"Sanctuary Square",Vector3.new(W.Hub,K.HubDepth,W.Hub),Vector3.zero,T.Colors.Slate,true).Material=Enum.Material.Cobblestone
    local spawn=Instance.new("SpawnLocation");spawn.Name="SanctuarySpawn";spawn.Size=size(K.SpawnSize);spawn.Position=Vector3.new(0,0.5,0)
    spawn.Neutral=true;spawn.Duration=0;spawn.Transparency=1;spawn.Parent=parent
    zone(parent,"Sanctuary Square",Vector3.zero,W.Zone.HubRadius,nil)
    local tower=W.Tower
    block(parent,"Clock tower",Vector3.new(tower.Width,tower.Height,tower.Width),Vector3.new(0,tower.Height/2,-W.Hub/2+8),T.Colors.Slate,true).Material=Enum.Material.Brick
    local clock=block(parent,"Unlettered clock face",Vector3.new(tower.ClockSize,tower.ClockSize,K.ClockFaceDepth),Vector3.new(0,tower.Height-10,-W.Hub/2+8+tower.Width/2+0.2),T.Colors.Text)
    for i,length in ipairs(tower.Hands) do
        local hand=block(parent,"Clock hand",Vector3.new(K.ClockHandWidth,length,K.ClockHandDepth),clock.Position+Vector3.new(0,length/2,0.2),T.Colors.Iron)
        hand.CFrame=CFrame.new(clock.Position+Vector3.zAxis*0.2)*CFrame.Angles(0,0,math.rad(if i==1 then -60 else 120))*CFrame.new(0,length/2,0)
    end
    for _,spec in ipairs(W.Services) do
        local desk=building(parent,spec)
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText=if spec.Action=="Buy" then "Open potion altar" else spec.Name
        prompt.ObjectText=spec.Name;prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.RequiresLineOfSight=true;prompt:SetAttribute("InteractionId",spec.Action);prompt.Parent=desk
        prompt.Triggered:Connect(function(player)
            local root=world:Root(player)
            if root and (root.Position-desk.Position).Magnitude<=T.Interaction.ServerDistance and world.OnInteraction then world.OnInteraction(player,spec.Action) end
        end)
    end
    for index,tier in ipairs(world.Data.Runtime.EnemyTiers) do
        local angle=(index-1)*math.pi/3
        local center=Vector3.new(math.cos(angle)*W.ArenaRadius,0,math.sin(angle)*W.ArenaRadius)
        local sizes=W.ArenaSizes[tier];local frame=CFrame.lookAt(center,Vector3.zero)
        local road=CFrame.lookAt(center/2,center)
        Art.Part(parent,"Carriageway",Vector3.new(W.Road,K.RoadDepth,W.ArenaRadius),road,T.Colors.Iron,true).Material=Enum.Material.Cobblestone
        for _,side in ipairs({-1,1}) do
            Art.Part(parent,"Pavement",Vector3.new(W.Pavement,K.PavementDepth,W.ArenaRadius),road*CFrame.new(side*(W.Road+W.Pavement)/2,0,0),T.Colors.Stone,true)
            for distance=W.Hub/2,W.ArenaRadius-sizes[2]/2,W.Lamp.Spacing do
                local at=(CFrame.lookAt(Vector3.zero,center)*CFrame.new(side*(W.Road/2+W.Pavement),0,-distance)).Position
                Art.Lamp(parent,at)
            end
            for n=-1,1 do
                local at=(frame*CFrame.new(side*(sizes[1]/2-1),0,n*sizes[2]/3)).Position
                block(parent,"Arena buttress",size(if tier<=2 then K.HighButtress else K.Buttress),at+Vector3.yAxis*(if tier<=2 then 10 else 6),T.Colors.Stone,true)
            end
        end
        Art.Part(parent,"Arena terrace · "..tier,Vector3.new(sizes[1],K.ArenaDepth,sizes[2]),frame,T.Colors.Slate,true).Material=Enum.Material.Slate
        zone(parent,W.Zones[tier],center,math.min(sizes[1],sizes[2])/2,tier)
        if tier<=4 then
            local z=block(parent,"WhisperZone",size(K.Exposure),center+Vector3.yAxis*6,T.Colors.DeepPurple)
            z.Transparency=1;z:SetAttribute("Radius",world.Data.Runtime.ExposureRadius);Collection:AddTag(z,"MysticalExposure")
        end
        for _,x in ipairs({-24,24}) do
            for _,z in ipairs({-24,24}) do Art.Lamp(parent,(frame*CFrame.new(x,0,z)).Position) end
        end
        -- Preserve real enemy tiers/statistics and the original three spawn offsets.
        for offset=1,3 do table.insert(world.Spawns,{Position=center+Vector3.new((offset-2)*12,4,8),Tier=tier,Entity=nil,NextSpawn=0}) end
        -- Large background arches stay outside the combat lane; two approaches stay clear.
        if tier<=2 then
            for _,side in ipairs({-1,1}) do
                Art.Part(parent,"Distant arch pier",size(K.DistantPier),frame*CFrame.new(side*20,15,sizes[2]/2+6),T.Colors.Stone,true)
            end
            Art.Part(parent,"Distant arch crown",size(K.DistantCrown),frame*CFrame.new(0,30,sizes[2]/2+6),T.Colors.Stone,true)
        end
    end
    for i=1,4 do
        local x=-35+i*14
        local door=block(parent,"PracticeDoor",size(K.PracticeDoor),Vector3.new(x,3.5,-30),T.Colors.Wood,true)
        door:SetAttribute("VisualName","Sealed practice passage");Collection:AddTag(door,"MysticDoor");Collection:AddTag(door,"MysteriesInteractable")
        for _,side in ipairs({-1,1}) do block(parent,"Practice door jamb",size(K.PracticeJamb),Vector3.new(x+side*2.5,4,-30),T.Colors.Stone,true) end
    end
    for key,value in pairs(W.Lighting) do (Lighting :: any)[key]=value end
    for _,spec in ipairs({{Class="Atmosphere",Name="MysteriesAtmosphere",Properties=W.Atmosphere},
        {Class="BloomEffect",Name="MysteriesBloom",Properties=W.Bloom}}) do
        local old=Lighting:FindFirstChild(spec.Name);if old then old:Destroy() end
        local object=Instance.new(spec.Class :: any);object.Name=spec.Name
        for key,value in pairs(spec.Properties) do (object :: any)[key]=value end
        object.Parent=Lighting
    end
    -- LightingStyle/Technology remain Studio properties; no restricted runtime assignment.
end
return Art
