--!strict
local Pathways = require(script.Parent.PathwayData)
local freeze = require(script.Parent.Freeze)
local potions = {}
for pathwayId, pathway in pairs(Pathways) do
    for n, sequence in pairs(pathway.Sequences) do
        local id = pathwayId.."_Potion_"..tostring(n)
        potions[id] = {
            Id=id, Name=sequence.Name.." Potion", PathwayId=pathwayId, TargetSequence=n,
            RequiredSequence=if n == 9 then nil else n+1,
            RequiredDigestion=if n == 9 then 0 else 100,
            RequiresUninitiated=n == 9, ConsumedOnSuccess=true,
            InitialDigestion=0, InitialActingProgress=0,
            -- Ingredients and rituals intentionally unavailable pending design/canon review.
            Ingredients={}, RitualId=nil, CraftingEnabled=false,
        }
    end
end
return freeze({ById=potions, Rules={
    StartingSequence=9, HighestSequence=1, AllowPathwaySwitch=false,
    AllowSequenceSkipping=false, AllowEarlyAdvancement=false,
    RequireLivingCharacter=true, RequireInventoryOwnership=true,
    RequireServerTransaction=true, ResetDigestionOnAdvance=true,
    -- If early advancement is enabled later, this penalty must run on the server.
    Risk={BaseChance=0.01, MissingDigestionWeight=0.65, MissingSanityWeight=0.30,
        MinChance=0, MaxChance=0.95, FailureSanityDamage=30},
}})
