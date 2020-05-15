-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newGoblin = function(tileX, tileY, level)
    local item = ItemManager.create(Assets.goblin_idle_anim, tileX, tileY)
    item.name = "goblin"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true

    item.level = level
    item.initMobStats(DATA.goblin)
    item.animIdle = require("engine.animation").createNew(Assets.goblin_idle_anim, 6, 0.1, true)
    item.animRun = require("engine.animation").createNew(Assets.goblin_run_anim, 6, 0.1, true)
    item.currentAnim = item.animIdle

    item.addPo = function()
        table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.goblin)))
    end

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
        Assets.snd_aggro_goblin:play()
    end

    item.onDie = function()
        Bravoure.kill100goblins.increment()
    end

    return item
end
