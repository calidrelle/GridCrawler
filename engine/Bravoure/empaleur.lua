Bravoure.Empaleur = Bravoure.create("Empaleur")
Bravoure.Empaleur.description = "Réussir à tuer 15 monstres par empalement"
Bravoure.Empaleur.countToReach = 15

-- Bravoure.Empaleur.counter = 0
-- Bravoure.Empaleur.increment = function()
--     Bravoure.Empaleur.counter = Bravoure.Empaleur.counter + 1
--     Bravoure.Empaleur.check()
-- end

Bravoure.Empaleur.check = function()
    if Bravoure.Empaleur.status == ACTE_NA and Bravoure.Empaleur.counter >= Bravoure.Empaleur.countToReach then
        Bravoure.Empaleur.achived()
    end
end
