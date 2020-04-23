ItemManager.newBarrel = function(x, y)
    local item = ItemManager.create(Assets.barrel, x, y)
    item.name = "barrel"
    item.solid = true
    item.initStats(1, 0, 0, 0)

    item.hit = function(other)
        item.pv = item.pv - other.atk - item.def
        if item.pv <= 0 then
            item.actif = false
            ItemManager.newGold(item.x, item.y)
        end
        print("touch by " .. other.name)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
