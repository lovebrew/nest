return function(windows)
    local screens = windows

    if love.load then
        love.load(arg)
    end

    if love.timer then
        love.timer.step()
    end

    local delta = 0

    return function()
        if love.event and love.event.pump then
            love.event.pump()

            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end

                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            delta = love.timer.step()
        end

        if love.update then
            love.update(delta)
        end

        if love.graphics then
            love.graphics.origin()

            for _, screen in ipairs(screens) do
                love.graphics.setActiveScreen(screen.name)
                screen:renderTo(function()
                    love.graphics.clear(love.graphics.getBackgroundColor())

                    if love.draw then
                        love.draw(screen)
                    end
                end)

                screen:draw()
            end

            love.graphics.present()
        end

        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end