local this = {}

local btnPlay
local btnOptions
local btnQuit

this.load = function()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnPlay = GUI.addButton("Lancer une partie", x, y, 64 * SCALE)
    btnOptions = GUI.addButton("Options", x, y + 60, 64 * SCALE)
    btnQuit = GUI.addButton("Quitter", x, y + 120, 64 * SCALE)
end

this.update = function(dt)
    if btnPlay.clicked then
        ScreenManager.setScreen("GAME")
    elseif btnOptions.clicked then
        ScreenManager.setScreen("OPTIONS")
    elseif btnQuit.clicked then
        ScreenManager.setScreen("QUIT")
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("QUIT")
    end
end

return this
