--!strict
-- Shared data only. The client may read it; only server services mutate player state.
local freeze = require(script.Parent.Freeze)
return freeze({
    Runtime=require(script.Parent.RuntimeConfig),
    Pathways=require(script.Parent.PathwayData),
    Abilities=require(script.Parent.AbilityData),
    Potions=require(script.Parent.PotionData),
    Stats=require(script.Parent.StatData),
    Progression=require(script.Parent.ProgressionConfig),
    StatusEffects=require(script.Parent.StatusEffectData),
})
