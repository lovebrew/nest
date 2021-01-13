local PATH = (...):gsub('%.[^%.]+$', '')

local Window = require(PATH .. ".window")

local config = require("nest.config")
local flags  = config.flags

local activeScreen = nil
local blendFactor  = 0

local names =
{
    { "default" },
    { "left", "right", "top", "bottom" }
}

--- default overrides

function love.graphics.getWidth(screen)
    if not screen then
        screen = activeScreen
    end

    return Window.getWidth(screen)
end

function love.graphics.getHeight()
    return Window.getHeight()
end

function love.graphics.getDimensions(screen)
    if not screen then
        screen = activeScreen
    end

    local width  = Window.getWidth(screen)
    local height = Window.getHeight()

    return width, height
end

--- console stuff

if config.hasFlag(flags.USE_CTR) == "ctr" then
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
    return Window.__config == "hac" and names[1] or names[2]
end