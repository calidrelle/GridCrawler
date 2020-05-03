-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraXXX = function(target, duration)
    local aura = AurasManager.create(target, duration)
    aura.name = "XXX"

    aura.start = function()
    end

    aura.apply = function()
    end

    aura.finish = function()
    end

    return aura
end
