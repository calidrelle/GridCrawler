local this = {}

local credits = {}
table.insert(credits, "Merci d'avoir joué à GridCrawler !!!")
table.insert(credits, "Ce jeu a été développé pour la participation à la Game Jam #24 de GameCodeur")
table.insert(credits, "https://www.gamecodeur.fr")
table.insert(credits, "")
table.insert(credits, "CREDITS:")
table.insert(credits, "Musique shop : yujiboy https://yujiboy.itch.io")
table.insert(credits, "Sprites : o-lobster https://o-lobster.itch.io")

local btnPlay
local btnQuit

this.load = function()
    local x = WIDTH * 3 / 4
    local y = HEIGHT * 3 / 4
    btnPlay = GUI.addButton("Retour", x, y)
    btnQuit = GUI.addButton("Quitter", x, y + 64)
end

this.update = function(dt)
    if btnQuit.clicked then
        love.event.quit()
    end
    if btnPlay.clicked then
        ScreenManager.setScreen("MENU")
    end
end

this.draw = function()
    local xpos = WIDTH * 1 / 4
    local ypos = HEIGHT * 1 / 3
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.setColor(0.21, 0.21, 0.21, 0.85)
    love.graphics.rectangle("fill", xpos, ypos, WIDTH / 2, HEIGHT / 3)

    love.graphics.setColor(1, 1, 1, 1)
    for i, value in pairs(credits) do
        love.graphics.print(value, xpos + 16, ypos + 16 + (i - 1) * 24)
    end
end

this.keypressed = function(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        ScreenManager.setScreen("MENU")
    end
end

return this
