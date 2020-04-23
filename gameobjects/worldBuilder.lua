local this = {}

local map = {}

local function initRandomMap()
    for x = 1, map.width do
        map[x] = {}
        for y = 1, map.height do
            map[x][y] = FLOOR
            if love.math.random(100) < 47 then
                map[x][y] = WALL
            end
        end
    end
end

local function getNbWall(x, y)
    local count = 0
    for i = -1, 1 do
        for j = -1, 1 do
            local tx = x + i
            local ty = y + j
            if tx < 1 or tx > map.width or ty < 1 or ty > map.height then
                count = count + 1
            else
                if map[tx][ty] == WALL then
                    count = count + 1
                end
            end
        end
    end
    return count
end

local function smoothMap()
    local newMap = {}
    for x = 1, map.width do
        newMap[x] = {}
        for y = 1, map.height do
            local nbWalls = getNbWall(x, y)
            if nbWalls > 4 then
                newMap[x][y] = WALL
            elseif nbWalls < 5 then
                newMap[x][y] = FLOOR
            else
                newMap[x][y] = map[x][y]
            end
        end
    end
    for x = 1, map.width do
        for y = 1, map.height do
            if (x == 1 or y == 1 or x == map.width or y == map.height) then
                map[x][y] = BEDROCK
            else
                map[x][y] = newMap[x][y]
            end
        end
    end
end

this.getEmptyLocation = function()
    local tx, ty
    repeat
        tx = love.math.random(1, map.width)
        ty = love.math.random(1, map.height)
    until map[tx][ty] == FLOOR
    return {x = tx, y = ty}
end

this.build = function(width, height, seed)
    local t0 = love.timer.getTime()
    if (seed ~= nil) then
        print("seeding : " .. seed)
        love.math.setRandomSeed(seed)
    end
    map = {}
    map.width = width
    map.height = height
    initRandomMap()
    for i = 1, 3 do
        smoothMap()
    end
    print("Map created in " .. love.timer.getTime() - t0)
    return map
end

return this
