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
                "Pour ouvrir la grille, il te\nfaut le grimoire complet.\nLes monstres ont volés les\n8 pages et en ont cachés\ndans les bariques et les\ncaisses du donjon.\nTrouve les 8 pages !",
                5)
        end
    end

    item.update = function(dt)
    end

    return item
end
