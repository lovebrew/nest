local path = (...):gsub('%.modules$', '')

-- overrides n stuff

local windows = require(path .. ".modules.window").init()
local config  = require(path .. ".config")

require(path .. ".modules.graphics")
require(path .. ".modules.touch")

if config.get("emulateJoystick") then
    require(path .. ".modules.keyboard").init()
end

return windows
