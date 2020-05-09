Bravoure.Chevalier = Bravoure.create("Chevalier")
Bravoure.Chevalier.description = "Finir le jeu en mode normal"

Bravoure.Chevalier.check = function()
    -- Si à la fin du jeu, rien n'a été acheté, c'est gagné
    if Bravoure.Chevalier.status == ACTE_NA then
        Bravoure.Chevalier.achived()
    end
end
