Bravoure.Clef1 = Bravoure.create("Clef niveau 4")
Bravoure.Clef1.description = "Vous avez maintenant la clef du niveau 4 pour y entrer directement depuis le magasin."
Bravoure.Clef1.toSave = false

Bravoure.Clef1.check = function()
    if not Player.hasKey(1) then
        Bravoure.Clef1.achived()
    end
end
