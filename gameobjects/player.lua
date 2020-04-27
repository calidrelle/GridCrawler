local this = {}
this.x = 0
this.y = 0
this.dx = 0
this.dy = 0

STAMINA_JUMP = 30
STAMINA_FIRE = 10

this.flip = false
this.bounds = {}
this.messages = {}

FRICTION = 0.55

this.createNew = function(x, y)
    this.name = "player"
    this.x = x
    this.y = y
    this.bounds.x = 6
    this.bounds.y = 6
    this.bounds.width = 5
    this.bounds.height = 8
    this.animIdle = require("engine.animation").createNew(Assets.knight_idle_anim, 6, 0.1, true)
    this.animRun = require("engine.animation").createNew(Assets.knight_run_anim, 6, 0.1, true)
    this.animDeath = require("engine.animation").createNew(Assets.knight_death_anim, 7, 0.3, false)
    this.currentAnim = this.animIdle
    this.gridOpened = false

    this.pv = 10
    this.pvMax = 10
    this.atkRange = 20
    this.atk = 4
    this.def = 2
    this.speedInit = 120
    this.speed = 120
    this.stamina = 100
    this.staminaRegen = 25 -- stamina par seconde
    this.regenPv = 0.5
end

this.getCenter = function()
    return this.x + this.bounds.x + this.bounds.width / 2, this.y + this.bounds.y + this.bounds.height / 2
end

this.resetAnims = function()
    this.animIdle.reset()
    this.animRun.reset()
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

        if Map.collideAt(px1, py1) or Map.collideAt(px1, py2) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px1, py2) then
            this.dx = 0
            tdx = 0
        end
    end
    if (this.dx > 0) then
        px1 = this.x + this.bounds.x + this.bounds.width + tdx
        py1 = this.y + this.bounds.y
        py2 = this.y + this.bounds.y + this.bounds.height
        if Map.collideAt(px1, py1) or Map.collideAt(px1, py2) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px1, py2) then
            this.dx = 0
            tdx = 0
        end
    end

    if (this.dy < 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if Map.collideAt(px1, py1) or Map.collideAt(px2, py1) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px2, py1) then
            this.dy = 0
            tdy = 0
        end
    end

    if (this.dy > 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + this.bounds.height + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if Map.collideAt(px1, py1) or Map.collideAt(px2, py1) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px2, py1) then
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
    table.insert(this.messages, 1, msg)
end

local function checkGridOpen()
    local count = 0
    for _, item in pairs(Inventory.getItems()) do
        if item.name ~= nil then
            if item.name:sub(1, 4) == "page" then
                count = count + 1
            end
        end
    end
    return count == MAX_PAGES
end

local firePressed = false
local function shoot(dt)
    -- on tir
    if love.keyboard.isDown(OPTIONS.FIRE) then
        if firePressed == false then
            if this.stamina > STAMINA_FIRE then
                -- on créé l'épée en peu plus devant le joueur
                local x = this.x + this.dx * TILESIZE
                local y = this.y + this.dy * TILESIZE
                ItemManager.newSword(x, y, this.shootx, this.shooty)
                this.stamina = this.stamina - STAMINA_FIRE
                Assets.snd_shoot:play()
            else
                Assets.snd_nostamina:play()
            end
        end
        firePressed = true
    else
        firePressed = false
    end
end

local isJumping = 0
local canJump = true
local function jump(dt)
    if love.keyboard.isDown(OPTIONS.JUMP) and canJump then
        if isJumping == 0 then
            if this.stamina > STAMINA_JUMP then
                Assets.snd_jump:play()
                isJumping = 0.15
                this.stamina = this.stamina - STAMINA_JUMP
                canJump = false
            else
                Assets.snd_nostamina:play()
            end
        end
    end
    if not love.keyboard.isDown(OPTIONS.JUMP) then
        canJump = true
    end
    if isJumping > 0 then
        isJumping = isJumping - dt
        this.speed = 300
    else
        isJumping = 0
    end
end

this.update = function(dt)
    this.currentAnim.update(self, dt)
    if this.pv <= 0 then
        this.pv = 0
        if this.currentAnim ~= this.animDeath then
            Assets.snd_deathplayer:play()
            this.currentAnim = this.animDeath
        end
        return
    end
    if this.stamina < 100 then
        this.stamina = this.stamina + this.staminaRegen * dt
    else
        this.stamina = 100
    end
    -- Déplacements
    this.speed = this.speedInit
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

    if this.stamina == 100 then
        if this.pv < this.pvMax then
            this.pv = this.pv + this.regenPv * dt
        end
    end

    jump(dt)
    move(dt)
    shoot(dt)
    this.dx = this.dx * FRICTION
    this.dy = this.dy * FRICTION

    -- on marche sur un truc
    local item = ItemManager.getItemAt(this.getCenter())
    if item ~= nil then
        item.walkOver(this)
        if checkGridOpen() then
            if not this.gridOpened then
                this.gridOpened = true
                Assets.snd_opengrid:play()
                Player.addMessage("La grille est ouverte !", 5)
            end
        end
    end

    -- les messages : on ne décompte que le temps du message affiché (le dernier entré)
    if #this.messages > 0 then
        this.messages[1].timer = this.messages[1].timer - dt
        if this.messages[1].timer <= 0 then
            table.remove(this.messages, 1)
        end
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1)
    this.currentAnim.draw(self, this.x, this.y, this.flip)

    -- love.graphics.setColor(0, 0.6, 1)
    -- love.graphics.rectangle("fill", this.x, this.y + TILESIZE + 3, TILESIZE * this.stamina / 100, 3)
    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.rectangle("line", this.x, this.y + TILESIZE + 3, TILESIZE, 3)

end

return this
