local config = {}

local flags = {}

flags.mode = ""
flags.emulateJoystick = false
flags.scale = 1

local modes = {"ctr", "hac"}
local scales = {1, 2}

local function find(table, what)
    for _, value in pairs(table) do
        if value == what then
            return true
        end
    end
    return false
end

function config.set(...)
    local args = {...}
    if type(...) == "table" then
        args = ...
    end

    if args.mode == "" then
        error("Configuration must have a mode! Expected 'ctr' or 'hac', got " .. tostring(args.mode))
    end

    local pass = true
    for key, value in pairs(args) do
        if config.validate(key, value) == true then
            flags[key] = value
        else
            pass = false
            break
        end
    end

    if not pass then
        error("Invalid config was set.")
    end
end

function config.isSet(key)
    if key == "mode" then
        return flags.mode ~= ""
    elseif key == "emulateJoystick" then
        return flags.emulateJoystick == true
    elseif key == "scale" then
        return flags.scale > 0 and flags.scale < 3
    end
end

function config.get(key)
    if config.isSet(key) then
        return flags[key]
    end
    return nil
end

function config.isSetTo(key, value)
    return config.get(key) == value
end

function config.validate(key, value)
    if key == "mode" then
        return find(modes, value)
    elseif key == "emulateJoystick" then
        return type(value) == "boolean"
    elseif key == "scale" then
        local isNumber = type(value) == "number"
        return isNumber and find(scales, value)
    end
end

return config
