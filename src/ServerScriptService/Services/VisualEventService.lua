--!strict
-- Server-only evidence adapter. It observes accepted casts; it never changes outcomes.
local Visual={}
function Visual.new(world: any,config: any,clock: ()->number,statusConfig: any?): any
    return setmetatable({World=world,Config=config,Clock=clock,Active={},Counters={},StatusRecords={},Revision=0,CueSerial=0,LastSync={},Gates={},Echoes={},StatusConfig=statusConfig or {Labels={},Private={}}},{__index=Visual})
end
function Visual.Packet(self: any,c: any,phase: string,position: any): any
    if not self.World:FiniteVector(position) then return nil end
    return {Kind="AbilityVisual",Phase=phase,AbilityId=c.Ability.Id,Owner=c.Player.UserId,
        Token=c.State.VisualToken or c.State.CastSerial,Character=c.Player.Character,Position=position,Tier=if c.Ability.UnlockSequence>=7 then 1 elseif c.Ability.UnlockSequence>=4 then 2 else 3,
        At=self.Clock()}
end
function Visual.Begin(self: any,c: any,now: number)
    local pending=c.State.Pending
    if not pending then return end
    self.Counters[c.Player]=(self.Counters[c.Player] or 0)+1
    c.State.VisualToken=self.Counters[c.Player]
    local packet=self:Packet(c,"Begin",c.Root.Position)
    if not packet then return end
    packet.EndsAt=packet.At+math.max(0,pending.EndsAt-now)
    self.Active[c.Player]={Ability=c.Ability,Token=packet.Token,DomainToken=pending.Token,Position=packet.Position,Character=c.Player.Character}
    self.World.FX:FireAllClients(packet)
end
function Visual.Capture(self: any,c: any): any
    return {Origin=c.Root.Position,Stored=c.State.StolenPower,Record=c.State.RecordedPower and c.State.RecordedPower.Id}
end
function Visual.Result(self: any,c: any,before: any,ok: boolean,evidence: any,now: number)
    local packet=self:Packet(c,if ok then "Result" else "Cancel",if ok then c.Position else before.Origin)
    self.Active[c.Player]=nil
    if not packet then return end
    packet.Origin=before.Origin;packet.Destination=c.Root.Position
    packet.Target=c.VisualTarget or (c.Entity and c.Entity.Model)
    packet.Affected=c.VisualAffected;packet.Radius=c.VisualRadius;packet.Gates=c.VisualGates;packet.Echo=c.VisualEcho
    if c.State.RecordedPower then packet.RecordedId=c.State.RecordedPower.Id;packet.RecordedCharges=c.State.RecordedPower.Charges end
    if c.Entity then packet.Threads=c.Entity.Threads;packet.Controlled=c.Entity.Owner==c.Player end
    packet.Outcome=if evidence==false and c.Ability.Operation.Kind=="Sense" then "Obscured" else "Confirmed"
    if c.Ability.Operation.Kind=="Theft" then packet.Outcome="Taken"
    elseif c.Ability.Operation.Kind=="StealPower" then
        packet.Outcome=if before.Stored then "Released" else "Captured"
        packet.PowerId=before.Stored or c.State.StolenPower
    end
    if c.VisualExpires then packet.ExpiresAt=packet.At+math.max(0,c.VisualExpires-now) end
    if ok and packet.Gates then self.Gates[c.Player]=table.clone(packet) end
    if ok and packet.Echo then self.Echoes[packet.Echo]=table.clone(packet) end
    self.World.FX:FireAllClients(packet)
end
function Visual.Reveal(self: any,c: any,entries: {any},now: number)
    local packet=self:Packet(c,"Reveal",c.Root.Position)
    if not packet then return end
    local targets={}
    for _,entry in ipairs(entries) do
        if #targets>=self.Config.MaxReveals then break end
        local target=entry.Model or entry.Part
        local position=if entry.Root then entry.Root.Position else entry.Position
        if target and self.World:FiniteVector(position) then table.insert(targets,{Target=target,Position=position}) end
    end
    if #targets==0 then return end
    packet.Targets=targets
    local status=c.State.Statuses.Vision
    local duration=if status then math.max(0,status.ExpiresAt-now) else self.Config.RevealLife
    packet.ExpiresAt=packet.At+math.min(duration,self.Config.RevealLife)
    -- Perception evidence remains private to the player the server authorized.
    self.World.FX:FireClient(c.Player,packet)
end
function Visual.Step(self: any,now: number?)
    for player,cast in pairs(self.Active) do
        local state=self.World.States[player]
        local pending=state and state.Pending
        if not state or not state.Ready or state.Dead or player.Character~=cast.Character or not pending or pending.Token~=cast.DomainToken then
            self.Active[player]=nil
            if state then
                local packet=self:Packet({Player=player,State=state,Ability=cast.Ability},"Cancel",cast.Position)
                if packet then packet.Token=cast.Token;self.World.FX:FireAllClients(packet) end
            end
        end
    end
    self:Statuses(now or os.clock())
    for model,packet in pairs(self.Echoes) do if not model.Parent or packet.ExpiresAt<=self.Clock() then self.Echoes[model]=nil end end
end
function Visual.Remove(self: any,player: any)
    local cast=self.Active[player]
    if cast then
        local state=self.World.States[player]
        if state then
            local packet=self:Packet({Player=player,State=state,Ability=cast.Ability},"Cancel",cast.Position)
            if packet then packet.Token=cast.Token;self.World.FX:FireAllClients(packet) end
        end
        self.Active[player]=nil
    end
    self.Counters[player]=nil
    self.LastSync[player]=nil
    self.Gates[player]=nil
    for model,packet in pairs(self.Echoes) do if packet.Owner==player.UserId then self.Echoes[model]=nil end end
    for target,records in pairs(self.StatusRecords) do
        for id,record in pairs(records) do
            if record.Owner==player then self:StatusPacket(record,"Remove");records[id]=nil end
        end
        if next(records)==nil then self.StatusRecords[target]=nil end
    end
end
function Visual.Trigger(self: any,player: any,trigger: string,abilityId: string,position: Vector3,target: any)
    local state=self.World.States[player]
    local ability=self.World.Data and self.World.Data.Abilities[abilityId]
    if not state or not ability then return end
    local packet=self:Packet({Player=player,State=state,Ability=ability},"Trigger",position)
    if not packet then return end
    self.CueSerial+=1
    packet.Kind="VisualTrigger";packet.CueId=self.CueSerial;packet.Trigger=trigger;packet.Target=target
    local root=self.World:Root(player)
    packet.Origin=if root then root.Position else position;packet.Destination=position;packet.Outcome="Confirmed"
    self.World.FX:FireAllClients(packet)
end
function Visual.RemoveGates(self: any,player: any)
    self.Gates[player]=nil
    self.CueSerial+=1
    self.World.FX:FireAllClients({Kind="GateRemoval",Owner=player.UserId,At=self.Clock(),CueId=self.CueSerial})
end
function Visual.StatusPacket(self: any,record: any,action: string,recipient: any?)
    -- A sync is a fresh observation: old revisions could be below a late joiner's
    -- newest live receipt, causing otherwise-current statuses to be discarded.
    self.Revision+=1;record.Revision=self.Revision
    local packet={Kind="StatusVisual",Action=action,Owner=record.Owner.UserId,Target=record.Target,StatusId=record.Id,
        Position=record.Position,ExpiresAt=record.ExpiresAt,PathwayId=record.PathwayId,Count=record.Count,
        Revision=record.Revision,Required=record.Required,Private=self.StatusConfig.Private[record.Id]==true,At=self.Clock()}
    if recipient then
        if not packet.Private or recipient==record.Owner then self.World.FX:FireClient(recipient,packet) end
    elseif packet.Private then
        local state=self.World.States[record.Owner]
        if state and state.Ready then self.World.FX:FireClient(record.Owner,packet) end
    else self.World.FX:FireAllClients(packet) end
end
function Visual.Statuses(self: any,now: number)
    local current={};local count=0
    local function collect(target: any,root: any,statuses: any,defaultOwner: any,threads: number?)
        if not target or not root or not self.World:FiniteVector(root.Position) then return end
        for id,status in pairs(statuses or {}) do
            local owner=status.Owner or defaultOwner
            local state=owner and self.World.States[owner]
            if self.StatusConfig.Labels[id] and state and state.Ready and not state.Dead and status.ExpiresAt>now
                and count<self.Config.MaxTrackedStatuses then
                count+=1;current[target]=current[target] or {}
                local old=self.StatusRecords[target] and self.StatusRecords[target][id]
                local record={Target=target,Owner=owner,Id=id,Until=status.ExpiresAt,Position=root.Position,
                    ExpiresAt=self.Clock()+math.max(0,status.ExpiresAt-now),PathwayId=state.Profile and state.Profile.PathwayId or "Seer",
                    Count=if id=="Threaded" then threads or 0 else 0}
                if id=="Threaded" then
                    local a=self.World.Data and self.World.Data.Abilities and self.World.Data.Abilities.Seer_5
                    record.Required=if record.PathwayId=="Seer" and a then a.Operation.RequiredHits else 1
                end
                if not old or old.Owner~=owner or old.Until~=record.Until or old.Count~=record.Count or old.PathwayId~=record.PathwayId then
                    if old and old.Owner~=owner then self:StatusPacket(old,"Remove") end
                    self:StatusPacket(record,"Set")
                else record.Revision=old.Revision end
                current[target][id]=record
            end
        end
    end
    for _,entity in pairs(self.World.Entities or {}) do
        if entity.Model.Parent and entity.Humanoid.Health>0 then collect(entity.Model,entity.Root,entity.Statuses,nil,entity.Threads) end
    end
    for player,state in pairs(self.World.States) do
        if state.Ready and not state.Dead and player.Character then
            local root=if self.World.Root then self.World:Root(player) else player.Character.PrimaryPart
            collect(player.Character,root,state.Statuses,player,nil)
        end
    end
    for target,records in pairs(self.StatusRecords) do
        for id,record in pairs(records) do
            if not current[target] or not current[target][id] then self:StatusPacket(record,"Remove") end
        end
    end
    self.StatusRecords=current
end
function Visual.Sync(self: any,player: any)
    local now=self.Clock()
    if now-(self.LastSync[player] or -math.huge)<self.Config.SyncInterval then return end
    self.LastSync[player]=now
    local records={}
    for _,targetRecords in pairs(self.StatusRecords) do
        for _,record in pairs(targetRecords) do
            if not self.StatusConfig.Private[record.Id] or record.Owner==player then table.insert(records,record) end
        end
    end
    table.sort(records,function(a,b) return a.Revision<b.Revision end)
    for i,record in ipairs(records) do
        if i>self.Config.MaxStatusRecords then break end
        self:StatusPacket(record,"Set",player)
    end
    for _,source in pairs(self.Gates) do
        if source.ExpiresAt>now then
            local packet=table.clone(source);packet.Kind="GateSnapshot";packet.At=now
            self.World.FX:FireClient(player,packet)
        end
    end
    for model,source in pairs(self.Echoes) do
        if model.Parent and source.ExpiresAt>now then
            local packet=table.clone(source);packet.Kind="EchoSnapshot";packet.At=now
            self.World.FX:FireClient(player,packet)
        end
    end
end
return Visual
