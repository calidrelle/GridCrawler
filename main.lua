-- [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)
love.graphics.setDefaultFilter("nearest") -- pas d'aliasing

local gameScreen = require("screens.gamescreen")
local menuScreen = require("screens.menuscreen")
local screen = nil

Font20 = love.graphics.newFont("fonts/decterm.ttf", 20)

love.graphics.setFont(Font20)

TILESIZE = 16
SCALE = 4
FULLSCREEN = false

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
    love.window.setFullscreen(FULLSCREEN)
    love.window.setTitle("Grid Crawler (by Wile)")
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()

    require("images.assets").init()
    require("gameobjects.itemManager")
    require("gameobjects.inventory").init()

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
