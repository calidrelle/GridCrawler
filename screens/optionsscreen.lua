local this = {}

OPTIONS = {}
OPTIONS.volume = 30
OPTIONS.fullscreen = true

local btnBack
local btnVolInc
local btnVolDec
local btnFullscreen

local xpos
local ypos

this.load = function()
    GUI.reset()
    xpos = (WIDTH - 80 * SCALE) / 2
    ypos = HEIGHT / 2
    btnVolDec = GUI.addButton("Volume -", xpos, ypos)
    btnVolInc = GUI.addButton("Volume +", xpos + 200, ypos)

    btnFullscreen = GUI.addButton("Plein écran", xpos, ypos + 60)

    btnBack = GUI.addButton("Retour", xpos, ypos + 300, 64 * SCALE)
end

this.update = function(dt)
    if btnBack.clicked then
        ScreenManager.setScreen("MENU")
    end

    if btnVolDec.clicked then
        if OPTIONS.volume > 0 then
            OPTIONS.volume = OPTIONS.volume - 10
            MUSICPLAYER:setVolume(OPTIONS.volume / 100)
        end
    end

    if btnVolInc.clicked then
        if OPTIONS.volume < 100 then
            OPTIONS.volume = OPTIONS.volume + 10
            MUSICPLAYER:setVolume(OPTIONS.volume / 100)
        end
    end

    if btnFullscreen.clicked then
        OPTIONS.fullscreen = not OPTIONS.fullscreen
        love.window.setFullscreen(OPTIONS.fullscreen)
        WIDTH = love.graphics.getWidth()
        HEIGHT = love.graphics.getHeight()
        this.load()
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())

    love.graphics.print("Volume : " .. OPTIONS.volume, xpos, ypos - 50)
    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.print("OPTIONS", 50, 50)
    -- -- love.graphics.print("Enter pour jouer", 80, 120)

    -- -- love.graphics.print("Espace pour générer une nouvelle map", 80, 140)
    -- love.graphics.print("Escape pour revenir au menu", 80, 160)
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    else
        print(key)
    end
end

return this
