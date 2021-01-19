local PATH = (...):gsub('%.init$', '')

-- overrides n stuff
local Window = require(PATH .. ".window")
require(PATH .. ".graphics")

local CONFIGPATH = PATH:gsub("%.modules$", '')
local config = require(CONFIGPATH .. ".config")
local flags = config.flags

local which = config.whichFlag(flags.HORIZON)
local screens = Window.allocScreens(which)

require(PATH .. ".touch")

if config.hasFlag(flags.USE_KEYBOARD_AS_GAMEPAD) then
    require(PATH .. ".keyboard")
end

return screens