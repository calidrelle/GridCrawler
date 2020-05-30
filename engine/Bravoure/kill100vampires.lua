Bravoure.kill100vampires = Bravoure.create("Buffy")
Bravoure.kill100vampires.description = "Tuer 100 vampires"
Bravoure.kill100vampires.countToReach = 100

Bravoure.kill100vampires.check = function()
    if Bravoure.kill100vampires.counter >= Bravoure.kill100vampires.countToReach then
        Bravoure.kill100vampires.achived()
    end
end
