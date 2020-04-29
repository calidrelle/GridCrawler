-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newVendor = function(tileX, tileY)
    local item = ItemManager.create(Assets.vendor, tileX, tileY)
    item.name = "vendor"
    item.solid = true -- item collide with player/mob ?
    item.animIdle = require("engine.animation").createNew(Assets.vendor_idle_anim, 4, 0.25, true)
    item.currentAnim = item.animIdle

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.currentAnim:update(dt)
    end

    return item
end
