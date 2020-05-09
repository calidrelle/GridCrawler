local this = {}

local btnPlay
local btnQuit

this.load = function()
    local xpos = WIDTH * 4 / 5
    local ypos = HEIGHT * 4 / 5
    btnPlay = GUI.addButton("Retour", xpos, ypos)

    MUSICPLAYER:stop()
    MUSICPLAYER = love.audio.newSource("sons/24_v2.mp3", "stream")
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)
    MUSICPLAYER:play()

    ItemManager.reset()
    AurasManager.reset()
    ItemManager.newTorch(192, 184)
    ItemManager.newTorch(288, 184)

    Player.setPosition(240, 208)
    GUI.addInfoBull(
        "Bravo, tu as réussi à sortir du manoir vivant. Tu auras toute une aventure à raconter à ta descendance !\nPartage ta victoire sur www.gamecodeur.fr",
        30)

    GUI.addInfoBull("Pour traversé le manoir, tu as mis " .. math.floor(Player.timers.getTotal()) .. "sec.", 60, 400)

    Bravoure.Harpagon.check()
    Bravoure.GousseDAil.check()
    Bravoure.Vaccine.check()
    Bravoure.Sparadrap.check()

    if OPTIONS.DIFFICULTY == 1 then
        Bravoure.Ecuyer.check()
    elseif OPTIONS.DIFFICULTY == 2 then
        Bravoure.Chevalier.check()
    elseif OPTIONS.DIFFICULTY == 3 then
        Bravoure.Paladin.check()
    end

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
