-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraXXX = function(target, duration)
    local aura = AurasManager.create(target, duration, Assets.___)
    aura.name = "Xxxx" -- Mettre une majuscule car texte affiché
    aura.initialValue = target.___ -- pour restaurer

    aura.start = function()
    end

    aura.apply = function(dt)
        target.___ = 123456
    end

    aura.finish = function()
        target.___ = aura.initialValue -- restauration de la valeur originale
    end

    return aura
end
