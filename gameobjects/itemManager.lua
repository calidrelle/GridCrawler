ItemManager = {}

local items = {}

require("gameobjects.barrel")
require("gameobjects.gold")

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

ItemManager.draw = function()
    for _, item in pairs(items) do
        Assets.draw(item.quad, item.x, item.y)
    end
end

return ItemManager
