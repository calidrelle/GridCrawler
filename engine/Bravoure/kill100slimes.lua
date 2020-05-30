Bravoure.kill100slimes = Bravoure.create("Brian Flagg")
Bravoure.kill100slimes.description = "Tuer 100 slimes"
Bravoure.kill100slimes.countToReach = 100

Bravoure.kill100slimes.check = function()
    if Bravoure.kill100slimes.counter >= Bravoure.kill100slimes.countToReach then
        Bravoure.kill100slimes.achived()
    end
end
