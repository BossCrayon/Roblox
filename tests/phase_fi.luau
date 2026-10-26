--!strict
-- Runs the actual F–I adapters with explicit engine stand-ins; no rendered certification.
return function(data: any,load: any,shared: any,e: any)
    local checks=0
    local function check(value,message) assert(value,message);checks+=1 end
    local env=table.clone(e.Env);local instance=e.Instance;local v=e.Vector;local cf=e.Frame
    local now=1000;e.SetTime(now);e.SetQuality(10);e.Input.TouchEnabled=false;e.Camera.Mode="All";e.Camera.CFrame=cf()
    local tags={};local lighting=instance("Lighting");local scheduled={};local studio=true
    local players={LocalPlayer={UserId=1},List={}}
    function players:GetPlayers() return self.List end
    function players:GetPlayerByUserId(id) for _,player in ipairs(self.List) do if player.UserId==id then return player end end;return nil end
    local collection={}
    function collection:AddTag(object,tag) tags[tag]=tags[tag] or {};table.insert(tags[tag],object) end
    function collection:GetTagged(tag) return tags[tag] or {} end
    local function signal() return {Connect=function() return {Disconnect=function() end} end,Once=function() end} end
    local services={ReplicatedStorage={Shared=shared},CollectionService=collection,Lighting=lighting,Players=players,
        UserInputService=e.Input,Debris={AddItem=function() end},RunService={IsStudio=function() return studio end},
        HttpService={JSONEncode=function() return "fixture report" end},TweenService={Create=function(_,object,_info,props)
            return {Play=function() for key,value in pairs(props) do object[key]=value end end,Completed=signal()}
        end}}
    env.game={GetService=function(_,key) return assert(services[key],key) end}
    env.UDim={new=function(scale,offset) return {Scale=scale,Offset=offset} end}
    env.UDim2={new=function(xs,xo,ys,yo) return {X={Scale=xs,Offset=xo},Y={Scale=ys,Offset=yo}} end}
    env.UDim2.fromOffset=function(x,y) return env.UDim2.new(0,x,0,y) end
    env.UDim2.fromScale=function(x,y) return env.UDim2.new(x,0,y,0) end
    local two={}
    local function v2(x,y) return setmetatable({X=x,Y=y},two) end
    two.__sub=function(a,b) return v2(a.X-b.X,a.Y-b.Y) end
    env.Vector2={new=v2,zero=v2(0,0)}
    env.TweenInfo={new=function(...) return {...} end}
    env.task={delay=function(seconds,fn) table.insert(scheduled,{At=now+seconds,Run=fn}) end}
    env.RaycastParams={new=function() return {} end}
    env.workspace.GetServerTimeNow=function() return now end
    env.workspace.Raycast=function() return nil end
    local cm={}
    function cm:Lerp(other,t) return setmetatable({R=self.R+(other.R-self.R)*t,G=self.G+(other.G-self.G)*t,B=self.B+(other.B-self.B)*t},{__index=cm}) end
    env.Color3={fromRGB=function(r,g,b) return setmetatable({R=r/255,G=g/255,B=b/255},{__index=cm}) end}
    local T=load("Theme",env);load("Client/UI/Kit",env)
    env.task.wait=function() end
    load("Server/Services/WorldArt",env)
    load("Server/Services/TingenArchitecture",env)
    local world={Folder=instance("Folder"),Spawns={},Data=data}
    load("Server/Services/TingenWorld",env).Build(world)
    check(#world.Spawns==18,"Expanded world retains eighteen real spawn records")
    check(world.Folder:FindFirstChild("CivicSquareSpawn").Position.Magnitude<=1,"Sanctuary spawn retains the original origin")
    local layout=load("TingenLayout",env)
    check(#layout.Landmarks==68,"All 67 reference entries and missing cathedral are included")
    local seen={}
    for _,item in ipairs(world.Folder:GetDescendants()) do
        local id=item:GetAttribute("MapId")
        if id then seen[id]=(seen[id] or 0)+1 end
    end
    for i=1,68 do check(seen[i]==(if i==5 then 3 else 1),"Every landmark is built once; entry 5 includes three businesses") end
    check(layout.Landmarks[68].Approximate and layout.Landmarks[68].Y<layout.OriginY,"Missing cathedral remains explicitly approximate and northern")
    local plan=load("TingenPlan",env)
    check(#plan.Buildings>=1000,"Known locations are embedded in a populated city, not isolated on empty ground")
    check(world.Folder:GetAttribute("UnnamedBuildingCount")==#plan.Buildings,"Runtime builds every planned street-front parcel")
    local cathedral,daffodil,blackthorn
    for _,model in ipairs(world.Folder:GetDescendants()) do
        if model:GetAttribute("MapId")==18 then cathedral=model end
        if model:GetAttribute("MapId")==11 then daffodil=model end
        if model:GetAttribute("MapId")==20 then blackthorn=model end
    end
    check(cathedral and cathedral:FindFirstChild("Black clock tower") and cathedral:FindFirstChild("Stained glass"),"Saint Selena has its documented central dark tower and stained glass")
    check(daffodil and daffodil:FindFirstChild("Balcony rail") and daffodil:FindFirstChild("Upper floor"),"Daffodil terrace retains two storeys and balcony")
    check(blackthorn and blackthorn:FindFirstChild("Reception desk") and blackthorn:FindFirstChild("Arched window frame"),"Earlier Blackthorn office has paired arch frames and upstairs reception")
    local parts=0;local prompts=0
    for _,object in ipairs(world.Folder:GetDescendants()) do
        if object:IsA("BillboardGui") then check(object.MaxDistance<=110,"Landmark labels are distance bounded") end
        if object:IsA("BasePart") then
            parts+=1
            check(object.Size.X>0 and object.Size.Y>0 and object.Size.Z>0,"Construction has positive finite dimensions")
            check(object.Size.X<=2048 and object.Size.Y<=2048 and object.Size.Z<=2048,"Parts respect Roblox size limits")
        end
        if object:IsA("ProximityPrompt") then prompts+=1 end
        if object:IsA("PointLight") then check(not object.Enabled and not object.Shadows,"Practical lights start disabled/unshadowed for local bounded selection") end
    end
    print("Tingen parts:",parts,"prompts:",prompts)
    check(parts<60000 and prompts==4,"City geometry is bounded and retains all four server prompts")
    for _,spec in ipairs(T.World.Services) do
        local object=world.Folder:FindFirstChild(spec.Name)
        check(object and object.CanCollide and object:GetAttribute("VisualName")==spec.Name,"Services retain exact authoritative lookup names")
    end
    for _,spawn in ipairs(world.Spawns) do
        check(spawn.Position.Magnitude<data.Runtime.WorldRadius,"Relocated spawns remain inside server travel bounds")
        check(table.find(data.Runtime.EnemyTiers,spawn.Tier)~=nil,"Relayout never changes enemy tiers")
    end
    check(#tags.MysticDoor==4 and #tags.FlameAnchor>=24,"Practice doors and real arena flame anchors remain tagged")
    check(lighting.ClockTime==T.World.Lighting.ClockTime,"Native lighting uses the Art Bible profile")
    -- Player outfits: all pathways/sequences, R6/R15, Incomplete/Complete Mythical Creature Forms, and disguise cleanup.
    local Service=load("Client/Visuals/VfxService",env);local Blocks=load("Client/Visuals/EffectBlocks",env)
    local service=Service.new();local blocks=Blocks.new(service)
    local Outfit=load("Client/Visuals/CharacterArt",env);local outfits=Outfit.new(service,blocks)
    local function avatar(id,rig,x)
        local character=instance("Model");local root=instance("Part");root.Name="HumanoidRootPart";root.CFrame=cf(x,4,0);root.Parent=character
        local torso=instance("Part");torso.Name=if rig=="R15" then "UpperTorso" else "Torso";torso.Size=v(2,2,1);torso.Parent=character
        local head=instance("Part");head.Name="Head";head.Size=v(2,1,1);head.Parent=character
        local hum=instance("Humanoid");hum.Health=100;hum.MaxHealth=100;hum.Parent=character
        character.PrimaryPart=root
        local player={UserId=id,Character=character};table.insert(players.List,player);return player,torso
    end
    for _,rig in ipairs({"R6","R15"}) do
        local player,torso=avatar(1,rig,10);players.LocalPlayer=player
        local original=torso.Color
        for _,path in ipairs({"Seer","Marauder","Apprentice"}) do
            for seq=9,1,-1 do
                local character=player.Character
                character:SetAttribute("MysteriesPathway",path);character:SetAttribute("MysteriesSequence",seq)
                character:SetAttribute("MysteriesMythicalForm","")
                outfits:Step(0.3)
                local record=outfits.Records[character];check(record~=nil and record.Mythical=="","Outfit exists for every pathway/sequence and both rigs")
                local count=0
                for _,part in ipairs(record.Model:GetDescendants()) do
                    if part:IsA("BasePart") then count+=1;check(not part.CanCollide and not part.CanQuery and part.Massless,"Outfit cannot change collision/aiming/rig mass") end
                end
                check(count<=T.CharacterArt.MaxParts and torso.Color==original,"Outfit cap preserves original body appearance data")
                if seq<=4 then
                    for _,stage in ipairs({"Incomplete","Complete"}) do
                        character:SetAttribute("MysteriesMythicalForm",stage);outfits:Step(0.3)
                        local mythRecord=outfits.Records[character]
                        check(mythRecord~=nil and mythRecord.Mythical==stage,"Mythical Creature Form builds for "..path.." "..stage)
                        local mythCount=0
                        for _,part in ipairs(mythRecord.Model:GetDescendants()) do
                            if part:IsA("BasePart") then mythCount+=1;check(not part.CanCollide and not part.CanQuery and part.Massless,"Mythical Creature parts stay massless and non-colliding") end
                        end
                        check(mythCount<=T.CharacterArt.MaxParts and torso.Color==original,"Mythical Creature assembly respects MaxParts and preserves body color")
                        if path=="Seer" and stage=="Complete" then
                            check(torso.LocalTransparencyModifier==1,"Complete Fool hides the original body locally")
                        end
                        check(mythRecord.Scale==(if stage=="Complete" then T.CharacterArt.Mythical.CompleteScale else T.CharacterArt.Mythical.IncompleteScale),"Mythical scale follows stage tuning")
                        check(mythRecord.Lift>0,"Mythical presentation floats above the physical rig")
                        check(player.Character.PrimaryPart.Position.Y==4,"Giant form never levitates the authoritative root")
                        local fixedCount=#mythRecord.Model:GetDescendants()
                        for _=1,8 do outfits:Step(0.08) end
                        check(#mythRecord.Model:GetDescendants()==fixedCount,"Idle transformation motion allocates no instances")
                        for _,motion in ipairs(mythRecord.Motions) do
                            check(motion.Part.Transparency>=0 and motion.Part.Transparency<=1,"Transformation reveal/pulse stays within valid alpha")
                            check(motion.Weld.Part1==motion.Part and motion.Weld.Part0~=nil,"Motion only drives a cosmetic weld")
                        end
                        if path=="Marauder" and stage=="Complete" then
                            check(#mythRecord.Faces==2,"Phantom clock has two bounded occluded faces")
                            for _,face in ipairs(mythRecord.Faces) do
                                check(#face:GetDescendants()==T.CharacterArt.Mythical.ClockSegments,"Clock actually contains twelve visible divisions per face")
                                check(not face.AlwaysOnTop,"Clock face never renders through walls")
                            end
                        end
                        service:SetSettings(true,true);outfits:Step(0.3)
                        local quiet=mythRecord.Motions[1].Part.Transparency;outfits:Step(0.3)
                        check(mythRecord.Motions[1].Part.Transparency==quiet,"Reduced Motion/Low Graphics disables idle pulsing")
                        service:SetSettings(false,false)

                    end
                    character:SetAttribute("MysteriesMythicalForm","");outfits:Step(0.3)
                    check(torso.LocalTransparencyModifier==0,"Form expiry restores original body visibility")
                    check(outfits.Records[character].Mythical=="","Expiring Mythical Creature Form restores base Victorian outfit")
                end
                character:SetAttribute("MysteriesDisguised",true);outfits:Step(0.3)
                check(not outfits.Records[character],"Disguise removes cosmetic outfit without interfering with server identity")
                character:SetAttribute("MysteriesDisguised",false)
            end
        end
        outfits:Clear(player.Character);players.List={}
    end
    for id=1,12 do local p=avatar(id,"R15",id);p.Character:SetAttribute("MysteriesPathway","Seer");p.Character:SetAttribute("MysteriesSequence",9) end
    outfits:Step(0.3);local count=0;for _ in pairs(outfits.Records) do count+=1 end
    check(count==T.CharacterArt.MaxPlayers,"Nearby outfit assemblies have a global player cap")
    outfits:Destroy();service:Step(5)
    -- Server attack observation cannot delay attacks or mutate health/resources.
    local World=load("Server/Services/WorldService",env)
    local player=players.List[1];players.LocalPlayer=player
    local root=instance("Part");root.CFrame=cf(3,4,0)
    local model=instance("Model");root.Parent=model;model.PrimaryPart=root
    local hum=instance("Humanoid");hum.Health=100;hum.MaxHealth=100;hum.Parent=model
    local enemy={Model=model,Root=root,Humanoid=hum,LastAttack=now-1,LastSpell=now-5,Tier=5,Statuses={}}
    local observer=setmetatable({Data=data,Root=function() return player.Character.PrimaryPart end,LineOfSight=function() return true end},{__index=World})
    observer:Threat(enemy,player,false,now)
    check(enemy.LastAttack==now-1 and hum.Health==100,"Threat observation preserves authoritative attack clock and health")
    check(model:GetAttribute("VisualThreatUserId")==player.UserId,"Threat identity is selected by the server")
    check(model:GetAttribute("VisualMeleeDue")==now+0.5,"Warning time derives from the unchanged melee interval")
    observer:Threat(enemy,nil,true,now)
    check(model:GetAttribute("VisualThreatUserId")==0,"Blocked/no target removes threat eligibility")
    -- All six enemy silhouettes, bounded health widgets and culling restoration.
    local Enemies=load("Client/Visuals/EnemyPresentation",env)
    local enemies=Enemies.new(service,blocks,data.Runtime,function() end)
    tags.Enemy={}
    for i,tier in ipairs(data.Runtime.EnemyTiers) do
        local m=instance("Model");local r=instance("Part");r.Name="HumanoidRootPart";r.CFrame=cf(i+3,4,0);r.Parent=m;m.PrimaryPart=r
        local body=instance("Part");body.Name="Torso";body.Parent=m
        local h=instance("Humanoid");h.Health=100;h.MaxHealth=100;h.Parent=m
        m:SetAttribute("VisualTier",tier);table.insert(tags.Enemy,m)
    end
    enemies:Step(0.1)
    for _,m in ipairs(tags.Enemy) do
        local r=enemies.Records[m];check(r~=nil and #r.Parts<=T.EnemyArt.MaxParts,"Every arena tier gets an original bounded silhouette")
        for _,part in ipairs(r.Parts) do check(not part.Part.CanQuery and not part.Part.CanCollide,"Enemy artwork cannot enlarge real targeting/collision") end
    end
    check(enemies.BarCount<=T.EnemyArt.MaxBars,"Enemy health widgets use a bounded pool")
    local m=tags.Enemy[1];m:SetAttribute("VisualThreatUserId",player.UserId);m:SetAttribute("VisualMeleeDue",now+0.5)
    enemies:Step(0.1);service:Step(0.1)
    check(enemies.Records[m].Cue and enemies.Records[m].Cue.Active,"Imminent server-scheduled melee gets an admitted ground fill")
    m:SetAttribute("VisualThreatUserId",0);enemies:Step(0.1)
    check(not enemies.Records[m].Cue,"Loss of server eligibility cancels warning")
    e.Camera.CFrame=cf(1000,0,0);enemies:Step(0.1)
    check(next(enemies.Records)==nil and m:FindFirstChild("Torso").LocalTransparencyModifier==0,"Distance culling frees silhouettes and restores actual proxy presentation")
    enemies:Destroy();e.Camera.CFrame=cf();service:Step(5)
    -- Real world-view adapter: bounded lights/labels, occlusion/modal suppression, accessibility and cleanup.
    local WorldView=load("Client/Visuals/WorldPresentation",env)
    local gui=instance("Frame");gui.AbsolutePosition=v2(0,0);gui.AbsoluteSize=v2(1920,1080)
    local modal=false
    local view=WorldView.new(gui,{VFX=service,Blocks=blocks},{Modal=function() return modal end,Prompt=function() return nil end,Exclusions=function() return {} end})
    local layout=load("VisualLayout",{}).Resolve(T,1920,1080,false);view:Resize(layout)
    local oldProjection=e.Camera.WorldToViewportPoint
    e.Camera.WorldToViewportPoint=function() return {X=600,Y=500,Z=1},true end
    local nearby=instance("Part");nearby.CFrame=cf(10,4,0);nearby:SetAttribute("VisualName","Reading desk")
    tags.MysteriesInteractable={nearby};view:Scan();view:Step(0.3)
    local enabled=0;for _,lamp in ipairs(tags.MysteriesLamp) do if lamp.Gaslight.Enabled then enabled+=1 end end
    check(enabled<=T.World.Lamp.DesktopMax,"Local practical lights obey the visible desktop cap")
    check(view.Labels[1].Visible and view.Labels[1].Text=="Reading desk","Compact nearby landmark label projects from server metadata")
    modal=true;view:Step(0.3)
    check(not view.Labels[1].Visible and not view.Compass.Visible,"Modal suppresses world labels and compass")
    modal=false
    env.workspace.Raycast=function() return {Instance=instance("Part")} end
    view:Step(0.3);check(not view.Labels[1].Visible,"An actual ray obstruction hides a landmark label")
    env.workspace.Raycast=function() return nil end
    view:SetSettings(true,true);view:Step(0.3)
    enabled=0;for _,lamp in ipairs(tags.MysteriesLamp) do
        if lamp.Gaslight.Enabled then enabled+=1;check(lamp.Gaslight.Brightness==T.World.Lamp.Brightness,"Reduced Motion removes lamp flicker") end
    end
    check(enabled<=T.World.Lamp.LowMax and not lighting.MysteriesBloom.Enabled,"Low Graphics limits lights and disables bloom")
    view:Destroy()
    enabled=0;for _,lamp in ipairs(tags.MysteriesLamp) do if lamp.Gaslight.Enabled then enabled+=1 end end
    check(enabled==0 and lighting:FindFirstChild("MysteriesWorldGrade")==nil,"World-view teardown disables owned lights and removes grade")
    e.Camera.WorldToViewportPoint=oldProjection
    service:Step(5)
    -- Local stress: peak cap, overfill rejection, drain and Studio-only guard.
    local Probe=load("Client/Visuals/PerformanceProbe",env)
    local probe=Probe.new(service,blocks)
    studio=false;check(not probe:Start(v(10,0,0),"Seer"),"Stress harness cannot start in published clients")
    studio=true
    for _,mobile in ipairs({false,true}) do
        e.Input.TouchEnabled=mobile;service:Profile()
        check(probe:Start(v(10,0,0),"Seer"),"Studio stress begins locally")
        check(not probe:Start(v(10,0,0),"Seer"),"Duplicate stress run is rejected")
        for _=1,132 do now+=0.1;e.SetTime(now);service:Step(0.1);probe:Step(0.1) end
        local report=probe.Last
        check(not probe.Running and report.Samples<=T.QA.Samples,"Stress ends without an unbounded frame history")
        check(report.Peak<=report.Cap and report.PoolsBounded and report.Errors==0,"Stress stays inside actual active/pool caps")
        check(report.Dropped>0 and report.Attempts>report.Cap,"Stress really requests overfill and exercises admission")
        check(report.Active==0 and report.Reserved==0,"Drain returns local test reservations to zero")
    end
    probe:Cancel();service:Step(5)
    -- Exercise the real coordinator (previous tests bypassed the melee/ultimate wiring).
    load("Client/Visuals/HitPresentation",env)
    local Presentation=load("Client/UI/Presentation",env)
    local C=load("VfxConfig",env)
    local kicks=0;local holds=0;local specs=nil
    local coordinator=setmetatable({VFX=service,Callbacks={},
        Blocks={Compose=function(_,layers,tier,priority,life)
            specs=layers;return blocks:Compose(layers,tier,priority,life)
        end},
        Camera={Kick=function() kicks+=1 end,HitStop=function() holds+=1 end},
        Controller=function() return {Play=function() end} end,
    },{__index=Presentation})
    for _,mobile in ipairs({false,true}) do
        e.Input.TouchEnabled=mobile
        for _,reduced in ipairs({false,true}) do
            service:SetSettings(reduced,mobile)
            for _,path in ipairs({"Seer","Marauder","Apprentice"}) do
                for _,combo in ipairs({1,2}) do
                    coordinator:Event({Kind="Melee",Position=v(12,4,0),Origin=v(10,4,0),Direction=v(0,0,-1),Combo=combo,
                        PathwayId=path,Owner=players.LocalPlayer.UserId,Target=nearby})
                    check(specs[1].Options.EndPosition~=nil and specs[1].Options.TargetPosition==nil,"Melee wires its actual endpoint using real tuning names")
                    service:Step(0.1);service:Step(1)
                    check(service:Stats().Errors==0,"Melee composition builds/releases at every quality")
                end
                local destination=v(18,4,-8)
                coordinator:Event({Kind="Dash",Position=destination,Origin=v(10,4,0),Destination=destination,PathwayId=path,Owner=1})
                check(specs[1].Options.EndPosition==destination,"Coordinator passes authoritative dash endpoint")
                service:Step(0.2);service:Step(1)
                for _,stage in ipairs({"Incomplete","Complete"}) do
                    local previousKicks=kicks;local previousHolds=holds
                    coordinator:Event({Kind="UltimateVisual",Position=v(10,4,0),Stage=stage,PathwayId=path,Owner=players.LocalPlayer.UserId})
                    local expected=if path=="Seer" and stage=="Complete" then "SpiritVortex" elseif path=="Seer" then "Worm" elseif path=="Marauder" then "Clock" else "Arch"
                    check(specs[2].Options.Glyph==expected,"Transformation selects its pathway glyph, never the fallback eye")
                    check(service:Stats().Active==1 and #specs<=C.Composition.MaxLayers,"Entire ultimate reserves one bounded composition")
                    check(kicks==previousKicks,"Ultimate camera cue waits for release")
                    service:Step(C.Ultimate.Release)
                    check(kicks==previousKicks+1 and holds==previousHolds+1,"Ultimate release drives one cosmetic camera/pose hold")
                    service:Step(0.4);service:Step(0.4);service:Step(2)
                    check(service:Stats().Errors==0 and service:Stats().Active==0 and service:Stats().Reserved.Part==0,
                        "All ultimate beats build within reservations and fully drain")
                end
            end
        end
    end
    -- City travel: execute real authorization and relocation with engine adapters.
    local registry=load("CityDestinations",env)
    local travel=load("Server/Services/CityTravel",env)
    local Domain=load("Server/Domain/PlayerDomain",env);local domain=Domain.new(data)
    local st=domain:NewState(domain:Default(),0)
    local destination=registry.Entries[1].Id
    check(#registry.Entries==70,"Every named site, including grouped businesses and riverbank arrivals, is selectable")
    check(not travel.Check(domain,st,destination,100),"Non-Door travel denied")
    st.Profile.PathwayId="Apprentice";st.Spirituality=50
    for sequence=1,9 do st.Profile.Sequence=sequence;check(travel.Check(domain,st,destination,100),"Door travel available at every requested sequence") end
    for _,id in ipairs({"unknown",{},3,string.rep("x",30)}) do check(not travel.Check(domain,st,id,100),"Forged destination rejected") end
    st.Dead=true;check(not travel.Check(domain,st,destination,100),"Dead travel denied");st.Dead=false
    st.Pending={};check(not travel.Check(domain,st,destination,100),"Pending cast prevents travel");st.Pending=nil
    for _,status in ipairs({"Silenced","Stasis","Sleep"}) do
        st.Statuses[status]={ExpiresAt=200};check(not travel.Check(domain,st,destination,100),"Control effects block travel");st.Statuses={}
    end
    st.Spirituality=0;check(not travel.Check(domain,st,destination,100),"Resource requirement enforced");st.Spirituality=50
    local root=instance("Part");root.CFrame=cf(0,4,0)
    local moves=0;local character={PivotTo=function(_,frame) root.CFrame=frame;moves+=1 end}
    local traveler={Character=character}
    local blocked=true
    local adapter={Transient=instance("Folder"),Root=function() return root end,Humanoid=function() return {Health=100} end,
        SafeDestination=function(_,_,position) return if blocked then nil else position+v(0,4,0) end}
    check(not travel.Go(adapter,domain,traveler,st,destination,100),"Blocked arrival rejected")
    check(st.Spirituality==50 and not st.Cooldowns.CityTravel and moves==0,"Failed travel consumes nothing and never moves")
    blocked=false
    check(travel.Go(adapter,domain,traveler,st,destination,100),"Valid Door travel succeeds")
    check(moves==1 and st.Spirituality==40 and st.Cooldowns.CityTravel==105 and st.TeleportGraceUntil==103,"Successful travel charges once and grants movement grace")
    check(not travel.Go(adapter,domain,traveler,st,destination,101) and moves==1,"Repeated request cannot bypass cooldown")
    -- Exercise the real map controller with GUI signal stand-ins.
    local function event()
        local handlers={}
        return {Connect=function(_,fn) table.insert(handlers,fn);return {Disconnect=function() end} end,
            Fire=function(_,...) for _,fn in ipairs(handlers) do fn(...) end end}
    end
    local guiEnv=table.clone(env)
    guiEnv.Instance={new=function(class)
        local object=instance(class);object.AbsoluteSize={X=900,Y=600}
        for _,key in ipairs({"Activated","MouseEnter","MouseLeave","InputBegan","SelectionGained","SelectionLost"}) do object[key]=event() end
        object.GetPropertyChangedSignal=function() return event() end
        return object
    end}
    local input={InputChanged=event(),InputEnded=event()}
    guiEnv.game={GetService=function(_,key) return if key=="UserInputService" then input else services[key] end}
    load("Client/UI/Kit",guiEnv)
    local CityMap=load("Client/UI/CityMap",guiEnv)
    local sent={};local isModal=false
    local map=CityMap.new(instance("Frame"),function(action,payload) table.insert(sent,{Action=action,Payload=payload}) end,function(open) isModal=open end)
    map:Update({Ready=true,Dead=false,PathwayId="Seer"});map:Toggle()
    check(isModal and map.Root.Visible and not map.TravelButton.Visible,"All pathways can view map but non-Door cannot travel")
    map.Search.Text="Daffodil";map:Filter()
    -- Registry uses the supplied name Moretti Residence (New), so search that label.
    map.Search.Text="Moretti";map:Filter()
    local visible=0;for _,row in ipairs(map.Rows) do if row.Button.Visible then visible+=1 end end
    check(visible==2,"Search filters destination list by name")
    map:Update({Ready=true,Dead=false,PathwayId="Apprentice"})
    map:Select(registry.Entries[1]);map.TravelButton.Activated:Fire();map.TravelButton.Activated:Fire()
    check(#sent==1 and sent[1].Action=="CityTravel" and sent[1].Payload.Id==destination,"Map sends only selected registry ID and suppresses repeated clicks")
    map:Result({Ok=false,Message="Blocked"});check(map.Root.Visible and not map.Waiting,"Travel failure keeps map usable")
    map:SetZoom(100);check(map.Zoom==5,"Zoom bounded")
    map:Result({Ok=true,Message="Arrived"});check(not map.Root.Visible and not isModal,"Successful travel closes map and releases input")
    map:Toggle();map:Update({Ready=true,Dead=true,PathwayId="Apprentice"});check(not map.Root.Visible,"Death closes map")
    map:Destroy()

    service:Destroy()
    print("PASS: "..checks.." F-I world/outfit/mythical-form/enemy/telegraph/stress assertions (engine stand-ins; no rendering)")
end
