-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newPage = function(tileX, tileY, num)
    local item = ItemManager.create(Assets.page[num], tileX, tileY)
    item.name = "page" .. num
    item.numPage = num
    item.solid = false -- item collide with player/mob ?

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other == Player then
            Effects.createLootItemEffect(item)
            Inventory.addItem(item, 1)
            item.actif = false
        end
    end

    item.update = function(dt)
    end

    return item
end
