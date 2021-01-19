---
-- @module nest

local PATH = (...):gsub('%.init$', '')

local nest =
{
   _VERSION     = "0.2.0",
   _DESCRIPTION = "LÖVE Potion Compatabiility Layer library",
   _LICENSE     =
   [[
       MIT LICENSE
       Copyright (c) 2020-2021 Jeremy S. Postelnek / TurtleP
       Permission is hereby granted, free of charge, to any person obtaining a
       copy of this software and associated documentation files (the
       "Software"), to deal in the Software without restriction, including
       without limitation the rights to use, copy, modify, merge, publish,
       distribute, sublicense, and/or sell copies of the Software, and to
       permit persons to whom the Software is furnished to do so, subject to
       the following conditions:
       The above copyright notice and this permission notice shall be included
       in all copies or substantial portions of the Software.
       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
       OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
       MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
       IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
       CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
       TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
       SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   ]]
}

if love._console_name then
    return
end

-- config flags
local config = require(PATH .. ".config")
local flags = config.flags

nest._require = function(name, ...)
    name = string.format("%s.%s", PATH, name)
    local chunk = require(name)

    local args = {...}
    return chunk(unpack(args))
end

nest.load = function(...)
    config.addFlags(...)

    love._console_name = config.hasFlag(flags.USE_HAC) and "Switch" or "3DS"

    local screens = require(PATH .. ".modules")
    love.run = nest._require("runner", screens)

    love.window.setTitle(string.format("Nintendo %s (nëst %s)", love._console_name, nest._VERSION))
end

nest.flags = config.flags

return nest