--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Model=require(Shared.VisualModel)
local Kit=require(script.Parent.Kit)
local Hud={}
function Hud.new(parent: Instance,data: any,callbacks: any): any
    local self: any={Data=data,Callbacks=callbacks,Slots={},Bars={},State=nil,ReceivedAt=0,Collapsed=nil,Layout=nil}
    self.Root=Kit.New("Frame",parent,{Name="HUD",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=T.Layers.HUD})
    Kit.New("UIScale",self.Root,{Scale=T.Layout.Scale})
    self.Resources=Kit.Panel(self.Root,"Vitals")
    self.ResourceInner=Kit.New("Frame",self.Resources,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
    self.ResourcePadding=Kit.Padding(self.ResourceInner,T.Layout.Desktop.PanelPad)
    self.ResourceList=Kit.List(self.ResourceInner,T.Layout.Desktop.ResourceGap)
    for index,spec in ipairs({{Key="Health",Name="HP",Glyph="Heart"},{Key="Spirituality",Name="Spirit",Glyph="Star"},{Key="Sanity",Name="Sanity",Glyph="Eye"}}) do
        local row=Kit.New("Frame",self.ResourceInner,{Name=spec.Key,BackgroundTransparency=1,LayoutOrder=index})
        local icon=Kit.Glyph(row,spec.Glyph,T.Layout.Resource.IconX,T.Colors[spec.Key])
        local text=Kit.Text(row,spec.Name,T.Type.Small,T.Fonts.Number)
        local number=Kit.Text(row,"—",T.Type.Number,T.Fonts.Number);number.TextXAlignment=Enum.TextXAlignment.Right
        local track=Kit.New("Frame",row,{BackgroundColor3=T.Colors.Slate,BorderSizePixel=0})
        local fill=Kit.New("Frame",track,{Size=UDim2.fromScale(0,1),BackgroundColor3=T.Colors[spec.Key],BorderSizePixel=0})
        Kit.Corner(track,T.Style.FillCorner);Kit.Corner(fill,T.Style.FillCorner)
        self.Bars[spec.Key]={Row=row,Icon=icon,Text=text,Number=number,Track=track,Fill=fill,Spec=spec}
    end
    self.Wordmark=Kit.Text(self.Root,"M Y S T E R I E S",T.Type.Heading,T.Fonts.Title);self.Wordmark.TextXAlignment=Enum.TextXAlignment.Center
    self.Pathway=Kit.Panel(self.Root,"Pathway")
    self.PathTitle=Kit.Text(self.Pathway,"Uninitiated",T.Type.Heading,T.Fonts.Heading)
    self.PathTitle.TextScaled=true
    Kit.New("UITextSizeConstraint",self.PathTitle,{MinTextSize=T.Type.Micro,MaxTextSize=T.Type.Heading})
    self.Digestion=Kit.Text(self.Pathway,"Digestion 0%",T.Type.Small,T.Fonts.Number)
    self.DigestionTrack=Kit.New("Frame",self.Pathway,{BorderSizePixel=0,BackgroundColor3=T.Colors.Slate})
    self.DigestionFill=Kit.New("Frame",self.DigestionTrack,{BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,Size=UDim2.fromScale(0,1)})
    Kit.Corner(self.DigestionTrack,T.Style.FillCorner);Kit.Corner(self.DigestionFill,T.Style.FillCorner)
    self.Objective=Kit.Text(self.Pathway,"Choose your first potion in the journal.",T.Type.Small)
    self.Objective.TextYAlignment=Enum.TextYAlignment.Top
    self.Collapse=Kit.Button(self.Pathway,T.Style.DisclosureOpen,function()
        if not self.Layout then return end
        if not self.Layout.CanExpand then callbacks.Journal("Pathway");return end
        self.Collapsed=not self.Collapsed;self:Resize(self.Layout)
    end)
    self.Collapse.BackgroundTransparency=1
    self.Journal=Kit.Button(self.Root,"Journal [B]",function() callbacks.Journal("Journal") end)
    self.Strike=Kit.Button(self.Root,"Strike",function() callbacks.Melee() end)
    self.Hotbar=Kit.Panel(self.Root,"AbilityHotbar")
    self.Cards=Kit.New("Frame",self.Hotbar,{BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
    self.CardPadding=Kit.Padding(self.Cards,T.Layout.Desktop.BarPad)
    self.CardList=Kit.List(self.Cards,T.Layout.Desktop.SlotGap,true)
    self.Tooltip=Kit.Panel(self.Root,"AbilityTooltip");self.Tooltip.Visible=false
    self.TooltipText=Kit.Text(self.Tooltip,"",T.Type.Small);self.TooltipText.Size=UDim2.new(1,-T.Layout.Modal.Gap*2,1,0);self.TooltipText.Position=UDim2.fromOffset(T.Layout.Modal.Gap,0)
    for i=1,T.Layout.Hotbar.Slots do
        local card=Kit.New("Frame",self.Cards,{Name="Slot"..i,BackgroundTransparency=1,LayoutOrder=i})
        local face=Kit.Button(card,"",function() callbacks.Cast(i) end)
        face.Name="Ability";Kit.New("UIAspectRatioConstraint",face,{AspectRatio=1})
        local glyph=Kit.New("Frame",face,{Name="Icon",BackgroundTransparency=1})
        local seal=Kit.New("Frame",face,{Name="VacantSeal",BackgroundTransparency=1,Size=UDim2.fromScale(1,1)})
        local emptyGlyph=Kit.Glyph(seal,"Seal",T.Layout.Desktop.Slot*T.Layout.Hotbar.SealSize,T.Colors.Muted)
        emptyGlyph.AnchorPoint=Vector2.new(0.5,0.5);emptyGlyph.Position=UDim2.fromScale(0.5,0.5)
        local dashes={}
        for edge=1,4 do
            for dash=1,T.Layout.Hotbar.DashedCount do
                local p=T.Layout.Hotbar.DashInset+(dash-1)*(1-T.Layout.Hotbar.DashInset*2)/(T.Layout.Hotbar.DashedCount-1)
                local horizontal=edge<=2
                local line=Kit.New("Frame",seal,{BorderSizePixel=0,BackgroundColor3=T.Colors.Muted,BackgroundTransparency=T.Style.SealAlpha,
                    AnchorPoint=Vector2.new(0.5,0.5),Position=if horizontal then UDim2.fromScale(p,if edge==1 then 0 else 1) else UDim2.fromScale(if edge==3 then 0 else 1,p),
                    Size=if horizontal then UDim2.new(T.Layout.Hotbar.DashLength,0,0,T.Layout.Hotbar.DashThickness) else UDim2.new(0,T.Layout.Hotbar.DashThickness,T.Layout.Hotbar.DashLength,0)})
                table.insert(dashes,line)
            end
        end
        local badge=Kit.Panel(face,"KeyBadge");local key=Kit.Text(badge,T.Input.KeyNames[i],T.Type.Micro,T.Fonts.Number);key.Size=UDim2.fromScale(1,1);key.TextXAlignment=Enum.TextXAlignment.Center
        local cost=Kit.Text(card,"",T.Type.Micro,T.Fonts.Number);cost.TextColor3=T.Colors.Spirituality;cost.TextXAlignment=Enum.TextXAlignment.Center
        local countdown=Kit.Text(face,"",T.Type.Number,T.Fonts.Number);countdown.AnchorPoint=Vector2.new(0.5,0.5);countdown.Position=UDim2.fromScale(0.5,0.5);countdown.BackgroundColor3=T.Colors.Ink;countdown.BackgroundTransparency=T.Style.PanelFade;countdown.Visible=false
        local segments={}
        for segment=1,T.Layout.Hotbar.Segments do
            local angle=(segment-1)/T.Layout.Hotbar.Segments*math.pi*2-math.pi/2
            table.insert(segments,Kit.New("Frame",face,{Name="CooldownSegment",BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5+math.cos(angle)*T.Layout.Hotbar.RingRadius,0.5+math.sin(angle)*T.Layout.Hotbar.RingRadius),
                Size=UDim2.fromOffset(T.Layout.Hotbar.SegmentWidth,T.Layout.Hotbar.SegmentHeight),Rotation=math.deg(angle)+90,Visible=false}))
        end
        self.Slots[i]={Card=card,Face=face,Glyph=glyph,Seal=seal,EmptyGlyph=emptyGlyph,KeyBadge=badge,Key=key,Cost=cost,Countdown=countdown,Segments=segments,Id=false}
        local function show()
            if callbacks.Touch then return end
            local id=self.State and self.State.Loadout and self.State.Loadout[i]
            local a=id and data.Abilities[id]
            if a then self.TooltipText.Text=a.Name.." · "..tostring(a.SpiritualityCost).." spirituality";self.Tooltip.Visible=true end
        end
        face.MouseEnter:Connect(show);face.SelectionGained:Connect(show)
        face.MouseLeave:Connect(function() self.Tooltip.Visible=false end);face.SelectionLost:Connect(function() self.Tooltip.Visible=false end)
    end
    self.Cast=Kit.Panel(self.Root,"CastFeedback");self.Cast.Visible=false
    self.CastText=Kit.Text(self.Cast,"",T.Type.Small,T.Fonts.Number);self.CastText.Size=UDim2.fromScale(1,1);self.CastText.TextXAlignment=Enum.TextXAlignment.Center
    self.CastTrack=Kit.New("Frame",self.Cast,{BorderSizePixel=0,BackgroundColor3=T.Colors.Spirituality,AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1)})
    self.Reticle=Kit.Glyph(self.Root,"Seal",T.Layout.Cast.Reticle,T.Colors.Muted)
    self.Reticle.AnchorPoint=Vector2.new(0.5,0.5);self.Reticle.Position=UDim2.fromScale(0.5,0.5);self.Reticle.Visible=false
    return setmetatable(self,{__index=Hud})
end
function Hud.Resize(self: any,layout: any)
    self.Layout=layout
    if self.Collapsed==nil then self.Collapsed=layout.DefaultCollapsed end
    local p,l=layout.Profile,T.Layout
    Kit.Rect(self.Resources,layout.Resources);Kit.Rect(self.Wordmark,layout.Wordmark);Kit.Rect(self.Journal,layout.Journal);Kit.Rect(self.Hotbar,layout.Hotbar);Kit.Rect(self.Cast,layout.Cast)
    self.Wordmark.TextSize=p.HeadingSize
    self.Journal.Text=if layout.Name=="Phone" or layout.Name=="Landscape" then "B" else "Journal [B]"
    self.ResourcePadding.PaddingTop=UDim.new(0,p.PanelPad);self.ResourcePadding.PaddingBottom=UDim.new(0,p.PanelPad)
    self.ResourcePadding.PaddingLeft=UDim.new(0,p.PanelPad);self.ResourcePadding.PaddingRight=UDim.new(0,p.PanelPad)
    self.ResourceList.Padding=UDim.new(0,p.ResourceGap)
    local rowHeight=(p.Resources[2]-p.PanelPad*2-p.ResourceGap*2)/3
    for _,bar in pairs(self.Bars) do
        bar.Row.Size=UDim2.new(1,0,0,rowHeight)
        bar.Icon.Size=UDim2.fromOffset(p.ResourceIcon,p.ResourceIcon);bar.Icon.Position=UDim2.fromOffset(0,0)
        bar.Text.Position=UDim2.fromOffset(p.ResourceIcon+p.ResourceGap,0);bar.Text.Size=UDim2.new(1,-l.Resource.NumberWidth-p.ResourceIcon,0,rowHeight-l.Resource.TrackHeight)
        bar.Text.TextSize=T.Type.Micro;bar.Text.Visible=layout.Name=="Desktop"
        bar.Number.Size=UDim2.new(1,-p.ResourceIcon-p.ResourceGap,0,rowHeight-l.Resource.TrackHeight);bar.Number.Position=UDim2.fromOffset(p.ResourceIcon+p.ResourceGap,0);bar.Number.TextSize=p.NumberSize
        bar.Track.Position=UDim2.new(0,p.ResourceIcon+p.ResourceGap,1,-l.Resource.TrackHeight);bar.Track.Size=UDim2.new(1,-p.ResourceIcon-p.ResourceGap,0,l.Resource.TrackHeight)
    end
    local height=if self.Collapsed or not layout.CanExpand then p.PathwayCollapsed else p.PathwayHeight
    self.Pathway.Position=UDim2.fromOffset(layout.Pathway.X,layout.Pathway.Y)
    Kit.Tween(self.Pathway,T.Timing.Collapse,{Size=UDim2.fromOffset(layout.Pathway.W,height)})
    self.PathTitle.Position=UDim2.fromOffset(l.Pathway.Pad,0);self.PathTitle.Size=UDim2.new(1,-l.Pathway.Pad-l.Pathway.Toggle,0,p.PathwayCollapsed)
    self.Collapse.Size=UDim2.fromOffset(l.Pathway.Toggle,l.Pathway.Toggle);self.Collapse.AnchorPoint=Vector2.new(1,0.5);self.Collapse.Position=UDim2.new(1,0,0,p.PathwayCollapsed/2)
    self.Collapse.Text=if self.Collapsed or not layout.CanExpand then T.Style.DisclosureClosed else T.Style.DisclosureOpen
    local expanded=not self.Collapsed and layout.CanExpand
    self.Digestion.Visible=expanded;self.DigestionTrack.Visible=expanded;self.Objective.Visible=expanded
    self.Digestion.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.HeadingHeight);self.Digestion.Size=UDim2.new(1,-l.Pathway.Pad*2,0,l.Pathway.SummaryHeight)
    self.DigestionTrack.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.HeadingHeight+l.Pathway.SummaryHeight);self.DigestionTrack.Size=UDim2.new(1,-l.Pathway.Pad*2,0,l.Pathway.TrackHeight)
    self.Objective.Position=UDim2.fromOffset(l.Pathway.Pad,l.Pathway.ObjectiveTop);self.Objective.Size=UDim2.new(1,-l.Pathway.Pad*2,0,p.PathwayHeight-l.Pathway.ObjectiveTop-l.Pathway.Pad);self.Objective.TextSize=T.Type.Small
    self.CardPadding.PaddingLeft=UDim.new(0,p.BarPad);self.CardPadding.PaddingRight=UDim.new(0,p.BarPad)
    self.CardPadding.PaddingTop=UDim.new(0,l.Hotbar.Top);self.CardPadding.PaddingBottom=UDim.new(0,0);self.CardList.Padding=UDim.new(0,p.SlotGap)
    for _,slot in ipairs(self.Slots) do
        slot.Card.Size=UDim2.fromOffset(p.Slot,p.HotbarHeight-l.Hotbar.Top)
        slot.Face.Size=UDim2.fromOffset(p.Slot,p.Slot)
        slot.Glyph.Size=UDim2.fromScale(l.Hotbar.GlyphFraction,l.Hotbar.GlyphFraction);slot.Glyph.AnchorPoint=Vector2.new(0.5,0.5);slot.Glyph.Position=UDim2.fromScale(0.5,0.5)
        slot.EmptyGlyph.Size=UDim2.fromOffset(p.Slot*l.Hotbar.SealSize,p.Slot*l.Hotbar.SealSize)
        slot.KeyBadge.Position=UDim2.fromOffset(l.Hotbar.KeyPad,l.Hotbar.KeyPad)
        local badge=if layout.Name=="Phone" or layout.Name=="Landscape" then l.Hotbar.KeyPhone else l.Hotbar.KeySize
        slot.KeyBadge.Size=UDim2.fromOffset(badge,badge)
        slot.Cost.Position=UDim2.fromOffset(0,p.Slot+l.Hotbar.CostPad);slot.Cost.Size=UDim2.fromOffset(p.Slot,l.Hotbar.CostHeight)
        slot.Countdown.Size=UDim2.fromOffset(p.Slot-l.Modal.Gap,l.Hotbar.CountdownHeight)
        slot.Id=false
    end
    self.Tooltip.Size=UDim2.fromOffset(math.min(l.Hotbar.TooltipWidth,layout.Width-p.Margin*2),l.Hotbar.TooltipHeight)
    self.Tooltip.AnchorPoint=Vector2.new(0.5,1);self.Tooltip.Position=UDim2.fromOffset(layout.Hotbar.X+layout.Hotbar.W/2,layout.Hotbar.Y-l.Hotbar.TooltipGap)
    self.Strike.Visible=self.Callbacks.Touch
    Kit.Rect(self.Strike,layout.Action)
    self:Render(self.State,self.ReceivedAt)
end
function Hud.Render(self: any,state: any,receivedAt: number)
    self.State=state;self.ReceivedAt=receivedAt
    if not state or not state.Ready then self.PathTitle.Text="Opening journal…";return end
    for key,bar in pairs(self.Bars) do
        local maximum=if key=="Sanity" then 100 else state["Max"..key]
        bar.Number.Text=string.format("%d / %d",math.ceil(state[key]),math.ceil(maximum))
        Kit.Tween(bar.Fill,T.Timing.Fill,{Size=UDim2.fromScale(math.clamp(state[key]/math.max(1,maximum),0,1),1)})
    end
    if state.PathwayId then
        local path=self.Data.Pathways[state.PathwayId];local seq=path.Sequences[state.Sequence]
        self.PathTitle.Text=path.Alias.." · "..tostring(state.Sequence).."  |  "..math.floor(state.Digestion).."%"
        self.Objective.Text=seq.ActingObjectives[1].Label
        self.Digestion.Text=seq.Name.." · digestion "..string.format("%.1f%%",state.Digestion)
        self.DigestionFill.BackgroundColor3=Kit.PathColor(state.PathwayId)
    else
        self.PathTitle.Text="Uninitiated"
        self.Digestion.Text="Choose a pathway"
        self.Objective.Text="Open the journal to drink your first potion."
    end
    Kit.Tween(self.DigestionFill,T.Timing.Fill,{Size=UDim2.fromScale(math.clamp(state.Digestion/100,0,1),1)})
    for i,slot in ipairs(self.Slots) do
        local id=state.Loadout[i];local a=id and self.Data.Abilities[id]
        if slot.Id~=id then
            slot.Id=id;Kit.Clear(slot.Glyph)
            slot.Seal.Visible=not a;slot.KeyBadge.Visible=a~=nil;slot.Cost.Text=if a then "✦ "..tostring(a.SpiritualityCost) else ""
            for _,child in ipairs(slot.Face:GetChildren()) do if child:IsA("UIStroke") then child.Transparency=if a then T.Style.BorderAlpha else 1 end end
            if a and self.Layout then
                local icon=Kit.Glyph(slot.Glyph,T.OperationGlyph[a.Operation.Kind] or "Seal",self.Layout.Profile.Slot*T.Layout.Hotbar.GlyphFraction,Kit.PathColor(a.PathwayId))
                icon.Size=UDim2.fromScale(1,1)
            end
        end
    end
    self:Step(os.clock())
end
function Hud.Step(self: any,now: number)
    local state=self.State
    if not state or not state.Ready then return end
    self.Reticle.Visible=self.Callbacks.TouchAim and self.Callbacks.TouchAim() or false
    local elapsed=now-self.ReceivedAt
    for _,slot in ipairs(self.Slots) do
        local a=slot.Id and self.Data.Abilities[slot.Id]
        local remaining=if a then Model.Cooldown(state,slot.Id,elapsed) else 0
        local n=if a then math.ceil(math.clamp(remaining/a.CooldownSeconds,0,1)*T.Layout.Hotbar.Segments) else 0
        slot.Countdown.Visible=remaining>0
        slot.Countdown.Text=if remaining>0 then string.format("%.1f",remaining) else ""
        for i,segment in ipairs(slot.Segments) do segment.Visible=i<=n end
    end
    local a=state.Casting and self.Data.Abilities[state.Casting]
    self.Cast.Visible=a~=nil
    if a then
        local remaining=math.max(0,(state.CastRemaining or a.CastTimeSeconds)-elapsed)
        self.CastText.Text=a.Name
        self.CastTrack.Size=UDim2.new(math.clamp(1-remaining/math.max(a.CastTimeSeconds,T.LegacyFX.MinBarFraction),0,1),0,0,T.Layout.Cast.Track)
    end
end
return Hud
