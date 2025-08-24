function love.load()
    -- Load other modules and capture returned functions
    require("menu")
    local game = require("game")  -- Capture returned table
    require("settings")
    require("utils")
    
    -- Store game functions globally
    loadGame = game.loadGame
    updateGame = game.updateGame
    drawGame = game.drawGame
    checkGameButtons = game.checkGameButtons
    levelComplete = game.levelComplete
    
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

    camera = {
        x = 0,
        y = 0,
        scale = 1,
        -- We'll set these in loadGame based on level size
        minX = 0,
        maxX = 0,
        minY = 0,
        maxY = 0
    }
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
        elseif gameState == "game" then
            -- Delegate game button checking to game.lua
            checkGameButtons(x, y)
        end
    end
end