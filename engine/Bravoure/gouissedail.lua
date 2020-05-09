Bravoure.GousseDAil = Bravoure.create("Gousse d'ail")
Bravoure.GousseDAil.description = "Finir le jeu sans se faire mordre"

Bravoure.GousseDAil.check = function()
    -- Si à la fin du jeu, rien n'a été acheté, c'est gagné
    if Bravoure.GousseDAil.status == ACTE_NA then
        Bravoure.GousseDAil.achived()
    end
end
