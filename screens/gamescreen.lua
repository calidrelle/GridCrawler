local this = {}

local seed = 1
Map = nil
Player = nil

this.reset = function()
    Assets.init()
    seed = nil
    Map = nil
    ItemManager.reset()
    Player.resetAnims()
    Player = nil
    this.load()
end

this.load = function()
    print("load game")
    if (Map == nil) then
        print("init map")
        local mapBuilder = require("gameobjects.dungeonBuilder")
        Map = mapBuilder.build(60, 60, seed)
        Player = require("gameobjects.player")
        Player.createNew(Map.spawn.x * TILESIZE, Map.spawn.y * TILESIZE)
    end

    -- Calcul de la zone de jeu
    PIXELLARGE = (WIDTH - 100 * SCALE)
end

this.update = function(dt)
    ItemManager.update(dt)
    Player.update(dt)
    Effects.update(dt)
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
    if #Player.messages > 0 then
        love.graphics.printf(Player.messages[1].text, PIXELLARGE + SCALE * 16 + 6, HEIGHT - (76 * SCALE), 70 * SCALE, "left")
    end
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (PIXELLARGE / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))

    love.graphics.clear(0.297, 0.223, 0.254)
    love.graphics.setColor(1, 1, 1)

    -- La map
    local nbTilesX = math.floor(PIXELLARGE / TILESIZE) - 1
    local nbTilesY = math.floor(HEIGHT / TILESIZE) - 1
    local xmin = math.max(1, math.floor(Player.x / TILESIZE) - nbTilesX)
    local xmax = math.min(Map.width, math.floor(Player.x / TILESIZE) + nbTilesX)
    local ymin = math.max(1, math.floor(Player.y / TILESIZE) - nbTilesY)
    local ymax = math.min(Map.height, math.floor(Player.y / TILESIZE) + nbTilesY)

    for x = xmin, xmax do
        for y = ymin, ymax do
            local tile = Map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty)
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
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("Items: " .. #ItemManager.getItems(), 10, 32)
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
        -- else
        --     print("gamescreen key : " .. key)
    end
    -- if key == "r" then
    --     this.reset()
    -- end
end

return this
