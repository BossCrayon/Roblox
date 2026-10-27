--!strict
-- Lore-inspired playable ancestry adaptations. Numbers and active skills are game balance,
-- not canonical universal racial abilities. Ancestry grants no pathway or sequence.
local freeze=require(script.Parent.Freeze)
return freeze({
    Order={"Human","Sanguine","Giant","Elf"},
    ById={
        Human={Name="Human",Description="Adaptable mortal ancestry. Balanced attributes and mental composure.",
            Multipliers={},Skill="Resolve",Detail="Restore 15 sanity and resist mental strain for 8 seconds.",Cost=10,Cooldown=45,Duration=8,Status="Composed",Sanity=15},
        Sanguine={Name="Sanguine",Description="Moon-associated ancestry; heightened vitality, agility and perception. Playable adaptation, not a free Moon sequence.",
            Multipliers={Health=1.1,Agility=1.2,Perception=1.15,Strength=1.1,SpiritualityRegen=0.9},
            Skill="Crimson Renewal",Detail="Regenerate 20% maximum health over 8 seconds.",Cost=25,Cooldown=60,Duration=8,HealFraction=0.2},
        Giant={Name="Giant",Description="Ancestry associated with immense strength and endurance. Reduced agility balances its physical advantages.",
            Multipliers={Health=1.3,Strength=1.3,Resistance=1.15,Agility=0.8,Spirituality=0.9},
            Skill="Titan Guard",Detail="Reduce incoming damage by 65% for 6 seconds.",Cost=25,Cooldown=60,Duration=6,Status="Shielded"},
        Elf={Name="Elf",Description="Ancestry associated with storms and keen senses. Increased agility and perception, with less physical endurance.",
            Multipliers={Health=0.9,Agility=1.15,Perception=1.3,Spirituality=1.1,Intuition=1.1},
            Skill="Stormstep",Detail="Gain 8 movement speed and spirit sight for 8 seconds.",Cost=20,Cooldown=45,Duration=8,Status="Vision",Speed=8},
    },
})
