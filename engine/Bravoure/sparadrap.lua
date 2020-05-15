Bravoure.Sparadrap = Bravoure.create("Sparadrap")
Bravoure.Sparadrap.description = "Finir le jeu sans avoir saigné"

Bravoure.Sparadrap.check = function()
    if Bravoure.Sparadrap.status == ACTE_NA then
        Bravoure.Sparadrap.achived()
    end
end
