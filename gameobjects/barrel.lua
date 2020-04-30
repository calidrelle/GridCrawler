ItemManager.newBarrel = function(x, y)
    local item = ItemManager.create(Assets.barrel, x, y)
    item.name = "barrel"
    item.solid = true
    item.canBeAttacked = true
    item.canDropPage = true
    table.insert(item.lootTable, ItemManager.newGold(-1, -1, ItemManager.getRandomPoNumber(DATA.barrel)))

    item.hit = function(other)
        ItemManager.doAttack(other, item)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
