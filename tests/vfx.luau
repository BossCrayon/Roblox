--!strict
-- Client presentation resource/lifecycle checks. Roblox engine behavior uses explicit stand-ins.
return function(load: any,sharedNode: any)
    local checks=0
    local function check(value: any,message: string)
        assert(value,message);checks+=1
    end
    local function same(array: any,expected: {string}): boolean
        if not array or #array~=#expected then return false end
        for i,value in ipairs(expected) do if array[i]~=value then return false end end
        return true
    end
    local Budget=load("VisualBudget",{})
    local budget=Budget.new({Part=5,Beam=2},3)
    check(budget:Add("ambient",{Part=3,Beam=1},1),"Ambient fits declared resource limits")
    check(budget:Add("impact",{Part=2,Beam=1},3),"High-priority impact fits remaining resources")
    local victims=budget:Plan({Part=2,Beam=1},2)
    check(same(victims,{"ambient"}),"Mid-priority request evicts ambient before impact")
    check(budget:Stats().Count==2 and budget:Stats().Used.Part==5,"Planning does not mutate active reservations")
    check(budget:Plan({Part=2},1)==nil,"Equal-priority effects cannot evict each other")
    check(budget:Plan({Part=6},10)==nil,"Impossible requests cannot evict unrelated active effects")
    check(budget:Stats().Count==2,"Denied impossible request preserves prior reservations")
    check(not budget:Add("overflow",{Part=1},9),"Add cannot silently exceed a pool cap")
    budget:Remove("ambient");budget:Remove("ambient")
    check(budget:Stats().Used.Part==2 and budget:Stats().Used.Beam==1,"Release is idempotent and decrements each resource once")
    check(budget:Add("replacement",{Part=3,Beam=1},2),"Freed capacity is reusable")
    local stats=budget:Stats();stats.Used.Part=999;stats.Limits.Part=999
    check(budget:Stats().Used.Part==5 and budget:Stats().Limits.Part==5,"Statistics copies cannot corrupt budget bookkeeping")

    local ordered=Budget.new({Part=4},3)
    ordered:Add("old-medium",{Part=1},2)
    ordered:Add("new-low",{Part=1},1)
    ordered:Add("new-medium",{Part=1},2)
    check(same(ordered:Plan({Part=3},3),{"new-low","old-medium"}),"Eviction sorts priority before insertion age")
    check(same(ordered:Plan({},3),{"new-low"}),"Effect count is capped even for a request with no instances")
    check(ordered:Plan({Part=4},2)==nil,"Lower-priority eviction cannot displace equal-priority reservations")
    for _,costs in ipairs({{Part=-1},{Part=0/0},{Part=math.huge},{Part=0.5},{Unknown=1}}) do
        check(ordered:Plan(costs,99)==nil,"Malformed or unknown resource requests are rejected")
    end
    local stress=Budget.new({Part=24,Beam=8},6)
    for i=1,100 do
        local costs={Part=(i*7)%9,Beam=(i*3)%4}
        local priority=i%4
        local plan=stress:Plan(costs,priority)
        if plan then
            for _,id in ipairs(plan) do stress:Remove(id) end
            check(stress:Add(tostring(i),costs,priority),"An accepted plan leaves capacity for its reservation")
        end
        if i%5==0 then stress:Remove(tostring(i-1)) end
        local current=stress:Stats()
        check(current.Count<=6 and current.Used.Part<=24 and current.Used.Beam<=8,"Repeated admission and release preserve every hard cap")
        check(current.Used.Part>=0 and current.Used.Beam>=0,"Repeated release never makes a counter negative")
    end
    local enum=setmetatable({},{__index=function(_,name)
        return setmetatable({},{__index=function(_,value) return {Name=name.."."..value,Value=100} end})
    end})
    local animation=load("AnimConfig",{Enum=enum})
    local spring=load("Client/Visuals/MotionSpring",{game={GetService=function() return {Shared=sharedNode} end}})
    local approach=spring.new(0)
    local previous=0
    for _=1,120 do
        local value=approach:Step(1/60,1)
        check(value>=previous and value<=1,"Critically damped blend approaches its target without overshoot")
        previous=value
    end
    check(math.abs(approach.Value-1)<0.00001,"Spring reaches the target within a visual frame budget")
    local before=approach.Value
    check(approach:Step(0,0)==before and approach:Step(-1,0)==before,"Zero or backwards frame deltas do not advance presentation")
    approach:Reset(-2)
    check(approach.Value==-2 and approach.Velocity==0,"Reset clears both the displacement and velocity")
    local capped=spring.new(0);local normal=spring.new(0)
    check(capped:Step(100,1)==normal:Step(animation.Spring.MaxStep,1),"Tab-out frames clamp spring integration to configured maximum step")
    check(spring.new(0,0):Step(1/60,4)==4,"Zero-frequency blend snaps without division by zero")
    check(spring.Smoothstep(-1)==0 and spring.Smoothstep(0.5)==0.5 and spring.Smoothstep(2)==1,"Easing clamps to safe interpolation endpoints")
    local entries=0
    for _,entry in pairs(animation.Entries) do
        entries+=1
        check(entry.AnimationId=="" and type(entry.Procedural)=="function","Every animation has an empty optional asset slot and procedural fallback")
    end
    check(entries==12,"All twelve required procedural animation states are configured")
    -- Lightweight engine values are sufficient to exercise the actual camera's
    -- ownership, caps and teardown. They do not assert rendered shake appearance.
    local vectorMeta={}
    local function vector(x: number,y: number,z: number): any
        return setmetatable({X=x,Y=y,Z=z,_kind="Vector3"},vectorMeta)
    end
    vectorMeta.__index=function(v: any,key: string): any
        if key=="Magnitude" then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z) end
        if key=="Unit" then local m=v.Magnitude;return vector(v.X/m,v.Y/m,v.Z/m) end
    end
    vectorMeta.__add=function(a: any,b: any) return vector(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
    vectorMeta.__sub=function(a: any,b: any) return vector(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    vectorMeta.__mul=function(a: any,b: any)
        if type(a)=="number" then return vector(a*b.X,a*b.Y,a*b.Z) end
        return vector(a.X*b,a.Y*b,a.Z*b)
    end
    local vectors={new=vector,zero=vector(0,0,0),one=vector(1,1,1)}
    local frames: any={}
    local frameMeta: any={}
    function frames.new(x: any,y: number?,z: number?): any
        local position=if type(x)=="table" then x else vector(x or 0,y or 0,z or 0)
        return setmetatable({Position=position,_kind="CFrame"},frameMeta)
    end
    frameMeta.__mul=function(a: any,b: any) return frames.new(a.Position+b.Position) end
    frames.Angles=function() return frames.new(0,0,0) end
    frames.identity=frames.new(0,0,0)
    local colors={fromRGB=function(r: number,g: number,b: number) return {R=r/255,G=g/255,B=b/255} end}
    local T=load("Theme",{Color3=colors,Enum=enum,Vector3=vectors})
    local bound={}
    local run={BindToRenderStep=function(_self: any,name: string,_priority: number,callback: any) bound[name]=callback end,
        UnbindFromRenderStep=function(_self: any,name: string) bound[name]=nil end}
    local camera={CFrame=frames.new(0,0,0),FieldOfView=70}
    local world={CurrentCamera=camera}
    local CameraFeel=load("Client/Visuals/CameraFeel",{game={GetService=function(_self: any,name: string)
        return if name=="RunService" then run else {Shared=sharedNode}
    end},Enum=enum,Vector3=vectors,CFrame=frames,workspace=world})
    local feel=CameraFeel.new()
    check(feel:Kick(100),"Camera accepts a dramatic cast without exceeding tier caps")
    check(feel.Studs<=T.CameraFeel.MajorStuds and feel.Degrees<=T.CameraFeel.MajorDegrees and feel.Fov<=T.CameraFeel.MaxFovKick,"Simultaneous camera motion remains within Art Bible caps")
    check(not feel:Kick(1),"Weaker rapid hits cannot continuously restart a major camera kick")
    local base=camera.CFrame
    bound[feel.BeforeName]();bound[feel.AfterName](1/60)
    check(camera.CFrame~=base and camera.FieldOfView>70,"An active kick adds a temporary camera contribution")
    bound[feel.BeforeName]()
    check(camera.CFrame==base and camera.FieldOfView==70,"Prior camera contribution is removed before the default camera update")
    for _=1,4 do bound[feel.AfterName](1/60);bound[feel.BeforeName]() end
    check(camera.CFrame==base and camera.FieldOfView==70,"Repeated camera frames cannot accumulate FOV or position drift")
    bound[feel.AfterName](1/60)
    local external=frames.new(8,3,2);camera.CFrame=external;camera.FieldOfView=85
    bound[feel.BeforeName]()
    check(camera.CFrame==external and camera.FieldOfView==85,"Unrelated camera script changes are preserved during restore")
    local paused=0;feel.OnHitStop=function(seconds: number) paused=seconds end
    check(feel:HitStop(10)==T.CameraFeel.MaxHitStop and paused==T.CameraFeel.MaxHitStop,"Cosmetic hold and animation callback clamp to configured maximum")
    feel:SetReducedMotion(true)
    check(not feel:Kick(3) and feel:HitStop()==0 and feel.Life==0,"Reduced motion disables camera kick and hit-stop")
    bound[feel.AfterName](1/60)
    check(camera.CFrame==external and camera.FieldOfView==85,"Reduced motion leaves the default camera untouched")
    local beforeName,afterName=feel.BeforeName,feel.AfterName
    feel:Destroy();feel:Destroy()
    check(bound[beforeName]==nil and bound[afterName]==nil,"Camera teardown disconnects both render bindings idempotently")

    local function tuple(...) return {...} end
    local created={}
    local function instance(class: string): any
        local object={ClassName=class,ClearCount=0,Destroyed=false}
        function object:Clear() self.ClearCount+=1 end
        function object:Destroy() self.Destroyed=true;self.Parent=nil end
        table.insert(created,object)
        return object
    end
    local config=load("VfxConfig",{Enum=enum,Vector3=vectors,CFrame=frames,
        Vector2={new=tuple},NumberRange={new=tuple},NumberSequence={new=tuple},
        NumberSequenceKeypoint={new=tuple},ColorSequence={new=tuple}})
    local quality=9
    local visible=true;local depth=5
    function camera:WorldToViewportPoint(_position: any) return {X=50,Y=50,Z=depth},visible end
    camera.CFrame=frames.new(0,0,0)
    local Service=load("Client/Visuals/VfxService",{game={GetService=function(_self: any,name: string)
        return if name=="UserInputService" then {TouchEnabled=false} else {Shared=sharedNode}
    end},workspace=world,Instance={new=instance},CFrame=frames,
        typeof=function(value: any) return if type(value)=="table" and value._kind then value._kind else type(value) end,
        UserSettings=function() return {GetService=function() return {SavedQualityLevel={Value=quality}} end} end})
    local service=Service.new({Mobile=false,Camera=camera})
    check(service:Stats().Active==0 and service:Stats().Allocated.Part==0,"Pools allocate lazily instead of prebuilding unused effects")
    check(service:Visible(vector(0,0,120)) and not service:Visible(vector(0,0,120.01)),"Distance culling includes120 studs and rejects greater distances")
    check(not service:Visible(vector(0/0,0,0)) and not service:Visible({X=0,Y=0,Z=0}),"Invalid or non-vector positions are rejected before allocation")
    visible=false
    check(service:Begin("offscreen",vector(1,0,0),1,2,{Part=1})==nil,"Offscreen effects allocate no pooled objects")
    visible=true;depth=-1
    check(service:Begin("behind",vector(1,0,0),1,2,{Part=1})==nil,"Behind-camera effects are skipped")
    depth=5
    check(service:Detail(vector(10,0,0))>service:Detail(vector(50,0,0)) and service:Detail(vector(50,0,0))>service:Detail(vector(100,0,0)),"Distance LOD reduces geometric detail in configured distance bands")
    check(Service.PowerTier(9)==1 and Service.PowerTier(7)==1 and Service.PowerTier(6)==2 and Service.PowerTier(4)==2 and Service.PowerTier(3)==3 and Service.PowerTier(1)==3,"All sequence ranges map to their presentation tier")
    local classes={"Part","Attachment","Beam","Trail","ParticleEmitter","PointLight","Highlight"}
    local costs={}
    for _,class in ipairs(classes) do costs[class]=1 end
    local effect=service:Begin("pooled",vector(1,0,0),99,4,costs)
    check(effect and effect.Tier==3 and effect.Scale==config.Tier[3].Scale,"Tier clamping cannot exceed the configured maximum scale")
    local objects={}
    for _,class in ipairs(classes) do
        objects[class]=effect:Acquire(class)
        check(objects[class]~=nil and effect:Acquire(class)==nil,"A handle cannot allocate beyond its declared per-class reservation")
    end
    check(effect:Acquire("Sound")==nil,"Undeclared object types cannot escape the bounded pools")
    check(objects.Part.Anchored and not objects.Part.CanCollide and not objects.Part.CanTouch and not objects.Part.CanQuery,"Effect geometry cannot participate in authoritative collision or targeting")
    check(not objects.PointLight.Enabled and not objects.PointLight.Shadows,"Pooled light default is disabled and shadow-free")
    objects.Beam.Attachment0=objects.Attachment;objects.Beam.Attachment1=objects.Attachment
    objects.Trail.Attachment0=objects.Attachment;objects.Highlight.Adornee={Name="OldTarget"}
    objects.Beam.Width0=99;objects.ParticleEmitter.Enabled=true;objects.PointLight.Enabled=true
    local finished=0;effect.OnFinish=function() finished+=1 end
    effect:Finish();effect:Finish()
    check(finished==1 and service:Stats().Active==0,"Effect completion callback and budget release run once")
    for _,class in ipairs(classes) do check(objects[class].Parent==nil,"Finishing detaches every pooled object") end
    check(not objects.Beam.Enabled and objects.Beam.Attachment0==nil and objects.Trail.Attachment0==nil and objects.Highlight.Adornee==nil,"Release clears beam/trail attachment and highlight target references")
    check(not objects.ParticleEmitter.Enabled and objects.ParticleEmitter.ClearCount>=2 and objects.Trail.ClearCount>=2,"Release clears retained particles and trail history")
    check(effect:Acquire("Part")==nil,"A completed handle cannot reclaim pooled objects")
    local reuse=service:Begin("reuse",vector(1,0,0),1,4,costs)
    for _,class in ipairs(classes) do check(reuse:Acquire(class)==objects[class],"Every requested class reuses its existing pooled instance") end
    check(objects.Beam.Width0==config.Beam.Width0 and objects.Highlight.Adornee==nil,"Reacquired instances start from configured defaults and no old target")
    reuse.Duration=0.1;service:Step(0.1)
    check(not reuse.Active and service:Stats().Active==0,"Effect lifetimes expire and return reservations without delayed callbacks")
    local errorEffect=service:Begin("error",vector(1,0,0),1,1,{Part=1})
    errorEffect:Acquire("Part");errorEffect.Update=function() error("Intentional presentation fault") end
    local errors=service:Stats().Errors;service:Step(0.01)
    check(not errorEffect.Active and service:Stats().Errors==errors+1,"A faulty update cannot leak pooled instances or reservations")
    local callbackError=service:Begin("callback-error",vector(1,0,0),1,1,{Part=1})
    callbackError:Acquire("Part");callbackError.OnFinish=function() error("Intentional cleanup fault") end
    callbackError:Finish()
    check(service:Stats().Errors==errors+2 and service:Stats().Active==0,"A faulty completion callback still releases pool resources")
    local expired=service:Begin("bounded-life",vector(1,0,0),1,1,{Part=1})
    expired.Duration=1000;service:Step(config.Lifetime.Maximum)
    check(not expired.Active,"User-supplied lifetimes cannot exceed the configured maximum")
    check(service:Begin("too-many-lights",vector(1,0,0),1,1,{PointLight=2})==nil,"An effect can never reserve more than one point light")
    local linger=service:Begin("offscreen-later",vector(1,0,0),1,1,{Part=1})
    linger:Acquire("Part");visible=false;service:Step(0.01);visible=true
    check(not linger.Active,"Active effects are reclaimed when they leave the view")
    local active=service:Begin("old-settings",vector(1,0,0),1,1,{Part=1})
    service:SetSettings(true,true)
    check(not active.Active and service:Stats().Active==0,"Changing accessibility or quality cancels old effects before reconfiguring budgets")
    local reduced=service:Begin("reduced",vector(1,0,0),1,1,{Part=1})
    check(reduced.ReducedMotion and reduced.Low and reduced.Detail<=config.Quality.Low,"New effects inherit reduced motion and explicit low-graphics detail")
    reduced:Finish()
    local capacity=service:Stats().MaxEffects
    local admitted={}
    for i=1,capacity do admitted[i]=service:Begin("ambient"..i,vector(1,0,0),1,1,{Part=1}) end
    check(service:Stats().Active==capacity and service:Begin("equal",vector(1,0,0),1,1,{Part=1})==nil,"Quality-specific simultaneous-effect cap rejects equal-priority overflow")
    check(service:Begin("impossible",vector(1,0,0),1,9,{Part=service:Stats().Limits.Part+1})==nil and service:Stats().Active==capacity,"Impossible high-priority effects preserve existing active effects")
    local important=service:Begin("impact",vector(1,0,0),1,5,{Part=1})
    check(important and not admitted[1].Active and service:Stats().Active==capacity and service:Stats().Evicted==1,"Important hits reclaim the oldest lower-priority effect at the simultaneous cap")
    service:SetSettings(false,false)
    local moteCalls=0
    local Hit=load("Client/Visuals/HitPresentation",{game={GetService=function() return {Shared=sharedNode} end},
        typeof=function(value: any) return if type(value)=="table" and value._kind then value._kind else type(value) end,
        Vector3=vectors,os={clock=function() return 100 end}})
    local hit=Hit.new(service,{Play=function() moteCalls+=1 end})
    local corpsePart={Parent=true,LocalTransparencyModifier=0.2}
    function corpsePart:IsA(class: string) return class=="BasePart" end
    local corpse={Parent=true,_kind="Instance"}
    function corpse:IsA(class: string) return class=="Model" end
    function corpse:GetDescendants() return {corpsePart} end
    function corpse:FindFirstChildOfClass() return {Health=0} end
    hit:Hit({Target=corpse,Position=vector(1,0,0)})
    hit:Death(corpse,vector(1,0,0))
    check(moteCalls==1 and service:Stats().Active==1,"A confirmed death has one dissolve even if its notification repeats")
    service:Step(config.Hit.DeathLife/2)
    check(corpsePart.LocalTransparencyModifier>0.2 and corpsePart.LocalTransparencyModifier<1,"Dissolve changes only the local transparency modifier over its configured lifetime")
    visible=false;service:Step(0.01);visible=true
    check(corpsePart.LocalTransparencyModifier==0.2 and hit.Deaths[corpse]==nil,"Offscreen cancellation restores the target's previous local transparency")
    hit:Death(corpse,vector(1,0,0));service:Step(config.Hit.DeathLife/2)
    service:SetSettings(false,true)
    check(corpsePart.LocalTransparencyModifier==0.2 and service:Stats().Active==0,"Quality changes restore partially dissolved characters before releasing their handles")
    hit:Death(corpse,vector(1,0,0));service:Step(config.Hit.DeathLife/2)
    service:Step(config.Hit.DeathHold)
    check(corpsePart.LocalTransparencyModifier==0.2,"Natural dissolve expiry restores local character visibility")
    function corpse:FindFirstChildOfClass() return {Health=100} end
    hit:Hit({Target=corpse,Position=vector(1,0,0),Dead=true})
    check(hit.Deaths[corpse]==true and service:Stats().Active==1,"Confirmed server death starts a dissolve before replicated Humanoid health catches up")
    service:Step(config.Hit.DeathLife/2)
    check(corpsePart.LocalTransparencyModifier>0.2,"Authoritative death presentation does not depend on local health replication timing")
    service:SetSettings(true,true)
    check(corpsePart.LocalTransparencyModifier==0.2 and hit.Deaths[corpse]==nil,"Cancelling a death received before health replication restores its original local transparency")
    local alive={Parent=true,_kind="Instance"}
    function alive:IsA(class: string) return class=="Model" end
    function alive:FindFirstChildOfClass() return {Health=100} end
    hit:Hit({Target=alive,Position=vector(1,0,0)})
    check(service:Stats().Active==0,"Reduced motion skips transient hit flashes while damage-number presentation remains independent")
    local mobile=Service.new({Mobile=true,Camera=camera})
    check(mobile:Stats().Limits.Part==config.Pools.Mobile.Part and mobile:Stats().MaxEffects<=config.Quality.MobileEffects,"Touch profile uses the smaller mobile pool and simultaneous caps")
    quality=1;mobile:Profile()
    check(mobile:Stats().MaxEffects==config.Quality.LowEffects,"Roblox graphics quality changes update admission limits")
    service:Destroy();service:Destroy();mobile:Destroy()
    check(service:Begin("after-destroy",vector(1,0,0),1,9,{Part=1})==nil,"Destroyed services cannot admit more effects")
    for _,object in ipairs(created) do check(object.Destroyed,"Service teardown destroys all allocated pooled objects and folders") end
    print("PASS: "..checks.." VFX framework admission/lifecycle and animation-spring assertions (engine stand-ins; no rendered certification)")
end
