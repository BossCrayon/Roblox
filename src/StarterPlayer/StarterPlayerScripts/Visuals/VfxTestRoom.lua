--!strict
-- Local preview only, launched by the server-authorized F8 panel in Studio.
-- The stage has no collision/query and sends no remote or gameplay intent.
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local A=require(Shared.AnimConfig)
local V=require(Shared.VfxConfig)
local Data=require(Shared.GameData)
local Kit=require(script.Parent.Parent.UI.Kit)
local Blocks=require(script.Parent.EffectBlocks)
local TestRoom={}
function TestRoom.new(parent: Instance,presentation: any,callbacks: any): any
    local self: any=setmetatable({Presentation=presentation,Callbacks=callbacks,Palette=T.TestRoom.DefaultPalette,
        Reduced=false,Low=false,Gray=false,Elapsed=0,Stage=nil,Position=Vector3.zero},{__index=TestRoom})
    self.Root=Kit.Panel(parent,"VFXTestRoom");self.Root.ZIndex=T.Layers.Developer;self.Root.Visible=false
    local title=Kit.Text(self.Root,"VFX TEST ROOM · STUDIO",T.Type.Heading,T.Fonts.Heading)
    title.Position=UDim2.fromOffset(T.TestRoom.Pad,0);title.Size=UDim2.new(1,-T.TestRoom.Header-T.TestRoom.Pad,0,T.TestRoom.Header)
    local close=Kit.Button(self.Root,T.Style.CloseSymbol,function() self:Close() end)
    close.Position=UDim2.new(1,-T.TestRoom.Header,0,0);close.Size=UDim2.fromOffset(T.TestRoom.Header,T.TestRoom.Header)
    self.Scroll=Kit.New("ScrollingFrame",self.Root,{BackgroundTransparency=1,BorderSizePixel=0,
        Position=UDim2.fromOffset(T.TestRoom.Pad,T.TestRoom.Header),Size=UDim2.new(1,-T.TestRoom.Pad*2,1,-T.TestRoom.Header-T.TestRoom.StatusHeight),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromOffset(0,0),ScrollBarThickness=T.Style.Stroke})
    Kit.New("UIListLayout",self.Scroll,{Padding=UDim.new(0,T.TestRoom.Gap),SortOrder=Enum.SortOrder.LayoutOrder})
    local order=0
    local function row(text: string,action: ()->())
        order+=1
        local button=Kit.Button(self.Scroll,text,action)
        button.Size=UDim2.new(1,-T.TestRoom.Gap,0,T.TestRoom.Row);button.LayoutOrder=order
        return button
    end
    self.PaletteButton=row("Palette: "..self.Palette,function()
        self.Palette=if self.Palette=="Seer" then "Marauder" elseif self.Palette=="Marauder" then "Apprentice" else "Seer"
        self.PaletteButton.Text="Palette: "..self.Palette
    end)
    row("Recenter local preview stage",function() self:StageAtCamera() end)
    self.ReducedButton=row("Reduced motion: off",function()
        self.Reduced=not self.Reduced;callbacks.ReducedMotion(self.Reduced)
        self.ReducedButton.Text="Reduced motion: "..(if self.Reduced then "on" else "off")
    end)
    self.LowButton=row("Low graphics: off",function()
        self.Low=not self.Low;callbacks.LowGraphics(self.Low)
        self.LowButton.Text="Low graphics: "..(if self.Low then "on" else "off")
    end)
    self.GrayButton=row("Silhouette view: color",function()
        self.Gray=not self.Gray
        if self.Gray and not self.GrayEffect then
            self.GrayEffect=Kit.New("ColorCorrectionEffect",Lighting,{Name="MysteriesSilhouettePreview",Saturation=T.Visuals.GrayscaleSaturation})
        elseif self.GrayEffect then self.GrayEffect:Destroy();self.GrayEffect=nil end
        self.GrayButton.Text="Silhouette view: "..(if self.Gray then "grayscale" else "color")
    end)
    local function abilityPreview(id: string,variant: string,cancel: boolean?,mode: string?)
        if not self.Stage then self:StageAtCamera() end
        local camera=workspace.CurrentCamera
        if not camera then return end
        local origin=self.Position
        local destination=origin+camera.CFrame.RightVector*T.TestRoom.AbilityOffset
        local target=self.Dummy
        if id=="Apprentice_9" then target=self.PreviewDoor end
        if mode=="HiddenOrigin" then origin=camera.CFrame.Position-camera.CFrame.LookVector*T.TestRoom.PreviewDistance
        elseif mode=="DistantArrival" then destination=camera.CFrame.Position+camera.CFrame.LookVector*(V.Quality.MaximumDistance+T.TestRoom.PreviewBeyond) end
        if mode=="SubstituteTriggered" or mode=="GraftReflected" or mode=="PayloadTriggered" then
            presentation:PreviewTrigger(id,mode,origin,destination,target)
        else presentation:PreviewAbility(id,variant,origin,destination,target,cancel) end
    end
    local catalog={}
    for id in pairs(Data.Abilities) do table.insert(catalog,id) end
    local pathwayOrder={Seer=1,Marauder=2,Apprentice=3}
    table.sort(catalog,function(left: string,right: string)
        local a,b=Data.Abilities[left],Data.Abilities[right]
        if a.PathwayId~=b.PathwayId then return pathwayOrder[a.PathwayId]<pathwayOrder[b.PathwayId] end
        return if a.UnlockSequence==b.UnlockSequence then left<right else a.UnlockSequence>b.UnlockSequence
    end)
    local selected=1
    local picker: any
    local function updatePicker()
        local ability=Data.Abilities[catalog[selected]]
        picker.Text="Preview "..selected.."/"..#catalog.." · "..ability.PathwayId.." "..ability.UnlockSequence.." · "..ability.Name
    end
    picker=row("",function() abilityPreview(catalog[selected],"Confirmed") end)
    picker.TextSize=T.Type.Small;picker.TextWrapped=true;updatePicker()
    row("Next ability →",function() selected=selected%#catalog+1;updatePicker() end)
    row("← Previous ability",function() selected=(selected-2)%#catalog+1;updatePicker() end)
    row("Cancel selected windup",function() abilityPreview(catalog[selected],"Confirmed",true) end)
    row("Paper substitute · confirmed trigger",function() abilityPreview("Seer_7_Secondary","Confirmed",false,"SubstituteTriggered") end)
    row("Graft · confirmed reflection",function() abilityPreview("Seer_1","Confirmed",false,"GraftReflected") end)
    row("Payload · confirmed trigger",function() abilityPreview("Marauder_2_Secondary","Confirmed",false,"PayloadTriggered") end)
    for _,id in ipairs(V.Ability.Pilots) do
        row("Ability · "..Data.Abilities[id].Name,function() abilityPreview(id,if id=="Marauder_9" then "Taken" elseif id=="Marauder_6" then "Captured" else "Confirmed") end)
    end
    row("Ability Theft · release stored power",function() abilityPreview("Marauder_6","Released") end)
    row("Cancel windup · no release",function() abilityPreview("Seer_9_Secondary","Confirmed",true) end)
    row("Travel · origin behind camera",function() abilityPreview("Apprentice_5","Confirmed",false,"HiddenOrigin") end)
    row("Travel · arrival beyond 120 studs",function() abilityPreview("Apprentice_5","Confirmed",false,"DistantArrival") end)
    for _,id in ipairs({"Seer_1","Marauder_1","Apprentice_1"}) do
        row("Tier 3 package · "..Data.Abilities[id].PathwayId.." tier 3",function() abilityPreview(id,"Confirmed") end)
    end
    local primitiveNames=table.clone(Blocks.Names)
    for _,name in ipairs(Blocks.AbilityNames) do table.insert(primitiveNames,name) end
    for _,name in ipairs(primitiveNames) do
        for tier=1,#require(Shared.VfxConfig).Tier do
            row(name.." · Tier "..tier,function()
                if not self.Stage then self:StageAtCamera() end
                local grounded=name=="RingBurst" or name=="GroundRune" or name=="ShockwaveRing" or name=="DoorFrame"
                local origin=if grounded then self.Position+Vector3.new(0,T.TestRoom.FloorOffset,0) else self.Position
                local frame=CFrame.new(origin)
                local camera=workspace.CurrentCamera
                if camera and name~="RingBurst" and name~="GroundRune" and name~="ShockwaveRing" then
                    local direction=Vector3.new(camera.CFrame.Position.X-origin.X,0,camera.CFrame.Position.Z-origin.Z)
                    if direction.Magnitude>T.TestRoom.OrientationEpsilon then frame=CFrame.lookAt(origin,origin+direction) end
                end
                presentation.Blocks:Play(name,origin,self.Palette,tier,{Frame=frame,EndPosition=self.Position+Vector3.new(T.TestRoom.TargetOffset,0,0),Target=self.Dummy})
            end)
        end
    end
    local names={}
    for name in pairs(A.Entries) do table.insert(names,name) end;table.sort(names)
    for _,name in ipairs(names) do row("Animation · "..name,function() presentation:DemoAnimation(name) end) end
    row("Stop animation preview",function() presentation:StopDemoAnimation() end)
    row("Camera · small hit",function() presentation.Camera:Kick(1);presentation.Camera:HitStop() end)
    row("Camera · major cast",function() presentation.Camera:Kick(#require(Shared.VfxConfig).Tier) end)
    row("Confirmed hit preview",function()
        if not self.Dummy then self:StageAtCamera() end
        presentation.Hits:Hit({Target=self.Dummy,Position=self.Position})
        callbacks.Damage({Owner=game:GetService("Players").LocalPlayer.UserId,Position=self.Position,Amount=T.TestRoom.PreviewDamage})
    end)
    row("Death dissolve preview",function()
        if not self.Dummy then self:StageAtCamera() end
        presentation.Hits:Death(self.Dummy,self.Position)
    end)
    self.Status=Kit.Text(self.Root,"",T.Type.Micro,T.Fonts.Number)
    self.Status.Position=UDim2.new(0,T.TestRoom.Pad,1,-T.TestRoom.StatusHeight)
    self.Status.Size=UDim2.new(1,-T.TestRoom.Pad*2,0,T.TestRoom.StatusHeight)
    return self
end
function TestRoom.StageAtCamera(self: any)
    if self.Stage then self.Stage:Destroy();self.Stage=nil;self.Dummy=nil end
    local camera=workspace.CurrentCamera
    if not camera then return end
    local center=camera.CFrame.Position+camera.CFrame.LookVector*T.TestRoom.PreviewDistance+Vector3.new(0,T.TestRoom.PreviewHeight,0)
    self.Position=center
    self.Stage=Kit.New("Folder",workspace,{Name="LocalVfxPreviewStage"})
    local size=T.TestRoom.FloorSize
    Kit.New("Part",self.Stage,{Name="PreviewFloor",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(size[1],size[2],size[3]),Position=center+Vector3.new(0,T.TestRoom.FloorOffset,0),
        Color=T.Colors.Ink,Transparency=T.TestRoom.FloorAlpha,CastShadow=false})
    self.Dummy=Kit.New("Model",self.Stage,{Name="Local preview mannequin"})
    local body=Kit.New("Part",self.Dummy,{Name="Torso",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(size[4],size[5],size[6]),Position=center,Color=T.Colors.Slate,CastShadow=false})
    self.Dummy.PrimaryPart=body
    local doorSize=T.TestRoom.PreviewDoorSize
    local doorCenter=center+camera.CFrame.RightVector*T.TestRoom.AbilityOffset+Vector3.yAxis*(T.TestRoom.FloorOffset+doorSize[2]/2)
    local toward=Vector3.new(camera.CFrame.Position.X-doorCenter.X,0,camera.CFrame.Position.Z-doorCenter.Z)
    local doorFrame=if toward.Magnitude>T.TestRoom.OrientationEpsilon then CFrame.lookAt(doorCenter,doorCenter+toward) else CFrame.new(doorCenter)
    self.PreviewDoor=Kit.New("Part",self.Stage,{Name="LocalPreviewDoor",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.new(doorSize[1],doorSize[2],doorSize[3]),CFrame=doorFrame,Color=T.Colors.Slate,Transparency=T.TestRoom.FloorAlpha,CastShadow=false})
    Kit.New("Part",self.Dummy,{Name="Head",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
        Size=Vector3.one*T.TestRoom.HeadSize,Position=center+Vector3.new(0,T.TestRoom.HeadHeight,0),Color=T.Colors.Muted,CastShadow=false})
    Kit.New("Humanoid",self.Dummy,{RequiresNeck=false,DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None})
end
function TestRoom.Resize(self: any,width: number,height: number)
    self.Root.Size=UDim2.fromOffset(math.min(T.TestRoom.Width,width-T.TestRoom.Margin*2),math.min(T.TestRoom.Height,height-T.TestRoom.Margin*2))
    self.Root.Position=UDim2.new(1,-T.TestRoom.Margin,0,T.TestRoom.Margin);self.Root.AnchorPoint=Vector2.new(1,0)
end
function TestRoom.Toggle(self: any,allowed: boolean)
    if not allowed or not RunService:IsStudio() then self:Close();return end
    if self.Root.Visible then self:Close();return end
    self.Root.Visible=true;self:StageAtCamera();self.Callbacks.Modal(true)
end
function TestRoom.Close(self: any)
    self.Root.Visible=false
    if self.Stage then self.Stage:Destroy();self.Stage=nil;self.Dummy=nil end
    if self.GrayEffect then self.GrayEffect:Destroy();self.GrayEffect=nil end
    self.Gray=false;self.GrayButton.Text="Silhouette view: color"
    self.Presentation:StopDemoAnimation();self.Callbacks.Modal(false)
end
function TestRoom.Step(self: any,dt: number)
    if not self.Root.Visible then return end
    self.Elapsed+=dt
    if self.Elapsed<T.TestRoom.StatInterval then return end;self.Elapsed=0
    local stats=self.Presentation.VFX:Stats()
    local profile=self.Presentation.VFX:Profile()
    local allocated=0;local reserved=0
    for _,count in pairs(stats.Allocated) do allocated+=count end
    for _,count in pairs(stats.Reserved) do reserved+=count end
    self.Status.Text="Active "..stats.Active.." / "..profile.MaxEffects.." · dropped "..stats.Dropped.." · evicted "..stats.Evicted.."\n"..
        (if profile.Mobile then "Mobile" else "Desktop").." · quality "..profile.Level.." · detail "..string.format("%.2f",profile.Detail)..
        "\nInstances "..allocated.." allocated · "..reserved.." reserved · errors "..stats.Errors
end
return TestRoom
