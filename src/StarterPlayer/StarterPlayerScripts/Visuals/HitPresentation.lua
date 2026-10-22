--!strict
-- Confirmed hits only. Recoil is a disposable silhouette; target physics never move.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local HitPresentation={}
function HitPresentation.new(vfx: any,blocks: any): any
    return setmetatable({VFX=vfx,Blocks=blocks,Flashes=setmetatable({},{__mode="k"}),Deaths=setmetatable({},{__mode="k"})},{__index=HitPresentation})
end
function HitPresentation.Hit(self: any,event: any)
    local target=event.Target
    if typeof(target)~="Instance" or not target:IsA("Model") or not target.Parent then return end
    if not self.VFX:Visible(event.Position) then return end
    local humanoid=target:FindFirstChildOfClass("Humanoid")
    if event.Dead==true or (humanoid and humanoid.Health<=C.Hit.MinimumHealth) then self:Death(target,event.Position);return end
    if self.VFX:Profile().ReducedMotion then return end
    local now=os.clock()
    if now-(self.Flashes[target] or -math.huge)<C.Hit.MinFlashGap then return end
    self.Flashes[target]=now
    local handle=self.VFX:Begin("ConfirmedHit",event.Position,1,C.Hit.Priority,C.Hit.Costs)
    if not handle then return end
    handle.Duration=C.Hit.Life
    local highlight=handle:Acquire("Highlight")
    if highlight then
        highlight.Adornee=target;highlight.FillColor=C.Highlight.FillColor
        highlight.FillTransparency=C.Hit.HighlightFill;highlight.OutlineTransparency=C.Hit.Outline
        highlight.Enabled=true
    end
    local body=target:FindFirstChild("UpperTorso") or target:FindFirstChild("Torso") or target.PrimaryPart
    local ghost=handle:Acquire("Part")
    local start: CFrame?=nil
    local direction=Vector3.zero
    if ghost and body and body:IsA("BasePart") then
        start=body.CFrame;direction=body.CFrame.LookVector
        ghost.Size=body.Size;ghost.CFrame=start;ghost.Color=C.Highlight.FillColor;ghost.Transparency=C.Hit.GhostAlpha
    end
    handle.Update=function(_dt: number,age: number)
        if not target.Parent then handle:Finish();return end
        if highlight then highlight.FillTransparency=C.Hit.HighlightFill+(1-C.Hit.HighlightFill)*math.clamp(age/C.Hit.Life,0,1) end
        if ghost and start then
            local alpha=math.clamp(age/C.Hit.KnockbackLife,0,1)
            ghost.CFrame=start+direction*C.Hit.KnockbackDistance*math.sin(alpha*math.pi)
            ghost.Transparency=C.Hit.GhostAlpha+(1-C.Hit.GhostAlpha)*alpha
        end
    end
end
function HitPresentation.Death(self: any,target: Model,position: Vector3)
    if self.Deaths[target] then return end
    local handle=self.VFX:Begin("DeathDissolve",position,1,C.Hit.Priority,C.Hit.DeathCosts)
    if not handle then return end
    self.Deaths[target]=true;handle.Duration=C.Hit.DeathHold
    local parts={}
    for _,item in ipairs(target:GetDescendants()) do
        if item:IsA("BasePart") and #parts<C.Hit.MaxParts then table.insert(parts,{Part=item,Original=item.LocalTransparencyModifier}) end
    end
    handle.OnFinish=function()
        self.Deaths[target]=nil
        for _,entry in ipairs(parts) do
            if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Original end
        end
    end
    handle.Update=function(_dt: number,age: number)
        if not target.Parent then handle:Finish();return end
        local alpha=math.clamp(age/C.Hit.DeathLife,0,1)
        for _,entry in ipairs(parts) do
            if entry.Part.Parent then entry.Part.LocalTransparencyModifier=entry.Original+(1-entry.Original)*alpha end
        end
    end
    self.Blocks:Play("RisingMotes",position,"Seer",1)
end
return HitPresentation
