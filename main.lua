function love.load()
    -- Load other modules
    require("menu")
    require("game")
    require("settings")
    require("utils")
    
    -- Game state management
    gameState = "menu"  -- Can be: "menu", "game", "settings"
    currentLevel = 1    -- Track current level
    
    -- Initialize player settings
    playerSettings = {
        color = {1, 1, 1},
        selectedColorIndex = 1
    }

    -- Load fonts
    font = love.graphics.newFont(24)
    smallFont = love.graphics.newFont(18)
    
    -- Initialize menus
    initMenu()
    initSettings()
end

function love.update(dt)
    if gameState == "game" then
        updateGame(dt)
    end
    -- Menu and settings don't need continuous updates
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.3) -- Dark blue background

    if gameState == "menu" then
        drawMenu()
    elseif gameState == "game" then
        drawGame()
    elseif gameState == "settings" then
        drawSettings()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        if gameState == "menu" then
            checkMenuButtons(x, y)
        elseif gameState == "settings" then
            checkSettingsButtons(x, y)
            checkColorOptions(x, y)
        end
    end
end