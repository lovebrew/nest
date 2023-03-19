local config = {}

local flags = {}

config._console = ""
config._scale = 1

local modes = { ["3ds"] = "ctr",["switch"] = "hac",["wiiu"] = "cafe" }
local scales = { 1, 2 }

local function find_match(t, f)
    for key, value in pairs(t) do
        if f(value) then
            return value
        end
    end
    return nil
end

local function round(v)
    if v < 0 then
        return math.ceil(v - 0.5)
    end
    return math.floor(v + 0.5)
end

local function clamp(value, low, high)
    value = round(value)
    return math.max(low, math.min(value, high))
end

function config.set(args)
    config._scale = clamp(args.scale or 1, 1, 3)
end

return config
