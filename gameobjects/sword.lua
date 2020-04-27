-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSword = function(tileX, tileY, dx, dy)
    local item = ItemManager.create(Assets.weapon_sword, tileX, tileY)
    item.name = "sword"
    item.solid = false -- item collide with player/mob ?
    item.initStats(0, 0, Player.atk, 0) -- pv, atkRange, atk, def (player de base: pv = 10, atkRange = 20, atk = 2, def = 2)

    item.life = 0.8 -- durée de vie, donc distance
    item.speed = 200

    dx = dx or 0
    dy = dy or 0

    if dx > 0 then
        item.dx = 1
    elseif dx < 0 then
        item.dx = -1
    else
        item.dx = 0
    end

    if dy > 0 then
        item.dy = 1
    elseif dy < 0 then
        item.dy = -1
    else
        item.dy = 0
    end

    item.rotation = math.atan2(item.dy, item.dx) + math.pi / 4

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.getCenter = function()
        return item.x + item.width / 2, item.y + item.height / 2
    end

    item.update = function(dt)
        item.life = item.life - dt
        if item.life <= 0 then
            item.actif = false
        end

        item.x = item.x + item.dx * dt * item.speed
        item.y = item.y + item.dy * dt * item.speed

        local other = ItemManager.getItemAt(item.getCenter())
        if other ~= nil and other.name ~= "player" then
            if ItemManager.doAttack(item, other) then
                item.actif = false
            end
        end

        if Player.map.collideAt(self, item.getCenter()) then
            item.actif = false
        end
    end

    return item
end
