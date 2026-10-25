--!strict
-- Additive presentation only. No physics, player input, simulation time or default
-- camera updates are paused. The prior contribution is removed before Camera.
local RunService=game:GetService("RunService")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local C=T.CameraFeel
local CameraFeel={}
local nextId=0

local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end

local function unitOrZero(x: number,y: number,z: number): Vector3
    local vector=Vector3.new(x,y,z)
    return if vector.Magnitude>C.Epsilon then vector.Unit else Vector3.zero
end

function CameraFeel.Restore(self: any)
    local camera: Camera?=self.LastCamera
    if not camera then return end
    -- An unrelated camera script may have written after this module. Preserve its
    -- new value; only undo a value we can identify as our own exact contribution.
    if self.LastOutput and camera.CFrame==self.LastOutput then camera.CFrame=self.LastBase end
    if self.LastOutputFov and math.abs(camera.FieldOfView-self.LastOutputFov)<=C.Epsilon then
        camera.FieldOfView=self.LastBaseFov
    end
    self.LastCamera=nil;self.LastOutput=nil;self.LastOutputFov=nil
end

function CameraFeel.Step(self: any,delta: number)
    if self.Destroyed then return end
    self.SinceKick+=delta
    if self.ReducedMotion or self.Life<=0 then return end
    local dt=math.clamp(delta,0,C.StepCap)
    local held=math.min(self.Hold,dt)
    self.Hold-=held;self.Elapsed+=dt-held
    if self.Elapsed>=self.Life then self.Life=0;return end
    local camera=workspace.CurrentCamera
    if not camera then return end
    local remaining=1-self.Elapsed/self.Life
    -- A short attack and a firm settle, with the existing displacement/FOV caps.
    local attack=math.clamp((self.Elapsed+self.Hold)/C.Attack,0,1)
    local envelope=attack*remaining^C.SettlePower
    local time=self.Elapsed*C.Frequency*math.pi*2
    local ratio=C.FrequencyRatio
    local phase=C.Phase
    local axis=C.ShakeAxis
    local rotation=C.RotationAxis
    local x=math.sin(time*ratio.X+phase.X)
    local y=math.sin(time*ratio.Y+phase.Y)
    local z=math.sin(time*ratio.Z+phase.Z)
    -- Normalize the direction, then scale by the envelope. Simultaneous events
    -- share this single envelope, so vector magnitude cannot add past the cap.
    local translation=unitOrZero(x*axis.X,y*axis.Y,z*axis.Z)*self.Studs*envelope
    local angles=unitOrZero(y*rotation.X,z*rotation.Y,x*rotation.Z)*math.rad(self.Degrees)*envelope
    local base=camera.CFrame
    local baseFov=camera.FieldOfView
    local output=base*CFrame.new(translation)*CFrame.Angles(angles.X,angles.Y,angles.Z)
    local outputFov=math.clamp(baseFov+self.Fov*envelope,C.FovMin,C.FovMax)
    self.LastCamera=camera;self.LastBase=base;self.LastOutput=output
    self.LastBaseFov=baseFov;self.LastOutputFov=outputFov
    camera.CFrame=output;camera.FieldOfView=outputFov
end

function CameraFeel.new(): any
    nextId+=1
    local self: any=setmetatable({Destroyed=false,ReducedMotion=false,Elapsed=0,Life=0,
        Hold=0,Studs=0,Degrees=0,Fov=0,SinceKick=math.huge,OnHitStop=nil,
        BeforeName="MysteriesCameraRestore"..nextId,AfterName="MysteriesCameraFeel"..nextId}, {__index=CameraFeel})
    RunService:BindToRenderStep(self.BeforeName,Enum.RenderPriority.Camera.Value+C.BeforePriorityOffset,function()
        self:Restore()
    end)
    RunService:BindToRenderStep(self.AfterName,Enum.RenderPriority.Camera.Value+C.AfterPriorityOffset,function(dt: number)
        self:Step(dt)
    end)
    return self
end

function CameraFeel.Kick(self: any,tier: number?): boolean
    if self.Destroyed or self.ReducedMotion then return false end
    local selected=if type(tier)=="number" and finite(tier) then tier else C.DefaultTier
    local fraction=math.clamp((selected-C.DefaultTier)/(C.MajorTier-C.DefaultTier),0,1)
    local studs=C.SmallStuds+(C.MajorStuds-C.SmallStuds)*fraction
    if self.SinceKick<C.KickGap and studs<=self.Studs then return false end
    self.Studs=math.min(studs,C.MajorStuds)
    self.Degrees=math.min(C.SmallDegrees+(C.MajorDegrees-C.SmallDegrees)*fraction,C.MajorDegrees)
    self.Life=C.SmallDuration+(C.MajorDuration-C.SmallDuration)*fraction
    self.Fov=math.min(C.FovKick*self.Studs/C.MajorStuds,C.MaxFovKick)
    self.Elapsed=0;self.Hold=0;self.SinceKick=0
    return true
end

function CameraFeel.HitStop(self: any,duration: number?): number
    if self.Destroyed or self.ReducedMotion then return 0 end
    local selected=if type(duration)=="number" and finite(duration) then duration else C.HitStop
    local seconds=math.clamp(selected,0,C.MaxHitStop)
    self.Hold=math.max(self.Hold,seconds)
    -- The caller can pause its procedural character overlay for the same time.
    -- This never changes Animator playback speed or delays a gameplay action.
    if seconds>0 and self.OnHitStop then self.OnHitStop(seconds) end
    return seconds
end

function CameraFeel.SetReducedMotion(self: any,reduced: boolean)
    self.ReducedMotion=reduced==true
    if self.ReducedMotion then
        self.Life=0;self.Hold=0;self.SinceKick=math.huge;self:Restore()
    end
end

function CameraFeel.Destroy(self: any)
    if self.Destroyed then return end
    self.Destroyed=true
    RunService:UnbindFromRenderStep(self.BeforeName)
    RunService:UnbindFromRenderStep(self.AfterName)
    self:Restore();self.OnHitStop=nil
end

return CameraFeel
