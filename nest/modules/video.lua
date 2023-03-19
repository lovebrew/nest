local path = (...):gsub("%.modules.+", "")
local assert = require(path .. ".libraries.assert")
local framebuffer = require(path .. ".classes.framebuffer")
local config = require(path .. ".config")

local data = require(path .. ".data.screens")

local video = {}
video._framebuffers = {}
video._drawGamepad = false

local function find_max(items, f)
    local current = nil
    local current_max = -math.huge

    for i = 1, #items do
        local e = items[i]
        local v = f(e, i)
        if v and v > current_max then
            current_max = v
            current = e
        end
    end
    return current_max
end

---Initializes the video module
---@param console string name of the console
---@param extra table extra data for the framebuffer information
function video.init(console, extra)
    local info = assert:some(data[console], "No screen info was found for the given console")

    if console == "3ds" then
    elseif console == "switch" then
    elseif console == "wii u" then
        table.insert(video._framebuffers, framebuffer("tv", info.tv[extra.mode]))
        table.insert(video._framebuffers, framebuffer("gamepad", info.gamepad, { 0, 0 }))
    end

    local window_width = find_max(video._framebuffers, framebuffer.getWidth)
    local window_height = find_max(video._framebuffers, framebuffer.getHeight)

    love.window.updateMode(window_width, window_height, {})
end

---Gets the framebuffers in the video module
---@return table
function video.getFramebuffers()
    return video._framebuffers
end

----
--- love overrides
----

function video.keypressed(key)
    if config.get("console") ~= "wii u" then
        return
    end

    local binding = config.getKeybinding(key)

    if not binding then
        return
    end

    local is_button, pressed = binding[1], binding[2]

    if is_button and pressed.value == "gamepadview" then
        video._drawGamepad = not video._drawGamepad

        for index = 1, #video._framebuffers do
            video._framebuffers[index]:toggle()
        end

        local index = video._drawGamepad and 2 or 1
        love.window.updateMode(video._framebuffers[index]:getWidth(), video._framebuffers[index]:getHeight(), {})
    end
end

local love_events = { "keypressed" }
local registry = {}

-- hook into love events we want
for _, callback in ipairs(love_events) do
    registry[callback] = love[callback] or function () end
    love[callback] = function(...)
        registry[callback](...)
        video[callback](...)
    end
end

local active_screen = nil
function love.graphics.setActiveScreen(screen)
    active_screen = screen
end

function love.graphics.getActiveScreen()
    return active_screen
end

return video
