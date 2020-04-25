local this = {}

this.load = function()
end

this.update = function(dt)
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.print(
        "Merci d'avoir joué !!!\n\n  [ESC] pour revenir au bureau\n\n\n  [Enter] pour revenir au menu et continuer à cet excellent jeu !!!",
        WIDTH / 2, HEIGHT / 2)
end

this.keypressed = function(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" or key == "kpenter" then
        ScreenManager.setScreen("MENU")
    end
end

return this
