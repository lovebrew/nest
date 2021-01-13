---
-- @module config

local bit = require("bit")

local PATH    = (...):gsub('%.[^%.]+$', '')
local utility = require(PATH .. ".utility")

local config = {}

local flags  = {}

-- base flags, empty
flags.base = 0

-- Available flags list

-- Enable Nintendo Switch // 1
flags.USE_HAC = bit.lshift(1, 0)
--< Enable Nintendo 3DS // 2
flags.USE_CTR = bit.lshift(1, 1)
--< Internal; Checks for either console // 3
flags.HORIZON = bit.bor(flags.USE_CTR, flags.USE_HAC)
--< Internal; Use Keyboard input // 4
flags.USE_KEYBOARD_AS_GAMEPAD = bit.lshift(1, 2)
--< Use Keyboard input on Switch // 5
flags.USE_HAC_WITH_KEYBOARD = bit.bor(flags.USE_HAC, flags.USE_KEYBOARD_AS_GAMEPAD)
--< Use Keyboard input on 3DS // 6
flags.USE_CTR_WITH_KEYBOARD = bit.bor(flags.USE_CTR, flags.USE_KEYBOARD_AS_GAMEPAD)
--< Use 2x Scaling // 8
flags.USE_SCALE_2X = bit.lshift(1, 3)
--< Use 3DS with x2 Scaling // 10
flags.USE_CTR_WITH_SCALE_2X = bit.bor(flags.USE_CTR, flags.USE_SCALE_2X)
--< Use 3DS with x2 Scaling and Keyboard input
flags.USE_CTR_WITH_SCALE_2X_AND_KEYBOARD = bit.bor(flags.USE_SCALE_2X, flags.USE_CTR_WITH_KEYBOARD)

-- Available window sizes

local windowSizes = {}

windowSizes[flags.USE_HAC] = {}
windowSizes[flags.USE_CTR] = {}

local function map(t, values)
    for _, value in ipairs(values) do
        table.insert(t, value)
    end
end

local ctrMapping =
{
    { {0,  0  }, {400, 240}, "left",     nil       },
    { {0,  0  }, {400, 240}, "right",    nil       },
    { {40, 240}, {320, 240}, "bottom", { 40, 240 } }
}

map(windowSizes[flags.USE_CTR], ctrMapping)

local hacMapping =
{
    { {0, 0}, {1280, 720}, nil, nil }
}

map(windowSizes[flags.USE_HAC], hacMapping)

config.flags = flags
config.windowSizes = windowSizes

-- Add flags to the base config
function config.addFlags(...)
    local add = {...}

    assert(#add > 0, "Cannot append zero or nil flags")

    local success, typename = utility.any(add, "number")
    assert(success, string.format("Number expected, got %s", typename))

    flags.base = bit.bor(unpack(add))

    -- make sure we don't enable both consoles
    if config.hasFlag(flags.HORIZON) then
        error("Cannot set both USE_HAC and USE_CTR flags.")
    end
end

-- Join arbitrary flags together
function config.joinFlags(...)
    local add = {...}

    assert(#add > 0, "Cannot append zero or nil flags")

    local success, typename = utility.any(add, "number")
    assert(success, string.format("Number expected, got %s", typename))

    local out = bit.bor(unpack(add))

    return out
end

-- Remove flags
function config.removeFlags(...)
    local args = {...}

    -- use ipairs for explicit logic
    for _, value in ipairs(args) do
        flags.base = bit.band(flags.base, bit.bnot(value))
    end
end

-- Check if flags are empty (zero)
function config.areEmpty()
    return flags.base == 0
end

-- Return the current flags
function config.getFlags()
    return flags.base
end

-- Check if we have a
-- specific flag set
function config.hasFlag(flag)
    return bit.band(flags.base, flag) == flag
end

-- Get which flag is used
-- @flags should be bor'd already
-- Returns the value of the flag
function config.whichFlag(borFlags)
    return bit.band(flags.base, borFlags)
end

return config