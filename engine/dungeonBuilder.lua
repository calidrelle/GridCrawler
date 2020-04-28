local this = {}

local ROOM_MIN_WIDTH = 6
local ROOM_MAX_WIDTH = 12
MAX_PAGES = 8

local map = {}
local rooms = {}
local corridors = {}

local tileFactory = require("engine.tile")

local function initWalls()
    for x = 1, map.width do
        map[x] = {}
        for y = 1, map.height do
            if x == 1 or y == 1 or x == map.width or y == map.height then
                map[x][y] = tileFactory.create(WALL, Assets.empty_brown)
            else
                map[x][y] = tileFactory.create(WALL)
            end
        end
    end
end

local function intersects(r1, r2)
    if r1.x + r1.width < r2.x - 1 then
        return false
    elseif r1.y > r2.y + r2.height + 1 then
        return false
    elseif r1.x > r2.x + r2.width + 1 then
        return false
    elseif r1.y + r1.height < r2.y - 1 then
        return false
    else
        return true
    end
end

local function impair(x)
    return math.floor(x / 2) * 2 - 1
end

local function createRooms()
    local maxRoomSize = ROOM_MAX_WIDTH * ROOM_MAX_WIDTH
    local mapToFill = (map.width * map.height) / 2.5
    local nbRooms = math.ceil(mapToFill / maxRoomSize) + 1
    rooms = {}

    local nbTry = 0
    repeat
        -- position d'une pièce
        local room = {}
        room.width = impair(love.math.random(ROOM_MIN_WIDTH, ROOM_MAX_WIDTH))
        room.height = impair(love.math.random(ROOM_MIN_WIDTH, ROOM_MAX_WIDTH))
        room.x = love.math.random(2, map.width - room.width - 1)
        room.y = love.math.random(2, map.width - room.height - 1)

        -- On vérifie si la pièce en touche d'autre
        local goodRoom = true
        for _, r in pairs(rooms) do
            if intersects(r, room) then
                goodRoom = false
                break
            end
        end

        if goodRoom then
            nbTry = 0
            table.insert(rooms, room)
        else
            nbTry = nbTry + 1
        end
    until #rooms == nbRooms or nbTry == 150

    -- Creuse les pièces
    for _, room in pairs(rooms) do
        -- les murs
        for x = room.x - 1, room.x + room.width + 1 do
            map[x][room.y - 1] = tileFactory.create(WALL)
            map[x][room.y + room.height + 1] = tileFactory.create(WALL)
        end
        for y = room.y - 1, room.y + room.height + 1 do
            map[room.x - 1][y] = tileFactory.create(WALL)
            map[room.x + room.width + 1][y] = tileFactory.create(WALL)
        end
        -- Le sol
        for x = room.x, room.x + room.width do
            for y = room.y, room.y + room.height do
                map[x][y] = tileFactory.create(FLOOR)
            end
        end
    end
end

local function roomCenter(room)
    local p = {}
    p.x = math.floor(room.x + room.width / 2)
    p.y = math.floor(room.y + room.height / 2)
    return p
end

local function hCorridor(x1, x2, y)
    local sens = (x2 - x1) / math.abs(x2 - x1)
    for x = x1, x2, sens do
        table.insert(corridors, {x, y})
    end
end

local function vCorridor(y1, y2, x)
    local sens = (y2 - y1) / math.abs(y2 - y1)
    for y = y1, y2, sens do
        table.insert(corridors, {x, y})
    end
end

local function createCorridors()
    -- Tant que toutes les pièces ne sont pas liées, on continue
    for i = 1, #rooms - 1 do
        local r1 = rooms[i]
        local r2 = rooms[i + 1]
        local c1 = roomCenter(r1)
        local c2 = roomCenter(r2)

        if love.math.random(100) < 50 then
            -- horizontal
            hCorridor(c1.x, c2.x, c1.y)
            vCorridor(c1.y, c2.y, c2.x)
        else
            -- vertical
            vCorridor(c1.y, c2.y, c1.x)
            hCorridor(c1.x, c2.x, c2.y)
        end
    end

    for _, value in pairs(corridors) do
        if map[value[1]][value[2]].type == WALL then
            map[value[1]][value[2]] = tileFactory.create(CORRIDOR)
        end
    end
end

local function removeWalls()
    local newMap = {}
    for x = 2, map.width - 1 do
        newMap[x] = {}
        for y = 2, map.height - 1 do
            newMap[x][y] = map[x][y]
            if map[x - 1][y].type == WALL and map[x + 1][y].type == WALL and map[x][y - 1].type == WALL and map[x][y + 1].type == WALL then
                if map[x + 1][y + 1].type == WALL and map[x - 1][y - 1].type == WALL and map[x + 1][y - 1].type == WALL and
                    map[x - 1][y + 1].type == WALL then
                    newMap[x][y].quad = Assets.empty_gray
                end
            end
        end
    end
    for x = 2, map.width - 1 do
        for y = 2, map.height - 1 do
            map[x][y] = newMap[x][y]
        end
    end
end

local function createPagesPieces()
    -- key in 9 parts : in monsters and in createBarrels
    local split = math.floor(love.math.random(MAX_PAGES / 3, MAX_PAGES / 3 * 2))
    local pos
    for i = 1, split do
        pos = this.getEmptyLocation()
        local barel = ItemManager.newBarrel(pos.x * TILESIZE, pos.y * TILESIZE)
        barel.loot = "page" .. i
    end
    for i = split + 1, MAX_PAGES do
        repeat
            pos = this.getEmptyLocation(0)
        until pos.room ~= map.spawn.room -- pas de slim dans la pièce du spanw

        local slim = ItemManager.newSlim(pos.x * TILESIZE, pos.y * TILESIZE)
        slim.loot = "page" .. i
    end
end

local function createBarrels(nbTotal)
    local nb = 0
    for _, item in pairs(ItemManager.getItems()) do
        if item.name == "barrel" then
            nb = nb + 1
        end
    end
    for _ = nb + 1, nbTotal do
        local pos = this.getEmptyLocation()
        ItemManager.newBarrel(pos.x * TILESIZE, pos.y * TILESIZE)
    end
end

local function createSlims(nbTotal)
    local nb = 0
    local pos
    for _, item in pairs(ItemManager.getItems()) do
        if item.name == "slim" then
            nb = nb + 1
        end
    end
    for _ = nb + 1, nbTotal do
        repeat
            pos = this.getEmptyLocation(0) -- monsters in rooms only
        until pos.room ~= map.spawn.room
        ItemManager.newSlim(pos.x * TILESIZE, pos.y * TILESIZE)
    end
end

this.build = function(width, height, seed)
    map = {}
    rooms = {}
    corridors = {}
    local t0 = love.timer.getTime()
    if (seed ~= nil) then
        print("seeding : " .. seed)
        love.math.setRandomSeed(seed)
    end
    map.width = width
    map.height = height

    initWalls()
    createRooms()
    createCorridors()
    removeWalls()

    -- Création du spawn du player
    map.spawn = this.getEmptyLocation(0) -- forcément dans une pièce

    -- Création de la grille de sortie
    if OPTIONS.SPAWN_AT_GRID then
        map.grid = this.getEmptyLocation(map.spawn.room)
    else
        map.grid = this.getEmptyLocation(0)
    end
    ItemManager.newExitGrid(map.grid.x * TILESIZE, map.grid.y * TILESIZE)

    -- on créé les autres entités du niveau par rapport à la position du player
    createPagesPieces()
    createBarrels(20)
    createSlims(12)

    map.collideAt = function(x, y)
        local tileX = math.floor(x / TILESIZE)
        local tileY = math.floor(y / TILESIZE)

        if tileX < 1 or tileY < 1 or tileX > width or tileY > height then
            return true
        else
            return (map[tileX][tileY].type == WALL)
        end
    end

    print("Map created in " .. love.timer.getTime() - t0)
    return map
end

-- roomNumber = nil -> n'importe ou dans la map
-- roomNumber = 0 -> n'importe ou, mais dans une pièce
-- roomNumber = n -> n'importe ou, dans la pièce n
this.getEmptyLocation = function(roomNumber)
    local xmin = 1
    local xmax = map.width
    local ymin = 1
    local ymax = map.height

    if roomNumber ~= nil then
        if roomNumber == 0 then
            roomNumber = love.math.random(1, #rooms)
        end
        xmin = rooms[roomNumber].x
        xmax = xmin + rooms[roomNumber].width
        ymin = rooms[roomNumber].y
        ymax = ymin + rooms[roomNumber].height
    end

    local tx, ty
    local nbTry = 0
    repeat
        nbTry = nbTry + 1
        tx = love.math.random(xmin, xmax)
        ty = love.math.random(ymin, ymax)
    until map[tx][ty].type == FLOOR or nbTry > 200
    return {x = tx, y = ty, room = roomNumber}
end

return this