local factory = {}

WALL = 1
FLOOR = 2
CORRIDOR = 3
GRID = 4

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

    this.draw = function(x, y)
        Assets.draw(this.quad, x, y)
    end

    return this
end

return factory
