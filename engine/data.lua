DATA = {}

DATA.barrel = {lootPoMin = 1, lootPoMax = 5}
DATA.chest = {lootPoMin = 5, lootPoMax = 15}
LEVELMAX = 9 -- rajouter des mobLevel si ça change

-- Pourcentage de chance que le vendeur n'ait rien à vendre
DATA.PCENTNOCELL = 10

-- Pourcentage de chance qu'un mob change de direction
DATA.PCENTCHANGEDIR = 2

-- RATIOS pour les niveau de diffucultés
DATA.RATIO_EASY = 0.5
DATA.RATIO_NORMAL = 0.75
DATA.RATIO_HARD = 1

--[[            1 2 3 4 5 6 7 8 9
    slim1       x x x . . . . . .
    slim2       . . . x x x . . .
    slim3       . . . . . . x x x
    goblin1     . x x x . . . . .
    goblin2     . . . . x x x . .
    goblin3     . . . . . . . x x
    zombie1     . . x x x . . . .
    zombie2     . . . . . x x x .
    zombie3     . . . . . . . . x
    vampire1    . x x x x . . . .
    vampire2    . . . . . x x x x
    vampire3    . . . . . . . x x
]]

-- Format : nom_mob, liveau, from, to
DATA.mobLevels = {
    -- Slims
    {"slim", 1, 1, 3}, --
    {"slim", 2, 4, 6}, --
    {"slim", 3, 7, 9}, --
    -- Goblins
    {"goblin", 1, 2, 4}, -- 
    {"goblin", 2, 5, 7}, -- 
    {"goblin", 3, 8, 9}, --
    -- Zombies
    {"zombie", 1, 3, 5}, --
    {"zombie", 2, 6, 8}, --
    {"zombie", 3, 9, 9}, --
    -- Vampires
    {"vampire", 1, 2, 5}, --
    {"vampire", 2, 7, 9}, --
    {"vampire", 3, 8, 9} --
}

---- SLIM
DATA.slim = {
    pv = 16,
    atk = 4,
    atkRange = 20,
    detectRange = 100,
    speed = 25,
    atkSpeed = 0.2,
    lootPoMin = 5,
    lootPoMax = 15,
    auraToDeal = {} -- nom, durée en seconde
}

-- GOBLIN
DATA.goblin = {
    pv = 22,
    atk = 6,
    atkRange = 20,
    detectRange = 100,
    speed = 40,
    atkSpeed = 0.15,
    lootPoMin = 10,
    lootPoMax = 15,
    auraToDeal = {}
}

-- ZOMBIE
DATA.zombie = {
    pv = 40,
    atk = 7,
    atkRange = 16,
    detectRange = 120,
    speed = 20,
    atkSpeed = 0.25,
    lootPoMin = 10,
    lootPoMax = 20,
    auraToDeal = {{"Poison", 10}}
}

-- VAMPIRE
DATA.vampire = {
    pv = 28,
    atk = 5,
    atkRange = 20,
    detectRange = 100,
    speed = 32,
    atkSpeed = 0.20,
    lootPoMin = 15,
    lootPoMax = 30,
    auraToDeal = {{"Morsure", 8}}
}
