ItemManager.newGold = function(tileX, tileY)
    local item = ItemManager.create(Assets.gold, tileX, tileY)
    item.name = "gold"
    item.solid = false
    item.initStats(0, 0, 0, 0)

    item.hit = function(other)
    end

    item.walkOver = function(other)
        other.gold = other.gold + 1
        item.actif = false
    end

    item.update = function(dt)
    end

    return item
end
