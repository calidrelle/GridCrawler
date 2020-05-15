Bravoure.Paladin = Bravoure.create("Paladin")
Bravoure.Paladin.description = "Finir le jeu en mode difficile"

Bravoure.Paladin.check = function()
    if Bravoure.Paladin.status == ACTE_NA then
        Bravoure.Paladin.achived()
    end
end
