return {
    player = {
        x = 50,
        y = 400,
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
        startX = 50,
        startY = 400
    },
    
    cameraBounds = {
        minX = 0,
        maxX = 1600,  -- Expanded for Level 2
        minY = 0,
        maxY = 1200
    },
    
    platforms = {
        -- Starting area
        {x = 0, y = 450, width = 150, height = 20},
        
        -- Challenging platform sequence
        {x = 200, y = 400, width = 80, height = 20},
        {x = 350, y = 350, width = 80, height = 20},
        {x = 250, y = 300, width = 80, height = 20},
        {x = 400, y = 250, width = 80, height = 20},
        {x = 300, y = 200, width = 80, height = 20},
        
        -- Right branch
        {x = 500, y = 350, width = 100, height = 20},
        {x = 600, y = 300, width = 80, height = 20},
        {x = 700, y = 250, width = 100, height = 20},
        {x = 800, y = 200, width = 80, height = 20},
        
        -- Upper area
        {x = 900, y = 150, width = 100, height = 20},
        {x = 1000, y = 100, width = 80, height = 20},
        
        -- Left branch (alternative path)
        {x = 100, y = 350, width = 80, height = 20},
        {x = 50, y = 300, width = 60, height = 20},
        {x = 100, y = 250, width = 80, height = 20},
        {x = 50, y = 200, width = 60, height = 20},
        {x = 100, y = 150, width = 80, height = 20},
        
        -- Bottom safety net
        {x = 0, y = 1150, width = 1600, height = 50},
        {x = 0, y = -50, width = 1600, height = 50},
        {x = -50, y = 0, width = 50, height = 1200},
        {x = 1600, y = 0, width = 50, height = 1200}
    },
    
    goal = {
        x = 1050,  -- Far right upper area
        y = 50,
        width = 30,
        height = 30,
        reached = false
    }
}