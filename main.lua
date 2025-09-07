function love.load()
    -- Load other modules and capture returned functions
    require("menu")
    local game = require("game")  -- Capture returned table
    require("settings")
    require("utils")
    require("leaderboard")
    
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
    
    -- Initialize menus and game components
    initMenu()
    initSettings()
    initLeaderboard()

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
    elseif gameState == "leaderboard" then
        drawLeaderboard()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        if gameState == "menu" then
            checkMenuButtons(x, y)
        elseif gameState == "settings" then
            -- Check if clicking on name input
            if x >= nameInput.x and x <= nameInput.x + nameInput.width and
               y >= nameInput.y and y <= nameInput.y + nameInput.height then
                nameInput.active = true
            else
                nameInput.active = false
                playerName = nameInput.text  -- Save name when clicking away
            end
            
            checkSettingsButtons(x, y)
            checkColorOptions(x, y)
        elseif gameState == "game" then
            -- Delegate game button checking to game.lua
            checkGameButtons(x, y)
        elseif gameState == "leaderboard" then
            checkLeaderboardButtons(x, y)
        end
    end
end

function love.textinput(text)
    if gameState == "settings" and nameInput.active then
        if #nameInput.text < 15 then  -- Limit name length
            nameInput.text = nameInput.text .. text
            playerName = nameInput.text
        end
    end
end

function love.keypressed(key)
    if gameState == "settings" and nameInput.active then
        if key == "backspace" then
            nameInput.text = string.sub(nameInput.text, 1, -2)
            playerName = nameInput.text
        elseif key == "return" or key == "escape" then
            nameInput.active = false
            playerName = nameInput.text
        end
    end
end