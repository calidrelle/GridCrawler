local this = {}

local btnPlay
local btnReplay
local btnPlayEasy, btnContinuEasy
local btnPlayNormal, btnContinueNormal
local btnPlayHard, btnContinueHard
local btnOptions
local btnQuit
local btnBravoure

this.load = function()
    GUI.reset()
    local x = (WIDTH - 80 * SCALE) / 2
    local y = HEIGHT / 2

    btnPlay = GUI.addButton("Continuer la partie", x, y, 100 * SCALE)
    btnReplay = GUI.addButton("Recommencer une partie", x, y - 60, 100 * SCALE)

    btnPlayEasy = GUI.addButton("1. Partie facile", x, y - 140, 100 * SCALE)
    btnPlayNormal = GUI.addButton("2. Partie normal", x, y - 80, 100 * SCALE)
    btnPlayHard = GUI.addButton("3. Partie difficile", x, y - 20, 100 * SCALE)

    btnContinuEasy = GUI.addButton("Magasin facile", x - 400, y + 100, 80 * SCALE)
    btnContinueNormal = GUI.addButton("Magasin normal", x - 400, y + 160, 80 * SCALE)
    btnContinueHard = GUI.addButton("Magasin difficile", x - 400, y + 220, 80 * SCALE)

    btnBravoure = GUI.addButton("Actes de Bravoure", WIDTH * 3 / 4, HEIGHT - 30 * SCALE, 80 * SCALE)

    if DATA.SaveExists() then
        ScreenManager.started = true
        btnReplay.hints = "Attention, recommencer une partie efface la progression en cours"
    end

    btnContinuEasy.visible = Player.hasKey(1, 1)
    btnContinuEasy.hints = btnReplay.hints
    btnContinueNormal.visible = Player.hasKey(1, 2)
    btnContinueNormal.hints = btnReplay.hints
    btnContinueHard.visible = Player.hasKey(1, 3)
    btnContinueHard.hints = btnReplay.hints

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

local function doStartEasy(useKey)
    if btnPlayEasy.visible or btnContinuEasy.visible then
        OPTIONS.DIFFICULTY = 1
        if useKey then
            Player.level = 1
            ScreenManager.setScreen("VENDOR")
        else
            ScreenManager.setScreen("GAME")
        end
        ScreenManager.started = true
    end
end

local function doStartNormal(useKey)
    if btnPlayNormal.visible or btnContinueNormal.visible then
        OPTIONS.DIFFICULTY = 2
        if useKey then
            Player.level = 1
            ScreenManager.setScreen("VENDOR")
        else
            ScreenManager.setScreen("GAME")
        end
        ScreenManager.started = true
    end
end

local function doStartHard(useKey)
    if btnPlayHard.visible or btnContinueHard.visible then
        OPTIONS.DIFFICULTY = 3
        if useKey then
            Player.level = 1
            ScreenManager.setScreen("VENDOR")
        else
            ScreenManager.setScreen("GAME")
        end
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

    elseif btnContinuEasy.clicked then
        doStartEasy(true)
    elseif btnContinueNormal.clicked then
        doStartNormal(true)
    elseif btnContinueHard.clicked then
        doStartHard(true)

    elseif btnOptions.clicked then
        doOptions()
    elseif btnBravoure.clicked then
        ScreenManager.setScreen("BRAVOURE")
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
