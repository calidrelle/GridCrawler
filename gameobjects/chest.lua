-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newChest = function(tileX, tileY)
    local item = ItemManager.create(Assets.chest, tileX, tileY)
    item.name = "chest"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true
    item.displayPvLost = false
    table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.chest)))

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
