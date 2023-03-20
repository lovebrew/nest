local path = (...):gsub("%.classes.+", "")
local assert = require(path .. ".libraries.assert")

local framebuffer = {}
framebuffer.__index = framebuffer

---Creates a new framebuffer (love.Canvas) wrapper object
---@param name string name of the screen
---@param config { size: { [1]: integer, [2]: integer }, offset: { [1]: integer, [2]: integer }, scale: integer, extra: table }
---@return table
function framebuffer.new(name, config)
    local instance = setmetatable({}, framebuffer)

    instance.name = name
    instance.width, instance.height = unpack(assert:some(config.size))

    instance.x_offset, instance.y_offset = 0, 0
    if config.offset then
        instance.x_offset, instance.y_offset = unpack(config.offset)
    end

    instance.hidden = (name == "right") or (name == "gamepad")
    instance.extra = config.extra

    instance.scale = config.scale or 1
    instance.canvas = love.graphics.newCanvas(instance.width, instance.height)

    return instance
end

function framebuffer:refresh(width, height)
    self.canvas = love.graphics.newCanvas(width, height)
    self.width, self.height = width, height
end

---Renders to the love.Canvas
---@param render_func function
function framebuffer:renderTo(render_func)
    if self.name == "right" then
        return
    end

    self.canvas:renderTo(assert:type(render_func, "function"))
end

---Draws the love.Canvas
function framebuffer:draw()
    if self.hidden then
        return
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, self.x_offset, self.y_offset)
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

function framebuffer:getExtra(name)
    return assert:some(self.extra[name])
end

return setmetatable(framebuffer, {
    __call = function(_, name, config)
        return framebuffer.new(name, config)
    end,
})
