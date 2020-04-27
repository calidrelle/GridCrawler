local this = {}

OPTIONS = {}
OPTIONS.volume = 0
OPTIONS.fullscreen = false

SCALE = 3

-- 800, 600 (4/3)
-- 1024 x 576 (16/9)
-- 1024 x 768 (4/3)
-- 1600 x 900 (16/9)

love.window.setMode(1280, 768)

OPTIONS.setValues = function()
    love.window.setFullscreen(OPTIONS.fullscreen)
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()
end
---------------------------------------------------------
local btnBack
local btnVolInc
local btnVolDec
local btnFullscreen
local btnScale3
local btnScale4
local btnKeyOptions

local xpos
local ypos

this.load = function()
    GUI.reset()
    xpos = WIDTH / 3
    ypos = HEIGHT / 3
    btnVolDec = GUI.addButton("Volume -", xpos, ypos)
    btnVolInc = GUI.addButton("Volume +", xpos + 80 * SCALE, ypos)

    btnFullscreen = GUI.addButton("Plein écran", xpos, ypos + 80)

    btnScale3 = GUI.addButton("Echelle 3", xpos, ypos + 160)
    btnScale4 = GUI.addButton("Echelle 4", xpos + 80 * SCALE, ypos + 160)

    btnKeyOptions = GUI.addButton("Touches", xpos, ypos + 240)

    btnBack = GUI.addButton("Retour", xpos, ypos + 320, 64 * SCALE)
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
        OPTIONS.setValues()
        this.load()
    end

    if btnScale3.clicked then
        SCALE = 3
        this.load()
    end
    if btnScale4.clicked then
        SCALE = 4
        this.load()
    end

    if btnKeyOptions.clicked then
        ScreenManager.setScreen("KEYS")
    end
end

this.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Assets.titleScreen, 0, 0, 0, WIDTH / Assets.titleScreen:getWidth(), HEIGHT / Assets.titleScreen:getHeight())
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    else
        print(key)
    end
end

return this
