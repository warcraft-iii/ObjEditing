-- enum.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 7/14/2019, 10:17:08 PM

Race = {
    Commoner = 'commoner',
    Creeps = 'creeps',
    Critters = 'critters',
    Demon = 'demon',
    Human = 'human',
    Naga = 'naga',
    Nightelf = 'nightelf',
    Orc = 'orc',
    Other = 'other',
    Undead = 'undead',
    Unknown = 'unknown',
}

AllowWhenFull = {
    Never = 0, --
    LifeOnly = 1, --
    ManaOnly = 2, --
    Always = 3, --
}

StackingType = {
    Damage = 0, --
    Movement = 1, --
    AttackRate = 2, --
    KillUnit = 3, --
}

ArmorType = {
    Normal = 'normal',
    Small = 'small',
    Medium = 'medium',
    Large = 'large',
    Fortified = 'fort',
    Hero = 'hero',
    Divine = 'divine',
    Unarmored = 'none',
}

MovementType = {
    Foot = 'foot', --
    Horse = 'horse', --
    Fly = 'fly', --
    Hover = 'hover', --
    Float = 'float', --
    Amphipic = 'amph', --
}

WeaponType = {
    Normal = 'normal',
    Instant = 'instant',
    Artillery = 'artillery',
    ArtilleryLine = 'aline',
    Missile = 'missile',
    MissileSplash = 'msplash',
    MissileBounce = 'mbounce',
    MissileLine = 'mline',
    None = '_',
}

WeaponSound = {
    Nothing = 'Nothing',
    AxeMediumChop = 'AxeMediumChop',
    MetalHeavyBash = 'MetalHeavyBash',
    MetalHeavyChop = 'MetalHeavyChop',
    MetalHeavySlice = 'MetalHeavySlice',
    MetalLightChop = 'MetalLightChop',
    MetalLightSlice = 'MetalLightSlice',
    MetalMediumBash = 'MetalMediumBash',
    MetalMediumChop = 'MetalMediumChop',
    MetalMediumSlice = 'MetalMediumSlice',
    RockHeavyBash = 'RockHeavyBash',
    WoodHeavyBash = 'WoodHeavyBash',
    WoodLightBash = 'WoodLightBash',
    WoodMediumBash = 'WoodMediumBash',
}

AttackType = {
    Unknown = 'unknown',
    Normal = 'normal',
    Pierce = 'pierce',
    Siege = 'siege',
    Spells = 'spells',
    Chaos = 'chaos',
    Magic = 'magic',
    Hero = 'hero',
}

ArmorSoundType = {
    Ethereal = 'Ethereal', --
    Flesh = 'Flesh', --
    Wood = 'Wood', --
    Stone = 'Stone', --
    Metal = 'Metal', --
}

UpgradeClass = {
    None = '',
    Armor = 'armor',
    Artillery = 'artillery',
    Melee = 'melee',
    Ranged = 'ranged',
    Caster = 'caster',
}

UpgradeEffectType = {
    None = '',
    AbilityLevelBonus = 'rlev',
    AddUltravision = 'rauv',
    ApplyAttackUpgradeBonus = 'ratt',
    ApplyDefenseUpgradeBonus = 'rarm',
    AttackDamageBonus = 'ratx',
    AttackDamageLoss = 'radl',
    AttackDiceBonus = 'ratd',
    AttackRangeBonus = 'ratr',
    AttackSpeedBonus = 'rats',
    AttackSpillDistanceBonus = 'rasd',
    AttackSpillRadiusBonus = 'rasr',
    AttackTargetCountBonus = 'ratc',
    AuraDataBonus = 'raud',
    DefenseTypeChange = 'rart',
    EnableAttacks = 'renw',
    EnableAttacksRooted = 'rroo',
    EnableAttacksUprooted = 'ruro',
    GoldHarvestBonus = 'rmin',
    GoldHarvestBonusEntangle = 'rent',
    HitPointBonus = 'rhpx',
    HitPointBonusPercent = 'rhpo',
    HitPointRegeneration = 'rhpr',
    LumberHarvestBonus = 'rlum',
    MagicImmunity = 'rmim',
    ManaPointBonus = 'rmnx',
    ManaPointBonusPercent = 'rman',
    ManaRegeneration = 'rmnr',
    MovementSpeedBonus = 'rmvx',
    MovementspeedBonusPercent = 'rmov',
    RaiseDeadDurationBonus = 'rrai',
    SightRangeBonus = 'rsig',
    SpikedBarricades = 'rspi',
    UnitAvailabilityChange = 'rtma',
}

AttacksEnabled = {
    None = 0, --
    AttackOneOnly = 1, --
    AttackTwoOnly = 2, --
    Both = 3, --
}
