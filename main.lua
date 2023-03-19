require("nest"):init({ console = "cafe" })

function love.load()
    love.graphics.setBackgroundColor(1, 0, 0)
end

function love.draw(screen)
    if screen == "tv" then
        love.graphics.rectangle("fill", 300, 300 + math.sin(love.timer.getTime() * 2) * 4, 64, 64)
    end
    love.graphics.circle("fill", 400, 400, 6)
end

function love.gamepadpressed(_, button)
    print(button)
end

function love.gamepadaxis(_, axis, value)
    print(axis, value)
end
