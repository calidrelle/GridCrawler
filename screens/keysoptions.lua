local this = {}

OPTIONS.UP = "z"
OPTIONS.DOWN = "s"
OPTIONS.LEFT = "q"
OPTIONS.RIGHT = "d"
OPTIONS.FIRE = "rctrl"
OPTIONS.JUMP = "space"
OPTIONS.SHOWCARAC = "tab"

---------------------------------------------------------
local btnBack

local btnUp
local btnDown
local btnLeft
local btnRight
local btnFire
local btnJump
local btnShowCarac

local xpos
local ypos
local selectionText

this.load = function()
    GUI.reset()
    xpos = WIDTH / 3
    ypos = 200

    btnUp = GUI.addButton(OPTIONS.UP, xpos, ypos)
    btnDown = GUI.addButton(OPTIONS.DOWN, xpos, ypos + 60)
    btnLeft = GUI.addButton(OPTIONS.LEFT, xpos, ypos + 120)
    btnRight = GUI.addButton(OPTIONS.RIGHT, xpos, ypos + 180)
    btnJump = GUI.addButton(OPTIONS.JUMP, xpos, ypos + 240)
    btnFire = GUI.addButton(OPTIONS.FIRE, xpos, ypos + 300)
    btnShowCarac = GUI.addButton(OPTIONS.SHOWCARAC, xpos, ypos + 360)

    btnBack = GUI.addButton("Retour", WIDTH * 3 / 4, HEIGHT * 4 / 5, 64 * SCALE)
    selectionText = ""
end

this.update = function(dt)
    if btnUp.clicked then
        btnUp.waiting = true
        selectionText = "Appuyez sur la touche pour'HAUT'"
    end
    if btnDown.clicked then
        btnDown.waiting = true
        selectionText = "Appuyez sur la touche pour 'BAS'"
    end
    if btnLeft.clicked then
        btnLeft.waiting = true
        selectionText = "Appuyez sur la touche pour 'GAUCHE'"
    end
    if btnRight.clicked then
        btnRight.waiting = true
        selectionText = "Appuyez sur la touche pour 'DROITE'"
    end
    if btnJump.clicked then
        btnJump.waiting = true
        selectionText = "Appuyez sur la touche pour 'SAUTER'"
    end
    if btnFire.clicked then
        btnFire.waiting = true
        selectionText = "Appuyez sur la touche pour 'TIR'"
    end
    if btnShowCarac.clicked then
        btnShowCarac.waiting = true
        selectionText = "Appuyez sur la touche pour 'CARACTERISTIQUES'"
    end

    if btnBack.clicked then
        ScreenManager.setScreen("OPTIONS")
    end
end

this.draw = function()
    Background.draw()

    for i = 1, 7 do
        love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
        love.graphics.rectangle("fill", 260 + xpos, ypos + (i - 1) * 60, 160, 48)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Font32)
    love.graphics.print(selectionText, xpos - 60, HEIGHT - 90)

    love.graphics.print("Haut", 300 + xpos, ypos + 6)
    love.graphics.print("Bas", 300 + xpos, 60 + ypos + 6)
    love.graphics.print("Gauche", 300 + xpos, 120 + ypos + 6)
    love.graphics.print("Droite", 300 + xpos, 180 + ypos + 6)
    love.graphics.print("Saut", 300 + xpos, 240 + ypos + 6)
    love.graphics.print("Tir", 300 + xpos, 300 + ypos + 6)
    love.graphics.print("Stats.", 300 + xpos, 360 + ypos + 6)
end

local function isKeyDispo(key)
    if key == "escape" then
        return false
    end
    if OPTIONS.UP == key or OPTIONS.DOWN == key or OPTIONS.LEFT == key or OPTIONS.RIGHT == key or OPTIONS.JUMP == key or OPTIONS.FIRE == key or
        OPTIONS.SHOWCARAC == key then
        return false
    end
    return true
end

this.keypressed = function(key)
    if btnUp.waiting then
        if isKeyDispo(key) then
            OPTIONS.UP = key
        else
            Assets.snd_error:play()
        end
    end
    if btnDown.waiting then
        if isKeyDispo(key) then
            OPTIONS.DOWN = key
        else
            Assets.snd_error:play()
        end
    end
    if btnLeft.waiting then
        if isKeyDispo(key) then
            OPTIONS.LEFT = key
        else
            Assets.snd_error:play()
        end
    end
    if btnRight.waiting then
        if isKeyDispo(key) then
            OPTIONS.RIGHT = key
        else
            Assets.snd_error:play()
        end
    end
    if btnJump.waiting then
        if isKeyDispo(key) then
            OPTIONS.JUMP = key
        else
            Assets.snd_error:play()
        end
    end
    if btnFire.waiting then
        if isKeyDispo(key) then
            OPTIONS.FIRE = key
        else
            Assets.snd_error:play()
        end
    end
    if btnShowCarac.waiting then
        if isKeyDispo(key) then
            OPTIONS.SHOWCARAC = key
        else
            Assets.snd_error:play()
        end
    end
    this.load()
end

return this
