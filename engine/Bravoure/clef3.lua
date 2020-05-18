Bravoure.Clef3 = Bravoure.create("Clef niveau Boss")
Bravoure.Clef3.description = "Vous avez maintenant la clef du Boss pour y entrer directement depuis le magasin."
Bravoure.Clef3.toSave = false

Bravoure.Clef3.check = function()
    if not Player.hasKey(3) then
        Bravoure.Clef3.achived()
    end
end
