Bravoure.Sparadrap = Bravoure.create("Sparadrap")
Bravoure.Sparadrap.description = "Finir le jeu sans avoir saigné"

Bravoure.Sparadrap.check = function()
    -- Si à la fin du jeu, rien n'a été acheté, c'est gagné
    if Bravoure.Sparadrap.status == ACTE_NA then
        Bravoure.Sparadrap.achived()
    end
end
