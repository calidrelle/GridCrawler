local this = {}
this.x = 0
this.y = 0
this.dx = 0
this.dy = 0
this.speed = 120
this.gold = 0

this.flip = false
this.bounds = {}
this.map = {}
this.messages = {}

FRICTION = 0.75

this.createNew = function(x, y)
    this.name = "player"
    this.x = x
    this.y = y
    this.bounds.x = 6
    this.bounds.y = 6
    this.bounds.width = 5
    this.bounds.height = 8
    this.animIdle = require("images.animation").createNew(Assets.knight_idle_anim, 6, 0.1)
    this.animRun = require("images.animation").createNew(Assets.knight_run_anim, 6, 0.1)
    this.currentAnim = this.animIdle

    this.pv = 10
    this.atkRange = 20
    this.atk = 3
    this.def = 2
end

this.getCenter = function()
    return {x = this.x + this.bounds.x + this.bounds.width / 2, y = this.y + this.bounds.y + this.bounds.height / 2}
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

    local px1
    local px2
    local py1
    local py2
    if (this.dx < 0) then
        px1 = this.x + this.bounds.x + tdx
        py1 = this.y + this.bounds.y
        py2 = this.y + this.bounds.y + this.bounds.height

        if this.map.collideAt(self, px1, py1) or this.map.collideAt(self, px1, py2) or ItemManager.isItemAt(px1, py1) or
            ItemManager.isItemAt(px1, py2) then
            this.dx = 0
            tdx = 0
        end
    end
    if (this.dx > 0) then
        px1 = this.x + this.bounds.x + this.bounds.width + tdx
        py1 = this.y + this.bounds.y
        py2 = this.y + this.bounds.y + this.bounds.height
        if this.map.collideAt(self, px1, py1) or this.map.collideAt(self, px1, py2) or ItemManager.isItemAt(px1, py1) or
            ItemManager.isItemAt(px1, py2) then
            this.dx = 0
            tdx = 0
        end
    end

    if (this.dy < 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if this.map.collideAt(self, px1, py1) or this.map.collideAt(self, px2, py1) or ItemManager.isItemAt(px1, py1) or
            ItemManager.isItemAt(px2, py1) then
            this.dy = 0
            tdy = 0
        end
    end

    if (this.dy > 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + this.bounds.height + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if this.map.collideAt(self, px1, py1) or this.map.collideAt(self, px2, py1) or ItemManager.isItemAt(px1, py1) or
            ItemManager.isItemAt(px2, py1) then
            this.dy = 0
            tdy = 0
        end
    end

    this.x = this.x + tdx
    this.y = this.y + tdy

    if math.abs(this.dx) < 0.2 then
        this.dx = 0
    end
    if math.abs(this.dy) < 0.2 then
        this.dy = 0
    end
    -- Animations
    if this.dx == 0 and this.dy == 0 then
        this.currentAnim = this.animIdle
    else
        this.currentAnim = this.animRun
        this.shootx = this.dx
        this.shooty = this.dy
    end
    this.currentAnim.update(self, dt)
    this.dx = this.dx * FRICTION
    this.dy = this.dy * FRICTION
end

local function canTouch(item)
    local x1 = item.x + item.width / 2
    local y1 = item.y + item.height / 2
    local x2 = this.getCenter().x
    local y2 = this.getCenter().y

    -- distance rapide
    if math.abs(x1 - x2) > TILESIZE * 3 then
        return false
    elseif math.abs(y1 - y2) > TILESIZE * 3 then
        return false
    end

    local dist2 = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
    return dist2 <= (this.atkRange * this.atkRange)
end

local function checkActions(mx, my)
    mx = (mx - (PIXELLARGE / 2)) / SCALE + this.x
    my = (my - (HEIGHT / 2)) / SCALE + this.y

    -- distance ?
    local item = ItemManager.getItemAt(mx, my)
    if item ~= nil then
        if canTouch(item) then
            item.hit(this)
        end
    end
end

this.addMessage = function(text, timer)
    for key, msg in pairs(this.messages) do
        if msg.text == text then
            return
        end
    end
    local msg = {}
    msg.text = text
    msg.timer = timer
    table.insert(this.messages, msg)
end

local cooldown = 0
local function shoot(dt)
    -- on tir
    if cooldown >= 0 then
        cooldown = cooldown - dt
        if cooldown <= 0 then
            cooldown = 0
        end
    end
    if love.keyboard.isDown(OPTIONS.FIRE) and cooldown == 0 then
        ItemManager.newSword(this.x, this.y, this.shootx, this.shooty)
        cooldown = 0.1
    end
end

this.update = function(dt)
    -- Déplacements
    if love.keyboard.isDown(OPTIONS.LEFT) then
        this.dx = -1
        this.flip = true
    elseif love.keyboard.isDown(OPTIONS.RIGHT) then
        this.dx = 1
        this.flip = false
    end
    if love.keyboard.isDown(OPTIONS.UP) then
        this.dy = -1
    elseif love.keyboard.isDown(OPTIONS.DOWN) then
        this.dy = 1
    end
    move(dt)
    shoot(dt)

    -- on marche sur un truc
    local item = ItemManager.getItemAt(this.getCenter().x, this.getCenter().y)
    if item ~= nil then
        item.walkOver(this)
    end

    -- les messages
    for i = #this.messages, 1, -1 do
        this.messages[i].timer = this.messages[i].timer - dt
        if this.messages[i].timer <= 0 then
            table.remove(this.messages, i)
        end
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1)
    this.currentAnim.draw(self, this.x, this.y, this.flip)
end

-- function love.mousepressed(x, y, button)
--     if button == 1 then
--         checkActions(x, y)
--     end
-- end

return this
