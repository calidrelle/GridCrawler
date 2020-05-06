-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraMorsure = function(target, duration)
    local aura = AurasManager.create(target, duration)
    aura.name = "Morsure"
    aura.initialValue = target.regenPv -- 0.5 pour le player pour restaurer

    aura.start = function()
    end

    aura.apply = function(dt)
        target.regenPv = 0.1
    end

    aura.finish = function()
        target.regenPv = aura.initialValue -- restauration de la valeur originale
    end

    return aura
end