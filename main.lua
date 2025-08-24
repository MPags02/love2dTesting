function love.load()
    -- Initialize our player object with properties
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
        jumpForce = -400, -- Negative because y goes down
        gravity = 900,
        isGrounded = false
    }

    -- Store initial position for respawning
    player.startX = player.x
    player.startY = player.y

    -- Define our platforms (x, y, width, height)
    platforms = {
        {x = 0, y = 350, width = 200, height = 20},
        {x = 250, y = 300, width = 100, height = 20},
        {x = 400, y = 250, width = 100, height = 20},
        {x = 0, y = 450, width = 600, height = 50} -- The ground
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
        -- Apply friction when no key is pressed
        if player.xSpeed > 0 then
            player.xSpeed = math.max(player.xSpeed - player.friction * dt, 0)
        elseif player.xSpeed < 0 then
            player.xSpeed = math.min(player.xSpeed + player.friction * dt, 0)
        end
    end

    -- Limit maximum speed
    player.xSpeed = math.max(math.min(player.xSpeed, player.maxSpeed), -player.maxSpeed)

    -- Store the player's position before applying horizontal movement
    local previousX = player.x

    -- Apply horizontal movement FIRST
    player.x = player.x + player.xSpeed * dt

    -- Check for HORIZONTAL collisions with platforms
    for i, platform in ipairs(platforms) do
        if CheckCollision(player.x, player.y, player.width, player.height, 
                         platform.x, platform.y, platform.width, platform.height) then
            
            -- We have a horizontal collision
            if previousX + player.width <= platform.x then
                -- Hit the left side of a platform
                player.x = platform.x - player.width
                player.xSpeed = 0
            elseif previousX >= platform.x + platform.width then
                -- Hit the right side of a platform
                player.x = platform.x + platform.width
                player.xSpeed = 0
            end
        end
    end

    -- Apply gravity
    player.ySpeed = player.ySpeed + player.gravity * dt

    -- Store the player's position before applying vertical movement
    local previousY = player.y

    -- Apply vertical movement SECOND
    player.y = player.y + player.ySpeed * dt

    -- Reset grounded state each frame
    player.isGrounded = false

    -- Check for VERTICAL collisions with platforms
    for i, platform in ipairs(platforms) do
        if CheckCollision(player.x, player.y, player.width, player.height, 
                         platform.x, platform.y, platform.width, platform.height) then
            
            -- We have a vertical collision
            if previousY + player.height <= platform.y then
                -- We were above the platform - this is a landing
                player.y = platform.y - player.height
                player.ySpeed = 0
                player.isGrounded = true
            elseif previousY >= platform.y + platform.height then
                -- We were below the platform - hit our head
                player.y = platform.y + platform.height
                player.ySpeed = 0
            end
        end
    end

    -- Handle jumping (only allow jumping when grounded)
    if jump and player.isGrounded then
        player.ySpeed = player.jumpForce
        player.isGrounded = false
    end

    -- Check if player fell out of the map and respawn
    if player.y > 600 then -- Adjust this value based on your screen size
        player.x = player.startX
        player.y = player.startY
        player.xSpeed = 0
        player.ySpeed = 0
    end
end

function love.draw()
    -- Clear the screen with a background color
    love.graphics.clear(0.1, 0.1, 0.3) -- Dark blue

    -- Draw the player (white square)
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- Draw all platforms (green)
    love.graphics.setColor(0.2, 0.8, 0.2) -- Green
    for i, platform in ipairs(platforms) do
        love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
    end

    -- Draw some instructions
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("Use A/D or Left/Right to move, SPACE to jump", 10, 10)
    love.graphics.print("Grounded: " .. tostring(player.isGrounded), 10, 30)
    love.graphics.print("Position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), 10, 50)
end