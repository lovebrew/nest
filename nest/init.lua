local PATH = (...):gsub('%.init$', '')

local nest =
{
    _VERSION     = "0.3.1",
    _DESCRIPTION = "LÖVE Potion Compatabiility Layer library",
    _LICENSE     = [[
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
    function nest:init()
        -- stubbed
    end

    return
end

-- config flags
local config = require(PATH .. ".config")
local title = "Nintendo %s (nëst %s)"

nest._require = function(name, ...)
    name = string.format("%s.%s", PATH, name)
    local chunk = require(name)

    local args = { ... }
    return chunk(unpack(args))
end

function nest:init(...)
    config.set(...)

    love._console_name = (config.isSetTo("mode", "ctr")) and "3DS" or "Switch"

    local screens = require(PATH .. ".modules")
    love.run = nest._require("runner", screens)

    local windowTitle = title:format(love._console_name, nest._VERSION)
    love.window.setTitle(windowTitle)
end

return nest
