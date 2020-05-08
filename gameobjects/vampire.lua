-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newVampire = function(tileX, tileY, level)
    local item = ItemManager.create(Assets.vampire_idle_anim, tileX, tileY)
    item.name = "vampire"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true

    item.level = level
    item.initMobStats(DATA.vampire)
    item.animIdle = require("engine.animation").createNew(Assets.vampire_idle_anim, 4, 0.18, true)
    item.animRun = require("engine.animation").createNew(Assets.vampire_run_anim, 4, 0.18, true)
    item.currentAnim = item.animIdle

    item.addPo = function()
        table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.vampire)))
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
        Assets.snd_aggro_vampire:play()
    end

    return item
end
