--!strict
-- Original, texture-free silhouettes. Optional particles supplement, never replace, geometry.
local C: any=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Blocks={}
Blocks.Names={"RingBurst","RisingMotes","ThreadBeam","DoorFrame","StarBurst","GlitchFlicker","GroundRune","ImpactFlash","ScreenEdgePulse","ShockwaveRing","AfterimageTrail"}
local TAU=math.pi*2
local function take(handle: any,class: string,parent: Instance?): any
    local object=handle:Acquire(class,parent)
    assert(object,"EffectBlocks exceeded reserved "..class.." budget")
    return object
end
local function alpha(age: number,duration: number,start: number): number
    return math.clamp((age/duration-start)/(1-start),0,1)
end
local function color(value: Color3): ColorSequence return ColorSequence.new(value) end
local function point(x: number,y: number,z: number): Vector3 return Vector3.new(x,y,z) end
local function segment(handle: any,host: BasePart,width: number,tint: Color3): any
    local a=take(handle,"Attachment",host) :: Attachment
    local b=take(handle,"Attachment",host) :: Attachment
    local beam=take(handle,"Beam",host) :: Beam
    beam.Attachment0=a;beam.Attachment1=b;beam.Color=color(tint);beam.Width0=width;beam.Width1=width
    return {A=a,B=b,Beam=beam}
end
local function setLine(line: any,a: Vector3,b: Vector3,transparency: number)
    line.A.Position=a;line.B.Position=b;line.Beam.Transparency=NumberSequence.new(transparency)
end
local function reserve(name: string,c: any,detail: number,low: boolean): (any,number,number)
    local segments=math.max(C.Blocks.Common.MinSegments,math.floor(C.Blocks.Common.Segments*detail))
    local n=0
    if name=="RingBurst" or name=="ShockwaveRing" then n=segments
    elseif name=="GroundRune" then n=segments+(if low then 0 else c.Spokes)
    elseif name=="DoorFrame" then n=(if low then 1 else c.Nested)*3
    elseif name=="StarBurst" then n=c.Points*2
    elseif name=="GlitchFlicker" then n=4
    elseif name=="ImpactFlash" then n=2
    elseif name=="ThreadBeam" then n=1 end
    local motes=if name=="RisingMotes" then math.max(1,math.floor(c.Count*detail)) else 0
    local trail=if name=="AfterimageTrail" and not low then 1 else 0
    local afterHead=if name=="AfterimageTrail" then 1 else 0
    local host=if name=="ScreenEdgePulse" then 0 else 1
    local emitter=if name=="RisingMotes" and C.Particle.Texture~="" then 1 else 0
    return {Part=host+motes+afterHead,Attachment=n*2+trail*2,Beam=n,Trail=trail,ParticleEmitter=emitter},segments,motes
end
function Blocks.new(service: any,callbacks: any?): any
    return setmetatable({Service=service,Callbacks=callbacks or {},LastPulse=nil},{__index=Blocks})
end
function Blocks.Play(self: any,name: string,position: Vector3,paletteName: string?,tier: number?,options: any?): any
    local c=C.Blocks[name]
    if not c or typeof(position)~="Vector3" then return nil end
    local pulse=name=="ImpactFlash" or name=="ScreenEdgePulse"
    local now=os.clock()
    if pulse then
        if self.Service:Profile().ReducedMotion then return nil end
        if self.LastPulse and now-self.LastPulse<C.Safety.MinimumPulseInterval then return nil end
    end
    local opts=options or {}
    local detail=self.Service:Detail(position)
    local low=detail<=C.Quality.Low
    local costs,segments,motes=reserve(name,c,detail,low)
    local h=self.Service:Begin(name,position,tier or 1,c.Priority,costs)
    if not h then return nil end
    if pulse then self.LastPulse=now end
    h.Duration=c.Duration
    local p=C.Palettes[paletteName or "Seer"] or C.Palettes.Seer
    local scale=h.Scale
    local common=C.Blocks.Common
    local width=common.Width*scale
    local host: any=nil
    if costs.Part>0 then
        host=take(h,"Part",nil)
        host.Size=Vector3.one*common.HostSize
        host.CFrame=if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position)
    end
    local update: (number,number,number)->() = function() end
    if name=="RingBurst" or name=="ShockwaveRing" or name=="GroundRune" then
        local lines={}
        for _=1,segments do table.insert(lines,segment(h,host,width,p.Accent)) end
        local spokes={}
        if name=="GroundRune" and not low then
            for _=1,c.Spokes do table.insert(spokes,segment(h,host,width,p.Primary)) end
        end
        update=function(_dt: number,age: number,t: number)
            local radius=c.Radius*scale
            if name~="GroundRune" then radius*=c.Start+(1-c.Start)*t end
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,line in ipairs(lines) do
                local a=(i-1)/segments*TAU
                local b=i/segments*TAU
                if name=="RingBurst" then b-=c.Gap/segments end
                setLine(line,point(math.cos(a)*radius,common.HeightOffset,math.sin(a)*radius),point(math.cos(b)*radius,common.HeightOffset,math.sin(b)*radius),fade)
            end
            for i,line in ipairs(spokes) do
                local a=(i-1)/c.Spokes*TAU
                local direction=point(math.cos(a),0,math.sin(a))
                setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,direction*radius+Vector3.yAxis*common.HeightOffset,fade)
            end
        end
    elseif name=="RisingMotes" then
        local pieces={}
        for i=1,motes do
            local part=take(h,"Part",nil) :: Part
            part.Shape=Enum.PartType.Ball;part.Color=if i%2==0 then p.Accent else p.Primary
            part.Size=Vector3.one*c.Size*scale
            table.insert(pieces,part)
        end
        if costs.ParticleEmitter>0 then
            local emitter=take(h,"ParticleEmitter",host) :: ParticleEmitter
            emitter.Color=color(p.Primary)
            emitter:Emit(math.max(1,math.floor(common.ParticleCount*h.Detail*common.ParticleEmitScale)))
        end
        update=function(_dt: number,age: number,t: number)
            for i,part in ipairs(pieces) do
                local a=(i-1)/motes*TAU+(if h.ReducedMotion then 0 else t*c.Orbit)
                local rise=if h.ReducedMotion then c.Height*(i/motes) else t*c.Height
                part.CFrame=host.CFrame*CFrame.new(math.cos(a)*c.Radius*scale,rise*scale,math.sin(a)*c.Radius*scale)
                part.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            end
        end
    elseif name=="ThreadBeam" then
        local line=segment(h,host,c.Width*scale,p.Accent)
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
        local arch=Vector3.yAxis*c.Height*scale
        local a=Vector3.zero
        local tangent0=endpoint/3+arch
        local tangent1=endpoint/3-arch
        -- Beams use +X on each attachment as their cubic Bezier tangent.
        local function tangentFrame(at: Vector3,tangent: Vector3): CFrame
            local right=if tangent.Magnitude>common.MinimumLength then tangent.Unit else Vector3.xAxis
            local up=if math.abs(right:Dot(Vector3.yAxis))<common.TangentVertical then Vector3.yAxis else Vector3.zAxis
            local back=right:Cross(up).Unit
            return CFrame.fromMatrix(at,right,back:Cross(right).Unit,back)
        end
        line.A.CFrame=tangentFrame(a,tangent0);line.B.CFrame=tangentFrame(endpoint,tangent1)
        line.Beam.CurveSize0=tangent0.Magnitude;line.Beam.CurveSize1=tangent1.Magnitude
        line.Beam.Segments=c.Segments;line.Beam.Width1=c.Width*scale*c.Taper
        update=function(_dt: number,age: number,_t: number)
            line.Beam.Transparency=NumberSequence.new(common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart))
        end
    elseif name=="DoorFrame" then
        local layers=if low then 1 else c.Nested
        local lines={}
        for _=1,layers*3 do table.insert(lines,segment(h,host,width,p.Primary)) end
        update=function(_dt: number,age: number,_t: number)
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i=1,layers do
                local half=(c.Width/2-(i-1)*c.Inset)*scale
                local base=c.Base*scale
                local top=(c.Height-(i-1)*c.Inset)*scale
                local offset=(i-1)*3
                setLine(lines[offset+1],point(-half,base,0),point(-half,top,0),fade)
                setLine(lines[offset+2],point(-half,top,0),point(half,top,0),fade)
                setLine(lines[offset+3],point(half,top,0),point(half,base,0),fade)
            end
        end
    elseif name=="StarBurst" or name=="ImpactFlash" then
        local lines={}
        local count=if name=="ImpactFlash" then 2 else c.Points*2
        for _=1,count do table.insert(lines,segment(h,host,width,p.Accent)) end
        update=function(_dt: number,age: number,t: number)
            local fade=(c.Alpha or common.Alpha)+(1-(c.Alpha or common.Alpha))*alpha(age,c.Duration,common.FadeStart)
            local radius=c.Radius*scale*(if h.ReducedMotion then 1 else (c.Start or c.Inner)+(1-(c.Start or c.Inner))*t)
            for i,line in ipairs(lines) do
                if name=="ImpactFlash" then
                    local direction=if i==1 then Vector3.xAxis else Vector3.yAxis
                    setLine(line,-direction*radius,direction*radius,fade)
                else
                    local a=(i-1)/count*TAU
                    local b=i/count*TAU
                    local r0=if i%2==1 then radius else radius*c.Inner
                    local r1=if i%2==1 then radius*c.Inner else radius
                    setLine(line,point(math.cos(a)*r0,math.sin(a)*r0,0),point(math.cos(b)*r1,math.sin(b)*r1,0),fade)
                end
            end
        end
    elseif name=="GlitchFlicker" then
        local lines={}
        for _=1,4 do table.insert(lines,segment(h,host,width,p.Accent)) end
        update=function(_dt: number,age: number,t: number)
            -- Two positional edits over 1.1s; opacity never oscillates or flashes.
            local step=if h.ReducedMotion or low then 0 else math.floor(t*c.Transitions)
            local shift=(if step%2==0 then -1 else 1)*c.Shift*scale
            local x=c.Width/2*scale;local y=c.Height/2*scale
            local gap=c.Split*scale
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            setLine(lines[1],point(-x+shift,-y,0),point(-x+shift,y,0),fade)
            setLine(lines[2],point(-x+shift,y,0),point(-gap+shift,y,0),fade)
            setLine(lines[3],point(x-shift,y,0),point(x-shift,-y,0),fade)
            setLine(lines[4],point(x-shift,-y,0),point(gap-shift,-y,0),fade)
        end
    elseif name=="ScreenEdgePulse" then
        if self.Callbacks.ScreenEdgePulse then self.Callbacks.ScreenEdgePulse(p.Primary,c.Duration) end
    elseif name=="AfterimageTrail" then
        local head=take(h,"Part",nil) :: Part
        head.Size=point(c.Head,c.Height,c.Head)*scale;head.Color=p.Primary
        local trail: Trail?=nil
        if costs.Trail>0 then
            local a=take(h,"Attachment",head) :: Attachment
            local b=take(h,"Attachment",head) :: Attachment
            a.Position=Vector3.yAxis*c.Height*scale/2;b.Position=-Vector3.yAxis*c.Height*scale/2
            local ribbon=take(h,"Trail",head) :: Trail
            ribbon.Attachment0=a;ribbon.Attachment1=b
            ribbon.Color=color(p.Primary);ribbon.Enabled=not h.ReducedMotion
            trail=ribbon
        end
        update=function(_dt: number,age: number,t: number)
            head.CFrame=host.CFrame*CFrame.new((if h.ReducedMotion then 0 else t*c.Length)*scale,c.Height*scale/2,0)
            head.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            if trail then trail.Enabled=not h.ReducedMotion end
        end
    end
    h.Update=update
    update(0,0,0)
    return h
end
return Blocks
