Bravoure.kill100squelettes = Bravoure.create("Skeletor")
Bravoure.kill100squelettes.description = "Tuer 100 squelettes"
Bravoure.kill100squelettes.countToReach = 100

Bravoure.kill100squelettes.check = function()
    if Bravoure.kill100squelettes.counter >= Bravoure.kill100squelettes.countToReach then
        Bravoure.kill100squelettes.achived()
    end
end
