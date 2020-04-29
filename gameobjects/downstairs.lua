-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newDownstairs = function(tileX, tileY)
    local item = ItemManager.create(Assets.downstairs, tileX, tileY)
    item.name = "downstaires"
    item.solid = false -- item collide with player/mob ?

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
