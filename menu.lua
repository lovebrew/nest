local menu = {}

function menu:init()
    local rand = love.math.random
    love.math.setRandomSeed(os.time())

    love.graphics.setBackgroundColor(rand(), rand(), rand())
end

function menu:draw_top()
    love.graphics.print("AYY LMAO")
end

function menu:draw_bottom()
    love.graphics.print("Test down here!")
end

return menu
