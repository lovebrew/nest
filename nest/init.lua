local PATH = (...):gsub('%.init$', '')

local hook  = require(PATH .. ".libs.hook")

local nest =
{
    _VERSION     = "0.1.0",
    _DESCRIPTION = "Löve Potion Compatabiility Layer library",
    _LICENSE     =
    [[
        MIT LICENSE

        Copyright (c) 2020 Jeremy S. Postelnek / TurtleP

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
}

--- Load the device to use.
--- @param device {string}: ctr for 3DS, nx for Switch
nest.init = function(device)
    -- make sure we're not already
    -- running under homebrew!
    if love._console_name then
        return
    end

    assert(device ~= nil, "Bad argument #1 to init: string expected, got " .. tostring(device))
    assert(device:match("ctr") or device:match("nx"), "Invalid device " .. device .. " expected 'ctr' or 'nx'")

    -- override the LÖVE variables
    -- don't actually do this other people
    -- this is dangerous and not recommended!
    love._os = "Horizon"
    love._console_name = (device == "ctr" and "3DS") or "Switch"
    love._potion_version = "2.0.0"

    -- format a path to the appropriate device folder
    local module_folder = string.format("%s.%s", PATH, device)
    local dimensions = require(module_folder)

    love.window.updateMode(unpack(dimensions))

    nest._setupControls()

    love.run = require(PATH .. ".run")
end

--- Sets up keybindings to be used as Gamepad callbacks
--- WARNING: Internal function - DO NOT USE
function nest._setupControls()
    nest.controls = require(PATH .. ".hid")

    local function format(str, ...)
        return string.format(str, ...)
    end

    local function parseGamepadAxis(str)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        str:gsub(pattern, function(c) fields[#fields + 1] = c end)
        return fields
    end

    -- these have to be defined or we can't overload them
    function love.keypressed(key, scancode, isrepeat)
    end

    function love.keyreleased(key, scancode, isrepeat)
    end

    function love.mousepressed(x, y, button, istouch)
    end

    function love.mousereleased(x, y, button, istouch)
    end

    function love.mousemoved(x, y, dx, dy, istouch)
    end

    local joystick = love.joystick.getJoysticks()[1] or {}
    love.keyboard.setKeyRepeat(true)

    -- GAMEPAD CALLBACKS

    function nest._keypressed(key, scancode, isrepeat)
        if not nest.controls[key] then
            return
        end

        if nest.controls[key]:find(":") then
            local info = parseGamepadAxis(nest.controls[key])
            local which, value = unpack(info)

            love.event.push("gamepadaxis", joystick, which, value)
        else
            if not isrepeat then
                love.event.push("gamepadpressed", joystick, nest.controls[key])
            end
        end
    end

    function nest._keyreleased(key)
        if nest.controls[key] then
            love.event.push("gamepadreleased", joystick, nest.controls[key])
        end
    end

    -- TOUCH CALLBACKS

    local isDown = false
    local function translateCoords(x, y)
        if (x < 40 or x > 360) or y < 240 then
            isDown = false
            return false
        end

        x = math.max(0, math.min(x - 40, 320))
        y = math.max(0, math.min(y - 240, 240))

        return x, y
    end

    function nest._touchpressed(x, y)
        x, y = translateCoords(x, y)

        if x and y then
            love.event.push("touchpressed", 1, x, y, 0, 0, 1)
            isDown = true
        end
    end

    function nest._touchreleased(x, y)
        x, y = translateCoords(x, y)

        if x and y then
            love.event.push("touchpressed", 1, x, y, 0, 0, 1)
            isDown = false
        end
    end

    function nest._touchmoved(x, y, dx, dy)
        x, y = translateCoords(x, y)

        if x and y and isDown then
            love.event.push("touchmoved", 1, x, y, dx, dy, 1)
        end
    end

    love.keypressed  = hook.add(love.keypressed,  nest._keypressed)
    love.keyreleased = hook.add(love.keyreleased, nest._keyreleased)

    love.mousepressed  = hook.add(love.mousepressed,  nest._touchpressed)
    love.mousereleased = hook.add(love.mousereleased, nest._touchreleased)
    love.mousemoved    = hook.add(love.mousemoved,    nest._touchmoved)
end

return nest
