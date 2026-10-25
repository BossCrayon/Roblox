--!strict
-- Coordinator for server-confirmed cosmetics; no outcomes are computed here.
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage").Shared
local T=require(Shared.Theme)
local C=require(Shared.VfxConfig)
local Kit=require(script.Parent.Kit)
local Visuals=script.Parent.Parent.Visuals
local VfxService=require(Visuals.VfxService)
local Blocks=require(Visuals.EffectBlocks)
local AnimationController=require(Visuals.AnimationController)
local CameraFeel=require(Visuals.CameraFeel)
local HitPresentation=require(Visuals.HitPresentation)
local AbilityPresentation=require(Visuals.AbilityPresentation)
local CharacterArt=require(Visuals.CharacterArt)
local EnemyPresentation=require(Visuals.EnemyPresentation)
local Presentation={}
function Presentation.new(gui: Instance,data: any,callbacks: any?): any
    local cb=callbacks or {}
    local self: any=setmetatable({GUI=gui,Data=data,Callbacks=cb,SoundCount=0,Controllers={},Reduced=false,Low=false,
        State=nil,Cast=nil,ScanElapsed=0,Demo=false},{__index=Presentation})
    self.VFX=VfxService.new()
    self.Blocks=Blocks.new(self.VFX,{ScreenEdgePulse=function(_color: Color3,_duration: number)
        if not self.Reduced and cb.ScreenEdgePulse then cb.ScreenEdgePulse() end
    end})
    self.Outfits=CharacterArt.new(self.VFX,self.Blocks)
    self.Enemies=EnemyPresentation.new(self.VFX,self.Blocks,data.Runtime,cb.Notice,function(hook: string) self:Audio(hook) end)
    self.Camera=CameraFeel.new()
    self.Hits=HitPresentation.new(self.VFX,self.Blocks)
    self.Abilities=AbilityPresentation.new(self.VFX,self.Blocks,data,{
        Clock=function() return workspace:GetServerTimeNow() end,
        Camera=function() return workspace.CurrentCamera end,
        LocalUserId=Players.LocalPlayer.UserId,
        Player=function(id: number) return Players:GetPlayerByUserId(id) end,
        Controller=function(character: Model) return self:Controller(character) end,
        Audio=function(hook: string) self:Audio(hook) end,
        Cast=cb.CastVisual,
    })
    self.Camera.OnHitStop=function(seconds: number)
        local controller=self:LocalController()
        if controller then controller:Pause(seconds) end
    end
    return self
end
function Presentation.Audio(self: any,hook: string,pitch: number?)
    local id=T.Sound.Abilities[hook]
    if type(id)~="number" or id<=0 or self.SoundCount>=T.Sound.MaxPlaying then return end
    self.SoundCount+=1
    local sound=Kit.New("Sound",self.GUI,{SoundId="rbxassetid://"..tostring(math.floor(id)),Volume=T.Sound.AbilityVolume,
        PlaybackSpeed=math.clamp(pitch or T.LegacyFX.Pitch,T.Sound.MinPitch,T.Sound.MaxPitch)})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();self.SoundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Presentation.Controller(self: any,character: Model?): any
    if not character or not character.Parent or not character:FindFirstChildOfClass("Humanoid") then return nil end
    if not self.Controllers[character] then
        self.Controllers[character]=AnimationController.new(character,{ReducedMotion=self.Reduced})
    end
    return self.Controllers[character]
end
function Presentation.LocalController(self: any): any
    return self:Controller(Players.LocalPlayer.Character)
end
function Presentation.SetSettings(self: any,reduced: boolean,low: boolean)
    self.Reduced=reduced;self.Low=low
    self.VFX:SetSettings(reduced,low);self.Camera:SetReducedMotion(reduced)
    for _,controller in pairs(self.Controllers) do controller:SetReducedMotion(reduced) end
end
function Presentation.Update(self: any,state: any)
    local previous=self.State;self.State=state
    self.Abilities:Update(state)
    if not state.Ready then return end
    local controller=self:LocalController()
    if controller and not self.Demo and previous and previous.Ready and state.Health<previous.Health then
        controller:Play("HitReact");self.Camera:Kick(1);self.Camera:HitStop()
    end
end
function Presentation.Event(self: any,event: any)
    if event.Kind=="AbilityVisual" or event.Kind=="StatusVisual" or event.Kind=="VisualTrigger" or event.Kind=="GateRemoval"
        or event.Kind=="GateSnapshot" or event.Kind=="EchoSnapshot" then
        local accepted=self.Abilities:Event(event)
        if accepted and event.Kind=="AbilityVisual" and event.Phase=="Result" and event.Owner==Players.LocalPlayer.UserId
            and self.VFX:Visible(event.Position) then
            self.Camera:Kick(event.Tier)
        end
        return
    end
    if event.Kind=="PotionConfirmed" then
        if type(event.At)~="number" or math.abs(workspace:GetServerTimeNow()-event.At)>C.Protocol.MaxAge or not T.CharacterArt.Trim[event.PathwayId] then return end
        local controller=self:LocalController();if controller then controller:Play("CastRelease",nil,nil,T.Ritual.Pose) end
        self.Blocks:Compose({{Name="RisingMotes",Position=event.Position,Palette=event.PathwayId,Options={Scale=T.CharacterArt.AuraScale}}},1,2,T.Ritual.DrinkTime)
        return
    end
    if not self.VFX:Visible(event.Position) then return end
    if event.Kind=="Damage" then
        self.Hits:Hit(event)
        if self.Callbacks.Damage then self.Callbacks.Damage(event) end
        if event.Owner==Players.LocalPlayer.UserId then self.Camera:Kick(1);self.Camera:HitStop() end
    elseif event.Kind=="Melee" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=if typeof(event.Character)=="Instance" and event.Character:IsA("Model") then event.Character elseif ownerPlayer then ownerPlayer.Character else nil
        local controller=self:Controller(character)
        local profile=if event.Combo==2 then "MeleeLeft" else "MeleeRight"
        if controller then controller:Play("CastRelease",nil,nil,profile) end
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local origin=if typeof(event.Origin)=="Vector3" then event.Origin else event.Position
        local dir=if typeof(event.Direction)=="Vector3" and event.Direction.Magnitude>0.01 then event.Direction.Unit else Vector3.new(0,0,-1)
        local side=Vector3.new(-dir.Z,0,dir.X)
        local sign=if event.Combo==2 then -1 else 1
        local arcStart=origin+dir*C.Melee.ArcForward+side*(sign*C.Melee.ArcSpan)+Vector3.yAxis*(C.Melee.ArcHeight*sign)
        local arcEnd=origin+dir*C.Melee.ArcEndForward-side*(sign*C.Melee.ArcSpan)-Vector3.yAxis*(C.Melee.ArcHeight*sign)
        local specs: {any}={
            {Name="ThreadBeam",Position=arcStart,Palette=palette,Options={EndPosition=arcEnd,Scale=C.Melee.SlashScale,Curve=C.Melee.ArcCurve,Draw=true,Delay=C.Melee.Windup}},
            {Name="AfterimageTrail",Position=arcStart,Palette=palette,Options={EndPosition=arcEnd,Scale=C.Melee.TrailScale,Delay=C.Melee.Windup}},
        }
        -- Cosmetic pathway vocabulary; an ordinary punch gains no supernatural outcome.
        if not self.Reduced and not self.Low then
            local motif=if palette=="Seer" then "VeilRibbon" elseif palette=="Marauder" then "GlitchFlicker" else "StarBurst"
            table.insert(specs,{Name=motif,Position=arcEnd,Palette=palette,
                Options={Scale=C.Melee.MotifScale,Delay=C.Melee.MotifDelay,Frame=CFrame.lookAt(arcEnd,arcEnd+dir)}})
        end
        if event.Target then
            table.insert(specs,{Name="ImpactFlash",Position=event.Position,Palette=palette,Options={Scale=C.Melee.ImpactScale,Delay=C.Melee.Windup}})
            table.insert(specs,{Name="RingBurst",Position=event.Position,Palette=palette,Options={Scale=C.Melee.ImpactScale,Delay=C.Melee.Windup}})
        end
        self.Blocks:Compose(specs,1,C.Composition.Priority,C.Melee.TrailLife)
    elseif event.Kind=="Dash" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=ownerPlayer and ownerPlayer.Character
        local controller=self:Controller(character)
        if controller then controller:Play("Dodge") end
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local origin=if typeof(event.Origin)=="Vector3" then event.Origin else event.Position
        local dest=if typeof(event.Destination)=="Vector3" then event.Destination else event.Position
        local dashSpecs: {any}={
            {Name="AfterimageTrail",Position=origin,Palette=palette,Options={EndPosition=dest,Scale=C.Dash.Scale}},
            {Name="RingBurst",Position=origin,Palette=palette,Options={Scale=C.Dash.Scale*0.82}},
        }
        self.Blocks:Compose(dashSpecs,1,C.Composition.Priority,C.Dash.Life)
    elseif event.Kind=="UltimateVisual" then
        local ownerPlayer=if type(event.Owner)=="number" then Players:GetPlayerByUserId(event.Owner) else nil
        local character=if typeof(event.Character)=="Instance" and event.Character:IsA("Model") then event.Character elseif ownerPlayer then ownerPlayer.Character else nil
        local palette=if T.CharacterArt.Trim[event.PathwayId] then event.PathwayId else "Seer"
        local controller=self:Controller(character)
        if controller then controller:Play("CastRelease",nil,nil,"Ultimate"..palette) end
        local scale=if event.Stage=="Complete" then C.Ultimate.CompleteScale else C.Ultimate.IncompleteScale
        local stencil=if palette=="Seer" then "Worm" elseif palette=="Marauder" then "Clock" else "Arch"
        local motif=if palette=="Seer" then "VeilRibbon" elseif palette=="Marauder" then "GlitchFlicker" else "DoorFrame"
        local facing=if character then character:FindFirstChild("HumanoidRootPart") else nil
        local frame=CFrame.new(event.Position)*(if facing and facing:IsA("BasePart") then facing.CFrame.Rotation else CFrame.identity)
        local ground=event.Position+Vector3.yAxis*C.Ultimate.GroundOffset
        local gesture=event.Position+Vector3.yAxis*C.Ultimate.GestureHeight
        -- Six layers, one reservation: intake -> unfold -> domain/aftermath.
        -- This is a cinematic interpretation, never a client-side damage or time-stop grant.
        local ultSpecs: {any}={
            {Name="RisingMotes",Position=gesture,Palette=palette,Options={Scale=C.Ultimate.IntakeScale,Intake=true,Life=C.Ultimate.Release}},
            {Name="SigilStencil",Position=gesture,Palette=palette,Options={Scale=scale,Glyph=stencil,LowGlyph=stencil,Frame=CFrame.new(gesture)*frame.Rotation}},
            {Name=motif,Position=ground,Palette=palette,Options={Scale=scale,Frame=CFrame.new(ground)*frame.Rotation,
                Height=C.Ultimate.VeilHeight,Delay=C.Ultimate.Release}},
            {Name="GroundRune",Position=ground,Palette=palette,Options={Scale=scale,InnerRing=true,Delay=C.Ultimate.Release}},
            {Name="ShockwaveRing",Position=ground,Palette=palette,Options={Scale=scale*C.Ultimate.DomainScale,Delay=C.Ultimate.Aftermath}},
            {Name=if palette=="Seer" then "CardFan" elseif palette=="Marauder" then "SigilStencil" else "StarBurst",
                Position=gesture,Palette=palette,Options={Scale=scale,Glyph="Clock",Frame=CFrame.new(gesture)*frame.Rotation,Delay=C.Ultimate.Aftermath}},
        }
        local handle=self.Blocks:Compose(ultSpecs,3,C.Composition.Priority+1,C.Ultimate.Life)
        if handle and event.Owner==Players.LocalPlayer.UserId then
            local update=handle.Update;local released=false
            handle.Update=function(dt: number,age: number,t: number)
                update(dt,age,t)
                if not released and age>=C.Ultimate.Release then
                    released=true
                    if self.VFX:Visible(event.Position) then self.Camera:Kick(3);self.Camera:HitStop() end
                end
            end
        end
    elseif event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch)
    elseif event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        -- Compatibility for old server reveal packets; current servers send private batches.
        self.Abilities.Status:Reveal({Targets={{Target=event.Target,Position=event.Position}},
            ExpiresAt=workspace:GetServerTimeNow()+C.Protocol.RevealLife},"Seer")
    elseif event.Kind~="Whisper" then
        local name=if event.Kind=="Defeat" then "RisingMotes" elseif event.Kind=="Substitute" then "RingBurst" else "ImpactFlash"
        self.Blocks:Compose({{Name=name,Position=event.Position,Palette="Seer",Options={Scale=C.Ability.DefaultScale}}},1,
            C.Composition.Priority,C.Composition.ResultLife)
    end
end
function Presentation.Step(self: any,dt: number)
    self.VFX:Step(dt);self.Abilities:Step();self.Outfits:Step(dt);self.Enemies:Step(dt);self.ScanElapsed+=dt
    if self.AbilityDemo and workspace:GetServerTimeNow()>=self.AbilityDemo.EndsAt then
        local demo=self.AbilityDemo;self.AbilityDemo=nil
        if demo.Windup then demo.Windup:Finish() end
        local controller=self:LocalController()
        if controller then
            controller:Stop("CastWindup",C.Composition.CancelFade)
            if not demo.Cancel then controller:Play("CastRelease",nil,nil,C.Ability.Profiles[demo.Id]) end
        end
        if not demo.Cancel then self.Abilities:Preview(demo.Id,demo.Variant,demo.Origin,demo.Destination,demo.Target) end
    end
    if self.ScanElapsed<T.TestRoom.StatInterval then return end;self.ScanElapsed=0
    local wanted={}
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if character and root and root:IsA("BasePart") and (player==Players.LocalPlayer or self.VFX:Visible(root.Position)) then
            wanted[character]=true;self:Controller(character)
        end
    end
    for character,controller in pairs(self.Controllers) do
        if not wanted[character] then controller:Destroy();self.Controllers[character]=nil end
    end
end
function Presentation.DemoAnimation(self: any,name: string)
    local controller=self:LocalController()
    if not controller then return end
    controller:Stop();controller.AutoLocomotion=false;self.Demo=true;controller:Play(name)
end
function Presentation.PreviewAbility(self: any,id: string,variant: string,origin: Vector3,destination: Vector3,target: Instance?,cancel: boolean?)
    self:StopDemoAnimation()
    local a=self.Data.Abilities[id]
    if not a then return end
    local controller=self:LocalController()
    if controller then controller:Play("CastWindup",nil,nil,C.Ability.Profiles[id]) end
    local windup=self.Abilities:Preview(id,variant,origin,destination,target,"Begin")
    self.AbilityDemo={Id=id,Variant=variant,Origin=origin,Destination=destination,Target=target,Cancel=cancel,
        Windup=windup,EndsAt=workspace:GetServerTimeNow()+a.CastTimeSeconds}
end
function Presentation.StopDemoAnimation(self: any)
    if self.AbilityDemo then
        if self.AbilityDemo.Windup then self.AbilityDemo.Windup:Finish() end
        self.AbilityDemo=nil
        local active=self:LocalController();if active then active:Stop("CastWindup",C.Composition.CancelFade) end
    end
    self.Abilities:ClearPreviews()
    if not self.Demo then return end
    self.Demo=false
    local controller=self:LocalController()
    if controller then controller:Stop();controller.AutoState=nil;controller.AutoLocomotion=true end
end
function Presentation.PreviewTrigger(self: any,id: string,trigger: string,origin: Vector3,destination: Vector3,target: Instance?)
    self:StopDemoAnimation()
    self.Abilities:Preview(id,"Confirmed",origin,destination,target,"Result",trigger)
end
function Presentation.Destroy(self: any)
    self.Outfits:Destroy();self.Enemies:Destroy();self.Abilities:Destroy();self.Camera:Destroy();self.VFX:Destroy()
    for _,controller in pairs(self.Controllers) do controller:Destroy() end
    table.clear(self.Controllers)
end
return Presentation
