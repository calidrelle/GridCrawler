--[[
    https://www.youtube.com/watch?v=aKYlikFAV4k
    Portage du code javascript présenté dans la vidéo "The coding train"
    https://thecodingtrain.com/CodingChallenges/051.1-astar.html

    for x = 1, Map.width do
        for y = 1, Map.height do
            if Map[x][y].type == WALL then

TODO si besoin des diagonales : https://youtu.be/EaZxUCWAjb0?t=349

]] -----
local factory = {}

local Spot = {}
Spot.create = function(x, y, isWall)
    local this = {}
    this.x = x
    this.y = y

    this.f = 0
    this.g = 0 -- score from the beginning
    this.h = 0
    this.previous = nil

    this.neighbors = {}
    this.wall = isWall

    this.reset = function()
        this.f = 0
        this.g = 0
        this.h = 0
        this.previous = nil
    end

    this.addNeighbors = function(g)
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) then
                    if this.x + dx >= 1 and this.x + dx <= g.width and this.y + dy >= 1 and this.y + dy <= g.height then
                        if dx == 0 or dy == 0 then
                            if not g[this.x + dx][this.y + dy].wall then
                                table.insert(this.neighbors, g[this.x + dx][this.y + dy])
                            end
                        else
                            -- diagonale, des trucs à vérifier
                            if not g[this.x + dx][this.y].wall and not g[this.x][this.y + dy].wall then
                                table.insert(this.neighbors, g[this.x + dx][this.y + dy])
                            end
                        end
                    end
                end
            end
        end
    end

    this.draw = function(r, g, b)
        -- pour debug
        if not this.wall then
            love.graphics.setColor(r, g, b, 0.2)
            love.graphics.rectangle("fill", x * TILESIZE, y * TILESIZE, TILESIZE, TILESIZE)
        end
    end

    return this
end
-----------------------------------------

factory.create = function(map)
    local this = {}
    this.grid = {}
    this.width = map.width
    this.height = map.height
    this.grid.width = map.width
    this.grid.height = map.height

    -- c'réation de la grille avec les murs
    for x = 1, this.width do
        this.grid[x] = {}
        for y = 1, this.height do
            local tile = map[x][y]
            this.grid[x][y] = Spot.create(x, y, tile.type == WALL)
        end
    end

    -- calcul des voisins de chaque grille
    for x = 1, this.width do
        for y = 1, this.height do
            this.grid[x][y].addNeighbors(this.grid)
        end
    end

    this.heuristic = function(n1, n2)
        -- local d = math.dist(n1.x, n1.y, n2.x, n2.y)
        local d = math.abs(n1.x - n2.x) + math.abs(n1.y - n2.y)
        return d
    end

    this.resetCounters = function()
        for x = 1, this.width do
            for y = 1, this.height do
                this.grid[x][y].reset()
            end
        end
    end

    this.getPath = function(x1, y1, x2, y2)
        local path = {}
        path.path = {}
        path.openSet = {}
        path.closedSet = {}
        this.resetCounters()

        local start = this.grid[x1][y1]
        local goal = this.grid[x2][y2]

        table.insert(path.openSet, start)

        local nbTry = 0
        local maxTry = 100000
        while #path.openSet > 0 and nbTry < maxTry do
            nbTry = nbTry + 1
            -- current = node in openSet having the lowest fScore value
            local winner = 1
            for key, value in pairs(path.openSet) do
                if value.f < path.openSet[winner].f then
                    winner = key
                end
            end
            local current = path.openSet[winner]

            if (path.openSet[winner] == goal) then
                -- contruct the path
                local temp = current
                table.insert(path.path, temp)
                while temp.previous ~= nil do
                    table.insert(path.path, temp.previous)
                    temp = temp.previous
                end
                path.iterations = nbTry
                return path
            end

            table.remove(path.openSet, winner)
            table.insert(path.closedSet, current)

            -- for each neighbor of current
            for _, neighbor in pairs(current.neighbors) do
                -- if neighbor in closedSet, continue to next neighbor
                if not table.contains(path.closedSet, neighbor) and not neighbor.wall then
                    local tempG = current.g + 1 -- distance between current and neighbor, standard grid, dist = 1 cell

                    local newPath = false
                    if table.contains(path.openSet, neighbor) then
                        if tempG < neighbor.g then
                            neighbor.g = tempG
                            newPath = true
                        end
                    else
                        neighbor.g = tempG
                        newPath = true
                        table.insert(path.openSet, neighbor)
                    end
                    if newPath then
                        neighbor.h = this.heuristic(neighbor, goal)
                        neighbor.f = neighbor.g + neighbor.h
                        neighbor.previous = current
                    end
                else
                    -- ce voisin a déjà été vérifié
                end
            end -- voisin suivant

        end
        return nil
    end

    this.draw = function(path)
        -- pour debug
        for x = 1, this.width do
            for y = 1, this.height do
                this.grid[x][y].draw(1, 1, 1)
            end
        end

        for key, value in pairs(path.closedSet) do
            value.draw(1, 0, 0)
        end
        for key, value in pairs(path.openSet) do
            value.draw(0, 1, 0)
        end
        for key, value in pairs(path.path) do
            value.draw(0, 0, 1)
        end
        if #path.path > 1 then
            path.path[#path.path - 1].draw(1, 1, 1)
        end

    end

    return this -- a pathfinder
end

return factory
