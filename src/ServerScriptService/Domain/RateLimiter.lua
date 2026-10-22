--!strict
local RateLimiter={}
RateLimiter.__index=RateLimiter
function RateLimiter.new(rate: number, burst: number)
    return setmetatable({Rate=rate,Burst=burst,Buckets={}},RateLimiter)
end
function RateLimiter:Allow(key: any, now: number, cost: number?): boolean
    local amount=cost or 1
    local b=self.Buckets[key] or {Tokens=self.Burst,Time=now}
    b.Tokens=math.min(self.Burst,b.Tokens+math.max(0,now-b.Time)*self.Rate); b.Time=now
    self.Buckets[key]=b
    if b.Tokens<amount then return false end
    b.Tokens-=amount
    return true
end
function RateLimiter:Remove(key: any) self.Buckets[key]=nil end
return RateLimiter
