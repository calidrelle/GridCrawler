Bravoure.MonPrecieux = Bravoure.create("Mon précieux")
Bravoure.MonPrecieux.description = "Avoir ramasser toutes les pièces d'or du manoir"

Bravoure.MonPrecieux.check = function()
    if Bravoure.MonPrecieux.status == ACTE_NA then
        Bravoure.MonPrecieux.achived()
    end
end
