ItemManager = {}

local items = {}

require("gameobjects.barrel")
require("gameobjects.gold")
require("gameobjects.exitGrid")
require("gameobjects.page")
require("gameobjects.sword")

-- mobs
require("gameobjects.slim")

ItemManager.create = function(quad, x, y)
    local item = {}
    item.quad = quad
    item.x = x
    item.y = y
    item.width = TILESIZE
    item.height = TILESIZE
    item.solid = false
    item.actif = true

    item.initStats = function(pv, atkRange, atk, def)
        item.pv = pv
        item.pvMax = pv
        item.atkRange = atkRange
        item.atk = atk
        item.def = def
    end

    table.insert(items, item)
    return item
end

ItemManager.reset = function()
    items = {}
end

ItemManager.update = function(dt)
    for _, item in pairs(items) do
        item.update(dt)
    end
    for i = #items, 1, -1 do
        if items[i].actif == false then
            table.remove(items, i)
        end
    end
end

ItemManager.getItemAt = function(x, y)
    for _, item in pairs(items) do
        if item.x <= x and item.x + TILESIZE >= x and item.y <= y and item.y + TILESIZE > y then
            return item
        end
    end
    return nil
end

ItemManager.isItemAt = function(x, y)
    local item = ItemManager.getItemAt(x, y)
    if item == nil then
        return false
    else
        return item.solid == true
    end
end

ItemManager.getItems = function()
    return items
end

ItemManager.draw = function()
    for _, item in pairs(items) do
        -- si l'item à une animation, on l'affiche, sinon, on affiche le quad de base
        love.graphics.setColor(1, 1, 1)
        if item.currentAnim ~= nil then
            item.currentAnim.draw(item, item.x, item.y, item.flip)
        else
            -- scale = 1 car on est sur l'écran, donc le zoom est géré globalement
            Assets.draw(item.quad, item.x, item.y, item.flip, 1, item.rotation)
        end
        -- si l'item à des PV, on les affiche
        if item.pv > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", item.x, item.y, TILESIZE * item.pv / item.pvMax, 3) -- La barre de vie à la taille d'une tile
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", item.x, item.y, TILESIZE, 3) -- La barre de vie à la taille d'une tile
        end
        if INFODEBUG then
            if item.loot ~= nil then
                love.graphics.print(item.loot, item.x, item.y)
            end
            -- love.graphics.rectangle("line", item.x, item.y, 2, 2)
        end
    end
end

ItemManager.doAttack = function(fighter, target)
    if target.name == "exit" or target.name == "sword" or target.name == "gold" or target.name:sub(1, 4) == "page" then
        return false
    end

    local damage = math.random(fighter.atk) - target.def
    if damage > 0 then
        print(fighter.name .. " hit " .. target.name .. " and deals " .. damage .. " damages")
        target.pv = target.pv - damage
        if target.pv > 0 then
            Assets.snd_hurt:play()
        end
    else
        print(fighter.name .. " missed")
    end

    if target.pv <= 0 then
        target.actif = false
        Assets.snd_dead:play()

        if target.loot == nil then
            ItemManager.newGold(target.x, target.y)
        else
            if string.sub(target.loot, 1, 4) == "page" then
                ItemManager.newPage(target.x, target.y, string.sub(target.loot, 5) + 0)
            end
        end
    end
    return true
end

return ItemManager
