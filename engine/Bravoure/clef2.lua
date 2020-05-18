Bravoure.Clef2 = Bravoure.create("Clef niveau 7")
Bravoure.Clef2.description = "Vous avez maintenant la clef du niveau 7 pour y entrer directement depuis le magasin."
Bravoure.Clef2.toSave = false

Bravoure.Clef2.check = function()
    if not Player.hasKey(2) then
        Bravoure.Clef2.achived()
    end
end
