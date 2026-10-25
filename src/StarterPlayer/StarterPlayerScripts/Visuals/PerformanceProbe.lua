--!strict
-- Studio-only, bounded local stress harness. Measures Heartbeat intervals, not GPU time.
local RunService=game:GetService("RunService")
local T=require(game:GetService("ReplicatedStorage").Shared.Theme)
local Probe={}
local function total(counts: any): number local n=0;for _,v in pairs(counts) do n+=v end;return n end
function Probe.new(service: any,blocks: any): any
    return setmetatable({Service=service,Blocks=blocks,Running=false,Reports=0,Last=nil,Handles={},Frames={}},{__index=Probe})
end
function Probe.Start(self: any,position: Vector3,palette: string): boolean
    if not RunService:IsStudio() or self.Running or self.Reports>=T.QA.MaxReports then return false end
    self.Running=true;self.Elapsed=0;self.NextBurst=0;self.Position=position;self.Palette=palette
    self.Frames={};self.FrameSerial=0;self.Peak=0;self.Violations=0;self.Attempts=0;self.Handles={};self.Before=self.Service:Stats()
    self.BeforeInstances=#workspace:GetDescendants()
    return true
end
function Probe.Cancel(self: any)
    for _,handle in ipairs(self.Handles) do if handle.Active then handle:Finish() end end
    self.Handles={};self.Running=false
end
function Probe.Finish(self: any)
    local stats=self.Service:Stats();local frames=table.clone(self.Frames);table.sort(frames)
    local function percentile(fraction: number): number return frames[math.max(1,math.ceil(#frames*fraction))] or 0 end
    local profile=self.Service:Profile();local pools=true
    for class,count in pairs(stats.Allocated) do if count>self.Service.Limits[class] then pools=false end end
    self.Reports+=1
    self.Last={MedianMs=percentile(0.5),P95Ms=percentile(0.95),MaxMs=frames[#frames] or 0,Samples=#frames,Peak=self.Peak,Cap=profile.MaxEffects,
        Allocated=total(stats.Allocated),Reserved=total(stats.Reserved),Active=stats.Active,Errors=stats.Errors-self.Before.Errors,
        BudgetViolations=self.Violations,BeforeActive=self.Before.Active,BeforeReserved=total(self.Before.Reserved),
        Dropped=stats.Dropped-self.Before.Dropped,Evicted=stats.Evicted-self.Before.Evicted,PoolsBounded=pools,
        InstancesBefore=self.BeforeInstances,InstancesAfter=#workspace:GetDescendants(),Attempts=self.Attempts,Mobile=profile.Mobile,Quality=profile.Level,
        Reduced=self.Service.ReducedMotion,Low=self.Service.LowGraphics}
    self:Cancel()
    print(T.QA.ReportPrefix..game:GetService("HttpService"):JSONEncode(self.Last))
end
function Probe.Step(self: any,dt: number)
    if not self.Running then return end
    self.Elapsed+=dt;self.FrameSerial+=1
    self.Frames[(self.FrameSerial-1)%T.QA.Samples+1]=dt*1000
    local stats=self.Service:Stats();self.Peak=math.max(self.Peak,stats.Active)
    if stats.Active>self.Service:Profile().MaxEffects then self.Violations+=1 end
    if self.Elapsed>=T.QA.Duration+T.QA.Drain then self:Finish();return end
    if self.Elapsed>T.QA.Duration or self.Elapsed<self.NextBurst then return end
    self.NextBurst=self.Elapsed+T.QA.SpawnInterval
    local alive={};for _,handle in ipairs(self.Handles) do if handle.Active then table.insert(alive,handle) end end;self.Handles=alive
    local names={"CardFan","VeilRibbon","GroundRune","SigilStencil"}
    for i=1,self.Service:Profile().MaxEffects+T.QA.Overfill do
        self.Attempts+=1
        local at=self.Position+Vector3.xAxis*((i%3)-1)
        local h=self.Blocks:Compose({{Name=names[(i-1)%#names+1],Position=at,Palette=self.Palette,
            Options={Scale=T.QA.Scale,Glyph="Seal",Frame=CFrame.new(at)}}},1,T.QA.Priority,T.World.Ambient.Life)
        if h then table.insert(self.Handles,h) end
    end
    self.Peak=math.max(self.Peak,self.Service:Stats().Active)
end
return Probe
