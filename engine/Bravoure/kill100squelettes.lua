Bravoure.kill100squlettes = Bravoure.create("Skeletor")
Bravoure.kill100squlettes.description = "Tuer 100 squelettes"

Bravoure.kill100squlettes.check = function()
    if Bravoure.kill100squlettes.counter == 100 then
        Bravoure.kill100squlettes.achived()
    end
end
