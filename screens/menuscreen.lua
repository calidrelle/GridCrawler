local this = {}

local btnPlay
local btnOptions
local btnQuit

local started = false

this.load = function()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    if started then
        btnPlay = GUI.addButton("Continuer la partie", x, y, 100 * SCALE)
    else
        btnPlay = GUI.addButton("Lancer une partie", x, y, 100 * SCALE)
    end

    btnOptions = GUI.addButton("Options", x, y + 60, 100 * SCALE)
    btnQuit = GUI.addButton("Quitter", x, y + 120, 100 * SCALE)
end

this.update = function(dt)
    if btnPlay.clicked then
        ScreenManager.setScreen("GAME")
        started = true
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
    elseif key == "return" or key == "kpenter" then
        ScreenManager.setScreen("GAME")
        started = true
    end
end

return this
