--!strict
-- Exercises actual EffectService handlers with deterministic engine-adapter stand-ins.
-- Does not simulate Roblox physics, rendering, networking, or DataStoreService.
return function(data: any,Domain: any,loadEffects: any,loadWorld: any,VisualEvents: any)
    local checks=0
    local function check(value: any,message: string) assert(value,message);checks+=1 end
    local VM={};local V={}
    local function vec(x,y,z) return setmetatable({X=x,Y=y,Z=z},VM) end
    VM.__add=function(a,b) return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
    VM.__sub=function(a,b) return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    VM.__mul=function(a,b) if type(a)=="number" then a,b=b,a end return vec(a.X*b,a.Y*b,a.Z*b) end
    VM.__index=function(a,k)
        if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
        if k=="Unit" then local n=a.Magnitude;return if n>0 then vec(a.X/n,a.Y/n,a.Z/n) else vec(0,0,0) end
        return V[k]
    end
    function V:Dot(b) return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
    local CM={}
    local function cf(v) return setmetatable({Position=v,LookVector=vec(0,0,-1)},CM) end
    CM.__mul=function(a,b) return cf(a.Position+b.Position) end
    CM.__index=function(a,k) if k=="Rotation" then return cf(vec(0,0,0)) end end
    local function object(class)
        local attrs={}
        local o={ClassName=class,Parent=true,Children={}}
        function o:IsA(kind) return self.ClassName==kind or (kind=="BasePart" and self.ClassName=="Part") end
        function o:SetAttribute(k,v) attrs[k]=v end
        function o:GetAttribute(k) return attrs[k] end
        function o:Destroy() self.Parent=nil end
        function o:GetDescendants() return self.Children end
        function o:FindFirstChild(name) return if name=="HumanoidRootPart" then self.Root else nil end
        function o:FindFirstChildOfClass(name) return if name=="Humanoid" then self.Humanoid else nil end
        function o:PivotTo(c) self.Root.CFrame=c end
        function o:GetPivot() return self.Root.CFrame end
        o.Triggered={Connect=function(self,callback) self.Callback=callback end}
        return setmetatable(o,{
            __index=function(t,k)
                if k=="Position" then return rawget(t,"_CFrame").Position end
                if k=="CFrame" then return rawget(t,"_CFrame") end
            end,
            __newindex=function(t,k,v)
                if k=="CFrame" then rawset(t,"_CFrame",v)
                elseif k=="Position" then rawset(t,"_CFrame",cf(v))
                else rawset(t,k,v) end
            end,
        })
    end
    local tagged={}
    local services={CollectionService={GetTagged=function(_self,id) return tagged[id] or {} end}}
    local engineEnvironment={
        game={GetService=function(_self,id) return assert(services[id],id) end},
        CFrame={new=cf},Vector3={new=vec,zero=vec(0,0,0)},
        Color3={fromRGB=function(r,g,b) return {r,g,b} end},
        Instance={new=object},Enum={Material={Neon="Neon"}},
    }
    services.Debris={AddItem=function() end}
    local Effects=loadEffects(engineEnvironment)
    local World=loadWorld(engineEnvironment)
    local domain=Domain.new(data,function() return 1 end)
    local function fixture(ability)
        local p=domain:Default();p.PathwayId=ability.PathwayId;p.Sequence=ability.UnlockSequence
        local s=domain:NewState(p,0);domain:AutoEquip(s);domain:Equip(s,1,ability.Id)
        local player={UserId=1,DisplayName="Tester",Character=object("Model")}
        local root=object("Part");root.Position=vec(0,3.5,0);player.Character.Root=root
        local body=object("Part");body.Name="Torso";body.Color={1,1,1};player.Character.Children={body}
        local hum={DisplayName="Tester",Health=s.Stats.Health/2,MaxHealth=s.Stats.Health}
        function hum:FindFirstChild(_name) return nil end
        function hum:GetChildren() return {} end
        function hum:TakeDamage(amount) self.Health=math.max(0,self.Health-amount) end
        player.Character.Humanoid=hum
        local world={Random=function() return 0 end,Data=data,States={[player]=s},Entities={},Damaged=0,Revealed=0,Effects=0,Blocked=false,Unsafe=false,Transient=object("Folder")}
        world.FX={FireClient=function() world.Revealed+=1 end}
        function world:Root(_p) return root end
        function world:Humanoid(_p) return hum end
        function world:Entity(model)
            local e=self.Entities[model]
            return if e and e.Humanoid.Health>0 then e else nil
        end
        function world:Has(e,id,now) return e.Statuses[id] and e.Statuses[id].ExpiresAt>now end
        function world:LineOfSight() return not self.Blocked end
        function world:FiniteVector(v)
            return type(v)=="table" and Domain.Finite(v.X) and Domain.Finite(v.Y) and Domain.Finite(v.Z)
        end
        function world:SafeDestination(_p,v)
            return if self.Unsafe then nil else vec(v.X,3.5,v.Z)
        end
        function world:Buff(state,id,duration,now) state.Statuses[id]={ExpiresAt=now+duration} end
        function world:Status(e,id,duration,now,owner,power)
            check(data.StatusEffects[id]~=nil,"Executor uses defined status")
            e.Statuses[id]={ExpiresAt=now+duration,Owner=owner,Power=power or 0}
        end
        function world:Damage(e,amount,owner,now)
            if e.Owner then return false end
            e.Humanoid.Health=math.max(0,e.Humanoid.Health-amount);self.Damaged+=amount;return true
        end
        function world:Effect() self.Effects+=1 end
        function world:Targets(position,radius,maximum,_owner)
            local found={}
            for _,e in pairs(self.Entities) do
                if not e.Owner and e.Humanoid.Health>0 and (e.Root.Position-position).Magnitude<=radius then table.insert(found,e) end
            end
            while #found>maximum do table.remove(found) end
            return found
        end
        function world:Spawn(position,tier,owner,expiry)
            local model=object("Model");local r=object("Part");r.Position=position;model.Root=r;model:SetAttribute("AbilityId","ArcBolt");model:SetAttribute("Omen",3)
            local e={Model=model,Root=r,Tier=tier,Owner=owner,ExpiresAt=expiry,Humanoid={Health=10000},LastSpell=100,Threads=0,Statuses={},Serial=1}
            function e.Humanoid:TakeDamage(amount) self.Health=math.max(0,self.Health-amount) end
            self.Entities[model]=e;return e
        end
        local enemy=world:Spawn(vec(5,3.5,0),ability.UnlockSequence,nil,nil)
        local other=world:Spawn(vec(8,3.5,0),ability.UnlockSequence,nil,nil)
        local effect=Effects.new(world,domain,function() end)
        local door=object("Part");door.Position=vec(25,3.5,0);door.CanCollide=true
        local anchor=object("Part");anchor.Position=vec(25,1,0)
        tagged.MysticDoor={door};tagged.FlameAnchor={anchor}
        s.ArchiveRead=true;s.RecordedPower={Id="ArcBolt",Charges=3};s.Profile.WishCredits=3
        enemy.Statuses.Parasite={ExpiresAt=200,Owner=player}
        local kind=ability.Operation.Kind
        if kind=="Control" then enemy.Threads=2 end
        if kind=="Command" or kind=="Exchange" then enemy.Owner=player end
        if kind=="Exchange" then enemy.Root.Position=vec(25,3.5,0) end
        local position=if kind=="Travel" or kind=="Portal" or kind=="FlameJump" or kind=="OpenDoor" or kind=="Echo" then vec(25,3.5,0) else vec(5,3.5,0)
        local input={Position=position,Target=enemy.Model}
        return {State=s,Player=player,Root=root,Humanoid=hum,World=world,Effect=effect,Enemy=enemy,Other=other,Input=input,Door=door}
    end
    local kinds={}
    for id,a in pairs(data.Abilities) do
        local f=fixture(a)
        check(Effects.Handlers[a.Operation.Kind]~=nil,"Handler registered for "..id)
        local context,err=f.Effect:Validate(f.Player,f.State,a,f.Input)
        check(context~=nil,"Accept valid target for "..id..": "..tostring(err))
        local pending=domain:BeginCast(f.State,id,100)
        check(pending~=nil,"Unlocked equipped ability begins")
        local ok,message=f.Effect:Execute(context,101)
        check(ok,"Execute "..id..": "..tostring(message))
        check(f.World.Effects==1,"Successful cast emits cosmetic hook")
        check(f.State.Spirituality>=0,"Cast never makes spirituality negative")
        domain:CancelCast(f.State,false)
        kinds[a.Operation.Kind]=true
    end
    local n=0;for _ in pairs(kinds) do n+=1 end
    -- Run the real server evidence adapter through every executor as production does.
    for id,a in pairs(data.Abilities) do
        local f=fixture(a)
        local broadcasts={};local private={}
        f.World.FX.FireAllClients=function(_self,event) table.insert(broadcasts,event) end
        f.World.FX.FireClient=function(_self,owner,event) table.insert(private,{Owner=owner,Event=event}) end
        local protocol={MaxReveals=16,RevealLife=5}
        f.World.Visuals=VisualEvents.new(f.World,protocol,function() return 1000 end)
        local context=f.Effect:Validate(f.Player,f.State,a,f.Input)
        local pending=domain:BeginCast(f.State,id,100)
        check(context and pending,"Production evidence fixture accepts validated cast")
        local reserved=f.State.Spirituality
        f.World.Visuals:Begin(context,100)
        local ok=f.Effect:Execute(context,101)
        check(ok and broadcasts[1].Phase=="Begin" and broadcasts[#broadcasts].Phase=="Result","Every executor emits accepted Begin/Result evidence")
        check(f.World.Effects==0,"Production adapter replaces old ability pulse event without duplicate traffic")
        check(f.State.Pending==pending and f.State.Spirituality>=0,"Presentation leaves pending gameplay cast and valid resource state intact")
        check(broadcasts[#broadcasts].AbilityId==id and broadcasts[#broadcasts].Origin.X==0,"Evidence carries correct stable ability ID and pre-execution root")
        if a.Operation.Kind=="Travel" or a.Operation.Kind=="FlameJump" then
            check(broadcasts[#broadcasts].Destination.X==f.Root.Position.X and f.Root.Position.X~=0,"Travel evidence carries actual validated destination")
        elseif a.Operation.Kind=="OpenDoor" then
            check(broadcasts[#broadcasts].Target==f.Door and broadcasts[#broadcasts].ExpiresAt>1000,"Door evidence names actual server-selected door and expiry")
        elseif a.Operation.Kind=="Sense" or a.Operation.Kind=="SenseDoors" then
            check(#private>0 and private[1].Owner==f.Player and private[1].Event.Phase=="Reveal","Sensing targets only travel to authorized caster")
        end
        domain:CancelCast(f.State,false)
    end
    local f=fixture(data.Abilities.Marauder_9)
    local c=f.Effect:Validate(f.Player,f.State,data.Abilities.Marauder_9,f.Input)
    check(f.Effect:Execute(c,100),"First pickpocket succeeds")
    check(not f.Effect:Execute(c,140) and f.State.Profile.Gold==5,"Cannot repeatedly steal the same NPC loot")
    f.Enemy.Owner={UserId=2}
    check(not f.Effect:Validate(f.Player,f.State,data.Abilities.Marauder_9,f.Input),"No stealing from an owned marionette")
    f=fixture(data.Abilities.Apprentice_6_Secondary)
    f.State.RecordedPower=nil
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Apprentice_6_Secondary,f.Input)
    check(not f.Effect:Execute(c,100),"Cannot release unrecorded powers")
    f.State.RecordedPower={Id="ArcBolt",Charges=1}
    check(f.Effect:Execute(c,110),"One recorded charge releases")
    check(not f.Effect:Execute(c,120),"Recording charge limit enforced")
    f=fixture(data.Abilities.Apprentice_6)
    f.Enemy.Model:SetAttribute("AbilityId","ArbitraryCode")
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Apprentice_6,f.Input)
    check(not f.Effect:Execute(c,100),"Only allowlisted powers can be copied")
    f=fixture(data.Abilities.Seer_2)
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Seer_2,f.Input)
    f.State.Profile.WishCredits=0
    check(not f.Effect:Execute(c,100),"Miracles require accumulated credits")
    f=fixture(data.Abilities.Seer_7)
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Seer_7,f.Input)
    tagged.FlameAnchor={}
    check(not f.Effect:Execute(c,100),"Flame jump requires an anchor")
    f=fixture(data.Abilities.Apprentice_5)
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Apprentice_5,f.Input)
    f.World.Unsafe=true
    check(not f.Effect:Execute(c,100) and f.Root.Position.X==0,"Teleport rejects unsafe landings")
    f=fixture(data.Abilities.Marauder_4_Secondary)
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Marauder_4_Secondary,f.Input)
    f.Enemy.Statuses.Parasite.Owner={UserId=2}
    check(not f.Effect:Execute(c,100),"Cannot siphon someone else's host")
    f=fixture(data.Abilities.Marauder_9)
    f.World.Blocked=true
    check(not f.Effect:Validate(f.Player,f.State,data.Abilities.Marauder_9,f.Input),"Obstructed target rejected")
    f.World.Blocked=false;f.Enemy.Root.Position=vec(200,3.5,0)
    check(not f.Effect:Validate(f.Player,f.State,data.Abilities.Marauder_9,f.Input),"Distant target rejected")
    f=fixture(data.Abilities.Apprentice_5)
    f.Input.Position=vec(0/0,0,0)
    check(not f.Effect:Validate(f.Player,f.State,data.Abilities.Apprentice_5,f.Input),"NaN destination rejected")
    f=fixture(data.Abilities.Seer_5)
    f.Enemy.Threads=0;c=f.Effect:Validate(f.Player,f.State,data.Abilities.Seer_5,f.Input)
    check(f.Effect:Execute(c,100) and f.Enemy.Owner==nil,"First thread cast does not control")
    check(f.State.Profile.Digestion==0,"Incomplete control earns no acting reward")
    f.Effect:Execute(c,131);f.Effect:Execute(c,162)
    check(f.Enemy.Owner==f.Player and f.State.Profile.Digestion==5,"Completed control earns acting reward")
    f=fixture(data.Abilities.Apprentice_5_Secondary)
    c=f.Effect:Validate(f.Player,f.State,data.Abilities.Apprentice_5_Secondary,f.Input)
    f.Effect:Execute(c,100)
    check(f.Effect.Gates[f.Player]~=nil,"Spatial gate pair retained")
    f.Effect:RemoveGates(f.Player)
    check(f.Effect.Gates[f.Player]==nil,"Owned gates cleaned up")
    f=fixture(data.Abilities.Seer_9)
    f.Root.Position=vec(0/0,0,0)
    check(not f.Effect:Validate(f.Player,f.State,data.Abilities.Seer_9,f.Input),"Reject non-finite caster positions")
    local scene=fixture(data.Abilities.Seer_8)
    local actualWorld=World.new(data,domain,{[scene.Player]=scene.State},{FireAllClients=function() end})
    actualWorld.Entities[scene.Enemy.Model]=scene.Enemy
    local hp=scene.Humanoid.Health
    scene.State.Statuses.Invulnerable={ExpiresAt=200}
    actualWorld:DamagePlayer(scene.Player,20,scene.Enemy,100)
    check(scene.Humanoid.Health==hp and scene.State.Profile.Digestion==5,"Actual NPC damage adapter rewards a successful dodge")
    actualWorld:DamagePlayer(scene.Player,20,scene.Enemy,101)
    check(scene.State.Profile.Digestion==5,"Blocked strikes respect acting cooldown")
    scene.State.Statuses.Invulnerable=nil;scene.State.Statuses.Substitute={ExpiresAt=200}
    actualWorld:DamagePlayer(scene.Player,9999,scene.Enemy,102)
    check(scene.Humanoid.Health>0 and scene.State.Statuses.Substitute==nil,"Paper substitute consumes one lethal hit")
    scene.State.Statuses.Invulnerable=nil
    actualWorld:DamagePlayer(scene.Player,9999,scene.Enemy,103)
    check(scene.Humanoid.Health==0,"Consumed substitute cannot prevent a second lethal hit")
    scene=fixture(data.Abilities.Seer_1)
    actualWorld=World.new(data,domain,{[scene.Player]=scene.State},{FireAllClients=function() end})
    scene.Enemy.Statuses.Grafted={Owner=scene.Player,ExpiresAt=200}
    hp=scene.Humanoid.Health
    actualWorld:DamagePlayer(scene.Player,40,scene.Enemy,100)
    check(scene.Humanoid.Health==hp and scene.Enemy.Humanoid.Health==9960,"Grafting reflects actual hostile damage")
    check(scene.State.Profile.Digestion==5,"A completed reflected attack earns graft acting progress")
    scene=fixture(data.Abilities.Marauder_8)
    actualWorld=World.new(data,domain,{[scene.Player]=scene.State},{FireAllClients=function() end})
    scene.Enemy.Power=28
    actualWorld:Status(scene.Enemy,"Confused",10,100,scene.Player)
    check(scene.Enemy.Statuses.Confused.ExpiresAt-100<data.Abilities.Marauder_8.CooldownSeconds,"Low-tier deception cannot permanently stun an angel-tier NPC")
    print("PASS: "..checks.." executor/target assertions; all 54 abilities across "..n.." handlers (engine adapters mocked)")
end
