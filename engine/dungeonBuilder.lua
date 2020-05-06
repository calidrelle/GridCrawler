local this = {}

local ROOM_MIN_WIDTH = 6
local ROOM_MAX_WIDTH = 12
MAX_PAGES = 8

local map = {}
local rooms = {}
local corridors = {}

local tileFactory = require("engine.tile")
-- pathfinder
local pathfinder = require("engine.pathfinder")

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

local function getSurroundsWall(x, y)
    local res = ""
    for dy = -1, 1 do
        for dx = -1, 1 do
            if map[x + dx][y + dy].type == WALL then
                res = res .. "x"
            else
                res = res .. "o"
            end
        end
    end
    return res
end

local function getDistNearestPics(cellX, cellY)
    local x = cellX * TILESIZE
    local y = cellY * TILESIZE
    local minDist = 100000000
    for _, item in pairs(ItemManager.getPics()) do
        local d = math.dist(item.x, item.y, x, y)
        if d < minDist then
            minDist = d
        end
    end
    return minDist
end

local function createPics()
    local nbPicsTotal = Player.level * OPTIONS.DIFFICULTY + 5
    local nbPics = 0

    local nbTry = 0
    while nbPics < nbPicsTotal do
        local x = love.math.random(map.width)
        local y = love.math.random(map.height)
        if map[x][y].type == CORRIDOR then
            local tmp = getSurroundsWall(x, y)
            local ok = false
            if tmp == "xxxoooxxx" then
                ok = true
            elseif tmp == "xoxxoxxox" then
                ok = true
            elseif tmp == "xxxooooxx" then
                ok = true
            else
                ok = false
            end
            if ok and getDistNearestPics(x, y) < 40 then
                ok = false
            end
            if ok or nbTry > 200 then
                ItemManager.newPics(x * TILESIZE, y * TILESIZE)
                nbPics = nbPics + 1
            else
                nbTry = nbTry + 1
            end
        end
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
    createPics()
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

local function deployPages()
    for i = 1, MAX_PAGES do
        local item
        repeat
            item = ItemManager.getRandomItem()
        until item.canDropPage
        table.insert(item.lootTable, ItemManager.newPage(-1, -1, i))
    end
end

local function createBarrels(nbTotal)
    for _ = 1, nbTotal do
        local pos = this.getEmptyLocation()
        ItemManager.newBarrel(pos.x * TILESIZE, pos.y * TILESIZE)
    end
end

this.nearWall = function(pos)
    for x = -1, 1 do
        for y = -1, 1 do
            if map[pos.x + x][pos.y + y].type == WALL then
                return true
            end
        end
    end
    return false
end

local function createChests(nbTotal)
    local pos
    for _ = 1, nbTotal do
        repeat
            pos = this.getEmptyLocation(0)
        until this.nearWall(pos)
        ItemManager.newChest(pos.x * TILESIZE, pos.y * TILESIZE)
    end
end

local function createSlims(level)
    local pos
    repeat
        pos = this.getEmptyLocation(0) -- monsters in rooms only
    until pos.room ~= map.spawn.room and math.dist(pos.x, pos.y, map.spawn.x, map.spawn.y) > 15 -- pas dans monstre dans la pièce du spawn
    ItemManager.newSlim(pos.x * TILESIZE, pos.y * TILESIZE, level)
end

local function createGoblins(level)
    local pos
    repeat
        pos = this.getEmptyLocation(0) -- monsters in rooms only
    until pos.room ~= map.spawn.room and math.dist(pos.x, pos.y, map.spawn.x, map.spawn.y) > 15 -- pas dans monstre dans la pièce du spawn
    ItemManager.newGoblin(pos.x * TILESIZE, pos.y * TILESIZE, level)

end

local function createZombies(level)
    local pos
    repeat
        pos = this.getEmptyLocation(0) -- monsters in rooms only
    until pos.room ~= map.spawn.room and math.dist(pos.x, pos.y, map.spawn.x, map.spawn.y) > 15 -- pas dans monstre dans la pièce du spawn
    ItemManager.newZombie(pos.x * TILESIZE, pos.y * TILESIZE, level)
end

this.build = function(width, height, seed)
    map = {}
    rooms = {}
    corridors = {}
    local t0 = love.timer.getTime()
    if (seed ~= nil) then
        love.math.setRandomSeed(seed)
    else
        love.math.setRandomSeed(t0)
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
    map.grid = this.getEmptyLocation(0)
    ItemManager.newExitGrid(map.grid.x * TILESIZE, map.grid.y * TILESIZE)

    -- on créé les autres entités du niveau par rapport à la position du player
    -- Items présents : les pics et la sortie
    createBarrels(love.math.random(15, 25))
    createChests(love.math.random(1, 3))

    -- Création des mobs selon le niveau du Player
    local mobsToCreate = {}
    for _, mobLev in pairs(DATA.mobLevels) do
        if mobLev[3] <= Player.level and Player.level <= mobLev[4] then
            table.insert(mobsToCreate, mobLev)
        end
    end

    local nbMobs = math.floor(10 + Player.level * 1.4 + (OPTIONS.DIFFICULTY * 1.5))
    for i = 1, nbMobs do
        local mob = mobsToCreate[love.math.random(#mobsToCreate)]
        if mob[1] == "slim" then
            createSlims(mob[2])
        end
        if mob[1] == "goblin" then
            createGoblins(mob[2])
        end
        if mob[1] == "zombie" then
            createZombies(mob[2])
        end

    end
    deployPages()

    map.collideAt = function(x, y)
        local tileX = math.floor(x / TILESIZE)
        local tileY = math.floor(y / TILESIZE)

        if tileX < 1 or tileY < 1 or tileX > width or tileY > height then
            return true
        else
            return (map[tileX][tileY].type == WALL)
        end
    end

    map.pathfinder = pathfinder.create(map)
    print("Map created in " .. love.timer.getTime() - t0)
    map.totalGolds = ItemManager.getPoInItems()
    print("Golds dans le donjon : " .. map.totalGolds)
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
    local onSpawn = false
    repeat
        nbTry = nbTry + 1
        tx = love.math.random(xmin, xmax)
        ty = love.math.random(ymin, ymax)
        if map.spawn == nil then
            onSpawn = false
        else
            onSpawn = map.spawn.x == tx and map.spawn.y == ty
        end
    until (map[tx][ty].type == FLOOR and not onSpawn) or nbTry > 200
    return {x = tx, y = ty, room = roomNumber}
end

-- Map vide, chez le marchand par exemple
this.createEmptyMap = function(width, height)
    map = {}
    map.width = width
    map.height = height
    for x = 1, map.width do
        map[x] = {}
        for y = 1, map.height do
            if x == 1 or y == 1 or x == map.width or y == map.height then
                map[x][y] = tileFactory.create(WALL, Assets.empty_brown)
            else
                map[x][y] = tileFactory.create(FLOOR)
            end
        end
    end

    map.collideAt = function(x, y)
        local tileX = math.floor(x / TILESIZE)
        local tileY = math.floor(y / TILESIZE)

        if tileX < 1 or tileY < 1 or tileX > width or tileY > height then
            return true
        else
            return (map[tileX][tileY].type == WALL)
        end
    end
    return map
end

return this
