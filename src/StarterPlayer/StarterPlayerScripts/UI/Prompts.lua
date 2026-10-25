--!strict
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Layout=require(Shared.VisualLayout)
local Kit=require(script.Parent.Kit)
local Prompts={}
local function position(prompt: ProximityPrompt): Vector3?
    local parent=prompt.Parent
    if not parent then return nil end
    if parent:IsA("Attachment") then return parent.WorldPosition end
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Model") then return parent:GetPivot().Position end
    return nil
end
function Prompts.new(parent: GuiObject): any
    local self: any={SafeRoot=parent,Current=nil,Layout=nil,Modal=false,Hold=nil,RenderConnection=nil,LegacyLabels={},Suppressed={}}
    self.Root=Kit.New("Frame",parent,{Name="ObjectPrompt",BackgroundTransparency=1,Visible=false,ZIndex=T.Layers.Prompt})
    self.Button=Kit.Button(self.Root,"",function() end);self.Button.Size=UDim2.fromScale(1,1)
    self.Badge=Kit.Panel(self.Button,"InputBadge")
    self.Key=Kit.Text(self.Badge,"E",T.Type.Small,T.Fonts.Number);self.Key.Size=UDim2.fromScale(1,1);self.Key.TextXAlignment=Enum.TextXAlignment.Center
    self.Action=Kit.Text(self.Button,"Interact",T.Type.Small,T.Fonts.Number)
    self.Object=Kit.Text(self.Button,"",T.Type.Micro);self.Object.TextColor3=T.Colors.Muted
    self.Fill=Kit.New("Frame",self.Button,{BorderSizePixel=0,BackgroundColor3=T.Colors.Gold,Position=UDim2.fromScale(0,1),AnchorPoint=Vector2.new(0,1)})
    local p=T.Layout.Prompt
    self.Root.Size=UDim2.fromOffset(p.Width,p.Height)
    self.Badge.Position=UDim2.fromOffset(p.Pad,(p.Height-p.Icon)/2);self.Badge.Size=UDim2.fromOffset(p.Icon,p.Icon)
    self.Action.Position=UDim2.fromOffset(p.TextX,p.Pad/2);self.Action.Size=UDim2.new(1,-p.TextX-p.Pad,0,p.ActionHeight)
    self.Object.Position=UDim2.fromOffset(p.TextX,p.ActionHeight+p.Pad/2);self.Object.Size=UDim2.new(1,-p.TextX-p.Pad,0,p.ObjectHeight)
    self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
    local function track(object: Instance)
        if object:IsA("ProximityPrompt") then object.Style=Enum.ProximityPromptStyle.Custom
        elseif object:IsA("BillboardGui") and object.Name~="MysteriesStatus" and object.Name~="MysteriesEnemyHealth" then
            self.LegacyLabels[object]=true
            if self.Root.Visible then self.Suppressed[object]=object.Enabled;object.Enabled=false end
        end
    end
    for _,object in ipairs(workspace:GetDescendants()) do track(object) end
    workspace.DescendantAdded:Connect(track)
    workspace.DescendantRemoving:Connect(function(object) self.LegacyLabels[object]=nil;self.Suppressed[object]=nil end)
    ProximityPromptService.MaxPromptsVisible=p.MaxVisible
    ProximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt,inputType: Enum.ProximityPromptInputType)
        if self.Modal then return end
        self:Hide();self.Current=prompt
        self.Action.Text=if prompt:GetAttribute("InteractionId")=="Buy" then "Open potion altar" else prompt.ActionText
        self.Object.Text=prompt.ObjectText
        self.Key.Text=if inputType==Enum.ProximityPromptInputType.Touch then "Tap" elseif inputType==Enum.ProximityPromptInputType.Gamepad then string.gsub(prompt.GamepadKeyCode.Name,"Button","") else prompt.KeyboardKeyCode.Name
        self.RenderConnection=RunService.RenderStepped:Connect(function() self:Project() end)
        self:Project()
    end)
    ProximityPromptService.PromptHidden:Connect(function(prompt) if self.Current==prompt then self:Hide() end end)
    ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if self.Current~=prompt then return end
        if self.Hold then self.Hold:Cancel() end
        self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
        self.Hold=Kit.Tween(self.Fill,prompt.HoldDuration,{Size=UDim2.new(1,0,0,p.HoldHeight)})
    end)
    ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt)
        if self.Current==prompt then
            if self.Hold then self.Hold:Cancel();self.Hold=nil end
            self.Fill.Size=UDim2.new(0,0,0,p.HoldHeight)
        end
    end)
    self.Button.InputBegan:Connect(function(input)
        if self.Current and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then self.Current:InputHoldBegin() end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if self.Current and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then self.Current:InputHoldEnd() end
    end)
    return setmetatable(self,{__index=Prompts})
end
function Prompts.Suppress(self: any,visible: boolean)
    -- Phase 1 avoids prompt/sign collisions. Phase 2 replaces these legacy signs properly.
    if visible then
        for label in pairs(self.LegacyLabels) do
            if label.Parent and self.Suppressed[label]==nil then self.Suppressed[label]=label.Enabled;label.Enabled=false end
        end
    else
        for label,enabled in pairs(self.Suppressed) do if label.Parent then label.Enabled=enabled end end
        table.clear(self.Suppressed)
    end
end
function Prompts.Show(self: any,visible: boolean)
    self.Root.Visible=visible
    if self.OnVisibility then self.OnVisibility(visible) end
    self:Suppress(visible)
end
function Prompts.Hide(self: any)
    local previous=self.Current;self.Current=nil
    if previous then previous:InputHoldEnd() end
    if self.RenderConnection then self.RenderConnection:Disconnect();self.RenderConnection=nil end
    if self.Hold then self.Hold:Cancel();self.Hold=nil end
    self.Current=nil;self:Show(false)
end
function Prompts.SetModal(self: any,open: boolean)
    self.Modal=open
    ProximityPromptService.Enabled=not open
    if open then self:Hide() end
end
function Prompts.Project(self: any)
    local prompt=self.Current;local camera=workspace.CurrentCamera
    local root=Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local world=prompt and position(prompt)
    if self.Modal or not prompt or not prompt.Parent or not prompt.Enabled or not camera or not root or not root:IsA("BasePart") or not world then
        self:Show(false);return
    end
    local screen,onScreen=camera:WorldToViewportPoint(world)
    if not onScreen or (root.Position-world).Magnitude>prompt.MaxActivationDistance then self:Show(false);return end
    local p=T.Layout.Prompt
    local origin=self.SafeRoot.AbsolutePosition
    local x,y=screen.X-origin.X,screen.Y-origin.Y
    local size=self.SafeRoot.AbsoluteSize
    -- Interactions outrank the optional pathway/masthead, which can temporarily yield space.
    self:Show(true)
    local candidates={{x+p.OffsetX,y+p.OffsetY},{x-p.Width-p.OffsetX,y+p.OffsetY},{x-p.Width/2,y-p.Height+p.OffsetY}}
    if self.Layout then table.insert(candidates,{(size.X-p.Width)/2,self.Layout.Hotbar.Y-p.Height-p.Edge}) end
    local chosen=nil
    for _,candidate in ipairs(candidates) do
        local r={X=math.clamp(candidate[1],p.Edge,math.max(p.Edge,size.X-p.Width-p.Edge)),Y=math.clamp(candidate[2],p.Edge,math.max(p.Edge,size.Y-p.Height-p.Edge)),W=p.Width,H=p.Height}
        local blocked=false
        if self.Layout then
            for _,other in ipairs({self.Layout.Resources,self.Layout.Hotbar,self.Layout.Journal,self.Layout.Wordmark}) do
                if Layout.Intersects(r,other,p.Edge) then blocked=true;break end
            end
            for _,object in ipairs(self.Exclusions or {}) do
                if object.Visible and object.Parent then
                    local pos=object.AbsolutePosition-self.SafeRoot.AbsolutePosition
                    local bounds=object.AbsoluteSize
                    if Layout.Intersects(r,{X=pos.X,Y=pos.Y,W=bounds.X,H=bounds.Y},p.Edge) then blocked=true;break end
                end
            end
        end
        if not blocked then chosen=r;break end
    end
    if chosen then Kit.Rect(self.Root,chosen) end
    self:Show(chosen~=nil)
end
return Prompts
