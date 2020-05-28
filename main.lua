local nest = require('nest').init("ctr")

menu = require 'menu'

function love.load()
    menu:init()
end

-- On 3DS we can check for a specific screen
-- to render to so that it's not double rendering
function love.draw(screen)
    menu["draw_" .. screen](menu)
end

function love.update(dt)

end

function love.gamepadpressed(joystick, button)
    menu:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)

end

function love.gamepadaxis(joystick, axis, value)
    print(axis, value)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    print(id, x, y, dx, dy, pressure)
end
