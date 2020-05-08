local this = {}

local btnPlay
local btnReplay
local btnPlayEasy
local btnPlayNormal
local btnPlayHard
local btnOptions
local btnQuit

this.load = function()
    GUI.reset()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnPlay = GUI.addButton("Continuer la partie", x, y, 100 * SCALE)
    btnReplay = GUI.addButton("Recommencer une partie", x, y - 60, 100 * SCALE)

    btnPlayEasy = GUI.addButton("1. Partie facile", x, y - 140, 100 * SCALE)
    btnPlayNormal = GUI.addButton("2. Partie normal", x, y - 80, 100 * SCALE)
    btnPlayHard = GUI.addButton("3. Partie difficile", x, y - 20, 100 * SCALE)

    if DATA.SaveExists() then
        ScreenManager.started = true
        btnReplay.hints = "Attention, recommencer une partie efface la progression en cours"
    end

    if ScreenManager.started then
        btnPlayEasy.visible = false
        btnPlayNormal.visible = false
        btnPlayHard.visible = false
    else
        btnPlay.visible = false
        if OPTIONS.DIFFICULTY == 0 then
            btnReplay.visible = false
        end
    end

    btnOptions = GUI.addButton("Options", x, y + 60, 100 * SCALE)
    btnQuit = GUI.addButton("Quitter", x, y + 120, 100 * SCALE)
end

local function doBackInGame()
    if btnPlay.visible then
        if DATA.SaveExists() then
            DATA.LoadGame()
            ScreenManager.setScreen("VENDOR")
        else
            ScreenManager.setScreen("GAME")
            ScreenManager.started = true
        end
    end
end

local function doStartEasy()
    if btnPlayEasy.visible then
        MUSICPLAYER:stop()
        OPTIONS.DIFFICULTY = 1
        ScreenManager.setScreen("GAME")
        ScreenManager.started = true
    end
end

local function doStartNormal()
    if btnPlayNormal.visible then
        MUSICPLAYER:stop()
        OPTIONS.DIFFICULTY = 2
        ScreenManager.setScreen("GAME")
        ScreenManager.started = true
    end
end

local function doStartHard()
    if btnPlayHard.visible then
        MUSICPLAYER:stop()
        OPTIONS.DIFFICULTY = 3
        ScreenManager.setScreen("GAME")
        ScreenManager.started = true
    end
end

local function doOptions()
    ScreenManager.setScreen("OPTIONS")
end

this.update = function(dt)
    if btnPlay.clicked then
        doBackInGame()
    elseif btnReplay.clicked then
        ScreenManager.setScreen("NEWGAME")
    elseif btnPlayEasy.clicked then
        doStartEasy()
    elseif btnPlayNormal.clicked then
        doStartNormal()
    elseif btnPlayHard.clicked then
        doStartHard()

    elseif btnOptions.clicked then
        doOptions()
    elseif btnQuit.clicked then
        ScreenManager.setScreen("QUIT")
    end
end

this.draw = function()
    Background.draw()
end

this.keypressed = function(key)
    if key == "escape" then
        ScreenManager.setScreen("QUIT")
    elseif key == "return" or key == "kpenter" then
        doBackInGame()
    elseif key == "1" or key == "kp1" then
        if btnPlayEasy.visible then
            doStartEasy()
        elseif btnPlay.visible then
            doBackInGame()
        end
    elseif key == "2" or key == "kp2" then
        doStartNormal()
    elseif key == "3" or key == "kp3" then
        doStartHard()
    elseif key == "o" then
        doOptions()
    else
        print(key)
    end
end

return this
