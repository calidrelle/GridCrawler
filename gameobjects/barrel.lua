ItemManager.newBarrel = function(x, y)
    local item = ItemManager.create(Assets.barrel, x, y)
    item.name = "barrel"
    item.solid = true
    item.initStats(0, 0, 0, 0)

    item.hit = function(other)
        ItemManager.doAttack(other, item)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
