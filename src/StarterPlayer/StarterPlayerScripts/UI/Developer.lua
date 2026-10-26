--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Data=require(Shared.GameData)
local Kit=require(script.Parent.Kit)
local Developer={}
function Developer.new(parent: Instance,send: any,testRoom: (() -> ())?): any
    local D=T.Layout.Developer
    local self: any=setmetatable({Allowed=false,State=nil,Pathway="Seer",Sequence=9,Initialized=false,Dirty=false,Waiting=false,Suppressed=false,
        PathButtons={},SequenceButtons={},Buttons={}},{__index=Developer})
    self.Root=Kit.Panel(parent,"DeveloperPanel");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    self.ToggleButton=Kit.Button(parent,"ADMIN",function() self:Toggle() end)
    self.ToggleButton.Name="AdminPowersButton";self.ToggleButton.ZIndex=T.Layers.Developer;self.ToggleButton.Visible=false
    local title=Kit.Text(self.Root,"ADMIN POWERS · F8",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(D.Pad,0);title.Size=UDim2.new(1,-D.Pad*2,0,D.Row)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{Name="DeveloperControls",BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=T.Style.Stroke,ScrollingDirection=Enum.ScrollingDirection.Y,
        Position=UDim2.fromOffset(0,D.Row),Size=UDim2.new(1,0,1,-D.Row)})
    self.Info=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Number)
    self.Info.Position=UDim2.fromOffset(D.Pad,0);self.Info.Size=UDim2.new(1,-D.Pad*2,0,D.Row*2)
    local y=D.Row*2
    local label=Kit.Text(self.Scroll,"Choose pathway",T.Type.Body,T.Fonts.Heading)
    label.Position=UDim2.fromOffset(D.Pad,y);label.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row
    local function cell(button: TextButton,column: number,top: number)
        button.Size=UDim2.new(1/D.Columns,-(D.Pad*2+D.Gap*(D.Columns-1))/D.Columns,0,D.Row)
        button.Position=UDim2.new(column/D.Columns,D.Pad+column*D.Gap/D.Columns,0,top)
        button.TextSize=T.Type.Small
    end
    for i,id in ipairs({"Seer","Marauder","Apprentice"}) do
        local b=Kit.Button(self.Scroll,id,function()
            if not self:CanChange() then return end
            self.Pathway=id;self.Dirty=true;self:Selection()
        end)
        cell(b,i-1,y);self.PathButtons[id]=b;table.insert(self.Buttons,b)
    end
    y+=D.Row+D.Gap
    self.Selected=Kit.Text(self.Scroll,"",T.Type.Small,T.Fonts.Heading)
    self.Selected.Position=UDim2.fromOffset(D.Pad,y);self.Selected.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row
    for sequence=9,1,-1 do
        local index=9-sequence
        local b=Kit.Button(self.Scroll,"Seq "..sequence,function()
            if not self:CanChange() then return end
            self.Sequence=sequence;self.Dirty=true;self:Selection()
        end)
        cell(b,index%D.Columns,y+math.floor(index/D.Columns)*(D.Row+D.Gap))
        self.SequenceButtons[sequence]=b;table.insert(self.Buttons,b)
    end
    y+=math.ceil(9/D.Columns)*(D.Row+D.Gap)
    self.Apply=Kit.Button(self.Scroll,"Apply pathway & sequence",function()
        if not self:CanChange() then return end
        self.Waiting=true;self:Selection()
        send("AdminSet",{PathwayId=self.Pathway,Sequence=self.Sequence})
    end)
    self.Apply.Position=UDim2.fromOffset(D.Pad,y);self.Apply.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row+D.Gap
    if testRoom then
        self.TestButton=Kit.Button(self.Scroll,"Studio VFX test room",function() if self.Allowed then testRoom() end end)
        self.TestButton.Position=UDim2.fromOffset(D.Pad,y);self.TestButton.Size=UDim2.new(1,-D.Pad*2,0,D.Row);y+=D.Row+D.Gap
    end
    self.Scroll.CanvasSize=UDim2.fromOffset(0,y)
    self:Selection()
    return self
end
function Developer.CanChange(self: any): boolean
    return self.Allowed and self.State~=nil and self.State.Ready==true and not self.State.Dead and not self.Waiting
end
function Developer.Selection(self: any)
    local sequence=Data.Pathways[self.Pathway].Sequences[self.Sequence]
    self.Selected.Text="Sequence "..self.Sequence.." · "..sequence.Name
    local enabled=self:CanChange()
    for id,b in pairs(self.PathButtons) do
        b.Interactable=enabled;b.BackgroundColor3=if id==self.Pathway then T.Colors.Gold else T.Colors.Slate
        b.TextColor3=if id==self.Pathway then T.Colors.Ink else T.Colors.Text
    end
    for number,b in pairs(self.SequenceButtons) do
        b.Interactable=enabled;b.BackgroundColor3=if number==self.Sequence then T.Colors.Gold else T.Colors.Slate
        b.TextColor3=if number==self.Sequence then T.Colors.Ink else T.Colors.Text
    end
    self.Apply.Interactable=enabled;self.Apply.Text=if self.Waiting then "Applying…" else "Apply pathway & sequence"
end
function Developer.Resize(self: any,layout: any)
    local D=T.Layout.Developer
    local width=math.min(D.Width,layout.Width-layout.Profile.Margin*2)
    local height=math.min(D.Height,layout.Height-layout.Profile.Margin*2)
    local rect=layout.Admin
    local panelY=math.max(layout.Profile.Margin,(layout.Height-height)/2)
    self.Root.Size=UDim2.fromOffset(width,height)
    self.Root.Position=UDim2.fromOffset((layout.Width-width)/2,panelY)
    self.Root.BackgroundTransparency=0
    Kit.Rect(self.ToggleButton,rect)
    self.ToggleButton.TextSize=12
    self.ToggleButton.Text=if rect.W<70 then "Dev" else "Admin"

end
function Developer.Update(self: any,state: any)
    self.State=state;self.Allowed=state~=nil and state.Developer==true
    self.ToggleButton.Visible=self.Allowed and not self.Suppressed
    if not self.Allowed then self.Root.Visible=false;self.Waiting=false;self:Selection();return end
    local info=state.DeveloperInfo
    self.Info.Text=if info then (if info.SessionOnly then "Studio · changes last this session" else "Live · changes save to your profile")..
        "\nCurrent: "..(state.PathwayId or "Uninitiated").." · "..(if state.Sequence then "Seq "..state.Sequence else "No sequence") else "Loading admin controls…"
    if state.Ready then
        if not self.Initialized or not self.Dirty then
            self.Pathway=state.PathwayId or "Seer";self.Sequence=state.Sequence or 9;self.Initialized=true
        end
        if self.Waiting and state.PathwayId==self.Pathway and state.Sequence==self.Sequence then self.Dirty=false end
        self.Waiting=false
    end
    self:Selection()
end
function Developer.Toggle(self: any)
    if self.Allowed and not self.Suppressed then self.Root.Visible=not self.Root.Visible end
end
function Developer.SetSuppressed(self: any,suppressed: boolean)
    self.Suppressed=suppressed;self.ToggleButton.Visible=self.Allowed and not suppressed
    if suppressed then self.Root.Visible=false end
end
return Developer
