--!strict
-- Local lighting/labels/ambience. All landmarks are tagged by the server.
local Collection=game:GetService("CollectionService")
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local Layout=require(Shared.VisualLayout)
local Kit=require(script.Parent.Parent.UI.Kit)
local WorldView={}
function WorldView.new(root: GuiObject,presentation: any,callbacks: any): any
    local self: any=setmetatable({Root=root,Presentation=presentation,Callbacks=callbacks,Labels={},Elapsed=0,AmbientAt=0,
        Lamps={},Zones={},Objects={},LastZone="",Exited={},Reduced=false,Low=false,ZoneSerial=0,NextScan=0},{__index=WorldView})
    self.Compass=Kit.Text(root,"Sanctuary Square",T.Type.Small,T.Fonts.Number);self.Compass.TextXAlignment=Enum.TextXAlignment.Center
    self.Compass.BackgroundColor3=T.Colors.Ink;self.Compass.BackgroundTransparency=0
    self.Title=Kit.New("CanvasGroup",root,{Name="ZoneTitle",BackgroundColor3=T.Colors.Ink,BorderSizePixel=0,Visible=false,ZIndex=T.Layers.Feedback})
    Kit.Corner(self.Title);Kit.Stroke(self.Title)
    self.TitleText=Kit.Text(self.Title,"",T.Type.Heading,T.Fonts.Title);self.TitleText.Size=UDim2.fromScale(1,1);self.TitleText.TextXAlignment=Enum.TextXAlignment.Center
    for i=1,T.World.Labels.Max do
        local label=Kit.Text(root,"",T.World.Labels.TextSize,T.Fonts.Number)
        label.Name="WorldLabel"..i;label.Size=UDim2.fromOffset(T.World.Labels.Width,T.World.Labels.Height)
        label.BackgroundColor3=T.Colors.Ink;label.BackgroundTransparency=0;label.Visible=false;label.TextXAlignment=Enum.TextXAlignment.Center
        Kit.Corner(label);self.Labels[i]=label
    end
    local old=Lighting:FindFirstChild("MysteriesWorldGrade");if old then old:Destroy() end
    self.Grade=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesWorldGrade"})
    for key,value in pairs(T.World.Correction) do self.Grade[key]=value end
    self:Scan()
    return self
end
function WorldView.Scan(self: any)
    self.Lamps=Collection:GetTagged("MysteriesLamp");self.Zones=Collection:GetTagged("MysteriesZone");self.Objects=Collection:GetTagged("MysteriesInteractable")
end
function WorldView.Resize(self: any,layout: any)
    self.Layout=layout;Kit.Rect(self.Compass,layout.Wordmark)
    local width=math.min(T.World.Zone.TitleWidth,layout.Width-layout.Profile.Margin*2)
    local top=math.max(T.World.Zone.TitleTop,layout.Resources.Y+layout.Resources.H+T.World.Labels.Pad)
    local height=math.min(T.World.Zone.TitleHeight,math.max(0,layout.Hotbar.Y-top-T.World.Labels.Pad))
    Kit.Rect(self.Title,{X=(layout.Width-width)/2,Y=top,W=width,H=height})
    self.TitleText.TextSize=layout.Profile.HeadingSize
end
function WorldView.SetSettings(self: any,reduced: boolean,low: boolean)
    self.Reduced=reduced;self.Low=low
    local bloom=Lighting:FindFirstChild("MysteriesBloom")
    if bloom and bloom:IsA("BloomEffect") then bloom.Enabled=not low end
end
function WorldView.Enter(self: any,zone: any,now: number)
    local name=if zone then zone:GetAttribute("VisualName") else "Outskirts"
    if type(name)~="string" then return end
    if name==self.LastZone then return end
    if self.LastZone~="" then self.Exited[self.LastZone]=now end
    self.LastZone=name
    local tier=zone and zone:GetAttribute("Sequence")
    local tint=if type(tier)=="number" then (if tier<=4 then T.World.Zone.HighTint else T.World.Zone.LowTint) else T.World.Zone.HubTint
    local color=T.World.Zone.HubTint:Lerp(tint,T.World.Zone.Blend)
    if self.Reduced then self.Grade.TintColor=color else Kit.Tween(self.Grade,T.World.Zone.Transition,{TintColor=color}) end
    if now-(self.Exited[name] or -math.huge)<T.World.Zone.Repeat then return end
    self.ZoneSerial+=1;local serial=self.ZoneSerial
    self.TitleText.Text=name..(if type(tier)=="number" then " · Sequence "..tier else "")
    self.Title.GroupTransparency=if self.Reduced then 0 else 1;self.Title.Visible=true
    if not self.Reduced then Kit.Tween(self.Title,T.World.Zone.Enter,{GroupTransparency=0}) end
    task.delay(T.World.Zone.Enter+T.World.Zone.Hold,function()
        if serial~=self.ZoneSerial then return end
        if self.Reduced then self.Title.Visible=false;return end
        local tween=Kit.Tween(self.Title,T.World.Zone.Leave,{GroupTransparency=1})
        tween.Completed:Once(function() if serial==self.ZoneSerial then self.Title.Visible=false end end)
    end)
end
function WorldView.ClearRay(self: any,from: Vector3,to: Vector3,target: Instance): boolean
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    local ignore: {Instance}={self.Presentation.VFX.Folder}
    if Players.LocalPlayer.Character then table.insert(ignore,Players.LocalPlayer.Character) end
    params.FilterDescendantsInstances=ignore
    local hit=workspace:Raycast(from,to-from,params)
    return not hit or hit.Instance==target or hit.Instance:IsDescendantOf(target)
end
function WorldView.ProjectLabels(self: any,camera: Camera,root: BasePart)
    for _,label in ipairs(self.Labels) do label.Visible=false end
    if not self.Layout or self.Callbacks.Modal() then return end
    local cfg=T.World.Labels;local accepted={};local candidates={}
    for _,object in ipairs(self.Objects) do
        if object:IsA("BasePart") and object.Parent then
            local distance=(root.Position-object.Position).Magnitude
            if distance<=cfg.Distance then table.insert(candidates,{Part=object,Distance=distance}) end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local count=0;local origin=self.Root.AbsolutePosition
    local exclusions={self.Layout.Resources,self.Layout.Hotbar,self.Layout.Journal,self.Layout.Action}
    for _,gui in ipairs(self.Callbacks.Exclusions()) do
        if gui.Visible then
            local p=gui.AbsolutePosition-origin;local size=gui.AbsoluteSize
            table.insert(exclusions,{X=p.X,Y=p.Y,W=size.X,H=size.Y})
        end
    end
    for _,item in ipairs(candidates) do
        if count>=cfg.Max then break end
        local object=item.Part
        local prompt=self.Callbacks.Prompt()
        if prompt and prompt.Parent==object then continue end
        local at=object.Position+Vector3.yAxis*cfg.Offset
        local point,visible=camera:WorldToViewportPoint(at)
        if not visible or not self:ClearRay(camera.CFrame.Position,object.Position,object) then continue end
        for _,offset in ipairs(cfg.Slots) do
            local r={X=point.X-origin.X-cfg.Width/2,Y=point.Y-origin.Y+offset,W=cfg.Width,H=cfg.Height}
            if r.X<0 or r.Y<0 or r.X+r.W>self.Layout.Width or r.Y+r.H>self.Layout.Height then continue end
            local blocked=false
            for _,other in ipairs(exclusions) do if Layout.Intersects(r,other,cfg.Pad) then blocked=true;break end end
            for _,other in ipairs(accepted) do if Layout.Intersects(r,other,cfg.Pad) then blocked=true;break end end
            if blocked then continue end
            count+=1;local label=self.Labels[count]
            label.Text=object:GetAttribute("VisualName") or object.Name
            local fade=math.clamp((item.Distance-cfg.Full)/(cfg.Distance-cfg.Full),0,1)
            label.TextTransparency=fade;label.BackgroundTransparency=fade;Kit.Rect(label,r);label.Visible=true
            table.insert(accepted,r);break
        end
    end
end
function WorldView.Step(self: any,dt: number)
    self.Elapsed+=dt;if self.Elapsed<T.World.Lamp.Tick then return end;self.Elapsed=0
    local bloom=Lighting:FindFirstChild("MysteriesBloom")
    if bloom and bloom:IsA("BloomEffect") then bloom.Enabled=not self.Low end
    local now=os.clock();if now>=self.NextScan then self:Scan();self.NextScan=now+T.World.Scan end
    local camera=workspace.CurrentCamera
    local character=Players.LocalPlayer.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if not camera or not root or not root:IsA("BasePart") then
        for _,label in ipairs(self.Labels) do label.Visible=false end
        for _,lamp in ipairs(self.Lamps) do local light=lamp:FindFirstChild("Gaslight");if light and light:IsA("PointLight") then light.Enabled=false end end
        return
    end
    local zone=nil;local closest=math.huge
    for _,object in ipairs(self.Zones) do
        if object:IsA("BasePart") then
            local distance=(root.Position-object.Position).Magnitude
            if distance<(object:GetAttribute("Radius") or 0) and distance<closest then closest=distance;zone=object end
        end
    end
    self:Enter(zone,now)
    local look=camera.CFrame.LookVector
    local heading=math.floor((math.deg(math.atan2(-look.X,-look.Z))+360)%360)
    self.Compass.Text=heading.."° · "..self.LastZone
    self.Compass.Visible=not self.Callbacks.Modal() and not self.Title.Visible
    if self.Callbacks.Title then self.Callbacks.Title(self.Title.Visible) end
    self:ProjectLabels(camera,root)
    local lamps={}
    for _,lamp in ipairs(self.Lamps) do
        if lamp:IsA("BasePart") and lamp.Parent then
            local light=lamp:FindFirstChild("Gaslight")
            if light and light:IsA("PointLight") then
                light.Enabled=false
                local distance=(camera.CFrame.Position-lamp.Position).Magnitude
                if distance<=T.World.Lamp.MaxDistance and self.Presentation.VFX:Visible(lamp.Position) then table.insert(lamps,{Part=lamp,Light=light,Distance=distance}) end
            end
        end
    end
    table.sort(lamps,function(a,b) return a.Distance<b.Distance end)
    local profile=self.Presentation.VFX:Profile()
    local limit=if self.Low or profile.Mobile or profile.Low then T.World.Lamp.LowMax else T.World.Lamp.DesktopMax
    for i=1,math.min(limit,#lamps) do
        local light=lamps[i].Light;light.Enabled=true;light.Shadows=false
        light.Brightness=T.World.Lamp.Brightness*(if self.Reduced then 1 else 1+math.sin(now/T.World.Lamp.Period+lamps[i].Part.Position.X)*T.World.Lamp.Flicker)
    end
    if now>=self.AmbientAt then
        self.AmbientAt=now+T.World.Ambient.Interval
        if not self.Low and not profile.Low and not self.Reduced then
            local count=if profile.Mobile then T.World.Ambient.MobileMax else T.World.Ambient.DesktopMax
            for i=1,math.min(count,#lamps) do
                local at=lamps[i].Part.Position
                self.Presentation.Blocks:Compose({{Name="RisingMotes",Position=at,Palette="Seer",Options={Scale=T.World.Ambient.Scale,Tint=T.Colors.Warm}}},1,T.World.Ambient.Priority,T.World.Ambient.Life)
            end
        end
    end
end
function WorldView.Destroy(self: any)
    self.ZoneSerial+=1;self.Grade:Destroy();self.Title:Destroy();self.Compass:Destroy()
    for _,label in ipairs(self.Labels) do label:Destroy() end
    for _,lamp in ipairs(self.Lamps) do local light=lamp:FindFirstChild("Gaslight");if light and light:IsA("PointLight") then light.Enabled=false end end
end
return WorldView
