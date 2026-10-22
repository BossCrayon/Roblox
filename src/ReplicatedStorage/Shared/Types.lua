--!strict
-- Luau has no numeric singleton types; validate integer bounds at runtime.
export type Sequence = number
export type Stats = {
    Health: number, Spirituality: number, Sanity: number,
    Strength: number, Agility: number, Perception: number,
    Intuition: number, Resistance: number, SpiritualityRegen: number,
}
export type Canon = { status: string, note: string, sources: {string} }
export type Objective = {
    Id: string, Label: string, ServerSignal: string, RequiredCount: number,
    DigestionReward: number, ActingProgressReward: number, CooldownSeconds: number,
}
export type SequenceData = {
    Number: number, Name: string, Canon: Canon, StatMultipliers: Stats,
    BaseStats: Stats, AbilityIds: {string}, PassiveTraits: {string},
    ActingObjectives: {Objective},
}
export type Pathway = {
    Id: string, Name: string, Alias: string, BaseStats: Stats,
    Sequences: {[number]: SequenceData}, AbilityDefinitions: {any},
}
export type Ability = {
    Id: string, PathwayId: string, UnlockSequence: number, Name: string,
    Description: string, Canon: Canon, CooldownSeconds: number,
    SpiritualityCost: number, CastTimeSeconds: number, Target: string,
    RangeStuds: number, RadiusStuds: number, MaxTargets: number,
    BasePower: number, Hitbox: {Shape: string, LineOfSight: boolean},
    StatusEffects: {string}, VFXHook: string, SFXHook: string,
    Implemented: boolean, Operation: any?,
}
return table.freeze({})
