-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newBoss = function(tileX, tileY)
    local item = ItemManager.create(Assets.boss, tileX, tileY, 32, 32)
    item.name = "boss"
    item.solid = true -- item collide with player/mob ?
    item.canBeAttacked = true
    item.canDropPage = true -- il possède les 8 pages !

    item.level = 1
    item.initMobStats(DATA.boss)
    item.animRun = require("engine.animation").createNew(Assets.boss, 8, 0.075, true)
    item.currentAnim = item.animRun

    item.hit = function(other)
    end

    item.addPo = function()
        -- table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.___)))
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
        item.updateState(dt)
        item.currentAnim:update(dt)
    end

    return item
end
