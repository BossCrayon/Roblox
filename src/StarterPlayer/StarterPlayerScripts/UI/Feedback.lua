--!strict
local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Kit=require(script.Parent.Kit)
local Feedback={}
function Feedback.new(parent: GuiObject,data: any,cinematic: (boolean)->()): any
    local self: any={SafeRoot=parent,Data=data,Cinematic=cinematic,State=nil,ReducedMotion=false,FlashTweens={},NoticeSerial=0,AdvanceSerial=0,Numbers={},Pool={},Layout=nil}
    self.Root=Kit.New("Frame",parent,{Name="Feedback",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=T.Layers.Feedback})
    self.Notice=Kit.New("CanvasGroup",self.Root,{Name="Notice",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Notice);Kit.Stroke(self.Notice)
    self.NoticeText=Kit.Text(self.Notice,"",T.Type.Number,T.Fonts.Number);self.NoticeText.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,1,0);self.NoticeText.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,0);self.NoticeText.TextXAlignment=Enum.TextXAlignment.Center
    self.Advance=Kit.New("CanvasGroup",self.Root,{Name="SequenceAdvance",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false});Kit.Corner(self.Advance);Kit.Stroke(self.Advance)
    self.AdvanceSmall=Kit.Text(self.Advance,"",T.Type.Small,T.Fonts.Number);self.AdvanceSmall.Size=UDim2.new(1,0,0,T.Feedback.SubtitleHeight);self.AdvanceSmall.TextXAlignment=Enum.TextXAlignment.Center
    self.AdvanceTitle=Kit.Text(self.Advance,"",T.Type.Title,T.Fonts.Title);self.AdvanceTitle.Size=UDim2.new(1,-T.Layout.Modal.BodyPad*2,0,T.Feedback.AdvanceTitleHeight);self.AdvanceTitle.Position=UDim2.fromOffset(T.Layout.Modal.BodyPad,T.Feedback.SubtitleHeight);self.AdvanceTitle.TextXAlignment=Enum.TextXAlignment.Center
    self.Acting=Kit.Text(self.Root,"",T.Type.Small,T.Fonts.Number);self.Acting.BackgroundColor3=T.Colors.Ink;self.Acting.BackgroundTransparency=0;self.Acting.Visible=false
    self.Acting.TextXAlignment=Enum.TextXAlignment.Center;Kit.Corner(self.Acting);Kit.Stroke(self.Acting,T.Colors.Gold,T.Style.BorderAlpha)
    self.SanityWarning=Kit.Text(self.Root,"",T.Type.Small,T.Fonts.Number);self.SanityWarning.BackgroundColor3=T.Colors.Ink;self.SanityWarning.BackgroundTransparency=0;self.SanityWarning.Visible=false
    self.SanityWarning.TextXAlignment=Enum.TextXAlignment.Center;self.SanityWarning.TextColor3=T.Colors.Danger;Kit.Corner(self.SanityWarning);Kit.Stroke(self.SanityWarning,T.Colors.Danger,T.Style.BorderAlpha)
    self.Vignette=Kit.New("Frame",self.Root,{Name="SanityVignette",Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
    self.Edges={}
    self.Flashes={}
    for index=1,4 do
        local horizontal=index<=2
        local pos=if index==1 then UDim2.fromScale(0,0) elseif index==2 then UDim2.fromScale(0,1) elseif index==3 then UDim2.fromScale(0,0) else UDim2.fromScale(1,0)
        local anchor=if index==2 then Vector2.new(0,1) elseif index==4 then Vector2.new(1,0) else Vector2.zero
        local size=if horizontal then UDim2.fromScale(1,T.Layout.Vignette.Thickness) else UDim2.fromScale(T.Layout.Vignette.Thickness,1)
        local rotation=if index==1 then 90 elseif index==2 then 270 elseif index==3 then 0 else 180
        for _,pair in ipairs({{Target=self.Edges,Color=T.Colors.Sanity},{Target=self.Flashes,Color=T.Colors.Hit}}) do
            local f=Kit.New("Frame",self.Vignette,{Size=size,Position=pos,AnchorPoint=anchor,BorderSizePixel=0,BackgroundColor3=pair.Color,BackgroundTransparency=1})
            Kit.New("UIGradient",f,{Rotation=rotation,Transparency=NumberSequence.new(0,1)})
            table.insert(pair.Target,f)
        end
    end
    local old=Lighting:FindFirstChild("MysteriesSanity")
    if old then old:Destroy() end
    self.Correction=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesSanity",Enabled=false})
    return setmetatable(self,{__index=Feedback})
end
function Feedback.Resize(self: any,layout: any)
    self.Layout=layout
    Kit.Rect(self.Notice,layout.Notice)
    Kit.Rect(self.Acting,{X=layout.Pathway.X,Y=layout.Pathway.Y+layout.Profile.PathwayCollapsed,W=layout.Pathway.W,H=T.Feedback.SubtitleHeight})
    Kit.Rect(self.SanityWarning,layout.Notice)
    local width=math.min(T.Layout.Advance.Width,layout.Width-layout.Profile.Margin*2)
    local x=(layout.Width-width)/2
    local top=T.Layout.Advance.Top
    if x<layout.Resources.X+layout.Resources.W and x+width>layout.Resources.X then top=math.max(top,layout.Resources.Y+layout.Resources.H+T.Layout.Modal.Gap) end
    Kit.Rect(self.Advance,{X=x,Y=top,W=width,H=T.Layout.Advance.Height})
    self.AdvanceTitle.TextSize=if layout.Name=="Phone" or layout.Name=="Landscape" then T.Feedback.AdvanceMobileTitle elseif layout.Name=="Tablet" then T.Feedback.AdvanceTabletTitle else T.Type.Title
end
function Feedback.Tell(self: any,text: string,rejected: boolean?)
    self.NoticeUntil=os.clock()+T.Timing.Notice+T.Timing.NoticeFade
    self.NoticeSerial+=1;local serial=self.NoticeSerial
    self.NoticeText.Text=text;self.NoticeText.TextColor3=if rejected then T.Colors.Danger else T.Colors.Text
    self.Notice.Visible=true;self.Notice.GroupTransparency=0
    if rejected then Kit.Sound(self.Root,"Reject") end
    task.delay(T.Timing.Notice,function()
        if serial~=self.NoticeSerial then return end
        local tween=Kit.Tween(self.Notice,T.Timing.NoticeFade,{GroupTransparency=1})
        tween.Completed:Once(function() if serial==self.NoticeSerial then self.Notice.Visible=false end end)
    end)
end
function Feedback.Flash(self: any)
    Kit.Sound(self.Root,"Hit")
    if self.ReducedMotion then return end
    local now=os.clock()
    if now-(self.LastFlash or -math.huge)<T.Visuals.FlashGap then return end
    self.LastFlash=now
    for _,tween in ipairs(self.FlashTweens) do tween:Cancel() end
    table.clear(self.FlashTweens)
    for _,f in ipairs(self.Flashes) do
        local tween=Kit.Tween(f,T.Timing.FlashIn,{BackgroundTransparency=1-math.min(T.Visuals.FlashOpacity,T.Layout.Vignette.FlashAlpha)})
        table.insert(self.FlashTweens,tween)
        tween.Completed:Once(function()
            if f.Parent and not self.ReducedMotion then table.insert(self.FlashTweens,Kit.Tween(f,T.Timing.FlashOut,{BackgroundTransparency=1})) end
        end)
    end
end
function Feedback.SetReducedMotion(self: any,reduced: boolean)
    self.ReducedMotion=reduced
    if reduced then
        for _,tween in ipairs(self.FlashTweens) do tween:Cancel() end
        table.clear(self.FlashTweens)
        for _,f in ipairs(self.Flashes) do f.BackgroundTransparency=1 end
    end
end
function Feedback.Sequence(self: any,state: any)
    self.AdvanceSerial+=1;local serial=self.AdvanceSerial
    local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
    Kit.Skin(self.Advance,state.PathwayId)
    local stroke=self.Advance:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color=Kit.PathColor(state.PathwayId) end
    self.AdvanceSmall.Text="SEQUENCE "..state.Sequence.." · "..string.upper(state.PathwayId)
    self.AdvanceSmall.TextColor3=Kit.PathColor(state.PathwayId);self.AdvanceTitle.Text=seq.Name
    self.Advance.Visible=true;self.Advance.GroupTransparency=1;self.Cinematic(true);Kit.Sound(self.Root,"Advance")
    Kit.Tween(self.Advance,T.Timing.AdvanceIn,{GroupTransparency=0})
    task.delay(T.Timing.AdvanceIn+T.Timing.AdvanceHold,function()
        if serial~=self.AdvanceSerial then return end
        local tween=Kit.Tween(self.Advance,T.Timing.AdvanceOut,{GroupTransparency=1})
        tween.Completed:Once(function()
            if serial==self.AdvanceSerial then self.Advance.Visible=false;self.Cinematic(false) end
        end)
    end)
end
function Feedback.Update(self: any,state: any)
    local previous=self.State
    self.State=state
    if not state or not state.Ready then return end
    if previous and previous.Ready then
        if state.Health<previous.Health then self:Flash() end
        if state.PathwayId==previous.PathwayId and state.Sequence==previous.Sequence and state.Digestion>previous.Digestion then
            self.Acting.Text=T.Ritual.DigestionText..string.format("%.1f%%",state.Digestion-previous.Digestion)
            local stroke=self.Acting:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color=Kit.PathColor(state.PathwayId) end
            self.ActingUntil=os.clock()+T.Ritual.DigestionTime
        end
        if state.PathwayId and (state.PathwayId~=previous.PathwayId or state.Sequence~=previous.Sequence) then self:Sequence(state) end
    end
    self.Correction.Enabled=state.Sanity<T.Layout.Vignette.Low or state.Mode~="Normal"
    self.Correction.TintColor=if state.Mode=="LostControl" then T.Colors.LostTint elseif state.Mode=="Madness" then T.Colors.MadnessTint else T.Colors.ClearTint
    self.Correction.Saturation=if state.Mode=="Normal" then T.Feedback.NormalSaturation else T.Feedback.MadnessSaturation
end
function Feedback.Damage(self: any,event: any)
    if event.Owner~=Players.LocalPlayer.UserId or #self.Numbers>=T.Layout.Damage.Max then return end
    local label: TextLabel=table.remove(self.Pool) or Kit.Text(self.Root,"",T.Type.Damage,T.Fonts.Number)
    label.BackgroundColor3=T.Colors.Ink;label.AnchorPoint=Vector2.new(0.5,0.5);label.TextXAlignment=Enum.TextXAlignment.Center
    label.Size=UDim2.fromOffset(T.Layout.Damage.Width,T.Layout.Damage.Height)
    if not label:FindFirstChildOfClass("UIStroke") then Kit.Corner(label);Kit.Stroke(label) end
    label.Text=tostring(math.max(0,math.round(event.Amount or 0)));label.Visible=true;label.BackgroundTransparency=0;label.TextTransparency=0
    table.insert(self.Numbers,{Label=label,Position=event.Position,Started=os.clock(),Index=#self.Numbers})
end
function Feedback.Step(self: any,now: number)
    local state=self.State
    self.Acting.Visible=now<(self.ActingUntil or 0) and not self.Advance.Visible
    self.SanityWarning.Visible=state~=nil and state.Ready and (state.Sanity<T.Layout.Vignette.Low or state.Mode~="Normal")
    if self.SanityWarning.Visible then
        self.SanityWarning.Text=if state.Mode=="LostControl" then T.Ritual.LostText elseif state.Mode=="Madness" then T.Ritual.MadnessText else T.Ritual.SanityText
    end
    local severity=if state and state.Ready then math.clamp((T.Layout.Vignette.Low-state.Sanity)/T.Layout.Vignette.Low,0,1) else 0
    local breath=if self.ReducedMotion then 1 else T.Layout.Vignette.BreathMin+(1-T.Layout.Vignette.BreathMin)*(math.sin(now*math.pi*2/T.Timing.SanityBreath)+1)/2
    for _,f in ipairs(self.Edges) do f.BackgroundTransparency=1-T.Layout.Vignette.MaxAlpha*severity*breath end
    local camera=workspace.CurrentCamera
    for i=#self.Numbers,1,-1 do
        local number=self.Numbers[i];local elapsed=now-number.Started
        if elapsed>=T.Timing.DamageLife then
            number.Label.Visible=false;table.insert(self.Pool,number.Label);table.remove(self.Numbers,i)
        elseif camera then
            local p,visible=camera:WorldToViewportPoint(number.Position+Vector3.new(0,T.Layout.Damage.OffsetStuds,0))
            local origin=self.SafeRoot.AbsolutePosition
            number.Label.Visible=visible and (number.Position-camera.CFrame.Position).Magnitude<=T.Visuals.MaxDistance
            number.Label.Position=UDim2.fromOffset(p.X-origin.X+(number.Index%3-1)*T.Feedback.DamageStagger,p.Y-origin.Y-T.Layout.Damage.Rise*math.min(1,elapsed/T.Timing.DamageRise))
            local alpha=math.clamp((elapsed-T.Timing.DamageRise)/math.max(T.LegacyFX.MinBarFraction,T.Timing.DamageLife-T.Timing.DamageRise),0,1)
            number.Label.TextTransparency=alpha;number.Label.BackgroundTransparency=alpha
        end
    end
end
return Feedback
