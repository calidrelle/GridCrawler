ItemManager = {}

local items = {}
local lastX = 0
local lastY = 0

ItemManager.create = function(quad, tileX, tileY)
    local item = {}
    item.quad = quad
    item.x = tileX * TILESIZE
    item.y = tileY * TILESIZE

    item.hit = function()
        print("Je suis touché")
    end

    table.insert(items, item)
    return item
end

ItemManager.update = function(dt)
end

ItemManager.getItemAt = function(x, y)
    lastX = x
    lastY = y
    for _, item in pairs(items) do
        if item.x <= x and item.x + TILESIZE >= x and item.y <= y and item.y + TILESIZE > y then
            return item
        end
    end
    return nil
end

ItemManager.draw = function()
    for _, item in pairs(items) do
        Assets.draw(item.quad, item.x, item.y)
    end
end

return ItemManager
