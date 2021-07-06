local PATH = (...):gsub("%.modules.+", '')
local config  = require(PATH .. ".config")

local window = {}

window.__screens = {}
window.__scale   = config.get("scale")

function window.newScreen(name, x, y, width, height)
    local result = {}

    local scale = window.__scale

    result.name   = name
    result.canvas = love.graphics.newCanvas(width * scale, height * scale)

    result.renderTo = function(func)
        if result.name == "right" then
            return
        end

        result.canvas:renderTo(func)
    end

    result.draw = function()
        if result.name == "right" then
            return
        end

        love.graphics.draw(result.canvas, x * scale, y * scale)
    end

    return result
end

function window.init()
    local mode = config.get("mode")

    if mode == "ctr" then
        local names = {"left", "right", "bottom"}

        for index = 1, 3 do
            local width = index ~= 3 and 400 or 320
            local x, y = index < 3 and 0 or 40, index < 3 and 0 or 240

            local screen = window.newScreen(names[index], x, y, width, 240)
            table.insert(window.__screens, screen)
        end
    else
        local screen = window.newScreen("default", 1280, 720)
        table.insert(window.__screens, screen)
    end

    local width, height = window._getWindowWidth(), window._getWindowHeight()
    love.window.updateMode(width * window.getScale(), height * window.getScale())

    return window.__screens
end

function window.getScale()
    return window.__scale
end

function window.getWidth(name)
    if config.isSetTo("mode", "hac") then
        return window.__screens[1].canvas:getWidth() / window.__scale
    else
        if name ~= "bottom" then
            return window.__screens[1].canvas:getWidth() / window.__scale
        end
        return window.__screens[3].canvas:getWidth() / window.__scale
    end
end

function window._getWindowWidth()
    if config.isSetTo("mode", "hac") then
        return 1280
    end
    return 400
end

function window._getWindowHeight()
    if config.isSetTo("mode", "hac") then
        return 720
    end
    return 480
end

function window.getHeight()
    return window.__screens[1].canvas:getHeight()
end

return window
