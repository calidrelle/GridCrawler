DATA = {}

DATA.barrel = {lootPoMin = 1, lootPoMax = 5}
DATA.chest = {lootPoMin = 5, lootPoMax = 15}
LEVELMAX = 9 -- rajouter des mobLevel si ça change

---- SLIM
DATA.slim = {
    mobLevel = {12, 8, 4, 0, 0, 4, 4, 8, 12},
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
    mobLevel = {0, 4, 8, 8, 4, 4, 8, 12, 12},
    pv = 22,
    atk = 7,
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
    mobLevel = {0, 0, 2, 4, 8, 12, 12, 12, 12},
    pv = 40,
    atk = 6,
    atkRange = 16,
    detectRange = 120,
    speed = 20,
    atkSpeed = 0.25,
    lootPoMin = 10,
    lootPoMax = 20,
    auraToDeal = {{"Poison", 10}}
}
