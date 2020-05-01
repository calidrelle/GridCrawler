-- [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)
love.graphics.setDefaultFilter("nearest") -- pas d'aliasing

-------------------[[ GLOBAL FUNCTIONS ]]
function DevMode()
    return love.filesystem.getInfo("README.md") ~= nil
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function table.contains(tab, item)
    for key, value in pairs(tab) do
        if value == item then
            return true
        end
    end
    return false
end

function table.removeAll(tab)
    while #tab > 0 do
        tab[1] = {}
        table.remove(tab, 1)
    end
end

function math.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function math.sign(value)
    if value == 0 then
        return 0
    else
        return math.abs(value) / value
    end
end

wile = {}
function wile.display2decimale(value)
    return math.floor(value * 100) / 100
end
-------------------[[ GLOBAL FUNCTIONS ]]

local gameScreen = require("screens.gamescreen")
local menuScreen = require("screens.menuscreen")
local gameQuit = require("screens.quitscreen")
local optionsScreen = require("screens.optionsscreen")
local keysOptionsScreen = require("screens.keysoptions")
local shopScreen = require("screens.shopscreen")
local outsideScreen = require("screens.outside")
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
    OPTIONS.applyValues()
    love.window.setTitle("Grid Crawler (v0.3 by Wile)")

    require("engine.data")
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

    ScreenManager.setScreen("MENU")
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
    elseif name == "NEWGAME" then
        gameScreen.restartGame()
        menuScreen.resetStarted()
        MUSICPLAYER:stop()
        MUSICPLAYER = musicIntro
        MUSICPLAYER:play()
        screen = menuScreen
    elseif name == "NEXTLEVEL" then
        love.mouse.setVisible(false)
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
    elseif name == "OUTSIDE" then
        screen = outsideScreen
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
    if DevMode() then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(Font16)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Items: " .. #ItemManager.getItems(), 10, 28)
    end
end

function love.keypressed(key)
    screen.keypressed(key)
end
