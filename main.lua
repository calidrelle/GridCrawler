-- [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)
love.graphics.setDefaultFilter("nearest") -- pas d'aliasing

INFODEBUG = true

local gameScreen = require("screens.gamescreen")
local menuScreen = require("screens.menuscreen")
local gameQuit = require("screens.quitscreen")
local optionsScreen = require("screens.optionsscreen")
local keysOptionsScreen = require("screens.keysoptions")
local nextLevelScreen = require("screens.nextlevel")
local screen = nil

Font20 = love.graphics.newFont("fonts/decterm.ttf", 20)
Font32 = love.graphics.newFont("fonts/decterm.ttf", 32)
Font8 = love.graphics.newFont("fonts/decterm.ttf", 8)
local musicIntro
local musicLoops = {}
MUSICPLAYER = nil

TILESIZE = 16

function love.load()
    OPTIONS.setValues()
    love.window.setTitle("Grid Crawler (by Wile)")

    require("engine.assets").init()
    require("engine.itemManager")
    require("engine.inventory").init()
    require("engine.gui").init()
    require("engine.effects").init()

    musicIntro = love.audio.newSource("sons/BeepBox-Song2-intro.wav", "stream")
    musicLoops[1] = love.audio.newSource("sons/BeepBox-Song2-loop1.wav", "stream")
    musicLoops[2] = love.audio.newSource("sons/BeepBox-Song2-loop2.wav", "stream")
    musicLoops[3] = love.audio.newSource("sons/BeepBox-Song2-loop3.wav", "stream")

    MUSICPLAYER = musicIntro
    MUSICPLAYER:play()
    MUSICPLAYER:setVolume(OPTIONS.volume / 100)

    ScreenManager.setScreen("MENU") -- MENU
end

ScreenManager = {}
ScreenManager.setScreen = function(name)
    GUI.reset()
    love.mouse.setVisible(true)
    if name == "MENU" then
        screen = menuScreen
    elseif name == "GAME" then
        if not INFODEBUG then
            love.mouse.setVisible(false)
        end
        screen = gameScreen
    elseif name == "OPTIONS" then
        screen = optionsScreen
    elseif name == "KEYS" then
        screen = keysOptionsScreen
    elseif name == "QUIT" then
        screen = gameQuit
    elseif name == "NEXTLEVEL" then
        screen = nextLevelScreen
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
    -- if key=="escape" then love.event.quit() end
end
