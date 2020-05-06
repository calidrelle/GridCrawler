AurasManager = {}

local auras = {}

require("gameobjects.aura_poison")
require("gameobjects.aura_morsure")

AurasManager.create = function(target, duration)
    local this = {}
    this.duration = duration
    this.target = target

    table.insert(auras, this)
    return this
end

AurasManager.reset = function()
    table.removeAll(auras)
end

AurasManager.addAura = function(aura, duration, target)
    table.insert(target.auras, aura)
    if aura == "Poison" then
        AurasManager.newAuraPoison(target, duration).start()
    elseif aura == "Morsure" then
        AurasManager.newAuraMorsure(target, duration).start()
    else
        error("Aura inconnue de aurasManager : " .. aura)
    end
end

AurasManager.update = function(dt)
    for _, aura in pairs(auras) do
        aura.duration = aura.duration - dt
        aura.apply(dt)
    end
    for i = #auras, 1, -1 do
        local aura = auras[i]
        if aura.duration <= 0 then
            aura.finish()
            table.removeFromValue(aura.target.auras, aura.name)
            table.remove(auras, i)
        end
    end
end

AurasManager.draw = function()
    -- On affiche les auras du joueur
    local ypos = 0
    love.graphics.setFont(Font32)
    love.graphics.setColor(1, 1, 1, 1)
    for _, aura in pairs(auras) do
        if aura.target == Player then
            love.graphics.print(aura.name .. " (" .. math.ceil(aura.duration) .. ")", PIXELLARGE - 60 * SCALE, TILESIZE * SCALE + ypos * 32)
            ypos = ypos + 20
        end
    end
end

return AurasManager
