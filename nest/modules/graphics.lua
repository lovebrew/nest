local PATH = (...):gsub('%.[^%.]+$', '')

local window = require(PATH .. ".window")

PATH = (...):gsub("%.modules.+", '')

local config = require(PATH .. ".config")

local activeScreen = nil
local blendFactor  = 0

local names = {}

names.ctr = { "left", "right", "bottom" }
names.hac = { "default" }

-- overrides

function love.graphics.getWidth(screen)
    if not screen then
        screen = activeScreen
    end

    return window.getWidth(screen)
end

function love.graphics.getHeight()
    return window.getHeight()
end

function love.graphics.getDimensions(screen)
    if not screen then
        screen = activeScreen
    end

    local width  = window.getWidth(screen)
    local height = window.getHeight()

    return width, height
end

--- console stuff

if config.isSetTo("mode", "ctr") then
    function love.graphics.setBlendFactor(factor)
        blendFactor = factor
    end

    function love.graphics.getBlendFactor()
        return blendFactor
    end

    function love.graphics.getStereoscopicDepth()
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
