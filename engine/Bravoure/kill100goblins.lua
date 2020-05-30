Bravoure.kill100goblins = Bravoure.create("GobuSure")
Bravoure.kill100goblins.description = "Tuer 100 gobelins"
Bravoure.kill100goblins.countToReach = 100

Bravoure.kill100goblins.check = function()
    if Bravoure.kill100goblins.counter >= Bravoure.kill100goblins.countToReach then
        Bravoure.kill100goblins.achived()
    end
end
