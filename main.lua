function love.load()
    -- Game state management
    gameState = "menu"  -- Can be: "menu", "game", "settings"
    
    -- Initialize player settings (will be used in both menu and game)
    playerSettings = {
        color = {1, 1, 1},  -- Default white color (RGB)
        selectedColorIndex = 1  -- Track which color is selected
    }

    -- Menu buttons
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
            text = "Settings",
            x = 200,
            y = 250,
            width = 200,
            height = 50,
            action = function() gameState = "settings" end
        },
        {
            text = "Quit",
            x = 200,
            y = 350,
            width = 200,
            height = 50,
            action = function() love.event.quit() end
        }
    }

    -- Settings menu color options
    colorOptions = {
        {name = "White", color = {1, 1, 1}},
        {name = "Red", color = {1, 0, 0}},
        {name = "Green", color = {0, 1, 0}},
        {name = "Blue", color = {0, 0, 1}},
        {name = "Yellow", color = {1, 1, 0}},
        {name = "Cyan", color = {0, 1, 1}},
        {name = "Magenta", color = {1, 0, 1}}
    }

    -- Settings buttons
    settingsButtons = {
        {
            text = "Back to Menu",
            x = 200,
            y = 350,
            width = 200,
            height = 50,
            action = function() gameState = "menu" end
        }
    }

    -- Load fonts
    font = love.graphics.newFont(24)
    smallFont = love.graphics.newFont(18)
end

function loadGame()
    -- Initialize our player object with properties (same as before)
    player = {
        x = 50,
        y = 50,
        width = 20,
        height = 20,
        xSpeed = 0,
        ySpeed = 0,
        maxSpeed = 200,
        acceleration = 1500,
        friction = 800,
        jumpForce = -400,
        gravity = 900,
        isGrounded = false
    }

    player.startX = player.x
    player.startY = player.y

    -- Define our platforms (x, y, width, height)
    platforms = {
        {x = 0, y = 350, width = 200, height = 20},
        {x = 250, y = 300, width = 100, height = 20},
        {x = 400, y = 250, width = 100, height = 20},
        {x = 0, y = 450, width = 600, height = 50}
    }

    -- Collision detection function
    function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
        return x1 < x2 + w2 and
               x2 < x1 + w1 and
               y1 < y2 + h2 and
               y2 < y1 + h1
    end
end

function love.update(dt)
    if gameState == "game" then
        updateGame(dt)
    end
    -- Menu and settings don't need continuous updates
end

function updateGame(dt)
    -- Get keyboard input
    local left = love.keyboard.isDown("a", "left")
    local right = love.keyboard.isDown("d", "right")
    local jump = love.keyboard.isDown("space", "w", "up")

    -- Horizontal movement with acceleration and friction
    if left then
        player.xSpeed = player.xSpeed - player.acceleration * dt
    elseif right then
        player.xSpeed = player.xSpeed + player.acceleration * dt
    else
        if player.xSpeed > 0 then
            player.xSpeed = math.max(player.xSpeed - player.friction * dt, 0)
        elseif player.xSpeed < 0 then
            player.xSpeed = math.min(player.xSpeed + player.friction * dt, 0)
        end
    end

    player.xSpeed = math.max(math.min(player.xSpeed, player.maxSpeed), -player.maxSpeed)
    local previousX = player.x
    player.x = player.x + player.xSpeed * dt

    -- Check horizontal collisions
    for i, platform in ipairs(platforms) do
        if CheckCollision(player.x, player.y, player.width, player.height, 
                         platform.x, platform.y, platform.width, platform.height) then
            if previousX + player.width <= platform.x then
                player.x = platform.x - player.width
                player.xSpeed = 0
            elseif previousX >= platform.x + platform.width then
                player.x = platform.x + platform.width
                player.xSpeed = 0
            end
        end
    end

    -- Apply gravity and vertical movement
    player.ySpeed = player.ySpeed + player.gravity * dt
    local previousY = player.y
    player.y = player.y + player.ySpeed * dt
    player.isGrounded = false

    -- Check vertical collisions
    for i, platform in ipairs(platforms) do
        if CheckCollision(player.x, player.y, player.width, player.height, 
                         platform.x, platform.y, platform.width, platform.height) then
            if previousY + player.height <= platform.y then
                player.y = platform.y - player.height
                player.ySpeed = 0
                player.isGrounded = true
            elseif previousY >= platform.y + platform.height then
                player.y = platform.y + platform.height
                player.ySpeed = 0
            end
        end
    end

    -- Handle jumping
    if jump and player.isGrounded then
        player.ySpeed = player.jumpForce
        player.isGrounded = false
    end

    -- Respawn if fell out of map
    if player.y > 600 then
        player.x = player.startX
        player.y = player.startY
        player.xSpeed = 0
        player.ySpeed = 0
    end

    -- Press Escape to return to menu
    if love.keyboard.isDown("escape") then
        gameState = "menu"
    end
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

function drawMenu()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Platformer Game", 0, 50, love.graphics.getWidth(), "center")

    -- Draw menu buttons
    for i, button in ipairs(menuButtons) do
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        love.graphics.printf(button.text, button.x, button.y + 10, button.width, "center")
    end
end

function drawGame()
    -- Draw platforms (green)
    love.graphics.setColor(0.2, 0.8, 0.2)
    for i, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end

    -- Draw player with selected color
    love.graphics.setColor(unpack(playerSettings.color))
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("Press ESC to return to menu", 10, 10)
end

function drawSettings()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Settings", 0, 50, love.graphics.getWidth(), "center")

    -- Draw color options
    love.graphics.setFont(smallFont)
    love.graphics.printf("Select Player Color:", 200, 80, 200, "center")
    
    for i, colorOption in ipairs(colorOptions) do
        local y = 100 + (i-1) * 30
        
        -- Draw the option background - different color for selected item
        if i == playerSettings.selectedColorIndex then
            love.graphics.setColor(0.5, 0.5, 0.5) -- Lighter gray for selected
        else
            love.graphics.setColor(0.3, 0.3, 0.3) -- Normal gray
        end
        love.graphics.rectangle("fill", 200, y, 200, 25)
        
        -- Draw white outline around currently selected color
        if i == playerSettings.selectedColorIndex then
            love.graphics.setColor(1, 1, 1) -- White
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", 199, y, 202, 25)
            love.graphics.setLineWidth(1)
        end
        
        -- Draw the color swatch
        love.graphics.setColor(unpack(colorOption.color))
        love.graphics.rectangle("fill", 410, y + 2, 21, 21)
        
        -- Draw the color name
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(colorOption.name, 200, y + 2, 200, "center")
    end

    -- Draw back button
    for i, button in ipairs(settingsButtons) do
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        love.graphics.printf(button.text, button.x, button.y + 10, button.width, "center")
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

function checkMenuButtons(x, y)
    for i, button in ipairs(menuButtons) do
        if x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height then
            button.action()
            return
        end
    end
end

function checkSettingsButtons(x, y)
    for i, button in ipairs(settingsButtons) do
        if x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height then
            button.action()
            return
        end
    end
end

function checkColorOptions(x, y)
    for i, colorOption in ipairs(colorOptions) do
        local optionY = 100 + (i-1) * 30
        if x >= 200 and x <= 400 and y >= optionY and y <= optionY + 25 then
            playerSettings.color = colorOption.color
            playerSettings.selectedColorIndex = i  -- Store the index of the selected color
            return
        end
    end
end