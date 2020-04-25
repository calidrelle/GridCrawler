-- This file is a template
ItemManager.newExitGrid = function(tileX, tileY)
    local item = ItemManager.create(Assets.floor_grid, tileX, tileY)
    item.name = "exit"
    item.solid = false
    item.initStats(0, 0, 0, 0) -- pv, atkRange, atk, def

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other.name == "player" then
            other.addMessage(
                "Pour ouvrir la grille, il te faut le\ngrimoire complet. Les monstres ont\nvolé les 8 pages et en ont caché dans\nles bariques et les caisses du donjon.\nTrouve les 8 pages !",
                5)
        end
    end

    item.update = function(dt)
    end

    return item
end
