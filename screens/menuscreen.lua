local this = {}

this.load = function()
end

this.update = function(dt)
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("MENU", 50, 50)
    love.graphics.print("Enter pour jouer", 80, 120)
    love.graphics.print("Espace pour afficher les options", 80, 140)
    -- love.graphics.print("Espace pour générer une nouvelle map", 80, 140)
    love.graphics.print("Escape pour quitter", 80, 160)
end

this.keypressed = function(key)
    if key == "return" or key == "kpenter" then
        ScreenManager.setScreen("GAME")
    elseif key == "space" then
        ScreenManager.setScreen("OPTIONS")
    elseif key == "escape" then
        ScreenManager.setScreen("QUIT")
    else
        print(key)
    end
end

return this
