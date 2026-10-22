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
local Presentation={}
function Presentation.new(gui: Instance,data: any,callbacks: any?): any
    local cb=callbacks or {}
    local self: any=setmetatable({GUI=gui,Data=data,Callbacks=cb,SoundCount=0,Controllers={},Reduced=false,Low=false,
        State=nil,Cast=nil,ScanElapsed=0,Demo=false},{__index=Presentation})
    self.VFX=VfxService.new()
    self.Blocks=Blocks.new(self.VFX,{ScreenEdgePulse=function(_color: Color3,_duration: number)
        if not self.Reduced and cb.ScreenEdgePulse then cb.ScreenEdgePulse() end
    end})
    self.Camera=CameraFeel.new()
    self.Hits=HitPresentation.new(self.VFX,self.Blocks)
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
    if not state.Ready then return end
    local controller=self:LocalController()
    if controller and not self.Demo then
        if state.Casting and state.Casting~=self.Cast then controller:Play("CastWindup")
        elseif not state.Casting and self.Cast then controller:Stop("CastWindup") end
        if previous and previous.Ready and state.Health<previous.Health then
            controller:Play("HitReact");self.Camera:Kick(1);self.Camera:HitStop()
        end
    end
    self.Cast=state.Casting or nil
end
function Presentation.Event(self: any,event: any)
    if not self.VFX:Visible(event.Position) then return end
    if event.Kind=="Damage" then
        self.Hits:Hit(event)
        if self.Callbacks.Damage then self.Callbacks.Damage(event) end
        if event.Owner==Players.LocalPlayer.UserId then self.Camera:Kick(1);self.Camera:HitStop() end
        return
    end
    if event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch);return end
    local ability=self.Data.Abilities[event.Kind]
    if ability then self:Audio(ability.SFXHook) end
    if event.Owner then
        local caster=Players:GetPlayerByUserId(event.Owner)
        local controller=caster and self:Controller(caster.Character)
        if controller and (ability or event.Kind=="Melee") then
            controller:Stop("CastWindup");controller:Play("CastRelease")
        end
    end
    if event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        local h=self.VFX:Begin("Reveal",event.Position,1,T.Visuals.RevealPriority,{Highlight=1})
        if not h then return end
        h.Duration=C.Hit.RevealLife
        local highlight=h:Acquire("Highlight")
        highlight.Adornee=event.Target;highlight.FillColor=T.Colors.Sanity;highlight.OutlineColor=T.Colors.Fog
        highlight.FillTransparency=T.LegacyFX.HighlightAlpha
    elseif event.Kind~="Whisper" then
        -- Preserve the old neutral pulse during Phase A. Pathway-specific layering
        -- is deliberately deferred until the user continues to Phases B-D.
        local h=self.VFX:Begin("LegacyPulse",event.Position,1,T.Visuals.LegacyPriority,{Part=1})
        if not h then return end
        h.Duration=T.Visuals.LegacyLife
        local p=h:Acquire("Part")
        p.Shape=Enum.PartType.Ball;p.Color=if ability then Kit.PathColor(ability.PathwayId) else T.Colors.Fog
        p.Position=event.Position;p.Size=Vector3.one*T.Visuals.LegacyStart;p.Transparency=T.Visuals.LegacyAlpha
        h.Update=function(_dt: number,_age: number,t: number)
            p.Size=Vector3.one*(T.Visuals.LegacyStart+(T.Visuals.LegacyEnd-T.Visuals.LegacyStart)*t)
            p.Transparency=T.Visuals.LegacyAlpha+(1-T.Visuals.LegacyAlpha)*t
        end
    end
end
function Presentation.Step(self: any,dt: number)
    self.VFX:Step(dt);self.ScanElapsed+=dt
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
function Presentation.StopDemoAnimation(self: any)
    if not self.Demo then return end
    self.Demo=false
    local controller=self:LocalController()
    if controller then controller:Stop();controller.AutoState=nil;controller.AutoLocomotion=true end
end
function Presentation.Destroy(self: any)
    self.Camera:Destroy();self.VFX:Destroy()
    for _,controller in pairs(self.Controllers) do controller:Destroy() end
    table.clear(self.Controllers)
end
return Presentation
