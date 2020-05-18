-- This file is a template
ItemManager.newGrid = function(tileX, tileY)
    local item = ItemManager.create(Assets.grid, tileX, tileY)
    if ItemManager.gridNumber == nil then
        ItemManager.gridNumber = 1
    else
        ItemManager.gridNumber = ItemManager.gridNumber + 1
    end
    item.name = "grid"
    item.solid = false

    item.gridNumber = ItemManager.gridNumber
    if item.gridNumber == 1 then
        item.gridToLevel = 4
    elseif item.gridNumber == 2 then
        item.gridToLevel = 7
    elseif item.gridNumber == 3 then
        item.gridToLevel = "du BOSS"
    end

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if Player.hasKey(item.gridNumber) then
            GUI.addInfoBull("Cette grille mène à l'étage " .. item.gridToLevel .. ".\nValider pour y descendre.", 3)
        end
    end

    item.update = function(dt)
        if Player.hasKey(item.gridNumber) then
            item.quad = Assets.downstairs
        end
    end

    return item
end
