Bravoure.Legolas = Bravoure.create("Legolas")
Bravoure.Legolas.description = "Finir le jeu sans se faire toucher"

Bravoure.Legolas.check = function()
    if Bravoure.Legolas.status == ACTE_NA then
        Bravoure.Legolas.achived()
    end
end
