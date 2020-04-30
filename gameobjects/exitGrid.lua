-- This file is a template
ItemManager.newExitGrid = function(tileX, tileY)
    local item = ItemManager.create(Assets.floor_grid, tileX, tileY)
    item.name = "exit"
    item.solid = false

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other.name == "player" then
            if Player.gridOpened then
                if Player.level == LEVELMAX then
                    ScreenManager.setScreen("OUTSIDE")
                else
                    ScreenManager.setScreen("VENDOR")
                end
            else
                other.addMessage(
                    "Pour ouvrir la grille, il te faut le grimoire complet. Les monstres ont volé les 8 pages et en ont caché dans les barriques et les caisses du manoir. Trouve les 8 pages !",
                    5)
            end
        end
    end

    item.update = function(dt)
    end

    return item
end
