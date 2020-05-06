DATA = {}

DATA.barrel = {lootPoMin = 1, lootPoMax = 5}
DATA.chest = {lootPoMin = 5, lootPoMax = 15}
LEVELMAX = 9 -- rajouter des mobLevel si ça change

DATA.PCENTNOCELL = 10 -- Pourcentage de chance que le vendeur n'ait rien à vendre

-- RATIOS pour les niveau de diffucultés
DATA.RATIO_EASY = 0.5
DATA.RATIO_NORMAL = 0.75
DATA.RATIO_HARD = 1

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
    {"zombie", 3, 9, 9} --
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
