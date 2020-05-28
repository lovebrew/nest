window = {}
window.size = {1280, 720}

love.graphics.getDimensions = function()
    return window.size[1], window.size[2]
end

love.graphics.getWidth = function()
    return window.size[1]
end

love.graphics.getHeight = function()
    return window.size[2]
end

return window.size
