local factory = {}

WALL = 1
FLOOR = 2
CORRIDOR = 3

factory.create = function(type, quad)
    local this = {}
    local rnd
    this.type = type
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

    this.draw = function(x, y)
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
        Assets.draw(this.quad, x, y)
    end

    return this
end

return factory

