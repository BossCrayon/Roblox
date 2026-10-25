--!strict
-- Original silhouettes; the real registered root/humanoid remains the sole combat entity.
local Collection=game:GetService("CollectionService")
local Players=game:GetService("Players")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Parent.UI.Kit)
local A=T.EnemyArt
local Enemies={}
function Enemies.new(service: any,blocks: any,runtime: any,notice: ((string)->())?,audio: ((string)->())?): any
    return setmetatable({Service=service,Blocks=blocks,Runtime=runtime,Notice=notice,Audio=audio,Records={},Bars={},BarCount=0,Elapsed=0,IntroAt=0,Seen=setmetatable({},{__mode="k"})},{__index=Enemies})
end
function Enemies.Bar(self: any): any
    local pooled=table.remove(self.Bars)
    if pooled then return pooled end
    if self.BarCount>=A.MaxBars then return nil end;self.BarCount+=1
    local gui=Kit.New("BillboardGui",self.Service.Folder,{Name="MysteriesEnemyHealth",Size=UDim2.fromOffset(A.BarWidth,A.BarHeight),
        MaxDistance=A.BarDistance,AlwaysOnTop=false})
    local title=Kit.Text(gui,"",T.Type.Micro,T.Fonts.Number);title.Name="Title";title.Size=UDim2.new(1,0,1,-A.BarTrack)
    title.BackgroundColor3=T.Colors.Ink;title.BackgroundTransparency=0;title.TextXAlignment=Enum.TextXAlignment.Center
    local track=Kit.New("Frame",gui,{Name="Track",BorderSizePixel=0,BackgroundColor3=T.Colors.Slate,
        Position=UDim2.new(0,0,1,-A.BarTrack),Size=UDim2.new(1,0,0,A.BarTrack)})
    Kit.New("Frame",track,{Name="Fill",BorderSizePixel=0,BackgroundColor3=T.Colors.Health,Size=UDim2.fromScale(1,1)})
    return gui
end
function Enemies.ReleaseBar(self: any,r: any)
    if r.Bar then r.Bar.Enabled=false;r.Bar.Adornee=nil;table.insert(self.Bars,r.Bar);r.Bar=nil end
end
function Enemies.Clear(self: any,model: Model)
    local r=self.Records[model];if not r then return end
    if r.Cue then r.Cue:Finish() end;self:ReleaseBar(r)
    for _,old in ipairs(r.Hidden) do if old.Part.Parent and r.Humanoid.Health>0 then old.Part.LocalTransparencyModifier=old.Alpha end end
    r.Art:Destroy();self.Records[model]=nil
end
function Enemies.Build(self: any,model: Model,root: BasePart,humanoid: Humanoid,tier: number): any
    local spec=A.Profiles[tier];if not spec then return nil end
    local art=Instance.new("Model");art.Name="Local silhouette · "..spec.Name;art.Parent=self.Service.Folder
    local r: any={Art=art,Parts={},Hidden={},Root=root,Humanoid=humanoid,Model=model,Spec=spec,Tier=tier,LastHealth=humanoid.Health,Attack=0,HitAt=-math.huge}
    local scale,width=spec.Scale,spec.Width
    local function geometry(name: string,x: number?,y: number?): Vector3
        local g=A.Geometry[name];return Vector3.new(g[1]*(x or 1),g[2]*(y or 1),g[3])
    end
    local function piece(name: string,size: Vector3,at: Vector3,color: Color3,roll: number?)
        if #r.Parts>=A.MaxParts then return end
        local p=Instance.new("Part");p.Name=name;p.Size=size;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
        p.Material=Enum.Material.SmoothPlastic;p.Color=color;p.Parent=art
        table.insert(r.Parts,{Part=p,Offset=CFrame.new(at)*CFrame.Angles(0,0,math.rad(roll or 0))})
    end
    local feet=A.GroundOffset;local body=feet+2.4*scale
    piece("Coat",geometry("Coat",width,scale),Vector3.new(0,body,0),spec.Color)
    for _,side in ipairs({-1,1}) do
        piece("Sleeve",geometry("Sleeve",width,scale),Vector3.new(side*1.5*width,body-0.1,0),spec.Color,side*8)
        piece("Boot",geometry("Boot",1,scale),Vector3.new(side*0.55,feet+0.6*scale,0),T.Colors.Iron)
    end
    local top=body+2.2*scale
    piece("Unmarked mask",geometry("Mask",width,scale),Vector3.new(0,top,0),spec.Mask)
    if spec.Motif=="Hat" then
        piece("Hat brim",geometry("Brim"),Vector3.new(0,top+0.9*scale,0),T.Colors.Iron)
        piece("Hat crown",geometry("Crown"),Vector3.new(0,top+1.35*scale,0),T.Colors.Iron)
    elseif spec.Motif=="Beast" then
        for _,side in ipairs({-1,1}) do piece("Angular ear",geometry("Ear"),Vector3.new(side*0.7,top+0.7,0),spec.Mask,side*25) end
    elseif spec.Motif=="Veil" then
        piece("Long veil",geometry("Veil",width,scale),Vector3.new(0,body+0.4,0.8),spec.Color)
    else
        for _,side in ipairs({-1,1}) do piece("Bound arch",geometry("Arch",1,scale),Vector3.new(side*1.7*width,body,0.8),spec.Mask) end
        piece("Arch lintel",geometry("Lintel",width),Vector3.new(0,body+2*scale,0.8),spec.Mask)
    end
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
            table.insert(r.Hidden,{Part=part,Alpha=part.LocalTransparencyModifier});part.LocalTransparencyModifier=1
        end
    end
    self.Records[model]=r
    local seen=self.Seen[model] or {};self.Seen[model]=seen;r.Phase=seen.Phase
    if not seen.Intro and tier<=2 and os.clock()>=self.IntroAt then
        seen.Intro=true;self.IntroAt=os.clock()+A.IntroGap
        if self.Audio then self.Audio(A.Sound.Intro) end
        if self.Notice then self.Notice(spec.Name.." · Sequence "..tier) end
    end
    return r
end
function Enemies.Warning(self: any,r: any,now: number)
    if r.Humanoid.Health<=0 then if r.Cue then r.Cue:Finish();r.Cue=nil end;return end
    local threat=r.Model:GetAttribute("VisualThreatUserId")
    local player=type(threat)=="number" and Players:GetPlayerByUserId(threat)
    local target=player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local due=nil;local kind="Melee"
    if target and target:IsA("BasePart") then
        local distance=(target.Position-r.Root.Position).Magnitude
        local melee=r.Model:GetAttribute("VisualMeleeDue")
        if type(melee)=="number" and melee>now and melee-now<=A.WarningLead and distance<=self.Runtime.NPCAttackRange then due=melee end
        local spell=r.Model:GetAttribute("VisualSpellDue")
        if r.Model:GetAttribute("VisualSpellAllowed")==true and r.Tier<=6 and type(spell)=="number" and spell>now and spell-now<=A.WarningLead and distance<=self.Runtime.NPCSpellRange and (not due or spell<due) then due=spell;kind="Spell" end
    end
    if not due then if r.Cue then r.Cue:Finish();r.Cue=nil end;return end
    if r.Cue and r.Cue.Active and r.Due==due then return end
    if r.Cue then r.Cue:Finish() end
    local radius=if kind=="Melee" then self.Runtime.NPCAttackRange else A.SpellRadius
    local h=self.Service:Begin("Enemy telegraph",r.Root.Position,1,A.ThreatPriority,{Part=2})
    if not h then return end
    r.Cue=h;r.Due=due;r.WarningKind=kind;h.Duration=math.max(A.MinimumLife,due-now)
    local rim=h:Acquire("Part");local fill=h:Acquire("Part")
    for _,p in ipairs({rim,fill}) do p.Shape=Enum.PartType.Cylinder;p.Color=T.Colors.Danger;p.Material=Enum.Material.SmoothPlastic end
    h.Update=function()
        if not r.Model.Parent or r.Humanoid.Health<=0 then h:Finish();return end
        h.Position=r.Root.Position
        local t=math.clamp(1-(due-workspace:GetServerTimeNow())/A.WarningLead,0,1)
        local at=r.Root.Position+Vector3.yAxis*A.GroundOffset
        local frame=CFrame.new(at)*CFrame.Angles(0,0,math.pi/2)
        rim.Size=Vector3.new(A.GroundThickness,radius*2,radius*2);rim.CFrame=frame;rim.Transparency=A.WarningAlpha
        fill.Size=Vector3.new(A.GroundThickness,math.max(A.MinimumSize,radius*2*t),math.max(A.MinimumSize,radius*2*t));fill.CFrame=frame+Vector3.yAxis*A.GroundThickness;fill.Transparency=A.FillAlpha
    end
end
function Enemies.Step(self: any,dt: number)
    self.Elapsed+=dt;if self.Elapsed<A.Scan then return end;self.Elapsed=0
    local camera=workspace.CurrentCamera;if not camera then return end
    local now=workspace:GetServerTimeNow();local candidates={};local wanted={}
    for _,model in ipairs(Collection:GetTagged("Enemy")) do
        if model:IsA("Model") and not model:GetAttribute("VisualEcho") then
            local root=model.PrimaryPart;local hum=model:FindFirstChildOfClass("Humanoid")
            if root and hum and (hum.Health>0 or self.Records[model]) and self.Service:Visible(root.Position) then table.insert(candidates,{Model=model,Root=root,Humanoid=hum,Distance=(root.Position-camera.CFrame.Position).Magnitude}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local bars=0;local limit=if self.Service:Profile().Mobile then A.MobileBars else A.MaxBars
    for i,item in ipairs(candidates) do
        if i>A.Max then break end
        local model=item.Model;local r=self.Records[model]
        if not r then r=self:Build(model,item.Root,item.Humanoid,model:GetAttribute("VisualTier")) end
        if not r then continue end;wanted[model]=true
        if r.Humanoid.Health<r.LastHealth then r.HitAt=now end;r.LastHealth=r.Humanoid.Health
        local health=math.clamp(r.Humanoid.Health/math.max(1,r.Humanoid.MaxHealth),0,1)
        if health<=A.PhaseRatio and not r.Phase and r.Tier<=2 and health>0 then
            r.Phase=true;self.Seen[model].Phase=true
            if self.Audio then self.Audio(A.Sound.Phase) end
            self.Blocks:Compose({{Name="SigilStencil",Position=r.Root.Position,Palette="Apprentice",Options={Glyph="Seal",Scale=A.PhaseScale}}},1,A.PhasePriority,A.DeathTime)
            if self.Notice then self.Notice(r.Spec.Name.." · seal fractured") end
        end
        if health<=0 then
            if not r.DiedAt and self.Audio then self.Audio(A.Sound.Death) end
            r.DiedAt=r.DiedAt or now;self:ReleaseBar(r)
        end
        local deadFade=if r.DiedAt then math.clamp((now-r.DiedAt)/A.DeathTime,0,1) else 0
        local reduced=self.Service.ReducedMotion or self.Service.LowGraphics
        local rise=if reduced then 0 else math.sin(now/A.IdlePeriod*math.pi*2)*A.IdleRise
        local serial=model:GetAttribute("VisualAttackSerial") or 0
        if serial>r.Attack then
            r.Attack=serial
            if self.Audio then self.Audio(if model:GetAttribute("VisualAttackKind")=="Spell" then A.Sound.Spell else A.Sound.Melee) end
        end
        local attackAt=model:GetAttribute("VisualAttackAt")
        local attack=if type(attackAt)=="number" then math.clamp(1-(now-attackAt)/A.HitTime,0,1) else 0
        local hit=math.clamp(1-(now-r.HitAt)/A.HitTime,0,1)
        local frame=r.Root.CFrame*CFrame.new(0,rise,0)*CFrame.Angles(math.rad(if reduced then 0 else -attack*A.AttackLean+hit*A.HitLean),0,0)
        for _,part in ipairs(r.Parts) do part.Part.CFrame=frame*part.Offset;part.Part.Transparency=deadFade end
        self:Warning(r,now)
        if health>0 and item.Distance<=A.BarDistance and bars<limit then
            bars+=1;r.Bar=r.Bar or self:Bar()
            if r.Bar then
                r.Bar.Adornee=r.Root;r.Bar.StudsOffset=Vector3.yAxis*(r.Spec.Scale*5);r.Bar.Enabled=true
                r.Bar.Title.Text=(if r.Cue and r.Cue.Active then r.WarningKind.." · " else "")..r.Spec.Name.." · "..math.ceil(r.Humanoid.Health).."/"..math.ceil(r.Humanoid.MaxHealth)
                r.Bar.Track.Fill.Size=UDim2.fromScale(health,1)
            end
        else self:ReleaseBar(r) end
    end
    for model in pairs(self.Records) do if not wanted[model] then self:Clear(model) end end
end
function Enemies.Destroy(self: any)
    for model in pairs(self.Records) do self:Clear(model) end
    for _,bar in ipairs(self.Bars) do bar:Destroy() end;table.clear(self.Bars)
end
return Enemies
