ItemManager.newGold = function(tileX, tileY, amount)
    local item = ItemManager.create(Assets.gold, tileX, tileY)
    item.name = "gold"
    item.amount = amount
    item.solid = false

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other == Player then
            Inventory.addItem(item, item.amount)
            other.addMessage("Vous ramassez " .. item.amount .. " pièce(s) d'or", item.amount)
            item.actif = false
        end
    end

    item.update = function(dt)
    end

    return item
end
