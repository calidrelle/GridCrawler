local this = {}

local stats = {}
local mx, my = 0, 0
local staires
local selectedItem = nil

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

    Inventory.removePages() -- On vide les pages de l'inventaire
    ItemManager.reset()
    local mapBuilder = require("engine.dungeonBuilder")
    Map = mapBuilder.createEmptyMap(12, 11)

    --- SCENERY
    Player.currentAnim = Player.animRun
    Player.setPosition(6.5 * TILESIZE, 8 * TILESIZE)

    ItemManager.newVendor(6.5 * TILESIZE, 5 * TILESIZE)
    staires = ItemManager.newDownstairs(7 * TILESIZE, 3 * TILESIZE)
    ItemManager.newTorch(4 * TILESIZE, 1 * TILESIZE)
    ItemManager.newTorch(9 * TILESIZE, 1 * TILESIZE)
    ItemManager.newBigTable(6 * TILESIZE, 6 * TILESIZE)
    ItemManager.newBarrel(2 * TILESIZE, 3 * TILESIZE)
    ItemManager.newBarrel(2 * TILESIZE, 10 * TILESIZE)
    ItemManager.newBarrel(10 * TILESIZE, 10 * TILESIZE)

    ItemManager.newBooks(3 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(4 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(5 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(8 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(9 * TILESIZE, 2 * TILESIZE)
    ItemManager.newBooks(10 * TILESIZE, 2 * TILESIZE)
    ItemManager.newChest(11 * TILESIZE, 2 * TILESIZE)

    -- Les stats
    addStat(1, "Vie max +1", 60, Player.pvMax, ItemManager.newTable(3 * TILESIZE, 5 * TILESIZE))
    addStat(2, "Attaque +1", 60, Player.atk, ItemManager.newTable(3 * TILESIZE, 7 * TILESIZE))
    addStat(3, "Défense +1", 80, Player.def, ItemManager.newTable(3 * TILESIZE, 9 * TILESIZE))
    addStat(4, "Distance d'attaque +5%", 60, Player.atkRange, ItemManager.newTable(10 * TILESIZE, 5 * TILESIZE))
    addStat(5, "Régénération de vie +5%", 50, Player.regenPv, ItemManager.newTable(10 * TILESIZE, 7 * TILESIZE))
    addStat(6, "Régénération d'endurence +5%", 50, Player.regenStamina, ItemManager.newTable(10 * TILESIZE, 9 * TILESIZE))

    MUSICPLAYER:stop()
    MUSICPLAYER = love.audio.newSource("sons/24_v2.mp3", "stream")
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)
    MUSICPLAYER:play()
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
                    if stat.id == 1 then
                        stat.value = stat.value + 1
                        Player.pvMax = stat.value
                    elseif stat.id == 2 then
                        stat.value = stat.value + 1
                        Player.atk = stat.value
                    elseif stat.id == 3 then
                        stat.value = stat.value + 1
                        Player.def = stat.value
                    elseif stat.id == 4 then
                        stat.value = stat.value * 1.05
                        Player.atkRange = stat.value
                    elseif stat.id == 5 then
                        stat.value = stat.value * 1.05
                        Player.regenPv = stat.value
                    elseif stat.id == 6 then
                        stat.value = stat.value * 1.05
                        Player.regenPv = stat.value
                    else
                        print("Amélioration inconnue !!!")
                    end
                else
                    this.drawHover("Pas assez d'argent")
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

    selectedItem = ItemManager.getItemAt(mx, my)
    local itemHovered = ItemManager.getItemAt(Player.getCenter())
    staires.isHover = false
    if itemHovered ~= nil then
        if itemHovered == staires then
            staires.isHover = true
        end
    end

    Player.update(dt)
    if Player.selectItem then
        doSelect()
    end

end

this.drawHover = function(text)
    local large = WIDTH / 2
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", (WIDTH - large) / 2, 50, large, 140)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(text, (WIDTH - large) / 2, 56, large, "center")
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
            this.drawHover(
                "Bonjour Aventurier, fait ton choix sur les tables, et prends les escaliers derrière moi pour continuer ton aventure.")
        end
    end

    if staires.isHover then
        this.drawHover("Si tu as fait tous tes choix, tu peux descendre à l'étage inférieur.")
    end
    for i, stat in pairs(stats) do
        if stat.item == selectedItem then
            this.drawHover(stat.name .. " = " .. stat.cost .. " po\nValeur actuelle : " .. math.floor(stat.value * 100) / 100)
        end
    end
end

this.keypressed = function(key)

end

return this
