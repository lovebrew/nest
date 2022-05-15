local path = (...):gsub('%.modules$', '')
local config = require(path .. ".config")

-- overrides n stuff
require(path .. ".modules.input.touch")
if config.isSet("emulateJoystick") then
    require(path .. ".modules.input.joystick").init()
end
require(path .. ".modules.input.keyboard")

require(path .. ".modules.renderer.graphics")

local emulationMode = config.get("mode")
return require(path .. ".modules.renderer.window").init(emulationMode)
