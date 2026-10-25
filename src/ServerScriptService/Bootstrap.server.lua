--!strict
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local RunService=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local data=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))
local Theme=require(ReplicatedStorage.Shared.Theme)
local Access=require(script.Parent.Domain.VisualAccess)
local AdminConfig=require(script.Parent.AdminConfig)
local adminIds=table.clone(AdminConfig.AdminUserIds)
task.spawn(function()
    for _,username in ipairs(AdminConfig.AdminUsernames) do
        local resolved=false
        for attempt=1,AdminConfig.LookupAttempts do
            local ok,id=pcall(function() return Players:GetUserIdFromNameAsync(username) end)
            if ok and type(id)=="number" and id>0 and id%1==0 then
                if not table.find(adminIds,id) then table.insert(adminIds,id) end
                resolved=true;break
            end
            if attempt<AdminConfig.LookupAttempts then task.wait(AdminConfig.LookupRetrySeconds) end
        end
        if not resolved then warn("Admin username could not be resolved: "..username..". Configure its numeric ID in AdminConfig.") end
    end
end)
local function isDeveloper(player: Player): boolean
    return Access.IsDeveloper(player.UserId,game.CreatorId,game.CreatorType==Enum.CreatorType.User,adminIds)
end
local Domain=require(script.Parent.Domain.PlayerDomain)
local AdminProgression=require(script.Parent.Domain.AdminProgression)
local Sessions=require(script.Parent.Domain.SessionStore)
local RateLimiter=require(script.Parent.Domain.RateLimiter)
local World=require(script.Parent.Services.WorldService)
local Effects=require(script.Parent.Services.EffectService)
local VisualEvents=require(script.Parent.Services.VisualEventService)
local VfxConfig=require(ReplicatedStorage.Shared.VfxConfig)
local domain=Domain.new(data)
local states: {[Player]: any}={}
local sessions: {[Player]: any}={}
local releasing: {[Player]: boolean}={}
local bound: {[Player]: Model}={}
local connections: {[Player]: RBXScriptConnection}={}
local closing=false
local releaseCount=0
local remotes=Instance.new("Folder");remotes.Name="MysteriesRemotes";remotes.Parent=ReplicatedStorage
local function remote(name: string): RemoteEvent
    local r=Instance.new("RemoteEvent");r.Name=name;r.Parent=remotes;return r
end
local intent,stateEvent,fx=remote("Intent"),remote("State"),remote("Effect")
local limiter=RateLimiter.new(data.Runtime.IntentRate,data.Runtime.IntentBurst)
local sessionOnly=RunService:IsStudio() and data.Runtime.StudioSessionOnly
local store: any
if sessionOnly then
    warn("Mysteries: STUDIO SESSION ONLY — progress is not saved between servers")
    local memory={}
    store={UpdateAsync=function(_self: any,key: string,transform: any)
        local value=transform(Domain.Copy(memory[key]))
        if value~=nil then memory[key]=Domain.Copy(value) end
        return Domain.Copy(value)
    end}
else
    store=DataStoreService:GetDataStore(data.Progression.Persistence.DataStoreName)
end
local persistence=Sessions.new(store,domain,data.Progression.Persistence,os.time,task.wait)
local function notify(player: Player,text: string)
    if player.Parent then stateEvent:FireClient(player,{Message=string.sub(text,1,data.Runtime.MaxMessageLength)}) end
end
local world=World.new(data,domain,states,fx)
local visualEvents=VisualEvents.new(world,VfxConfig.Protocol,function() return workspace:GetServerTimeNow() end,VfxConfig.Status)
world.Visuals=visualEvents
local effects=Effects.new(world,domain,notify)
world:Build()
local function applyStats(player: Player,s: any,refill: boolean)
    local hum=world:Humanoid(player)
    if not hum then return end
    hum.MaxHealth=s.Stats.Health
    if refill then hum.Health=s.Stats.Health else hum.Health=math.min(hum.Health,hum.MaxHealth) end
    hum.WalkSpeed=math.clamp(16+s.Stats.Agility*0.25,16,42)
    s.Health=hum.Health
end
local function sendState(player: Player)
    local s=states[player]
    if not s or not s.Ready then
        stateEvent:FireClient(player,{Ready=false,Loading=not releasing[player],Developer=isDeveloper(player)});return
    end
    local now=os.clock();local p=s.Profile;local cooldowns={};local statuses={}
    for id,expiry in pairs(s.Cooldowns) do if expiry>now then cooldowns[id]=expiry-now end end
    for id,st in pairs(s.Statuses) do if st.ExpiresAt>now then table.insert(statuses,id) end end
    table.sort(statuses)
    stateEvent:FireClient(player,{Ready=true,Developer=isDeveloper(player),
        DeveloperInfo=if isDeveloper(player) then {SessionOnly=sessionOnly,Mode=s.Mode,Ready=s.Ready} else nil,PathwayId=p.PathwayId,Sequence=p.Sequence,
        Digestion=p.Digestion,ActingProgress=p.ActingProgress,Health=s.Health,MaxHealth=s.Stats.Health,
        Spirituality=s.Spirituality,MaxSpirituality=s.Stats.Spirituality,Sanity=s.Sanity,Mode=s.Mode,
        Gold=p.Gold,WishCredits=p.WishCredits,Inventory=Domain.Copy(p.Inventory),Loadout=Domain.Copy(p.AbilityLoadout),
        Cooldowns=cooldowns,Statuses=statuses,Dead=s.Dead,RecordedCharges=s.RecordedPower and s.RecordedPower.Charges or 0,RecordedPowerId=s.RecordedPower and s.RecordedPower.Id or false,StolenPower=s.StolenPower or false,
        Casting=s.Pending and s.Pending.Id or false,CastRemaining=s.Pending and math.max(0,s.Pending.EndsAt-now) or 0,CastSerial=s.CastSerial,VisualToken=s.VisualToken or 0})
end
local function bindCharacter(player: Player,character: Model)
    if bound[player]==character then return end
    bound[player]=character
    task.spawn(function()
        local hum=character:WaitForChild("Humanoid",15)
        local root=character:WaitForChild("HumanoidRootPart",15)
        if not hum or not hum:IsA("Humanoid") or not root or not root:IsA("BasePart") then return end
        while player.Parent and character==player.Character and states[player] and not states[player].Ready do task.wait(0.1) end
        local s=states[player]
        if not s or not s.Ready or player.Character~=character then return end
        s.Dead=false;s.Pending=nil;s.Statuses={};s.RecordedPower=nil;s.StolenPower=nil;s.DisguiseUntil=nil;s.OriginalDisplayName=nil
        s.Health=s.Stats.Health;s.Spirituality=s.Stats.Spirituality
        s.LastPosition=root.Position;s.LastPositionAt=os.clock();s.TeleportGraceUntil=os.clock()+3
        applyStats(player,s,true)
        hum.HealthChanged:Connect(function(health)
            local current=states[player]
            if current and player.Character==character then current.Health=health end
        end)
        hum.Died:Connect(function()
            local current=states[player]
            if current and player.Character==character then
                current.Dead=true;domain:CancelCast(current,false);current.Statuses={}
                effects:RemoveGates(player);world:Cleanup(player)
            end
        end)
    end)
end
world.OnInteraction=function(player: Player,action: string)
    local s=states[player]
    if not s or not s.Ready or s.Dead or s.Pending or not limiter:Allow(player,os.clock()) then return end
    local now=os.clock()
    local ok,message=false,"No response"
    if action=="Buy" and s.Mode=="Normal" then
        local altar=world.Folder:FindFirstChild("Potion Altar")
        local root=world:Root(player)
        if not altar or not altar:IsA("BasePart") or not root or (root.Position-altar.Position).Magnitude>Theme.Interaction.ServerDistance then return end
        s.AltarTicket={Position=altar.Position,ExpiresAt=now+Theme.Timing.AltarExpiry,PathwayId=s.Profile.PathwayId,Sequence=s.Profile.Sequence}
        stateEvent:FireClient(player,{Menu="Altar",ExpiresIn=Theme.Timing.AltarExpiry})
        return
    elseif action=="Recover" then
        ok,message=domain:Recover(s);s.FailureApplied=false
    elseif action=="Cipher" then
        if s.Mode=="Normal" and s.Statuses.CipherSight and s.Statuses.CipherSight.ExpiresAt>now then
            ok=domain:Act(s,"CipherSolved","archive:"..tostring(now),now)
            message=if ok then "Cipher interpreted" else "Acting objective is not ready"
        else message="Use Cryptologist's Decipher ability first" end
    elseif action=="Archive" and s.Mode=="Normal" then
        s.ArchiveRead=true
        if s.Statuses.Disguised then ok=domain:Act(s,"DisguisedInfiltrationCompleted","infiltration:"..tostring(now),now) end
        if s.Statuses.Concealed then ok=domain:Act(s,"SecretProtected","secret:"..tostring(now),now) or ok end
        message=if ok then "Archive objective complete" else "Historical record read; a Scholar can invoke its echo"
    elseif string.sub(action,1,7)=="Studio:" and isDeveloper(player) and sessionOnly and RunService:IsStudio() then
        local path=string.sub(action,8)
        if data.Pathways[path] then
            local p=domain:Default();p.PathwayId=path;p.Sequence=1;p.Digestion=100;p.Gold=1000;p.WishCredits=100
            for id in pairs(data.Potions.ById) do p.Inventory[id]=1 end
            local replacement=domain:NewState(p,now);domain:AutoEquip(replacement)
            states[player]=replacement;replacement.TeleportGraceUntil=now+3;replacement.FailureApplied=false
            effects:RemoveGates(player);world:Cleanup(player);applyStats(player,replacement,true)
            ok=true;message="Attuned to "..path.." · Sequence 1"
        end
    end
    notify(player,message);sendState(player)
end
local function loadPlayer(player: Player)
    if states[player] then return end
    states[player]={Ready=false,Loading=true}
    connections[player]=player.CharacterAdded:Connect(function(c) bindCharacter(player,c) end)
    if player.Character then bindCharacter(player,player.Character) end
    task.spawn(function()
        local owner=game.JobId..":"..HttpService:GenerateGUID(false)
        local handle,err=persistence:Acquire(player.UserId,owner)
        if not handle then
            if player.Parent then notify(player,err or "Load failed");player:Kick("Save could not be safely loaded. "..(err or "Please rejoin.")) end
            return
        end
        if not player.Parent or closing then persistence:Save(handle,handle.Data,true);return end
        sessions[player]=handle
        local s=domain:NewState(handle.Data,os.clock())
        if next(s.Profile.AbilityLoadout)==nil then domain:AutoEquip(s) end
        s.NextSave=os.clock()+data.Progression.Persistence.LockRefreshSeconds
        states[player]=s
        if player.Character and bound[player]~=player.Character then bindCharacter(player,player.Character) end
        sendState(player)
    end)
end
local function releasePlayer(player: Player)
    if releasing[player] then return end
    releasing[player]=true;releaseCount+=1
    local s=states[player];local handle=sessions[player]
    visualEvents:Remove(player)
    if s then s.Ready=false;s.Pending=nil end
    effects:RemoveGates(player);world:Cleanup(player)
    if handle and s then
        local deadline=os.clock()+18
        while handle.Busy and os.clock()<deadline do task.wait(0.05) end
        local ok,err=persistence:Save(handle,domain:Snapshot(s),true)
        if not ok then warn("Mysteries final save failed for "..player.UserId..": "..tostring(err)) end
    end
    if connections[player] then connections[player]:Disconnect();connections[player]=nil end
    limiter:Remove(player);states[player]=nil;sessions[player]=nil;bound[player]=nil
    releaseCount-=1;releasing[player]=nil
end
Players.PlayerAdded:Connect(loadPlayer)
Players.PlayerRemoving:Connect(releasePlayer)
for _,player in ipairs(Players:GetPlayers()) do loadPlayer(player) end
intent.OnServerEvent:Connect(function(player: Player,action: any,payload: any)
    if closing or type(action)~="string" or #action>12 or not limiter:Allow(player,os.clock()) then return end
    if action=="Sync" then sendState(player);visualEvents:Sync(player);return end
    local s=states[player]
    if not s or not s.Ready or s.Dead or type(payload)~="table" then return end
    local now=os.clock()
    if action=="Buy" then
        local root=world:Root(player)
        local ticket=s.AltarTicket
        s.AltarTicket=nil
        local valid=root and ticket and Access.AltarValid(ticket,now,(root.Position-ticket.Position).Magnitude,s.Profile.PathwayId,s.Profile.Sequence,Theme.Interaction.ServerDistance)
        local ok,message=false,"Return to the Potion Altar to confirm a purchase"
        if valid and s.Mode=="Normal" and not s.Pending then ok,message=domain:BuyNextPotion(s) end
        stateEvent:FireClient(player,{Purchase={Ok=ok,Message=message}})
        notify(player,message)
    elseif action=="CloseAltar" then
        s.AltarTicket=nil
    elseif action=="AdminSet" then
        local hum=world:Humanoid(player)
        local authorized=isDeveloper(player)
        local ok,message=false,"Wait until your character is alive and loaded"
        if not authorized or (hum and hum.Health>0) then
            ok,message=AdminProgression.Apply(domain,s,payload.PathwayId,payload.Sequence,now,authorized)
        end
        if ok then
            effects:RemoveGates(player);world:Cleanup(player);applyStats(player,s,true)
        end
        notify(player,message)
    elseif action=="DevMastery" then
        if isDeveloper(player) and sessionOnly and RunService:IsStudio() and type(payload.PathwayId)=="string" and data.Pathways[payload.PathwayId] then
            local interact=world.OnInteraction
            if interact then interact(player,"Studio:"..payload.PathwayId) end
        end
    elseif action=="Drink" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local ok,message=domain:Drink(s,payload.Id,now)
        if ok then applyStats(player,s,true);world:Cleanup(player);effects:RemoveGates(player) end
        notify(player,message)
    elseif action=="Equip" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local _,message=domain:Equip(s,payload.Slot,payload.Id);notify(player,message)
    elseif action=="Cast" then
        if type(payload.Id)~="string" or #payload.Id>80 then return end
        local a=data.Abilities[payload.Id]
        if not a then return end
        local input={Position=payload.Position,Target=payload.Target}
        local context,err=effects:Validate(player,s,a,input)
        if not context then notify(player,err or "Invalid target");return end
        local pending,reason=domain:BeginCast(s,payload.Id,now)
        if not pending then notify(player,reason or "Cannot cast");return end
        pending.Input=input
        visualEvents:Begin(context,now)
    elseif action=="Melee" then
        local root=world:Root(player)
        if not root or not world:FiniteVector(root.Position) or s.Mode~="Normal" or s.Pending or now-s.LastMelee<data.Runtime.MeleeCooldown then return end
        s.LastMelee=now;s.LastCombat=now
        local direction=root.CFrame.LookVector
        if world:FiniteVector(payload.Position) and (payload.Position-root.Position).Magnitude>0.1 then direction=(payload.Position-root.Position).Unit end
        for _,e in ipairs(world:Targets(root.Position,data.Runtime.MeleeRange,8,player)) do
            local delta=e.Root.Position-root.Position
            if delta.Magnitude<0.1 or delta.Unit:Dot(direction)>0.25 then
                if world:LineOfSight(root.Position,e.Root.Position,player.Character,e.Model) then
                    world:Damage(e,s.Stats.Strength*data.Runtime.MeleePowerMultiplier,player,now);break
                end
            end
        end
        world:Effect(root.Position+direction*3,"Melee",player)
    end
    sendState(player)
end)
task.spawn(function()
    local previous=os.clock();local nextState=0
    while not closing do
        task.wait(data.Runtime.TickSeconds)
        local now=os.clock();local dt=now-previous;previous=now
        for player,s in pairs(states) do
            if not s.Ready then continue end
            domain:Tick(s,dt,now)
            local root=world:Root(player);local hum=world:Humanoid(player)
            if root and hum and hum.Health>0 then
                -- Horizontal movement guard; server-authorized travel has an explicit grace window.
                if s.LastPosition and now>(s.TeleportGraceUntil or 0) then
                    local horizontal=Vector3.new(root.Position.X-s.LastPosition.X,0,root.Position.Z-s.LastPosition.Z).Magnitude
                    if horizontal>hum.WalkSpeed*math.min(dt,2)*2+8 then
                        root.CFrame=CFrame.new(s.LastPosition);domain:CancelCast(s,false)
                    end
                end
                s.LastPosition=root.Position
                s.Health=hum.Health
            end
            if s.Mode=="LostControl" and not s.FailureApplied then
                s.FailureApplied=true
                if hum then hum.Health=0 end
                notify(player,"Loss of control. Return to Stabilization after respawning.")
            end
            local pending=s.Pending
            if pending and now>=pending.EndsAt then
                local a=data.Abilities[pending.Id]
                local context,err=effects:Validate(player,s,a,pending.Input)
                if not context then domain:CancelCast(s,true);notify(player,err or "Cast interrupted")
                else
                    local success,ok,message=pcall(function() return effects:Execute(context,now) end)
                    if not success then
                        domain:CancelCast(s,true);warn("Mysteries executor error: "..tostring(ok));notify(player,"Cast interrupted")
                    else domain:CancelCast(s,not ok);notify(player,message) end
                end
            end
            local handle=sessions[player]
            if handle and not handle.Busy and now>=(s.NextSave or math.huge) then
                s.NextSave=now+data.Progression.Persistence.LockRefreshSeconds
                local snapshot=domain:Snapshot(s)
                task.spawn(function()
                    local ok,err=persistence:Save(handle,snapshot,false)
                    if not ok and player.Parent and not releasing[player] then
                        warn("Mysteries save/lease failure for "..player.UserId..": "..tostring(err))
                        if handle.Closed or os.time()+15>=handle.ExpiresAt then
                            s.Ready=false;player:Kick("Save session ownership could not be maintained. Please rejoin.")
                        else s.NextSave=os.clock()+5;notify(player,"Saving delayed; retrying safely") end
                    end
                end)
            end
        end
        world:Step(math.min(dt,1),now);effects:Step(now);visualEvents:Step(now)
        if now>=nextState then
            nextState=now+data.Runtime.StateIntervalSeconds
            for player in pairs(states) do if player.Parent then sendState(player) end end
        end
    end
end)
game:BindToClose(function()
    closing=true
    local waiting=0
    for player in pairs(states) do
        waiting+=1
        task.spawn(function() releasePlayer(player);waiting-=1 end)
    end
    local deadline=os.clock()+25
    while (waiting>0 or releaseCount>0) and os.clock()<deadline do task.wait(0.05) end
end)
