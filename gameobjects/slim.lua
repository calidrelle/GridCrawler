-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSlim = function(tileX, tileY)
    local item = ItemManager.create(Assets.slime_idle_anim, tileX, tileY)
    item.name = "slim"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true
    table.insert(item.lootTable, ItemManager.newGold(-1, -1, math.random(1, 5)))

    item.initMobStats(DATA.slim)
    item.animIdle = require("engine.animation").createNew(Assets.slime_idle_anim, 6, 0.1, true)
    item.animRun = require("engine.animation").createNew(Assets.slime_run_anim, 6, 0.1, true)
    item.currentAnim = item.animIdle

    item.hit = function(other)
        ItemManager.doAttack(other, item)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.updateState(dt)
        item.currentAnim:update(dt)
    end

    return item
end
