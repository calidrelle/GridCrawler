Inventory = {}
local nbItems = 16
local items = {}
local po = 0

Inventory.getItems = function()
    return items
end

Inventory.init = function()
    po = 0
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
    return po
end

Inventory.removePo = function(amount)
    if po >= amount then
        po = po - amount
        Assets.snd_pay:play()
        return true
    else
        Assets.snd_error:play()
        return false
    end
end

local function lootSound(item)
    if item.name:sub(1, 4) == "page" then
        Assets.snd_lootpage:play()
    else
        Assets.snd_loot:play()
    end
end

Inventory.addItem = function(newItem, nombre)
    if newItem.name == "gold" then
        po = po + nombre
        Assets.snd_loot:play()
        return
    end

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
                Assets.draw(item.quad, 2 + PIXELLARGE + (x * TILESIZE) * SCALE,
                            2 + HEIGHT - (Assets.gui_bottom:getHeight() * SCALE) + ((y - 1) * TILESIZE) * SCALE, false, SCALE)
                if item.count > 1 then
                    love.graphics.print(item.count, 2 + PIXELLARGE + (x * TILESIZE) * SCALE,
                                        2 + HEIGHT - (Assets.gui_bottom:getHeight() * SCALE) + ((y - 1) * TILESIZE) * SCALE)
                end
            end
        end
    end
    love.graphics.setColor(0.867, 0.835, 0.251)
    love.graphics.print("GOLD:" .. po, 2 + PIXELLARGE + TILESIZE * SCALE, HEIGHT - TILESIZE * SCALE)
end

return Inventory
