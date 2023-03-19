local path = (...):gsub("%.classes.+", "")
local assert = require(path .. ".libraries.assert")

local framebuffer = {}
framebuffer.__index = framebuffer

---Creates a new framebuffer (love.Canvas) wrapper object
---@param name string name of the screen
---@param dimensions { [1]: integer, [2]: integer }
---@param offset { [1]: integer, [2]: integer }
---@return table
function framebuffer.new(name, dimensions, offset)
    local instance = setmetatable({}, framebuffer)

    instance.name = name
    instance.width, instance.height = unpack(dimensions)
    instance.x_offset, instance.y_offset = unpack(offset or {0, 0})

    instance.hidden = (name == "right") or (name == "gamepad")

    instance.canvas = love.graphics.newCanvas(instance.width, instance.height)

    return instance
end

---Renders to the love.Canvas
---@param render_func function
function framebuffer:renderTo(render_func)
    self.canvas:renderTo(assert:type(render_func, "function"))
end

---Draws the love.Canvas
function framebuffer:draw()
    if self.hidden then
        return
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, self.x_offset, self.y_offset)
    love.graphics.rectangle("line", self.x_offset, self.y_offset, self.width, self.height)
end

function framebuffer:toggle()
    self.hidden = not self.hidden
end

---Get the name of this framebuffer
---@return string name
function framebuffer:getName()
    return self.name
end

---Get the width of this framebuffer
---@return integer
function framebuffer:getWidth()
    return self.width
end

---Get the height of this framebuffer
---@return integer height
function framebuffer:getHeight()
    return self.height
end

---Gets the dimensions of this framebuffer
---@return integer width
---@return integer height
function framebuffer:getDimensions()
    return self.width, self.height
end

return setmetatable(framebuffer, {
    __call = function(self, name, dimensions, offset)
        return framebuffer.new(name, dimensions, offset)
    end,
})
