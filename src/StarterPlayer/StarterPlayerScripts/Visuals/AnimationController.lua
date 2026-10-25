--!strict
-- Local, additive Motor6D presentation. Never moves a root, changes a Humanoid
-- property, disables Animate, or changes a track loaded by another controller.
local RunService=game:GetService("RunService")
local C=require(game:GetService("ReplicatedStorage").Shared.AnimConfig)
local Spring=require(script.Parent.MotionSpring)
local AnimationController={}
AnimationController.__index=AnimationController
type MotorState={Motor: Motor6D,Role: string,Base: CFrame?,Applied: CFrame?}
type EntryState={Name: string,Entry: any,Elapsed: number,Target: number,Fade: number,Spring: any,
    Track: AnimationTrack?,Animation: Animation?,AssetAge: number,AssetFailed: boolean,Profile: string?}
type Fields={Character: Model,Humanoid: Humanoid?,Root: BasePart?,Animator: Animator?,Motors: {MotorState},
    States: {[string]: EntryState},Connections: {RBXScriptConnection},ReducedMotion: boolean,
    AutoLocomotion: boolean,AutoState: string?,PauseLeft: number,Destroyed: boolean,WasAirborne: boolean,LastVertical: number}
export type Controller=typeof(setmetatable({} :: Fields,AnimationController))
local function finite(value: number): boolean return value==value and math.abs(value)<math.huge end
local function resolve(name: string): string return C.Aliases[name] or name end
local function contentId(value: any): string?
    if type(value)~="string" or value=="" then return nil end
    local digits=string.match(value,"^rbxassetid://(%d+)$") or string.match(value,"^(%d+)$")
    local number=if digits then tonumber(digits) else nil
    return if number and number>0 then "rbxassetid://"..(digits :: string) else nil
end
local function dispose(state: EntryState)
    if state.Track then state.Track:Stop();state.Track:Destroy();state.Track=nil end
    if state.Animation then state.Animation:Destroy();state.Animation=nil end
end
function AnimationController.new(character: Model,options: any?): Controller
    local opts=options or {}
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    local root=character:FindFirstChild("HumanoidRootPart")
    local self: Controller=setmetatable({Character=character,Humanoid=humanoid,
        Root=if root and root:IsA("BasePart") then root else character.PrimaryPart,
        Animator=if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil,
        Motors={},States={},Connections={},ReducedMotion=opts.ReducedMotion==true,
        AutoLocomotion=opts.AutoLocomotion~=false,AutoState=nil,PauseLeft=0,Destroyed=false,WasAirborne=false,LastVertical=0},AnimationController)
    local function motor(instance: Instance)
        if instance:IsA("Motor6D") then
            local role=C.MotorRoles[instance.Name]
            if role then table.insert(self.Motors,{Motor=instance,Role=role,Base=nil,Applied=nil}) end
        elseif instance:IsA("BasePart") and instance.Name=="HumanoidRootPart" then
            self.Root=instance
        elseif instance:IsA("Animator") and instance.Parent==self.Humanoid then
            self.Animator=instance
        end
    end
    for _,descendant in ipairs(character:GetDescendants()) do motor(descendant) end
    table.insert(self.Connections,character.DescendantAdded:Connect(motor))
    table.insert(self.Connections,character.DescendantRemoving:Connect(function(instance: Instance)
        if instance==self.Root then self.Root=nil end
        if instance==self.Animator then self.Animator=nil end
        for i=#self.Motors,1,-1 do
            if self.Motors[i].Motor==instance then
                local m=self.Motors[i]
                if m.Applied and m.Base and m.Motor.Transform==m.Applied then m.Motor.Transform=m.Base end
                table.remove(self.Motors,i)
            end
        end
    end))
    if opts.AutoStep~=false then
        -- Animator writes after PreAnimation and before PreSimulation. Undo only
        -- our exact last transform, then compose onto that frame's authored pose.
        table.insert(self.Connections,RunService.PreAnimation:Connect(function() self:Restore() end))
        table.insert(self.Connections,RunService.PreSimulation:Connect(function(dt: number) self:Step(dt) end))
    end
    if humanoid then
        table.insert(self.Connections,humanoid.Died:Connect(function() self:Play("Death") end))
        table.insert(self.Connections,humanoid.StateChanged:Connect(function(_old: Enum.HumanoidStateType,new: Enum.HumanoidStateType)
            if new==Enum.HumanoidStateType.Jumping then self:Play("Jump") end
        end))
    end
    return self
end
function AnimationController.Restore(self: Controller)
    for _,m in ipairs(self.Motors) do
        if m.Motor.Parent and m.Base and m.Applied and m.Motor.Transform==m.Applied then m.Motor.Transform=m.Base end
        m.Base=nil;m.Applied=nil
    end
end
function AnimationController.Play(self: Controller,name: string,weight: number?,fade: number?,profile: string?): boolean
    if self.Destroyed then return false end
    name=resolve(name)
    local entry=C.Entries[name]
    if not entry then return false end
    local override=profile and C.CastProfiles[profile] and C.CastProfiles[profile][name]
    if override then
        entry=table.clone(entry)
        for key,value in pairs(override) do
            if key~="AnimationId" or value~="" then entry[key]=value end
        end
    end
    local target=if weight and finite(weight) then math.clamp(weight,0,C.Blend.MaxWeight) else C.Blend.MaxWeight
    local transition=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else entry.FadeIn
    local state: EntryState?=self.States[name]
    if state and state.Profile~=profile then dispose(state);self.States[name]=nil;state=nil end
    if not state then
        local created: EntryState={Name=name,Entry=entry,Elapsed=0,Target=target,Fade=transition,Spring=Spring.new(0),
            Track=nil,Animation=nil,AssetAge=0,AssetFailed=false,Profile=profile}
        self.States[name]=created;state=created
        local id=contentId(entry.AnimationId)
        if id and self.Animator then
            local animation=Instance.new("Animation");animation.AnimationId=id;created.Animation=animation
            local ok,track=pcall(function() return (self.Animator :: Animator):LoadAnimation(animation) end)
            if ok then
                created.Track=track;track.Priority=entry.AssetPriority;track.Looped=entry.Loop
            else
                created.AssetFailed=true;animation:Destroy();created.Animation=nil
            end
        end
    end
    assert(state)
    state.Elapsed=0;state.AssetAge=0;state.Target=target;state.Fade=transition
    local track=state.Track
    if track and not state.AssetFailed then
        track:Play(transition,target,if self.PauseLeft>0 then 0 else 1)
    end
    return true
end
function AnimationController.Stop(self: Controller,name: string?,fade: number?)
    local wanted=if name then resolve(name) else nil
    for key,state in pairs(self.States) do
        if not wanted or key==wanted then
            state.Target=0
            state.Fade=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else state.Entry.FadeOut
            if state.Track then state.Track:Stop(state.Fade) end
        end
    end
end
function AnimationController.Blend(self: Controller,name: string,weight: number,fade: number?): boolean
    if self.Destroyed or not finite(weight) then return false end
    name=resolve(name)
    local state=self.States[name]
    if not state then return self:Play(name,weight,fade) end
    state.Target=math.clamp(weight,0,C.Blend.MaxWeight)
    state.Fade=if fade and finite(fade) then math.clamp(fade,C.Blend.MinFade,C.Blend.MaxFade) else C.Blend.Default
    if state.Track then state.Track:AdjustWeight(state.Target,state.Fade) end
    return true
end
function AnimationController.Pause(self: Controller,duration: number)
    if not finite(duration) then return end
    self.PauseLeft=math.max(self.PauseLeft,math.clamp(duration,0,C.Safety.MaxPause))
    for _,state in pairs(self.States) do
        if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(0) end
    end
end
function AnimationController.SetReducedMotion(self: Controller,reduced: boolean)
    self.ReducedMotion=reduced
    if reduced then
        self.PauseLeft=0
        for _,state in pairs(self.States) do
            if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(1) end
        end
    end
end
function AnimationController.Locomotion(self: Controller): number
    local humanoid,root=self.Humanoid,self.Root
    if not self.AutoLocomotion or not humanoid or not root then return 0 end
    if humanoid.Health<=0 then
        if not self.States.Death then self:Play("Death") end
        return 0
    end
    local velocity=root.AssemblyLinearVelocity
    local speed=Vector3.new(velocity.X,0,velocity.Z).Magnitude
    local airborne=humanoid.FloorMaterial==Enum.Material.Air
    if self.WasAirborne and not airborne and self.LastVertical<C.Locomotion.LandingVelocity then self:Play("Land") end
    self.WasAirborne=airborne;self.LastVertical=velocity.Y
    local name=if airborne or speed<C.Locomotion.MinSpeed then "Idle" elseif speed>=C.Locomotion.RunSpeed then "Run" else "Walk"
    if self.AutoState~=name then
        if self.AutoState then self:Stop(self.AutoState) end
        self.AutoState=name;self:Play(name)
    end
    return math.clamp(speed/C.Locomotion.SpeedReference,0,C.Locomotion.MaxSpeedRatio)
end
function AnimationController.Step(self: Controller,delta: number)
    if self.Destroyed or not finite(delta) or delta<0 then return end
    self:Restore()
    local dt=math.min(delta,C.Safety.MaxFrameDelta)
    local paused=self.PauseLeft>0
    self.PauseLeft=math.max(0,self.PauseLeft-dt)
    if paused and self.PauseLeft==0 then
        for _,state in pairs(self.States) do
            if state.Track and state.Track.IsPlaying then state.Track:AdjustSpeed(1) end
        end
    end
    local elapsed=if paused then 0 else dt
    local speed=self:Locomotion()
    local ordered: {EntryState}={}
    local assetPriority=-math.huge
    for name,state in pairs(self.States) do
        state.Elapsed+=elapsed;state.AssetAge+=dt
        if not state.Entry.Loop and state.Elapsed>=state.Entry.Duration then
            state.Target=0;state.Fade=state.Entry.FadeOut
        end
        state.Spring.Frequency=1/state.Fade
        state.Spring:Step(elapsed,state.Target)
        if state.Track then
            local track=state.Track
            if track.Length>0 and track.IsPlaying then
                assetPriority=math.max(assetPriority,state.Entry.Priority)
                track:AdjustWeight(state.Target,state.Fade)
            elseif state.AssetAge>=C.Safety.AssetLoadGrace then
                -- Invalid/unpermitted/unloaded real assets never leave an empty pose.
                track:Stop();track:Destroy();state.Track=nil;state.AssetFailed=true
                if state.Animation then state.Animation:Destroy();state.Animation=nil end
            end
        end
        if state.Target==0 and state.Spring.Value<C.Blend.WeightEpsilon then
            dispose(state);self.States[name]=nil
        else table.insert(ordered,state) end
    end
    table.sort(ordered,function(a: EntryState,b: EntryState)
        if a.Entry.Priority==b.Entry.Priority then return a.Name<b.Name end
        return a.Entry.Priority<b.Entry.Priority
    end)
    local poses: {[string]: CFrame}={}
    for _,state in ipairs(ordered) do
        if state.Entry.Priority>assetPriority then
            local weight=math.clamp(state.Spring.Value,0,C.Blend.MaxWeight)
            if self.ReducedMotion then weight*=C.Blend.ReducedScale end
            local pose=state.Entry.Procedural(state.Entry,state.Elapsed,speed)
            for role,transform in pairs(pose) do
                poses[role]=(poses[role] or CFrame.identity):Lerp(transform,weight)
            end
        end
    end
    for _,m in ipairs(self.Motors) do
        if m.Motor.Parent then
            local offset=poses[m.Role]
            if offset then
                m.Base=m.Motor.Transform;m.Motor.Transform=(m.Base :: CFrame)*offset
                -- Store the engine's read-back value, including its precision.
                m.Applied=m.Motor.Transform
            end
        end
    end
end
function AnimationController.Destroy(self: Controller)
    if self.Destroyed then return end
    self.Destroyed=true;self:Restore()
    for _,connection in ipairs(self.Connections) do connection:Disconnect() end
    for _,state in pairs(self.States) do dispose(state) end
    table.clear(self.Connections);table.clear(self.States);table.clear(self.Motors)
end
return AnimationController
