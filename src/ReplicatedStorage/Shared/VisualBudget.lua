--!strict
-- Pure admission policy: reservations are atomic; equal/higher priority effects survive.
local Budget={}
Budget.__index=Budget
type Counts={ [string]: number }
type Entry={Costs: Counts, Priority: number, Serial: number}
type Fields={Limits: Counts,Used: Counts,MaxEffects: number,Count: number,Serial: number,Entries:{[string]: Entry}}
export type VisualBudget=typeof(setmetatable({} :: Fields,Budget))
local function finite(value: number): boolean
    return value==value and value>-math.huge and value<math.huge
end
local function valid(costs: Counts,limits: Counts): boolean
    for class,count in pairs(costs) do
        if type(count)~="number" or not finite(count) or count<0 or count%1~=0 or limits[class]==nil or count>limits[class] then return false end
    end
    return true
end
function Budget.new(limits: Counts,maxEffects: number): VisualBudget
    assert(finite(maxEffects) and maxEffects>0 and maxEffects%1==0,"Invalid effect cap")
    local used: Counts={}
    for class,count in pairs(limits) do
        assert(finite(count) and count>=0 and count%1==0,"Invalid pool cap")
        used[class]=0
    end
    return setmetatable({Limits=table.clone(limits),Used=used,MaxEffects=maxEffects,Count=0,Serial=0,Entries={}},Budget)
end
local function fits(self: VisualBudget,costs: Counts,used: Counts,count: number): boolean
    if count>=self.MaxEffects then return false end
    for class,cost in pairs(costs) do
        if (used[class] or 0)+cost>self.Limits[class] then return false end
    end
    return true
end
function Budget.Plan(self: VisualBudget,costs: Counts,priority: number): {string}?
    if not finite(priority) or not valid(costs,self.Limits) then return nil end
    local used=table.clone(self.Used)
    if fits(self,costs,used,self.Count) then return {} end
    local candidates: {{Id:string,Entry:Entry}}={}
    for id,entry in pairs(self.Entries) do
        if entry.Priority<priority then table.insert(candidates,{Id=id,Entry=entry}) end
    end
    table.sort(candidates,function(a,b)
        return if a.Entry.Priority==b.Entry.Priority then a.Entry.Serial<b.Entry.Serial else a.Entry.Priority<b.Entry.Priority
    end)
    local victims: {string}={}
    local count=self.Count
    for _,candidate in ipairs(candidates) do
        table.insert(victims,candidate.Id);count-=1
        for class,cost in pairs(candidate.Entry.Costs) do used[class]-=cost end
        if fits(self,costs,used,count) then return victims end
    end
    return nil
end
function Budget.Add(self: VisualBudget,id: string,costs: Counts,priority: number): boolean
    if self.Entries[id] or not finite(priority) or not valid(costs,self.Limits) or not fits(self,costs,self.Used,self.Count) then return false end
    self.Serial+=1;self.Count+=1
    self.Entries[id]={Costs=table.clone(costs),Priority=priority,Serial=self.Serial}
    for class,count in pairs(costs) do self.Used[class]+=count end
    return true
end
function Budget.Remove(self: VisualBudget,id: string)
    local entry=self.Entries[id]
    if not entry then return end
    self.Entries[id]=nil;self.Count-=1
    for class,count in pairs(entry.Costs) do self.Used[class]-=count end
end
function Budget.Stats(self: VisualBudget): any
    return {Count=self.Count,Used=table.clone(self.Used),Limits=table.clone(self.Limits),MaxEffects=self.MaxEffects}
end
return Budget
