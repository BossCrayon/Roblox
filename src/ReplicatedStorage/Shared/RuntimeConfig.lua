--!strict
local freeze=require(script.Parent.Freeze)
return freeze({
    -- Only honored in Studio. Published servers always use DataStoreService.
    StudioSessionOnly=true, GenerateDemoWorld=true,
    TickSeconds=0.25, StateIntervalSeconds=0.5, MaxEnemies=18,
    IntentRate=8, IntentBurst=12, MaxMessageLength=180,
    MeleeRange=11, MeleeCooldown=0.55, MeleePowerMultiplier=1.6,
    NPCNoticeRange=65, NPCAttackRange=6, NPCAttackInterval=1.5,
    NPCRespawnSeconds=12, NPCGoldReward=25,
    NPCHealthPerTier=60, NPCMeleeDamagePerTier=6, NPCSpellDamagePerTier=4,
    NPCSpeed=10, NPCSpellRange=28, NPCSpellCooldown=6,
    NPCMentalResistancePerTier=12, MinStatusDurationMultiplier=0.15,
    SummonDamagePerTier=12, SummonAttackInterval=1.5,
    ExposureRadius=30, WhisperInterval=10, NextPotionGoldCost=100,
    MaxOwnedSummons=2, MaxPortalsPerPlayer=2, MaxVFX=48,
    Disguises={
        Wanderer={DisplayName="Unknown Wanderer",Color={100,120,140},VoicePitch=0.85,
            Scales={BodyHeightScale=0.92,BodyWidthScale=1.1,BodyDepthScale=1.05,HeadScale=0.95}},
        Archivist={DisplayName="Archive Custodian",Color={155,125,105},VoicePitch=1.1,
            Scales={BodyHeightScale=1.05,BodyWidthScale=0.9,BodyDepthScale=0.95,HeadScale=1.0}},
    },
    DivinationAccuracy={Base=0.55,Bonus=0.4,IntuitionScale=40},
    CopyableNPCPowers={ArcBolt={Power=1.7,Status="Burning",Duration=3}},
    EnemyTiers={9,7,5,4,2,1},
    SanctuaryRadius=25, WorldRadius=380,
})
