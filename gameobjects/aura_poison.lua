-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraPoison = function(target, duration)
    local aura = AurasManager.create(target, duration)
    aura.name = "poison"
    aura.initialValue = target.regenStamina

    aura.start = function()
    end

    aura.apply = function()
        target.regenStamina = 0
    end

    aura.finish = function()
        target.regenStamina = aura.initialValue
    end

    return aura
end
