local this = {}

local seed = 1
local map = nil
local player = nil

this.reset = function()
    map = nil
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
end

this.update = function(dt)
    player.update(dt)
end

local function drawGui()
    love.graphics.print("Coord: " .. player.x .. ", " .. player.y, 10, 10)
    love.graphics.draw(Assets.gui, WIDTH - 100 * SCALE, 100 * SCALE, 0, SCALE, SCALE)
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-player.x + (WIDTH / SCALE) / 2), (-player.y + (HEIGHT / SCALE) / 2))

    love.graphics.clear(76 / 256, 57 / 256, 65 / 256, 1)

    -- La map
    local nbTilesX = 15
    local nbTilesY = 10
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
    -- le player
    player.draw()

    love.graphics.pop()
    drawGui()
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    end
    if key == "r" then
        seed = nil
        map = nil
        player.resetAnims()
        player = nil
        this.load()
    end
end

return this
