--!strict
-- DataStore adapter is injected; UpdateAsync callbacks are pure and never yield.
local SessionStore={}
SessionStore.__index=SessionStore
type Fields = {Store: any, Domain: any, Config: any, Clock: () -> number, Sleep: (number) -> (), Random: () -> number}
type SessionStore = typeof(setmetatable({} :: Fields, SessionStore))

function SessionStore.new(store: any, domain: any, config: any, clock: () -> number, sleep: (number)->(), random: (() -> number)?): SessionStore
    return setmetatable({Store=store,Domain=domain,Config=config,Clock=clock,Sleep=sleep,Random=random or math.random} :: Fields, SessionStore)
end
function SessionStore.Update(self: SessionStore, key: string, transform: (any)->any): (boolean,any)
    local last=nil
    for attempt=1,self.Config.RetryCount do
        local ok,result=pcall(function() return self.Store:UpdateAsync(key,transform) end)
        if ok then return true,result end
        last=result
        if attempt<self.Config.RetryCount then
            local backoff=math.min(self.Config.BackoffMaxSeconds,self.Config.BackoffBaseSeconds*2^(attempt-1))
            self.Sleep(backoff*(1+self.Random()*self.Config.BackoffJitterFraction))
        end
    end
    return false,tostring(last)
end
function SessionStore.Acquire(self: SessionStore, userId: number, owner: string): (any?,string?)
    local key=self.Config.KeyPrefix..tostring(userId)
    local reason="Session is locked on another server"
    local ok,result=self:Update(key,function(old)
        local now=self.Clock()
        if old~=nil then
            if type(old)~="table" or old.Version~=1 or not self.Domain.Finite(old.ExpiresAt) or old.ExpiresAt<0 or (old.Owner~=nil and type(old.Owner)~="string") then
                reason="Unsupported or corrupt save envelope"; return nil
            end
            if old.Owner~=nil and old.Owner~=owner and old.ExpiresAt>now then return nil end
        end
        local data,err=self.Domain:Validate(if old==nil then self.Domain:Default() else old.Data)
        if not data then reason=err or "Invalid save"; return nil end
        return {Version=1,Owner=owner,ExpiresAt=now+self.Config.LockLeaseSeconds,Data=data}
    end)
    if not ok then return nil,"DataStore unavailable: "..tostring(result) end
    if not result or result.Owner~=owner then return nil,reason end
    return {Key=key,Owner=owner,Data=result.Data,ExpiresAt=result.ExpiresAt,Busy=false,Closed=false},nil
end
function SessionStore.Save(self: SessionStore, handle: any, profile: any, release: boolean): (boolean,string?)
    if handle.Closed then return false,"Session is closed" end
    if handle.Busy then return false,"Session is busy" end
    -- A stale server must never revive its own expired lease or save without ownership.
    if handle.ExpiresAt<=self.Clock() then handle.Closed=true; return false,"Session lease expired" end
    local clean,err=self.Domain:Validate(profile)
    if not clean then return false,err end
    handle.Busy=true
    handle.SaveSerial=(handle.SaveSerial or 0)+1
    local operation=handle.Owner.."#"..tostring(handle.SaveSerial)
    local ok,result=self:Update(handle.Key,function(old)
        local now=self.Clock()
        if type(old)~="table" or old.Version~=1 then return nil end
        -- A release may have committed before its HTTP response was lost.
        if release and old.Owner==nil and old.LastOperation==operation then return old end
        if old.Owner~=handle.Owner or not self.Domain.Finite(old.ExpiresAt) or old.ExpiresAt<=now then return nil end
        return {Version=1,Owner=if release then nil else handle.Owner,
            ExpiresAt=if release then 0 else now+self.Config.LockLeaseSeconds,Data=clean,LastOperation=operation}
    end)
    handle.Busy=false
    if not ok then return false,"Save unavailable: "..tostring(result) end
    if not result then handle.Closed=true; return false,"Session ownership lost" end
    handle.Data=clean; handle.ExpiresAt=result.ExpiresAt
    if release then handle.Closed=true end
    return true,nil
end
return SessionStore
