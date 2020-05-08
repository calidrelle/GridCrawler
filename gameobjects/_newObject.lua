-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newXXX = function(tileX, tileY)
    local item = ItemManager.create(Assets.___, tileX, tileY)
    item.name = "XXX"
    item.solid = false -- item collide with player/mob ?
    item.canBeAttacked = false -- peut-on taper dessus
    item.canDropPage = false
    item.displayPvLost = true
    item.initStats(0, 0, 0, 0, 0, 0) -- pv, atk, atkRange, detectRange, speed, atkSpeed
    item.auras = {}

    item.hit = function(other)
    end

    item.addPo = function()
        table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.___)))
    end

    item.walkOver = function(other)
        if other == Player then -- qui marche dessus ?
        else
        end
    end

    item.update = function(dt)
    end

    return item
end
