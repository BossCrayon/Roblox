--!strict
-- Read-only UI calculations. These never authorize a server transaction.
local Model={}
function Model.Unlocked(data: any,state: any): {string}
    local ids={}
    if not state or not state.Ready or not state.PathwayId then return ids end
    for id,a in pairs(data.Abilities) do
        if a.PathwayId==state.PathwayId and state.Sequence<=a.UnlockSequence then table.insert(ids,id) end
    end
    table.sort(ids,function(a: string,b: string)
        local aa,bb=data.Abilities[a],data.Abilities[b]
        return if aa.UnlockSequence==bb.UnlockSequence then a<b else aa.UnlockSequence<bb.UnlockSequence
    end)
    return ids
end
function Model.NextPotion(state: any): string?
    if not state or not state.PathwayId or not state.Sequence or state.Sequence<=1 then return nil end
    return state.PathwayId.."_Potion_"..tostring(state.Sequence-1)
end
function Model.Potion(data: any,state: any,id: string?,purchase: boolean): any
    local potion=id and data.Potions.ById[id]
    if not state or not state.Ready then return {Allowed=false,Reason="Your journal is still opening"} end
    if not potion then return {Allowed=false,Reason=if state.PathwayId then "No further potion is available" else "Choose a starting potion in Inventory"} end
    local owned=state.Inventory[id] or 0
    local reason=nil
    if state.Dead or state.Mode~="Normal" or state.Casting then reason="You cannot use the altar during this condition"
    elseif purchase then
        if id~=Model.NextPotion(state) then reason="This is not your next potion"
        elseif owned>0 then reason="You already own this potion"
        elseif state.Gold<data.Runtime.NextPotionGoldCost then reason="Not enough gold" end
    elseif owned<1 then reason="You do not own this potion"
    elseif potion.TargetSequence==9 and state.PathwayId then reason="Your pathway is already chosen"
    elseif potion.TargetSequence~=9 and (state.PathwayId~=potion.PathwayId or state.Sequence~=potion.RequiredSequence) then reason="Follow your pathway one sequence at a time"
    elseif state.Digestion<potion.RequiredDigestion then reason="Digest your current potion completely first"
    elseif state.Sanity<=data.Progression.Sanity.BlockAdvancementAtOrBelow then reason="Recover your sanity before advancing" end
    return {Allowed=reason==nil,Reason=reason or (if purchase then "Purchase requires proximity to the altar" else "Your pathway choice and advancement are permanent"),
        Potion=potion,Owned=owned,Cost=if purchase then data.Runtime.NextPotionGoldCost else 0}
end
function Model.Cooldown(state: any,id: string,elapsed: number): number
    return math.max(0,((state and state.Cooldowns and state.Cooldowns[id]) or 0)-math.max(0,elapsed))
end
function Model.Ultimate(data: any,state: any,elapsed: number): any
    local u=data and data.Runtime and data.Runtime.Ultimate
    if not u or not state or not state.Ready or not state.PathwayId or type(state.Sequence)~="number" then
        return {Unlocked=false,Stage=false,Name="Mythical Form",Title="Unlocks at Sequence 4 (Saint)",Active=false,Remaining=0,Duration=10,Cooldown=0,Cost=u and u.SpiritualityCost or 45}
    end
    local form=u.Forms[state.PathwayId] or u.Forms.Seer
    local unlocked=state.Sequence<=u.UnlockSequence
    local stage=if not unlocked then false elseif state.Sequence<=u.CompleteSequence then "Complete" else "Incomplete"
    local duration=if stage=="Complete" then u.CompleteDuration else u.IncompleteDuration
    local remaining=if state.UltimateStage then math.max(0,(state.UltimateRemaining or 0)-math.max(0,elapsed)) else 0
    local active=unlocked and remaining>0
    local cd=Model.Cooldown(state,"Ultimate",elapsed)
    local title=if not unlocked then form.Name.." · Locked until Sequence 4 (Saint)"
        elseif stage=="Complete" then form.CompleteTitle
        else form.IncompleteTitle
    return {
        Unlocked=unlocked,
        Stage=stage,
        Name=form.Name,
        Title=title,
        Active=active,
        Remaining=remaining,
        Duration=duration,
        Cooldown=cd,
        Cost=u.SpiritualityCost,
        SanityCost=if stage=="Complete" then u.CompleteSanityCost else u.IncompleteSanityCost,
    }
end
return table.freeze(Model)
