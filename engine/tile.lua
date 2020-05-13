local factory = {}

WALL = 1
FLOOR = 2
CORRIDOR = 3
DECO = 4

factory.addLayerToMap = function(layer, map)
    -- remplissage de la map dans le sens y, x donné par Tiled
    print("Loading layer " .. layer.name .. "...")
    for y = 1, layer.height do
        for x = 1, layer.width do
            local id = layer.data[x + (y - 1) * layer.width]
            if id ~= 0 then
                if layer.name == "items" then
                    map.createItemFromId(id, x, y)
                elseif layer.name == "player" then
                    map.spawn = {x = x, y = y, room = 1}
                elseif layer.name == "deco" or layer.name == "wallup" then
                    -- todo : certainement des Items qui s'affiche bêtement à un endroit par dessus des tuiles existantes
                    map[x][y].upperQuad = factory.getQuadFromId(id)
                else
                    map[x][y] = factory.createFromId(id)
                end
            end
        end
    end
    print("Layer " .. layer.name .. " loaded")
end

factory.getQuadFromId = function(id)
    local tileInWidth = 28
    local qx = (id % tileInWidth) - 1
    local qy = math.floor(id / tileInWidth)
    return love.graphics.newQuad(qx * TILESIZE, qy * TILESIZE, TILESIZE, TILESIZE, Assets.getSheet():getDimensions())
end

factory.createFromId = function(id)
    local quad = factory.getQuadFromId(id)

    if id == 90 or id == 62 then
        return factory.create(WALL, quad)

    elseif id == 59 or id == 60 or id == 61 or id == 87 or id == 88 or id == 89 then
        -- sol avec dalles
        return factory.create(FLOOR, quad)

    elseif id == 11 or id == 12 then
        -- sol extérieur
        return factory.create(WALL, quad)

    elseif id == 16 or id == 17 or id == 18 or id == 44 or id == 45 or id == 46 then
        -- murs et plafond inaccessible pour la 32
        return factory.create(WALL, quad)

    elseif id == 32 then
        local tmp = factory.create(WALL, quad)
        tmp.upperQuad = quad
        return tmp

    elseif id == 349 or id == 350 then
        -- Porte de déco considérer comme un mur
        return factory.create(WALL, quad)

    else
        -- print("Default DECO tile id : " .. id .. "(" .. qx * 16 .. "," .. qy * 16 .. ")")
        -- return factory.create(DECO, quad)
        error("Tile id inconnu : " .. id .. "(" .. quad.qx * 16 .. "," .. quad.qy * 16 .. ")")
    end
end

factory.create = function(type, quad)
    local this = {}
    local rnd
    this.type = type
    this.upperQuad = nil

    if type == CORRIDOR then
        rnd = love.math.random(1, 2)
        this.quad = Assets.corridor[rnd]
    elseif type == FLOOR then
        rnd = love.math.random(1, #Assets.floor)
        this.quad = Assets.floor[rnd]
    elseif type == WALL then
        rnd = love.math.random(1, #Assets.wall)
        this.quad = Assets.wall[rnd]
    end
    if quad ~= nil then
        this.quad = quad
    end

    this.visited = false

    this.draw = function(x, y, upper)
        local r, g, b = 1, 1, 1
        if Player.level > 6 then
            r, g, b = 0.6, 0.6, 0.6
        elseif Player.level > 3 then
            r, g, b = 0.8, 0.8, 0.8
        end
        if this.type == FLOOR then
            love.graphics.setColor(r, g, b)
        else
            love.graphics.setColor(1, 1, 1)
        end
        if upper then
            if this.upperQuad ~= nil then
                Assets.draw(this.upperQuad, x, y)
            end
        else
            if this.quad ~= nil then
                Assets.draw(this.quad, x, y)
            end
        end
    end

    return this
end

return factory

