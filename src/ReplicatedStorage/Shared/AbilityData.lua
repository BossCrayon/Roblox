--!strict
local Pathways = require(script.Parent.PathwayData)
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
local byId: {[string]: Types.Ability} = {}
for pathwayId, pathway in pairs(Pathways) do
    for n, sequence in pairs(pathway.Sequences) do
        local tier = sequence.StatMultipliers.Health
        local sourceModule = script.Parent.Pathways:FindFirstChild(pathwayId)
        assert(sourceModule, "Missing pathway module")
        -- Authored ability metadata lives in each pathway's AbilityDefinitions.
        for _, definition in ipairs(pathway.AbilityDefinitions) do
            if definition.UnlockSequence ~= n then continue end
            local ability: any = table.clone(definition)
            ability.PathwayId = pathwayId
            ability.Canon = sequence.Canon
            ability.CooldownSeconds = 5 + (9-n)*2
            ability.SpiritualityCost = math.round(12 * tier)
            ability.CastTimeSeconds = if n <= 4 then 1.5 else 0.5
            ability.RangeStuds = math.round(25 * math.sqrt(tier))
            ability.RadiusStuds = if n <= 4 then math.round(6*math.sqrt(tier)) else 0
            ability.MaxTargets = if n <= 4 then 4 else 1
            -- Abstract effect budget, not unconditional damage. Executor interprets by ability.
            ability.BasePower = math.round(10*tier)
            ability.Hitbox = {Shape=if ability.Target == "NPC" then "SingleTarget" else "None", LineOfSight=true}
            ability.StatusEffects = definition.StatusEffects or {}
            ability.VFXHook = "Ability."..ability.Id..".VFX"
            ability.SFXHook = "Ability."..ability.Id..".SFX"
            local operation=ability.Operation
            ability.Implemented = operation ~= nil
            if operation then
                ability.Target = operation.Target or ability.Target
                ability.RangeStuds = operation.Range or ability.RangeStuds
                ability.StatusEffects = if operation.Status then {operation.Status} else {}
                ability.Hitbox.Shape = if ability.Target == "NPC" then "SingleTarget" else "None"
            end
            assert(byId[ability.Id] == nil, "Duplicate ability ID")
            byId[ability.Id] = ability
        end
    end
end
return freeze(byId)
