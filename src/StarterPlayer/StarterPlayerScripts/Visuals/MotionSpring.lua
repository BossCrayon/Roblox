--!strict
-- Critically damped scalar spring. Stable closed form; no physics or server time.
local C=require(game:GetService("ReplicatedStorage").Shared.AnimConfig)
local MotionSpring={}
MotionSpring.__index=MotionSpring
type Fields={Value: number,Velocity: number,Frequency: number}
export type Spring=typeof(setmetatable({} :: Fields,MotionSpring))
function MotionSpring.new(value: number,frequency: number?): Spring
    return setmetatable({Value=value,Velocity=0,Frequency=frequency or C.Spring.Frequency},MotionSpring)
end
function MotionSpring.Reset(self: Spring,value: number)
    self.Value=value;self.Velocity=0
end
function MotionSpring.Step(self: Spring,delta: number,target: number): number
    if delta<=0 then return self.Value end
    local omega=math.max(0,self.Frequency)*math.pi*2
    if omega==0 then self.Value=target;self.Velocity=0;return target end
    local dt=math.min(delta,C.Spring.MaxStep)
    local difference=self.Value-target
    local tangent=self.Velocity+omega*difference
    local decay=math.exp(-omega*dt)
    self.Value=target+(difference+tangent*dt)*decay
    self.Velocity=(self.Velocity-omega*tangent*dt)*decay
    return self.Value
end
function MotionSpring.Smoothstep(value: number): number
    local t=math.clamp(value,0,1)
    return t*t*(3-2*t)
end
return MotionSpring
