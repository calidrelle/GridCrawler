Bravoure.Harpagon = Bravoure.create("Harpagon")
Bravoure.Harpagon.description = "Finir le jeu sans rien acheter"

Bravoure.Harpagon.check = function()
    -- Si à la fin du jeu, rien n'a été acheté, c'est gagné
    if Bravoure.Harpagon.status == ACTE_NA then
        Bravoure.Harpagon.achived()
    end
end
