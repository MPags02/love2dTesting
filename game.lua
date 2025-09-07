-- Initialize best times table if it doesn't exist
if not bestTimes then
    bestTimes = {}
    for i = 1, 2 do  -- For both levels
        bestTimes[i] = math.huge
    end
end

function loadGame()
    local levelData = loadLevel(currentLevel)
    player = levelData.player
    platforms = levelData.platforms
    goal = levelData.goal
    enemies = levelData.enemies or {}  -- Add enemies, default to empty table if not defined
    
    -- Reset goal state
    goal.reached = false
    
    -- Reset level timer
    levelTimer = 0
    timerActive = true
    
    -- Set camera boundaries based on level size
    camera.minX = levelData.cameraBounds.minX
    camera.maxX = levelData.cameraBounds.maxX
    camera.minY = levelData.cameraBounds.minY
    camera.maxY = levelData.cameraBounds.maxY
    
    -- Reset player position and velocity to start position
    player.x = player.startX
    player.y = player.startY
    player.xSpeed = 0
    player.ySpeed = 0
    player.isGrounded = false
    
    -- Center camera on player initially
    camera.x = player.x - love.graphics.getWidth()/2
    camera.y = player.y - love.graphics.getHeight()/2
    
    -- Reset goal arrow mechanics
    goalArrow = {
        active = false,
        cooldown = 0,
        maxCooldown = 5,
        duration = 2,
        activeTime = 0
    }
    
    -- Reset button
    resetButton = {
        x = love.graphics.getWidth() - 120,
        y = 10,
        width = 110,
        height = 30,
        text = "Reset Level"
    }
    
    print("Level reset! Player at:", player.x, player.y)
end

function updateGame(dt)
    -- Update level timer
    if timerActive then
        levelTimer = levelTimer + dt
    end
    
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

    -- Update goal arrow mechanics
    if goalArrow.active then
        goalArrow.activeTime = goalArrow.activeTime - dt
        if goalArrow.activeTime <= 0 then
            goalArrow.active = false
            goalArrow.cooldown = goalArrow.maxCooldown
        end
    else
        goalArrow.cooldown = math.max(0, goalArrow.cooldown - dt)
    end
    
    -- Toggle goal arrow with 'G' key if not on cooldown
    if love.keyboard.isDown("g") and goalArrow.cooldown <= 0 and not goalArrow.active then
        goalArrow.active = true
        goalArrow.activeTime = goalArrow.duration
    end

    -- Add keyboard reset with 'R' key with debouncing
    if love.keyboard.isDown("r") and not resetCooldown then
        loadGame() -- Reset the current level
        resetCooldown = 0.5 -- 0.5 second cooldown
    end
    
    -- Handle reset cooldown
    if resetCooldown then
        resetCooldown = math.max(0, resetCooldown - dt)
        if resetCooldown == 0 then
            resetCooldown = nil
        end
    end

    -- Update camera to follow player with smoothing
    local targetX = player.x - love.graphics.getWidth()/2
    local targetY = player.y - love.graphics.getHeight()/2
    
    -- Smooth camera movement (lerp)
    camera.x = camera.x + (targetX - camera.x) * 10 * dt
    camera.y = camera.y + (targetY - camera.y) * 10 * dt
    
    -- Keep camera within level bounds
    camera.x = math.max(camera.minX, math.min(camera.maxX, camera.x))
    camera.y = math.max(camera.minY, math.min(camera.maxY, camera.y))

    -- Check if player reached the goal
    if not goal.reached and CheckCollision(player.x, player.y, player.width, player.height, 
                                         goal.x, goal.y, goal.width, goal.height) then
        goal.reached = true
        levelComplete()
    end
    
    -- Check enemy collisions
    for _, enemy in ipairs(enemies) do
        if CheckCollision(player.x, player.y, player.width, player.height,
                         enemy.x, enemy.y, enemy.width, enemy.height) then
            -- Reset player to start position
            loadGame()
            return
        end
    end

    -- Respawn if fell out of map (use world coordinates now)
    if player.y > camera.maxY + 200 then  -- Fell far below the world
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

function drawGame()
    -- Apply camera transformation
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    
    -- Draw platforms
    love.graphics.setColor(0.2, 0.8, 0.2)
    for i, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end

    -- Draw goal
    if not goal.reached then
        love.graphics.setColor(1, 1, 0) -- Yellow
    else
        love.graphics.setColor(0, 1, 0) -- Green when reached
    end
    love.graphics.rectangle("fill", goal.x, goal.y, goal.width, goal.height)
    
    -- Draw enemies
    love.graphics.setColor(1, 0, 0) -- Red color for enemies
    for _, enemy in ipairs(enemies) do
        drawSpikyEnemy(enemy.x + enemy.width/2, enemy.y + enemy.height/2, enemy.width/2)
    end

    -- Draw goal arrow if active
    if goalArrow.active and not goal.reached then
        drawGoalArrow()
    end

    -- Draw player with selected color
    love.graphics.setColor(unpack(playerSettings.color))
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    
    love.graphics.pop() -- Restore original transformation
    
    -- Draw UI (stays fixed on screen)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(smallFont)
    
    -- Left side UI elements
    local leftX = 10
    
    -- Controls info at the very top
    love.graphics.print("Press ESC to return to menu", leftX, 10)
    love.graphics.print("Press R to reset level", leftX, 30)
    
    -- Game status info with proper spacing
    love.graphics.print("Level: " .. currentLevel, leftX, 60)
    
    -- Format and display times
    local currentTimeStr = string.format("Time: %.2f", levelTimer)
    local bestTimeStr = string.format("Best: %.2f", bestTimes[currentLevel] == math.huge and 0.00 or bestTimes[currentLevel])
    love.graphics.print(currentTimeStr, leftX, 80)
    love.graphics.print(bestTimeStr, leftX, 100)
    
    -- Position info
    love.graphics.print("Position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), leftX, 120)
    
    -- Goal arrow info - on right side below reset button
    local rightX = love.graphics.getWidth() - 200  -- 200 pixels from right edge
    if goalArrow.cooldown > 0 then
        love.graphics.print("Arrow: " .. string.format("%.1f", goalArrow.cooldown) .. "s", rightX, 50)
    else
        love.graphics.print("Press G for goal arrow", rightX, 50)
    end
    
    -- Draw reset button
    drawResetButton()
    
    if goal.reached then
        love.graphics.printf("LEVEL COMPLETE!", 0, 200, love.graphics.getWidth(), "center")
    end
end

function drawGoalArrow()
    local dx = goal.x - player.x
    local dy = goal.y - player.y
    local distance = math.sqrt(dx * dx + dy * dy)
    
    if distance > 50 then  -- Only draw if goal is far enough
        -- Normalize direction
        dx = dx / distance
        dy = dy / distance
        
        -- Arrow position (slightly above player)
        local arrowX = player.x + player.width/2
        local arrowY = player.y - 30
        
        -- Draw arrow line
        love.graphics.setColor(1, 0.5, 0) -- Orange
        love.graphics.setLineWidth(2)
        love.graphics.line(arrowX, arrowY, arrowX + dx * 40, arrowY + dy * 40)
        
        -- Draw arrowhead
        love.graphics.polygon("fill", 
            arrowX + dx * 40, arrowY + dy * 40,
            arrowX + dx * 30 + dy * 8, arrowY + dy * 30 - dx * 8,
            arrowX + dx * 30 - dy * 8, arrowY + dy * 30 + dx * 8
        )
    end
end

function drawResetButton()
    -- Button background
    love.graphics.setColor(0.8, 0.2, 0.2) -- Red
    love.graphics.rectangle("fill", resetButton.x, resetButton.y, resetButton.width, resetButton.height)
    
    -- Button border
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", resetButton.x, resetButton.y, resetButton.width, resetButton.height)
    
    -- Button text
    love.graphics.printf(resetButton.text, resetButton.x, resetButton.y + 8, resetButton.width, "center")
end

function levelComplete()
    -- Stop the timer
    timerActive = false
    
    -- Check if this is a new best time
    if levelTimer < bestTimes[currentLevel] then
        bestTimes[currentLevel] = levelTimer
    end
    
    -- Add time to leaderboard
    addTimeToLeaderboard(currentLevel, levelTimer)
    
    -- Show completion message for 2 seconds before proceeding
    love.timer.sleep(2)
    
    if currentLevel == 1 then
        currentLevel = 2
        loadGame()
    else
        gameState = "menu"
        currentLevel = 1
    end
end

function checkGameButtons(x, y)
    -- Check if reset button was clicked
    if resetButton and x >= resetButton.x and x <= resetButton.x + resetButton.width and
       y >= resetButton.y and y <= resetButton.y + resetButton.height then
        loadGame() -- Reset the current level
        return true
    end
    return false
end

-- Function to draw a spiky enemy
function drawSpikyEnemy(x, y, radius)
    local spikes = 8  -- Number of spikes
    local innerRadius = radius * 0.6  -- Inner circle radius
    local points = {}
    
    -- Create points for the spiky circle
    for i = 1, spikes * 2 do
        local angle = (i - 1) * math.pi / spikes
        local r = i % 2 == 1 and radius or innerRadius
        points[#points + 1] = x + math.cos(angle) * r
        points[#points + 1] = y + math.sin(angle) * r
    end
    
    -- Draw the spiky outline with a black border
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("line", points)
    
    -- Fill the spiky circle with red
    love.graphics.setColor(1, 0, 0)
    love.graphics.polygon("fill", points)
    
    -- Draw inner details
    love.graphics.setColor(0.8, 0, 0)  -- Darker red
    love.graphics.circle("fill", x, y, innerRadius * 0.7)
end

-- Return the functions that need to be accessible
return {
    loadGame = loadGame,
    updateGame = updateGame,
    drawGame = drawGame,
    checkGameButtons = checkGameButtons,
    levelComplete = levelComplete
}