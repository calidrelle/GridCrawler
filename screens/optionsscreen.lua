local this = {}

OPTIONS = {}
OPTIONS.volume = 50
OPTIONS.fullscreen = false
SCALE = 3
OPTIONS.DIFFICULTY = 0

love.window.setMode(1280, 768)

OPTIONS.applyValues = function()
    love.window.setFullscreen(OPTIONS.fullscreen)
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()
    PIXELLARGE = (WIDTH - 100 * SCALE)
    print(PIXELLARGE .. " x " .. HEIGHT .. ", scale : " .. SCALE)
end

OPTIONS.save = function()
    local strOptions = ""
    local add = function(value)
        strOptions = strOptions .. value .. "\n"
    end
    local boolToStr = function(value)
        if value then
            return 1
        else
            return 0
        end
    end
    add(OPTIONS.volume)
    add(boolToStr(OPTIONS.fullscreen))
    add(SCALE)
    add(OPTIONS.UP)
    add(OPTIONS.DOWN)
    add(OPTIONS.LEFT)
    add(OPTIONS.RIGHT)
    add(OPTIONS.JUMP)
    add(OPTIONS.FIRE)

    love.filesystem.write("options.sav", strOptions)
    GUI.addInfoBull("Options sauvegardées", 3, HEIGHT - 200, true)
end

OPTIONS.load = function()
    local info = love.filesystem.getInfo("options.sav")
    if info == nil then
        return
    end

    local opt = {}
    for line in love.filesystem.lines("options.sav") do
        table.insert(opt, line)
    end
    OPTIONS.volume = opt[1] + 0
    OPTIONS.fullscreen = (opt[2] == "1")
    SCALE = opt[3] + 0
    OPTIONS.UP = opt[4]
    OPTIONS.DOWN = opt[5]
    OPTIONS.LEFT = opt[6]
    OPTIONS.RIGHT = opt[7]
    OPTIONS.JUMP = opt[8]
    OPTIONS.FIRE = opt[9]
    OPTIONS.applyValues()
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
    xpos = (WIDTH - 140 * SCALE) / 2
    ypos = HEIGHT / 3
    btnVolDec = GUI.addButton("Musique -", xpos, ypos)
    btnVolInc = GUI.addButton("Musique +", xpos + 80 * SCALE, ypos)

    btnFullscreen = GUI.addButton("Plein écran", xpos, ypos + 80)

    btnScale3 = GUI.addButton("Echelle 3", xpos, ypos + 160)
    btnScale4 = GUI.addButton("Echelle 4", xpos + 80 * SCALE, ypos + 160)

    btnKeyOptions = GUI.addButton("Touches", xpos, ypos + 240)

    btnBack = GUI.addButton("Retour", WIDTH * 3 / 4, HEIGHT * 4 / 5, 64 * SCALE)
end

this.update = function(dt)
    if btnBack.clicked then
        OPTIONS.save()
        ScreenManager.setScreen("MENU")
        return
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
        OPTIONS.applyValues()
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
    Background.draw()
    GUI.drawProgressBar(xpos, ypos - 30, SCALE * 140, 20, OPTIONS.volume, 100, 0.8, 0.1, 0.1)
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("MENU")
    else
        print("optionscreen key: " .. key)
    end
end

return this
