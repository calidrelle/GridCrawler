-- TODO: insérer cet écran dans les require de main.lua
local this = {}

local alpha = 0
this.load = function()
    love.mouse.setVisible(true)
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2
end

this.update = function(dt)
    if alpha < 1 then
        alpha = alpha + dt / 2
    end
    Background.setAlpha(alpha)
    MUSICPLAYER:setVolume(alpha * OPTIONS.volume / 100)
end

this.draw = function()
    Background.draw()
    love.graphics.setFont(Font32)
    love.graphics.print("Appuyer sur [Entrer] pour commencer", WIDTH / 3, HEIGHT * 4 / 5)
end

this.keypressed = function(key)
    if key == "return" or key == "kpenter" then
        ScreenManager.setScreen("TUTO")
    end
end

return this
