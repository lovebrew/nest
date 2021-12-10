local PATH = (...):gsub("%.modules.+", '')

local config  = require(PATH .. ".config")
local canvas = require((...):gsub("window", ".canvas"))

local window = {}

window.__screens = {}
window.__scale   = config.get("scale")

function window.init(mode)
    if mode == "ctr" then
        local names = {"left", "right", "bottom"}

        for index = 1, 3 do
            local width = index ~= 3 and 400 or 320
            local x, y = index < 3 and 0 or 40, index < 3 and 0 or 240

            local screen = canvas.new(names[index], x, y, width, 240)
            table.insert(window.__screens, screen)
        end
    else
        local screen = canvas.new("default", 1280, 720)
        table.insert(window.__screens, screen)
    end

    local width, height = window.getWidth(), window.getHeight()
    love.window.updateMode(width * window.__scale, height * window.__scale)

    return window.__screens
end

function window.getScale()
    return window.__scale
end

function window.getWidth()
    if config.isSetTo("mode", "hac") then
        return 1280
    end
    return 400
end

function window.getHeight()
    if config.isSetTo("mode", "hac") then
        return 720
    end
    return 480
end

function window.getCanvasWidth(screen)
    if config.isSetTo("mode", "hac") then
        return window.__screens[1]:getWidth()
    end

    local index = (screen ~= "bottom" and 1) or 3
    return window.__screens[index]:getWidth()
end

-- 3DS screen heights are equal
function window.getCanvasHeight()
    return window.__screens[1]:getHeight()
end

return window
