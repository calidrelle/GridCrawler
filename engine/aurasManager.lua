AurasManager = {}

local auras = {}

require("gameobjects.aura_poison")

AurasManager.create = function(target, duration)
    local this = {}
    this.duration = duration
    this.target = target

    table.insert(auras, this)
    return this
end

AurasManager.addAura = function(aura, target, duration)
    table.insert(target.auras, aura)
    if aura == "poison" then
        AurasManager.newAuraPoison(target, duration).start()
    else
        print("Aura inconnue : " .. aura)
    end
end

AurasManager.update = function(dt)
    for _, aura in pairs(auras) do
        aura.duration = aura.duration - dt
        aura.apply()
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

return AurasManager
