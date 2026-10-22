--!strict
-- Keeps the existing pooled cosmetics working; pathway VFX redesign belongs to Phase 4.
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Kit=require(script.Parent.Kit)
local Presentation={}
function Presentation.new(gui: Instance,data: any): any
    local folder=Kit.New("Folder",workspace,{Name="LocalMysteriesFX"})
    return setmetatable({GUI=gui,Data=data,Folder=folder,Pool={},Active=0,Highlights={},HighlightPool={},HighlightCount=0,SoundCount=0},{__index=Presentation})
end
function Presentation.Audio(self: any,hook: string,pitch: number?)
    local id=T.Sound.Abilities[hook]
    if type(id)~="number" or id<=0 or self.SoundCount>=T.Sound.MaxPlaying then return end
    self.SoundCount+=1
    local sound=Kit.New("Sound",self.GUI,{SoundId="rbxassetid://"..tostring(math.floor(id)),Volume=T.Sound.AbilityVolume,PlaybackSpeed=math.clamp(pitch or T.LegacyFX.Pitch,T.Sound.MinPitch,T.Sound.MaxPitch)})
    local released=false
    local function release()
        if released then return end;released=true;sound:Destroy();self.SoundCount-=1
    end
    sound.Ended:Once(release);sound:Play();task.delay(T.Timing.SoundLife,release)
end
function Presentation.Event(self: any,event: any)
    if event.Kind=="VoiceProfile" then self:Audio(event.Hook,event.Pitch);return end
    local ability=self.Data.Abilities[event.Kind]
    if ability then self:Audio(ability.SFXHook) end
    if event.Kind=="Reveal" and typeof(event.Target)=="Instance" then
        if self.Highlights[event.Target] or self.HighlightCount>=T.LegacyFX.Max then return end
        local highlight=table.remove(self.HighlightPool) or Instance.new("Highlight")
        self.Highlights[event.Target]=highlight;self.HighlightCount+=1
        highlight.Adornee=event.Target;highlight.FillColor=T.Colors.Sanity;highlight.OutlineColor=T.Colors.Fog
        highlight.FillTransparency=T.LegacyFX.HighlightAlpha;highlight.Parent=self.Folder;highlight.Enabled=true
        task.delay(T.Timing.Reveal,function()
            self.Highlights[event.Target]=nil;self.HighlightCount-=1
            highlight.Enabled=false;highlight.Adornee=nil;highlight.Parent=nil;table.insert(self.HighlightPool,highlight)
        end)
    elseif event.Kind~="Whisper" and self.Active<T.LegacyFX.Max then
        local p: Part=table.remove(self.Pool) or Instance.new("Part")
        p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Shape=Enum.PartType.Ball;p.Material=Enum.Material.Neon
        p.Size=Vector3.one*T.LegacyFX.StartSize;p.Position=event.Position;p.Transparency=T.LegacyFX.Alpha
        p.Color=if ability then Kit.PathColor(ability.PathwayId) else T.Colors.Fog
        self.Active+=1;p.Parent=self.Folder
        local tween=Kit.Tween(p,T.Timing.Pulse,{Size=Vector3.one*T.LegacyFX.EndSize,Transparency=1})
        tween.Completed:Once(function() self.Active-=1;p.Parent=nil;table.insert(self.Pool,p) end)
    end
end
return Presentation
