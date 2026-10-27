--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Model=require(Shared.VisualModel)
local Kit=require(script.Parent.Kit)
local Menus={}
function Menus.new(parent: Instance,data: any,callbacks: any): any
    local self: any={Data=data,Callbacks=callbacks,State=nil,Tab="Journal",SelectedSlot=1,View="Page",PreviewId=nil,Purchase=false,Waiting=false,Rows={},LastKey="",ReducedMotion=false,LowGraphics=false}
    self.Root=Kit.New("Frame",parent,{Name="Menus",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=false,ZIndex=T.Layers.Modal})
    self.Dim=Kit.New("TextButton",self.Root,{Name="Backdrop",Size=UDim2.fromScale(1,1),Text="",AutoButtonColor=false,BackgroundColor3=T.Colors.Ink,BackgroundTransparency=T.Style.ModalDim,BorderSizePixel=0})
    self.Dim.Activated:Connect(function() self:Close() end)
    self.Card=Kit.Panel(self.Root,"JournalCard");self.Card.Active=true;self.Card.BackgroundTransparency=0
    Kit.New("UIScale",self.Card,{Scale=T.Layout.Scale})
    self.Title=Kit.Text(self.Card,"BEYONDER JOURNAL",T.Type.Heading,T.Fonts.Title)
    self.Wallet=Kit.Text(self.Card,"",T.Type.Small,T.Fonts.Number);self.Wallet.TextColor3=T.Colors.Muted
    self.CloseButton=Kit.Button(self.Card,T.Style.CloseSymbol,function() self:Close() end)
    self.Navigation=Kit.New("Frame",self.Card,{BackgroundTransparency=1})
    self.NavLayout=Kit.List(self.Navigation,T.Layout.Modal.NavGap,true)
    self.Tabs={}
    for index,tab in ipairs({"Journal","Pathway","Inventory","Character"}) do
        local b=Kit.Button(self.Navigation,tab,function() self.Tab=tab;self.View="Page";self:Render() end);b.LayoutOrder=index
        self.Tabs[tab]=b
    end
    self.Scroll=Kit.New("ScrollingFrame",self.Card,{Name="Content",BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,
        ScrollBarImageColor3=T.Colors.Gold,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollingDirection=Enum.ScrollingDirection.Y})
    self.PreviewActions=Kit.New("Frame",self.Card,{Name="ConfirmationActions",BackgroundTransparency=1})
    self.Footer=Kit.Text(self.Card,"",T.Type.Micro,T.Fonts.Number);self.Footer.TextColor3=T.Colors.Muted
    return setmetatable(self,{__index=Menus})
end
function Menus.Open(self: any,tab: string?)
    self.Tab=tab or "Journal";self.View="Page";self.Purchase=false;self.Root.Visible=true;self.Waiting=false
    Kit.Sound(self.Root,"JournalOpen");self.Callbacks.Modal(true);self:Render()
end
function Menus.Close(self: any)
    if self.Purchase then self.Callbacks.Intent("CloseAltar",{}) end
    self.Root.Visible=false;self.Purchase=false;self.Waiting=false;self.Callbacks.Modal(false)
end
function Menus.Altar(self: any,expiresIn: number)
    self.Purchase=true;self.View="Preview";self.PreviewId=Model.NextPotion(self.State)
    self.ExpiresAt=os.clock()+expiresIn;self.Waiting=false;self.Root.Visible=true;self.Callbacks.Modal(true);self:Render()
end
function Menus.Preview(self: any,id: string)
    self.Purchase=false;self.View="Preview";self.PreviewId=id;self.PreviewOwned=self.State and self.State.Inventory[id];self.Waiting=false;self:Render()
end
function Menus.Resize(self: any,layout: any)
    self.Layout=layout
    local r=if self.View=="Preview" then layout.Confirm else layout.Modal
    Kit.Rect(self.Card,r)
    local m=T.Layout.Modal
    self.Title.Position=UDim2.fromOffset(m.BodyPad,0);self.Title.Size=UDim2.new(1,-m.Close-m.BodyPad*2,0,m.TitleHeight);self.Title.TextSize=layout.Profile.HeadingSize
    self.Wallet.Position=UDim2.fromOffset(m.BodyPad,m.TitleHeight);self.Wallet.Size=UDim2.new(1,-m.BodyPad*2,0,m.Header-m.TitleHeight)
    self.CloseButton.Size=UDim2.fromOffset(m.Close,m.Close);self.CloseButton.Position=UDim2.new(1,-m.Close,0,0)
    self.Navigation.Position=UDim2.fromOffset(m.BodyPad,m.Header);self.Navigation.Size=UDim2.new(1,-m.BodyPad*2,0,m.Tabs)
    for _,b in pairs(self.Tabs) do b.Size=UDim2.new(1/4,-m.NavGap,1,0);b.TextSize=layout.Profile.NumberSize end
    self.Navigation.Visible=self.View=="Page"
    self.PreviewActions.Visible=self.View=="Preview"
    self.PreviewActions.Size=UDim2.new(1,-m.BodyPad*2,0,m.ConfirmHeight);self.PreviewActions.Position=UDim2.new(0,m.BodyPad,1,-m.Footer-m.ConfirmHeight-m.Gap)
    local top=m.Header+(if self.View=="Page" then m.Tabs else 0)+m.Gap
    self.Scroll.Position=UDim2.fromOffset(m.BodyPad,top);self.Scroll.Size=UDim2.new(1,-m.BodyPad*2,1,-top-m.Footer-m.Gap-(if self.View=="Preview" then m.ConfirmHeight+m.Gap else 0))
    self.Footer.Position=UDim2.new(0,m.BodyPad,1,-m.Footer);self.Footer.Size=UDim2.new(1,-m.BodyPad*2,0,m.Footer)
end
function Menus.TextRow(self: any,text: string,heading: boolean?): TextLabel
    local l=Kit.Text(self.Scroll,text,if heading then self.Layout.Profile.HeadingSize else self.Layout.Profile.BodySize,if heading then T.Fonts.Heading else T.Fonts.Body)
    l.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,0);l.AutomaticSize=Enum.AutomaticSize.Y;l.TextYAlignment=Enum.TextYAlignment.Top
    return l
end
function Menus.ActionRow(self: any,text: string,callback: ()->()): TextButton
    local b=Kit.Button(self.Scroll,text,callback);b.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,T.Layout.Modal.ConfirmHeight)
    return b
end
function Menus.Render(self: any)
    if not self.Layout then return end
    self:Resize(self.Layout)
    local state=self.State
    local pathAccent=Kit.PathColor(state and state.PathwayId)
    Kit.Skin(self.Card,state and state.PathwayId)
    local oldScroll=self.Scroll.CanvasPosition
    Kit.Clear(self.PreviewActions);Kit.Clear(self.Scroll);Kit.List(self.Scroll,T.Layout.Modal.Gap);self.Rows={}
    self.Title.Text=if self.View=="Preview" then (if self.Purchase then "POTION ALTAR" else "POTION RITUAL") else "BEYONDER "..string.upper(self.Tab)
    self.Footer.Text=if self.View=="Preview" then "The altar seals only what you confirm." else "1–6 · skills  |  R · ultimate  |  Q · dash  |  Ctrl · walk/run  |  B · close"
    for name,b in pairs(self.Tabs) do
        local active=name==self.Tab
        b.BackgroundColor3=if active then T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend) else T.Colors.Slate
        b.TextColor3=if active then pathAccent else T.Colors.Text
        local stroke=b:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color=if active then pathAccent else T.Colors.Gold;stroke.Transparency=if active then T.Skins.ReadyAlpha else T.Style.BorderAlpha end
    end
    if not state or not state.Ready then self:TextRow("Your journal is opening…");return end
    if self.View=="Preview" then
        local view=Model.Potion(self.Data,state,self.PreviewId,self.Purchase)
        local potion=view.Potion
        if potion then
            local row=Kit.New("Frame",self.Scroll,{Size=UDim2.new(1,0,0,T.Layout.Modal.Bottle),BackgroundTransparency=1})
            Kit.Glyph(row,"Bottle",T.Layout.Modal.Bottle,Kit.PathColor(potion.PathwayId))
            local title=Kit.Text(row,potion.Name,self.Layout.Profile.HeadingSize,T.Fonts.Heading)
            title.Position=UDim2.fromOffset(T.Layout.Modal.Bottle+T.Layout.Modal.Gap,0);title.Size=UDim2.new(1,-T.Layout.Modal.Bottle-T.Layout.Modal.Gap,1,0)
            self:TextRow(potion.PathwayId.." · "..(if potion.TargetSequence==9 then "Uninitiated → Sequence 9" else "Sequence "..tostring(potion.RequiredSequence).." → Sequence "..tostring(potion.TargetSequence)))
            self:TextRow("Required digestion: "..potion.RequiredDigestion.."%  ·  Yours: "..string.format("%.1f%%",state.Digestion))
            self:TextRow("Owned: "..view.Owned..(if self.Purchase then "  ·  Price: "..view.Cost.." gold" else "  ·  Drinking consumes one potion"))
        end
        self.PreviewReason=self:TextRow(view.Reason)
        self.Confirm=Kit.Button(self.PreviewActions,if self.Purchase then "Confirm purchase" else "Confirm drinking",function()
            local current=Model.Potion(self.Data,self.State,self.PreviewId,self.Purchase)
            if not current.Allowed or self.Waiting or (self.Purchase and os.clock()>(self.ExpiresAt or 0)) then Kit.Sound(self.Root,"Reject");return end
            self.Waiting=true
            self.Callbacks.Intent(if self.Purchase then "Buy" else "Drink",if self.Purchase then {} else {Id=self.PreviewId})
            self.PendingSince=os.clock();self:UpdatePreview()
        end)
        local cancel=Kit.Button(self.PreviewActions,"Cancel",function()
            if self.Purchase then self:Close() else self.View="Page";self.Tab="Inventory";self:Render() end
        end)
        Kit.List(self.PreviewActions,T.Layout.Modal.Gap,true)
        self.Confirm.Size=UDim2.new(0.5,-T.Layout.Modal.Gap/2,1,0);cancel.Size=self.Confirm.Size
        self:UpdatePreview()
    elseif self.Tab=="Journal" then
        if type(state.RecordedPowerId)=="string" and (state.RecordedCharges or 0)>0 then
            self:TextRow("Recorded inscription: "..(T.AbilityUI.PowerNames[state.RecordedPowerId] or state.RecordedPowerId).." · "..state.RecordedCharges.." uses remaining.")
        end
        if type(state.StolenPower)=="string" then
            self:TextRow(T.AbilityUI.StoredPrefix..(T.AbilityUI.PowerNames[state.StolenPower] or state.StolenPower).." · cast Ability Theft again to release it.")
        end
        self:TextRow((T.Skins[state.PathwayId] or T.Skins.Seer).Name.." · The acting method",true)
        if state.PathwayId then
            local seq=self.Data.Pathways[state.PathwayId].Sequences[state.Sequence]
            self:TextRow(seq.ActingObjectives[1].Label)
            self:TextRow(string.format("Digestion %.1f%% · Acting progress %d",state.Digestion,state.ActingProgress))
        else self:TextRow("Choose one starter potion in Inventory. Its pathway becomes your permanent path.") end
        self:TextRow("Select a hotbar slot (1–6), then click an unlocked ability below to bind it.")
        local slots=Kit.New("ScrollingFrame",self.Scroll,{Name="SlotPicker",Size=UDim2.new(1,0,0,T.Layout.Modal.SlotHeight),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
            ScrollingDirection=Enum.ScrollingDirection.X,BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=T.Style.Stroke,ScrollBarImageColor3=T.Colors.Gold})
        Kit.List(slots,T.Layout.Modal.NavGap,true)
        for i=1,T.Layout.Hotbar.Slots do
            local keyLabel=T.Input.KeyNames[i] or tostring(i)
            local label=tostring(i).."·"..keyLabel
            local b=Kit.Button(slots,label,function() self.SelectedSlot=i;self:Render() end)
            b.Size=UDim2.fromOffset(math.max(T.Layout.Modal.SlotHeight,54),T.Layout.Modal.SlotHeight);b.LayoutOrder=i
            local active=self.SelectedSlot==i
            if active then
                b.BackgroundColor3=T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend)
                b.TextColor3=pathAccent
                local stroke=b:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color=pathAccent;stroke.Transparency=T.Skins.ReadyAlpha end
            elseif state.Loadout and state.Loadout[i] then
                b.TextColor3=T.Colors.Text
            else
                b.TextColor3=T.Colors.Muted
            end
        end
        for _,id in ipairs(Model.Unlocked(self.Data,state)) do
            local ability=self.Data.Abilities[id]
            local equippedSlots={}
            for slotIdx=1,T.Layout.Hotbar.Slots do
                if state.Loadout and state.Loadout[slotIdx]==id then
                    table.insert(equippedSlots,T.Input.KeyNames[slotIdx] or tostring(slotIdx))
                end
            end
            local isCurrentSlot=state.Loadout and state.Loadout[self.SelectedSlot]==id
            local b=self:ActionRow("",function() self.Callbacks.Intent("Equip",{Id=id,Slot=self.SelectedSlot}) end)
            b.Size=UDim2.new(1,-T.Layout.Modal.Gap,0,T.Layout.Modal.AbilityRow)
            if isCurrentSlot then
                b.BackgroundColor3=T.Colors.Ink:Lerp(pathAccent,T.Style.HoverBlend)
                local stroke=b:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color=pathAccent;stroke.Transparency=T.Skins.ReadyAlpha end
            end
            local glyph=Kit.Glyph(b,Kit.AbilityGlyph(ability),T.Layout.Modal.Icon,Kit.PathColor(ability.PathwayId))
            glyph.Position=UDim2.fromOffset(T.Layout.Modal.Gap,(T.Layout.Modal.AbilityRow-T.Layout.Modal.Icon)/2)
            local x=T.Layout.Modal.Icon+T.Layout.Modal.Gap*2
            local titleStr=ability.Name..(if #equippedSlots>0 then "  ·  Equipped ["..table.concat(equippedSlots,",").."]" else "")
            local text=Kit.Text(b,titleStr,self.Layout.Profile.BodySize,T.Fonts.Heading)
            text.Position=UDim2.fromOffset(x,4);text.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,24)
            if #equippedSlots>0 then text.TextColor3=pathAccent end
            local desc=Kit.Text(b,ability.Description or "",T.Type.Micro,T.Fonts.Body)
            desc.Position=UDim2.fromOffset(x,28);desc.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,28);desc.TextColor3=T.Colors.Text
            local info=Kit.Text(b,"Seq "..ability.UnlockSequence.." · "..ability.SpiritualityCost.." spirit · "..ability.CooldownSeconds.."s CD · Target: "..ability.Target,T.Type.Micro,T.Fonts.Number)
            info.Position=UDim2.new(0,x,1,-T.Layout.Modal.Footer+4);info.Size=UDim2.new(1,-x-T.Layout.Modal.Gap,0,T.Layout.Modal.Footer-4);info.TextColor3=T.Colors.Muted
        end
        self:ActionRow("Reduced motion: "..(if self.ReducedMotion then "on" else "off"),function()
            self.ReducedMotion=not self.ReducedMotion;self.Callbacks.ReducedMotion(self.ReducedMotion);self:Render()
        end)
        self:ActionRow("Low graphics: "..(if self.LowGraphics then "on" else "off"),function()
            self.LowGraphics=not self.LowGraphics
            if self.Callbacks.LowGraphics then self.Callbacks.LowGraphics(self.LowGraphics) end
            self:Render()
        end)
    elseif self.Tab=="Character" then
        local race=self.Data.Races.ById[state.RaceId or "Human"]
        self:TextRow(race.Name.." · Ancestry",true)
        self:TextRow(race.Description)
        self:TextRow("Sequence, pathway and ancestry determine these stats. Numerical bonuses are game balance.")
        for _,stat in ipairs({"Health","Spirituality","Sanity","Strength","Agility","Perception","Intuition","Resistance","SpiritualityRegen"}) do
            self:TextRow(stat..": "..tostring(state.Stats and state.Stats[stat] or "—"))
        end
        self:TextRow("Ancestry passives",true)
        local keys={};for stat in pairs(race.Multipliers) do table.insert(keys,stat) end;table.sort(keys)
        for _,stat in ipairs(keys) do self:TextRow(string.format("%s: %+.0f%%",stat,(race.Multipliers[stat]-1)*100)) end
        if #keys==0 then self:TextRow("Balanced base attributes; no stat penalties.") end
        self:TextRow(race.Skill.." [G]",true)
        self:TextRow("Cooldown remaining: "..math.ceil((state.Cooldowns or {}).RacialSkill or 0).."s")
        self:TextRow(race.Detail.." · "..race.Cost.." spirituality · "..race.Cooldown.."s cooldown")
        self:ActionRow("Use "..race.Skill.." [G]",function() self.Callbacks.Intent("RacialSkill",{}) end)
        if not state.RaceChosen then
            self:TextRow("Choose ancestry once · permanent after confirmation",true)
            for _,id in ipairs(self.Data.Races.Order) do
                local option=self.Data.Races.ById[id]
                self:TextRow(option.Name..": "..option.Description.." Special: "..option.Detail)
                local label=if self.PendingRace==id then "Confirm permanent choice: "..option.Name else "Choose "..option.Name
                self:ActionRow(label,function()
                    if self.PendingRace==id then self.Callbacks.Intent("ChooseRace",{Id=id});self.PendingRace=nil
                    else self.PendingRace=id;self:Render() end
                end)
            end
        end
    elseif self.Tab=="Pathway" then
        if state.PathwayId then
            local path=self.Data.Pathways[state.PathwayId];local seq=path.Sequences[state.Sequence]
            self:TextRow(path.Name.." / "..path.Alias,true);self:TextRow("Sequence "..state.Sequence.." — "..seq.Name,true)
            self:TextRow(seq.ActingObjectives[1].Label)
            local ult=Model.Ultimate(self.Data,state,0)
            self:TextRow("Mythical Creature Form ["..T.Input.UltimateName.."] — "..ult.Name,true)
            if not ult.Unlocked then
                self:TextRow("Locked (Sequences 9–5) · Unlocks Incomplete Saint form at Sequence 4 and Complete Angel form at Sequence 2.")
            elseif ult.Stage=="Incomplete" then
                self:TextRow(ult.Title.." (Sequences 4–3) · "..tostring(ult.Cost).." spirit · "..string.format("%.0fs",ult.Duration).." duration · Continuous sanity strain while manifested.")
            else
                self:TextRow(ult.Title.." (Sequences 2–1) · "..tostring(ult.Cost).." spirit · "..string.format("%.0fs",ult.Duration).." duration · Stable Angelic manifestation.")
            end
            if seq.PassiveTraits and #seq.PassiveTraits>0 then
                self:TextRow("Sequence passives",true)
                for _,trait in ipairs(seq.PassiveTraits) do
                    self:TextRow(if type(trait)=="string" then trait else tostring(trait.Name).." — "..tostring(trait.Description))
                end
            end
            self:TextRow("Attributes",true)
            for _,key in ipairs({"Health","Spirituality","Strength","Agility","Perception","Intuition","Resistance"}) do
                self:TextRow(key.."   "..tostring(seq.BaseStats[key]))
            end
            self:TextRow("Earlier sequence abilities remain retained in your journal.")
        else
            self:TextRow("Three paths into the unknown",true)
            for _,id in ipairs({"Seer","Marauder","Apprentice"}) do
                local path=self.Data.Pathways[id]
                self:TextRow(path.Name.." / "..path.Alias,true)
                self:TextRow("Begins at Sequence 9: "..path.Sequences[9].Name)
            end
            self:ActionRow("Choose a starter potion",function() self.Tab="Inventory";self:Render() end)
        end
    else
        self:TextRow("Potion inventory",true)
        local ids={}
        for id,n in pairs(state.Inventory) do if n>0 and self.Data.Potions.ById[id] then table.insert(ids,id) end end
        table.sort(ids)
        for _,id in ipairs(ids) do
            local potion=self.Data.Potions.ById[id]
            self:ActionRow(potion.Name.."  ×"..state.Inventory[id],function() self:Preview(id) end)
        end
        if #ids==0 then self:TextRow("No potions carried. Visit the Potion Altar for your next formula.") end
        self:TextRow("The Potion Altar exchanges earned gold for your next potion. Stabilization restores sanity at a digestion cost.")
    end
    task.defer(function() if self.Scroll.Parent then self.Scroll.CanvasPosition=oldScroll end end)
end
function Menus.UpdatePreview(self: any)
    if self.View~="Preview" or not self.Confirm or not self.Confirm.Parent then return end
    local view=Model.Potion(self.Data,self.State,self.PreviewId,self.Purchase)
    local expired=self.Purchase and os.clock()>(self.ExpiresAt or 0)
    local allowed=view.Allowed and not expired and not self.Waiting
    self.Confirm.Text=if self.Waiting then "Confirming…" elseif self.Purchase then "Confirm · "..tostring(self.Data.Runtime.NextPotionGoldCost).." gold" else "Drink potion"
    self.Confirm.TextColor3=if allowed then T.Colors.Text else T.Colors.Muted
    self.Confirm.Interactable=allowed
    self.PreviewReason.Text=if expired then "The altar invitation has expired. Approach it again." else view.Reason
end
function Menus.Update(self: any,state: any)
    self.State=state
    if not state or not state.Ready then return end
    self.Wallet.Text="Gold "..state.Gold.."   ·   Wish credits "..state.WishCredits
    local inventory={}
    for id,n in pairs(state.Inventory) do table.insert(inventory,id..":"..n) end
    table.sort(inventory)
    local loadout={}
    for i=1,T.Layout.Hotbar.Slots do loadout[i]=state.Loadout[i] or "-" end
    local keys={tostring(state.PathwayId),tostring(state.Sequence),table.concat(inventory,","),table.concat(loadout,"|"),
        tostring(state.RecordedPowerId),tostring(state.RecordedCharges),tostring(state.StolenPower),tostring(state.Digestion),tostring(state.ActingProgress),
        tostring(state.UltimateStage),tostring(state.RaceId),tostring(state.RaceChosen),if self.Tab=="Character" then tostring(math.ceil((state.Cooldowns or {}).RacialSkill or 0)) else ""}
    local key=table.concat(keys,";")
    if self.Root.Visible then
        if self.View=="Preview" then
            self:UpdatePreview()
            if self.Waiting and not self.Purchase and state.Inventory[self.PreviewId]~=(self.PreviewOwned or state.Inventory[self.PreviewId]) then self:Close() end
        elseif key~=self.LastKey then self:Render() end
    end
    self.LastKey=key
end
function Menus.Step(self: any,now: number)
    if self.Root.Visible and self.View=="Preview" then
        self:UpdatePreview()
        if self.Waiting and self.Purchase and now-(self.PendingSince or now)>T.Timing.PurchaseResponseTimeout then
            self.Waiting=false;self.ExpiresAt=now-T.LegacyFX.MinBarFraction;self:UpdatePreview()
        end
        if self.Waiting and not self.Purchase and now-(self.PendingSince or now)>T.Timing.AltarClientTimeout then
            self.Waiting=false;self:UpdatePreview()
        end
    end
end
return Menus
