local this = {}
this.x = 0
this.y = 0
this.dx = 0
this.dy = 0

STAMINA_JUMP = 30
STAMINA_FIRE = 10

this.flip = false
this.bounds = {}

FRICTION = 0.55

this.createNew = function()
    this.name = "player"
    this.level = 1
    this.x = 0
    this.y = 0
    this.bounds.x = 7
    this.bounds.y = 7
    this.bounds.width = 4
    this.bounds.height = 6
    this.animIdle = require("engine.animation").createNew(Assets.knight_idle_anim, 6, 0.1, true)
    this.animRun = require("engine.animation").createNew(Assets.knight_run_anim, 6, 0.1, true)
    this.animDeath = require("engine.animation").createNew(Assets.knight_death_anim, 7, 0.3, false)
    this.currentAnim = this.animIdle
    this.gridOpened = false
    this.jumpingTimer = 0
    this.shootx = 0
    this.shooty = 0
    this.lastdx = 0
    this.lastdy = 0

    this.hasItemSelected = false

    this.canBeAttacked = true -- le player peut se faire taper
    this.pv = 10
    this.pvMax = 10
    this.atkRange = 40
    this.atk = 4
    this.def = 2
    this.speedInit = 120
    this.speed = 120
    this.stamina = 100
    this.regenStamina = 25
    this.regenPv = 0.5
    this.auras = {}
    this.aurasToDeal = {} -- les debufs que le player passe à ses cibles

    Inventory.init()
end

this.setPosition = function(x, y)
    this.x = x
    this.y = y
end

this.getCenter = function()
    return this.x + this.bounds.x + this.bounds.width / 2, this.y + this.bounds.y + this.bounds.height / 2
end

this.getMapCell = function()
    local cx, cy = this.getCenter()
    return math.floor(cx / TILESIZE), math.floor(cy / TILESIZE)
end

this.resetAnims = function()
    this.animIdle.reset()
    this.animRun.reset()
end

this.lowlife = function()
    return this.pv / this.pvMax < 0.5 and this.pv > 0
end

local function move(dt)
    local tdx = this.dx * this.speed * dt
    local tdy = this.dy * this.speed * dt
    this.lastdx = this.dx
    this.lastdy = this.dy

    local px1
    local px2
    local py1
    local py2
    if (this.dx < 0) then
        px1 = this.x + this.bounds.x + tdx
        py1 = this.y + this.bounds.y
        py2 = this.y + this.bounds.y + this.bounds.height

        if Map.collideAt(px1, py1) or Map.collideAt(px1, py2) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px1, py2) then
            tdx = 0
        end
    end
    if (this.dx > 0) then
        px1 = this.x + this.bounds.x + this.bounds.width + tdx
        py1 = this.y + this.bounds.y
        py2 = this.y + this.bounds.y + this.bounds.height
        if Map.collideAt(px1, py1) or Map.collideAt(px1, py2) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px1, py2) then
            tdx = 0
        end
    end

    if (this.dy < 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if Map.collideAt(px1, py1) or Map.collideAt(px2, py1) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px2, py1) then
            tdy = 0
        end
    end

    if (this.dy > 0) then
        px1 = this.x + this.bounds.x
        py1 = this.y + this.bounds.y + this.bounds.height + tdy
        px2 = this.x + this.bounds.x + this.bounds.width
        if Map.collideAt(px1, py1) or Map.collideAt(px2, py1) or ItemManager.isItemSolidAt(px1, py1) or ItemManager.isItemSolidAt(px2, py1) then
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
        this.shootx = math.sign(this.dx) * 0.7
        this.shooty = math.sign(this.dy) * 0.7
    end
end

local function doShoot(dt)
    if this.stamina > STAMINA_FIRE then
        -- on créé l'épée en peu plus devant le joueur
        if this.shootx == 0 and this.shooty == 0 then
            this.shootx = 1
        end
        local x = this.x + this.shootx * TILESIZE
        local y = this.y + this.shooty * TILESIZE
        local sword = ItemManager.newSword(x, y, this.shootx, this.shooty)
        sword.initStats(0, Player.atk, 0, 0, Player.atkRange, 0, Player.aurasToDeal)
        this.stamina = this.stamina - STAMINA_FIRE
        Assets.snd_shoot:play()
    else
        Assets.snd_nostamina:play()
    end
end

local function doSelectItem(dt)
    this.hasItemSelected = true
end

local firePressed = false
local function checkAction(dt)
    this.hasItemSelected = false
    if love.keyboard.isDown(OPTIONS.FIRE) then
        if firePressed == false then
            if not Player.inTheShop then
                doShoot(dt)
            else
                doSelectItem(dt)
            end
        end
        firePressed = true
    else
        firePressed = false
    end
end

local canJump = true
local function jump(dt)
    if love.keyboard.isDown(OPTIONS.JUMP) and canJump then
        if this.jumpingTimer == 0 then
            if this.stamina > STAMINA_JUMP then
                Assets.snd_jump:play()
                ItemManager.newSmoke(Player.x - Player.dx, Player.y - Player.dy)
                this.jumpingTimer = 0.15
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
    if this.jumpingTimer > 0 then
        this.jumpingTimer = this.jumpingTimer - dt
        this.speed = 300
    else
        this.jumpingTimer = 0
    end
end

this.update = function(dt)
    this.currentAnim.update(self, dt)
    if this.pv <= 0 then
        this.pv = 0

        if this.currentAnim == this.animDeath then
            if not this.currentAnim.isPlaying then
                GameOver.status = true
            end
        else
            Assets.snd_deathplayer:play()
            this.currentAnim = this.animDeath
        end
        return
    end

    if this.stamina < 100 then
        this.stamina = this.stamina + this.regenStamina * dt
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
    -- Gestion des diagonales
    if (this.dx * this.dy) ~= 0 then
        this.dx = this.dx * 0.707
        this.dy = this.dy * 0.707
    end

    if this.stamina == 100 then
        if this.pv < this.pvMax then
            this.pv = this.pv + this.regenPv * dt
        end
    end

    jump(dt)
    move(dt)
    checkAction(dt)

    this.dx = this.dx * FRICTION
    this.dy = this.dy * FRICTION

    -- on marche sur un truc
    local itemsOver = ItemManager.getItemsAt(this.getCenter())
    for _, item in pairs(itemsOver) do
        if item ~= nil then
            item.walkOver(this)
        end
    end

    -- check récupération de toutes les pages
    if Inventory.getNombrePages() == MAX_PAGES then
        if not this.gridOpened then
            this.gridOpened = true
            Assets.snd_opengrid:play()
            GUI.addInfoBull("La grille est ouverte !")
        end
    end
end

this.drawFichePerso = function()
    local xpos = PIXELLARGE + 20 * SCALE
    local ypos = 80 * SCALE
    local img = love.graphics.newImage("images/bg_stats.png")
    love.graphics.draw(img, xpos - TILESIZE, ypos - 4)
    love.graphics.setFont(Font20)
    love.graphics.setColor(0, 0, 0, 1)
    local stats = {}
    table.insert(stats, {"VIE", Player.pvMax})
    table.insert(stats, {"ATK", Player.atk})
    table.insert(stats, {"DEF", Player.def})
    table.insert(stats, {"VIT", wile.display2decimale(Player.speedInit / 120 * 100) .. "%"})

    for i = 1, #stats do
        love.graphics.print(stats[i][1] .. " = " .. stats[i][2], xpos + TILESIZE, 22 + ypos + 22 * (i - 1))
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1)
    this.currentAnim.draw(self, this.x, this.y, this.flip)
end

return this
