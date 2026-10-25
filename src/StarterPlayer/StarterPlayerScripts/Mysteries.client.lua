--!strict
-- Entry LocalScript. All Phase 1 visual tokens live in ReplicatedStorage.Shared.Theme.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local shared=ReplicatedStorage:WaitForChild("Shared")
local data=require(shared:WaitForChild("GameData"))
local T=require(shared:WaitForChild("Theme"))
local Layout=require(shared:WaitForChild("VisualLayout"))
local UI=script.Parent:WaitForChild("UI")
local Kit=require(UI.Kit)
local Hud=require(UI.Hud)
local Menus=require(UI.Menus)
local Prompts=require(UI.Prompts)
local Feedback=require(UI.Feedback)
local Developer=require(UI.Developer)
local Presentation=require(UI.Presentation)
local VfxTestRoom=require(script.Parent.Visuals.VfxTestRoom)
local remotes=ReplicatedStorage:WaitForChild("MysteriesRemotes")
local intent=remotes:WaitForChild("Intent") :: RemoteEvent
local stateEvent=remotes:WaitForChild("State") :: RemoteEvent
local effectEvent=remotes:WaitForChild("Effect") :: RemoteEvent
-- Preserve the working third-person camera for Phase 1; camera feel is revised in Phase 4.
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=T.Camera.MinZoom;player.CameraMaxZoomDistance=T.Camera.MaxZoom
local old=player:WaitForChild("PlayerGui"):FindFirstChild("MysteriesHUD")
if old then old:Destroy() end
local gui=Kit.New("ScreenGui",player.PlayerGui,{Name="MysteriesHUD",ResetOnSpawn=false,IgnoreGuiInset=false,
    ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets,ClipToDeviceSafeArea=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local safeRoot=Kit.New("Frame",gui,{Name="SafeArea",Size=UDim2.fromScale(1,1),BackgroundTransparency=1})
local state: any=nil
local modal=false
local menuModal=false
local roomModal=false
local cinematic=false
local menus: any=nil
local hud: any=nil
local presentation: any=nil
local testRoom: any=nil
local developer: any=nil
local promptUI=Prompts.new(safeRoot)
local function send(action: string,payload: any) intent:FireServer(action,payload) end
local function touchAim(): boolean
    return not modal and UserInputService.TouchEnabled and (not UserInputService.MouseEnabled
        or (hud and hud.Layout and hud.Layout.Name~="Desktop") or UserInputService:GetLastInputType()==Enum.UserInputType.Touch)
end
local function aim(): any
    local camera=workspace.CurrentCamera
    if not camera then return {} end
    local point=UserInputService:GetMouseLocation()
    local ray: Ray
    if touchAim() then
        local center=camera.ViewportSize/2
        ray=camera:ViewportPointToRay(center.X,center.Y)
    else ray=camera:ScreenPointToRay(point.X,point.Y) end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    if player.Character then params.FilterDescendantsInstances={player.Character} end
    local hit=workspace:Raycast(ray.Origin,ray.Direction*T.Input.RayLength,params)
    local target: Instance?=hit and hit.Instance or nil
    while target and target~=workspace do
        if target:IsA("Model") and target:FindFirstChildOfClass("Humanoid") then break end
        target=target.Parent
    end
    return {Position=if hit then hit.Position else ray.Origin+ray.Direction*T.Input.FallbackAim,Target=if target==workspace then nil else target}
end
local function cast(slot: number)
    if modal or not state or not state.Ready or state.Dead then return end
    local id=state.Loadout[slot]
    if not id then return end
    local payload=aim();payload.Id=id;send("Cast",payload)
end
local function melee()
    if not modal and state and state.Ready and not state.Dead then send("Melee",aim()) end
end
local feedback=Feedback.new(safeRoot,data,function(active: boolean)
    cinematic=active
    if hud then hud.Wordmark.Visible=not active and not promptUI.Root.Visible;hud.Pathway.Visible=not active and not promptUI.Root.Visible end
end)
hud=Hud.new(safeRoot,data,{Cast=cast,Melee=melee,Touch=UserInputService.TouchEnabled,TouchAim=touchAim,Journal=function(tab: string)
    if roomModal then return end
    if menus.Root.Visible and menus.Tab==tab and menus.View=="Page" then menus:Close() else menus:Open(tab) end
end})
local function updateModal()
    modal=menuModal or roomModal;promptUI:SetModal(modal);hud.Tooltip.Visible=false
    if developer then developer:SetSuppressed(modal) end
end
local function visualSettings(reduced: boolean,low: boolean)
    feedback:SetReducedMotion(reduced)
    if presentation then presentation:SetSettings(reduced,low) end
    if testRoom then
        testRoom.Reduced=reduced;testRoom.Low=low
        testRoom.ReducedButton.Text="Reduced motion: "..(if reduced then "on" else "off")
        testRoom.LowButton.Text="Low graphics: "..(if low then "on" else "off")
    end
end
menus=Menus.new(safeRoot,data,{Intent=send,Modal=function(open: boolean)
    menuModal=open;updateModal()
end,ReducedMotion=function(reduced: boolean) visualSettings(reduced,menus.LowGraphics) end,
    LowGraphics=function(low: boolean) visualSettings(menus.ReducedMotion,low) end})
presentation=Presentation.new(gui,data,{Damage=function(event: any) feedback:Damage(event) end,
    CastVisual=function(event: any) hud:SetVisualCast(event) end,
    ScreenEdgePulse=function() feedback:Flash() end})
testRoom=VfxTestRoom.new(safeRoot,presentation,{Modal=function(open: boolean) roomModal=open;updateModal() end,
    ReducedMotion=function(reduced: boolean) menus.ReducedMotion=reduced;visualSettings(reduced,menus.LowGraphics) end,
    LowGraphics=function(low: boolean) menus.LowGraphics=low;visualSettings(menus.ReducedMotion,low) end,
    Damage=function(event: any) feedback:Damage(event) end})
developer=Developer.new(safeRoot,send,if RunService:IsStudio() then function()
    if menus.Root.Visible then menus:Close() end
    testRoom:Toggle(developer.Allowed);developer.Root.Visible=false
end else nil)
promptUI.OnVisibility=function(visible: boolean)
    hud.Pathway.Visible=not visible and not cinematic;hud.Wordmark.Visible=not visible and not cinematic
end
promptUI.Exclusions={hud.Pathway,hud.Cast,feedback.Notice,feedback.Advance,developer.Root}
local function resize()
    local size=safeRoot.AbsoluteSize
    if size.X<=0 or size.Y<=0 then return end
    local layout=Layout.Resolve(T,size.X,size.Y,UserInputService.TouchEnabled)
    hud:Resize(layout);menus:Resize(layout);feedback:Resize(layout);developer:Resize(layout);promptUI.Layout=layout
    testRoom:Resize(size.X,size.Y)
    hud.Wordmark.Visible=not cinematic and not promptUI.Root.Visible;hud.Pathway.Visible=not cinematic and not promptUI.Root.Visible
    if menus.Root.Visible then menus:Render() end
end
safeRoot:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(resize)
stateEvent.OnClientEvent:Connect(function(update: any)
    if type(update)~="table" then return end
    if update.Message then
        feedback:Tell(update.Message)
        if menus.Waiting and not menus.Purchase then menus:Close() end
        return
    end
    if update.Menu=="Altar" then menus:Altar(update.ExpiresIn or T.Timing.AltarExpiry);return end
    if update.Purchase then
        Kit.Sound(gui,if update.Purchase.Ok then "Confirm" else "Reject")
        menus:Close();feedback:Tell(update.Purchase.Message,not update.Purchase.Ok);return
    end
    state=update
    developer:Update(update);hud:Render(update,os.clock());menus:Update(update);feedback:Update(update)
    presentation:Update(update)
    if not developer.Allowed and testRoom.Root.Visible then testRoom:Close() end
    if update.Dead and menus.Root.Visible then menus:Close() end
end)
effectEvent.OnClientEvent:Connect(function(event: any)
    if type(event)~="table" or typeof(event.Position)~="Vector3" or type(event.Kind)~="string" then return end
    presentation:Event(event)
end)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==T.Input.Developer then
        if testRoom.Root.Visible then testRoom:Close() else developer:Toggle() end
        return
    end
    if processed then return end
    if input.KeyCode==T.Input.Journal then
        if roomModal then return end
        if menus.Root.Visible then menus:Close() else menus:Open("Journal") end
        return
    end
    if input.KeyCode==Enum.KeyCode.Escape then
        if testRoom.Root.Visible then testRoom:Close();return end
        if menus.Root.Visible then menus:Close();return end
    end
    if modal then return end
    -- E belongs to an active prompt, preventing a simultaneous slot-2 cast.
    if promptUI.Current and input.KeyCode==promptUI.Current.KeyboardKeyCode then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then melee();return end
    for i,key in ipairs(T.Input.Keys) do if input.KeyCode==key then cast(i);return end end
end)
local accumulator=0
RunService.Heartbeat:Connect(function(dt: number)
    presentation:Step(dt);testRoom:Step(dt)
    accumulator+=dt
    if accumulator<T.Timing.Step then return end
    accumulator=0
    local now=os.clock()
    hud:Step(now);menus:Step(now);feedback:Step(now)
    feedback.Notice.Visible=now<(feedback.NoticeUntil or 0) and not hud.Cast.Visible and not cinematic and not modal
    hud.Wordmark.Visible=not cinematic and not promptUI.Root.Visible and not feedback.Notice.Visible and not hud.Cast.Visible
end)
resize()
send("Sync",{})
script.Destroying:Connect(function() testRoom:Close();presentation:Destroy() end)
