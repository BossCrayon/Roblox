--!strict
-- Real server evidence adapter, client dispatcher and composite pool owner run here.
-- Explicit value/Instance stand-ins do not emulate rendering, physics or networking.
return function(data: any,load: any,shared: any)
    local checks=0
    local function check(v,m) assert(v,m);checks+=1 end
    local VM={};local methods={}
    local function v(x,y,z) return setmetatable({X=x,Y=y,Z=z,_kind="Vector3"},VM) end
    VM.__add=function(a,b) return v(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
    VM.__sub=function(a,b) return v(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    VM.__unm=function(a) return v(-a.X,-a.Y,-a.Z) end
    VM.__mul=function(a,b) if type(a)=="number" then a,b=b,a end;return v(a.X*b,a.Y*b,a.Z*b) end
    VM.__div=function(a,b) return v(a.X/b,a.Y/b,a.Z/b) end
    VM.__index=function(a,k)
        if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
        if k=="Unit" then return a/a.Magnitude end
        return methods[k]
    end
    function methods:Dot(b) return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
    function methods:Cross(b) return v(self.Y*b.Z-self.Z*b.Y,self.Z*b.X-self.X*b.Z,self.X*b.Y-self.Y*b.X) end
    local CM={};local cm={}
    local function cf(x,y,z)
        return setmetatable({Position=if type(x)=="table" then x else v(x or 0,y or 0,z or 0),_kind="CFrame",
            RightVector=v(1,0,0),LookVector=v(0,0,-1)},CM)
    end
    CM.__index=function(a,k) if k=="Rotation" then return cf() end;return cm[k] end
    CM.__mul=function(a,b) return cf(a.Position+b.Position) end
    CM.__add=function(a,b) return cf(a.Position+b) end
    function cm:PointToObjectSpace(p) return p-self.Position end
    function cm:PointToWorldSpace(p) return p+self.Position end
    local frames={new=cf,identity=cf(),lookAt=function(p) return cf(p) end,fromMatrix=function(p) return cf(p) end,Angles=function() return cf() end}
    local function instance(class)
        local props={ClassName=class,_kind="Instance",Parent=true,Name=class,CFrame=cf(),Size=v(7,9,1),Transparency=0,LocalTransparencyModifier=0,Color={R=0.5,G=0.5,B=0.5}}
        local children={};local methods={};local object
        function methods:IsA(kind) return kind==class or (kind=="BasePart" and (class=="Part" or class=="WedgePart" or class=="SpawnLocation")) end
        function methods:SetAttribute(key,value) props["Attr_"..key]=value end
        function methods:GetAttribute(key) return props["Attr_"..key] end
        function methods:IsDescendantOf(parent)
            local item=object
            while type(item)=="table" do if item==parent then return true end;item=item.Parent end
            return false
        end
        function methods:Clear() end
        function methods:Emit(count) props.Emitted=count end
        function methods:Destroy() for _,child in ipairs(table.clone(children)) do child:Destroy() end;object.Parent=nil end
        function methods:GetDescendants()
            local result={};for _,child in ipairs(children) do table.insert(result,child);for _,item in ipairs(child:GetDescendants()) do table.insert(result,item) end end
            return result
        end
        function methods:FindFirstChild(name)
            for _,child in ipairs(children) do if child.Name==name then return child end end
            return if name=="HumanoidRootPart" then props.PrimaryPart else nil
        end
        function methods:FindFirstChildOfClass(kind)
            for _,child in ipairs(children) do if child:IsA(kind) then return child end end;return nil
        end
        object=setmetatable({_Children=children},{__index=function(_,key)
            if methods[key] then return methods[key] end
            if key=="Triggered" then return {Connect=function(_,fn) props.Trigger=fn end} end
            if key=="Position" then return props.CFrame.Position end
            if props[key]~=nil then return props[key] end
            for _,child in ipairs(children) do if child.Name==key then return child end end
        end,__newindex=function(_,key,value)
            if key=="Parent" then
                if type(props.Parent)=="table" and props.Parent._Children then
                    local index=table.find(props.Parent._Children,object);if index then table.remove(props.Parent._Children,index) end
                end
                if type(value)=="table" and value._Children then table.insert(value._Children,object) end
            end
            if key=="Position" then props.CFrame=cf(value) else props[key]=value end
        end})
        return object
    end
    local enums=setmetatable({},{__index=function(a,key)
        local namespace=setmetatable({},{__index=function(b,item) local out={Name=item,Value=1};rawset(b,item,out);return out end})
        rawset(a,key,namespace);return namespace
    end})
    local function sequence(...) return {...} end
    local quality=10;local now=100;local input={TouchEnabled=false}
    local camera={CFrame=cf(),Mode="Positive"}
    function camera:WorldToViewportPoint(p)
        return {Z=1},if self.Mode=="All" then true elseif self.Mode=="Positive" then p.X>=0 else p.X<0
    end
    local worldRoot=instance("Workspace");worldRoot.CurrentCamera=camera
    local env={UDim2={fromOffset=function(x,y) return {X=x,Y=y} end,fromScale=function(x,y) return {X=x,Y=y} end},Vector3={new=v,zero=v(0,0,0),one=v(1,1,1),xAxis=v(1,0,0),yAxis=v(0,1,0),zAxis=v(0,0,1)},CFrame=frames,
        Vector2={new=function(x,y) return {X=x,Y=y} end},Enum=enums,workspace=worldRoot,Instance={new=instance},
        Color3={fromRGB=function(r,g,b) return {R=r/255,G=g/255,B=b/255} end},
        NumberRange={new=sequence},NumberSequence={new=sequence},ColorSequence={new=sequence},NumberSequenceKeypoint={new=sequence},
        typeof=function(item) return if type(item)=="table" and item._kind then item._kind else typeof(item) end,
        UserSettings=function() return {GetService=function() return {SavedQualityLevel={Value=quality}} end} end,
        os={clock=function() return now end},game={GetService=function(_,name)
            if name=="ReplicatedStorage" then return {Shared=shared} end
            if name=="UserInputService" then return input end
            error(name)
        end}}
    load("Theme",env)
    local C=load("VfxConfig",env)
    local T=load("Theme",env)
    local Service=load("Client/Visuals/VfxService",env)
    local Blocks=load("Client/Visuals/EffectBlocks",env)
    load("Client/Visuals/Choreography",env)
    load("Client/Visuals/PathwayEffects/Seer",env);load("Client/Visuals/PathwayEffects/Marauder",env);load("Client/Visuals/PathwayEffects/Apprentice",env)
    load("Client/Visuals/Choreography",env)
    load("Client/Visuals/StatusPresentation",env)
    local Presenter=load("Client/Visuals/AbilityPresentation",env)
    local Status=load("Client/Visuals/StatusPresentation",env)
    local Anim=load("AnimConfig",env)
    local Events=load("Server/Services/VisualEventService",{})
    local service=Service.new();local blocks=Blocks.new(service)
    local layer=function(x) return {Name="DoorFrame",Position=v(x,0,0),Palette="Apprentice"} end
    local pair=blocks:Compose({layer(10),layer(-10)},1,3,0.75)
    check(pair~=nil and service:Stats().Active==1,"Two endpoint groups share one effect reservation")
    check(service:Stats().Reserved.Part==2 and service:Stats().Allocated.Part==1,"Invisible endpoint reserves atomically but instantiates no objects")
    local first=pair.Objects[1].Object
    camera.Mode="Negative";service:Step(0.1)
    check(pair.Active and service:Stats().Allocated.Part==2,"Second endpoint appears after viewpoint change while first becomes hidden")
    check(first.Parent==nil,"Off-screen first endpoint is parked independently")
    camera.Mode="All";service:Step(0.1)
    check(first.Parent~=nil and service:Stats().Active==1,"Previously visible endpoint reattaches without a second lease")
    camera.CFrame=cf(500,0,0);service:Step(0.1)
    check(not pair.Active and service:Stats().Active==0,"Entire composition releases when all endpoints exceed120studs")
    check(service:Stats().Reserved.Part==0 and service:Stats().Reserved.Beam==0,"Composite release returns every reserved class")
    camera.CFrame=cf();camera.Mode="All"
    check(blocks:Compose({layer(1)},1,3,0)==nil,"Zero lifetime rejected")
    check(blocks:Compose({layer(1)},1,3,0/0)==nil,"NaN lifetime rejected")
    check(blocks:Compose({layer(1),layer(2),layer(3),layer(4),layer(5),layer(6),layer(7)},1,3,1)==nil,"Composite layer count bounded")
    local invalid=layer(1);invalid.Position=v(0/0,0,0)
    check(blocks:Compose({invalid,layer(2)},1,3,1)==nil,"Invalid endpoint cannot bypass validation through another visible endpoint")
    local rune=blocks:Compose({{Name="SigilStencil",Position=v(1,0,0),Palette="Seer",Options={Glyph="Eye",LowGlyph="EyeLow"}}},1,3,0.85)
    check(rune and service:Stats().Errors==0,"New stencil builds using declared Beam and Attachment reservations")
    rune:Finish()
    local followed=instance("Part");followed.CFrame=cf(10,0,0)
    local tracking=blocks:Compose({{Name="SigilStencil",Position=v(10,0,0),Palette="Seer",Options={Follow=followed,Offset=v(0,1,0),Glyph="Eye"}}},1,2,1)
    followed.CFrame=cf(40,0,0);service:Step(0.1)
    check(tracking.Anchors[1].X==40 and tracking.Objects[1].Object.Position.X==40,"Windup glyph follows moving rig without moving the rig itself")
    followed.Parent=nil;service:Step(0.1)
    check(not tracking.Active and tracking.ResolveAnchors==nil,"Removing followed rig releases composition and resolver references")
    local moving=blocks:Compose({{Name="SigilStencil",Position=v(100,0,0),Palette="Marauder",Options={Glyph="Split",MoveTo=v(150,0,0)}}},1,3,1)
    service:Step(0.5)
    check(not moving.Active,"Moving symbol culls at actual position when it crosses120studs")
    local entering=blocks:Compose({{Name="SigilStencil",Position=v(150,0,0),Palette="Marauder",Options={Glyph="Split",MoveTo=v(100,0,0)}}},1,3,1)
    check(entering and #entering.Objects==0,"Moving symbol starts with no off-screen/far instances")
    service:Step(0.75)
    check(#entering.Objects>0 and entering.Objects[1].Object.Position.X<=120,"Symbol instantiates lazily only after entering visibility range")
    entering:Finish()
    -- Cinematic beats share one reservation and never allocate after cancellation.
    local staged=blocks:Compose({
        {Name="RisingMotes",Position=v(10,0,0),Palette="Seer",Options={Intake=true,Life=0.15}},
        {Name="DoorFrame",Position=v(10,0,0),Palette="Apprentice",Options={Delay=0.2}},
    },1,3,1)
    check(staged and service:Stats().Active==1,"Staged transformation consumes exactly one effect slot")
    local allocated=#staged.Objects
    service:Step(0.1)
    check(#staged.Objects==allocated,"Delayed release allocates no premature beams")
    service:Step(0.15)
    check(#staged.Objects>allocated,"Release lazily builds within reserved beam budget")
    check(staged.Objects[1].Object.Parent==nil,"Finished intake geometry parks before release")
    staged:Finish()
    local cancelled=blocks:Compose({{Name="DoorFrame",Position=v(10,0,0),Options={Delay=0.4}}},1,3,1)
    cancelled:Finish();service:Step(0.5)
    check(service:Stats().Active==0 and service:Stats().Reserved.Part==0,"Cancelling future beats drains reservations without deferred callbacks")
    local endpoint=v(20,1,-8)
    local dash=blocks:Compose({{Name="AfterimageTrail",Position=v(10,1,0),Options={EndPosition=endpoint}}},1,3,0.6)
    service:Step(C.Cinematic.TrailTravel)
    local trailHead=dash.Objects[2].Object
    check(math.abs(trailHead.Position.X-endpoint.X)<0.001 and math.abs(trailHead.Position.Z-endpoint.Z)<0.001,
        "Dash trail reaches the server endpoint instead of local +X")
    dash:Finish()
    -- Lowest quality must retain four-effect cap, including multi-layer casts.
    quality=1;service:Profile()
    for _=1,4 do check(blocks:Compose({layer(10)},1,3,0.75)~=nil,"Low-quality effect slot admits within cap") end
    local old=service:Stats()
    check(blocks:Compose({layer(10)},1,3,0.75)==nil,"Equal-priority fifth low-quality cast drops")
    check(service:Stats().Active==4 and service:Stats().Reserved.Beam==old.Reserved.Beam,"Rejected composition does not evict or partially allocate")
    service:Step(1);quality=10;service:Profile()
    local avatar=instance("Model");avatar.PrimaryPart=instance("Part")
    local player={UserId=1,Character=avatar};local players={[1]=player,[2]={UserId=2,Character=instance("Model")}}
    local poses={};local stops=0;local audio=0;local visualCast=nil
    local controller={Play=function(_,name,_weight,_fade,profile) table.insert(poses,{Name=name,Profile=profile}) end,
        Stop=function() stops+=1 end}
    local presenter=Presenter.new(service,blocks,data,{Clock=function() return now end,Camera=function() return camera end,
        LocalUserId=1,Player=function(id) return players[id] end,Controller=function() return controller end,
        Audio=function() audio+=1 end,Cast=function(event) visualCast=event end})
    local function packet(id,phase,token)
        return {Kind="AbilityVisual",Phase=phase,AbilityId=id,Owner=1,Token=token,Character=avatar,
            Position=v(12,0,0),Origin=v(10,0,0),Destination=v(20,0,0),At=now,EndsAt=now+data.Abilities[id].CastTimeSeconds,
            Tier=Service.PowerTier(data.Abilities[id].UnlockSequence),Outcome="Confirmed"}
    end
    local b=packet("Seer_9_Secondary","Begin",1)
    check(presenter:Event(b),"Accepted cast packet starts presentation")
    check(poses[#poses].Name=="CastWindup" and poses[#poses].Profile=="Reading","Spirit Vision selects Reading pose variant")
    check(visualCast and visualCast.Phase=="Begin","HUD windup receives synchronized accepted event")
    check(not presenter:Event(b),"Repeated Begin does not restart animation/effects")
    local cancel=packet(b.AbilityId,"Cancel",1)
    local beforeAudio=audio
    check(presenter:Event(cancel) and audio==beforeAudio,"Cancelled cast produces no successful release/audio")
    check(visualCast.Phase=="End" and visualCast.Token==1,"Cancel ends exact HUD cast token")
    check(not presenter:Event(packet(b.AbilityId,"Result",1)),"Result after cancellation cannot resurrect successful release")
    local accepted=packet("Marauder_6","Begin",2);presenter:Event(accepted)
    local capture=packet("Marauder_6","Result",2);capture.Outcome="Captured"
    check(presenter:Event(capture),"Capture result admitted")
    check(poses[#poses].Name=="CastRelease" and poses[#poses].Profile=="Theft","Ability Theft selects release pose")
    check(not presenter:Event(capture),"Duplicate success does not duplicate effects or sounds")
    check(not presenter:Event(packet("Seer_7","Result",1)),"Old token cannot replace newer cast")
    check(not presenter:Event(packet("Seer_7","Result",2)),"Different ability cannot reuse an existing cast token")
    local expired=packet("Seer_7","Begin",3);expired.At=now-C.Protocol.MaxAge-1
    check(not presenter:Event(expired),"Expired evidence ignored")
    local future=packet("Seer_7","Begin",3);future.At=now+C.Protocol.FutureTolerance+1
    check(not presenter:Event(future),"Implausibly future evidence ignored")
    local malformed=packet("Seer_7","Result",3);malformed.Origin=v(0/0,0,0)
    check(not presenter:Event(malformed),"Nonfinite confirmed endpoint rejected")
    local foreign=packet("Seer_7","Result",3);foreign.Character=instance("Model")
    check(not presenter:Event(foreign),"Old character results cannot affect respawned character")
    local private=packet("Seer_9_Secondary","Reveal",3);private.Targets={{Target=avatar,Position=v(10,0,0)}};private.ExpiresAt=now+5
    check(presenter:Event(private),"Private authorized reveal batch accepted")
    check(not presenter:Event(private),"Same reveal batch deduplicated")
    local wrong=packet("Seer_9_Secondary","Reveal",4);wrong.Owner=2;wrong.Character=players[2].Character;wrong.Targets=private.Targets;wrong.ExpiresAt=now+5
    check(not presenter:Event(wrong),"Other owner's private sensing batch rejected")
    presenter:Update({Ready=true,PathwayId="Seer",Sequence=9})
    local profileChanged=packet("Seer_7","Begin",4);presenter:Event(profileChanged)
    presenter:Update({Ready=true,PathwayId="Marauder",Sequence=6})
    check(not presenter:Event(packet("Seer_7","Result",4)),"Late completion cannot revive cosmetics after an admin pathway change")
    local cancelled=packet("Seer_7","Begin",5);presenter:Event(cancelled)
    now+=data.Abilities.Seer_7.CastTimeSeconds+C.Protocol.ResultGrace+0.1;presenter:Step()
    check(not presenter.Records[1].Active and presenter.Records[1].Completed,"Missing completion times out without a successful impact")
    presenter:Destroy();service:Step(2)
    -- Exercise ALL54 configured result routes, pilots included, at each quality/motion profile.
    local target=instance("Part");target.CFrame=cf(20,4.5,0)
    for _,level in ipairs({1,5,10}) do
        quality=level;service:SetSettings(false,level==1)
        for _,reduced in ipairs({false,true}) do
            service:SetSettings(reduced,level==1)
            for id,a in pairs(data.Abilities) do
                local p=Presenter.new(service,blocks,data,{Clock=function() return now end,Camera=function() return camera end})
                local e=packet(id,"Result",1);e.Target=target
                if id=="Marauder_9" then e.Outcome="Taken" elseif id=="Marauder_6" then e.Outcome="Captured" end
                local layers,duration=p:Layers(a,e)
                local handle=blocks:Compose(layers,e.Tier,3,duration)
                check(handle~=nil,"Every ability route constructs under isolated budget: "..id)
                service:Step(duration/2)
                check(service:Stats().Errors==0,"All routes obey actual pool reservation at every quality/motion profile")
                check(service:Stats().Active<=service:Profile().MaxEffects,"Route cannot exceed active effects cap")
                handle:Finish();p.Status:Clear()
            end
        end
    end
    -- Client visual code cannot move target/root or grant a resource.
    check(target.Position.X==20 and avatar.PrimaryPart.Position.X==0,"Choreography never moves target/player physics")
    local bulk=service:Begin("PoolTrimCheck",v(10,0,0),1,3,{Part=C.Pools.Mobile.Part+1})
    for _=1,C.Pools.Mobile.Part+1 do check(bulk:Acquire("Part")~=nil,"Desktop pool admits within desktop limit before device switch") end
    bulk:Finish();input.TouchEnabled=true
    check(service:Profile().Mobile and service:Profile().MaxEffects==C.Quality.MobileEffects,"Live emulator switch applies mobile active-effect cap")
    check(service:Stats().Allocated.Part<=C.Pools.Mobile.Part,"Live mobile switch trims idle desktop instances to mobile pool cap")
    local mobileBlocks=Blocks.new(service)
    local mobilePresenter=Presenter.new(service,mobileBlocks,data,{Clock=function() return now end,Camera=function() return camera end})
    for _,id in ipairs(C.Ability.Pilots) do
        local a=data.Abilities[id];local event=packet(id,"Result",1);event.Target=target
        local layers,duration=mobilePresenter:Layers(a,event)
        local handle=mobileBlocks:Compose(layers,event.Tier,3,duration)
        check(handle~=nil,"Each pilot has a usable mobile fallback")
        service:Step(duration/2)
        check(service:Stats().Errors==0 and service:Stats().Reserved.Beam<=C.Pools.Mobile.Beam,"Mobile fallback obeys actual pool declarations")
        handle:Finish()
    end
    service:Destroy()
    -- Server adapter is tested independently of client visual assumptions.
    local broadcasts={};local privatePackets={}
    local state={CastSerial=7,Pending={Token=7,EndsAt=201},Statuses={Vision={ExpiresAt=220}},Ready=true}
    local root={Position=v(1,3,0)}
    local serverWorld={States={[player]=state},FX={FireAllClients=function(_,e) table.insert(broadcasts,e) end,
        FireClient=function(_,owner,e) table.insert(privatePackets,{Owner=owner,Event=e}) end}}
    function serverWorld:FiniteVector(p) return type(p)=="table" and p._kind=="Vector3" and p.X==p.X and p.Y==p.Y and p.Z==p.Z end
    local events=Events.new(serverWorld,C.Protocol,function() return now end)
    local context={Player=player,State=state,Root=root,Ability=data.Abilities.Seer_9_Secondary,Position=v(20,3,0)}
    events:Begin(context,200)
    local begin=broadcasts[#broadcasts]
    check(begin.Phase=="Begin" and begin.EndsAt==now+1,"Cast end converted to synchronized server time")
    local original=events:Capture(context)
    root.Position=v(30,3,0)
    events:Result(context,original,true,nil,201)
    local result=broadcasts[#broadcasts]
    check(result.Origin.X==1 and result.Destination.X==30,"Departure survives teleport mutation; arrival reflects confirmed root")
    check(events.Active[player]==nil,"Completion removes active cast tracker")
    context.Ability=data.Abilities.Marauder_6;state.StolenPower=nil
    original=events:Capture(context);state.StolenPower="ArcBolt";events:Result(context,original,true,nil,201)
    check(broadcasts[#broadcasts].Outcome=="Captured" and broadcasts[#broadcasts].PowerId=="ArcBolt","Capture identity comes from actual server state")
    original=events:Capture(context);state.StolenPower=nil;events:Result(context,original,true,false,201)
    check(broadcasts[#broadcasts].Outcome=="Released","Release variant comes from pre-execution stored power")
    context.Ability=data.Abilities.Seer_9;original=events:Capture(context);events:Result(context,original,true,false,201)
    check(broadcasts[#broadcasts].Outcome=="Obscured","Obscured divination never claims successful reading")
    events:Reveal(context,{{Model=avatar,Root={Position=v(20,0,0)}}},201)
    check(#privatePackets==1 and privatePackets[1].Owner==player,"Perception uses FireClient only for authorized caster")
    check(privatePackets[1].Event.ExpiresAt==now+C.Protocol.RevealLife,"Reveal lifetime bounded by actual status/config")
    local entries={}
    for _=1,C.Protocol.MaxReveals+2 do table.insert(entries,{Model=avatar,Root={Position=v(20,0,0)}}) end
    events:Reveal(context,entries,201)
    check(#privatePackets[2].Event.Targets==C.Protocol.MaxReveals,"Reveal batch bounded")
    state.Pending={Token=8,EndsAt=202};state.CastSerial=8;events:Begin(context,201)
    local firstToken=broadcasts[#broadcasts].Token
    state.Pending=nil;events:Step()
    check(broadcasts[#broadcasts].Phase=="Cancel" and broadcasts[#broadcasts].Token==firstToken,"Interrupted pending cast emits cancellation")
    state.CastSerial=0;state.Pending={Token=1,EndsAt=202};events:Begin(context,201)
    check(broadcasts[#broadcasts].Token>firstToken,"Visual token remains monotonic across administrative domain reset")
    events:Remove(player)
    check(events.Active[player]==nil and events.Counters[player]==nil,"Leaving player releases server evidence trackers")
    check(state.Pending.Token==1 and state.CastSerial==0,"Evidence adapter never changes pending gameplay or cast serial")
    -- C–E: all routes have real registered recipes and matching procedural profiles.
    local registry={Seer=load("Client/Visuals/PathwayEffects/Seer",env),Marauder=load("Client/Visuals/PathwayEffects/Marauder",env),Apprentice=load("Client/Visuals/PathwayEffects/Apprentice",env)}
    local Choreo=load("Client/Visuals/Choreography",env)
    local requiredRoles={"Root","Waist","Neck","LeftShoulder","RightShoulder","LeftHip","RightHip"}
    for id,a in pairs(data.Abilities) do
        local event=packet(id,"Result",1);event.Target=target;event.Radius=4
        local ctx={Layer=function(name,pos,options) return {Name=name,Position=pos,Palette=a.PathwayId,Options=options or {}} end,
            Frame=function(pos) return cf(pos) end,Simplified=false}
        local extended=Choreo.Extend(a,event,ctx)
        local layers=registry[a.PathwayId].Build(a,event,extended)
        check(layers and #layers>0 and #layers<=C.Composition.MaxLayers,"Dedicated pathway recipe exists within layer cap: "..id)
        local profileName=Anim.AbilityProfiles[id]
        local profile=profileName and Anim.CastProfiles[profileName]
        check(profile~=nil,"Every ability selects a procedural pose profile")
        local timing=Anim.AbilityTimings[id]
        check(timing.Windup==a.CastTimeSeconds,"Pose windup preserves authoritative cast duration")
        check(type(timing.Origin)=="table" and type(timing.Stencil)=="string","Every ability timing defines gesture origin and stencil")
        check(extended.Gesture.Y==extended.Self.Y+timing.Origin[2],"Choreography gesture origin aligns with cast pose height")
        local windPose=profile.CastWindup.Pose;local relPose=profile.CastRelease.Pose
        local differs=false
        for _,role in ipairs(requiredRoles) do
            check(windPose[role]~=nil and relPose[role]~=nil,"7-joint coordination present for "..id.." role "..role)
            for idx=1,4 do
                if windPose[role][idx]~=relPose[role][idx] then differs=true end
            end
        end
        check(differs,"Windup and release poses are kinematically distinct for "..id)
        if not string.find(id,"_Secondary",1,true) then
            local secTiming=Anim.AbilityTimings[id.."_Secondary"]
            check(secTiming and secTiming.Family~=timing.Family,"Primary and secondary abilities on sequence have distinct gesture families: "..id)
        end
    end
    local serverState=state
    serverState.Profile={PathwayId="Seer"};serverState.Ready=true;serverState.Dead=false;serverState.Statuses={}
    local npc=instance("Model");npc.PrimaryPart=instance("Part");npc.PrimaryPart.CFrame=cf(20,0,0);npc.PrimaryPart.Parent=npc
    local npcHum=instance("Humanoid");npcHum.Health=100;npcHum.Parent=npc
    local enemy={Model=npc,Root=npc.PrimaryPart,Humanoid=npcHum,Threads=1,Statuses={Threaded={Owner=player,ExpiresAt=520}}}
    serverWorld.Entities={[npc]=enemy};serverWorld.Data=data
    serverWorld.Root=function() return root end
    broadcasts={};privatePackets={}
    local watched=Events.new(serverWorld,C.Protocol,function() return now end,C.Status)
    watched:Statuses(500)
    check(#privatePackets==1 and #broadcasts==0,"Thread stages are private to the authorizing caster")
    check(privatePackets[1].Event.Count==1 and privatePackets[1].Event.Required==3,"Thread count and requirement come from actual server state/data")
    watched:Statuses(500.25)
    check(#privatePackets==1,"Unchanged status produces no per-frame network stream")
    enemy.Threads=2;enemy.Statuses.Threaded.ExpiresAt=530;watched:Statuses(501)
    check(privatePackets[#privatePackets].Event.Count==2,"Confirmed second thread stage updates")
    enemy.Statuses={Controlled={Owner=player,ExpiresAt=535}};enemy.Owner=player;watched:Statuses(502)
    check(#broadcasts==1 and broadcasts[1].StatusId=="Controlled","Only actual control completion produces a public ownership mark")
    check(privatePackets[#privatePackets].Event.Action=="Remove","Replaced thread status is explicitly removed")
    local controlled=enemy.Statuses.Controlled
    watched:Statuses(536)
    check(broadcasts[#broadcasts].Action=="Remove" and enemy.Statuses.Controlled==controlled,"Expiry evidence does not mutate gameplay status tables")
    enemy.Statuses={Payload={Owner=player,ExpiresAt=550}};watched:Statuses(537)
    check(privatePackets[#privatePackets].Event.StatusId=="Payload" and privatePackets[#privatePackets].Event.Private,"Hidden payload remains caster-only before triggering")
    watched:Sync(players[2]);local synced=#privatePackets
    check(synced>0 and (privatePackets[synced].Owner~=players[2] or privatePackets[synced].Event.StatusId~="Payload"),"Late observer sync cannot disclose private payload")
    -- A late joiner may receive a new live status before older active statuses sync.
    enemy.Statuses.Controlled={Owner=player,ExpiresAt=550};watched:Statuses(538)
    local observerStatus=Status.new(nil,function() return now end)
    local newer=table.clone(broadcasts[#broadcasts]);newer.Target=instance("Model")
    watched.Revision+=1;newer.Revision=watched.Revision
    check(observerStatus:Event(newer,2),"Late observer can receive a newer live status before sync")
    watched.LastSync[players[2]]=nil;watched:Sync(players[2])
    local activeSnapshot=privatePackets[#privatePackets].Event
    check(activeSnapshot.StatusId=="Controlled" and activeSnapshot.Revision>newer.Revision,
        "Current status sync receives a fresh revision beyond intervening live receipts")
    check(observerStatus:Event(activeSnapshot,2),"Late observer retains earlier active statuses after a newer live receipt")
    watched:Trigger(player,"PayloadTriggered","Marauder_2_Secondary",v(20,0,0),npc)
    check(broadcasts[#broadcasts].Kind=="VisualTrigger" and broadcasts[#broadcasts].Trigger=="PayloadTriggered","Confirmed trigger has a distinct cue ID")
    -- Actual client status renderer, GUI pooling, gate fallback and appearance restoration.
    quality=10;input.TouchEnabled=false;camera.CFrame=cf();camera.Mode="All"
    local effects=Service.new();local library=Blocks.new(effects);local status=Status.new(effects,function() return now end,library)
    local source={Kind="StatusVisual",Action="Set",Owner=1,Target=npc,StatusId="Threaded",Position=v(20,0,0),
        PathwayId="Seer",Count=2,Required=3,Revision=1,ExpiresAt=now+20,At=now}
    check(status:Event(source,1),"Client admits private thread receipt for its owner")
    status:Step()
    check(status.Records[npc].Widget and status.Records[npc].Widget.Status.Text=="Threads 2/3","Pooled badge displays confirmed thread progress")
    local oldWidget=status.Records[npc].Widget
    local removed=table.clone(source);removed.Action="Remove";removed.Revision=2
    status:Event(removed,1);status:Step()
    check(not oldWidget.Enabled and status.Records[npc]==nil,"Removal parks and detaches status GUI")
    check(not status:Event(source,1),"Stale status cannot resurrect a removed badge")
    local privateCopy=table.clone(source);privateCopy.Owner=2;privateCopy.Revision=3
    check(not status:Event(privateCopy,1),"Client also enforces hidden status ownership")
    local public=table.clone(source);public.StatusId="Controlled";public.Revision=4
    status:Event(public,1);status:Step()
    check(status.Records[npc].Widget==oldWidget and status.Widgets==1,"Badges reuse pooled GUI after status replacement")
    for index=1,T.StatusUI.Max+2 do
        local model=instance("Model");model.PrimaryPart=instance("Part");model.PrimaryPart.CFrame=cf(20+index,0,0)
        local event=table.clone(public);event.Target=model;event.Revision=4+index
        status:Event(event,1)
    end
    status:Step();check(status.Widgets<=T.StatusUI.Max,"Status GUI allocation respects global widget cap")
    input.TouchEnabled=true;status:Step()
    local visible=0;for _,entry in pairs(status.Records) do if entry.Widget and entry.Widget.Enabled then visible+=1 end end
    check(visible<=T.StatusUI.MobileMax,"Touch mode reduces visible status labels")
    input.TouchEnabled=false
    local left=instance("Part");left.CFrame=cf(10,4,0);local right=instance("Part");right.CFrame=cf(30,4,0)
    local originalColor=left.Color
    status:Gate({Gates={left,right},Owner=1,AbilityId="Apprentice_1",ExpiresAt=now+25})
    status:Step()
    check(status.Gates[1].Handle and left.LocalTransparencyModifier==1,"Real proxy pane hides only after frame admission")
    local gateHandle=status.Gates[1].Handle
    effects:SetSettings(true,true)
    check(not gateHandle.Active and left.LocalTransparencyModifier==0,"Quality change restores pane while old frame releases")
    now+=C.Status.Retry;status:Step()
    check(status.Gates[1].Handle.Active,"Persistent gate renews under new quality without a gameplay gate")
    status:RemoveGates(1)
    check(left.LocalTransparencyModifier==0 and left.Color==originalColor and status.Gates[1]==nil,"Gate removal restores original local appearance")
    local blockers={}
    for _=1,effects:Profile().MaxEffects do
        table.insert(blockers,library:Compose({{Name="RingBurst",Position=v(10,0,0),Palette="Seer"}},1,5,1))
    end
    status:Gate({Gates={left,right},Owner=1,AbilityId="Apprentice_5_Secondary",ExpiresAt=now+25});status:Step()
    check(not status.Gates[1].Handle and left.LocalTransparencyModifier==0,"Budget denial keeps real gate fallback visible")
    for _,handle in ipairs(blockers) do if handle then handle:Finish() end end
    status:RemoveGates(1)

    local body=instance("Part");body.Parent=npc;body.Color={R=1,G=0,B=0};body.LocalTransparencyModifier=0
    local bodyColor=body.Color
    status:Echo({Echo=npc,Owner=1,ExpiresAt=now+10})
    check(body.Color==C.Status.EchoColor and body.LocalTransparencyModifier==C.Status.EchoAlpha,"Historical dressing alters presentation only")
    status:ClearLocal(1)
    check(body.Color==bodyColor and body.LocalTransparencyModifier==0,"Administrative cleanup restores echo appearance")
    local snapshots={};local observer=players[2]
    local realGates={instance("Part"),instance("Part")};realGates[1].CFrame=cf(10,0,0);realGates[2].CFrame=cf(30,0,0)
    local cache=Events.new(serverWorld,C.Protocol,function() return now end,C.Status)
    serverWorld.FX.FireClient=function(_self,recipient,event) table.insert(snapshots,{Player=recipient,Event=event}) end
    local gateContext={Player=player,State=state,Root=root,Position=v(30,0,0),Ability=data.Abilities.Apprentice_5_Secondary,VisualGates=realGates,VisualExpires=600}
    cache:Result(gateContext,cache:Capture(gateContext),true,nil,550)
    cache:Sync(observer)
    check(#snapshots==1 and snapshots[1].Event.Kind=="GateSnapshot","Late join receives active gate appearance without recasting")
    cache:Sync(observer);check(#snapshots==1,"Status/gate resync is separately throttled")
    now+=C.Protocol.SyncInterval;cache:RemoveGates(player);cache:Sync(observer)
    check(#snapshots==1,"Removed gates are not resurrected by synchronization")
    local echoContext={Player=player,State=state,Root=root,Position=v(20,0,0),Ability=data.Abilities.Seer_3,VisualEcho=npc,VisualExpires=575}
    cache:Result(echoContext,cache:Capture(echoContext),true,nil,550)
    now+=C.Protocol.SyncInterval;cache:Sync(observer)
    check(snapshots[#snapshots].Event.Kind=="EchoSnapshot","Late join receives historical summon appearance")
    cache:Remove(player)
    check(next(cache.Gates)==nil and next(cache.Echoes)==nil,"Departing owner clears persistent cosmetic caches")
    status:Clear();effects:Destroy()
    print("PASS: "..checks.." ability composition/54-route/status/privacy/lifecycle assertions (engine stand-ins; no rendering)")
    return {Env=env,Instance=instance,Vector=v,Frame=cf,Camera=camera,Input=input,
        SetTime=function(value) now=value end,SetQuality=function(value) quality=value end}
end
