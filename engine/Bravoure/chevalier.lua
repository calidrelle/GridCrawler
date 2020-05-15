Bravoure.Chevalier = Bravoure.create("Chevalier")
Bravoure.Chevalier.description = "Finir le jeu en mode normal"

Bravoure.Chevalier.check = function()
    if Bravoure.Chevalier.status == ACTE_NA then
        Bravoure.Chevalier.achived()
    end
end
