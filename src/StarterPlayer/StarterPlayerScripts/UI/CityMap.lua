--!strict
local Shared=game:GetService("ReplicatedStorage").Shared
local Registry=require(Shared.CityDestinations)
local Plan=require(Shared.TingenPlan)
local Layout=require(Shared.TingenLayout)
local Kit=require(script.Parent.Kit)
local Input=game:GetService("UserInputService")
local Map={};Map.__index=Map
local ink=Color3.fromRGB(29,36,43)
local paper=Color3.fromRGB(222,216,195)
local gold=Color3.fromRGB(207,179,116)
local function button(parent: Instance,text: string,position: UDim2,size: UDim2,callback: ()->()): TextButton
    local b=Kit.New("TextButton",parent,{Text=text,Position=position,Size=size,BackgroundColor3=ink,TextColor3=paper,TextSize=14,Font=Enum.Font.Gotham})
    b.Activated:Connect(callback);return b
end
function Map.new(parent: Instance,send: any,modal: any): any
    local self: any=setmetatable({Send=send,Modal=modal,Zoom=1,Selected=nil,State=nil,Rows={},Pins={},Waiting=false,Connections={}},Map)
    self.Root=Kit.New("Frame",parent,{Name="TingenCityMap",Size=UDim2.fromScale(1,1),BackgroundColor3=ink,Visible=false,ZIndex=20})
    Kit.New("TextLabel",self.Root,{Text="TINGEN  /  CITY ATLAS",Position=UDim2.fromOffset(16,8),Size=UDim2.new(1,-190,0,30),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,TextColor3=gold,TextSize=20,Font=Enum.Font.Garamond})
    button(self.Root,"Close [M]",UDim2.new(1,-110,0,8),UDim2.fromOffset(100,30),function() self:Close() end)
    self.Search=Kit.New("TextBox",self.Root,{PlaceholderText="Search locations…",Text="",ClearTextOnFocus=false,Position=UDim2.fromOffset(12,48),Size=UDim2.new(1,-24,0,32),TextColor3=paper,BackgroundColor3=Color3.fromRGB(49,58,65),TextSize=14})
    self.View=Kit.New("ScrollingFrame",self.Root,{Position=UDim2.fromOffset(12,90),Size=UDim2.new(.68,-18,1,-205),CanvasSize=UDim2.fromOffset(1080,809),BackgroundColor3=paper,ScrollBarThickness=6,BorderSizePixel=0})
    self.Canvas=Kit.New("Frame",self.View,{Size=UDim2.fromOffset(1080,809),BackgroundColor3=paper,BorderSizePixel=0})
    self.Scale=Kit.New("UIScale",self.Canvas,{Scale=1})
    local function rect(x: number,y: number,w: number,h: number,c: Color3)
        return Kit.New("Frame",self.Canvas,{Position=UDim2.fromOffset(x-w/2,y-h/2),Size=UDim2.fromOffset(w,h),BackgroundColor3=c,BorderSizePixel=0})
    end
    for _,r in ipairs(Plan.Water) do rect(r[1],r[2],r[3],r[4],Color3.fromRGB(73,115,134)) end
    for _,r in ipairs(Plan.Buildings) do
        local b=rect(r[1],r[2],r[3],r[4],Color3.fromRGB(139,129,112));b.Rotation=-r[5]
    end
    for _,r in ipairs(Plan.Roads) do
        local dx,dy=r[3]-r[1],r[4]-r[2]
        local b=rect((r[1]+r[3])/2,(r[2]+r[4])/2,math.sqrt(dx*dx+dy*dy),r[5],Color3.fromRGB(185,179,161));b.Rotation=math.deg(math.atan2(dy,dx))
    end
    self.List=Kit.New("ScrollingFrame",self.Root,{Position=UDim2.new(.68,0,0,90),Size=UDim2.new(.32,-12,1,-205),BackgroundTransparency=1,ScrollBarThickness=5,CanvasSize=UDim2.new(),BorderSizePixel=0})
    for _,entry in ipairs(Registry.Entries) do
        local pin=button(self.Canvas,tostring(entry.MapId),UDim2.fromOffset(entry.X-6,entry.Y-6),UDim2.fromOffset(12,12),function() self:Select(entry) end)
        pin.TextSize=9;pin.BackgroundColor3=Color3.fromRGB(126,49,44);pin.ZIndex=3
        local name=Kit.New("TextLabel",pin,{Position=UDim2.fromOffset(14,-2),Size=UDim2.fromOffset(135,16),BackgroundTransparency=.2,BackgroundColor3=paper,TextColor3=ink,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Text=entry.Name,ZIndex=4,Visible=false})
        pin.MouseEnter:Connect(function() name.Visible=true end)
        pin.MouseLeave:Connect(function() name.Visible=self.Zoom>=2 or self.Selected==entry end)
        self.Pins[entry.Id]={Button=pin,Label=name}
        local row=button(self.List,tostring(entry.MapId).."  "..entry.Name,UDim2.new(),UDim2.new(1,-8,0,40),function() self:Select(entry) end)
        row.TextWrapped=true;row.TextSize=12;row.TextXAlignment=Enum.TextXAlignment.Left
        table.insert(self.Rows,{Entry=entry,Button=row})
    end
    self.You=rect(655,310,8,8,Color3.fromRGB(0,160,180));self.You.ZIndex=6
    self.Detail=Kit.New("TextLabel",self.Root,{Position=UDim2.new(0,12,1,-105),Size=UDim2.new(1,-24,0,40),Text="Select a named location. Right-drag or touch-drag to pan; + / − to zoom.",TextWrapped=true,BackgroundTransparency=1,TextColor3=paper,TextSize=14})
    self.TravelButton=button(self.Root,"Door travel",UDim2.new(.48,0,1,-53),UDim2.new(.52,-12,0,38),function()
        if self.Waiting or not self.Selected or not self.State or self.State.PathwayId~="Apprentice" then return end
        self.Waiting=true;self.SentAt=os.clock();self.Detail.Text="Opening a door…"
        self.Send("CityTravel",{Id=self.Selected.Id})
    end)
    button(self.Root,"−",UDim2.new(0,12,1,-53),UDim2.fromOffset(38,38),function() self:SetZoom(self.Zoom/1.5) end)
    button(self.Root,"+",UDim2.new(0,56,1,-53),UDim2.fromOffset(38,38),function() self:SetZoom(self.Zoom*1.5) end)
    button(self.Root,"Fit",UDim2.new(0,100,1,-53),UDim2.fromOffset(45,38),function() self:SetZoom(1);self.View.CanvasPosition=Vector2.zero end)
    self.Launch=Kit.Button(parent,"Map [M]",function() self:Toggle() end)
    self.Search:GetPropertyChangedSignal("Text"):Connect(function() self:Filter() end)
    self.Root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() self:SetZoom(self.Zoom) end)
    self.View.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            self.DragStart=Vector2.new(input.Position.X,input.Position.Y);self.DragCanvas=self.View.CanvasPosition
        end
    end)
    table.insert(self.Connections,Input.InputChanged:Connect(function(input: InputObject)
        if self.Root.Visible and self.DragStart and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=Vector2.new(input.Position.X,input.Position.Y)-self.DragStart
            self.View.CanvasPosition=self.DragCanvas-delta
        end
    end))
    table.insert(self.Connections,Input.InputEnded:Connect(function(input: InputObject)
        if input.UserInputType==Enum.UserInputType.MouseButton2 then self.DragStart=nil end
    end))
    self:Filter();return self
end
function Map.Resize(self: any,layout: any)
    Kit.Rect(self.Launch,layout.Map)
    self.Launch.TextSize=12
    self.Launch.Text=if layout.Map.W<70 then "Map" else "Map [M]"
end
function Map.Filter(self: any)
    local query=string.lower(self.Search.Text);local n=0
    for _,row in ipairs(self.Rows) do
        local visible=string.find(string.lower(row.Entry.Name),query,1,true)~=nil or tostring(row.Entry.MapId)==query
        row.Button.Visible=visible
        if visible then row.Button.Position=UDim2.fromOffset(0,n*42);n+=1 end
        self.Pins[row.Entry.Id].Button.Visible=visible
    end
    self.List.CanvasSize=UDim2.fromOffset(0,n*42);self.List.CanvasPosition=Vector2.zero
end
function Map.Select(self: any,entry: any)
    self.Selected=entry
    self.Detail.Text=entry.Name..(if entry.Approximate then " · approximate site" else "")
    for id,pin in pairs(self.Pins) do pin.Label.Visible=self.Zoom>=2 or id==entry.Id end
    local scale=self.Scale.Scale
    self.View.CanvasPosition=Vector2.new(math.max(0,entry.X*scale-self.View.AbsoluteSize.X/2),math.max(0,entry.Y*scale-self.View.AbsoluteSize.Y/2))
end
function Map.SetZoom(self: any,zoom: number)
    self.Zoom=math.clamp(zoom,1,5)
    local fit=math.min(self.View.AbsoluteSize.X/1080,self.View.AbsoluteSize.Y/809)
    if fit<=0 then return end
    self.Scale.Scale=fit*self.Zoom;self.View.CanvasSize=UDim2.fromOffset(1080*fit*self.Zoom,809*fit*self.Zoom)
    for _,pin in pairs(self.Pins) do pin.Label.Visible=self.Zoom>=2 end
end
function Map.Update(self: any,state: any)
    self.State=state
    local door=state.Ready and not state.Dead and state.PathwayId=="Apprentice"
    self.TravelButton.Visible=door==true
    self.TravelButton.Text="Travel · "..Registry.Cost.." spirituality"
    if state.Dead then self:Close() end
end
function Map.Result(self: any,result: any)
    self.Waiting=false;self.Detail.Text=result.Message or "Travel complete"
    if result.Ok then self:Close() end
end
function Map.Step(self: any)
    if not self.Root.Visible then return end
    if self.Waiting and os.clock()-self.SentAt>8 then self.Waiting=false;self.Detail.Text="No response. Select the destination to retry." end
    local character=game:GetService("Players").LocalPlayer.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        self.You.Position=UDim2.fromOffset(root.Position.X/Layout.Scale+Layout.OriginX-4,root.Position.Z/Layout.Scale+Layout.OriginY-4)
    end
end
function Map.Toggle(self: any)
    if self.Root.Visible then self:Close();return end
    self.Root.Visible=true;self.Modal(true);self:SetZoom(1);self.View.CanvasPosition=Vector2.zero
    self.Detail.Text=if self.State and self.State.PathwayId=="Apprentice" then "Select a location, then Travel · 10 spirituality · 5s cooldown" else "Select a location to find it. Door pathway unlocks city travel."
end
function Map.Close(self: any) self.DragStart=nil;self.Root.Visible=false;self.Modal(false) end
function Map.Destroy(self: any)
    self:Close()
    for _,connection in ipairs(self.Connections) do connection:Disconnect() end
    self.Root:Destroy();self.Launch:Destroy()
end
return Map
