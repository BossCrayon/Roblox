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
return freeze({BaseStats=bases, TierMultipliers=tiers, GetMultipliers=multipliers, Calculate=calculate, Scale=scale,
    Digestion={Min=0, Max=100, StartingValue=0}, Sanity={Min=0, Max=100}})
