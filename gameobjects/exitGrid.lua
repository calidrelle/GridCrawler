-- This file is a template
ItemManager.newExitGrid = function(tileX, tileY)
    local item = ItemManager.create(Assets.floor_grid, tileX, tileY)
    item.name = "exit"
    item.solid = false
    -- item.initStats(0, 0, 0, 0) -- pv, atkRange, atk, def

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other.name == "player" then
            if Player.gridOpened then
                ScreenManager.setScreen("VENDOR")
            else
                other.addMessage(
                    "Pour ouvrir la grille, il te faut le grimoire complet. Les monstres ont volé les 8 pages et en ont caché dans les bariques et les caisses du donjon. Trouve les 8 pages !",
                    5)
            end
        end
    end

    item.update = function(dt)
    end

    return item
end
