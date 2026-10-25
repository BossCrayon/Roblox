--!strict
-- Private sensing targets are granted by the server. No discovery/raycast runs here.
local C=require(game:GetService("ReplicatedStorage").Shared.VfxConfig)
local Status={}
function Status.new(service: any,clock: ()->number): any
    return setmetatable({Service=service,Clock=clock,Entries={}},{__index=Status})
end
function Status.Reveal(self: any,event: any,pathway: string)
    local life=math.clamp((event.ExpiresAt or 0)-self.Clock(),0,C.Protocol.RevealLife)
    if life<=0 then return end
    local palette=C.Palettes[pathway]
    local count=0
    for target,entry in pairs(self.Entries) do
        if not entry.Active then self.Entries[target]=nil else count+=1 end
    end
    for _,item in ipairs(event.Targets) do
        local target=item.Target
        if typeof(target)~="Instance" or not target.Parent or not self.Service:Visible(item.Position) then continue end
        local previous=self.Entries[target]
        if previous and previous.Active then previous.Age=0;previous.Duration=life;continue end
        if count>=C.Protocol.MaxStatuses then break end
        local h=self.Service:Begin("PrivateReveal",item.Position,1,C.Ability.RevealPriority,{Highlight=1})
        if not h then continue end
        count+=1;self.Entries[target]=h;h.Duration=life
        local highlight=h:Acquire("Highlight")
        highlight.Adornee=target;highlight.FillColor=palette.Primary;highlight.OutlineColor=palette.Accent
        highlight.FillTransparency=C.Ability.RevealFill;highlight.OutlineTransparency=C.Ability.RevealOutline
        h.Update=function(_dt: number,_age: number,t: number)
            if not target.Parent then h:Finish();return end
            if target:IsA("BasePart") then h.Position=target.Position
            elseif target:IsA("Model") then
                local root=target.PrimaryPart or target:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then h.Position=root.Position end
            end
            highlight.FillTransparency=C.Ability.RevealFill+(1-C.Ability.RevealFill)*t
            highlight.OutlineTransparency=C.Ability.RevealOutline+(1-C.Ability.RevealOutline)*t
        end
    end
end
function Status.Step(self: any)
    for target,entry in pairs(self.Entries) do if not entry.Active then self.Entries[target]=nil end end
end
function Status.Clear(self: any)
    for _,entry in pairs(self.Entries) do entry:Finish() end;table.clear(self.Entries)
end
return Status
