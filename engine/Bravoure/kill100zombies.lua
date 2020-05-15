Bravoure.kill100zombies = Bravoure.create("Abraham")
Bravoure.kill100zombies.description = "Tuer 100 zombies"

Bravoure.kill100zombies.check = function()
    if Bravoure.kill100zombies.counter == 2 then
        Bravoure.kill100zombies.achived()
    end
end
