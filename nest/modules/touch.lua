local PATH = (...):gsub("%.modules.+", '')
local config  = require(PATH .. ".config")
local flags   = config.flags

local function translate(x, y)
    if config.hasFlag(flags.USE_HAC) then
        return false
    end

    local function inViewport(x, y)
        return x >= 40 and y >= 240
    end

    if not inViewport(x, y) then
        return false
    end

    x = math.max(0, math.min(x - 40,  320))
    y = math.max(0, math.min(y - 240, 240))
end

function love.mousepressed(x, y)
    if not translate(x, y) then
        return
    end
    love.event.push("touchpressed", 1, x, y, 0, 0, 1)
end

function love.mousemoved(x, y, dx, dy)
    if not translate(x, y) then
        return
    end
    love.event.push("touchmoved", 1, x, y, dx, dy, 1)
end

function love.mousereleased(x, y)
    if not translate(x, y) then
        return
    end
    love.event.push("touchreleased", 1, x, y, 0, 0, 1)
end