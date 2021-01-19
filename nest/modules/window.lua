local PATH = (...):gsub("%.modules.+", '')
local utility = require(PATH .. ".utility")

local config  = require(PATH .. ".config")
local flags = config.flags

local Window = {}
Window.__mt =
{
    __index = Window,
    __isSet = false,
    __list  = {},
    __scale = 1
}

local function resize(position, size)
    local scale = 1
    if config.hasFlag(flags.USE_CTR_WITH_SCALE_2X) then
        scale = 2
    end

    for index, value in ipairs(position) do
        position[index] = value * scale
    end

    for index, value in ipairs(size) do
        size[index] = value * scale
    end

    return scale
end

function Window.new(position, size, name, offset)
    Window.__scale = resize(position, size)

    local window = setmetatable({
        position = position,
        size     = size,
        canvas = love.graphics.newCanvas(unpack(size)),
        name   = name or "default",
        offset = offset or nil
    }, Window.__mt)

    if not Window.__isSet then
        local width, height = unpack(size)
        if config.hasFlag(config.flags.USE_CTR) then
            height = height * 2
        end

        Window.__isSet = love.window.updateMode(width, height)
    end

    return window
end

-- Window Sizing --

function Window.allocScreens(which)
    Window.__list = {}

    local sizes = config.windowSizes[which]

    for _, args in ipairs(sizes) do
        local position, size, name, offset = unpack(args)
        table.insert(Window.__list, Window(position, size, name, offset))
    end

    return Window.__list
end

-- Other

function Window.getWidth(name)
    if config.hasFlag(config.flags.USE_HAC) then
        return Window.__list[1].canvas:getWidth()
    else
        if utility.find({"top", "left", "right"}, name) then
            return Window.__list[1].canvas:getWidth()
        end
        return Window.__list[2].canvas:getWidth()
    end
end

function Window.getHeight()
    -- constant
    return Window.__list[1].canvas:getHeight()
end

-- Class stuff

function Window:renderTo(func)
    if self.name == "right" then
        return
    end

    self.canvas:renderTo(func)
end

function Window:draw()
    if self.name == "right" then
        return
    end

    local x, y = unpack(self.position)
    love.graphics.draw(self.canvas, x, y)
end

return setmetatable(Window, {
    __call = function(_, ...)
       return Window.new(...)
    end,
})