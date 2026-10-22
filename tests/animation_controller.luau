--!strict
-- Actual controller lifecycle with explicit frame/Animator stand-ins. This does
-- not render a rig or certify uploaded-asset permissions in the Roblox engine.
return function(load: any,sharedNode: any)
    local checks=0
    local function check(value: any,message: string) assert(value,message);checks+=1 end
    local function near(a: number,b: number): boolean return math.abs(a-b)<0.00001 end
    local function signal(): any
        local self={Listeners={}}
        function self:Connect(fn: any)
            local listener={Connected=true,Callback=fn};table.insert(self.Listeners,listener)
            return {Disconnect=function() listener.Connected=false end}
        end
        function self:Fire(...: any)
            for _,listener in ipairs(table.clone(self.Listeners)) do if listener.Connected then listener.Callback(...) end end
        end
        function self:Count(): number
            local count=0;for _,listener in ipairs(self.Listeners) do if listener.Connected then count+=1 end end
            return count
        end
        return self
    end
    local namespaces={}
    local enums=setmetatable({},{__index=function(_,namespace)
        namespaces[namespace]=namespaces[namespace] or setmetatable({},{__index=function(values,key)
            local value={Name=key};rawset(values,key,value);return value
        end})
        return namespaces[namespace]
    end})
    local vectors={}
    function vectors.new(x: number,y: number,z: number): any
        return {X=x,Y=y,Z=z,Magnitude=math.sqrt(x*x+y*y+z*z)}
    end
    local frames: any={};local frameMeta: any={}
    function frames.new(x: number?,y: number?,z: number?): any
        return setmetatable({X=x or 0,Y=y or 0,Z=z or 0,P=0,A=0,R=0},frameMeta)
    end
    function frames.Angles(p: number,a: number,r: number): any
        local value=frames.new();value.P=p;value.A=a;value.R=r;return value
    end
    frameMeta.__index={Lerp=function(a: any,b: any,t: number): any
        local value=frames.new()
        for _,key in ipairs({"X","Y","Z","P","A","R"}) do value[key]=a[key]+(b[key]-a[key])*t end
        return value
    end}
    frameMeta.__mul=function(a: any,b: any): any
        local value=frames.new()
        for _,key in ipairs({"X","Y","Z","P","A","R"}) do value[key]=a[key]+b[key] end
        return value
    end
    frameMeta.__eq=function(a: any,b: any): boolean
        for _,key in ipairs({"X","Y","Z","P","A","R"}) do if a[key]~=b[key] then return false end end
        return true
    end
    frames.identity=frames.new()
    local config=load("AnimConfig",{Enum=enums,CFrame=frames})
    local mutable=table.clone(config);mutable.Entries={}
    for name,entry in pairs(config.Entries) do mutable.Entries[name]=table.clone(entry) end
    local run={PreAnimation=signal(),PreSimulation=signal()}
    local gameStub={GetService=function(_self: any,name: string): any
        return if name=="RunService" then run else {Shared=sharedNode}
    end}
    local spring=load("Client/Visuals/MotionSpring",{game=gameStub})
    local animations={}
    local instance={new=function(class: string): any
        local object={ClassName=class,Destroyed=false}
        function object:Destroy() self.Destroyed=true end
        table.insert(animations,object);return object
    end}
    local Controller=load("Client/Visuals/AnimationController",{game=gameStub,Enum=enums,CFrame=frames,Vector3=vectors,Instance=instance,
        require=function(module: any): any return if module==sharedNode.AnimConfig then mutable else spring end})
    local function character(names: {string}?,assetMode: string?): any
        local self={DescendantAdded=signal(),DescendantRemoving=signal(),Descendants={},Parent={},PrimaryPart=nil}
        local root={Parent=self,Name="HumanoidRootPart",CFrame=frames.new(10,0,0),AssemblyLinearVelocity=vectors.new(0,0,0)}
        function root:IsA(class: string): boolean return class=="BasePart" end
        self.PrimaryPart=root;self.Root=root
        local animator={Tracks={},Mode=assetMode}
        function animator:LoadAnimation(_animation: any): any
            if self.Mode=="error" then error("Intentional asset permission failure") end
            local track={Length=if self.Mode=="ready" then 1 else 0,IsPlaying=false,Destroyed=false,Speed=1,PlayCount=0}
            function track:Play(_fade: number,weight: number,speed: number) self.IsPlaying=true;self.Weight=weight;self.Speed=speed;self.PlayCount+=1 end
            function track:Stop(_fade: number?) self.IsPlaying=false end
            function track:Destroy() self.Destroyed=true end
            function track:AdjustWeight(weight: number,_fade: number) self.Weight=weight end
            function track:AdjustSpeed(speed: number) self.Speed=speed end
            table.insert(self.Tracks,track);return track
        end
        local humanoid={Health=100,FloorMaterial=enums.Material.Ground,Died=signal(),StateChanged=signal()}
        function humanoid:FindFirstChildOfClass(class: string): any return if class=="Animator" then animator else nil end
        self.Humanoid=humanoid;self.Animator=animator
        function self:FindFirstChildOfClass(class: string): any return if class=="Humanoid" then humanoid else nil end
        function self:FindFirstChild(name: string): any return if name=="HumanoidRootPart" then root else nil end
        function self:GetDescendants(): any return self.Descendants end
        for _,name in ipairs(names or {}) do
            local motor={Name=name,Transform=frames.new(),Parent=self}
            function motor:IsA(class: string): boolean return class=="Motor6D" end
            table.insert(self.Descendants,motor)
        end
        return self
    end
    local function advance(controller: any,seconds: number)
        for _=1,math.ceil(seconds*60) do controller:Step(1/60) end
    end
    local rig=character({"RootJoint","Neck","Right Shoulder"})
    local controller=Controller.new(rig,{AutoStep=false,AutoLocomotion=false})
    check(not controller:Play("unknown") and next(controller.States)==nil,"Unknown animations do not allocate state")
    check(controller:Play("cast-windup"),"Configured aliases resolve without new profile definitions")
    advance(controller,0.2)
    local rootMotor=rig.Descendants[1]
    local first=rootMotor.Transform
    check(first~=frames.identity,"A procedural cast visibly offsets a supported rendered joint")
    controller:Restore()
    check(rootMotor.Transform==frames.identity,"Restore removes the controller's previous offset exactly")
    controller:Step(1/60)
    local external=frames.new(3,4,5);rootMotor.Transform=external
    controller:Restore()
    check(rootMotor.Transform==external,"A new Animator/external joint write is preserved instead of restoring stale state")
    controller:Step(1/60);controller:Restore()
    check(rootMotor.Transform==external,"Next overlay composes onto the authored Animator pose without accumulating")
    local elapsed=controller.States.CastWindup.Elapsed
    check(controller:Blend("CastWindup",0.4,0.2),"Active entries accept blend requests")
    check(controller.States.CastWindup.Elapsed==elapsed and controller.States.CastWindup.Target==0.4,"Blending changes weight without retriggering animation time")
    check(not controller:Blend("CastWindup",0/0),"Non-finite blend targets are rejected")
    controller:Play("HitReact");advance(controller,0.1)
    check(rootMotor.Transform.P<math.rad(config.Entries.CastWindup.Pose.Root[2]),"Higher-priority hit reaction can override a lower-priority cast")
    advance(controller,1)
    check(controller.States.HitReact==nil and controller.States.CastWindup~=nil,"One-shot reaction fades and releases while looped cast persists")
    controller:Pause(100)
    check(controller.PauseLeft==config.Safety.MaxPause,"Cosmetic hold cannot exceed the configured safety duration")
    local held=controller.States.CastWindup.Elapsed
    controller:Step(1/60)
    check(controller.States.CastWindup.Elapsed==held,"Cosmetic hold pauses only the controller's presentation clock")
    check(rig.Root.CFrame==frames.new(10,0,0) and rig.Humanoid.Health==100,"Animation, blending and hit-stop cannot move root physics or change health")
    controller:SetReducedMotion(true)
    check(controller.PauseLeft==0,"Reduced-motion setting immediately clears a cosmetic hold")
    controller:Blend("CastWindup",1,0.02);advance(controller,0.5);controller:Restore()
    controller:Step(1/60);local reducedAngle=math.abs(rootMotor.Transform.P)
    controller:Restore();controller:SetReducedMotion(false);controller:Step(1/60)
    check(reducedAngle<math.abs(rootMotor.Transform.P),"Reduced motion lowers procedural posture amplitude")
    controller:Stop();advance(controller,1)
    check(next(controller.States)==nil,"Stopping all profiles eventually releases every active entry")
    controller:Play("CastWindup");advance(controller,0.2)
    rig.DescendantRemoving:Fire(rootMotor)
    check(rootMotor.Transform==external and #controller.Motors==2,"Removing a Motor6D restores its owned offset and drops the reference")
    controller:Destroy();controller:Destroy()
    check(next(controller.States)==nil and #controller.Connections==0 and rig.DescendantAdded:Count()==0,"Repeated teardown releases states and every rig connection once")
    check(not controller:Play("Idle"),"Destroyed animation controllers cannot restart")

    local automatic=character({"Root","Waist","Neck","RightShoulder"})
    local auto=Controller.new(automatic)
    check(run.PreAnimation:Count()==1 and run.PreSimulation:Count()==1,"Automatic controllers bind the two documented Animator frame phases")
    auto:Play("CastWindup")
    for _=1,30 do
        run.PreAnimation:Fire()
        automatic.Descendants[1].Transform=frames.new(2,0,0)
        run.PreSimulation:Fire(1/60)
        check(near(automatic.Descendants[1].Transform.X,2),"Each frame composes once onto the default Animate pose without drift")
    end
    automatic.Root.AssemblyLinearVelocity=vectors.new(20,0,0);run.PreAnimation:Fire();run.PreSimulation:Fire(1/60)
    check(auto.AutoState=="Run" and auto.States.Run~=nil,"Locomotion observes speed without modifying the Humanoid")
    automatic.Humanoid.StateChanged:Fire(enums.HumanoidStateType.Running,enums.HumanoidStateType.Jumping)
    check(auto.States.Jump~=nil,"Jump state observation queues only a cosmetic jump profile")
    auto:Destroy()
    check(run.PreAnimation:Count()==0 and run.PreSimulation:Count()==0,"Destroy disconnects both automatic frame hooks")
    local simple=character({})
    local noJoints=Controller.new(simple,{AutoStep=false,AutoLocomotion=false})
    noJoints:Play("Death");noJoints:Step(1/60);noJoints:Destroy()
    check(simple.Root.CFrame==frames.new(10,0,0),"Root-only NPC rigs use a harmless no-joint fallback")
    local delayed=character({"Root"})
    delayed.PrimaryPart=nil
    function delayed:FindFirstChild(_name: string): any return nil end
    function delayed.Humanoid:FindFirstChildOfClass(_class: string): any return nil end
    local delayedController=Controller.new(delayed,{AutoStep=false,AutoLocomotion=false})
    check(delayedController.Root==nil and delayedController.Animator==nil,"Partially replicated characters can begin without a root or Animator")
    delayed.DescendantAdded:Fire(delayed.Root)
    delayed.Animator.Parent=delayed.Humanoid
    function delayed.Animator:IsA(class: string): boolean return class=="Animator" end
    delayed.DescendantAdded:Fire(delayed.Animator)
    check(delayedController.Root==delayed.Root and delayedController.Animator==delayed.Animator,"Late root and Animator replication are discovered without replacing the controller")
    delayed.DescendantRemoving:Fire(delayed.Root);delayed.DescendantRemoving:Fire(delayed.Animator)
    check(delayedController.Root==nil and delayedController.Animator==nil,"Removed root and Animator references are released promptly")
    delayedController:Destroy()

    mutable.Entries.CastWindup.AnimationId="123" -- Test-only fake identifier; production asset slots remain blank.
    local ready=character({"RootJoint"},"ready")
    local hybrid=Controller.new(ready,{AutoStep=false,AutoLocomotion=false});hybrid:Play("CastWindup");hybrid:Step(1/60)
    local track=ready.Animator.Tracks[1]
    check(track and track.IsPlaying and track.Priority==config.Entries.CastWindup.AssetPriority,"A supplied asset uses the entry's configured Roblox priority")
    check(ready.Descendants[1].Transform==frames.identity,"An active loaded asset overrides the corresponding procedural pose")
    hybrid:Pause(0.04);check(track.Speed==0,"Cosmetic hold adjusts only this controller's uploaded track")
    advance(hybrid,0.1);check(track.Speed==1,"Owned uploaded tracks resume after the bounded hold")
    hybrid:Destroy();check(track.Destroyed,"Destroy cleans up every uploaded track it created")
    local unloaded=character({"RootJoint"},"waiting")
    local fallback=Controller.new(unloaded,{AutoStep=false,AutoLocomotion=false});fallback:Play("CastWindup");advance(fallback,0.2)
    check(unloaded.Descendants[1].Transform~=frames.identity,"Unloaded assets retain an immediate procedural fallback")
    advance(fallback,config.Safety.AssetLoadGrace)
    check(unloaded.Animator.Tracks[1].Destroyed and fallback.States.CastWindup.AssetFailed,"Assets that never load are stopped and reclaimed after the configured timeout")
    fallback:Destroy()
    local denied=character({"RootJoint"},"error")
    local deniedController=Controller.new(denied,{AutoStep=false,AutoLocomotion=false})
    check(deniedController:Play("CastWindup"),"LoadAnimation errors cannot abort a valid procedural profile")
    advance(deniedController,0.2)
    check(denied.Descendants[1].Transform~=frames.identity and deniedController.States.CastWindup.AssetFailed,"Permission/load failures fall back to the original procedural cast")
    deniedController:Destroy()
    for _,animation in ipairs(animations) do check(animation.Destroyed,"Hybrid teardown releases its temporary Animation objects") end
    print("PASS: "..checks.." animation controller blending/ownership/asset lifecycle assertions (engine stand-ins)")
end
