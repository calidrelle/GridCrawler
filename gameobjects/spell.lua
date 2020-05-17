-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newSpell = function(tileX, tileY, angle)
    local rnd = math.random(3)
    local spell

    if angle == nil then
        spell = Assets.saignement
    else
        if rnd == 1 then
            spell = Assets.morsure
        elseif rnd == 2 then
            spell = Assets.poison
        else
            spell = Assets.saignement
        end
    end

    local item = ItemManager.create(spell, tileX, tileY)
    item.name = "spell"
    item.solid = false -- item collide with player/mob ?
    item.canBeAttacked = false -- peut-on taper dessus
    item.canDropPage = false
    item.displayPvLost = true

    item.initStats(0, 1, 0, 0, 0, 0) -- pv, atk, atkRange, detectRange, speed, atkSpeed

    if spell == Assets.morsure then
        item.aurasToDeal = {{"Morsure", 4}}
    elseif spell == Assets.poison then
        item.aurasToDeal = {{"Poison", 4}}
    elseif spell == Assets.saignement then
        item.aurasToDeal = {{"Saignement", 4}}
    end

    if angle ~= nil then
        item.dx = math.cos(angle)
        item.dy = math.sin(angle)
        item.speed = 50 -- math.random(20, 50)
        item.life = 5
    else
        item.life = 0.3
    end

    item.hit = function(other)
    end

    item.addPo = function()
    end

    item.walkOver = function(other)
        if other == Player then -- qui marche dessus ?
            ItemManager.doAttack(item, other)
            item.actif = false
        else
        end
    end

    item.update = function(dt)
        item.life = item.life - dt

        if item.life <= 0 then
            item.actif = false
        end
    end

    return item
end
