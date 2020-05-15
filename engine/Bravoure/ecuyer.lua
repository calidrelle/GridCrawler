Bravoure.Ecuyer = Bravoure.create("Ecuyer")
Bravoure.Ecuyer.description = "Finir le jeu en mode facile"

Bravoure.Ecuyer.check = function()
    if Bravoure.Ecuyer.status == ACTE_NA then
        Bravoure.Ecuyer.achived()
    end
end
