local this = {}

local stats = {}
local mx, my = 0, 0
local staires
local selectedItem = nil
local raduisSelection = 20

local STAT_PV = 1
local STAT_ATK = 2
local STAT_DEF = 3
local STAT_SPD = 4
local strChoixStats

local function addStat(id, name, cost, value, item)
    local stat = {}
    stat.id = id
    stat.name = name
    stat.cost = cost
    stat.value = value
    stat.item = item
    table.insert(stats, stat)
end

this.load = function()
    love.mouse.setVisible(false)
    Inventory.removePages() -- On vide les pages de l'inventaire
    ItemManager.reset()
    AurasManager.reset()
    local mapBuilder = require("engine.dungeonBuilder")
    Map = mapBuilder.createEmptyMap(12, 11)

    --- SCENERY
    Player.currentAnim = Player.animRun
    Player.setPosition(6.5 * TILESIZE, 10 * TILESIZE)

    ItemManager.newVendor(6.5 * TILESIZE, 5 * TILESIZE)
    ItemManager.newBigTable(6 * TILESIZE, 6 * TILESIZE)

    staires = ItemManager.newDownstairs(7 * TILESIZE, 3 * TILESIZE)
    ItemManager.newTorch(4 * TILESIZE, 1 * TILESIZE)
    ItemManager.newTorch(9 * TILESIZE, 1 * TILESIZE)

    ItemManager.newBarrel(3 * TILESIZE, 4 * TILESIZE).isSelectable = false
    ItemManager.newBarrel(2 * TILESIZE, 10 * TILESIZE).isSelectable = false
    ItemManager.newBarrel(10 * TILESIZE, 10 * TILESIZE).isSelectable = false

    ItemManager.newBooks(3 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(4 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(5 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(8 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(9 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(10 * TILESIZE, 2 * TILESIZE)
    ItemManager.newChest(11 * TILESIZE, 2 * TILESIZE)

    -- Les stats : 2 au hasard

    local stat1 = math.random(4)
    local stat2 = 0
    repeat
        stat2 = math.random(4)
    until stat1 ~= stat2

    -- 20% de change de ne rien vendre
    if math.random(100) <= DATA.PCENTNOCELL then
        stat1 = 0
        stat2 = 0
        strChoixStats =
            "Je suis désolé, mais je n'ai pas été livré. Je n'ai rien à te proposer aujourd'hui. Prends les escaliers derrière moi pour continuer ton aventure !"
    else
        strChoixStats =
            "Fais ton choix sur les 2 petites tables que je te propose aujourd'hui. Tes courses terminées, prends les escaliers derrière moi pour continuer ton aventure !"
    end

    if stat1 == STAT_PV or stat2 == STAT_PV then
        addStat(STAT_PV, "Point de vie +1", 150, Player.pvMax, ItemManager.newTable(3 * TILESIZE, 7 * TILESIZE))
    end
    if stat1 == STAT_DEF or stat2 == STAT_DEF then
        addStat(STAT_DEF, "Défense +1", 150, Player.def, ItemManager.newTable(3 * TILESIZE, 9 * TILESIZE))
    end
    if stat1 == STAT_ATK or stat2 == STAT_ATK then
        addStat(STAT_ATK, "Attaque +1", 150, Player.atk, ItemManager.newTable(10 * TILESIZE, 7 * TILESIZE))
    end
    if stat1 == STAT_SPD or stat2 == STAT_SPD then
        addStat(STAT_SPD, "Vitesse +2%", 150, Player.speedInit, ItemManager.newTable(10 * TILESIZE, 9 * TILESIZE))
    end

    MUSICPLAYER:stop()
    MUSICPLAYER = love.audio.newSource("sons/16.mp3", "stream")
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)
    MUSICPLAYER:play()

    GUI.addInfoBull("Bonjour Aventurier ! Approche-toi, j'ai des informations à te donner !", 6)
end

local function doSelect()
    if selectedItem == nil then
        return
    end
    if selectedItem == staires then
        Player.pv = Player.pvMax
        Player.level = Player.level + 1
        ScreenManager.setScreen("NEXTLEVEL")
    elseif selectedItem.name then
        -- Le joueur à choisi une amélioration
        for _, stat in pairs(stats) do
            if stat.item == selectedItem then
                if Inventory.removePo(stat.cost) then
                    if stat.id == STAT_PV then
                        stat.value = stat.value + 1
                        Player.pvMax = stat.value
                    elseif stat.id == STAT_ATK then
                        stat.value = stat.value + 1
                        Player.atk = stat.value
                    elseif stat.id == STAT_DEF then
                        stat.value = stat.value + 1
                        Player.def = stat.value
                    elseif stat.id == STAT_SPD then
                        stat.value = stat.value * 1.02
                        Player.speedInit = stat.value
                    end
                end
            end
        end

    end
end

this.update = function(dt)
    ItemManager.update(dt)

    mx, my = Player.getCenter()
    mx = mx + TILESIZE * Player.lastdx
    my = my + TILESIZE * Player.lastdy

    selectedItem = ItemManager.getItemAroundPlayer(raduisSelection)
    staires.isHover = (selectedItem == staires)

    Player.update(dt)
    if Player.hasItemSelected then
        doSelect()
    end
end

local function drawMap()
    -- La map
    for x = 1, Map.width do
        for y = 1, Map.height do
            local tile = Map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty)
        end
    end
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (WIDTH / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(FontVendor12)

    drawMap()
    love.graphics.draw(Assets.shop, 0, 0)
    ItemManager.draw()
    Assets.draw(Assets.floor_grid, 6 * TILESIZE, 3 * TILESIZE)
    Assets.draw(Assets.floor_grid, 11 * TILESIZE, 9 * TILESIZE)

    Player.draw()
    Assets.draw(Assets.vendor_topdoor, TILESIZE * 6, TILESIZE * 11)

    love.graphics.setColor(0.867, 0.835, 0.251)
    love.graphics.print(Inventory.getPo() .. " po", 96, 160)

    love.graphics.pop() -------------------------------------

    love.graphics.setFont(FontVendor32)
    if selectedItem ~= nil then
        if selectedItem.name == "bigtable" then
            GUI.addInfoBull(strChoixStats, 6)
        end
    end

    if staires.isHover then
        GUI.addInfoBull("Si tu as fait tous tes choix, tu peux descendre à l'étage inférieur.")
    end
    for i, stat in pairs(stats) do
        if stat.item == selectedItem then
            GUI.addInfoBull(stat.name .. " = " .. stat.cost .. " po\nValeur actuelle : " .. wile.display2decimale(stat.value), 3)
        end
    end
end

this.keypressed = function(key)
end

return this
