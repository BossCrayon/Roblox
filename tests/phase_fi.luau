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
    local Art=load("Server/Services/WorldArt",env)
    local world={Folder=instance("Folder"),Spawns={},Data=data}
    Art.Build(world)
    check(#world.Spawns==18,"Expanded world retains eighteen real spawn records")
    check(world.Folder:FindFirstChild("SanctuarySpawn").Position.Magnitude<1,"Sanctuary spawn retains the original origin")
    local parts=0;local prompts=0
    for _,object in ipairs(world.Folder:GetDescendants()) do
        check(not object:IsA("BillboardGui"),"World construction has no permanent floating zone/debug names")
        if object:IsA("BasePart") then parts+=1 end
        if object:IsA("ProximityPrompt") then prompts+=1 end
        if object:IsA("PointLight") then check(not object.Enabled and not object.Shadows,"Practical lights start disabled/unshadowed for local bounded selection") end
    end
    check(parts<1500 and prompts==4,"Procedural original world kit is bounded and retains all four server prompts")
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
    service:Destroy()
    print("PASS: "..checks.." F-I world/outfit/mythical-form/enemy/telegraph/stress assertions (engine stand-ins; no rendering)")
end
