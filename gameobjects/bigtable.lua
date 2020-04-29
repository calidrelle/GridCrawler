-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newBigTable = function(tileX, tileY)
    local item = ItemManager.create(Assets.bigTable, tileX, tileY, TILESIZE * 2)
    item.name = "bigtable"
    item.solid = true -- item collide with player/mob ?

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
