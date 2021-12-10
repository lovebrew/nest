local path = (...):gsub("%.modules.+", '')

local config = require(path .. ".config")
local window = require(path .. ".modules.renderer.window")

local function translate(x, y)
    local result = {x = x, y = y}

    if config.isSetTo("mode", "hac") then
        return result
    end

    local scale = config.get("scale")
    local function inViewport(_x, _y)
        return _x >= 40 * scale and _y >= 240 * scale
    end

    if not inViewport(x, y) then
        return false
    end

    local maxWidth  = window.getWidth("bottom")
    local maxHeight = window.getHeight()

    local maxScaledWidth  = maxWidth  * scale
    local maxScaledHeight = maxHeight * scale

    local widthOffset  = 40 * scale
    local heightOffset = 240 * scale

    result.x = math.floor(math.max(0, math.min((x - widthOffset)  / maxScaledWidth,  1)) * maxWidth)
    result.y = math.floor(math.max(0, math.min((y - heightOffset) / maxScaledHeight, 1)) * maxHeight)

    return result
end

local touching = false

local function pushEvent(event, translate, dx, dy, pressure)
    if translate then
        love.event.push(event, 1, translate.x, translate.y, dx, dy, pressure)
    end
end

function love.mousepressed(x, y)
    local result = translate(x, y)
    pushEvent("touchpressed", result, 0, 0, 1)
    touching = true
end

function love.mousemoved(x, y, dx, dy)
    if not touching then
        return
    end

    local result = translate(x, y)
    pushEvent("touchmoved", result, dx, dy, 1)
end

function love.mousereleased(x, y)
    if touching then
        local result = translate(x, y)
        pushEvent("touchreleased", result, 0, 0, 0)
        touching = false
    end
end
