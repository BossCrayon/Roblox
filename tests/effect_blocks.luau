--!strict
-- Runs real effect builders against finite pool and Roblox-value stand-ins.
-- This checks resource declarations/lifecycle parameters, not engine rendering.
return function(load: any,sharedNode: any)
    local checks=0
    local function check(value: any,message: string) assert(value,message);checks+=1 end
    local VM={};local vectorMethods={}
    local function vec(x: number,y: number,z: number): any return setmetatable({X=x,Y=y,Z=z},VM) end
    VM.__add=function(a,b) return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
    VM.__sub=function(a,b) return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    VM.__unm=function(a) return vec(-a.X,-a.Y,-a.Z) end
    VM.__mul=function(a,b) if type(a)=="number" then a,b=b,a end;return vec(a.X*b,a.Y*b,a.Z*b) end
    VM.__div=function(a,b) return vec(a.X/b,a.Y/b,a.Z/b) end
    VM.__index=function(a,k)
        if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
        if k=="Unit" then return a/a.Magnitude end
        return vectorMethods[k]
    end
    function vectorMethods:Dot(b) return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
    function vectorMethods:Cross(b) return vec(self.Y*b.Z-self.Z*b.Y,self.Z*b.X-self.X*b.Z,self.X*b.Y-self.Y*b.X) end
    local v3={new=vec,zero=vec(0,0,0),one=vec(1,1,1),xAxis=vec(1,0,0),yAxis=vec(0,1,0),zAxis=vec(0,0,1)}
    local CM={};local cm={}
    local function cf(x,y,z): any
        local at=if type(x)=="table" then x else vec(x or 0,y or 0,z or 0)
        return setmetatable({Position=at},CM)
    end
    CM.__index=cm;CM.__mul=function(a,b) return cf(a.Position+b.Position) end
    function cm:PointToObjectSpace(at) return at-self.Position end
    local cframe={new=cf,identity=cf(),Angles=function(x,y,z)
        local value=cf();value.Angles={x,y,z};return value
    end,fromMatrix=function(at,right,up,back)
        local value=cf(at);value.RightVector=right;value.UpVector=up;value.BackVector=back;return value
    end}
    local enum=setmetatable({},{__index=function(self,k)
        local namespace=setmetatable({},{__index=function(t,key) rawset(t,key,key);return key end})
        rawset(self,k,namespace);return namespace
    end})
    local function sequence(a,b) return {Start=a,Finish=b} end
    local now=0
    local env={os={clock=function() return now end},Enum=enum,Vector3=v3,CFrame=cframe,Vector2={new=function(x,y) return {X=x,Y=y} end},
        Color3={fromRGB=function(r,g,b) return {R=r/255,G=g/255,B=b/255} end},
        NumberRange={new=sequence},NumberSequence={new=sequence},ColorSequence={new=sequence},
        NumberSequenceKeypoint={new=function(t,v) return {Time=t,Value=v} end},
        typeof=function(value)
            local meta=getmetatable(value)
            return if meta==VM then "Vector3" elseif meta==CM then "CFrame" else typeof(value)
        end,
        game={GetService=function(_self,id) assert(id=="ReplicatedStorage");return {Shared=sharedNode} end},
    }
    load("Theme",env)
    local config=load("VfxConfig",env)
    local Blocks=load("Client/Visuals/EffectBlocks",env)
    local detail=1;local reduced=false;local denied=false;local pulseCalls=0
    local service={}
    function service:Detail(_position) return detail end
    function service:Profile() return {ReducedMotion=reduced} end
    function service:Begin(name,position,tier,priority,costs)
        if denied then return nil end
        local h={Name=name,Position=position,Scale=config.Tier[tier].Scale,Detail=detail,ReducedMotion=reduced,
            Reserved=costs,Allocated={},Objects={}}
        function h:Acquire(class,parent)
            local allocated=(self.Allocated[class] or 0)+1
            check(allocated<=(self.Reserved[class] or 0),name.." reserves every "..class)
            self.Allocated[class]=allocated
            local object={ClassName=class,Parent=parent,CFrame=cf(),Emitted=0}
            function object:Emit(amount) self.Emitted+=amount end
            table.insert(self.Objects,object)
            return object
        end
        function h:Finish() self.Finished=true end
        return h
    end
    local blocks=Blocks.new(service,{ScreenEdgePulse=function(_color,_duration) pulseCalls+=1 end})
    check(#Blocks.Names==11,"Eleven reusable blocks exposed")
    local names={}
    local profiles={{Detail=1,Reduced=false},{Detail=config.Quality.Low,Reduced=false},{Detail=1,Reduced=true}}
    for _,profile in ipairs(profiles) do
        detail=profile.Detail;reduced=profile.Reduced
        for tier=1,3 do
            for _,name in ipairs(Blocks.Names) do
                names[name]=true
                local p=vec(2,1,3)
                now+=config.Safety.MinimumPulseInterval*2
                local h=blocks:Play(name,p,({"Seer","Marauder","Apprentice"})[tier],tier)
                if reduced and (name=="ImpactFlash" or name=="ScreenEdgePulse") then
                    check(h==nil,name.." skipped with reduced motion")
                    continue
                end
                check(h~=nil,name.." supported at every quality/tier/motion profile")
                check(h.Duration>0 and h.Duration<=config.Lifetime.Maximum,name.." finite lifetime")
                check(type(h.Update)=="function",name.." has owned update")
                h.Update(0,h.Duration/2,0.5)
                h.Update(0,h.Duration,1)
                for _,object in ipairs(h.Objects) do
                    if object.ClassName=="Beam" then
                        check(object.Attachment0~=nil and object.Attachment1~=nil,name.." beam endpoints exist")
                        local transparency=object.Transparency.Start
                        check(type(transparency)=="number" and transparency>=0 and transparency<=1,name.." beam opacity clamped")
                    elseif object.ClassName=="Trail" and reduced then
                        check(not object.Enabled,"Reduced motion disables moving afterimage ribbon")
                    end
                end
                if name=="DoorFrame" and detail==config.Quality.Low then
                    check(h.Allocated.Beam==3,"Low portal has one three-sided frame")
                elseif name=="GroundRune" and detail==config.Quality.Low then
                    check(h.Allocated.Beam==config.Blocks.Common.MinSegments,"Low rune removes spokes")
                elseif name=="AfterimageTrail" and detail==config.Quality.Low then
                    check(h.Allocated.Trail==nil,"Low afterimage omits trail instance")
                elseif name=="RisingMotes" then
                    check(h.Allocated.ParticleEmitter==nil,"Empty particle texture uses geometric fallback")
                end
            end
        end
    end
    check(names.ThreadBeam and names.ScreenEdgePulse,"Catalog includes curved and screen primitives")
    reduced=false;now+=config.Safety.MinimumPulseInterval*2
    local first=blocks:Play("ImpactFlash",vec(0,0,0),"Seer",1)
    check(first~=nil,"First pulse admitted")
    check(blocks:Play("ImpactFlash",vec(0,0,0),"Seer",1)==nil,"Repeated impact flash throttled")
    local beforeThrottle=pulseCalls
    check(blocks:Play("ScreenEdgePulse",vec(0,0,0),"Seer",1)==nil,"Impact and screen pulses share safety gate")
    check(pulseCalls==beforeThrottle,"Throttled pulse has no screen callback")
    now+=config.Safety.MinimumPulseInterval/2
    check(blocks:Play("ImpactFlash",vec(0,0,0),"Seer",1)==nil,"Flash gap enforced until minimum interval")
    now+=config.Safety.MinimumPulseInterval*2
    check(blocks:Play("ScreenEdgePulse",vec(0,0,0),"Seer",1)~=nil,"Pulse admitted after interval")
    now+=config.Safety.MinimumPulseInterval*2
    local before=pulseCalls;denied=true
    check(blocks:Play("ScreenEdgePulse",vec(0,0,0),"Seer",1)==nil,"Denied effect returns nil")
    check(pulseCalls==before,"Budget-denied screen pulse cannot bypass admission")
    denied=false;detail=1;reduced=false
    local curved=blocks:Play("ThreadBeam",vec(0,0,0),"Seer",1,{EndPosition=vec(0,7,0)})
    for _,object in ipairs(curved.Objects) do
        if object.ClassName=="Beam" then
            check(object.CurveSize0>0 and object.CurveSize1>0,"Thread uses real cubic Bezier tangents")
        end
    end
    check(blocks:Play("Unknown",vec(0,0,0),"Seer",1)==nil,"Unknown block rejected")
    check(blocks:Play("RingBurst",nil,"Seer",1)==nil,"Invalid position rejected")
    print("PASS effect block reservations: "..checks.." assertions (value/pool stand-ins; no rendering)")
end
