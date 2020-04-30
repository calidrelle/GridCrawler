local this = {}

local btnPlay
local btnQuit

this.load = function()
    local x = WIDTH * .5
    local y = HEIGHT * 3 / 4
    btnPlay = GUI.addButton("Retour", x, y)

    MUSICPLAYER:stop()
    MUSICPLAYER = love.audio.newSource("sons/24_v2.mp3", "stream")
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)
    MUSICPLAYER:play()

    ItemManager.reset()
    ItemManager.newTorch(192, 184)
    ItemManager.newTorch(288, 184)

    Player.setPosition(240, 208)
    GUI.addInfoBull(
        "Bravo, tu as réussi à sortir du manoir vivant. Tu auras toute une aventure à raconter à ta descendance !\nPartage ta victoire sur www.gamecodeur.fr",
        30)
end

this.update = function(dt)
    if btnPlay.clicked then
        ScreenManager.setScreen("NEWGAME")
    end
    if Player.y < 248 then
        Player.y = Player.y + 10 * dt
    end
    ItemManager.update(dt)
    Player.update(dt)
end

this.draw = function()
    love.graphics.push()
    love.graphics.scale(SCALE)
    love.graphics.translate((-Player.x + (WIDTH / SCALE) / 2), (-Player.y + (HEIGHT / SCALE) / 2))

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.outside, 0, 0)

    Player.draw()
    ItemManager.draw()

    love.graphics.pop()
end

this.keypressed = function(key)
    if key == "return" then
        ScreenManager.setScreen("NEWGAME")
    end
end

return this
