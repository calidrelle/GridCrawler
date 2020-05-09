Bravoure.Savonnette = Bravoure.create("Savonnette")
Bravoure.Savonnette.description = "Finir un niveau sans se faire toucher"

Bravoure.Savonnette.check = function()
    -- Si à la fin d'un niveau, on n'a pas été touché, c'est gagné
    if Bravoure.Savonnette.status == ACTE_NA then
        Bravoure.Savonnette.achived()
    end
end
