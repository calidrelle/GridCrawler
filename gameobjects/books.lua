-- This file is a template
-- Penser à rajouter le require de ce fichier dans ItemManager.lua
ItemManager.newBooks = function(tileX, tileY)
    local item = ItemManager.create(Assets.books, tileX, tileY)
    item.name = "books"
    item.solid = true

    item.hit = function(other)
    end

    item.walkOver = function(other)
    end

    item.update = function(dt)
    end

    return item
end
