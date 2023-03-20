require("nest"):init({ console = "3ds" })

local canvas = nil
function love.load()
    love.graphics.setBackgroundColor(1, 0, 0)
    canvas = love.graphics.newCanvas(200, 120)
end

function love.draw(screen)
    love.graphics.setCanvas(canvas)
    love.graphics.rectangle("fill", 50, 30, 100, 60)
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 100, 60)
    love.graphics.rectangle("line", 100, 60, 200, 120)
end

function love.gamepadpressed(_, button)
    print(button)
end

function love.gamepadaxis(_, axis, value)
    print(axis, value)
end
