--!strict
local CollectionService=game:GetService("CollectionService")
local Debris=game:GetService("Debris")
local World={}
World.__index=World
type Fields = {
    Data: any, Domain: any, States: {[Player]: any}, FX: RemoteEvent,
    Folder: Folder, NPCFolder: Folder, Transient: Folder, Entities: {[Model]: any},
    Spawns: {any}, Clock: number, OnInteraction: ((Player, string) -> ())?,
}
type World = typeof(setmetatable({} :: Fields, World))

local function part(parent: Instance,name: string,size: Vector3,position: Vector3,color: Color3): Part
    local p=Instance.new("Part")
    p.Name=name; p.Size=size; p.Position=position; p.Color=color; p.Anchored=true
    p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent
    return p
end
local function label(p: BasePart,text: string)
    local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(260,70);gui.StudsOffset=Vector3.new(0,4,0);gui.AlwaysOnTop=false;gui.Parent=p
    local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextColor3=Color3.new(1,1,1);t.TextStrokeTransparency=0.3;t.TextScaled=true;t.Font=Enum.Font.GothamMedium;t.Parent=gui
end
function World.new(data: any,domain: any,states: any,effects: RemoteEvent): World
    local folder=Instance.new("Folder");folder.Name="MysteriesWorld";folder.Parent=workspace
    local npcs=Instance.new("Folder");npcs.Name="Enemies";npcs.Parent=folder
    local transient=Instance.new("Folder");transient.Name="Transient";transient.Parent=folder
    return setmetatable({Data=data,Domain=domain,States=states,FX=effects,Folder=folder,NPCFolder=npcs,Transient=transient,
        Entities={},Spawns={},Clock=0,OnInteraction=nil} :: Fields, World)
end
function World.Build(self: World)
    if not self.Data.Runtime.GenerateDemoWorld then return end
    part(self.Folder,"TrainingGround",Vector3.new(800,4,800),Vector3.new(0,-2,0),Color3.fromRGB(35,41,49))
    local spawn=Instance.new("SpawnLocation");spawn.Name="SanctuarySpawn";spawn.Size=Vector3.new(12,1,12);spawn.Position=Vector3.new(0,0.5,0);spawn.Neutral=true;spawn.Duration=0;spawn.Color=Color3.fromRGB(95,153,170);spawn.Parent=self.Folder
    label(spawn,"SANCTUARY\nChoose a potion in your journal")
    for _,v in ipairs({{Name="Potion Altar",Action="Buy",Pos=Vector3.new(-12,3,0)},
        {Name="Stabilization",Action="Recover",Pos=Vector3.new(12,3,0)},
        {Name="Cipher Archive",Action="Cipher",Pos=Vector3.new(0,3,-16)},
        {Name="Hidden Archive",Action="Archive",Pos=Vector3.new(0,3,16)}}) do
        local p=part(self.Folder,v.Name,Vector3.new(3,6,3),v.Pos,Color3.fromRGB(112,100,160))
        label(p,v.Name)
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText=if v.Action=="Buy" then "Next potion · 100 gold" else v.Name
        prompt.ObjectText=v.Name;prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.RequiresLineOfSight=true;prompt.Parent=p
        prompt.Triggered:Connect(function(player)
            local root=self:Root(player)
            if root and (root.Position-p.Position).Magnitude<=12 and self.OnInteraction then self.OnInteraction(player,v.Action) end
        end)
    end
    for i=1,4 do
        local door=part(self.Folder,"PracticeDoor",Vector3.new(7,9,1),Vector3.new(-35+i*14,4.5,-34),Color3.fromRGB(123,92,62))
        CollectionService:AddTag(door,"MysticDoor");label(door,"LOCKED PASSAGE")
    end
    for x=-168,168,28 do
        for z=-168,168,28 do
            if Vector3.new(x,0,z).Magnitude>35 then
                local p=part(self.Folder,"FlameAnchor",Vector3.new(0.7,2,0.7),Vector3.new(x,1,z),Color3.fromRGB(255,150,70))
                p.CanCollide=false;p.Material=Enum.Material.Neon;CollectionService:AddTag(p,"FlameAnchor")
            end
        end
    end
    for index,tier in ipairs(self.Data.Runtime.EnemyTiers) do
        local angle=(index-1)*math.pi/3
        local center=Vector3.new(math.cos(angle)*130,0,math.sin(angle)*130)
        local marker=part(self.Folder,"Arena"..tier,Vector3.new(8,0.3,8),center,Color3.fromRGB(75,65,100))
        label(marker,"SEQUENCE "..tier.." ENEMIES")
        if tier<=4 then
            local zone=part(self.Folder,"WhisperZone",Vector3.new(50,12,50),center+Vector3.new(0,6,0),Color3.fromRGB(90,70,120))
            zone.Transparency=1;zone.CanCollide=false;zone.CanTouch=false;zone.CanQuery=false
            zone:SetAttribute("Radius",self.Data.Runtime.ExposureRadius);CollectionService:AddTag(zone,"MysticalExposure")
        end
        for offset=1,3 do
            table.insert(self.Spawns,{Position=center+Vector3.new((offset-2)*12,4,8),Tier=tier,Entity=nil,NextSpawn=0})
        end
    end
end
function World.Root(self: World, player: Player): BasePart?
    local c=player.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    return if root and root:IsA("BasePart") then root else nil
end
function World.Humanoid(self: World, player: Player): Humanoid?
    return if player.Character then player.Character:FindFirstChildOfClass("Humanoid") else nil
end
function World.Entity(self: World, model: any): any
    if typeof(model)~="Instance" or not model:IsA("Model") then return nil end
    local e=self.Entities[model]
    if not e or not model:IsDescendantOf(self.NPCFolder) or not CollectionService:HasTag(model,"Enemy") or e.Humanoid.Health<=0 then return nil end
    return e
end
function World.Has(self: World, e: any,id: string,now: number): boolean
    local st=e.Statuses[id]
    return st~=nil and st.ExpiresAt>now
end
function World.Status(self: World, e: any,id: string,duration: number,now: number,owner: Player?,power: number?)
    assert(self.Data.StatusEffects[id],"Unknown status")
    if owner and id~="Controlled" then
        local s=self.States[owner]
        if s then
            local rating=self.Data.Runtime.NPCMentalResistancePerTier*e.Power
            duration*=math.clamp(s.Stats.Resistance/rating,self.Data.Runtime.MinStatusDurationMultiplier,1)
        end
    end
    e.Statuses[id]={ExpiresAt=now+duration,Owner=owner,Power=power or 0,NextTick=now+1}
end
function World.Buff(self: World, s: any,id: string,duration: number,now: number)
    assert(self.Data.StatusEffects[id],"Unknown buff")
    s.Statuses[id]={ExpiresAt=now+duration}
end
function World.LineOfSight(self: World, from: Vector3,to: Vector3,ignore: Instance?,target: Instance?): boolean
    local delta=to-from
    if delta.Magnitude<0.1 then return true end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    local exclusions: {Instance}={self.Transient}
    if ignore then table.insert(exclusions,ignore) end
    params.FilterDescendantsInstances=exclusions;params.IgnoreWater=true
    local hit=workspace:Raycast(from,delta,params)
    return not hit or (hit.Position-to).Magnitude<1 or (target~=nil and hit.Instance:IsDescendantOf(target))
end
function World.FiniteVector(self: World, v: any): boolean
    return typeof(v)=="Vector3" and self.Domain.Finite(v.X) and self.Domain.Finite(v.Y) and self.Domain.Finite(v.Z)
end
function World.SafeDestination(self: World, player: Player,position: Vector3): Vector3?
    if not self:FiniteVector(position) or math.abs(position.Y)>500 or Vector3.new(position.X,0,position.Z).Magnitude>self.Data.Runtime.WorldRadius then return nil end
    local ignore: {Instance}={self.NPCFolder,self.Transient}
    if player.Character then table.insert(ignore,player.Character) end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances=ignore
    local hit=workspace:Raycast(position+Vector3.new(0,30,0),Vector3.new(0,-100,0),params)
    if not hit or hit.Normal.Y<0.7 or not hit.Instance.CanCollide then return nil end
    if not hit.Instance.Anchored and not hit.Instance:IsA("Terrain") then return nil end
    local destination=Vector3.new(position.X,hit.Position.Y+3.5,position.Z)
    local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances=ignore
    for _,p in ipairs(workspace:GetPartBoundsInBox(CFrame.new(destination),Vector3.new(4,5,4),overlap)) do
        if p.CanCollide then return nil end
    end
    return destination
end
function World.Targets(self: World, position: Vector3,radius: number,maximum: number,owner: Player): {any}
    local found={}
    for _,e in pairs(self.Entities) do
        if e.Humanoid.Health>0 and e.Owner==nil and (e.Root.Position-position).Magnitude<=radius then table.insert(found,e) end
    end
    table.sort(found,function(a,b) return (a.Root.Position-position).Magnitude<(b.Root.Position-position).Magnitude end)
    while #found>maximum do table.remove(found) end
    return found
end
function World.Effect(self: World, position: Vector3,kind: string,owner: Player?,target: Instance?)
    -- Server supplies bounded positions/identities; clients render pooled cosmetics only.
    self.FX:FireAllClients({Position=position,Kind=kind,Owner=owner and owner.UserId,Target=target})
end
function World.Damage(self: World, e: any,amount: number,owner: Player,now: number): boolean
    if e.Humanoid.Health<=0 or e.Owner~=nil or amount<=0 then return false end
    e.LastHit=owner;e.LastHitAt=now
    e.Humanoid:TakeDamage(math.min(amount,100000))
    return true
end
function World.DamagePlayer(self: World, player: Player,amount: number,source: any,now: number)
    local s=self.States[player];local hum=self:Humanoid(player)
    if not s or not s.Ready or s.Dead or not hum or hum.Health<=0 then return end
    s.LastCombat=now
    if s.Statuses.Invulnerable then
        self.Domain:Act(s,"HostileStrikeEvaded","dodge:"..tostring(source.Serial)..":"..tostring(math.floor(now)),now)
        return
    end
    if s.Statuses.Shielded then amount*=0.35 end
    if source.Statuses.Grafted and source.Statuses.Grafted.Owner==player then
        if self:Damage(source,amount,player,now) then
            self.Domain:Act(s,"GraftEncounterResolved","graft:"..source.Serial..":"..tostring(math.floor(now)),now)
        end
        return
    end
    if s.Statuses.Substitute and hum.Health<=amount then
        s.Statuses.Substitute=nil;hum.Health=math.max(1,hum.MaxHealth*0.2)
        self:Buff(s,"Invulnerable",2,now);self:Effect(hum.RootPart and hum.RootPart.Position or Vector3.zero,"Substitute",player)
        return
    end
    hum:TakeDamage(amount);s.Health=hum.Health
end
function World.Spawn(self: World, position: Vector3,tier: number,owner: Player?,expiresAt: number?): any
    local model=Instance.new("Model");model.Name=if owner then "Past Echo" else "Sealed Remnant · "..tostring(tier)
    local root=part(model,"HumanoidRootPart",Vector3.new(2,2,1),position,Color3.new(0,0,0));root.Transparency=1;root.CanCollide=false
    local torso=part(model,"Torso",Vector3.new(3,3,1.5),position,if owner then Color3.fromRGB(110,190,205) else Color3.fromRGB(120,75,145));torso.CanCollide=false
    local head=part(model,"Head",Vector3.new(1.8,1.8,1.8),position+Vector3.new(0,2.3,0),Color3.fromRGB(190,170,190));head.Shape=Enum.PartType.Ball;head.CanCollide=false
    local hum=Instance.new("Humanoid");hum.RequiresNeck=false;hum.BreakJointsOnDeath=false
    local t=self.Data.Stats.TierMultipliers[tier];hum.MaxHealth=self.Data.Runtime.NPCHealthPerTier*t;hum.Health=hum.MaxHealth;hum.WalkSpeed=0;hum.Parent=model
    model.PrimaryPart=root;model.Parent=self.NPCFolder
    CollectionService:AddTag(model,"Enemy");model:SetAttribute("AbilityId","ArcBolt");model:SetAttribute("Omen",math.random(1,4))
    self.Clock+=1
    local e: any={Model=model,Root=root,Humanoid=hum,Tier=tier,Power=t,Home=position,Owner=owner,ExpiresAt=expiresAt,
        Statuses={},LastAttack=0,LastHit=nil,LastHitAt=0,Serial=self.Clock,Threads=0,Stolen=false}
    self.Entities[model]=e
    hum.Died:Connect(function()
        if e.Rewarded then return end;e.Rewarded=true
        local killer=e.LastHit;local state=killer and self.States[killer]
        if state and state.Ready and os.clock()-e.LastHitAt<=20 and e.Owner==nil then
            state.Profile.Gold=math.min(10000000,state.Profile.Gold+self.Data.Runtime.NPCGoldReward)
        end
        self:Effect(root.Position,"Defeat",killer)
        Debris:AddItem(model,2)
    end)
    return e
end
function World.Step(self: World, dt: number,now: number)
    for player,s in pairs(self.States) do
        local root=self:Root(player)
        if not s.Ready or s.Dead or not root then continue end
        for _,zone in ipairs(CollectionService:GetTagged("MysticalExposure")) do
            if zone:IsA("BasePart") and (root.Position-zone.Position).Magnitude<self.Data.Runtime.ExposureRadius then
                self.Domain:DrainSanity(s,self.Data.Progression.Sanity.ExposureDrainPerSecond*dt,now)
                if now>=(s.NextWhisper or 0) then
                    s.NextWhisper=now+self.Data.Runtime.WhisperInterval
                    self.Domain:DrainSanity(s,self.Data.Progression.Sanity.WhisperDrain,now)
                    self.FX:FireClient(player,{Position=root.Position,Kind="Whisper"})
                end
                break
            end
        end
    end
    for _,spawn in ipairs(self.Spawns) do
        if spawn.Entity and (not spawn.Entity.Model.Parent or spawn.Entity.Humanoid.Health<=0) then
            spawn.Entity=nil;spawn.NextSpawn=now+self.Data.Runtime.NPCRespawnSeconds
        end
        if not spawn.Entity and now>=spawn.NextSpawn and table.find(self.Spawns,spawn)<=self.Data.Runtime.MaxEnemies then spawn.Entity=self:Spawn(spawn.Position,spawn.Tier,nil,nil) end
    end
    for model,e in pairs(self.Entities) do
        if not model.Parent then self.Entities[model]=nil;continue end
        if e.Humanoid.Health<=0 then continue end
        if e.ExpiresAt and now>=e.ExpiresAt then model:Destroy();self.Entities[model]=nil;continue end
        if e.Owner and not self.States[e.Owner] then
            if e.IsEcho then model:Destroy();self.Entities[model]=nil;continue end
            e.Owner=nil;e.Statuses={}
        end
        for id,st in pairs(e.Statuses) do
            if st.ExpiresAt<=now then
                e.Statuses[id]=nil
                if id=="Controlled" then e.Owner=nil end
                if id=="Threaded" then e.Threads=0 end
            elseif (id=="Burning" or id=="Parasite") and now>=st.NextTick then
                st.NextTick=now+1
                if st.Owner and self.States[st.Owner] then
                    self:Damage(e,st.Power,st.Owner,now)
                    if id=="Parasite" then
                        local h=self:Humanoid(st.Owner);if h then h.Health=math.min(h.MaxHealth,h.Health+st.Power*0.5) end
                    end
                end
            end
        end
        local blocked=false;local speed=self.Data.Runtime.NPCSpeed
        for id in pairs(e.Statuses) do
            local def=self.Data.StatusEffects[id]
            if def.BlocksAttacks then blocked=true end
            if def.MoveMultiplier then speed*=def.MoveMultiplier end
        end
        if e.Owner then
            local foes=self:Targets(e.Root.Position,55,1,e.Owner)
            local foe=foes[1]
            if foe then
                local delta=foe.Root.Position-e.Root.Position
                if delta.Magnitude>5 then model:PivotTo(model:GetPivot()+delta.Unit*math.min(delta.Magnitude-4,speed*dt))
                elseif now-e.LastAttack>=self.Data.Runtime.SummonAttackInterval then e.LastAttack=now;self:Damage(foe,self.Data.Runtime.SummonDamagePerTier*e.Power,e.Owner,now) end
            end
            continue
        end
        local nearest=nil;local distance=self.Data.Runtime.NPCNoticeRange
        for player,s in pairs(self.States) do
            local root=self:Root(player);local hum=self:Humanoid(player)
            if root and hum and hum.Health>0 and s.Ready and not s.Dead and root.Position.Magnitude>self.Data.Runtime.SanctuaryRadius then
                local range=if s.Statuses.Concealed then 0 elseif s.Statuses.Disguised then 12 else distance
                local d=(root.Position-e.Root.Position).Magnitude
                if d<distance and d<range then nearest=player;distance=d end
            end
        end
        if nearest and not blocked then
            local root=self:Root(nearest)
            if root and e.Tier<=6 and distance<self.Data.Runtime.NPCSpellRange and now-(e.LastSpell or -100)>self.Data.Runtime.NPCSpellCooldown and not self:Has(e,"Silenced",now) and self:LineOfSight(e.Root.Position,root.Position,model,nearest.Character) then
                e.LastSpell=now
                self:DamagePlayer(nearest,self.Data.Runtime.NPCSpellDamagePerTier*e.Power,e,now)
                self.Domain:DrainSanity(self.States[nearest],2,now)
                self:Effect(root.Position,"ArcBolt",nil)
            end
            if root then
                local delta=root.Position-e.Root.Position
                if delta.Magnitude>self.Data.Runtime.NPCAttackRange then
                    local step=delta.Unit*math.min(delta.Magnitude-4,speed*dt)
                    if (e.Root.Position+step-e.Home).Magnitude<75 then model:PivotTo(model:GetPivot()+Vector3.new(step.X,0,step.Z)) end
                elseif now-e.LastAttack>=self.Data.Runtime.NPCAttackInterval and self:LineOfSight(e.Root.Position,root.Position,model,nearest.Character) then
                    e.LastAttack=now
                    local payload=e.Statuses.Payload
                    if payload and payload.Owner then
                        e.Statuses.Payload=nil;self:Damage(e,payload.Power,payload.Owner,now)
                    end
                    self:DamagePlayer(nearest,self.Data.Runtime.NPCMeleeDamagePerTier*e.Power,e,now)
                    if e.Tier<=4 and not self:Has(e,"Silenced",now) then self.Domain:DrainSanity(self.States[nearest],3,now) end
                    self:Effect(e.Root.Position,"Strike",nil)
                end
            end
        elseif not nearest and (e.Root.Position-e.Home).Magnitude>2 and speed>0 then
            local delta=e.Home-e.Root.Position
            model:PivotTo(model:GetPivot()+delta.Unit*math.min(delta.Magnitude,dt*speed))
        end
    end
end
function World.Cleanup(self: World, player: Player)
    for model,e in pairs(self.Entities) do
        if e.Owner==player then
            if e.IsEcho then model:Destroy();self.Entities[model]=nil else e.Owner=nil;e.Statuses={} end
        end
        for id,st in pairs(e.Statuses) do if st.Owner==player then e.Statuses[id]=nil end end
    end
end
return World
