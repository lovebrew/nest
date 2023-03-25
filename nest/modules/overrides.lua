local path = (...):gsub("%.modules.+", "")

local config = require(path .. ".config")
local video = require(path .. ".modules.video")

-- Credit: https://shorturl.at/tyENT
local function foreach(t, f)
    for i = 1, #t do
        local result = f(t[i], i)
        if result ~= nil then
            return result
        end
    end
    return nil
end

-- video should be inited by now
local framebuffers = video.getFramebuffers()

local active_screen = nil
function love.graphics.setActiveScreen(screen)
    active_screen = screen
end

function love.graphics.getActiveScreen()
    return active_screen
end

local originalSetCanvas = love.graphics.setCanvas
function love.graphics.setCanvas(...)
    local length = select("#", ...)

    if length == 1 then
        foreach(framebuffers, function(element, _)
            element:toggleRenderTo()
        end)

        originalSetCanvas(...)
    else
        originalSetCanvas(...)

        foreach(framebuffers, function(element, _)
            element:toggleRenderTo()
        end)
    end
end

function love.graphics.getWidth(screen)
    return foreach(framebuffers, function(element, _)
        if element:getName() == screen then
            return element:getWidth()
        end
    end) or framebuffers[1]:getWidth()
end

function love.graphics.getHeight(screen)
    return foreach(framebuffers, function(element, _)
        if element:getName() == screen then
            return element:getHeight()
        end
    end) or framebuffers[1]:getHeight()
end

function love.graphics.getDimensions(screen)
    local element = foreach(framebuffers, function(element, _)
        if element:getName() == screen then
            return element
        end
    end)

    if element then
        return element:getDimensions()
    end
    return framebuffers[1]:getDimensions()
end

if config.get("console") == "3ds" then
    local depth_enabled = true
    function love.graphics.get3D()
        return depth_enabled
    end

    function love.graphics.set3D(enabled)
        depth_enabled = enabled
    end

    local depth_value = 0.0
    function love.graphics.getDepth()
        if not love.graphics.get3D() then
            return 0.0
        end
        return depth_value
    end

    function love.graphics._setDepth(depth)
        depth_value = math.max(0, math.min(depth_value + depth, 1))
    end
end

----
--- drawing scaled stuff (need to check if it's the screen or an actual canvas)
--- print, printf, draw, circle, rectangle, points, line, ellipse, polygon
----
