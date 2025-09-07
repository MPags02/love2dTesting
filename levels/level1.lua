local screenWidth = 800
local screenHeight = 600

return {
    player = {
        x = 400,
        y = 500,
        width = 20,
        height = 20,
        xSpeed = 0,
        ySpeed = 0,
        maxSpeed = 200,
        acceleration = 1500,
        friction = 800,
        jumpForce = -400,
        gravity = 900,
        isGrounded = false,
        startX = 400,
        startY = 500
    },
    
    cameraBounds = {
        minX = 0,
        maxX = 2400,  -- 3 screens wide
        minY = 0,
        maxY = 1800   -- 3 screens tall
    },
    
    platforms = {
        -- Central Hub Area (starting area)
        {x = 300, y = 550, width = 200, height = 20},  -- Ground platform
        
        -- Left Branch (leads to secret area)
        {x = 100, y = 500, width = 100, height = 20},
        {x = 50, y = 450, width = 80, height = 20},
        {x = 100, y = 400, width = 100, height = 20},
        {x = 50, y = 350, width = 80, height = 20},
        {x = 100, y = 300, width = 100, height = 20},
        {x = 0, y = 250, width = 150, height = 20},    -- Left secret platform
        
        -- Right Branch (main path to goal)
        {x = 500, y = 500, width = 100, height = 20},
        {x = 600, y = 450, width = 100, height = 20},
        {x = 500, y = 400, width = 100, height = 20},
        {x = 600, y = 350, width = 100, height = 20},
        {x = 500, y = 300, width = 100, height = 20},
        {x = 600, y = 250, width = 100, height = 20},
        {x = 500, y = 200, width = 100, height = 20},  -- Path to upper area
        
        -- Upper Area (above starting point)
        {x = 300, y = 150, width = 200, height = 20},  -- Upper platform
        {x = 200, y = 100, width = 100, height = 20},  -- Left upper
        {x = 400, y = 100, width = 100, height = 20},  -- Right upper
        
        -- Bottom Right Area (alternative path)
        {x = 700, y = 600, width = 100, height = 20},
        {x = 800, y = 550, width = 100, height = 20},
        {x = 900, y = 500, width = 100, height = 20},
        {x = 1000, y = 450, width = 100, height = 20},
        
        -- Far Right Area 
        {x = 1100, y = 400, width = 200, height = 20},
        {x = 1200, y = 350, width = 100, height = 20},
        {x = 1300, y = 300, width = 100, height = 20},
        
        -- Top Left Area (hard to reach)
        {x = 100, y = 100, width = 80, height = 20},
        {x = 50, y = 50, width = 60, height = 20},
        
        -- Bottom Left Area 
        {x = 200, y = 800, width = 100, height = 20},
        {x = 100, y = 750, width = 80, height = 20},
        {x = 200, y = 700, width = 100, height = 20},
        
        -- Far Bottom Area
        {x = 400, y = 1000, width = 200, height = 20},
        {x = 600, y = 950, width = 100, height = 20},
        {x = 500, y = 900, width = 100, height = 20},
        
        -- Extensive ground throughout the level
        {x = 0, y = 1150, width = 2400, height = 50},  -- Bottom safety net
        {x = 0, y = -50, width = 2400, height = 50},   -- Top boundary
        {x = -50, y = 0, width = 50, height = 1200},   -- Left boundary  
        {x = 2400, y = 0, width = 50, height = 1200},  -- Right boundary
    },
    
    goal = {
        x = 1350,  -- Far right area
        y = 250,
        width = 30,
        height = 30,
        reached = false
    },
    
    enemies = {
        -- Add some enemies in strategic locations
        {x = 350, y = 520, width = 20, height = 20},  -- One near the start
        {x = 650, y = 420, width = 20, height = 20},  -- One on the right path
        {x = 150, y = 220, width = 20, height = 20}   -- One near the secret area
    }
}