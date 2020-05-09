-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
AurasManager.newAuraSaignement = function(target, duration)
    local aura = AurasManager.create(target, duration, Assets.saignement)
    aura.name = "Saignement" -- Mettre une majuscule car texte affiché
    -- Saignement est un dot qui fait 0.8 de dégâts toutes les secondes pendant la durée
    aura.timer = 1
    aura.atk = 4
    aura.aurasToDeal = {} -- pas d'aura rajouté par cette aura, faut pas exagérer ^^

    aura.start = function()
    end

    aura.apply = function(dt)
        aura.timer = aura.timer - dt
        if aura.timer <= 0 then
            aura.timer = 1
            ItemManager.doAttack(aura, target)
        end
    end

    aura.finish = function()
    end

    return aura
end
