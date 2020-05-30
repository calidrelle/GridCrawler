-- TODO: insérer cet écran dans les require de main.lua
local this = {}

local btnRetour

this.load = function()
    love.mouse.setVisible(true)
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnRetour = GUI.addButton("Retour", WIDTH * 3 / 4, HEIGHT - 30 * SCALE)
end

this.update = function(dt)
    if btnRetour.clicked then
        ScreenManager.setScreen("MENU")
    end
end

this.draw = function()
    Background.draw()
    local x, y = 50, 50

    for _, acte in pairs(Bravoure.getActes()) do
        if acte.toSave then
            acte.drawAtPos(x, y, 1)
            x = x + 100 * SCALE
            if x > WIDTH * 4 / 5 then
                x = 50
                y = y + 40 * SCALE
            end
        end
    end
end

this.keypressed = function(key)
end

return this
