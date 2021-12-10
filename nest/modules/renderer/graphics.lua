local PATH = (...):gsub('%.[^%.]+$', '')
local window = require(PATH .. ".window")

PATH = (...):gsub("%.modules.+", '')

local config = require(PATH .. ".config")

local activeScreen = nil

local names = {}

names.ctr = { "left", "right", "bottom" }
names.hac = { "default" }

-- overrides

function love.graphics.getWidth(screen)
    if not screen then
        screen = activeScreen
    end

    return window.getCanvasWidth(screen)
end

function love.graphics.getHeight()
    return window.getCanvasHeight()
end

function love.graphics.getDimensions(screen)
    if not screen then
        screen = activeScreen
    end

    local width  = window.getCanvasWidth(screen)
    local height = window.getCanvasHeight()

    return width, height
end

--- console stuff

if config.isSetTo("mode", "ctr") then
    function love.graphics.get3DDepth()
        return 0.0
    end
end

function love.graphics.setActiveScreen(screen)
    activeScreen = screen
end

function love.graphics.getActiveScreen()
    return activeScreen
end

function love.graphics.getScreens()
    local mode = window.get("mode")
    return names[mode]
end
