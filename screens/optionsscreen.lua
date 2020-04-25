local this = {}

this.load = function()
end

this.update = function(dt)
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("OPTIONS", 50, 50)
    -- love.graphics.print("Enter pour jouer", 80, 120)

    -- love.graphics.print("Espace pour générer une nouvelle map", 80, 140)
    love.graphics.print("Escape pour revenir au menu", 80, 160)
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    else
        print(key)
    end
end

return this
