--!strict
-- Data-driven ability executors. Only trusted server definitions select these handlers.
local CollectionService=game:GetService("CollectionService")
local Effects={}
Effects.__index=Effects
type Fields = {
    World: any, Domain: any, Notify: (Player, string) -> (),
    Gates: {[Player]: any}, OpenDoors: {[BasePart]: number},
}
type Effects = typeof(setmetatable({} :: Fields, Effects))

local handlers={}
function Effects.new(world: any,domain: any,notify: any): Effects
    return setmetatable({World=world,Domain=domain,Notify=notify,Gates={},OpenDoors={}} :: Fields, Effects)
end
function Effects.Validate(self: Effects, player: Player,s: any,a: any,input: any): (any?,string?)
    local world=self.World;local root=world:Root(player);local hum=world:Humanoid(player)
    if not root or not world:FiniteVector(root.Position) or not hum or hum.Health<=0 or not s.Ready or s.Dead or s.Mode~="Normal" then return nil,"Your character is unavailable" end
    local context={Player=player,State=s,Ability=a,Root=root,Position=root.Position,Entity=nil}
    if a.Target=="NPC" then
        local entity=world:Entity(input.Target)
        if not entity then return nil,"Aim at a living enemy" end
        local owned=a.Operation.Kind=="Command" or a.Operation.Kind=="Exchange"
        if owned then
            if entity.Owner~=player then return nil,"Target your own marionette" end
        elseif entity.Owner~=nil then return nil,"Target a hostile enemy" end
        context.Entity=entity;context.Position=entity.Root.Position
    elseif a.Target=="Position" then
        if not world:FiniteVector(input.Position) then return nil,"Aim at a location" end
        context.Position=input.Position
    end
    if (context.Position-root.Position).Magnitude>a.RangeStuds+1 then return nil,"Target is out of range" end
    if a.Target~="Self" and a.Hitbox.LineOfSight and not world:LineOfSight(root.Position,context.Position,player.Character,context.Entity and context.Entity.Model) then return nil,"Your target is obstructed" end
    return context,nil
end
function Effects.Execute(self: Effects, context: any,now: number): (boolean,string)
    local a=context.Ability;local op=a.Operation
    local handler=op and handlers[op.Kind]
    if not handler then return false,"No executor exists for this ability" end
    local visuals=self.World.Visuals
    local before=visuals and visuals:Capture(context)
    local ok,message,evidence=handler(self,context,op,now)
    if visuals then visuals:Result(context,before,ok,evidence,now) end
    if ok then
        local world=self.World
        if not visuals then world:Effect(context.Position,a.Id,context.Player,context.Entity and context.Entity.Model) end
        if op.Signal and evidence~=false then
            self.Domain:Act(context.State,op.Signal,"cast:"..tostring(context.State.CastSerial),now)
        end
    end
    return ok,message
end
local function buff(self: any,c: any,op: any,now: number)
    if op.Status then self.World:Buff(c.State,op.Status,op.Duration or 10,now) end
end
local function power(c: any,op: any): number return c.Ability.BasePower*(op.Power or 1) end
local function affected(c: any,e: any)
    c.VisualAffected=c.VisualAffected or {}
    table.insert(c.VisualAffected,{Target=e.Model,Position=e.Root.Position})
end
local function teleport(self: any,c: any,position: Vector3): boolean
    local safe=self.World:SafeDestination(c.Player,position)
    if not safe or not c.Player.Character then return false end
    local state=self.World.States[c.Player]
    if state then state.TeleportGraceUntil=os.clock()+1;state.LastPosition=safe end
    c.Player.Character:PivotTo(CFrame.new(safe)*c.Root.CFrame.Rotation)
    c.Root.AssemblyLinearVelocity=Vector3.zero
    return true
end
handlers.Buff=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now);return true,"Effect prepared"
end
handlers.Sense=function(self: any,c: any,op: any,now: number)
    local enemies=self.World:Targets(c.Root.Position,c.State.Stats.Perception,16,c.Player)
    if #enemies==0 and op.Signal then return false,"No spiritual trace is close enough" end
    if op.Signal then
        local accuracy=self.World.Data.Runtime.DivinationAccuracy
        local intuition=c.State.Stats.Intuition
        local chance=accuracy.Base+accuracy.Bonus*intuition/(intuition+accuracy.IntuitionScale)
        local random=self.World.Random or math.random
        if random()>chance then
            self.Domain:DrainSanity(c.State,2,now)
            return true,"The omen is obscured; no acting progress earned",false
        end
    end
    buff(self,c,op,now)
    if self.World.Visuals then self.World.Visuals:Reveal(c,enemies,now)
    else for _,e in ipairs(enemies) do self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=e.Root.Position,Target=e.Model}) end end
    if enemies[1] then
        local e=enemies[1]
        self.Notify(c.Player,"Reading: omen "..tostring(e.Model:GetAttribute("Omen")).." · target HP "..tostring(math.ceil(e.Humanoid.Health)))
    end
    return true,"Spiritual traces revealed"
end
handlers.SenseDoors=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    local revealed={}
    for _,door in ipairs(CollectionService:GetTagged("MysticDoor")) do
        if door:IsA("BasePart") and (door.Position-c.Root.Position).Magnitude<=c.State.Stats.Perception then
            if self.World.Visuals then table.insert(revealed,{Part=door,Position=door.Position})
            else self.World.FX:FireClient(c.Player,{Kind="Reveal",Position=door.Position,Target=door}) end
        end
    end
    if self.World.Visuals then self.World.Visuals:Reveal(c,revealed,now) end
    return true,"Passages revealed"
end
handlers.Dodge=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    local destination=c.Root.Position-c.Root.CFrame.LookVector*8
    teleport(self,c,destination)
    return true,"Evade an incoming strike",false
end
handlers.FlameJump=function(self: any,c: any,op: any,now: number)
    local anchor=nil;local distance=12
    for _,p in ipairs(CollectionService:GetTagged("FlameAnchor")) do
        if p:IsA("BasePart") and (p.Position-c.Position).Magnitude<distance then anchor=p;distance=(p.Position-c.Position).Magnitude end
    end
    if not anchor then return false,"Aim near an orange flame anchor" end
    local threats=self.World:Targets(c.Root.Position,20,1,c.Player)
    local origin=c.Root.Position
    if not teleport(self,c,anchor.Position+Vector3.new(3,0,0)) then return false,"The landing is obstructed" end
    local escaped=#threats>0 and (origin-c.Root.Position).Magnitude>=15
    return true,"Flame jump",escaped
end
handlers.Disguise=function(self: any,c: any,op: any,now: number)
    local profile=self.World.Data.Runtime.Disguises[op.Profile or "Wanderer"]
    if not profile then return false,"Unknown disguise profile" end
    buff(self,c,op,now)
    c.State.DisguiseUntil=now+(op.Duration or 30)
    local hum=self.World:Humanoid(c.Player)
    if hum then
        if not c.State.OriginalDisplayName then c.State.OriginalDisplayName=hum.DisplayName end
        hum.DisplayName=profile.DisplayName
        for name,value in pairs(profile.Scales) do
            local scale=hum:FindFirstChild(name)
            if scale and scale:IsA("NumberValue") then
                if scale:GetAttribute("MysteriesOriginalScale")==nil then scale:SetAttribute("MysteriesOriginalScale",scale.Value) end
                scale.Value=value
            end
        end
    end
    local character=c.Player.Character
    if character then
        local oldMask=character:FindFirstChild("MysteriesDisguise")
        if oldMask then oldMask:Destroy() end
        for _,p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                if p:GetAttribute("OriginalColor")==nil then p:SetAttribute("OriginalColor",p.Color) end
                p.Color=Color3.fromRGB(table.unpack(profile.Color))
            end
        end
        local head=character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            -- An original mask replaces the visible face; no marketplace face assets.
            local mask=Instance.new("Part");mask.Name="MysteriesDisguise";mask.Size=head.Size*1.03;mask.CFrame=head.CFrame
            mask.CanCollide=false;mask.CanTouch=false;mask.CanQuery=false;mask.Massless=true
            mask.Color=Color3.fromRGB(table.unpack(profile.Color));mask.Parent=character
            local weld=Instance.new("WeldConstraint");weld.Part0=head;weld.Part1=mask;weld.Parent=mask
        end
    end
    self.World.FX:FireClient(c.Player,{Kind="VoiceProfile",Position=c.Root.Position,Hook=c.Ability.SFXHook,Pitch=profile.VoicePitch})
    return true,"Identity changed: "..profile.DisplayName.."; infiltrate the Hidden Archive"
end
handlers.Control=function(self: any,c: any,op: any,now: number)
    local e=c.Entity
    if e.Tier<c.State.Profile.Sequence then return false,"This enemy is too powerful to control" end
    local owned=0
    for _,other in pairs(self.World.Entities) do if other.Owner==c.Player then owned+=1 end end
    if owned>=self.World.Data.Runtime.MaxOwnedSummons then return false,"Your summon limit is reached" end
    e.Threads+=1
    self.World:Status(e,"Threaded",math.max(20,c.Ability.CooldownSeconds+3),now,c.Player)
    local required=op.RequiredHits or 1
    if e.Threads<required then return true,"Threads "..tostring(e.Threads).." / "..tostring(required),false end
    e.Threads=0;e.Owner=c.Player;e.Statuses.Threaded=nil
    self.World:Status(e,"Controlled",op.Duration or 15,now,c.Player)
    return true,"Marionette secured"
end
handlers.Command=function(self: any,c: any,op: any,now: number)
    local foes=self.World:Targets(c.Entity.Root.Position,45,1,c.Player)
    if not foes[1] then return false,"No hostile target near the marionette" end
    self.World:Damage(foes[1],power(c,op),c.Player,now)
    affected(c,foes[1])
    return true,"Marionette strike"
end
handlers.Exchange=function(self: any,c: any,op: any,now: number)
    local original=c.Root.Position;local other=c.Entity.Root.Position
    local threatened=#self.World:Targets(original,25,1,c.Player)>0
    if not teleport(self,c,other+Vector3.new(4,0,0)) then return false,"Exchange destination is blocked" end
    c.Entity.Model:PivotTo(CFrame.new(original))
    self.World:Buff(c.State,"Invulnerable",2,now)
    return true,"Marionette exchange",threatened
end
handlers.Area=function(self: any,c: any,op: any,now: number)
    local radius=math.max(10,c.Ability.RadiusStuds)
    c.VisualRadius=radius
    local enemies=self.World:Targets(c.Position,radius,c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No enemies in the area" end
    for _,e in ipairs(enemies) do
        if self.World:LineOfSight(c.Position,e.Root.Position,c.Player.Character,e.Model) then
            self.World:Damage(e,power(c,op),c.Player,now)
            affected(c,e)
            if op.Status then self.World:Status(e,op.Status,op.Duration or 5,now,c.Player,power(c,op)*0.15) end
        end
    end
    return true,"Area effect released"
end
handlers.Echo=function(self: any,c: any,op: any,now: number)
    if not c.State.ArchiveRead then return false,"Read the Hidden Archive before invoking a past echo" end
    local count=0
    for _,e in pairs(self.World.Entities) do if e.Owner==c.Player then count+=1 end end
    if count>=self.World.Data.Runtime.MaxOwnedSummons then return false,"Your summon limit is reached" end
    local safe=self.World:SafeDestination(c.Player,c.Position)
    if not safe then return false,"Cannot summon here" end
    local e=self.World:Spawn(safe,c.State.Profile.Sequence,c.Player,now+(op.Duration or 20))
    e.IsEcho=true;c.State.ArchiveRead=false
    c.VisualEcho=e.Model;c.VisualExpires=e.ExpiresAt
    return true,"Past echo summoned"
end
handlers.Recall=function(self: any,c: any,op: any,now: number)
    local hum=self.World:Humanoid(c.Player)
    if not hum then return false,"Character missing" end
    local fraction=op.Power or 0.25
    if hum.Health>=hum.MaxHealth and c.State.Spirituality>=c.State.Stats.Spirituality-c.Ability.SpiritualityCost then return false,"Nothing needs recovery" end
    hum.Health=math.min(hum.MaxHealth,hum.Health+hum.MaxHealth*fraction)
    c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+c.State.Stats.Spirituality*fraction)
    return true,"A measure of past vitality recalled"
end
handlers.Wish=function(self: any,c: any,op: any,now: number)
    local hum=self.World:Humanoid(c.Player);local p=c.State.Profile
    if not hum or (hum.Health>=hum.MaxHealth and c.State.Sanity>=100) then return false,"No recovery wish can be fulfilled here" end
    if p.WishCredits<1 then return false,"Earn a wish credit by completing acting objectives" end
    p.WishCredits-=1
    hum.Health=math.min(hum.MaxHealth,hum.Health+hum.MaxHealth*(op.Power or 1))
    c.State.Sanity=math.min(100,c.State.Sanity+30)
    self.World:Buff(c.State,"Shielded",8,now)
    return true,"Recovery wish fulfilled"
end
handlers.Graft=function(self: any,c: any,op: any,now: number)
    c.VisualRadius=math.max(15,c.Ability.RadiusStuds)
    local enemies=self.World:Targets(c.Position,math.max(15,c.Ability.RadiusStuds),c.Ability.MaxTargets,c.Player)
    if #enemies==0 then return false,"No hostile attacks to graft" end
    for _,e in ipairs(enemies) do self.World:Status(e,"Grafted",op.Duration or 10,now,c.Player);affected(c,e) end
    return true,"Hostile attacks grafted back to their source",false
end
handlers.Theft=function(self: any,c: any,op: any,now: number)
    if c.Entity.Stolen then return false,"This enemy has already been pickpocketed" end
    c.Entity.Stolen=true;c.State.Profile.Gold=math.min(10000000,c.State.Profile.Gold+5)
    self.World:Status(c.Entity,"Confused",2,now,c.Player)
    return true,"Stole 5 gold"
end
handlers.Debuff=function(self: any,c: any,op: any,now: number)
    if op.Power then self.World:Damage(c.Entity,power(c,op),c.Player,now) end
    if op.Status then self.World:Status(c.Entity,op.Status,op.Duration or 5,now,c.Player,power(c,op)*0.2) end
    if op.Status=="TimeSlow" then c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+c.Ability.SpiritualityCost*0.25) end
    return true,"Hostile influence applied"
end
handlers.Cipher=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    return true,"Cipher sight: use the Cipher Archive while this effect lasts"
end
handlers.StealPower=function(self: any,c: any,op: any,now: number)
    local powerId=c.Entity.Model:GetAttribute("AbilityId")
    if not self.World.Data.Runtime.CopyableNPCPowers[powerId] then return false,"This power cannot be stolen" end
    if c.State.StolenPower then
        local spec=self.World.Data.Runtime.CopyableNPCPowers[c.State.StolenPower]
        c.State.StolenPower=nil
        self.World:Damage(c.Entity,c.Ability.BasePower*spec.Power,c.Player,now)
        self.World:Status(c.Entity,spec.Status,spec.Duration,now,c.Player,c.Ability.BasePower*0.2)
        return true,"Stolen power released",false
    end
    c.State.StolenPower=powerId
    self.World:Status(c.Entity,"Silenced",op.Duration or 10,now,c.Player)
    return true,"Power stolen; cast again to release it"
end
handlers.Siphon=function(self: any,c: any,op: any,now: number)
    local host=c.Entity.Statuses.Parasite
    if op.RequiresHost and (not host or host.Owner~=c.Player or host.ExpiresAt<=now) then return false,"Target your parasitized host" end
    local before=c.Entity.Humanoid.Health
    self.World:Damage(c.Entity,power(c,op),c.Player,now)
    local removed=math.min(before,power(c,op))
    local hum=self.World:Humanoid(c.Player)
    if hum then hum.Health=math.min(hum.MaxHealth,hum.Health+removed*0.5) end
    c.State.Spirituality=math.min(c.State.Stats.Spirituality,c.State.Spirituality+removed*0.3)
    return true,"Vitality and spirituality siphoned"
end
handlers.Parasite=function(self: any,c: any,op: any,now: number)
    if c.Entity.Tier<c.State.Profile.Sequence then return false,"This host is too powerful" end
    for _,e in pairs(self.World.Entities) do
        local st=e.Statuses.Parasite
        if st and st.Owner==c.Player and e~=c.Entity then e.Statuses.Parasite=nil end
    end
    self.World:Status(c.Entity,"Parasite",op.Duration or 12,now,c.Player,power(c,op)*0.15)
    self.World:Buff(c.State,"Shielded",op.Duration or 12,now)
    return true,"Host parasitized"
end
handlers.Infiltrate=function(self: any,c: any,op: any,now: number)
    local e=c.Entity
    if not teleport(self,c,e.Root.Position-e.Root.CFrame.LookVector*7) then return false,"No safe infiltration point" end
    self.World:Status(e,"Payload",op.Duration or 10,now,c.Player,power(c,op)*2)
    self.World:Buff(c.State,"Invulnerable",1,now)
    return true,"A hidden payload entered the target's destiny"
end
handlers.Record=function(self: any,c: any,op: any,now: number)
    local id=c.Entity.Model:GetAttribute("AbilityId")
    if not self.World.Data.Runtime.CopyableNPCPowers[id] then return false,"This power cannot be recorded" end
    if not c.Entity.LastSpell or now-c.Entity.LastSpell>15 then return false,"Observe an enemy casting its power before recording it" end
    c.State.RecordedPower={Id=id,Charges=3}
    return true,"Power recorded: 3 releases available"
end
handlers.Release=function(self: any,c: any,op: any,now: number)
    local record=c.State.RecordedPower
    if not record or record.Charges<=0 then return false,"Record a permitted enemy power first" end
    local spec=self.World.Data.Runtime.CopyableNPCPowers[record.Id]
    if not spec then return false,"The recording is invalid" end
    record.Charges-=1
    self.World:Damage(c.Entity,power(c,op)*spec.Power,c.Player,now)
    self.World:Status(c.Entity,spec.Status,spec.Duration,now,c.Player,power(c,op)*0.2)
    return true,"Recorded phenomenon released"
end
handlers.OpenDoor=function(self: any,c: any,op: any,now: number)
    local nearest=nil;local distance=10
    for _,door in ipairs(CollectionService:GetTagged("MysticDoor")) do
        if door:IsA("BasePart") and (door.Position-c.Position).Magnitude<distance then nearest=door;distance=(door.Position-c.Position).Magnitude end
    end
    if not nearest or self.OpenDoors[nearest] then return false,"Aim at a closed practice door" end
    nearest.CanCollide=false;nearest.Transparency=0.75;self.OpenDoors[nearest]=now+20
    c.VisualTarget=nearest;c.VisualExpires=self.OpenDoors[nearest]
    return true,"Locked passage opened"
end
handlers.Travel=function(self: any,c: any,op: any,now: number)
    if (c.Position-c.Root.Position).Magnitude<10 then return false,"Choose a destination at least 10 studs away" end
    if not teleport(self,c,c.Position) then return false,"The destination is unsafe" end
    buff(self,c,op,now)
    return true,"Travel completed"
end
handlers.Conceal=function(self: any,c: any,op: any,now: number)
    buff(self,c,op,now)
    c.State.SecretUntil=now+(op.Duration or 18)
    return true,"Concealed: protect the Hidden Archive",false
end
handlers.Portal=function(self: any,c: any,op: any,now: number)
    local destination=self.World:SafeDestination(c.Player,c.Position)
    local origin=self.World:SafeDestination(c.Player,c.Root.Position)
    if not destination or not origin or (destination-origin).Magnitude<10 then return false,"Choose a safe, more distant gateway destination" end
    self:RemoveGates(c.Player)
    local gate={Owner=c.Player,EndsAt=now+(op.Duration or 25),Parts={},LastUse=-100}
    for _,pair in ipairs({{origin,destination},{destination,origin}}) do
        local p=Instance.new("Part");p.Name="SpatialGate";p.Size=Vector3.new(6,8,0.6);p.CFrame=CFrame.new(pair[1]);p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(100,150,255);p.Transparency=0.4;p.Parent=self.World.Transient
        local prompt=Instance.new("ProximityPrompt");prompt.ActionText="Enter your gate";prompt.MaxActivationDistance=8;prompt.RequiresLineOfSight=true;prompt.Parent=p
        prompt.Triggered:Connect(function(player)
            local root=self.World:Root(player);local s=self.World.States[player]
            local t=os.clock()
            if player~=c.Player or t>=gate.EndsAt or t-gate.LastUse<1 or not root or not s or not s.Ready or s.Dead or s.Mode~="Normal" or (root.Position-p.Position).Magnitude>10 then return end
            gate.LastUse=t
            local result=teleport(self,{Player=player,Root=root},pair[2]+Vector3.new(4,0,0))
            if result then self.Domain:Act(s,"TravelDestinationReached","gate:"..tostring(t),t) end
        end)
        table.insert(gate.Parts,p)
    end
    self.Gates[c.Player]=gate
    c.VisualGates=gate.Parts;c.VisualExpires=gate.EndsAt
    return true,"Linked spatial gates created"
end
handlers.CloseSpace=function(self: any,c: any,op: any,now: number)
    local hadGate=self.Gates[c.Player]~=nil
    self:RemoveGates(c.Player)
    local ok,message=handlers.Area(self,c,op,now)
    return hadGate or ok,if hadGate then "Spatial gates closed and area sealed" else message
end
function Effects.RemoveGates(self: Effects, player: Player)
    local gate=self.Gates[player]
    if gate and self.World.Visuals then self.World.Visuals:RemoveGates(player) end
    if gate then for _,p in ipairs(gate.Parts) do p:Destroy() end end
    self.Gates[player]=nil
end
function Effects.Step(self: Effects, now: number)
    for player,gate in pairs(self.Gates) do if now>=gate.EndsAt then self:RemoveGates(player) end end
    for door,expires in pairs(self.OpenDoors) do
        if not door.Parent then self.OpenDoors[door]=nil
        elseif now>=expires then
            local occupied=false
            for player in pairs(self.World.States) do
                local root=self.World:Root(player)
                if root and (root.Position-door.Position).Magnitude<6 then occupied=true;break end
            end
            if not occupied then door.CanCollide=true;door.Transparency=0;self.OpenDoors[door]=nil end
        end
    end
    for player,s in pairs(self.World.States) do
        if s.DisguiseUntil and (now>=s.DisguiseUntil or not s.Statuses.Disguised) then
            s.DisguiseUntil=nil
            local hum=self.World:Humanoid(player)
            if hum then
                hum.DisplayName=s.OriginalDisplayName or player.DisplayName
                for _,scale in ipairs(hum:GetChildren()) do
                    if scale:IsA("NumberValue") then
                        local original=scale:GetAttribute("MysteriesOriginalScale")
                        if type(original)=="number" then scale.Value=original;scale:SetAttribute("MysteriesOriginalScale",nil) end
                    end
                end
            end
            s.OriginalDisplayName=nil
            if player.Character then
                local mask=player.Character:FindFirstChild("MysteriesDisguise")
                if mask then mask:Destroy() end
                for _,p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        local color=p:GetAttribute("OriginalColor")
                        if typeof(color)=="Color3" then p.Color=color;p:SetAttribute("OriginalColor",nil) end
                    end
                end
            end
        end
    end
end
-- Exposed names allow schema coverage tests without loading Roblox services.
Effects.Handlers=handlers
return Effects
