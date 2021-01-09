local PATH = (...):gsub('%.[^%.]+$', '')
local Enum = require(PATH .. ".enum.enum")

local Window = {}
Window.__mt =
{
    __index  = Window,
    __isSet  = false,
    __config = nil
}

function Window.new(position, size, name, offset)
    local window = setmetatable({
        position = position,
        size     = size,
        canvas = love.graphics.newCanvas(unpack(size)),
        name   = name or "default",
        offset = offset or nil
    }, Window.__mt)

    if not Window.__isSet then
        local width, height = unpack(size)
        if Window.__config == "ctr" then
            height = height * 2
        end
        Window.__isSet = love.window.updateMode(width, height)
    end

    return window
end

-- Window Sizing --

local enums = Enum("ctr", "hac")

local sizes = {}

sizes.ctr =
{
    { {0,  0  }, {400, 240}, "top",    nil         },
    { {40, 240}, {320, 240}, "bottom", { 40, 240 } }
}

sizes.hac =
{
    { {0, 0}, {1280, 720}, nil, nil }
}

function Window.allocScreens(console)
    local out = {}

    local which = enums[console]
    Window.__config = console

    for _, args in ipairs(sizes[which]) do
        local position, size, name, offset = unpack(args)
        table.insert(out, Window(position, size, name, offset))
    end

    return out
end

-- Class stuff

function Window:renderTo(func)
    return self.canvas:renderTo(func)
end

function Window:draw()
    local x, y = unpack(self.position)
    love.graphics.draw(self.canvas, x, y)
end

return setmetatable(Window, {
    __call = function(_, ...)
       return Window.new(...)
    end,
})