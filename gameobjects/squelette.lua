-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSquelette = function(tileX, tileY, level)
    local item = ItemManager.create(Assets.squelette_run_anim, tileX, tileY)
    item.name = "squelette"
    item.solid = true -- item collide with player/mob ?
    item.canBeAttacked = true
    item.canDropPage = true

    item.level = level
    item.initMobStats(DATA.squelette)
    item.animRun = require("engine.animation").createNew(Assets.squelette_run_anim, 4, 0.15, true)
    item.currentAnim = item.animRun

    item.hit = function(other)
    end

    item.addPo = function()
        table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.squelette)))
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.updateState(dt)
        item.currentAnim:update(dt)
    end

    item.aggroSound = function()
        Assets.snd_aggro_squlette:play()
    end

    return item
end
