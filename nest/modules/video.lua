local path = (...):gsub("%.modules.+", "")
local assert = require(path .. ".libraries.assert")
local framebuffer = require(path .. ".classes.framebuffer")
local config = require(path .. ".config")

local data = require(path .. ".data.screens")

local video = {}
video._framebuffers = {}
video._toggleView = false

video._switchViews = { "undocked", "docked" }
video._switchViewIndex = 1

-- Credit: https://shorturl.at/pqCR7
local function find_max(items, f)
    local current_max = -math.huge

    for i = 1, #items do
        local e = items[i]
        local v = f(e, i)
        if v and v > current_max then
            current_max = v
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
        table.insert(video._framebuffers, framebuffer("left",   { size = info.left                       }))
        table.insert(video._framebuffers, framebuffer("right",  { size = info.right                      }))
        table.insert(video._framebuffers, framebuffer("bottom", { size = info.bottom, offset = {40, 240} }))
    elseif console == "switch" then
        local mode = (extra.docked and "docked" or "undocked")
        video._toggleView = extra.docked

        table.insert(video._framebuffers, framebuffer("default", { size = info.default[mode], extra = { mode = mode } }))
    elseif console == "wii u" then
        table.insert(video._framebuffers, framebuffer("tv",      { size = info.tv[extra.mode] }))
        table.insert(video._framebuffers, framebuffer("gamepad", { size = info.gamepad        }))
    end

    local window_width = find_max(video._framebuffers, framebuffer.getWidth)
    local window_height = find_max(video._framebuffers, framebuffer.getHeight)

    if console == "3ds" then
        window_height = window_height * 2
    end

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

local valid_console_input = {
    ["3ds"]    = false,
    ["switch"] = true,
    ["wii u"]  = true
}

function video.keypressed(key)
    if not valid_console_input[config.get("console")] then
        return
    end

    local console = config.get("console")
    local binding = config.getKeybinding(key)

    if not binding then
        return
    end

    local is_button, pressed = binding[1], binding[2]

    if is_button and pressed.value == "special" then
        video._toggleView = not video._toggleView
        video._switchViewIndex = video._toggleView and 2 or 1

        local current_framebuffer = video._framebuffers[1]

        if console == "switch" then
            local mode = video._switchViews[video._switchViewIndex]
            video._framebuffers[1]:refresh(unpack(data[console].default[mode]))
        else
            for index = 1, #video._framebuffers do
                video._framebuffers[index]:toggle()
            end
            current_framebuffer = video._framebuffers[video._switchViewIndex]
        end

        local width, height = current_framebuffer:getWidth(), current_framebuffer:getHeight()
        love.window.updateMode(width, height, {})
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

local originalSetCanvas = love.graphics.setCanvas
local lastScreenCanvas = nil
function love.graphics.setCanvas(...)
    local arg = { ... }

    if #arg == 1 then
        lastScreenCanvas = arg[1] -- Store the current screens canvas, as to be restored in a later call
    end

    if #arg == 0 and lastScreenCanvas then
        -- Restore the last screens canvas
        originalSetCanvas(lastScreenCanvas)
    else
        -- Nothing to restore, just call the original setCanvas with the args provided
        originalSetCanvas(unpack(arg))
    end
end

return video
