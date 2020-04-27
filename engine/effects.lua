Effects = {}

local effects

Effects.init = function()
    print("Initialisation du moteur d'effets")
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
        e.alpha = e.duree / e.dureeInit
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

Effects.draw = function()
    for _, effect in pairs(effects) do
        effect.draw()
    end
end

Effects.createFloatingText = function(text, x, y, duree, r, g, b)
    local this = createNewEffect(x, y, duree)
    this.text = text
    this.r = r
    this.g = g
    this.b = b
    this.dx = math.random(-2, 2)
    this.dy = -5

    this.update = function(dt)
        this.x = this.x + this.dx * dt * 20
        this.y = this.y + this.dy * dt * 20
        this.dy = this.dy + dt * 20
    end

    this.draw = function()
        love.graphics.setFont(Font8)
        love.graphics.setColor(this.r, this.g, this.b, this.alpha)
        love.graphics.print(this.text, this.x, this.y)
    end

    return this
end

return Effects
