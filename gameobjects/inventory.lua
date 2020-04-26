Inventory = {}
local nbItems = 16
local items = {}

Inventory.init = function()
    for i = 1, nbItems do
        items[i] = {}
    end
end

Inventory.addItem = function(newItem, nombre)
    for i = 1, nbItems do
        if items[i].name == newItem.name then
            items[i].count = items[i].count + nombre
            Assets.snd_loot:play()
            return
        end
    end
    -- pas trouvé, on le rajoute à la liste si on peut
    for i = 1, nbItems do
        if items[i].name == nil then
            items[i] = newItem
            items[i].count = nombre
            Assets.snd_loot:play()
            return
        end
    end
    Assets.snd_error:play()
end

Inventory.draw = function()
    for y = 1, 4 do
        for x = 1, 4 do
            local i = (y - 1) * 4 + x
            local item = items[i]
            if item.name ~= nil then
                Assets.draw(item.quad, PIXELLARGE + (x * TILESIZE) * SCALE, (y * TILESIZE) * SCALE, false, SCALE)
                love.graphics.print(item.count, PIXELLARGE + (x * TILESIZE) * SCALE, (y * TILESIZE) * SCALE)
            end
        end
    end
end

return Inventory
