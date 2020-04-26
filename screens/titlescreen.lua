local this = {}

local btnGo = {}

this.load = function()
    btnGo = GUI.addButton("Jouer !", WIDTH / 4 * 3, HEIGHT - 80)
end

this.update = function(dt)
    if btnGo.clicked then
        ScreenManager.setScreen("MENU")
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())
end

this.keypressed = function(key)
    if key == "return" or key == "kpenter" then
        ScreenManager.setScreen("MENU")
    end
end

return this
