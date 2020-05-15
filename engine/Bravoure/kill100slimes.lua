Bravoure.kill100slimes = Bravoure.create("Brian Flagg")
Bravoure.kill100slimes.description = "Tuer 100 slimes"

Bravoure.kill100slimes.check = function()
    if Bravoure.kill100slimes.counter == 100 then
        Bravoure.kill100slimes.achived()
    end
end
