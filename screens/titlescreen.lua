local this = {}

this.load = function()

end

this.update = function(dt)
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.print("Appuyer sur 'Enter' pour commencer", WIDTH / 2, HEIGHT / 2)
end

this.keypressed = function(key)
    if key == "return" or key == "kpenter" then
        ScreenManager.setScreen("MENU")
    end
end

return this
