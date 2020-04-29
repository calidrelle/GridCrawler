-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newTable = function(tileX, tileY)
    local item = ItemManager.create(Assets.table, tileX, tileY)
    item.name = "table"
    item.solid = true -- item collide with player/mob ?

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.onMouseOver = function()
    end

    item.update = function(dt)
    end

    return item
end
