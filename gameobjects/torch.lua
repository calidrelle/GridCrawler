-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newTorch = function(tileX, tileY)
    local item = ItemManager.create(Assets.torch, tileX, tileY)
    item.name = "torch"
    item.solid = false
    item.animIdle = require("engine.animation").createNew(Assets.torch, 6, 0.1, true)
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
