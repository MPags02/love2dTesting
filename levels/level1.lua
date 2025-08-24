return {
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
        isGrounded = false,
        startX = 50,
        startY = 50
    },
    
    platforms = {
        {x = 0, y = 350, width = 200, height = 20},
        {x = 250, y = 300, width = 100, height = 20},
        {x = 400, y = 250, width = 100, height = 20},
        {x = 0, y = 450, width = 600, height = 50}
    },
    
    goal = {
        x = 450,
        y = 200,
        width = 30,
        height = 30,
        reached = false
    }
}