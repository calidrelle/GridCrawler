-- This file is a template
ItemManager.newExitGrid = function(tileX, tileY)
    local item = ItemManager.create(Assets.floor_grid, tileX, tileY)
    item.name = "exit"
    item.solid = false

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other == Player then
            if Player.gridOpened then
                Bravoure.Savonnette.check()
                if Player.level == LEVELMAX then
                    ScreenManager.setScreen("OUTSIDE")
                else
                    ScreenManager.setScreen("VENDOR")
                end
            end
        end
    end

    item.update = function(dt)
        if Player.gridOpened then
            item.quad = Assets.downstairs
        end
    end

    return item
end
