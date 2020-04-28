local this = {}

local seed = 1

Map = nil
local btnRestart = nil

this.startNewLevel = function()
    Assets.init()
    seed = nil
    Map = nil
    ItemManager.reset()
    Player.resetAnims()
    Player.gridOpened = false
    GameOver.status = false
    GameOver.timer = 0
    this.load()
end

this.load = function()
    print("load game")
    GUI.reset()
    if (Map == nil) then
        print("init map")
        local mapBuilder = require("gameobjects.dungeonBuilder")
        Map = mapBuilder.build(60, 60, seed)
        Player.setPosition(Map.spawn.x * TILESIZE, Map.spawn.y * TILESIZE)
    end
    -- Calcul de la zone de jeu
    PIXELLARGE = (WIDTH - 100 * SCALE)
    btnRestart = GUI.addButton("Rejouer", PIXELLARGE / 2 - 40 * SCALE, HEIGHT / 2 + 8 * SCALE, 64 * SCALE)
    btnRestart.visible = false
end

this.update = function(dt)
    if btnRestart.clicked then
        this.startNewLevel()
    end
    ItemManager.update(dt)
    Player.update(dt)
    Effects.update(dt)
    if GameOver.status then
        if GameOver.timer < 1 then
            GameOver.timer = GameOver.timer + dt / 2
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
    GUI.drawProgressBar(PIXELLARGE / 2 - 250, HEIGHT - 50, 200, 32, Player.pv / Player.pvMax, 1, 0.1, 0)
    GUI.drawProgressBar(PIXELLARGE / 2 + 50, HEIGHT - 50, 200, 32, Player.stamina / 100, 0, 0.6, 1)

    -- Messages
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(Font20)
    if #Player.messages > 0 then
        love.graphics.printf(Player.messages[1].text, PIXELLARGE + SCALE * 16 + 6, HEIGHT - (76 * SCALE), 70 * SCALE, "left")
    end
end

local function drawMinimap()
    local scale = 3
    local xoff = PIXELLARGE - Map.width * scale - TILESIZE
    local yoff = 20
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", xoff, yoff, Map.width * scale, Map.height * scale)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(.5, .5, .5, 0.6)
    love.graphics.rectangle("fill", xoff, yoff, Map.width * scale, Map.height * scale)

    for x = 1, Map.width do
        for y = 1, Map.height do
            local tile = Map[x][y]
            if tile.visited then
                if tile.type == FLOOR or tile.type == CORRIDOR then
                    love.graphics.setColor(0.6, 0.4, 0.3)
                    love.graphics.rectangle("fill", xoff + x * scale, yoff + y * scale, scale, scale)
                elseif tile.type == WALL then
                    love.graphics.setColor(0.2, 0.2, 0.4)
                    love.graphics.rectangle("fill", xoff + x * scale, yoff + y * scale, scale, scale)
                end
            end
        end
    end
    -- Grille
    if Map[Map.grid.x][Map.grid.y].visited then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", xoff + Map.grid.x * scale, yoff + Map.grid.y * scale, scale, scale)
    end

    -- Player
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", xoff + (Player.x / TILESIZE) * scale, yoff + (Player.y / TILESIZE) * scale, scale, scale)
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (PIXELLARGE / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))

    love.graphics.clear(0.297, 0.223, 0.254)
    love.graphics.setColor(1, 1, 1)

    -- La map
    local nbTilesX = math.floor((PIXELLARGE / TILESIZE) / SCALE)
    local nbTilesY = math.floor((HEIGHT / TILESIZE) / SCALE)
    local xmin = math.max(1, math.floor(Player.x / TILESIZE - nbTilesX / 2))
    local xmax = math.min(Map.width, math.floor(Player.x / TILESIZE + nbTilesX / 2))
    local ymin = math.max(1, math.floor(Player.y / TILESIZE - nbTilesY / 2))
    local ymax = math.min(Map.height, math.floor(Player.y / TILESIZE + nbTilesY / 2))

    for x = xmin, xmax do
        for y = ymin, ymax do
            local tile = Map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty)
            tile.visited = true
        end
    end
    -- les items
    ItemManager.draw()
    -- le Player
    Player.draw()
    Effects.draw()

    love.graphics.pop()

    drawGui()
    Inventory.draw()
    drawMinimap()

    if GameOver then
        love.graphics.setColor(1, 1, 1, GameOver.timer)
        love.graphics.draw(Assets.GameOver, (PIXELLARGE - Assets.GameOver:getWidth()) / 2, (HEIGHT - Assets.GameOver:getHeight()) / 2)
    end

    love.graphics.setColor(1, 1, 1, 1)

    if DevMode() then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Items: " .. #ItemManager.getItems(), 10, 32)
    end
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    end
    if key == "return" and btnRestart.visible then
        this.startNewLevel()
    end
    if DevMode() then
        if key == "f10" then
            Player.pv = -1
        elseif key == "f11" then

        else
            print("gamescreen key : " .. key)
        end
    end
end

return this
