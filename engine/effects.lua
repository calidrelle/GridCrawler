Effects = {}

local effects

Effects.init = function()
    effects = {}
end

local createNewEffect = function(x, y, duree)
    local this = {}
    this.active = true
    this.x = x
    this.y = y
    this.duree = duree
    this.dureeInit = duree
    this.alpha = 1

    table.insert(effects, this)
    return this
end

Effects.update = function(dt)
    for _, e in pairs(effects) do
        e.update(dt)
        e.duree = e.duree - dt
        if e.duree <= 0 then
            e.active = false
        end
    end
    for i = #effects, 1, -1 do
        if not effects[i].active then
            table.remove(effects, i)
        end
    end
end

Effects.preRender = function()
    for _, effect in pairs(effects) do
        effect.preRender()
    end
end

Effects.draw = function()
    for _, effect in pairs(effects) do
        effect.draw()
    end
end

-------------------------- EFFECTS--------------------------------

Effects.createFloatingText = function(text, x, y, duree, r, g, b)
    local this = createNewEffect(x, y, duree)
    this.text = text
    this.r = r
    this.g = g
    this.b = b
    this.dx = math.random(-20, 20) / 10
    this.dy = -5

    this.update = function(dt)
        this.x = this.x + this.dx * dt * 20
        this.y = this.y + this.dy * dt * 20
        this.dy = this.dy + dt * 12
        this.alpha = this.duree / this.dureeInit
    end

    this.preRender = function()
    end

    this.draw = function()
        love.graphics.setFont(Font8)
        love.graphics.setColor(this.r, this.g, this.b, this.alpha)
        love.graphics.print(this.text, this.x, this.y)
    end

    return this
end

Effects.createCamShake = function(duree, amplitude)
    local this = createNewEffect(0, 0, duree)
    this.amplitude = amplitude

    this.update = function(dt)
        local angle = math.random() * math.pi * 2
        this.x = this.amplitude * math.cos(angle)
        this.y = this.amplitude * math.sin(angle)
    end

    this.preRender = function()
        love.graphics.translate(this.x, this.y)
    end

    this.draw = function()
    end

    return this
end

Effects.createLootItemEffect = function(item)
    local this = createNewEffect(item.x, item.y, 1)
    this.image = Assets.page[item.numPage]

    this.update = function(dt)
        this.y = this.y - 40 * dt
        this.alpha = this.duree / this.dureeInit
    end

    this.preRender = function()
    end

    this.draw = function()
        love.graphics.setColor(1, 1, 1, this.alpha)
        Assets.draw(this.image, this.x, this.y)
    end

    return this
end

return Effects
