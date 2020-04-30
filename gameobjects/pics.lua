-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newPics = function(tileX, tileY)
    local item = ItemManager.create(Assets.pics, tileX, tileY)
    item.name = "pics"
    item.solid = false
    item.initStats(0, 10)
    item.animRun = require("engine.animation").createNew(Assets.pics, 8, 0.01, false)
    item.currentAnim = nil
    item.timer = 0

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other == Player then
            item.currentAnim = item.animRun
            if item.timer == 0 then
                Assets.snd_pics:play()
                item.timer = 2
                if Player.jumpingTimer == 0 then
                    ItemManager.doAttack(item, Player)
                end
            end
        end
    end

    item.update = function(dt)
        if item.currentAnim ~= nil then
            item.currentAnim:update(dt)
            item.timer = item.timer - dt
            if item.timer <= 0 then
                item.timer = 0
                item.currentAnim.reset()
                item.currentAnim = nil
            end
        end
    end

    return item
end
