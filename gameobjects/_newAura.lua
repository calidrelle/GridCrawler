-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraXXX = function(target, duration)
    local aura = AurasManager.create(target, duration)
    aura.name = "XXX"
    aura.initialValue = target.___ -- pour restaurer

    aura.start = function()
    end

    aura.apply = function()
        target.___ = 123456
    end

    aura.finish = function()
        target.___ = aura.initialValue -- restauration de la valeur originale
    end

    return aura
end
