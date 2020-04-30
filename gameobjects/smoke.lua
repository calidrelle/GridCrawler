-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSmoke = function(tileX, tileY)
    local item = ItemManager.create(Assets.smoke, tileX, tileY)
    item.name = "smoke"
    item.solid = false
    item.canBeAttacked = false
    item.canDropPage = false
    item.animRun = require("engine.animation").createNew(Assets.smoke, 4, 0.25, false)
    item.currentAnim = item.animRun

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.currentAnim:update(dt)
        item.actif = item.currentAnim.isPlaying
    end

    return item
end
