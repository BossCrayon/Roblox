--!strict
-- Original, texture-free silhouettes. Optional particles supplement, never replace, geometry.
local C: any=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Blocks={}
Blocks.Names={"RingBurst","RisingMotes","ThreadBeam","DoorFrame","StarBurst","GlitchFlicker","GroundRune","ImpactFlash","ScreenEdgePulse","ShockwaveRing","AfterimageTrail"}
Blocks.AbilityNames={"SigilStencil","CardFan","PaperFold","VeilRibbon","ContourEcho"}
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
local function stencil(c: any,low: boolean,opts: any): any
    return c.Paths[(if low then opts.LowGlyph or opts.Glyph else opts.Glyph) or C.Ability.EyeGlyph] or c.Paths[C.Ability.EyeGlyph]
end
local function reserve(name: string,c: any,detail: number,low: boolean,opts: any?): (any,number,number)
    local segments=math.max(C.Blocks.Common.MinSegments,math.floor(C.Blocks.Common.Segments*detail))
    local n=0
    if name=="RingBurst" or name=="ShockwaveRing" then n=segments
    elseif name=="GroundRune" then n=segments+(if low then 0 else c.Spokes)
    elseif name=="DoorFrame" then n=(if low then 1 else c.Nested)*3
    elseif name=="StarBurst" then n=c.Points*2
    elseif name=="GlitchFlicker" then n=4
    elseif name=="ImpactFlash" then n=2
    elseif name=="ThreadBeam" then n=1
    elseif name=="VeilRibbon" then n=if low then c.LowCount else c.Count
    elseif name=="SigilStencil" then
        for _,path in ipairs(stencil(c,low,opts or {})) do n+=math.max(0,#path-1) end
    end
    local motes=if name=="RisingMotes" then math.max(1,math.floor(c.Count*detail))
        elseif name=="SigilStencil" and opts and opts.Follow and not low then c.IntakeCount else 0
    local trail=if name=="AfterimageTrail" and not low then 1 else 0
    local afterHead=if name=="AfterimageTrail" then 1 else 0
    local host=if name=="ScreenEdgePulse" then 0 else 1
    local pieces=0
    if name=="CardFan" then pieces=if low then c.LowCount else c.Count
    elseif name=="PaperFold" or name=="ContourEcho" then pieces=if low then #c.LowPieces else #c.Pieces end
    local emitter=if name=="RisingMotes" and C.Particle.Texture~="" then 1 else 0
    return {Part=host+motes+afterHead+pieces,Attachment=n*2+trail*2,Beam=n,Trail=trail,ParticleEmitter=emitter},segments,motes
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
    local detail=math.min(self.Service:Detail(position),opts.Detail or math.huge)
    local low=detail<=C.Quality.Low
    if opts.Duration then c=table.clone(c);c.Duration=opts.Duration end
    if opts.Width or opts.Height then
        c=table.clone(c);c.Width=opts.Width or c.Width;c.Height=opts.Height or c.Height
    end
    if opts.Radius then c=table.clone(c);c.Radius=opts.Radius end
    local costs,segments,motes=reserve(name,c,detail,low,opts)
    local h=opts.Lease or self.Service:Begin(name,position,tier or 1,c.Priority,costs)
    if not h then return nil end
    h.Scale*=opts.Scale or 1
    if pulse then self.LastPulse=now end
    h.Duration=c.Duration
    local p=C.Palettes[paletteName or "Seer"] or C.Palettes.Seer
    if opts.Tint then p=table.clone(p);p.Primary=opts.Tint;p.Accent=opts.Tint end
    local scale=h.Scale
    local common=C.Blocks.Common
    local width=math.max(common.Width*scale,opts.MinWidth or 0)
    local host: any=nil
    if costs.Part>0 then
        host=take(h,"Part",nil)
        host.Size=Vector3.one*common.HostSize
        host.CFrame=if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position)
    end
    local update: (number,number,number)->() = function() end
    if name=="CardFan" or name=="PaperFold" or name=="ContourEcho" then
        local pieces={}
        local count=costs.Part-1
        for i=1,count do
            local part=take(h,"Part",nil)
            part.Color=if name=="ContourEcho" then p.Primary else c.Color
            part.Material=Enum.Material.SmoothPlastic
            local shape=nil
            if name~="CardFan" then shape=c.Pieces[if low then c.LowPieces[i] else i] end
            part.Size=if shape then point(shape[4],shape[5],shape[6])*scale else c.Size*scale
            table.insert(pieces,{Part=part,Shape=shape})
        end
        update=function(_dt: number,age: number,t: number)
            local fade=c.Alpha+(1-c.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,entry in ipairs(pieces) do
                local offset: Vector3
                local rotation=CFrame.identity
                if name=="CardFan" then
                    local index=i-(count+1)/2
                    offset=point(index*c.Offset,0,0)*scale
                    rotation=CFrame.Angles(0,0,math.rad(index*c.Spread))
                else
                    local shape=entry.Shape
                    offset=point(shape[1],shape[2],shape[3])*scale
                    if name=="PaperFold" and opts.Break and not h.ReducedMotion then
                        local direction=if offset.Magnitude>common.MinimumLength then offset.Unit else Vector3.yAxis
                        offset+=direction*t*c.BreakDistance*scale
                    elseif name=="ContourEcho" and not h.ReducedMotion then offset+=Vector3.xAxis*t*c.Drift*scale end
                end
                entry.Part.CFrame=host.CFrame*CFrame.new(offset)*rotation;entry.Part.Transparency=fade
            end
        end
    elseif name=="VeilRibbon" then
        local lines={}
        for _=1,costs.Beam do table.insert(lines,segment(h,host,c.Width*scale,p.Primary)) end
        update=function(_dt: number,age: number,t: number)
            local fade=c.Alpha+(1-c.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i,line in ipairs(lines) do
                local side=if i%2==0 then 1 else -1
                if opts.Coil and not h.ReducedMotion then
                    local angle=t*TAU+side*math.pi/2
                    local radius=c.Offset*scale
                    setLine(line,point(math.cos(angle)*radius,-c.Height*scale/2,math.sin(angle)*radius),
                        point(-math.cos(angle)*radius,c.Height*scale/2,-math.sin(angle)*radius),fade)
                else
                    setLine(line,point(side*c.Offset*scale,-c.Height*scale/2,0),point(side*c.Offset*scale,c.Height*scale/2,0),fade)
                end
                local wave=if h.ReducedMotion or low then 0 else math.sin(t*TAU+i)*C.Cinematic.VeilSway
                line.Beam.CurveSize0=(c.Curve+wave)*scale;line.Beam.CurveSize1=(-c.Curve+wave)*scale
            end
        end
    elseif name=="SigilStencil" then
        local paths=stencil(c,low,opts)
        local lines={}
        local intake={}
        for _=1,motes do
            local part=take(h,"Part",nil) :: Part
            part.Shape=Enum.PartType.Ball;part.Size=Vector3.one*c.IntakeSize*scale;part.Color=p.Accent
            table.insert(intake,part)
        end
        for _,path in ipairs(paths) do
            for i=1,#path-1 do table.insert(lines,{Line=segment(h,host,width,p.Accent),A=path[i],B=path[i+1]}) end
        end
        update=function(_dt: number,age: number,_t: number)
            if opts.MoveTo then
                local t=if h.ReducedMotion then 1 else math.clamp(age/c.Duration,0,1)
                host.CFrame=((if typeof(opts.Frame)=="CFrame" then opts.Frame else CFrame.new(position))+(opts.MoveTo-position)*t)
                    *CFrame.Angles(0,0,if h.ReducedMotion or low then 0 else age*(opts.Spin or C.Cinematic.SigilSpin))
            end
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            local progress=math.min(1,age/C.Cinematic.Intake)
            for i,part in ipairs(intake) do
                local angle=(i-1)/motes*TAU+progress*math.pi
                local radius=c.Size*scale*(1-progress)
                part.CFrame=host.CFrame*CFrame.new(math.cos(angle)*radius,math.sin(angle)*radius,0)
                part.Transparency=if h.ReducedMotion then 1 else common.Alpha+(1-common.Alpha)*progress
            end
            for _,entry in ipairs(lines) do
                local intakeScale=if h.ReducedMotion then 1 else 1+C.Cinematic.IntakeRadius*(1-math.clamp(age/C.Cinematic.Intake,0,1))
                local function vertex(v: any): Vector3 return point((v[1]-0.5)*c.Size*scale*intakeScale,(0.5-v[2])*c.Size*scale*intakeScale,0) end
                setLine(entry.Line,vertex(entry.A),vertex(entry.B),fade)
            end
        end
    elseif name=="RingBurst" or name=="ShockwaveRing" or name=="GroundRune" then
        local lines={}
        for _=1,segments do table.insert(lines,segment(h,host,width,p.Accent)) end
        local spokes={}
        if name=="GroundRune" and not low then
            for _=1,c.Spokes do table.insert(spokes,segment(h,host,width,p.Primary)) end
        end
        update=function(_dt: number,age: number,t: number)
            local radius=c.Radius*scale
            if name~="GroundRune" and not h.ReducedMotion then radius*=c.Start+(1-c.Start)*t end
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
                if opts.InnerRing then
                    local b=a+TAU/c.Spokes
                    setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,
                        point(math.cos(b),0,math.sin(b))*radius*c.Inner+Vector3.yAxis*common.HeightOffset,fade)
                else
                    setLine(line,direction*radius*c.Inner+Vector3.yAxis*common.HeightOffset,direction*radius+Vector3.yAxis*common.HeightOffset,fade)
                end
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
                local intake=if opts.Intake then 1-t else math.min(1,t/C.Cinematic.Intake)
                local radius=c.Radius*(if h.ReducedMotion then 1 else C.Cinematic.IntakeRadius+(1-C.Cinematic.IntakeRadius)*intake)
                local rise=if h.ReducedMotion then c.Height*(i/motes) elseif opts.Intake then (1-t)*c.Height else t*c.Height
                part.CFrame=host.CFrame*CFrame.new(math.cos(a)*radius*scale,rise*scale,math.sin(a)*radius*scale)
                part.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            end
        end
    elseif name=="ThreadBeam" then
        local line=segment(h,host,math.max(c.Width*scale,opts.MinWidth or 0),p.Accent)
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
        local arch=Vector3.yAxis*(opts.Curve or c.Height)*scale
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
        line.Beam.Segments=c.Segments;line.Beam.Width1=math.max(c.Width*scale*c.Taper,opts.MinWidth or 0)
        update=function(_dt: number,age: number,_t: number)
            local draw=if h.ReducedMotion or not opts.Draw then 1 else math.min(1,age/C.Cinematic.BeamDraw)
            line.B.Position=endpoint*draw
            line.Beam.Width0=math.max(c.Width*scale,opts.MinWidth or 0)*(1+C.Cinematic.Afterglow*(1-draw))
            line.Beam.Transparency=NumberSequence.new(common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart))
        end
    elseif name=="DoorFrame" then
        local layers=if low then 1 else c.Nested
        local lines={}
        for _=1,layers*3 do table.insert(lines,segment(h,host,width,p.Primary)) end
        update=function(_dt: number,age: number,_t: number)
            local fade=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            for i=1,layers do
                local opening=if h.ReducedMotion then 1 else C.Cinematic.DoorOpen+(1-C.Cinematic.DoorOpen)*math.min(1,age/C.Cinematic.Intake)
                local half=(c.Width/2-(i-1)*c.Inset)*scale*opening
                local base=c.Base*scale
                local top=(c.Height-(i-1)*c.Inset)*scale
                local offset=(i-1)*3
                local depth=(i-1)*C.Cinematic.DoorDepth*scale
                setLine(lines[offset+1],point(-half,base,depth),point(-half,top,depth),fade)
                setLine(lines[offset+2],point(-half,top,depth),point(half,top,depth),fade)
                setLine(lines[offset+3],point(half,top,depth),point(half,base,depth),fade)
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
        local endpoint=if typeof(opts.EndPosition)=="Vector3" then host.CFrame:PointToObjectSpace(opts.EndPosition) else point(c.Length*scale,0,0)
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
            local travel=if h.ReducedMotion then 1 else math.min(1,age/C.Cinematic.TrailTravel)
            head.CFrame=host.CFrame*CFrame.new(endpoint*travel+Vector3.yAxis*c.Height*scale/2)
            head.Transparency=common.Alpha+(1-common.Alpha)*alpha(age,c.Duration,common.FadeStart)
            if trail then trail.Enabled=not h.ReducedMotion end
        end
    end
    local wrapped=function(dt: number,age: number,t: number)
        if host and opts.MoveTo and name~="SigilStencil" then
            local fraction=if h.ReducedMotion then 1 else t
            host.CFrame=(opts.Frame or CFrame.new(position))+(opts.MoveTo-position)*fraction
        end
        if host and opts.Follow then
            if not opts.Follow.Parent then h:Finish();return end
            host.CFrame=CFrame.new(opts.Follow.Position+(opts.Offset or Vector3.zero))*(if opts.Frame then opts.Frame.Rotation else CFrame.identity)
        end
        if host and (name=="SigilStencil" or name=="GroundRune") and not opts.MoveTo then
            local base=if opts.Follow then host.CFrame else opts.Frame or CFrame.new(position)
            local spin=if h.ReducedMotion or low then 0 else age*(opts.Spin or (if name=="GroundRune" then C.Cinematic.RuneSpin else C.Cinematic.SigilSpin))
            host.CFrame=base*(if name=="GroundRune" then CFrame.Angles(0,spin,0) else CFrame.Angles(0,0,spin))
        end
        update(dt,age,t)
    end
    h.Update=wrapped
    wrapped(0,0,0)
    return h
end
-- One atomic reservation for the entire cast. Endpoints instantiate lazily and
-- park independently when outside the viewport/120-stud limit.
function Blocks.Compose(self: any,layers: {any},tier: number,priority: number,duration: number): any
    if #layers==0 or #layers>C.Composition.MaxLayers or duration~=duration or duration<=0 or duration>C.Lifetime.Maximum then return nil end
    local profile=self.Service:Profile()
    local accepted={}
    for _,layer in ipairs(layers) do
        local pulse=layer.Name=="ImpactFlash" or layer.Name=="ScreenEdgePulse"
        if not pulse or (not profile.ReducedMotion and (not self.LastPulse or os.clock()-self.LastPulse>=C.Safety.MinimumPulseInterval)) then
            table.insert(accepted,layer)
        end
    end
    layers=accepted
    if #layers==0 then return nil end
    local detail=if profile.Mobile then math.min(profile.Detail,C.Composition.MobileDetail) else profile.Detail
    local costs={};local anchors={}
    for _,layer in ipairs(layers) do
        local config=C.Blocks[layer.Name]
        if not config or typeof(layer.Position)~="Vector3" then return nil end
        local layerDetail=math.min(detail,(layer.Options and layer.Options.Detail) or math.huge)
        local budget=reserve(layer.Name,config,layerDetail,layerDetail<=C.Quality.Low,layer.Options)
        for class,count in pairs(budget) do costs[class]=(costs[class] or 0)+count end
        table.insert(anchors,layer.Position)
    end
    for _,layer in ipairs(layers) do
        if layer.Options and layer.Options.MoveTo then table.insert(anchors,layer.Options.MoveTo) end
    end
    local h=self.Service:Begin("AbilityComposition",anchors[1],tier,priority,costs,anchors)
    if not h then return nil end
    h.Duration=duration
    local groups={}
    for _,layer in ipairs(layers) do table.insert(groups,{Layer=layer,Anchor=layer.Position,Objects={},Built=false,Child=nil,Visible=false}) end
    h.ResolveAnchors=function()
        for i,group in ipairs(groups) do
            local layer=group.Layer
            if layer.Options and layer.Options.Follow then
                if not layer.Options.Follow.Parent then h:Finish();return end
                layer.Position=layer.Options.Follow.Position+(layer.Options.Offset or Vector3.zero)
            end
            local anchor=layer.Position
            if layer.Options and layer.Options.MoveTo then
                local t=if h.ReducedMotion then 1 else math.clamp(h.Age/duration,0,1)
                anchor+=(layer.Options.MoveTo-anchor)*t
            end
            group.Anchor=anchor;h.Anchors[i]=anchor
        end
    end
    local function update(dt: number,age: number,_progress: number)
        for _,group in ipairs(groups) do
            local layer=group.Layer
            local delay=math.clamp((layer.Options and layer.Options.Delay) or 0,0,duration)
            local life=math.clamp((layer.Options and layer.Options.Life) or (duration-delay),C.Blocks.Common.MinimumLength,math.max(C.Blocks.Common.MinimumLength,duration-delay))
            local visible=age>=delay and age<delay+life and self.Service:Visible(group.Anchor)
            if layer.Options and layer.Options.EndPosition then visible=visible and self.Service:Visible(layer.Options.EndPosition) end
            if visible and not group.Built then
                local child: any={Scale=h.Scale,Detail=detail,ReducedMotion=h.ReducedMotion,Duration=duration}
                function child:Acquire(class: string,parent: Instance?): any
                    local object=h:Acquire(class,parent)
                    if object then table.insert(group.Objects,{Object=object,Parent=object.Parent}) end
                    return object
                end
                function child:Finish() h:Finish() end
                local opts=table.clone(layer.Options or {})
                opts.Lease=child;opts.Detail=math.min(detail,opts.Detail or math.huge);opts.Duration=life
                child.Detail=opts.Detail
                opts.MinWidth=if profile.Mobile then C.Composition.MobileMinWidth else C.Composition.MinWidth
                group.Child=self:Play(layer.Name,layer.Position,layer.Palette,tier,opts)
                group.Built=true
            end
            if group.Visible~=visible then
                for _,entry in ipairs(group.Objects) do entry.Object.Parent=if visible then entry.Parent else nil end
                group.Visible=visible
            end
            if visible and group.Child and group.Child.Update then
                group.Child.Update(dt,age-delay,math.clamp((age-delay)/life,0,1))
            end
        end
    end
    h.Update=update
    local ok=pcall(function() h.ResolveAnchors();if h.Active then update(0,0,0) end end)
    if not ok then self.Service.Errors+=1;h:Finish();return nil end
    return h
end
return Blocks
