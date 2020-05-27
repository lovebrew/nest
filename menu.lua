local menu = {}

function menu:init()
    local rand = love.math.random
    love.math.setRandomSeed(os.time())

    love.graphics.setBackgroundColor(rand(), rand(), rand())

    self.x = 0
    self.y = 0
end

function menu:draw_top()
    love.graphics.print("AYY LMAO")

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 100, 100, 60, 50)
end

function menu:draw_bottom()
    love.graphics.print("Test down here!", self.x, self.y)
end

function menu:gamepadpressed(joy, button)
    if button == "dpright" then
        self.x = self.x + 1
    elseif button == "dpleft" then
        self.x = self.x - 1
    end
end

return menu
