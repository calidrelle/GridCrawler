local this = {}

local seed = 1
local map = nil
local player = nil

this.reset = function()
    Assets.init()
    seed = nil
    map = nil
    ItemManager.reset()
    player.resetAnims()
    player = nil
    this.load()
end

this.load = function()
    print("load game")
    if (map == nil) then
        print("init map")
        local mapBuilder = require("gameobjects.dungeonBuilder")
        map = mapBuilder.build(60, 60, seed)
        player = require("gameobjects.player")
        player.createNew(map.spawn.x * TILESIZE, map.spawn.y * TILESIZE)
        player.setMap(map)
    end

    -- Calcul de la zone de jeu
    PIXELLARGE = (WIDTH - 100 * SCALE)
end

this.update = function(dt)
    ItemManager.update(dt)
    player.update(dt)
end

local function drawGui()
    -- love.graphics.print("player " .. player.x .. ", " .. player.y, 10, 10)
    -- love.graphics.print("mouse" .. love.mouse.getX() .. ", " .. love.mouse.getY(), 10, 30)
    love.graphics.draw(Assets.gui, WIDTH - 100 * SCALE, 0, 0, SCALE, SCALE)
    love.graphics.draw(Assets.gui_bottom, WIDTH - 100 * SCALE, HEIGHT - Assets.gui_bottom:getHeight() * SCALE, 0, SCALE, SCALE)
end

local function drawMessages()
    love.graphics.setColor(0, 0, 0)
    local numLigne = 0
    for _, msg in pairs(player.messages) do
        local words = {}
        table.insert(words, "*")
        for word in msg.text:gmatch("%S+") do
            table.insert(words, word)
        end
        -- on rajoute les mots sauf s'il ne rentre pas dans la largeur (70 * scale)
        local msgToPrint = ""
        for _, word in pairs(words) do
            if string.len(msgToPrint) > 7 * SCALE then
                love.graphics.print(msgToPrint, PIXELLARGE + SCALE * 16 + 6, HEIGHT - (76 * SCALE) + numLigne * 16)
                msgToPrint = ""
                numLigne = numLigne + 1
            end
            msgToPrint = msgToPrint .. word .. " "
        end
        love.graphics.print(msgToPrint, PIXELLARGE + SCALE * 16 + 6, HEIGHT - (76 * SCALE) + numLigne * 16)
        numLigne = numLigne + 1
    end
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-player.x + (PIXELLARGE / SCALE) / 2), (-player.y + (HEIGHT / SCALE) / 2))

    love.graphics.clear(0.297, 0.223, 0.254)
    love.graphics.setColor(1, 1, 1)

    -- La map
    local nbTilesX = math.floor(PIXELLARGE / TILESIZE) - 1
    local nbTilesY = math.floor(HEIGHT / TILESIZE) - 1
    local xmin = math.max(1, math.floor(player.x / TILESIZE) - nbTilesX)
    local xmax = math.min(map.width, math.floor(player.x / TILESIZE) + nbTilesX)
    local ymin = math.max(1, math.floor(player.y / TILESIZE) - nbTilesY)
    local ymax = math.min(map.height, math.floor(player.y / TILESIZE) + nbTilesY)

    for x = xmin, xmax do
        for y = ymin, ymax do
            local tile = map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty)
        end
    end

    -- les items
    ItemManager.draw()

    -- le player
    player.draw()

    love.graphics.pop()
    drawGui()
    Inventory.draw()

    drawMessages()
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    end
    if key == "r" then
        this.reset()
    end
end

return this
