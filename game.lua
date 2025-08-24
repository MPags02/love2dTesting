function loadGame()
    local levelData = loadLevel(currentLevel)
    player = levelData.player
    platforms = levelData.platforms
    goal = levelData.goal
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

    -- Check if player reached the goal
    if not goal.reached and CheckCollision(player.x, player.y, player.width, player.height, 
                                         goal.x, goal.y, goal.width, goal.height) then
        goal.reached = true
        levelComplete()
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

function drawGame()
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

    -- Draw player with selected color
    love.graphics.setColor(unpack(playerSettings.color))
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("Press ESC to return to menu", 10, 10)
    love.graphics.print("Level: " .. currentLevel, 10, 30)
    
    if goal.reached then
        love.graphics.printf("LEVEL COMPLETE!", 0, 200, love.graphics.getWidth(), "center")
    end
end

function levelComplete()
    if currentLevel == 1 then
        currentLevel = 2
        loadGame()
    else
        gameState = "menu"
        currentLevel = 1
    end
end