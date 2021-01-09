local PATH = (...):gsub('%.[^%.]+$', '')
local Window = require(PATH .. ".window")

local activeScreen = nil

local names = { { "default "}, { "top", "bottom" } }

function love.graphics.getScreens()
    return Window.__config == "hac" and names[1] or names[2]
end

function love.graphics.getWidth(screen)
    if not screen then
        screen = activeScreen
    end
    return Window.getWidth(screen)
end

function love.graphics.setActiveScreen(screen)
    activeScreen = screen
end

function love.graphics.getActiveScreen()
    return activeScreen
end
