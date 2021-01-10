local bindings =
{
    a = "a",
    s = "b",
    z = "x",
    x = "y",

    m = "start",
    n = "back",

    f = "dpleft",
    h = "dpright",
    t = "dpup",
    g = "dpdown",

    q = "leftshoulder",
    w = "rightshoulder",

    left = "leftx:-1",
    right = "leftx:1",
    up = "lefty:-1",
    down = "lefty:1",

    j = "rightx:-1",
    l = "rightx:1",
    i = "righty:-1",
    k = "righty:1",

    ["1"] = "triggerleft:1",
    ["2"] = "triggerright:1"
}

if not love.filesystem.getInfo("boot.nest") then
    local notice = [[
    Using the love.keyboard callbacks will result in the
    gamepad callbacks having empty tables for the joystick
    parameter.

    Press OK to continue.
    ]]

    love.window.showMessageBox("nëst", notice, "info")
    love.filesystem.write("boot.nest", "")
end

local joystick = {}

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

    if output:find(":") then
        local info = parseGamepadAxis(output)
        local which, value = info[1], tonumber(info[2])

        love.event.push("gamepadaxis", joystick, which, value)
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

        love.event.push("gamepadaxis", joystick, which, 0.0)
    else
        love.event.push("gamepadreleased", joystick, output)
    end
end