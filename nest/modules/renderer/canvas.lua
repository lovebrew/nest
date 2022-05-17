local canvas = {}
canvas.__index = canvas

function canvas.new(name, x, y, width, height)
    local self = setmetatable({}, canvas)

    self.position = {x, y}

    self.target = love.graphics.newCanvas(width, height)
    self.name   = name

    return self
end

function canvas:renderTo(func)
    if self.name == "right" then
        return
    end

    self.target:renderTo(func)
end

function canvas:draw()
    if self.name == "right" then
        return
    end

    local x, y = unpack(self.position)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.target, x, y)
end

function canvas:getWidth()
    return self.target:getWidth()
end

function canvas:getHeight()
    return self.target:getHeight()
end

return canvas
