--!strict
-- Private sensing targets are granted by the server. No discovery/raycast runs here.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Root=require(script.Parent.Choreography).Root
local Status={}
function Status.new(service: any,clock: ()->number,blocks: any?): any
    return setmetatable({Service=service,Clock=clock,Entries={},Blocks=blocks,Records={},GuiPool={},Widgets=0,Gates={},Echoes={},LastRevision=0,RecordSerial=0},{__index=Status})
end
function Status.Reveal(self: any,event: any,pathway: string)
    local life=math.clamp((event.ExpiresAt or 0)-self.Clock(),0,C.Protocol.RevealLife)
    if life<=0 then return end
    local palette=C.Palettes[pathway]
    local count=0
    for target,entry in pairs(self.Entries) do
        if not entry.Active then self.Entries[target]=nil else count+=1 end
    end
    for _,item in ipairs(event.Targets) do
        local target=item.Target
        if typeof(target)~="Instance" or not target.Parent or not self.Service:Visible(item.Position) then continue end
        local previous=self.Entries[target]
        if previous and previous.Active then previous.Age=0;previous.Duration=life;continue end
        if count>=C.Protocol.MaxStatuses then break end
        local h=self.Service:Begin("PrivateReveal",item.Position,1,C.Ability.RevealPriority,{Highlight=1})
        if not h then continue end
        count+=1;self.Entries[target]=h;h.Duration=life
        local highlight=h:Acquire("Highlight")
        highlight.Adornee=target;highlight.FillColor=palette.Primary;highlight.OutlineColor=palette.Accent
        highlight.FillTransparency=C.Ability.RevealFill;highlight.OutlineTransparency=C.Ability.RevealOutline
        h.Update=function(_dt: number,_age: number,t: number)
            if not target.Parent then h:Finish();return end
            if target:IsA("BasePart") then h.Position=target.Position
            elseif target:IsA("Model") then
                local root=target.PrimaryPart or target:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then h.Position=root.Position end
            end
            highlight.FillTransparency=C.Ability.RevealFill+(1-C.Ability.RevealFill)*t
            highlight.OutlineTransparency=C.Ability.RevealOutline+(1-C.Ability.RevealOutline)*t
        end
    end
end
function Status.Step(self: any)
    self:Reconcile()
    for target,entry in pairs(self.Entries) do if not entry.Active then self.Entries[target]=nil end end
end
function Status.Clear(self: any)
    for _,entry in pairs(self.Entries) do entry:Finish() end;table.clear(self.Entries)
    for _,record in pairs(self.Records) do self:ReleaseBadge(record) end;table.clear(self.Records)
    for owner in pairs(self.Gates) do self:RemoveGates(owner) end
    for _,echo in pairs(self.Echoes) do self:RestoreEcho(echo) end;table.clear(self.Echoes)
end
function Status.Badge(self: any): any
    local pooled=table.remove(self.GuiPool)
    if pooled then return pooled end
    if self.Widgets>=T.StatusUI.Max then return nil end
    self.Widgets+=1
    local gui=Instance.new("BillboardGui");gui.Name="MysteriesStatus";gui.Size=UDim2.fromOffset(T.StatusUI.Width,T.StatusUI.Height)
    gui.StudsOffset=Vector3.new(0,T.StatusUI.OffsetStuds,0);gui.AlwaysOnTop=false;gui.MaxDistance=T.StatusUI.Distance
    local label=Instance.new("TextLabel");label.Name="Status";label.Size=UDim2.fromScale(1,1)
    label.BackgroundColor3=T.Colors.Ink;label.BackgroundTransparency=T.StatusUI.BackgroundAlpha;label.BorderSizePixel=0
    label.TextColor3=T.Colors.Text;label.Font=T.Fonts.Number;label.TextSize=T.StatusUI.TextSize;label.TextTruncate=Enum.TextTruncate.AtEnd
    label.Parent=gui;gui.Parent=self.Service.Folder
    return gui
end
function Status.ReleaseBadge(self: any,record: any)
    if record.Widget then record.Widget.Enabled=false;record.Widget.Adornee=nil;table.insert(self.GuiPool,record.Widget);record.Widget=nil end
end
function Status.Event(self: any,e: any,localId: number): boolean
    if typeof(e.Target)~="Instance" or not C.Status.Labels[e.StatusId] or not C.Palettes[e.PathwayId] then return false end
    if C.Status.Private[e.StatusId] and e.Owner~=localId then return false end
    if e.Revision<=self.LastRevision then return false end
    self.LastRevision=e.Revision
    local records=self.Records[e.Target]
    if not records then
        local count=0;for _ in pairs(self.Records) do count+=1 end
        if count>=C.Protocol.MaxStatusRecords then return false end
        self.RecordSerial+=1
        records={Target=e.Target,States={},Serial=self.RecordSerial};self.Records[e.Target]=records
    end
    local old=records.States[e.StatusId]
    if old and old.Revision>=e.Revision then return false end
    if e.Action=="Remove" then records.States[e.StatusId]={Revision=e.Revision,Removed=true,Owner=e.Owner};return true end
    records.States[e.StatusId]={Revision=e.Revision,Owner=e.Owner,ExpiresAt=e.ExpiresAt,PathwayId=e.PathwayId,Count=e.Count or 0,Required=e.Required}
    return true
end
function Status.RemoveGates(self: any,owner: number)
    local gate=self.Gates[owner]
    if not gate then return end
    if gate.Handle then gate.Handle:Finish() end
    for _,entry in ipairs(gate.Parts) do
        if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Alpha;entry.Part.Color=entry.Color end
    end
    self.Gates[owner]=nil
end
function Status.Gate(self: any,e: any)
    if not self.Blocks or type(e.Gates)~="table" or #e.Gates~=2 or not e.ExpiresAt then return end
    self:RemoveGates(e.Owner)
    local count=0;for _ in pairs(self.Gates) do count+=1 end
    if count>=C.Status.MaxGatePairs then return end
    local parts={}
    for _,part in ipairs(e.Gates) do
        if typeof(part)~="Instance" or not part:IsA("BasePart") or not part.Parent then return end
        table.insert(parts,{Part=part,Alpha=part.LocalTransparencyModifier,Color=part.Color})
    end
    for _,entry in ipairs(parts) do entry.Part.Color=C.Palettes.Apprentice.Primary end
    self.Gates[e.Owner]={Parts=parts,ExpiresAt=e.ExpiresAt,Owner=e.Owner,AbilityId=e.AbilityId,NextAttempt=0}
end
function Status.GateStep(self: any,gate: any,now: number)
    for _,entry in ipairs(gate.Parts) do if not entry.Part.Parent then self:RemoveGates(gate.Owner);return end end
    if now>=gate.ExpiresAt then self:RemoveGates(gate.Owner);return end
    if gate.Handle and gate.Handle.Active then return end
    if now<gate.NextAttempt then return end
    gate.NextAttempt=now+C.Status.Retry
    local layers={};local star=gate.AbilityId=="Apprentice_1"
    for _,entry in ipairs(gate.Parts) do
        local part=entry.Part
        local at=part.Position-Vector3.yAxis*(part.Size.Y/2)
        table.insert(layers,{Name="DoorFrame",Position=at,Palette="Apprentice",Options={Frame=CFrame.new(at)*part.CFrame.Rotation,
            Scale=1,Width=part.Size.X+C.Ability.DoorMargin,Height=part.Size.Y+C.Ability.DoorMargin}})
        if star then
            local top=part.Position+Vector3.yAxis*(part.Size.Y/2+C.Ability.GateStarOffset)
            table.insert(layers,{Name="SigilStencil",Position=top,Palette="Apprentice",
                Options={Frame=CFrame.new(top)*part.CFrame.Rotation,Glyph="Star",LowGlyph="Star",Scale=C.Ability.GateStarScale}})
        end
    end
    local handle=self.Blocks:Compose(layers,1,C.Status.GatePriority,math.min(C.Status.Lease,gate.ExpiresAt-now))
    if not handle then return end
    gate.Handle=handle
    -- Only suppress the old pane while the budget admits a replacement frame.
    for _,entry in ipairs(gate.Parts) do entry.Part.LocalTransparencyModifier=1 end
    handle.OnFinish=function()
        for _,entry in ipairs(gate.Parts) do if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Alpha end end
    end
end
function Status.Echo(self: any,e: any)
    local model=e.Echo
    if typeof(model)~="Instance" or not model:IsA("Model") or not e.ExpiresAt then return end
    local count=0;for _ in pairs(self.Echoes) do count+=1 end
    if count>=C.Status.MaxEchoes or self.Echoes[model] then return end
    local parts={}
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency<1 and #parts<C.Hit.MaxParts then
            table.insert(parts,{Part=part,Color=part.Color,Alpha=part.LocalTransparencyModifier})
            part.Color=C.Status.EchoColor;part.LocalTransparencyModifier=C.Status.EchoAlpha
        end
    end
    self.Echoes[model]={Model=model,Parts=parts,ExpiresAt=e.ExpiresAt,Owner=e.Owner}
end
function Status.RestoreEcho(self: any,echo: any)
    for _,entry in ipairs(echo.Parts) do
        if entry.Part.Parent then entry.Part.Color=entry.Color;entry.Part.LocalTransparencyModifier=entry.Alpha end
    end
end
function Status.ClearLocal(self: any,owner: number)
    for _,entry in pairs(self.Entries) do entry:Finish() end;table.clear(self.Entries)
    for _,record in pairs(self.Records) do
        for id,state in pairs(record.States) do if state.Owner==owner then record.States[id]=nil end end
    end
    self:RemoveGates(owner)
    for model,echo in pairs(self.Echoes) do if echo.Owner==owner then self:RestoreEcho(echo);self.Echoes[model]=nil end end
end
function Status.Reconcile(self: any)
    local now=self.Clock();local candidates={}
    for target,record in pairs(self.Records) do
        local live={};local priority=0
        for id,state in pairs(record.States) do
            if state.Removed or state.ExpiresAt<=now then record.States[id]=nil
            else
                local text=C.Status.Labels[id]
                if id=="Threaded" then text..=" "..state.Count.."/"..(state.Required or T.StatusUI.RequiredThreads) end
                if id=="Controlled" and state.PathwayId=="Seer" then text="Marionette" end
                table.insert(live,{Text=text,Priority=T.StatusUI.Priorities[id] or 0});priority=math.max(priority,T.StatusUI.Priorities[id] or 0)
            end
        end
        local root=Root(target)
        local hum=target:IsA("Model") and target:FindFirstChildOfClass("Humanoid")
        if not target.Parent or not root or (hum and hum.Health<=0) or #live==0 then
            self:ReleaseBadge(record);self.Records[target]=nil
        elseif self.Service:Visible(root.Position) and (root.Position-(self.Service.Camera or workspace.CurrentCamera).CFrame.Position).Magnitude<=T.StatusUI.Distance then
            table.sort(live,function(a,b) return if a.Priority==b.Priority then a.Text<b.Text else a.Priority>b.Priority end)
            record.Text=live[1].Text..(if live[2] then " · "..live[2].Text else "");record.Priority=priority;record.Root=root
            record.Distance=(root.Position-(self.Service.Camera or workspace.CurrentCamera).CFrame.Position).Magnitude
            table.insert(candidates,record)
        else self:ReleaseBadge(record) end
    end
    table.sort(candidates,function(a,b)
        if a.Priority~=b.Priority then return a.Priority>b.Priority end
        return if a.Distance==b.Distance then a.Serial<b.Serial else a.Distance<b.Distance
    end)
    local limit=if self.Service:Profile().Mobile then T.StatusUI.MobileMax else T.StatusUI.Max
    for i,record in ipairs(candidates) do
        if i>limit then self:ReleaseBadge(record)
        else
            record.Widget=record.Widget or self:Badge()
            if record.Widget then record.Widget.Adornee=record.Root;record.Widget.Status.Text=record.Text;record.Widget.Enabled=true end
        end
    end
    for _,gate in pairs(self.Gates) do self:GateStep(gate,now) end
    for model,echo in pairs(self.Echoes) do
        if not model.Parent or now>=echo.ExpiresAt then self:RestoreEcho(echo);self.Echoes[model]=nil end
    end
end
return Status
