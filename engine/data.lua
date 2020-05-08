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
    vampire1    . . . x x x . . .
    vampire2    . . . . . . x x x
    vampire3    . . . . . . . . x
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
    {"vampire", 1, 4, 6}, --
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

------------------------------------------------ BACKUP

DATA.sell1 = 0
DATA.sell2 = 0
DATA.saveFileExists = nil

DATA.SaveExists = function()
    if DATA.saveFileExists == nil then
        local info = love.filesystem.getInfo("game.sav")
        DATA.saveFileExists = info ~= nil
    end
    return DATA.saveFileExists
end

DATA.LoadGame = function()
    if not DATA.SaveExists() then
        return
    end
    local values = {}
    for line in love.filesystem.lines("game.sav") do
        table.insert(values, line)
    end

    OPTIONS.DIFFICULTY = values[1] + 0
    Player.level = values[2] + 0
    Inventory.setPo(values[3] + 0)
    Player.pvMax = values[4] + 0
    Player.atk = values[5] + 0
    Player.def = values[6] + 0
    Player.speedInit = values[7] + 0
    DATA.sell1 = values[8] + 0
    DATA.sell2 = values[9] + 0

    Player.pv = Player.pvMax
    Player.speed = Player.speedInit
    print("backup loaded")
end

DATA.SaveGame = function()
    local strOptions = ""

    local function add(value)
        strOptions = strOptions .. value .. "\n"
    end
    add(OPTIONS.DIFFICULTY)
    add(Player.level)
    add(Inventory.getPo())
    add(Player.pvMax)
    add(Player.atk)
    add(Player.def)
    add(Player.speedInit)
    add(DATA.sell1)
    add(DATA.sell2)

    love.filesystem.write("game.sav", strOptions)
    GUI.addInfoBull("Progression sauvegardée", 3, HEIGHT * 4 / 5, true)
    print("backup saved")
    DATA.saveFileExists = true
end

DATA.DeleteSave = function()
    love.filesystem.remove("game.sav")
    DATA.sell1 = 0 -- pour permettre de tirer au hasard
    DATA.sell2 = 0
    DATA.saveFileExists = false
    print("backup deleted")
end
