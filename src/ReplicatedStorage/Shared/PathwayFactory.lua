--!strict
local Stats = require(script.Parent.StatData)
local freeze = require(script.Parent.Freeze)
-- Internal construction helper; no discovery, player state, or runtime systems.
return function(id: string, alias: string, rows: {{any}}, source: string, customBaseStats: any?)
    local base = customBaseStats or Stats.BaseStats[id]
    assert(base, "New pathways must supply custom base stats")
    assert(#rows == 9, "Exactly nine rows required, ordered Sequence 9 to 1")
    local sequences = {}
    local abilities = {}
    for index, row in ipairs(rows) do
        local n = 10-index
        table.insert(abilities, {Id=id.."_"..tostring(n), UnlockSequence=n, Name=row[2],
            Description=row[5], Target=row[7], StatusEffects={}, Operation=row[9] and row[9].Primary})
        local ids = {id.."_"..tostring(n)}
        local extra = row[8]
        if extra then
            local extraId = id.."_"..tostring(n).."_Secondary"
            table.insert(ids, extraId)
            table.insert(abilities, {Id=extraId, UnlockSequence=n, Name=extra[1],
                Description=extra[3], Target=extra[2], StatusEffects={}, Operation=row[9] and row[9].Secondary})
        end
        sequences[n] = {
            Number=n, Name=row[1],
            Canon={status="[UNVERIFIED]", note="Name, power placement and passive require source review; wiki access blocked during authoring.", sources={source}},
            StatMultipliers=Stats.GetMultipliers(n), BaseStats=Stats.Scale(base,n),
            AbilityIds=ids, PassiveTraits={"[UNVERIFIED] "..row[6]},
            ActingObjectives={{Id=id.."_"..tostring(n).."_acting", Label=row[3], ServerSignal=row[4],
                RequiredCount=1, DigestionReward=5, ActingProgressReward=1, CooldownSeconds=30}},
        }
    end
    return freeze({Id=id, Name=id, Alias=alias, BaseStats=base, Sequences=sequences, AbilityDefinitions=abilities})
end
