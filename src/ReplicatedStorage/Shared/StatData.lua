--!strict
local freeze = require(script.Parent.Freeze)
local Types = require(script.Parent.Types)
type Stats = Types.Stats
-- Game balance values, not novel claims. Perception is Spirit Vision range in studs;
-- regen is spirituality/second. Resistance is a rating, not percent immunity.
local bases: {[string]: Stats} = {
    Seer = {Health=100, Spirituality=140, Sanity=100, Strength=10, Agility=12, Perception=45, Intuition=20, Resistance=12, SpiritualityRegen=2.4},
    Marauder = {Health=110, Spirituality=110, Sanity=100, Strength=12, Agility=18, Perception=30, Intuition=14, Resistance=10, SpiritualityRegen=2.0},
    Apprentice = {Health=100, Spirituality=130, Sanity=100, Strength=10, Agility=14, Perception=40, Intuition=16, Resistance=11, SpiritualityRegen=2.2},
}
-- Absolute multipliers relative to Sequence 9; never compound on a player's stats.
local tiers = {[9]=1, [8]=1.25, [7]=1.85, [6]=2.4, [5]=3.5, [4]=7, [3]=10, [2]=18, [1]=28}
local function multipliers(sequence: number): Stats
    local t = assert(tiers[sequence], "Sequence must be an integer from 1 through 9")
    return {
        Health=t, Spirituality=t*math.sqrt(t), Sanity=1,
        Strength=t, Agility=math.sqrt(t), Perception=math.sqrt(t),
        Intuition=t, Resistance=t, SpiritualityRegen=t,
    }
end
local function scale(base: Stats, sequence: number): Stats
    local m: any = multipliers(sequence)
    local result: any = {}
    for key, value in pairs(base :: any) do
        result[key] = math.round(value * m[key] * 100) / 100
    end
    return result :: Stats
end
local function calculate(pathwayId: string, sequence: number): Stats
    return scale(assert(bases[pathwayId], "Unknown pathway"), sequence)
end
-- Modifiers are server-authored definitions, never client-supplied stat totals.
-- Flat bonuses sum; percentage bonuses sum; multipliers multiply in stable ID order.
local uninitiated: Stats={Health=100,Spirituality=50,Sanity=100,Strength=8,Agility=10,Perception=20,Intuition=8,Resistance=8,SpiritualityRegen=2}
local function resolve(pathwayId: any,sequence: any,modifiers: {any}?): (Stats,any)
    local base=if pathwayId then calculate(pathwayId,sequence) else table.clone(uninitiated)
    local ordered=table.clone(modifiers or {})
    local seen={}
    for _,modifier in ipairs(ordered) do
        assert(type(modifier.Id)=="string" and modifier.Id~="" and not seen[modifier.Id],"Modifier IDs must be unique")
        seen[modifier.Id]=true
        for _,operation in ipairs({"Flat","Percent","Multiply"}) do
            for stat,value in pairs(modifier[operation] or {}) do
                assert((base :: any)[stat]~=nil,"Unknown stat: "..tostring(stat))
                assert(type(value)=="number" and value==value and math.abs(value)<math.huge,"Invalid modifier value")
                assert(operation~="Multiply" or value>=0,"Negative stat multiplier")
            end
        end
    end
    table.sort(ordered,function(a: any,b: any) return a.Id<b.Id end)
    local result: any={};local breakdown: any={}
    for stat,value in pairs(base :: any) do
        local flat,percent,multiply=0,0,1
        for _,modifier in ipairs(ordered) do
            flat+=(modifier.Flat or {})[stat] or 0
            percent+=(modifier.Percent or {})[stat] or 0
            multiply*=(modifier.Multiply or {})[stat] or 1
        end
        local final=(value+flat)*math.max(0,1+percent)*multiply
        assert(final==final and math.abs(final)<math.huge,"Stat modifier overflow")
        -- Sanity stays on the existing 0–100 resource scale.
        final=if stat=="Sanity" then 100 else math.clamp(final,if stat=="Health" then 1 else 0,10000000)
        result[stat]=math.round(final*100)/100
        breakdown[stat]={Base=value,Flat=flat,Percent=percent,Multiplier=multiply,Final=result[stat]}
    end
    return result :: Stats,breakdown
end
return freeze({BaseStats=bases, TierMultipliers=tiers, GetMultipliers=multipliers, Calculate=calculate, Scale=scale, Resolve=resolve,Uninitiated=uninitiated,
    Digestion={Min=0, Max=100, StartingValue=0}, Sanity={Min=0, Max=100}})
