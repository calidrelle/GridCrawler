local this = {}
this.x = 0
this.y = 0
this.dx = 0
this.dy = 0
this.speed = 120
this.flip = false
this.bounds = {}
this.map = {}

this.createNew = function(x, y)
    this.x = x
    this.y = y
    this.bounds.x = 6
    this.bounds.y = 6
    this.bounds.width = 5
    this.bounds.height = 8
    this.animIdle = require("images.animation").createNew(Assets.knight_idle_anim, 6, 0.1)
    this.animRun = require("images.animation").createNew(Assets.knight_run_anim, 6, 0.1)
    this.currentAnim = nil
end

this.resetAnims = function()
    this.animIdle.reset()
    this.animRun.reset()
end

this.setMap = function(map)
    this.map = map
end

local function move(dt)
    local tdx = this.dx * this.speed * dt
    local tdy = this.dy * this.speed * dt

    if (this.dx < 0) then
        if this.map.collideAt(self, this.x + this.bounds.x + tdx, this.y + this.bounds.y) or
            this.map.collideAt(self, this.x + this.bounds.x + tdx, this.y + this.bounds.y + this.bounds.height) then
            this.dx = 0
            tdx = 0
        end
    end
    if (this.dx > 0) then
        if this.map.collideAt(self, this.x + this.bounds.x + this.bounds.width + tdx, this.y + this.bounds.y) or
            this.map.collideAt(self, this.x + this.bounds.x + this.bounds.width + tdx, this.y + this.bounds.y + this.bounds.height) then
            this.dx = 0
            tdx = 0
        end
    end

    if (this.dy < 0) then
        if this.map.collideAt(self, this.x + this.bounds.x, this.y + this.bounds.y + tdy) or
            this.map.collideAt(self, this.x + this.bounds.x + this.bounds.width, this.y + this.bounds.y + tdy) then
            this.dy = 0
            tdy = 0
        end
    end

    if (this.dy > 0) then
        if this.map.collideAt(self, this.x + this.bounds.x, this.y + this.bounds.y + this.bounds.height + tdy) or
            this.map.collideAt(self, this.x + this.bounds.x + this.bounds.width, this.y + this.bounds.y + this.bounds.height + tdy) then
            this.dy = 0
            tdy = 0
        end
    end

    this.x = this.x + tdx
    this.y = this.y + tdy

    this.dx = this.dx * 0.85
    this.dy = this.dy * 0.85
    if math.abs(this.dx) < 0.2 then
        this.dx = 0
    end
    if math.abs(this.dy) < 0.2 then
        this.dy = 0
    end
    if this.dx == 0 and this.dy == 0 then
        this.currentAnim = this.animIdle
    else
        this.currentAnim = this.animRun
    end
end

this.update = function(dt)
    if love.keyboard.isDown("q") then
        this.dx = -1
        this.flip = true
    elseif love.keyboard.isDown("d") then
        this.dx = 1
        this.flip = false
    end
    if love.keyboard.isDown("z") then
        this.dy = -1
    elseif love.keyboard.isDown("s") then
        this.dy = 1
    end
    move(dt)
    this.currentAnim.update(self, dt)
end

this.draw = function()
    this.currentAnim.draw(self, this.x, this.y, this.flip)
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle("line", this.x + this.bounds.x, this.y + this.bounds.y, this.bounds.width, this.bounds.height)
end

return this
