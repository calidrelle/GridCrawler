-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newZombie = function(tileX, tileY, level)
    local item = ItemManager.create(Assets.zombie_idle_anim, tileX, tileY)
    item.name = "zombie"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true
    table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.zombie)))

    item.level = level
    item.initMobStats(DATA.zombie)
    item.animIdle = require("engine.animation").createNew(Assets.zombie_idle_anim, 4, 0.18, true)
    item.animRun = require("engine.animation").createNew(Assets.zombie_run_anim, 4, 0.18, true)
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

    item.aggroSound = function()
        Assets.snd_aggro_zombie:play()
    end

    return item
end
