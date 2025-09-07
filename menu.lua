-- Initialize player name if it doesn't exist
if not playerName then
    playerName = "Player"
end

function initMenu()
    menuButtons = {
        {
            text = "Start Game",
            x = 200,
            y = 150,
            width = 200,
            height = 50,
            action = function() 
                loadGame() 
                gameState = "game" 
            end
        },
        {
            text = "Leaderboard",
            x = 200,
            y = 250,
            width = 200,
            height = 50,
            action = function() gameState = "leaderboard" end
        },
        {
            text = "Settings",
            x = 200,
            y = 350,
            width = 200,
            height = 50,
            action = function() gameState = "settings" end
        },
        {
            text = "Quit",
            x = 200,
            y = 450,
            width = 200,
            height = 50,
            action = function() love.event.quit() end
        }
    }
end

function drawMenu()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Platformer Game", 0, 50, love.graphics.getWidth(), "center")
    
    -- Draw current player name
    love.graphics.setFont(smallFont)
    love.graphics.printf("Playing as: " .. playerName, 0, 100, love.graphics.getWidth(), "center")
    
    -- Draw menu buttons
    for i, button in ipairs(menuButtons) do
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        love.graphics.printf(button.text, button.x, button.y + 10, button.width, "center")
    end
end

function checkMenuButtons(x, y)
    for i, button in ipairs(menuButtons) do
        if x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height then
            button.action()
            return
        end
    end
end