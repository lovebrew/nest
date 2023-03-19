
-- Author: Christian Vallentin <mail@vallentinsource.com>
-- Website: http://vallentinsource.com
-- Repository: https://github.com/MrVallentin/hook.lua
--
-- Date Created: November 22, 2015
-- Last Modified: March 11, 2015
--
-- Developed and tested using Lua 5.1 and Lua 5.2

--[[
The MIT License (MIT)

Copyright (c) 2016 Christian Vallentin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


-- In Lua 5.2 unpack() was moved into the table library
local unpack = unpack or table.unpack


local hook = {}


hook._VERSION = "hook.lua 1.0"
hook._URL = "https://github.com/MrVallentin/hook.lua"


local function callhooks(hookedfunc, ...)
    local result = nil

    for i = 1, #hookedfunc.__hooks, 1 do
        result = {hookedfunc.__hooks[i](...)}

        if result ~= nil and #result > 0 then
            return unpack(result)
        end
    end

    return nil
end

local function newhook(func, hook)
    local hookedfunc = {}

    hookedfunc.__hooks = { hook }
    hookedfunc.__func = func

    setmetatable(hookedfunc, {
        __call = function(func, ...)
            local result = {callhooks(hookedfunc, ...)}

            if result ~= nil and #result > 0 then
                return unpack(result)
            end

            return hookedfunc.__func(...)
        end
    })

    return hookedfunc
end

local function addhook(func, hook)
    func.__hooks[#func.__hooks + 1] = hook

    return func
end

local function ishookedfunc(hookedfunc)
    if type(hookedfunc) == "table" then
        if type(hookedfunc.__hooks) == "table" then
            return true
        end
    end

    return false
end


function hook.add(func, hook)
    if hook == nil then
        return func
    end

    local t = type(func)

    if t == "function" then
        return newhook(func, hook)
    elseif t == "table" then
        return addhook(func, hook)
    end

    return func
end

function hook.call(hookedfunc, ...)
    if ishookedfunc(hookedfunc) then
        return callhooks(hookedfunc, ...)
    end

    return nil
end

function hook.remove(hookedfunc, hook)
    if ishookedfunc(hookedfunc) then
        for i = #hookedfunc.__hooks, 1, -1 do
            if hookedfunc.__hooks[i] == hook then
                table.remove(hookedfunc.__hooks, i)
            end
        end

        if #hookedfunc.__hooks == 0 then
            return hookedfunc.__func
        end
    end

    return hookedfunc
end

function hook.clear(hookedfunc)
    if ishookedfunc(hookedfunc) then
        hookedfunc.__hooks = {}

        return hookedfunc.__func
    end

    return hookedfunc
end

function hook.count(hookedfunc)
    if ishookedfunc(hookedfunc) then
        return #hookedfunc.__hooks
    end

    return 0
end

function hook.gethooks(hookedfunc)
    if ishookedfunc(hookedfunc) then
        local hooks = {}

        for i = 1, #hookedfunc.__hooks, 1 do
            hooks[i] = hookedfunc.__hooks[i]
        end

        return hooks
    end

    return nil
end


return hook
