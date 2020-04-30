-- [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)
love.graphics.setDefaultFilter("nearest") -- pas d'aliasing

function DevMode()
    return love.filesystem.getInfo("README.md") ~= nil
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local gameScreen = require("screens.gamescreen")
local menuScreen = require("screens.menuscreen")
local gameQuit = require("screens.quitscreen")
local optionsScreen = require("screens.optionsscreen")
local keysOptionsScreen = require("screens.keysoptions")
local shopScreen = require("screens.shopscreen")
local screen = nil

Font20 = love.graphics.newFont("fonts/decterm.ttf", 20)
Font32 = love.graphics.newFont("fonts/decterm.ttf", 32)
Font16 = love.graphics.newFont("fonts/decterm.ttf", 16)
Font8 = love.graphics.newFont("fonts/decterm.ttf", 8)
FontVendor12 = love.graphics.newFont("fonts/Pixellari.ttf", 12)
FontVendor32 = love.graphics.newFont("fonts/Pixellari.ttf", 32)
local musicIntro
local musicLoops = {}
MUSICPLAYER = nil

GameOver = {}
GameOver.status = false
GameOver.timer = 0

Player = nil

function love.load()
    OPTIONS.setValues()
    love.window.setTitle("Grid Crawler (v0.3 by Wile)")

    require("engine.assets").init()
    require("engine.itemManager")
    require("engine.inventory")
    require("engine.gui").init()
    require("engine.effects").init()

    Player = require("gameobjects.player")
    Player.createNew()

    musicIntro = love.audio.newSource("sons/BeepBox-Song2-intro.mp3", "stream")
    musicLoops[1] = love.audio.newSource("sons/BeepBox-Song2-loop1.mp3", "stream")
    musicLoops[2] = love.audio.newSource("sons/BeepBox-Song2-loop2.mp3", "stream")
    musicLoops[3] = love.audio.newSource("sons/BeepBox-Song2-loop3.mp3", "stream")

    MUSICPLAYER = musicIntro
    MUSICPLAYER:play()
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)

    ScreenManager.setScreen("MENU") -- MENU
end

ScreenManager = {}
ScreenManager.setScreen = function(name)
    GUI.reset()
    love.mouse.setVisible(true)
    Player.inTheShop = false
    if name == "MENU" then
        screen = menuScreen
    elseif name == "GAME" then
        love.mouse.setVisible(false)
        screen = gameScreen
    elseif name == "NEXTLEVEL" then
        MUSICPLAYER:stop()
        MUSICPLAYER = musicIntro
        MUSICPLAYER:play()
        gameScreen.startNewLevel()
        screen = gameScreen
    elseif name == "OPTIONS" then
        screen = optionsScreen
    elseif name == "KEYS" then
        screen = keysOptionsScreen
    elseif name == "QUIT" then
        screen = gameQuit
    elseif name == "VENDOR" then
        Player.inTheShop = true
        love.mouse.setVisible(false)
        screen = shopScreen
    else
        error("L'écran " .. name .. " n'existe pas")
    end
    screen.load()
end

local function updateMusic()
    if not MUSICPLAYER:isPlaying() then
        local n = math.random(#musicLoops)
        MUSICPLAYER = musicLoops[n]
        MUSICPLAYER:setVolume(OPTIONS.volume / 100)
        MUSICPLAYER:play()
    end
end

function love.update(dt)
    dt = math.min(dt, 1 / 60)
    updateMusic()
    GUI.update(dt)
    screen.update(dt)
end

function love.draw()
    love.graphics.setFont(Font20)
    screen.draw()
    GUI.draw()
end

function love.keypressed(key)
    screen.keypressed(key)
end
