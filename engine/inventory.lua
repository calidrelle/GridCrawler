Inventory = {}
local nbItems = 16
local items = {}

Inventory.getItems = function()
    return items
end

Inventory.init = function()
    for i = 1, nbItems do
        items[i] = {}
    end
end

Inventory.removePages = function()
    for i = 1, nbItems do
        if items[i].name ~= nil then
            if items[i].name:sub(1, 4) == "page" then
                items[i] = {}
            end
        end
    end
end

Inventory.getNombrePages = function()
    local count = 0
    for _, item in pairs(items) do
        if item.name ~= nil then
            if item.name:sub(1, 4) == "page" then
                count = count + 1
            end
        end
    end
    return count
end

Inventory.getPo = function()
    for _, item in pairs(items) do
        if item.name ~= nil then
            if item.name == "gold" then
                return item.count
            end
        end
    end
    return 0
end

Inventory.removePo = function(amount)
    for _, item in pairs(items) do
        if item.name ~= nil then
            if item.name == "gold" then
                if item.count >= amount then
                    item.count = item.count - amount
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end

local function lootSound(item)
    if item.name:sub(1, 4) == "page" then
        Assets.snd_lootpage:play()
    else
        Assets.snd_loot:play()
    end
end

Inventory.addItem = function(newItem, nombre)

    for i = 1, nbItems do
        if items[i].name == newItem.name then
            items[i].count = items[i].count + nombre
            lootSound(newItem)
            return
        end
    end
    -- pas trouvé, on le rajoute à la liste si on peut
    for i = 1, nbItems do
        if items[i].name == nil then
            items[i] = newItem
            items[i].count = nombre
            lootSound(newItem)
            return
        end
    end
    Assets.snd_error:play()
end

Inventory.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Font20)
    for y = 1, 4 do
        for x = 1, 4 do
            local i = (y - 1) * 4 + x
            local item = items[i]
            if item.name ~= nil then
                -- on rajoute la scale car on est en après le transform.pop
                Assets.draw(item.quad, PIXELLARGE + (x * TILESIZE) * SCALE, (y * TILESIZE) * SCALE, false, SCALE)
                love.graphics.print(item.count, PIXELLARGE + (x * TILESIZE) * SCALE, (y * TILESIZE) * SCALE)
            end
        end
    end
end

return Inventory
