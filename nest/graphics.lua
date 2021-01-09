local activeScreen = nil

function love.graphics.getScreens()
    return nil
end

function love.graphics.setActiveScreen(screen)
    activeScreen = screen
end

function love.graphics.getActiveScreen()
    return activeScreen
end
