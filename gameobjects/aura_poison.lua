-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraPoison = function(target, duration)
    local aura = AurasManager.create(target, duration)
    aura.name = "Poison"

    aura.start = function()
    end

    aura.apply = function(dt)
        target.regenStamina = 2
    end

    aura.finish = function()
        target.regenStamina = 25
    end

    return aura
end
