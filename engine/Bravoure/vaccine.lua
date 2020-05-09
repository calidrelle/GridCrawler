Bravoure.Vaccine = Bravoure.create("Vacciné")
Bravoure.Vaccine.description = "Finir le jeu sans se faire empoisonner"

Bravoure.Vaccine.check = function()
    -- Si à la fin du jeu, rien n'a été acheté, c'est gagné
    if Bravoure.Vaccine.status == ACTE_NA then
        Bravoure.Vaccine.achived()
    end
end
