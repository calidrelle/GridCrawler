-- TODO: insérer cet écran dans les require de main.lua
local this = {}

local btnXXX

this.load = function()
    love.mouse.setVisible(true)
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnXXX = GUI.addButton("Retour", x, y)
end

this.update = function(dt)
    if btnXXX.clicked then
        ScreenManager.setScreen("MENU")
    end
end

this.draw = function()
    Background.draw()
end

this.keypressed = function(key)
end

return this
