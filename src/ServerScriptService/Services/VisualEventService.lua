--!strict
-- Server-only evidence adapter. It observes accepted casts; it never changes outcomes.
local Visual={}
function Visual.new(world: any,config: any,clock: ()->number): any
    return setmetatable({World=world,Config=config,Clock=clock,Active={},Counters={}},{__index=Visual})
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
    return {Origin=c.Root.Position,Stored=c.State.StolenPower}
end
function Visual.Result(self: any,c: any,before: any,ok: boolean,evidence: any,now: number)
    local packet=self:Packet(c,if ok then "Result" else "Cancel",if ok then c.Position else before.Origin)
    self.Active[c.Player]=nil
    if not packet then return end
    packet.Origin=before.Origin;packet.Destination=c.Root.Position
    packet.Target=c.VisualTarget or (c.Entity and c.Entity.Model)
    packet.Outcome=if evidence==false and c.Ability.Operation.Kind=="Sense" then "Obscured" else "Confirmed"
    if c.Ability.Operation.Kind=="Theft" then packet.Outcome="Taken"
    elseif c.Ability.Operation.Kind=="StealPower" then
        packet.Outcome=if before.Stored then "Released" else "Captured"
        packet.PowerId=before.Stored or c.State.StolenPower
    end
    if c.VisualExpires then packet.ExpiresAt=packet.At+math.max(0,c.VisualExpires-now) end
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
function Visual.Step(self: any)
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
end
return Visual
