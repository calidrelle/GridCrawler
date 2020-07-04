Bravoure.NidDouillet = Bravoure.create("Nid douillet")
Bravoure.NidDouillet.description = "Finir le jeu sans s'être fait empaler"

Bravoure.NidDouillet.check = function()
  if Bravoure.NidDouillet.status == ACTE_NA then
    Bravoure.NidDouillet.achived()
  end
end
