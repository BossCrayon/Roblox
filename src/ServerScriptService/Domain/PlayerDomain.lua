--!strict
-- Pure server-owned rules; no Roblox services, yielding, remotes or client decisions.
local Domain = {}
Domain.__index = Domain
type Fields = {Data: any, Random: () -> number}
type Domain = typeof(setmetatable({} :: Fields, Domain))

local function finite(n: any): boolean
    return type(n)=="number" and n==n and math.abs(n)<math.huge
end
local function copy(value: any): any
    if type(value)~="table" then return value end
    local out={}
    for k,v in pairs(value) do out[k]=copy(v) end
    return out
end
local function bounded(n: any, lo: number, hi: number): boolean
    return finite(n) and n>=lo and n<=hi
end
function Domain.new(data: any, random: (() -> number)?): Domain
    return setmetatable({Data=data, Random=random or math.random} :: Fields, Domain)
end
function Domain.Default(self: Domain): any
    local p=copy(self.Data.Progression.DefaultPlayer)
    p.Sanity=100; p.Gold=0; p.WishCredits=0
    for id,potion in pairs(self.Data.Potions.ById) do
        if potion.TargetSequence==9 then p.Inventory[id]=1 end
    end
    return p
end
function Domain.Stats(self: Domain, profile: any): any
    if profile.PathwayId then
        return copy(self.Data.Pathways[profile.PathwayId].Sequences[profile.Sequence].BaseStats)
    end
    return {Health=100,Spirituality=50,Sanity=100,Strength=8,Agility=10,Perception=20,Intuition=8,Resistance=8,SpiritualityRegen=2}
end
function Domain.Unlocked(self: Domain, p: any, id: any): boolean
    local a=self.Data.Abilities[id]
    return a~=nil and p.PathwayId==a.PathwayId and type(p.Sequence)=="number" and p.Sequence<=a.UnlockSequence
end
function Domain.Validate(self: Domain, raw: any): (any?, string?)
    if type(raw)~="table" or raw.SchemaVersion~=1 then return nil,"Unsupported profile schema" end
    local p=copy(self.Data.Progression.DefaultPlayer)
    if raw.PathwayId~=false then
        local path=self.Data.Pathways[raw.PathwayId]
        if not path or not finite(raw.Sequence) or raw.Sequence%1~=0 or not path.Sequences[raw.Sequence] then
            return nil,"Invalid pathway or sequence"
        end
        p.PathwayId=raw.PathwayId; p.Sequence=raw.Sequence
    elseif raw.Sequence~=false then return nil,"Uninitiated profile has a sequence" end
    for _,key in ipairs({"Digestion","ActingProgress","Sanity","Gold","WishCredits"}) do
        local max=if key=="ActingProgress" or key=="Gold" then 10000000 else 100
        local value=raw[key]
        if value==nil and (key=="Gold" or key=="WishCredits") then value=0 end
        if value==nil and key=="Sanity" then value=100 end
        if not bounded(value,0,max) then return nil,"Invalid "..key end
        p[key]=value
    end
    if type(raw.Inventory)~="table" then return nil,"Invalid inventory" end
    local entries=0
    for id,n in pairs(raw.Inventory) do
        entries+=1
        if entries>100 or not self.Data.Potions.ById[id] or not bounded(n,0,99) or n%1~=0 then return nil,"Invalid inventory item" end
        p.Inventory[id]=n
    end
    if type(raw.ObjectiveProgress)~="table" or type(raw.AbilityLoadout)~="table" then return nil,"Invalid progress/loadout" end
    if p.PathwayId then
        for _,o in ipairs(self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].ActingObjectives) do
            local n=raw.ObjectiveProgress[o.Id] or 0
            if not bounded(n,0,o.RequiredCount) or n%1~=0 then return nil,"Invalid objective count" end
            p.ObjectiveProgress[o.Id]=n
        end
    end
    local seen={}
    for slot=1,6 do
        local id=raw.AbilityLoadout[slot]
        if id~=nil then
            if type(id)~="string" or not self:Unlocked(p,id) or seen[id] then return nil,"Invalid ability loadout" end
            p.AbilityLoadout[slot]=id; seen[id]=true
        end
    end
    -- Never trust persisted maxima: rebalance/migration derives these from the sequence.
    p.Stats=self:Stats(p)
    return p,nil
end
function Domain.NewState(self: Domain, profile: any, now: number): any
    local p,err=self:Validate(profile)
    assert(p,err)
    return {Profile=p,Stats=self:Stats(p),Health=p.Stats.Health,Spirituality=p.Stats.Spirituality,
        Sanity=p.Sanity,Mode=if p.Sanity==0 then "Madness" else "Normal",MadnessUntil=now+10,
        Cooldowns={},GlobalUntil=0,LastCast=-100,LastCombat=-100,Pending=nil,CastSerial=0,
        ObjectiveLast={},SeenEvents={},SeenOrder={},Statuses={},Dead=false,Ready=true,
        RecordedPower=nil,StolenPower=nil,LastMelee=-100,LastRitual=-100}
end
function Domain.Snapshot(self: Domain, s: any): any
    local p=copy(s.Profile)
    p.Stats=copy(s.Stats); p.Sanity=s.Sanity
    return p
end
function Domain.AutoEquip(self: Domain, s: any)
    local ids={}
    for id,a in pairs(self.Data.Abilities) do
        if self:Unlocked(s.Profile,id) then table.insert(ids,id) end
    end
    table.sort(ids,function(a,b)
        local aa,bb=self.Data.Abilities[a],self.Data.Abilities[b]
        return if aa.UnlockSequence==bb.UnlockSequence then a<b else aa.UnlockSequence<bb.UnlockSequence
    end)
    s.Profile.AbilityLoadout={}
    for i=1,math.min(6,#ids) do s.Profile.AbilityLoadout[i]=ids[i] end
end
function Domain.Equip(self: Domain, s: any, slot: any, id: any): (boolean,string)
    if not finite(slot) or slot%1~=0 or slot<1 or slot>6 or type(id)~="string" or not self:Unlocked(s.Profile,id) then return false,"Invalid ability slot" end
    if s.Pending then return false,"Finish casting first" end
    for i,other in pairs(s.Profile.AbilityLoadout) do
        if other==id then s.Profile.AbilityLoadout[i]=nil end
    end
    s.Profile.AbilityLoadout[slot]=id
    return true,"Ability equipped"
end
function Domain.DrainSanity(self: Domain, s: any, amount: number, now: number)
    if amount<=0 or s.Mode=="LostControl" then return end
    local guard=s.Statuses.Composed
    local mitigation=if guard and guard.ExpiresAt>now then 0.5 else 1
    local resistance=100/(100+s.Stats.Resistance)
    s.Sanity=math.max(0,s.Sanity-amount*resistance*mitigation)
    if s.Sanity==0 and s.Mode=="Normal" then
        s.Mode="Madness"; s.MadnessUntil=now+self.Data.Progression.Sanity.MadnessDurationSeconds
        self:CancelCast(s,false)
    end
end
function Domain.Drink(self: Domain, s: any, id: any, now: number): (boolean,string)
    local potion=self.Data.Potions.ById[id]
    if not potion or not s.Ready or s.Dead or s.Mode~="Normal" or s.Pending then return false,"Cannot drink now" end
    if now-s.LastRitual<2 then return false,"Wait before another ritual" end
    local p=s.Profile
    if (p.Inventory[id] or 0)<1 then return false,"You do not own that potion" end
    if potion.TargetSequence==9 then
        if p.PathwayId~=false then return false,"Your pathway is already chosen" end
    elseif p.PathwayId~=potion.PathwayId or p.Sequence~=potion.RequiredSequence then
        return false,"Potions must follow your pathway, one sequence at a time"
    end
    s.LastRitual=now
    if p.Digestion<potion.RequiredDigestion or s.Sanity<=self.Data.Progression.Sanity.BlockAdvancementAtOrBelow then
        local risk=self.Data.Potions.Rules.Risk
        local chance=math.clamp(risk.BaseChance+risk.MissingDigestionWeight*(1-p.Digestion/100)+risk.MissingSanityWeight*(1-s.Sanity/100),risk.MinChance,risk.MaxChance)
        self:DrainSanity(s,if self.Random()<chance then self.Data.Progression.Sanity.UnsafeRitualDrain else self.Data.Progression.Sanity.FailedRitualDrain,now)
        return false,"Unsafe ritual rejected; your sanity suffered"
    end
    p.Inventory[id]-=1; p.PathwayId=potion.PathwayId; p.Sequence=potion.TargetSequence
    p.Digestion=0; p.ActingProgress=0; p.ObjectiveProgress={}
    s.Stats=self:Stats(p); p.Stats=copy(s.Stats)
    s.Health=s.Stats.Health; s.Spirituality=s.Stats.Spirituality
    s.ObjectiveLast={}; s.SeenEvents={}; s.SeenOrder={}; s.Statuses={}
    self:AutoEquip(s)
    return true,"Advanced to "..self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].Name
end
function Domain.Act(self: Domain, s: any, signal: string, eventId: string, now: number): boolean
    local p=s.Profile
    if not s.Ready or s.Dead or s.Mode~="Normal" or not p.PathwayId or s.SeenEvents[eventId] then return false end
    local objectives=self.Data.Pathways[p.PathwayId].Sequences[p.Sequence].ActingObjectives
    for _,o in ipairs(objectives) do
        if o.ServerSignal==signal and now-(s.ObjectiveLast[o.Id] or -1000)>=o.CooldownSeconds then
            s.SeenEvents[eventId]=true; table.insert(s.SeenOrder,eventId)
            if #s.SeenOrder>256 then s.SeenEvents[table.remove(s.SeenOrder,1)]=nil end
            local n=(p.ObjectiveProgress[o.Id] or 0)+1
            p.ObjectiveProgress[o.Id]=n
            if n>=o.RequiredCount then
                p.ObjectiveProgress[o.Id]=0; s.ObjectiveLast[o.Id]=now
                p.Digestion=math.min(100,p.Digestion+o.DigestionReward)
                p.ActingProgress=math.min(10000000,p.ActingProgress+o.ActingProgressReward)
                p.WishCredits=math.min(100,p.WishCredits+1)
            end
            return true
        end
    end
    return false
end
function Domain.BeginCast(self: Domain, s: any, id: any, now: number): (any?,string?)
    local a=self.Data.Abilities[id]
    if not a or not a.Implemented or not self:Unlocked(s.Profile,id) then return nil,"Ability is unavailable" end
    local equipped=false
    for _,v in pairs(s.Profile.AbilityLoadout) do if v==id then equipped=true end end
    if not equipped then return nil,"Equip this ability first" end
    if not s.Ready or s.Dead or s.Mode~="Normal" or s.Pending then return nil,"Cannot cast now" end
    if now<s.GlobalUntil or now<(s.Cooldowns[id] or 0) then return nil,"Ability is cooling down" end
    if s.Spirituality<a.SpiritualityCost then return nil,"Not enough spirituality" end
    s.Spirituality-=a.SpiritualityCost; s.LastCast=now; s.CastSerial+=1
    local pending={Id=id,Token=s.CastSerial,EndsAt=now+a.CastTimeSeconds,Cost=a.SpiritualityCost}
    s.Pending=pending; s.GlobalUntil=now+self.Data.Progression.Abilities.GlobalCooldownSeconds
    s.Cooldowns[id]=now+a.CooldownSeconds
    return pending,nil
end
function Domain.CancelCast(self: Domain, s: any, refund: boolean)
    if s.Pending and refund then s.Spirituality=math.min(s.Stats.Spirituality,s.Spirituality+s.Pending.Cost) end
    s.Pending=nil
end
function Domain.Tick(self: Domain, s: any, dt: number, now: number)
    if not s.Ready then return end
    dt=math.clamp(dt,0,2)
    for key,status in pairs(s.Statuses) do if status.ExpiresAt<=now then s.Statuses[key]=nil end end
    if s.Mode=="Madness" and now>=s.MadnessUntil then s.Mode="LostControl"; s.Health=0 end
    if not s.Dead and s.Mode=="Normal" then
        if now-s.LastCast>=2 then
            local combat=if now-s.LastCombat<5 then self.Data.Progression.Spirituality.CombatRegenMultiplier else 1
            s.Spirituality=math.min(s.Stats.Spirituality,s.Spirituality+s.Stats.SpiritualityRegen*dt*combat)
        end
        s.Sanity=math.min(100,s.Sanity+self.Data.Progression.Sanity.RecoveryPerSecond*dt)
    end
end
function Domain.Recover(self: Domain, s: any): (boolean,string)
    if s.Mode=="Normal" and s.Sanity>=100 then return false,"You are already well" end
    s.Mode="Normal"; s.Sanity=100; s.Statuses={}; s.Pending=nil
    s.Profile.Digestion=math.max(0,s.Profile.Digestion-self.Data.Progression.Sanity.RecoveryDigestionPenalty)
    return true,"Stabilized; 20 digestion sacrificed"
end
function Domain.BuyNextPotion(self: Domain, s: any): (boolean,string)
    local p=s.Profile
    if not p.PathwayId or p.Sequence<=1 then return false,"No next potion" end
    local id=p.PathwayId.."_Potion_"..tostring(p.Sequence-1)
    if (p.Inventory[id] or 0)>0 then return false,"You already have your next potion" end
    if p.Gold<self.Data.Runtime.NextPotionGoldCost then return false,"Requires 100 gold from enemies" end
    p.Gold-=self.Data.Runtime.NextPotionGoldCost; p.Inventory[id]=1
    return true,"Next potion acquired"
end
Domain.Copy=copy
Domain.Finite=finite
return Domain
