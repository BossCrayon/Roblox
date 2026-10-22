--!strict
-- Run against the actual modules with tests/run.py, or call with GameData in Studio.
return function(data: any)
    local checks = 0
    local function check(condition: boolean, message: string)
        assert(condition, message)
        checks += 1
    end
    local function count(t: any): number
        local n=0
        for _ in pairs(t) do n+=1 end
        return n
    end
    check(count(data.Pathways) == 3, "Exactly three pathways in this release")
    check(count(data.Abilities) == 54, "Expected 54 authored ability definitions")
    check(count(data.Potions.ById) == 27, "Expected 27 potions")
    local expected = {
        Seer={"Attendant of Mysteries","Miracle Invoker","Scholar of Yore","Bizarro Sorcerer","Marionettist","Faceless","Magician","Clown","Seer"},
        Marauder={"Worm of Time","Trojan Horse of Destiny","Mentor of Deceit","Parasite","Dream Stealer","Prometheus","Cryptologist","Swindler","Marauder"},
        Apprentice={"Key of Stars","Planeswalker","Wanderer","Secrets Sorcerer","Traveler","Scribe","Astrologer","Trickmaster","Apprentice"},
    }
    for id, pathway in pairs(data.Pathways) do
        check(count(pathway.Sequences)==9 and pathway.Sequences[0]==nil, "Sequences 9 through 1 only")
        for n=1,9 do
            local s = pathway.Sequences[n]
            check(s.Name==expected[id][n], "Sequence order: "..id..tostring(n))
            check(s.Canon.status=="[UNVERIFIED]" and #s.Canon.sources>0, "Honest source metadata")
            check(#s.AbilityIds>=2 and #s.ActingObjectives>0, "Abilities and acting coverage")
            check(s.BaseStats.Sanity==100, "Sanity stays bounded at all tiers")
            for stat, value in pairs(s.BaseStats) do
                check(value>0 and value==value and value<math.huge, "Finite positive stat: "..stat)
                local expectedValue=math.round(pathway.BaseStats[stat]*s.StatMultipliers[stat]*100)/100
                check(math.abs(value-expectedValue)<0.001, "Stat multipliers agree")
                if n<9 and stat~="Sanity" then
                    check(value>pathway.Sequences[n+1].BaseStats[stat], "Power grows as sequence decreases")
                end
            end
            local potion=data.Potions.ById[id.."_Potion_"..tostring(n)]
            check(potion.TargetSequence==n and potion.PathwayId==id, "Potion matches sequence")
            check(potion.InitialDigestion==0 and potion.InitialActingProgress==0, "Advancement resets digestion/acting")
            if n==9 then
                check(potion.RequiredSequence==nil and potion.RequiresUninitiated and potion.RequiredDigestion==0, "Uninitiated starts at 9")
            else
                check(potion.RequiredSequence==n+1 and potion.RequiredDigestion==100, "No skipping or early advancement")
            end
            for _, abilityId in ipairs(s.AbilityIds) do
                local a=data.Abilities[abilityId]
                check(a~=nil and a.PathwayId==id and a.UnlockSequence==n, "No crossed ability references")
                check(a.Implemented and a.Operation and a.Canon.status=="[UNVERIFIED]", "Executor configuration and honest canon claim")
                check(a.SpiritualityCost<=s.BaseStats.Spirituality, "Unlocked ability is affordable")
                check(a.CooldownSeconds>0 and a.CastTimeSeconds>=0 and a.RangeStuds>=0, "Valid cast budget")
                check(a.Hitbox.LineOfSight and a.MaxTargets>=1, "Server targeting configuration")
                check(a.VFXHook~="" and a.SFXHook~="", "Asset hooks available")
                for _, effectId in ipairs(a.StatusEffects) do
                    check(data.StatusEffects[effectId]~=nil, "Known status effect reference")
                end
            end
            for _, o in ipairs(s.ActingObjectives) do
                check(o.RequiredCount>=1 and o.DigestionReward>0 and o.CooldownSeconds>0, "Bounded acting reward")
                check(o.DigestionReward<=data.Progression.Digestion.MaxRewardPerEvent and o.ServerSignal~="", "Server reward contract")
            end
        end
        for _, n in ipairs({7,5,4,2}) do
            check(pathway.Sequences[n].BaseStats.Health/pathway.Sequences[n+1].BaseStats.Health>=1.4, "Required tier power jump")
        end
    end
    for _, n in ipairs({0,10,1.5,-1}) do
        check(not pcall(data.Stats.Calculate,"Seer",n), "Reject invalid sequence")
    end
    check(not pcall(data.Stats.Calculate,"Unknown",9), "Reject unknown pathway")
    check(not pcall(function() data.Pathways.Seer.Sequences[9].BaseStats.Health=999 end), "Nested config immutable")
    check(not pcall(function() data.Abilities.Seer_9.Name="Tampered" end), "Abilities immutable")
    check(not data.Potions.Rules.AllowPathwaySwitch and not data.Potions.Rules.AllowEarlyAdvancement, "Safe advancement defaults")
    check(data.Progression.Sanity.FailureThreshold==0 and data.Progression.Sanity.MadnessDurationSeconds>0, "Loss-of-control configuration")
    check(data.Progression.Persistence.LockRefreshSeconds<data.Progression.Persistence.LockLeaseSeconds, "Lease refreshed before expiry")
    print("PASS: "..tostring(checks).." data assertions; 3 pathways, 27 sequences, 54 abilities, 27 potions")
end
