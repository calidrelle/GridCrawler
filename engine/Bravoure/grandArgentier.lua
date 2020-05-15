Bravoure.GrandArgentier = Bravoure.create("Grand Argentier")
Bravoure.GrandArgentier.description = "Avoir ramasser plus de 1400 pièces d'or"

Bravoure.GrandArgentier.check = function()
    if Bravoure.GrandArgentier.counter >= 1400 then
        Bravoure.GrandArgentier.achived()
    end
end
