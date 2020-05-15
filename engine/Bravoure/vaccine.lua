Bravoure.Vaccine = Bravoure.create("Vacciné")
Bravoure.Vaccine.description = "Finir le jeu sans se faire empoisonner"

Bravoure.Vaccine.check = function()
    if Bravoure.Vaccine.status == ACTE_NA then
        Bravoure.Vaccine.achived()
    end
end
