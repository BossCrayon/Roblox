--!strict
return function(data: any)
    print("# Sequence balance tables\n")
    print("All numbers are original gameplay balance, not canon claims. Multipliers are absolute relative to Sequence 9, never compounded. Health/Strength/Intuition/Resistance/regen use t; spirituality uses t^1.5; Agility/Perception use sqrt(t); Sanity uses 1. Digestion starts at 0 and caps at 100 at every sequence.\n")
    print("Perception = Spirit Vision range in studs. Regen = spirituality per second. Resistance is a rating. Values rounded to two decimals. These are max/base stats; current resources belong to player state.\n")
    for _, id in ipairs({"Seer","Marauder","Apprentice"}) do
        print("## "..id.."\n")
        print("| Seq | Name | t | HP | Spirituality | Sanity | Strength | Agility | Perception | Intuition | Resistance | Regen/s |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|")
        for n=9,1,-1 do
            local s=data.Pathways[id].Sequences[n]
            local b=s.BaseStats
            print(string.format("| %d | %s | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f |",n,s.Name,s.StatMultipliers.Health,b.Health,b.Spirituality,b.Sanity,b.Strength,b.Agility,b.Perception,b.Intuition,b.Resistance,b.SpiritualityRegen))
        end
        print("")
    end
end
