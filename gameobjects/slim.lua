-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSlim = function(tileX, tileY)
    local item = ItemManager.create(Assets.slime_idle_anim, tileX, tileY)
    item.name = "slim"
    item.solid = true -- item collide with player/mob ?
    item.initStats(5, 20, 2, 1) -- pv, atkRange, atk, def (player de base: pv = 10, atkRange = 20, atk = 2, def = 2
    item.animIdle = require("engine.animation").createNew(Assets.slime_idle_anim, 6, 0.1)
    item.animRun = require("engine.animation").createNew(Assets.slime_run_anim, 6, 0.1)
    item.currentAnim = item.animIdle

    item.hit = function(other)
        ItemManager.doAttack(other, item)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.currentAnim:update(dt)
    end

    return item
end
