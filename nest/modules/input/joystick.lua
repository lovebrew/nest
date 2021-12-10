local path = (...):gsub('%.modules.+', '')

local joystick = {}
local keyboard = {}
local bindings = {}

function keyboard.init()
    local bindings = require(path .. ".bindings")

    for key, value in pairs(bindings.buttons) do
        bindings[value] = key
    end

    for key, value in pairs(bindings.axes) do
        bindings[value] = key
    end
end

local function parseGamepadAxis(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)

    str:gsub(pattern, function(c)
        fields[#fields + 1] = c
    end)

    return fields
end

love.keyboard.setKeyRepeat(true)

function love.keypressed(key, _, isRepeat)
    if not bindings[key] then
        return
    end

    local output = bindings[key]

    if type(output) == "table" then
        local info = parseGamepadAxis(output)
        local which, value = info[1], 1.0
        if info[2] == "neg" then
            value = -value
        end

        love.handlers.gamepadaxis(joystick, which, value)
    else
        if not isRepeat then
            love.event.push("gamepadpressed", joystick, output)
        end
    end
end

function love.keyreleased(key)
    if not bindings[key] then
        return
    end

    local output = bindings[key]

    if output:find(":") then
        local info = parseGamepadAxis(output)
        local which, _ = unpack(info)

        love.handlers.gamepadaxis(joystick, which, 0.0)
    else
        love.event.push("gamepadreleased", joystick, output)
    end
end

return keyboard
