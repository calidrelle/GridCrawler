-- [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)
love.graphics.setDefaultFilter("nearest") -- pas d'aliasing

local gameScreen = require("screens.gamescreen")
local menuScreen = require("screens.menuscreen")
local screen = nil

TILESIZE = 16
SCALE = 3

ScreenManager = {}
ScreenManager.setScreen = function(name)
    if name == "MENU" then
        screen = menuScreen
    elseif name == "NEWGAME" then
        screen = gameScreen
        screen.reset()
    elseif name == "GAME" then
        screen = gameScreen
    else
        error("L'écran " .. name .. " n'existe pas")
    end
    screen.load()
end

function love.load()
    love.window.setMode(1280, 768)
    love.window.setFullscreen(false)
    -- love.window.setFullscreen(true)
    love.window.setTitle("Grid Crawler (by Wile)")
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()
    print("Game launch in " .. WIDTH .. "x" .. HEIGHT)

    require("images.assets").init()

    ScreenManager.setScreen("GAME") -- MENU
end

function love.update(dt)
    screen.update(dt)
end

function love.draw()
    screen.draw()
end

function love.keypressed(key)
    screen.keypressed(key)
    -- if key=="escape" then love.event.quit() end
end
