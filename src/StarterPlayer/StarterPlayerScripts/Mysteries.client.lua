--!strict
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local player=Players.LocalPlayer
local data=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))
local remotes=ReplicatedStorage:WaitForChild("MysteriesRemotes")
local intent=remotes:WaitForChild("Intent") :: RemoteEvent
local stateEvent=remotes:WaitForChild("State") :: RemoteEvent
local effectEvent=remotes:WaitForChild("Effect") :: RemoteEvent
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=8;player.CameraMaxZoomDistance=32
local gui=Instance.new("ScreenGui");gui.Name="MysteriesHUD";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=false;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Parent=player:WaitForChild("PlayerGui")
local canvas=Instance.new("Frame");canvas.Name="Canvas";canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=gui
local textColor=Color3.fromRGB(232,232,242)
local background=Color3.fromRGB(22,24,36)
local accent=Color3.fromRGB(153,137,210)
local function corner(parent: Instance,radius: number?)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius or 8);c.Parent=parent
end
local function frame(parent: Instance,size: UDim2,position: UDim2): Frame
    local f=Instance.new("Frame");f.Size=size;f.Position=position;f.BackgroundColor3=background;f.BackgroundTransparency=0.12;f.BorderSizePixel=0;f.Parent=parent;corner(f);return f
end
local function label(parent: Instance,text: string,size: UDim2,pos: UDim2,fontSize: number?): TextLabel
    local t=Instance.new("TextLabel");t.Size=size;t.Position=pos;t.BackgroundTransparency=1;t.TextColor3=textColor;t.Text=text;t.Font=Enum.Font.Gotham;t.TextSize=fontSize or 14;t.TextXAlignment=Enum.TextXAlignment.Left;t.TextWrapped=true;t.Parent=parent;return t
end
local function button(parent: Instance,text: string,size: UDim2,pos: UDim2,callback: () -> ()): TextButton
    local b=Instance.new("TextButton");b.Size=size;b.Position=pos;b.Text=text;b.BackgroundColor3=Color3.fromRGB(60,53,88);b.BorderSizePixel=0;b.TextColor3=textColor;b.Font=Enum.Font.GothamMedium;b.TextSize=13;b.TextWrapped=true;b.AutoButtonColor=true;b.Parent=parent;corner(b,6);b.Activated:Connect(callback);return b
end
local state: any=nil
local receivedAt=0
local selectedSlot=1
local lastPageKey=""
local noticeSerial=0
local hud=frame(canvas,UDim2.fromOffset(300,192),UDim2.fromOffset(12,12))
label(hud,"MYSTERIES",UDim2.new(1,-20,0,25),UDim2.fromOffset(10,6),19)
local modeLabel=label(hud,"Loading your session…",UDim2.new(1,-20,0,20),UDim2.fromOffset(10,31),12)
local bars={}
for i,spec in ipairs({{Key="Health",Name="HP",Color=Color3.fromRGB(199,83,104)},
    {Key="Spirituality",Name="Spirituality",Color=Color3.fromRGB(91,159,207)},
    {Key="Sanity",Name="Sanity",Color=Color3.fromRGB(164,142,211)}}) do
    local base=frame(hud,UDim2.new(1,-20,0,24),UDim2.fromOffset(10,56+(i-1)*30));base.BackgroundColor3=Color3.fromRGB(41,42,58)
    local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(1,1);fill.BackgroundColor3=spec.Color;fill.BorderSizePixel=0;fill.Parent=base;corner(fill,6)
    local text=label(base,spec.Name,UDim2.fromScale(1,1),UDim2.fromOffset(6,0),12)
    bars[spec.Key]={Fill=fill,Label=text,Name=spec.Name}
end
local gold=label(hud,"Gold 0  ·  Wishes 0",UDim2.new(1,-20,0,22),UDim2.fromOffset(10,150),12)
local statuses=label(hud,"",UDim2.new(1,-20,0,20),UDim2.fromOffset(10,171),11)
local progress=frame(canvas,UDim2.fromOffset(300,142),UDim2.fromOffset(12,212))
local sequenceLabel=label(progress,"Uninitiated",UDim2.new(1,-20,0,24),UDim2.fromOffset(10,5),16)
local digestionLabel=label(progress,"Digestion 0%",UDim2.new(1,-20,0,20),UDim2.fromOffset(10,31),13)
local objective=label(progress,"Open the journal to choose your starting potion.",UDim2.new(1,-20,0,68),UDim2.fromOffset(10,55),12)
local journal=frame(canvas,UDim2.fromOffset(390,430),UDim2.new(1,-402,0,12));journal.Visible=false
label(journal,"BEYONDER JOURNAL",UDim2.new(1,-60,0,30),UDim2.fromOffset(12,6),17)
button(journal,"×",UDim2.fromOffset(28,28),UDim2.new(1,-36,0,5),function() journal.Visible=false end)
local inventoryText=label(journal,"Potion inventory",UDim2.new(1,-20,0,46),UDim2.fromOffset(10,40),12)
local potionButtons={}
for index,path in ipairs({"Seer","Marauder","Apprentice"}) do
    potionButtons[path]=button(journal,"Drink "..path,UDim2.fromOffset(118,38),UDim2.fromOffset(10+(index-1)*126,90),function()
        if not state or not state.Ready then return end
        intent:FireServer("Drink",{Id=path.."_Potion_9"})
    end)
end
local drinkNext=button(journal,"Drink next potion",UDim2.new(1,-20,0,34),UDim2.fromOffset(10,136),function()
    if state and state.PathwayId and state.Sequence>1 then
        intent:FireServer("Drink",{Id=state.PathwayId.."_Potion_"..tostring(state.Sequence-1)})
    end
end)
local slotLabel=label(journal,"Select a hotbar slot, then equip an ability:",UDim2.new(1,-20,0,30),UDim2.fromOffset(10,178),12)
local selectors={}
for i=1,6 do
    selectors[i]=button(journal,tostring(i),UDim2.fromOffset(48,26),UDim2.fromOffset(10+(i-1)*62,210),function() selectedSlot=i end)
end
local list=Instance.new("ScrollingFrame");list.Name="AbilityLibrary";list.Size=UDim2.new(1,-20,0,150);list.Position=UDim2.fromOffset(10,246);list.BackgroundTransparency=1;list.BorderSizePixel=0;list.ScrollBarThickness=5;list.AutomaticCanvasSize=Enum.AutomaticSize.Y;list.CanvasSize=UDim2.new();list.Parent=journal
local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,5);layout.Parent=list
label(journal,"Lore review pending · original gameplay adaptations",UDim2.new(1,-20,0,24),UDim2.fromOffset(10,401),10)
button(canvas,"Journal [B]",UDim2.fromOffset(150,34),UDim2.new(1,-162,1,-128),function() journal.Visible=not journal.Visible end)
local meleeButton=button(canvas,"Strike [click]",UDim2.fromOffset(150,34),UDim2.new(1,-162,1,-88),function() end)
local hotbar=frame(canvas,UDim2.fromOffset(620,78),UDim2.new(0.5,-310,1,-86))
local keys={Enum.KeyCode.Q,Enum.KeyCode.E,Enum.KeyCode.R,Enum.KeyCode.F,Enum.KeyCode.Z,Enum.KeyCode.X}
local keyNames={"Q","E","R","F","Z","X"}
local hotButtons={}
local function aim(): any
    local camera=workspace.CurrentCamera
    if not camera then return {} end
    local point=UserInputService:GetMouseLocation()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then point=camera.ViewportSize/2 end
    local ray=camera:ScreenPointToRay(point.X,point.Y)
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    if player.Character then params.FilterDescendantsInstances={player.Character} end
    local hit=workspace:Raycast(ray.Origin,ray.Direction*500,params)
    local target=nil
    if hit then
        local ancestor: Instance?=hit.Instance
        while ancestor and ancestor~=workspace do
            if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then target=ancestor;break end
            ancestor=ancestor.Parent
        end
    end
    return {Position=if hit then hit.Position else ray.Origin+ray.Direction*50,Target=target}
end
local function cast(slot: number)
    if not state or not state.Ready or state.Dead then return end
    local id=state.Loadout[slot]
    if not id then return end
    local input=aim();input.Id=id
    intent:FireServer("Cast",input)
end
local function melee()
    if state and state.Ready then intent:FireServer("Melee",aim()) end
end
meleeButton.Activated:Connect(melee)
for i=1,6 do
    hotButtons[i]=button(hotbar,keyNames[i].."\n—",UDim2.fromOffset(94,62),UDim2.fromOffset(10+(i-1)*102,8),function() cast(i) end)
end
local notice=label(canvas,"Welcome. Open the journal [B] to choose a potion.",UDim2.fromOffset(590,52),UDim2.new(0.5,-295,1,-146),14)
notice.TextXAlignment=Enum.TextXAlignment.Center;notice.TextStrokeTransparency=0.3
local function tell(text: string)
    noticeSerial+=1;local serial=noticeSerial;notice.Text=text
    task.delay(6,function() if serial==noticeSerial then notice.Text="" end end)
end
local function rebuildLibrary()
    for _,child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    if not state or not state.PathwayId then return end
    local ids={}
    for id,a in pairs(data.Abilities) do
        if a.PathwayId==state.PathwayId and state.Sequence<=a.UnlockSequence then table.insert(ids,id) end
    end
    table.sort(ids,function(a,b)
        local aa,bb=data.Abilities[a],data.Abilities[b]
        return if aa.UnlockSequence==bb.UnlockSequence then a<b else aa.UnlockSequence<bb.UnlockSequence
    end)
    for _,id in ipairs(ids) do
        local a=data.Abilities[id]
        local b=button(list,"Seq "..a.UnlockSequence.." · "..a.Name.."   ["..a.SpiritualityCost.."]",UDim2.new(1,-8,0,32),UDim2.new(),function()
            intent:FireServer("Equip",{Id=id,Slot=selectedSlot})
        end)
        b.LayoutOrder=(a.UnlockSequence*100)+#list:GetChildren()
    end
end
local madness=Instance.new("ColorCorrectionEffect");madness.Name="MysteriesSanity";madness.Enabled=false;madness.Parent=Lighting
stateEvent.OnClientEvent:Connect(function(update)
    if type(update)~="table" then return end
    if update.Message then tell(update.Message);return end
    state=update;receivedAt=os.clock()
    if not update.Ready then modeLabel.Text="Loading save safely…";return end
    modeLabel.Text=(if update.SessionOnly then "STUDIO SESSION · not saved" else "Persistent session").." · "..update.Mode
    gold.Text="Gold "..tostring(update.Gold).."  ·  Wishes "..tostring(update.WishCredits).."  ·  Recordings "..tostring(update.RecordedCharges)
    statuses.Text=table.concat(update.Statuses,", ")
    madness.Enabled=update.Mode~="Normal" or update.Sanity<20
    madness.TintColor=if update.Mode=="LostControl" then Color3.fromRGB(170,130,180) else Color3.fromRGB(240,180,195)
    madness.Saturation=if update.Mode=="Normal" then -0.25 else -0.65
    if update.PathwayId then
        local path=data.Pathways[update.PathwayId];local seq=path.Sequences[update.Sequence]
        sequenceLabel.Text=path.Alias.." · Seq "..update.Sequence.." "..seq.Name
        objective.Text="Acting: "..seq.ActingObjectives[1].Label.."\nProgress "..tostring(update.ActingProgress).." · next potion at 100%"
        digestionLabel.Text=string.format("Digestion %.1f%%",update.Digestion)
        inventoryText.Text="Buy the next potion at the sanctuary altar (100 gold). Stabilization costs 20 digestion."
        local nextId=update.PathwayId.."_Potion_"..tostring(update.Sequence-1)
        drinkNext.Text=if update.Sequence==1 then "Highest available sequence reached" else "Drink next potion · owned "..tostring(update.Inventory[nextId] or 0)
    else
        sequenceLabel.Text="Uninitiated · choose your pathway"
        objective.Text="Drink one starting potion in the journal. Your chosen pathway is permanent."
        inventoryText.Text="Choose ONE starting potion below. All later potions must follow that pathway."
    end
    for path,b in pairs(potionButtons) do b.Visible=update.PathwayId==false;b.Text="Drink "..path.." ("..tostring(update.Inventory[path.."_Potion_9"] or 0)..")" end
    local pageKey=tostring(update.PathwayId)..":"..tostring(update.Sequence)
    if pageKey~=lastPageKey then lastPageKey=pageKey;rebuildLibrary() end
    for key,bar in pairs(bars) do
        local max=if key=="Sanity" then 100 else update["Max"..key]
        local value=update[key]
        bar.Label.Text=bar.Name.." "..math.ceil(value).." / "..math.ceil(max)
        TweenService:Create(bar.Fill,TweenInfo.new(0.2),{Size=UDim2.fromScale(math.clamp(value/max,0,1),1)}):Play()
    end
end)
UserInputService.InputBegan:Connect(function(input,processed)
    if processed or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.B then journal.Visible=not journal.Visible;return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then melee();return end
    for i,key in ipairs(keys) do if input.KeyCode==key then cast(i);return end end
end)
-- Fixed-rate text refresh, not a RenderStepped world scan.
task.spawn(function()
    while gui.Parent do
        task.wait(0.1)
        for i,b in ipairs(hotButtons) do
            local id=state and state.Ready and state.Loadout[i]
            local a=id and data.Abilities[id]
            local remaining=if id and state.Cooldowns[id] then math.max(0,state.Cooldowns[id]-(os.clock()-receivedAt)) else 0
            b.Text=keyNames[i].." · "..(a and a.Name or "Empty")..(if remaining>0 then string.format("\n%.1fs",remaining) else "")
            b.BackgroundColor3=if remaining>0 then Color3.fromRGB(42,43,54) else Color3.fromRGB(60,53,88)
            selectors[i].BackgroundColor3=if selectedSlot==i then accent else Color3.fromRGB(60,53,88)
        end
        slotLabel.Text="Equip an ability in hotbar slot "..selectedSlot..":"
    end
end)
-- Pooled original neon pulses and highlights. No downloaded VFX/audio assets.
local pool={};local active=0
local fxFolder=Instance.new("Folder");fxFolder.Name="LocalMysteriesFX";fxFolder.Parent=workspace
local function pulse(position: Vector3,kind: string)
    if active>=data.Runtime.MaxVFX then return end
    local p: Part=table.remove(pool) or Instance.new("Part")
    p.Shape=Enum.PartType.Ball;p.Material=Enum.Material.Neon;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
    active+=1;p.Size=Vector3.one;p.CFrame=CFrame.new(position);p.Color=if string.find(kind,"Marauder") then Color3.fromRGB(230,178,85) elseif string.find(kind,"Apprentice") then Color3.fromRGB(110,167,240) else Color3.fromRGB(170,130,225)
    p.Transparency=0.25;p.Parent=fxFolder
    local tween=TweenService:Create(p,TweenInfo.new(0.5),{Size=Vector3.new(7,7,7),Transparency=1})
    tween:Play()
    tween.Completed:Once(function() active-=1;p.Parent=nil;table.insert(pool,p) end)
end
local highlights={}
local highlightCount=0
local highlightPool={}
local soundActive=0
local function audio(hook: string,pitch: number?)
    local id=data.Runtime.AudioAssets[hook]
    if type(id)~="number" or id<=0 or soundActive>=8 then return end
    soundActive+=1
    local sound=Instance.new("Sound");sound.SoundId="rbxassetid://"..tostring(math.floor(id));sound.Volume=0.4;sound.PlaybackSpeed=math.clamp(pitch or 1,0.5,2);sound.Parent=gui
    sound:Play()
    task.delay(8,function() sound:Destroy();soundActive-=1 end)
end
effectEvent.OnClientEvent:Connect(function(event)
    if type(event)~="table" or typeof(event.Position)~="Vector3" or type(event.Kind)~="string" then return end
    if event.Kind=="VoiceProfile" then
        audio(event.Hook,event.Pitch);return
    end
    local ability=data.Abilities[event.Kind]
    if ability then audio(ability.SFXHook) end
    if event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        if highlights[event.Target] or highlightCount>=data.Runtime.MaxVFX then return end
        local h=table.remove(highlightPool) or Instance.new("Highlight")
        h.Adornee=event.Target;h.FillColor=Color3.fromRGB(150,130,230);h.FillTransparency=0.6;h.Parent=fxFolder;h.Enabled=true
        highlights[event.Target]=h;highlightCount+=1
        task.delay(5,function()
            highlights[event.Target]=nil;highlightCount-=1;h.Enabled=false;h.Adornee=nil;h.Parent=nil;table.insert(highlightPool,h)
        end)
    else pulse(event.Position,event.Kind) end
end)
local function resize()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local size=camera.ViewportSize
    local scale=math.clamp(size.X/1050,0.5,1)
    for _,f in ipairs({hud,progress,journal,hotbar}) do
        local ui=f:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        ui.Scale=scale;ui.Parent=f
    end
    hotbar.AnchorPoint=Vector2.new(0.5,1);hotbar.Position=UDim2.new(0.5,0,1,-8)
    journal.AnchorPoint=Vector2.new(1,0);journal.Position=UDim2.new(1,-12,0,12)
    progress.Position=UDim2.fromOffset(12,12+200*scale)
end
local viewportConnection: RBXScriptConnection?=nil
local function bindCamera()
    if viewportConnection then viewportConnection:Disconnect() end
    local camera=workspace.CurrentCamera
    if camera then viewportConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    resize()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera);bindCamera()
intent:FireServer("Sync",{})
