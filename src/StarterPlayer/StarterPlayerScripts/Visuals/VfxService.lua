--!strict
-- Client-only bounded pool/reservation owner. Nothing here can decide a hit or move a character.
local Shared=game:GetService("ReplicatedStorage").Shared
local Config=require(Shared.VfxConfig)
local Budget=require(Shared.VisualBudget)
local UserInputService=game:GetService("UserInputService")
local Service={}
Service.__index=Service
local Handle={}
Handle.__index=Handle
local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end
local function validPosition(position: any): boolean
    return typeof(position)=="Vector3" and finite(position.X) and finite(position.Y) and finite(position.Z)
        and position.Magnitude<=Config.Safety.PositionLimit
end
local function qualityLevel(): number
    local ok,value=pcall(function() return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value end)
    return if ok and type(value)=="number" and value>0 then value else Config.Quality.AutoLevel
end
local function camera(self: any): Camera?
    return self.Camera or workspace.CurrentCamera
end
local function defaults(object: any,class: string)
    local props: any
    if class=="ParticleEmitter" then props=Config.Particle
    elseif class=="PointLight" then props=Config.Light
    else props=Config[class] end
    if props then for property,value in pairs(props) do object[property]=value end end
    if class=="Part" then
        object.Anchored=true;object.CanCollide=false;object.CanTouch=false;object.CanQuery=false
        object.CastShadow=false;object.CFrame=CFrame.identity
    elseif class=="Beam" or class=="Trail" then
        object.Attachment0=nil;object.Attachment1=nil;object.Enabled=true
        if class=="Trail" then object:Clear() end
    elseif class=="ParticleEmitter" then object.Enabled=false;object:Clear()
    elseif class=="Highlight" then object.Adornee=nil;object.Enabled=true end
end
local function park(object: any,class: string)
    if class=="Beam" or class=="Trail" then
        object.Enabled=false;object.Attachment0=nil;object.Attachment1=nil
        if class=="Trail" then object:Clear() end
    elseif class=="ParticleEmitter" then object.Enabled=false;object:Clear()
    elseif class=="PointLight" then object.Enabled=false
    elseif class=="Highlight" then object.Enabled=false;object.Adornee=nil end
    object.Parent=nil
end
function Handle.Acquire(self: any,class: string,parent: Instance?): any
    if not self.Active or (self.Acquired[class] or 0)>=(self.Costs[class] or 0) then return nil end
    local owner=self.Owner
    local pool=owner.Pools[class]
    if not pool then return nil end
    local object=table.remove(pool)
    if not object then
        if owner.Allocated[class]>=owner.Limits[class] then return nil end
        object=Instance.new(class :: any);owner.Allocated[class]+=1
    end
    local acquired: any=object
    defaults(acquired,class)
    acquired.Name="VFX_"..class;acquired.Parent=parent or owner.Folder
    self.Acquired[class]=(self.Acquired[class] or 0)+1
    table.insert(self.Objects,{Object=acquired,Class=class})
    return acquired
end
function Handle.Finish(self: any)
    if not self.Active then return end
    self.Active=false
    local owner=self.Owner
    owner.Active[self.Id]=nil;owner.Budget:Remove(self.Id)
    if self.OnFinish then
        local ok=pcall(self.OnFinish)
        if not ok then owner.Errors+=1 end
    end
    for _,entry in ipairs(self.Objects) do
        park(entry.Object,entry.Class);table.insert(owner.Pools[entry.Class],entry.Object)
    end
    table.clear(self.Objects);self.Update=nil;self.OnFinish=nil;self.ResolveAnchors=nil;self.Anchors=nil;self.Character=nil;self.CasterId=nil
end
Handle.Stop=Handle.Finish
function Service.new(options: any?): any
    local settings=options or {}
    local folder=Instance.new("Folder");folder.Name="LocalVisualFramework";folder.Parent=workspace
    local mobile=if settings.Mobile~=nil then settings.Mobile else UserInputService.TouchEnabled
    local limits=if mobile then Config.Pools.Mobile else Config.Pools.Desktop
    local self: any=setmetatable({Folder=folder,Camera=settings.Camera,Mobile=mobile,MobileOverride=settings.Mobile,
        LowGraphics=settings.LowGraphics==true,ReducedMotion=settings.ReducedMotion==true,
        Pools={},Allocated={},Limits=limits,Active={},Serial=0,Evicted=0,Dropped=0,Errors=0,Destroyed=false,ProfileKey=""},Service)
    for class in pairs(limits) do self.Pools[class]={};self.Allocated[class]=0 end
    self:_Refresh()
    return self
end
function Service._Refresh(self: any)
    local mobile=if self.MobileOverride~=nil then self.MobileOverride else UserInputService.TouchEnabled
    if mobile~=self.Mobile then
        local finishing={}
        for _,effect in pairs(self.Active) do table.insert(finishing,effect) end
        for _,effect in ipairs(finishing) do effect:Finish() end
        self.Mobile=mobile;self.Limits=if mobile then Config.Pools.Mobile else Config.Pools.Desktop
        for class,pool in pairs(self.Pools) do
            while self.Allocated[class]>self.Limits[class] do
                local object=table.remove(pool)
                if not object then break end
                object:Destroy();self.Allocated[class]-=1
            end
        end
        self.ProfileKey=""
    end
    local level=qualityLevel()
    local q=Config.Quality
    local low=self.LowGraphics or level<=q.LowLevel
    local detail=if low then q.Low else (if level<=q.MediumLevel then q.Medium else q.High)
    local maxEffects=if low then q.LowEffects else (if level<=q.MediumLevel then q.MediumEffects else q.HighEffects)
    if self.Mobile then maxEffects=math.min(maxEffects,q.MobileEffects) end
    local key=tostring(detail)..":"..tostring(self.ReducedMotion)
    if self.ProfileKey~=key then
        local finishing={}
        for _,effect in pairs(self.Active) do table.insert(finishing,effect) end
        for _,effect in ipairs(finishing) do effect:Finish() end
        self.Budget=Budget.new(self.Limits,maxEffects);self.ProfileKey=key
    end
    self.CurrentProfile={Detail=detail,Low=low,ReducedMotion=self.ReducedMotion,Mobile=self.Mobile,Level=level,MaxEffects=maxEffects}
end
function Service.Profile(self: any): any
    self:_Refresh()
    return table.clone(self.CurrentProfile)
end
function Service.Visible(self: any,position: any): boolean
    if self.Destroyed or not validPosition(position) then return false end
    local current=camera(self)
    if not current or (position-current.CFrame.Position).Magnitude>Config.Quality.MaximumDistance then return false end
    local point,onScreen=current:WorldToViewportPoint(position)
    return onScreen and point.Z>0
end
function Service.Detail(self: any,position: Vector3): number
    local profile=self:Profile()
    local current=camera(self)
    if not current then return profile.Detail end
    local distance=(position-current.CFrame.Position).Magnitude
    if distance>Config.Quality.Middle then return profile.Detail*Config.Quality.FarScale end
    if distance>Config.Quality.Near then return profile.Detail*Config.Quality.MiddleScale end
    return profile.Detail
end
function Service.PowerTier(sequence: number): number
    if sequence>=Config.TierSequences.Low then return 1 end
    if sequence>=Config.TierSequences.Middle then return 2 end
    return #Config.Tier
end
function Service.Begin(self: any,name: string,position: Vector3,tier: number,priority: number,costs: {[string]:number}?,anchors: {Vector3}?): any
    if not validPosition(position) then self.Dropped+=1;return nil end
    if anchors then
        if #anchors==0 or #anchors>Config.Composition.MaxAnchors then self.Dropped+=1;return nil end
        local visible=false
        for _,anchor in ipairs(anchors) do
            if not validPosition(anchor) then self.Dropped+=1;return nil end
            visible=self:Visible(anchor) or visible
        end
        if not visible then self.Dropped+=1;return nil end
    elseif not self:Visible(position) then self.Dropped+=1;return nil end
    self:_Refresh()
    if not finite(tier) then self.Dropped+=1;return nil end
    local request=costs or Config.DefaultCosts
    if (request.PointLight or 0)>Config.Safety.MaximumLightsPerEffect then self.Dropped+=1;return nil end
    local victims=self.Budget:Plan(request,priority)
    if not victims then self.Dropped+=1;return nil end
    for _,id in ipairs(victims) do
        local victim=self.Active[id]
        if victim then victim:Finish();self.Evicted+=1 end
    end
    self.Serial+=1
    local id=tostring(self.Serial)
    if not self.Budget:Add(id,request,priority) then self.Dropped+=1;return nil end
    local resolvedTier=math.clamp(math.floor(tier),1,#Config.Tier)
    local effect: any=setmetatable({Owner=self,Id=id,Name=name,Position=position,Tier=resolvedTier,
        Scale=Config.Tier[resolvedTier].Scale,Detail=self:Detail(position),Low=self.CurrentProfile.Low,
        ReducedMotion=self.ReducedMotion,Priority=priority,Costs=table.clone(request),Acquired={},Objects={},
        Age=0,Duration=Config.Lifetime.Default,Active=true,Update=nil,OnFinish=nil,Anchors=anchors and table.clone(anchors)},Handle)
    self.Active[id]=effect
    return effect
end
function Service.SetSettings(self: any,reduced: boolean,low: boolean)
    if self.Destroyed then return end
    self.ReducedMotion=reduced;self.LowGraphics=low;self:_Refresh()
end
function Service.Step(self: any,dt: number)
    if self.Destroyed or not finite(dt) or dt<0 then return end
    self:_Refresh()
    local snapshot={}
    for _,effect in pairs(self.Active) do table.insert(snapshot,effect) end
    for _,effect in ipairs(snapshot) do
        if not effect.Active then continue end
        effect.Age+=dt
        if effect.ResolveAnchors then
            local ok=pcall(effect.ResolveAnchors)
            if not ok then self.Errors+=1;effect:Finish() end
            if not effect.Active then continue end
        end
        local duration=if finite(effect.Duration) then math.clamp(effect.Duration,0,Config.Lifetime.Maximum) else Config.Lifetime.Default
        local visible=false
        if effect.Anchors then for _,anchor in ipairs(effect.Anchors) do visible=self:Visible(anchor) or visible end
        else visible=self:Visible(effect.Position) end
        if not visible then effect:Finish();continue end
        local progress=if duration>0 then math.clamp(effect.Age/duration,0,1) else 1
        if effect.Update then
            local ok=pcall(effect.Update,math.min(dt,Config.Lifetime.MaxStep),effect.Age,progress)
            if not ok then self.Errors+=1;effect:Finish() end
        end
        if effect.Age>=duration then effect:Finish() end
    end
end
function Service.Stats(self: any): any
    local stats=self.Budget:Stats()
    local pools={}
    for class,pool in pairs(self.Pools) do pools[class]=#pool end
    return {Active=stats.Count,Reserved=stats.Used,Limits=table.clone(self.Limits),Allocated=table.clone(self.Allocated),
        Pools=pools,MaxEffects=stats.MaxEffects,Evicted=self.Evicted,Dropped=self.Dropped,Errors=self.Errors}
end
function Service.Destroy(self: any)
    if self.Destroyed then return end
    self.Destroyed=true
    local snapshot={}
    for _,effect in pairs(self.Active) do table.insert(snapshot,effect) end
    for _,effect in ipairs(snapshot) do effect:Finish() end
    for _,pool in pairs(self.Pools) do for _,object in ipairs(pool) do object:Destroy() end;table.clear(pool) end
    self.Folder:Destroy()
end
return Service
