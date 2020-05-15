Bravoure.Savonnette = Bravoure.create("Savonnette")
Bravoure.Savonnette.description = "Finir un niveau sans se faire toucher"

Bravoure.Savonnette.check = function()
    if Bravoure.Savonnette.status == ACTE_NA then
        Bravoure.Savonnette.achived()
    end
end
