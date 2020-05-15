Bravoure.Harpagon = Bravoure.create("Harpagon")
Bravoure.Harpagon.description = "Finir le jeu sans rien acheter"

Bravoure.Harpagon.check = function()
    if Bravoure.Harpagon.status == ACTE_NA then
        Bravoure.Harpagon.achived()
    end
end
