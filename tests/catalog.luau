--!strict
return function(data: any)
    print("# Ability catalog\n")
    print("Generated from the runtime modules. All lore metadata remains [UNVERIFIED]. These are bounded original gameplay implementations. Audio assets are optional bindings to SFX hooks.\n")
    for _,pathId in ipairs({"Seer","Marauder","Apprentice"}) do
        local path=data.Pathways[pathId]
        print("## "..pathId.." / "..path.Alias.."\n")
        print("| Seq | Ability | Executor | Target | Cost | Cooldown |")
        print("|---|---|---|---|---|---|")
        for n=9,1,-1 do
            for _,id in ipairs(path.Sequences[n].AbilityIds) do
                local a=data.Abilities[id]
                print(string.format("| %d | %s | %s | %s | %d | %.1fs |",n,a.Name,a.Operation.Kind,a.Target,a.SpiritualityCost,a.CooldownSeconds))
            end
        end
        print("")
    end
end
