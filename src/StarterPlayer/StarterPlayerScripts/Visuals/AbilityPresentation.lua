--!strict
-- Original, cosmetic choreography. Only server-authored ability packets enter Event.
local Shared=game:GetService("ReplicatedStorage").Shared
local C=require(Shared.VfxConfig)
local Anim=require(Shared.AnimConfig)
local VfxService=require(script.Parent.VfxService)
local Status=require(script.Parent.StatusPresentation)
local Choreography=require(script.Parent.Choreography)
local Families={Seer=require(script.Parent.PathwayEffects.Seer),Marauder=require(script.Parent.PathwayEffects.Marauder),Apprentice=require(script.Parent.PathwayEffects.Apprentice)}
local Ability={}
local function finite(n: any): boolean return type(n)=="number" and n==n and math.abs(n)<math.huge end
local function point(p: any): boolean
    return typeof(p)=="Vector3" and finite(p.X) and finite(p.Y) and finite(p.Z) and p.Magnitude<=C.Safety.PositionLimit
end
function Ability.new(service: any,blocks: any,data: any,callbacks: any): any
    local self: any=setmetatable({Service=service,Blocks=blocks,Data=data,Callbacks=callbacks,Records={},Previews={},LocalPath=nil,
        Status=Status.new(service,callbacks.Clock,blocks),LastCue=0,LastGateCue=0},{__index=Ability})
    return self
end
function Ability.Frame(self: any,position: Vector3): CFrame
    local camera=self.Callbacks.Camera()
    if not camera then return CFrame.new(position) end
    local direction=Vector3.new(camera.CFrame.Position.X-position.X,0,camera.CFrame.Position.Z-position.Z)
    return if direction.Magnitude>C.Blocks.Common.MinimumLength then CFrame.lookAt(position,position+direction) else CFrame.new(position)
end
function Ability.Layers(self: any,a: any,e: any): (any,number)
    local function layer(name: string,position: Vector3,opts: any?): any
        return {Name=name,Position=position,Palette=a.PathwayId,Options=opts or {}}
    end
    local profile=self.Service:Profile()
    local context={Layer=layer,Frame=function(position: Vector3) return self:Frame(position) end,Simplified=profile.Low or profile.Mobile}
    context=Choreography.Extend(a,e,context)
    if e.Phase=="Begin" then
        local at=e.Position+Vector3.yAxis*C.Ability.HandHeight
        local family=Anim.AbilityTimings[a.Id] and Anim.AbilityTimings[a.Id].Family
        local glyph=C.Ability.WindupGlyphs[family] or (if a.PathwayId=="Seer" then C.Ability.EyeGlyph elseif a.PathwayId=="Marauder" then C.Ability.TheftGlyph else C.Ability.DoorGlyph)
        local lowGlyph=if a.PathwayId=="Seer" then C.Ability.LowEyeGlyph elseif a.PathwayId=="Marauder" then glyph else C.Ability.LowDoorGlyph
        local root=e.Character and (e.Character.PrimaryPart or e.Character:FindFirstChild("HumanoidRootPart"))
        return {layer("SigilStencil",at,{Frame=self:Frame(at),Glyph=glyph,LowGlyph=lowGlyph,Scale=C.Ability.WindupScale,
            Follow=root,Offset=Vector3.yAxis*C.Ability.HandHeight})},
            math.max(C.Composition.CancelFade,e.EndsAt-self.Callbacks.Clock())
    end
    local layers,duration=Families[a.PathwayId].Build(a,e,context)
    if layers then return layers,duration or C.Composition.ResultLife end
    local name=C.Ability.Defaults[a.PathwayId]
    local at=e.Position
    if name=="RingBurst" or name=="DoorFrame" then at+=Vector3.yAxis*C.Ability.GroundOffset end
    local opts: any={Scale=C.Ability.DefaultScale}
    if name~="RingBurst" then opts.Frame=self:Frame(at) end
    -- Obscured readings are a small incomplete mark, never a successful reveal.
    if e.Outcome=="Obscured" then name="SigilStencil";opts.Glyph=C.Ability.TheftGlyph;opts.LowGlyph=opts.Glyph;opts.Frame=self:Frame(at) end
    return {layer(name,at,opts)},C.Composition.ResultLife
end
function Ability.Stop(self: any,record: any)
    if record.Handle then record.Handle:Finish();record.Handle=nil end
    if record.Controller then record.Controller:Stop("CastWindup",C.Composition.CancelFade) end
    if record.Active and record.Owner==self.Callbacks.LocalUserId and self.Callbacks.Cast then self.Callbacks.Cast({Phase="End",Token=record.Token}) end
    record.Active=false
end
function Ability.Valid(self: any,e: any): any
    if type(e)~="table" or e.Kind~="AbilityVisual" or type(e.AbilityId)~="string" or not self.Data.Abilities[e.AbilityId] then return nil end
    if not finite(e.Owner) or e.Owner%1~=0 or not finite(e.Token) or e.Token<1 or e.Token%1~=0 then return nil end
    if not finite(e.At) or not point(e.Position) or not finite(e.Tier) or e.Tier%1~=0 or e.Tier<1 or e.Tier>#C.Tier then return nil end
    local age=self.Callbacks.Clock()-e.At
    if age>C.Protocol.MaxAge or age< -C.Protocol.FutureTolerance then return nil end
    local player=self.Callbacks.Player(e.Owner)
    if not player or player.Character~=e.Character or typeof(e.Character)~="Instance" or not e.Character:IsA("Model") or not e.Character.Parent then return nil end
    if e.Phase=="Begin" then
        if not finite(e.EndsAt) or e.EndsAt<e.At or e.EndsAt-e.At>C.Lifetime.Maximum then return nil end
    elseif e.Phase=="Result" then
        if not point(e.Origin) or not point(e.Destination) or type(e.Outcome)~="string" then return nil end
        if e.Radius~=nil and (not finite(e.Radius) or e.Radius<0 or e.Radius>C.Safety.PositionLimit) then return nil end
        if e.Affected then
            if type(e.Affected)~="table" or #e.Affected>C.Protocol.MaxAffected then return nil end
            for _,item in ipairs(e.Affected) do if type(item)~="table" or not point(item.Position) then return nil end end
        end
        if (e.Gates or e.Echo) and (not finite(e.ExpiresAt) or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife) then return nil end
    elseif e.Phase=="Reveal" then
        if e.Owner~=self.Callbacks.LocalUserId or type(e.Targets)~="table" or #e.Targets>C.Protocol.MaxReveals or not finite(e.ExpiresAt) then return nil end
        for _,target in ipairs(e.Targets) do if type(target)~="table" or not point(target.Position) then return nil end end
    elseif e.Phase~="Cancel" then return nil end
    return player
end
function Ability.Record(self: any,e: any): any
    local record=self.Records[e.Owner]
    if record and record.Character~=e.Character then self:Stop(record);record=nil end
    if record and e.Token<record.Token then return nil end
    if record and e.Token==record.Token and record.AbilityId~=e.AbilityId then return nil end
    if not record or e.Token>record.Token then
        if record then self:Stop(record) end
        local count=0;local oldestOwner=nil;local oldest=math.huge
        for owner,item in pairs(self.Records) do
            count+=1;if item.At<oldest then oldest=item.At;oldestOwner=owner end
        end
        if count>=C.Protocol.MaxOwners and oldestOwner then self:Stop(self.Records[oldestOwner]);self.Records[oldestOwner]=nil end
        record={Owner=e.Owner,Token=e.Token,AbilityId=e.AbilityId,Character=e.Character,At=e.At,Active=false,Completed=false,Revealed=false}
        self.Records[e.Owner]=record
    end
    return record
end
function Ability.Event(self: any,e: any): boolean
    if e.Kind=="StatusVisual" or e.Kind=="GateRemoval" or e.Kind=="VisualTrigger" or e.Kind=="GateSnapshot" or e.Kind=="EchoSnapshot" then return self:Auxiliary(e) end
    local player=self:Valid(e)
    if not player then return false end
    local record=self:Record(e)
    if not record then return false end
    local a=self.Data.Abilities[e.AbilityId]
    if e.Phase=="Reveal" then
        if record.Revealed then return false end
        record.Revealed=true;self.Status:Reveal(e,a.PathwayId);return true
    end
    if e.Phase=="Begin" then
        if record.Active or record.Completed or e.EndsAt<=self.Callbacks.Clock() then return false end
        record.Active=true;record.EndsAt=e.EndsAt
        local visible=self.Service:Visible(e.Position)
        if visible or e.Owner==self.Callbacks.LocalUserId then
            record.Controller=self.Callbacks.Controller(player.Character)
            if record.Controller then record.Controller:Play("CastWindup",nil,nil,C.Ability.Profiles[a.Id]) end
            local layers,duration=self:Layers(a,e)
            record.Handle=self.Blocks:Compose(layers,e.Tier,C.Composition.WindupPriority,math.min(duration,C.Lifetime.Maximum))
            if record.Handle then record.Handle.CasterId=e.Owner;record.Handle.Character=e.Character end
        end
        if e.Owner==self.Callbacks.LocalUserId and self.Callbacks.Cast then self.Callbacks.Cast(e) end
        return true
    end
    if record.Completed then return false end
    self:Stop(record);record.Completed=true;record.At=e.At
    if e.Phase=="Cancel" then return true end
    if e.Gates then self.Status:Gate(e) end
    if e.Echo then self.Status:Echo(e) end
    local visible=self.Service:Visible(e.Position) or self.Service:Visible(e.Origin) or self.Service:Visible(e.Destination)
    if not visible then return true end
    local controller=self.Callbacks.Controller(player.Character)
    if controller then controller:Play("CastRelease",nil,nil,C.Ability.Profiles[a.Id]) end
    local layers,duration=self:Layers(a,e)
    record.Result=self.Blocks:Compose(layers,e.Tier,C.Composition.Priority,duration)
    if record.Result then record.Result.CasterId=e.Owner;record.Result.Character=e.Character end
    self.Callbacks.Audio(a.SFXHook)
    return true
end
function Ability.Update(self: any,state: any)
    local path=if state and state.Ready then tostring(state.PathwayId)..":"..tostring(state.Sequence) else nil
    if self.LocalPath~=path or not state or state.Dead or not state.Ready then
        self.Status:ClearLocal(self.Callbacks.LocalUserId)
        local record=self.Records[self.Callbacks.LocalUserId]
        if record then self:Stop(record);record.Completed=true;if record.Result then record.Result:Finish() end end
        local finishing={}
        for _,handle in pairs(self.Service.Active) do if handle.CasterId==self.Callbacks.LocalUserId then table.insert(finishing,handle) end end
        for _,handle in ipairs(finishing) do handle:Finish() end
    end
    self.LocalPath=path
end
function Ability.Auxiliary(self: any,e: any): boolean
    if not finite(e.Owner) or not finite(e.At) then return false end
    local age=self.Callbacks.Clock()-e.At
    if age>C.Protocol.MaxAge or age< -C.Protocol.FutureTolerance then return false end
    if e.Kind=="GateSnapshot" or e.Kind=="EchoSnapshot" then
        if not point(e.Position) or not finite(e.ExpiresAt) or e.ExpiresAt<=self.Callbacks.Clock()
            or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife then return false end
        if e.Kind=="GateSnapshot" and (e.AbilityId=="Apprentice_5_Secondary" or e.AbilityId=="Apprentice_1") then self.Status:Gate(e);return true end
        if e.Kind=="EchoSnapshot" and e.AbilityId=="Seer_3" then self.Status:Echo(e);return true end
        return false
    end
    if e.Kind=="StatusVisual" then
        if not point(e.Position) or not finite(e.Revision) or not finite(e.ExpiresAt) or (e.Action~="Set" and e.Action~="Remove") then return false end
        if e.Action=="Set" and (e.ExpiresAt<=self.Callbacks.Clock() or e.ExpiresAt-self.Callbacks.Clock()>C.Protocol.MaxStatusLife) then return false end
        if e.Count~=nil and (not finite(e.Count) or e.Count<0) then return false end
        if e.Required~=nil and (not finite(e.Required) or e.Required<1 or e.Required%1~=0) then return false end
        if e.Action=="Set" and e.Owner==self.Callbacks.LocalUserId and self.LocalPath
            and e.PathwayId~=string.match(self.LocalPath,"^[^:]+") then return false end
        return self.Status:Event(e,self.Callbacks.LocalUserId)
    end
    if not finite(e.CueId) or e.CueId<1 or e.CueId%1~=0 then return false end
    if e.Kind=="GateRemoval" then
        if e.CueId<=self.LastGateCue then return false end
        self.LastGateCue=e.CueId;self.Status:RemoveGates(e.Owner);return true
    end
    local expected={SubstituteTriggered="Seer_7_Secondary",GraftReflected="Seer_1",PayloadTriggered="Marauder_2_Secondary"}
    if e.CueId<=self.LastCue or expected[e.Trigger]~=e.AbilityId or not point(e.Position) or not point(e.Origin)
        or not finite(e.Tier) or e.Tier<1 or e.Tier>#C.Tier or e.Tier%1~=0 then return false end
    local player=self.Callbacks.Player(e.Owner)
    if not player or player.Character~=e.Character then return false end
    self.LastCue=e.CueId
    local event=table.clone(e);event.Phase="Result";event.Destination=e.Origin
    local layers,duration=self:Layers(self.Data.Abilities[e.AbilityId],event)
    local handle=self.Blocks:Compose(layers,e.Tier,C.Hit.Priority,duration)
    if handle then handle.CasterId=e.Owner;handle.Character=e.Character end
    if handle and self.Callbacks.Audio then self.Callbacks.Audio("Trigger."..e.Trigger) end
    return true
end
function Ability.Step(self: any)
    local now=self.Callbacks.Clock()
    for owner,record in pairs(self.Records) do
        local player=self.Callbacks.Player(owner)
        if not player or player.Character~=record.Character or not record.Character.Parent then
            self:Stop(record);if record.Result then record.Result:Finish() end;self.Records[owner]=nil
        elseif record.Active and now>record.EndsAt+C.Protocol.ResultGrace then self:Stop(record);record.Completed=true end
        if now-record.At>C.Protocol.MaxAge then self:Stop(record);self.Records[owner]=nil end
    end
    self.Status:Step()
    local finishing={}
    for _,handle in pairs(self.Service.Active) do
        if handle.Character and not handle.Character.Parent then table.insert(finishing,handle) end
    end
    for _,handle in ipairs(finishing) do handle:Finish() end
    for i=#self.Previews,1,-1 do if not self.Previews[i].Active then table.remove(self.Previews,i) end end
end
function Ability.Preview(self: any,id: string,variant: string,origin: Vector3,destination: Vector3,target: Instance?,phase: string?,trigger: string?): any
    local a=self.Data.Abilities[id]
    if not a then return nil end
    local now=self.Callbacks.Clock()
    local event={Phase=phase or "Result",Position=if a.Target=="NPC" then destination else origin,Origin=origin,Destination=if a.Target=="NPC" then origin else destination,
        Outcome=variant,Target=target,Tier=VfxService.PowerTier(a.UnlockSequence),EndsAt=now+a.CastTimeSeconds,Preview=true,Trigger=trigger,
        Radius=C.Ability.PreviewRadius,Affected={{Target=target,Position=destination}},Echo=if id=="Seer_3" then target else nil}
    local layers,duration=self:Layers(a,event)
    local handle=self.Blocks:Compose(layers,event.Tier,C.Composition.Priority,duration)
    if handle then table.insert(self.Previews,handle) end
    return handle
end
function Ability.ClearPreviews(self: any)
    for _,handle in ipairs(self.Previews) do handle:Finish() end;table.clear(self.Previews)
end
function Ability.Destroy(self: any)
    for _,record in pairs(self.Records) do self:Stop(record);if record.Result then record.Result:Finish() end end
    table.clear(self.Records);self:ClearPreviews();self.Status:Clear()
end
return Ability
