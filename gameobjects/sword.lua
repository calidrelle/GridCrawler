-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSword = function(tileX, tileY, dx, dy)
    local item = ItemManager.create(Assets.weapon_sword, tileX, tileY)
    item.name = "sword"
    item.solid = false -- item collide with player/mob ?

    item.life = 0.2 -- durée de vie, donc distance
    item.speed = 40

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

    item.update = function(dt)
        item.life = item.life - dt
        if item.life <= 0 then
            item.actif = false
        end

        item.x = item.x + item.dx * dt * item.speed
        item.y = item.y + item.dy * dt * item.speed

        local others = ItemManager.getItemsAt(item.getCenter())
        for _, other in pairs(others) do
            if other ~= nil and other.name ~= "player" then
                if ItemManager.doAttack(item, other) then
                    item.actif = false
                end
            end
        end

        if Map.collideAt(item.getCenter()) then
            item.actif = false
        end
    end

    return item
end
