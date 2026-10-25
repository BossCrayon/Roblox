--!strict
-- Pure layout/model/access checks plus GUI lifecycle smoke tests with explicit Roblox stand-ins.
-- This does not render text, emulate safe insets, or certify appearance in Studio.
return function(data: any,load: any,sharedNode: any)
    local checks=0
    local function check(value,message) assert(value,message);checks+=1 end
    local namespaces={}
    local enum=setmetatable({},{__index=function(_,namespace)
        if not namespaces[namespace] then
            local values={}
            namespaces[namespace]=setmetatable({},{__index=function(_,key)
                if not values[key] then values[key]={Name=key,Value=0} end
                return values[key]
            end})
        end
        return namespaces[namespace]
    end})
    local colorMethods={}
    function colorMethods:Lerp(other,t) return setmetatable({R=self.R+(other.R-self.R)*t,G=self.G+(other.G-self.G)*t,B=self.B+(other.B-self.B)*t},{__index=colorMethods}) end
    local color={fromRGB=function(r,g,b) return setmetatable({R=r/255,G=g/255,B=b/255},{__index=colorMethods}) end}
    local T=load("Theme",{Color3=color,Enum=enum})
    local Layout=load("VisualLayout",{})
    local Model=load("VisualModel",{})
    local Access=load("Server/Domain/VisualAccess",{})
    local cases={{1920,1044,false},{1280,684,false},{1024,732,false},{834,1150,true},{768,988,true},{390,760,true},{320,484,true},{844,310,true},{640,280,true}}
    for _,c in ipairs(cases) do
        local l=Layout.Resolve(T,c[1],c[2],c[3])
        for _,r in ipairs({l.Resources,l.Hotbar,l.Wordmark,l.Journal,l.Modal,l.Confirm}) do
            check(r.X>=0 and r.Y>=0 and r.X+r.W<=c[1] and r.Y+r.H<=c[2],"Layout within safe root: "..c[1].."x"..c[2])
        end
        check(l.Profile.Slot>=44,"Touch targets stay usable")
        check(not Layout.Intersects(l.Resources,l.Hotbar),"Vitals and hotbar do not overlap")
        check(not Layout.Intersects(l.Resources,l.Wordmark),"Vitals and masthead do not overlap: "..c[1].."x"..c[2])
        check(not Layout.Intersects(l.Hotbar,l.Journal),"Journal stays clear of hotbar")
        if c[3] then
            check(not Layout.Intersects(l.Action,l.Hotbar),"Strike stays clear of hotbar")
            check(not Layout.Intersects(l.Action,l.Notice),"Strike stays clear of notices")
            check(l.Notice.Y>=0 and l.Notice.X>=0,"Compact notices stay in safe area")
        end
        local p=l.Pathway
        check(not Layout.Intersects({X=p.X,Y=p.Y,W=p.W,H=l.Profile.PathwayCollapsed},l.Hotbar),"Collapsed pathway clears hotbar")
    end
    local function luminance(c)
        local function f(v) return if v<=0.04045 then v/12.92 else ((v+0.055)/1.055)^2.4 end
        return 0.2126*f(c.R)+0.7152*f(c.G)+0.0722*f(c.B)
    end
    for _,text in ipairs({T.Colors.Text,T.Colors.Muted,T.Colors.Danger}) do
        for _,back in ipairs({T.Colors.Ink,T.Colors.Slate}) do
            local hi,lo=math.max(luminance(text),luminance(back)),math.min(luminance(text),luminance(back))
            check((hi+0.05)/(lo+0.05)>=4.5,"Opaque text colors meet 4.5:1")
        end
    end
    check(not pcall(function() T.Colors.Ink.R=0 end),"Theme is deeply immutable")
    check(Access.IsDeveloper(7,7,true,{}),"Individual creator authorized")
    check(not Access.IsDeveloper(7,7,false,{}),"Group ownership is not individual authorization")
    check(not Access.IsDeveloper(-1,0,true,{-1}),"Studio synthetic negative IDs get no implicit privilege")
    check(Access.IsDeveloper(9,7,false,{9}),"Server allowlist authorized")
    check(not Access.IsDeveloper(9,7,true,{8}),"Other users are denied")
    local ticket={ExpiresAt=115,PathwayId="Seer",Sequence=9}
    check(Access.AltarValid(ticket,100,8,"Seer",9,12),"Valid altar invitation")
    check(not Access.AltarValid(ticket,116,8,"Seer",9,12),"Expired altar invitation rejected")
    check(not Access.AltarValid(ticket,100,13,"Seer",9,12),"Leaving altar invalidates purchase")
    check(not Access.AltarValid(ticket,100,8,"Seer",8,12),"Sequence changes invalidate old preview")
    check(not Access.AltarValid(ticket,100,0/0,"Seer",9,12),"NaN distance rejected")
    local state={Ready=true,PathwayId=false,Sequence=false,Digestion=0,ActingProgress=0,Health=100,MaxHealth=100,
        Spirituality=50,MaxSpirituality=50,Sanity=100,Mode="Normal",Gold=0,WishCredits=0,Dead=false,Casting=false,
        Inventory={Seer_Potion_9=1,Marauder_Potion_9=1,Apprentice_Potion_9=1},Loadout={},Cooldowns={}}
    check(Model.Potion(data,state,"Seer_Potion_9",false).Allowed,"Starter preview usable")
    check(not Model.Potion(data,state,nil,true).Allowed,"Uninitiated cannot buy next potion")
    state.PathwayId="Seer";state.Sequence=9
    check(not Model.Potion(data,state,"Marauder_Potion_9",false).Allowed,"UI never offers pathway switching")
    state.Inventory.Seer_Potion_8=1
    check(not Model.Potion(data,state,"Seer_Potion_8",false).Allowed,"Early drinking disabled")
    state.Digestion=100;check(Model.Potion(data,state,"Seer_Potion_8",false).Allowed,"Ready potion enabled")
    state.Sanity=20;check(not Model.Potion(data,state,"Seer_Potion_8",false).Allowed,"Low-sanity preview blocked")
    state.Sanity=100;state.Inventory.Seer_Potion_8=0;state.Gold=100
    check(Model.Potion(data,state,"Seer_Potion_8",true).Allowed,"Purchase does not require drinking immediately")
    check(#Model.Unlocked(data,state)==2,"Only unlocked powers listed")
    state.Sequence=1;check(#Model.Unlocked(data,state)==18 and Model.NextPotion(state)==nil,"Top sequence has all earlier abilities and no Sequence 0")
    state.Sequence=9;state.Loadout={[1]="Seer_9"};state.Cooldowns.Seer_9=2.5
    check(Model.Cooldown(state,"Seer_9",3)==0,"Cooldown countdown clamps to zero")
    -- Minimal UI engine stand-ins exercise actual component construction and updates.
    local now=100;local tasks={};local viewport={X=1920,Y=1044}
    local function signal()
        local s={Callbacks={}}
        function s:Connect(fn) table.insert(self.Callbacks,fn);return {Disconnect=function() end} end
        function s:Once(fn) local once=false;return self:Connect(function(...) if not once then once=true;fn(...) end end) end
        function s:Fire(...) for _,fn in ipairs(table.clone(self.Callbacks)) do fn(...) end end
        return s
    end
    local function v2(x,y) return {X=x,Y=y} end
    local udim={new=function(s,o) return {Scale=s,Offset=o} end}
    local u2={new=function(xs,xo,ys,yo) return {X=udim.new(xs,xo),Y=udim.new(ys,yo)} end}
    u2.fromOffset=function(x,y) return u2.new(0,x,0,y) end
    u2.fromScale=function(x,y) return u2.new(x,0,y,0) end
    local defaultSize=u2.fromScale(1,1)
    local knownSignals={Activated=true,MouseEnter=true,MouseLeave=true,SelectionGained=true,SelectionLost=true,InputBegan=true,InputEnded=true,DescendantAdded=true,DescendantRemoving=true}
    local function object(class)
        local children={};local props={ClassName=class,Name=class,Visible=true,Enabled=true,Text="",Size=defaultSize,Position=u2.fromOffset(0,0),AnchorPoint=v2(0,0),CanvasPosition=v2(0,0)}
        local methods={}
        local self
        function methods:GetChildren() return table.clone(children) end
        function methods:GetDescendants()
            local out={}
            for _,child in ipairs(children) do table.insert(out,child);for _,d in ipairs(child:GetDescendants()) do table.insert(out,d) end end
            return out
        end
        function methods:IsA(wanted) return class==wanted or (wanted=="BasePart" and class=="Part") end
        function methods:FindFirstChildOfClass(wanted) for _,child in ipairs(children) do if child:IsA(wanted) then return child end end return nil end
        function methods:FindFirstChild(wanted) for _,child in ipairs(children) do if child.Name==wanted then return child end end return nil end
        function methods:Destroy() self.Parent=nil end
        function methods:Play() end
        function methods:InputHoldBegin() end
        function methods:InputHoldEnd() end
        function methods:SetAttribute(k,v) props["Attribute_"..k]=v end
        function methods:GetAttribute(k) return props["Attribute_"..k] end
        self=setmetatable({},{__index=function(_,k)
            if methods[k] then return methods[k] end
            if k=="_children" then return children end
            if k=="AbsoluteSize" then
                local p=props.Parent and props.Parent.AbsoluteSize or viewport
                return v2(p.X*props.Size.X.Scale+props.Size.X.Offset,p.Y*props.Size.Y.Scale+props.Size.Y.Offset)
            end
            if k=="AbsolutePosition" then
                local origin=props.Parent and props.Parent.AbsolutePosition or v2(0,0)
                local p=props.Parent and props.Parent.AbsoluteSize or viewport
                local size=self.AbsoluteSize
                return v2(origin.X+p.X*props.Position.X.Scale+props.Position.X.Offset-size.X*props.AnchorPoint.X,origin.Y+p.Y*props.Position.Y.Scale+props.Position.Y.Offset-size.Y*props.AnchorPoint.Y)
            end
            if knownSignals[k] then props[k]=props[k] or signal() end
            return props[k]
        end,__newindex=function(_,k,v)
            if k=="Parent" then
                if props.Parent then local list=props.Parent._children;local i=table.find(list,self);if i then table.remove(list,i) end end
                if v then table.insert(v._children,self) end
            end
            props[k]=v
        end})
        return self
    end
    local lighting=object("Lighting")
    local scheduler={delay=function(seconds,fn) table.insert(tasks,{At=now+seconds,Run=fn}) end,defer=function(fn) fn() end}
    local services={ReplicatedStorage={Shared=sharedNode},Lighting=lighting,TweenService={Create=function(_self,target,info,properties)
        local tween={Completed=signal()}
        function tween:Play() for k,v in pairs(properties) do target[k]=v end end
        function tween:Cancel() end
        return tween
    end},Players={LocalPlayer={UserId=7}}}
    local environment={game={GetService=function(_self,id) return assert(services[id],id) end},Enum=enum,Color3=color,
        workspace={GetServerTimeNow=function() return now end},
        Instance={new=object},UDim=udim,UDim2=u2,Vector2={new=v2,zero=v2(0,0)},ColorSequence={new=function(...) return {...} end},
        TweenInfo={new=function(t) return {Time=t} end},NumberSequence={new=function(...) return {...} end},task=scheduler,os={clock=function() return now end}}
    local Kit=load("Client/UI/Kit",environment)
    local Hud=load("Client/UI/Hud",environment)
    local Menus=load("Client/UI/Menus",environment)
    local Developer=load("Client/UI/Developer",environment)
    local Feedback=load("Client/UI/Feedback",environment)
    local root=object("Frame")
    local requests={}
    local function send(action,payload) table.insert(requests,{Action=action,Payload=payload}) end
    local hud=Hud.new(root,data,{Cast=function() end,Melee=function() end,Journal=function() end,Touch=false})
    local menus=Menus.new(root,data,{Intent=send,Modal=function() end,ReducedMotion=function() end})
    local dev=Developer.new(root,send)
    local feedback=Feedback.new(root,data,function() end)
    local layout=Layout.Resolve(T,viewport.X,viewport.Y,false)
    hud:Resize(layout);menus:Resize(layout);dev:Resize(layout);feedback:Resize(layout)
    hud:Render(state,now);menus:Update(state);feedback:Update(state);dev:Update(state)
    check(not dev.Root.Visible and not dev.Allowed,"No public developer panel")
    check(not dev.ToggleButton.Visible,"Admin button hidden from ordinary players")
    dev:Toggle();check(not dev.Root.Visible,"F8 component cannot open without server permission")
    for i=2,6 do
        check(hud.Slots[i].Seal.Visible and hud.Slots[i].Cost.Text=="" and not hud.Slots[i].KeyBadge.Visible,"Vacant slots show seals without placeholder text")
    end
    local visibleSegments=0
    for _,segment in ipairs(hud.Slots[1].Segments) do if segment.Visible then visibleSegments+=1 end end
    check(visibleSegments==16,"Half cooldown renders half the 32-segment ring")
    hud:Step(now+3);check(not hud.Slots[1].Countdown.Visible,"Cooldown clears after elapsed time")
    -- Sparse loadouts used to make table.concat fail; exercise slot removal and menu refresh.
    state.Loadout={[2]="Seer_9_Secondary"};menus:Update(state)
    menus:Open("Journal");check(menus.Root.Visible,"Journal handles sparse slots")
    for _,case in ipairs(cases) do
        viewport.X=case[1];viewport.Y=case[2]
        local l=Layout.Resolve(T,case[1],case[2],case[3]);hud:Resize(l);menus:Resize(l);feedback:Resize(l);dev:Resize(l)
        check(hud.Hotbar.AbsoluteSize.X==l.Hotbar.W,"Component applies measured hotbar width")
        local button={X=dev.ToggleButton.AbsolutePosition.X,Y=dev.ToggleButton.AbsolutePosition.Y,
            W=dev.ToggleButton.AbsoluteSize.X,H=dev.ToggleButton.AbsoluteSize.Y}
        check(not Layout.Intersects(button,l.Resources),"Admin button clears vitals on all devices")
        check(not Layout.Intersects(button,l.Journal),"Admin button clears Journal on all devices")
        check(button.X>=0 and button.Y>=0 and button.X+button.W<=l.Width and button.Y+button.H<=l.Height,"Admin touch target stays in safe area")
    end
    viewport.X=1920;viewport.Y=1044;menus:Resize(layout)
    state.PathwayId=false;state.Sequence=false;state.Digestion=0;state.Loadout={};state.Gold=0
    menus:Update(state);menus:Open("Inventory");menus:Preview("Seer_Potion_9")
    check(#requests==0,"Opening a potion preview never consumes or buys")
    check(menus.Confirm.Interactable,"Starter confirmation enabled")
    for _,button in ipairs(menus.PreviewActions:GetChildren()) do
        if button.ClassName=="TextButton" and button.Text=="Cancel" then button.Activated:Fire() end
    end
    check(#requests==0 and menus.View=="Page" and menus.Tab=="Inventory","Cancel returns to Inventory without an intent")
    check(state.PathwayId==false and state.Inventory.Seer_Potion_9==1,"Cancel preserves pathway and quantity")
    menus:Preview("Seer_Potion_9")
    menus.Confirm.Activated:Fire()
    check(#requests==1 and requests[1].Action=="Drink" and requests[1].Payload.Id=="Seer_Potion_9","Confirmation sends only drinking intent")
    menus.Confirm.Activated:Fire();check(#requests==1,"Repeated confirmation is suppressed while pending")
    check(state.Inventory.Seer_Potion_9==1,"Client never mutates inventory")
    menus:Close();state.PathwayId="Seer";state.Sequence=9;state.Gold=100;state.Inventory.Seer_Potion_8=0;menus:Update(state)
    menus:Altar(T.Timing.AltarExpiry)
    check(menus.Confirm.Interactable,"Eligible altar preview enabled")
    now+=T.Timing.AltarExpiry+1;menus:Step(now)
    check(not menus.Confirm.Interactable,"Expired invitation disables confirmation")
    local count=#requests;menus.Confirm.Activated:Fire();check(#requests==count,"Expired altar cannot send purchase")
    menus:Close();menus:Altar(T.Timing.AltarExpiry);menus.Confirm.Activated:Fire()
    check(requests[#requests].Action=="Buy","Altar uses validated server purchase intent")
    local developerState=table.clone(state);developerState.Developer=true;developerState.DeveloperInfo={SessionOnly=true,Mode="Normal",Ready=true}
    dev:Update(developerState);dev:Toggle();check(dev.Root.Visible,"Authorized F8 panel opens")
    check(dev.ToggleButton.Visible,"Authorized user gets visible admin button")
    dev.ToggleButton.Activated:Fire();check(not dev.Root.Visible,"Visible admin button closes panel")
    dev.ToggleButton.Activated:Fire();check(dev.Root.Visible,"Visible admin button opens panel")
    local beforeAdmin=#requests
    dev.PathButtons.Apprentice.Activated:Fire();dev.SequenceButtons[4].Activated:Fire()
    check(#requests==beforeAdmin,"Selecting pathway/sequence waits for Apply")
    dev.Apply.Activated:Fire()
    check(requests[#requests].Action=="AdminSet" and requests[#requests].Payload.PathwayId=="Apprentice"
        and requests[#requests].Payload.Sequence==4,"Admin submits exact selected pathway and sequence")
    dev.Apply.Activated:Fire();check(#requests==beforeAdmin+1,"Pending admin change suppresses duplicate submits")
    developerState.PathwayId="Apprentice";developerState.Sequence=4;developerState.DeveloperInfo.SessionOnly=false
    dev:Update(developerState);check(dev.Apply.Interactable,"Admin selector works in live saved sessions")
    dev:SetSuppressed(true);check(not dev.ToggleButton.Visible and not dev.Root.Visible,"Modal hides admin controls")
    dev:SetSuppressed(false);check(dev.ToggleButton.Visible,"Admin shortcut restored after modal")
    dev:Update(state);check(not dev.Root.Visible,"Permission loss closes developer UI")
    check(not dev.ToggleButton.Visible,"Permission loss removes admin shortcut")
    dev.Apply.Activated:Fire();check(#requests==beforeAdmin+1,"Unauthorized client component cannot submit an admin command")
    local VM={}
    local function v3(x,y,z) return setmetatable({X=x,Y=y,Z=z},VM) end
    VM.__sub=function(a,b) return v3(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
    VM.__index=function(a,k) if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end return nil end
    local world=object("Workspace")
    world.CurrentCamera={WorldToViewportPoint=function(_self,_position) return {X=960,Y=400,Z=5},true end}
    local character=object("Model");local playerRoot=object("Part");playerRoot.Name="HumanoidRootPart";playerRoot.Position=v3(0,3,0);playerRoot.Parent=character
    services.Players.LocalPlayer.Character=character
    local altar=object("Part");altar.Position=v3(0,3,0);altar.Parent=world
    local prompt=object("ProximityPrompt");prompt.Parent=altar;prompt.KeyboardKeyCode=enum.KeyCode.E;prompt.MaxActivationDistance=10;prompt.HoldDuration=0.4;prompt.ObjectText="Potion Altar";prompt.ActionText="Open altar";prompt:SetAttribute("InteractionId","Buy")
    local legacy=object("BillboardGui");legacy.Parent=altar;legacy.Enabled=true
    local service={Enabled=true,PromptShown=signal(),PromptHidden=signal(),PromptButtonHoldBegan=signal(),PromptButtonHoldEnded=signal()}
    services.ProximityPromptService=service;services.RunService={RenderStepped=signal()};services.UserInputService={InputEnded=signal()}
    environment.workspace=world
    function world:GetServerTimeNow() return now end
    local visualState=table.clone(state);visualState.PathwayId="Marauder";visualState.Sequence=6
    visualState.Loadout={[1]="Marauder_6"};visualState.StolenPower="ArcBolt";visualState.Casting=false;visualState.VisualToken=0
    hud:Render(visualState,now)
    check(hud.Slots[1].Stored.Visible,"Confirmed stolen power has a persistent slot badge")
    visualState.StolenPower=false;hud:Render(visualState,now)
    check(not hud.Slots[1].Stored.Visible,"Release clears stored-power badge from snapshot")
    visualState.Loadout={[1]="Apprentice_6_Secondary"};visualState.RecordedCharges=3;visualState.RecordedPowerId="ArcBolt"
    hud:Render(visualState,now)
    check(hud.Slots[1].Recorded.Visible and hud.Slots[1].Recorded.Text=="3","Recorded releases show actual charge count")
    visualState.RecordedCharges=0;hud:Render(visualState,now)
    check(not hud.Slots[1].Recorded.Visible,"Depleted recordings clear their charge badge")
    hud:SetVisualCast({Phase="Begin",AbilityId="Marauder_6",EndsAt=now+0.5,Token=1})
    check(hud.Cast.Visible and hud.CastText.Text=="Ability Theft","Accepted visual event starts HUD without waiting for snapshot")
    visualState.Casting="Marauder_6";visualState.VisualToken=1;visualState.CastRemaining=0.3
    hud:SetVisualCast({Phase="End",Token=1})
    check(not hud.Cast.Visible,"Late pre-result snapshot cannot resurrect completed HUD cast")
    visualState.VisualToken=2;hud:Render(visualState,now)
    check(hud.Cast.Visible,"A newer confirmed snapshot may show a fresh cast")
    -- F: pathway skins and read-only cooldown/acting feedback.
    for _,path in ipairs({"Seer","Marauder","Apprentice"}) do
        local skinState=table.clone(state);skinState.PathwayId=path;skinState.Sequence=9
        skinState.Loadout={[1]=path.."_9"};skinState.Cooldowns={[path.."_9"]=0.5}
        hud:Render(skinState,now)
        check(hud.SkinPath==path and hud.Hotbar:FindFirstChild("PathwaySkin")~=nil,"HUD applies each pathway's native geometry skin")
        check(hud.Slots[1].Face.BackgroundColor3==T.Skins[path].Backing,"Each pathway gets its configured card surface")
        hud.Slots[1].Face.MouseEnter:Fire();hud.Slots[1].Face.MouseLeave:Fire()
        check(hud.Slots[1].Face.BackgroundColor3==T.Skins[path].Backing,"Hover/selection leave preserves the pathway skin surface")
        hud:Step(now+1)
        local stroke=hud.Slots[1].Face:FindFirstChildOfClass("UIStroke")
        check(stroke.Transparency==T.Skins.ReadyAlpha,"Cooldown completion gives a restrained ready frame")
        hud.Callbacks.ReducedMotion=function() return true end;hud:Step(now+1)
        check(stroke.Transparency==T.Style.BorderAlpha,"Reduced Motion disables ready accent")
        hud.Callbacks.ReducedMotion=nil
        check(skinState.Cooldowns[path.."_9"]==0.5,"Cooldown polish never mutates the server snapshot")
    end
    local abilityGlyphCount=0
    for id,ability in pairs(data.Abilities) do
        local key=T.AbilityGlyphs[id]
        check(type(key)=="string" and T.Glyphs[key]~=nil,"Ability has bespoke vector glyph: "..id)
        check(Kit.AbilityGlyph(ability)==key,"Kit.AbilityGlyph resolves ability icon: "..id)
        abilityGlyphCount+=1
    end
    check(abilityGlyphCount==54,"All 54 abilities have bespoke glyph entries")
    menus:Update(visualState);menus:Open("Pathway")
    check(menus.Root.Visible and menus.Tab=="Pathway","Pathway tab renders sequence progression and passive traits")
    menus:Open("Journal")
    local priorKey=menus.LastKey
    local recordedUpdate=table.clone(visualState);recordedUpdate.RecordedCharges=2;menus:Update(recordedUpdate)
    check(menus.LastKey~=priorKey,"Open Journal refreshes when confirmed recording charges change")
    menus:Close()
    local actingBefore=table.clone(state);actingBefore.Digestion=0;feedback:Update(actingBefore)
    local actingAfter=table.clone(actingBefore);actingAfter.Digestion=5;feedback:Update(actingAfter);feedback:Step(now)
    check(feedback.Acting.Visible and string.find(feedback.Acting.Text,"5.0%%")~=nil,"Confirmed digestion gain gets readable acting feedback")
    local madness=table.clone(actingAfter);madness.Sanity=10;madness.Mode="Madness";feedback:Update(madness);feedback:SetReducedMotion(true);feedback:Step(now)
    check(feedback.SanityWarning.Visible and feedback.SanityWarning.Text==T.Ritual.MadnessText,"Madness has static readable guidance under Reduced Motion")
    feedback:Update(state);feedback:SetReducedMotion(false)
    local Prompts=load("Client/UI/Prompts",environment)
    local prompts=Prompts.new(root);prompts.Layout=layout
    service.PromptShown:Fire(prompt,enum.ProximityPromptInputType.Keyboard)
    check(prompts.Root.Visible and prompts.Current==prompt,"Custom prompt projects near an eligible object")
    check(not legacy.Enabled,"Legacy signs suppressed during prompt presentation")
    service.PromptHidden:Fire(prompt)
    check(not prompts.Root.Visible and legacy.Enabled,"Prompt hide restores previous label visibility")
    prompts:SetModal(true);service.PromptShown:Fire(prompt,enum.ProximityPromptInputType.Keyboard)
    check(not service.Enabled and not prompts.Root.Visible,"Modal prevents background prompt activation")
    prompts:SetModal(false);service.PromptShown:Fire(prompt,enum.ProximityPromptInputType.Keyboard)
    playerRoot.Position=v3(30,3,0);prompts:Project()
    check(not prompts.Root.Visible and legacy.Enabled,"Out-of-range prompt hides and releases labels")
    prompts:Hide()
    for _,child in ipairs(hud.Root:GetDescendants()) do
        if child.ClassName=="TextLabel" or child.ClassName=="TextButton" then
            check(not string.find(child.Text,"STUDIO SESSION",1,true) and not string.find(child.Text,"not saved",1,true) and child.Text~="Empty","Public HUD contains no debug strings or Empty labels")
        end
    end
    print("PASS: "..checks.." visual-model/layout/access and UI lifecycle assertions (GUI engine stand-ins; no rendered certification)")
end
