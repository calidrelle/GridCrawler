Bravoure.Legolas = Bravoure.create("Legolas")
Bravoure.Legolas.description = "Finir le jeu sans se faire toucher"

Bravoure.Legolas.check = function()
    -- Si à la fin d'un niveau, on n'a pas été touché, c'est gagné
    if Bravoure.Legolas.status == ACTE_NA then
        Bravoure.Legolas.achived()
    end
end
