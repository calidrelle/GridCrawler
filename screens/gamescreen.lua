local this = {}

Map = nil
Boss = nil

local btnRestart = nil
local clignotementLowLife = 0

this.restartGame = function()
    -- Après un gameover, on recréé un perso tout neuf
    print("restartGame")
    Assets.init()
    Bravoure.init()
    Player.createNew()
    this.startNewLevel()
    OPTIONS.DIFFICULTY = 0
    GameOver.status = false
    GameOver.timer = 0
    ScreenManager.started = false
    ScreenManager.setScreen("MENU")
end

this.startNewLevel = function()
    print("startNewLevel")
    Assets.init()
    Map = nil
    Player.resetAnims()
    ItemManager.reset()
    AurasManager.reset()
    Bravoure.resetLevel()
    Player.gridOpened = false
    GameOver.status = false
    GameOver.timer = 0
    this.load()
end

this.load = function()
    love.mouse.setVisible(false)
    GUI.reset()
    Bravoure.resetLevel()
    if (Map == nil) then
        local mapBuilder = require("engine.dungeonBuilder")
        -- Map = mapBuilder.build(60, 60, 1)
        if Player.level == LEVELMAX then
            Map = mapBuilder.buildFromTiled("maps/boss.lua")
            mapBuilder.createBoss()

        else
            Map = mapBuilder.build(60, 60)
        end
        Player.setPosition(Map.spawn.x * TILESIZE, Map.spawn.y * TILESIZE)
        GUI.addInfoBull("Bienvenue au niveau " .. Player.level .. " de GridCrawler.\nTrouve les " .. MAX_PAGES ..
                            " pages pour reconstituer le grimoire d'ouverture de la grille.")

        Boss = Map.boss
    end
    -- Calcul de la zone de jeu
    btnRestart = GUI.addButton("Rejouer", PIXELLARGE / 2 - 40 * SCALE, HEIGHT / 2 + 8 * SCALE, 64 * SCALE)
    btnRestart.visible = false
end

this.update = function(dt)
    Player.timers[Player.level] = Player.timers[Player.level] + dt
    if Player.lowlife() then
        clignotementLowLife = clignotementLowLife + dt
        if clignotementLowLife > 2 * math.pi then
            clignotementLowLife = 0
        end
    end
    if btnRestart.clicked then
        this.restartGame()
        return
    end
    ItemManager.update(dt)
    AurasManager.update(dt)
    Player.update(dt)
    Effects.update(dt)
    if GameOver.status then
        if GameOver.timer < 1 then
            GameOver.timer = GameOver.timer + dt
        else
            GameOver.timer = 1
            love.mouse.setVisible(true)
            btnRestart.visible = true
        end
    end
end

local function drawGui()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.gui, WIDTH - 100 * SCALE, 0, 0, SCALE, SCALE)
    love.graphics.draw(Assets.gui_bottom, WIDTH - 100 * SCALE, HEIGHT - Assets.gui_bottom:getHeight() * SCALE, 0, SCALE, SCALE)

    -- Catactéristiques player
    if table.contains(Player.auras, "Morsure") then
        GUI.drawProgressBar(PIXELLARGE / 2 - 250, HEIGHT - 50, 200, 32, Player.pv, Player.pvMax, 0.698, 0, 1, true)
    else
        GUI.drawProgressBar(PIXELLARGE / 2 - 250, HEIGHT - 50, 200, 32, Player.pv, Player.pvMax, 1, 0.1, 0, true)
    end

    if table.contains(Player.auras, "Poison") then
        GUI.drawProgressBar(PIXELLARGE / 2 + 50, HEIGHT - 50, 200, 32, Player.stamina, 100, 0, 1, 0.6, true)
    else
        GUI.drawProgressBar(PIXELLARGE / 2 + 50, HEIGHT - 50, 200, 32, Player.stamina, 100, 0, 0.6, 1, true)
    end

    if Boss ~= nil then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", PIXELLARGE / 4, 40, PIXELLARGE / 2 * Boss.pv / Boss.pvMax, 12 * SCALE) -- La barre de vie à la taille d'une tile
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", PIXELLARGE / 4, 40, PIXELLARGE / 2, 12 * SCALE) -- La barre de vie à la taille d'une tile
    end

    if Player.lowlife() then
        love.graphics.setColor(1, 1, 1, math.sin(clignotementLowLife * 6))
        love.graphics.draw(Assets.lowlife, 0, 0, 0, PIXELLARGE, HEIGHT / 768)
    end
end

local function strDiff(diff)
    if diff == 1 then
        return "Facile"
    elseif diff == 2 then
        return "Normal"
    elseif diff == 3 then
        return "Difficile"
    else
        return "Inconnu"
    end
end

local function drawMinimap()
    local xoff = PIXELLARGE + (TILESIZE - 1) * SCALE
    local yoff = (TILESIZE - 1) * SCALE

    for x = 1, Map.width do
        for y = 1, Map.height do
            local tile = Map[x][y]
            if tile.visited then
                if tile.type == FLOOR or tile.type == CORRIDOR then
                    love.graphics.setColor(0.6, 0.4, 0.3)
                    love.graphics.rectangle("fill", xoff + x * SCALE, yoff + y * SCALE, SCALE, SCALE)
                elseif tile.type == WALL then
                    love.graphics.setColor(0.2, 0.2, 0.4)
                    love.graphics.rectangle("fill", xoff + x * SCALE, yoff + y * SCALE, SCALE, SCALE)
                end
            end
        end
    end
    -- Grille
    if Map[Map.grid.x][Map.grid.y].visited then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", xoff + Map.grid.x * SCALE, yoff + Map.grid.y * SCALE, SCALE, SCALE)
    end

    -- Player
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", xoff + (Player.x / TILESIZE) * SCALE, yoff + (Player.y / TILESIZE) * SCALE, SCALE, SCALE)

    love.graphics.setFont(Font16)
    love.graphics.print("Niv. " .. Player.level .. ' (' .. strDiff(OPTIONS.DIFFICULTY) .. ")", xoff + SCALE, yoff - 6 * SCALE)
end

this.drawMap = function(upper)
    -- La map
    local nbTilesX = math.floor((PIXELLARGE / TILESIZE) / SCALE)
    local nbTilesY = math.floor((HEIGHT / TILESIZE) / SCALE)
    local xmin = math.max(1, math.floor(Player.x / TILESIZE - nbTilesX / 2) - 1)
    local xmax = math.min(Map.width, math.floor(Player.x / TILESIZE + nbTilesX / 2) + 1)
    local ymin = math.max(1, math.floor(Player.y / TILESIZE - nbTilesY / 2) - 1)
    local ymax = math.min(Map.height, math.floor(Player.y / TILESIZE + nbTilesY / 2) + 1)

    for x = xmin, xmax do
        for y = ymin, ymax do
            local tile = Map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty, upper)
            tile.visited = true
        end
    end
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (PIXELLARGE / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))
    Effects.preRender()

    love.graphics.clear(0.297, 0.223, 0.254)
    love.graphics.setColor(1, 1, 1)

    this.drawMap(false)
    -- les items
    ItemManager.draw()
    -- le Player
    Player.draw()
    this.drawMap(true)

    Effects.draw()

    love.graphics.pop() ----------------------------------------------------------------------- POP

    drawGui()
    AurasManager.draw()
    if love.keyboard.isDown(OPTIONS.SHOWCARAC) then
        Player.drawFichePerso()
    end
    Inventory.draw()
    drawMinimap()

    if GameOver then
        love.graphics.setColor(1, 1, 1, GameOver.timer)
        love.graphics.draw(Assets.GameOver, (PIXELLARGE - Assets.GameOver:getWidth()) / 2, (HEIGHT - Assets.GameOver:getHeight()) / 2)
    end

    -- love.graphics.setColor(1, 1, 1, 1)
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    end
    if key == "return" and btnRestart.visible then
        this.restartGame()
        return
    end
    if DevMode() then
        if key == "f2" then
            Bravoure.Savonnette.check()
        elseif key == "f4" then
            Player.gridOpened = true
            Player.level = LEVELMAX
            ItemManager.getItem("exit").walkOver(Player)
        elseif key == "f10" then
            Player.pv = -1
        elseif key == "f11" then
            Player.gridOpened = true
            if Player.level == LEVELMAX then
                ItemManager.getItem("exit").walkOver(Player)
            else
                Inventory.addItem(ItemManager.newGold(0, 0), math.random(190, 250))
                ScreenManager.setScreen("VENDOR")
            end
        elseif key == "f12" then
            ScreenManager.setScreen("OUTSIDE")
        elseif key == "kp+" then
            Player.pvMax = Player.pvMax + 10
            Player.pv = Player.pv + 10
        elseif key == "kp*" then
            Player.level = Player.level + 1
        elseif key == "kp/" then
            Player.level = Player.level - 1

        else
            print(key)
        end
    end
end

return this
