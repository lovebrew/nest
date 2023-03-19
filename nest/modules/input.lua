local path = (...):gsub("%.modules.+", "")
local config = require(path .. ".config")

local input = {}

----
--- Keyboard/Joystick input
----

function input.keypressed(key)
    local binding = config.getKeybinding(key)

    if not binding or binding[2].value == "gamepadview" then
        return
    end

    local is_button, pressed = binding[1], binding[2]

    if is_button then
        return love.event.push("gamepadpressed", {}, pressed.value)
    end
    love.event.push("gamepadaxis", {}, pressed.axis, tonumber(pressed.direction .. "1"))
end

function input.keyreleased(key)
    local binding = config.getKeybinding(key)

    if not binding or binding[2].value == "gamepadview" then
        return
    end

    local is_button, released = binding[1], binding[2]

    if is_button then
        return love.event.push("gamepadreleased", {}, released.value)
    end
    love.event.push("gamepadaxis", {}, released.axis, 0)
end

----
--- Touch input
----

local love_events = { "keypressed", "keyreleased" }
local registry = {}

-- hook into love events we want
for _, callback in ipairs(love_events) do
    registry[callback] = love[callback] or function () end
    love[callback] = function(...)
        registry[callback](...)
        input[callback](...)
    end
end
