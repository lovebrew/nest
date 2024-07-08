local nest = require("nest").init({ console = "3ds", scale = 2 })

local rect = { w = 200, h = 120 }
function love.load()

end

local function screen_depth(screen)
    local depth = screen ~= "bottom" and -love.graphics.getDepth() or 0
    if screen == "right" then
        depth = -depth
    end
    return depth
end

function love.draw(screen)
    local x = (love.graphics.getWidth(screen) - rect.w) * 0.5
    local y = (love.graphics.getHeight() - rect.h) * 0.5

    local depth = screen_depth(screen)
    love.graphics.rectangle("fill", x - (depth * 6), y, rect.w, rect.h)
    print(love.system.getPowerInfo())
end

function love.gamepadpressed(_, button)
    if button == "a" then
        nest.plug_in()
    end
end

function love.gamepadaxis(_, axis, value)
    print(axis, value)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    print(x, y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    print(x, y, dx, dy)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    print(x, y)
end
