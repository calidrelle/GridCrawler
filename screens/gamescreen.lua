local this = {}

local seed = 1
local map = nil
local player = nil

BEDROCK = 0
WALL = 1
FLOOR = 2
CORRIDOR = 3

this.reset = function()
    map = nil
end

this.load = function()
    print("load game")
    if (map == nil) then
        print("init map")
        local mapBuilder = require("gameobjects.dungeonBuilder")
        map = mapBuilder.build(60, 60, seed)
        local spawn = mapBuilder.getEmptyLocation()
        player = require("gameobjects.player")
        player.createNew(spawn.x * TILESIZE, spawn.y * TILESIZE)
        player.setMap(map)
    end
end

this.update = function(dt)
    player.update(dt)
end

local function drawGui()
    love.graphics.print("Coord: " .. player.x .. ", " .. player.y, 10, 10)
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-player.x + (WIDTH / SCALE) / 2), (-player.y + (HEIGHT / SCALE) / 2))

    love.graphics.setColor(1, 1, 1, 1)
    -- La map
    -- TODO: Optimiser les tiles à afficher
    for x = 1, map.width do
        for y = map.height, 1, -1 do
            local tile = map[x][y]
            local tx = x * TILESIZE
            local ty = y * TILESIZE
            tile.draw(tx, ty)
            -- if tile == FLOOR then
            --     Assets.draw(Assets.floor_1, tx, ty)
            -- elseif tile == WALL then
            --     Assets.draw(Assets.wall_1, tx, ty)
            -- elseif tile == CORRIDOR then
            --     Assets.draw(Assets.corridor_1, tx, ty)
            -- end
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
        player = nil
        this.load()
    end
end

return this
