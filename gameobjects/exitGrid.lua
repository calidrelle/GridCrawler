-- This file is a template
ItemManager.newExitGrid = function(tileX, tileY)
    local asset
    if Player.level > 6 then
        asset = Assets.floor3_grid
    elseif Player.level > 3 then
        asset = Assets.floor2_grid
    else
        asset = Assets.floor1_grid
    end
    local item = ItemManager.create(asset, tileX, tileY)
    item.name = "exit"
    item.solid = false

    item.hit = function(other)
    end

    item.walkOver = function(other)
        if other == Player then
            if Player.gridOpened then
                Bravoure.Savonnette.check()
                if ItemManager.getPoInItems() > 0 then
                    Bravoure.MonPrecieux.lost()
                end
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
