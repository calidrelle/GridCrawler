AurasManager = {}

local auras = {}

require("gameobjects.aura_poison")
require("gameobjects.aura_morsure")
require("gameobjects.aura_saignement")

AurasManager.create = function(target, duration, icon)
    local this = {}
    this.duration = duration
    this.target = target
    this.icon = icon

    table.insert(auras, this)
    return this
end

AurasManager.reset = function()
    table.removeAll(auras)
end

AurasManager.addAura = function(aura, duration, target)
    -- On rajoute une aura si on ne l'a pas déjà, sinon, on initialise sa duréerror
    if table.contains(target.auras, aura) then
        for _, a in pairs(auras) do
            if a.name == aura then
                a.duration = duration
            end
        end
    else
        table.insert(target.auras, aura)
        if aura == "Poison" then
            AurasManager.newAuraPoison(target, duration).start()
            Bravoure.Vaccine.lost()
        elseif aura == "Morsure" then
            AurasManager.newAuraMorsure(target, duration).start()
            Bravoure.GousseDAil.lost()
        elseif aura == "Saignement" then
            AurasManager.newAuraSaignement(target, duration).start()
            Bravoure.Sparadrap.lost()
        else
            error("Aura inconnue de aurasManager : " .. aura)
        end
        if #target.auras == 3 then
            Bravoure.Martyr.achived()
        end
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
    local xpos = PIXELLARGE + 20 * SCALE
    local ypos = 80 * SCALE
    love.graphics.setFont(Font20)
    love.graphics.setColor(1, 1, 1, 1)
    for _, aura in pairs(auras) do
        if aura.target == Player then
            Assets.draw(aura.icon, xpos, ypos - 5, false, SCALE - 1)
            love.graphics.print(aura.name .. " (" .. wile.display1decimale(aura.duration) .. ")", xpos + TILESIZE * 2, ypos)
            ypos = ypos + 24
        end
    end
end

return AurasManager
