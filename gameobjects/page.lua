-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newPage = function(tileX, tileY, num)
    local item = ItemManager.create(Assets.page[num], tileX, tileY)
    item.name = "page" .. num
    item.numPage = num
    item.solid = false -- item collide with player/mob ?
    -- item.initStats(0, 0, 0, 0) -- pv, atkRange, atk, def (player de base: pv = 10, atkRange = 20, atk = 2, def = 2)

    item.hit = function(other)
    end

    item.walkOver = function(other)
        Effects.createLootItemEffect(item)
        Inventory.addItem(item, 1)
        other.addMessage("Vous ramassez la page " .. item.numPage, 4)
        item.actif = false
    end

    item.update = function(dt)
    end

    return item
end
