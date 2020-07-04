Bravoure.GrandArgentier = Bravoure.create("Grand Argentier")
Bravoure.GrandArgentier.description = "Avoir ramassé plus de 1400 pièces d'or"
Bravoure.GrandArgentier.countToReach = 1400

Bravoure.GrandArgentier.check = function()
  if Bravoure.GrandArgentier.counter >= Bravoure.GrandArgentier.countToReach then
    Bravoure.GrandArgentier.achived()
  end
end
