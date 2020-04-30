-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newXXX = function(tileX, tileY)
    local item = ItemManager.create(Assets.___, tileX, tileY)
    item.name = "XXX"
    item.solid = false -- item collide with player/mob ?
    item.canBeAttacked = false -- peut-on taper dessus
    item.initStats(0, 0, 0, 0) -- pv, atkRange, atk, def (player de base: pv = 10, atkRange = 20, atk = 2, def = 2)

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
