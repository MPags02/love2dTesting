function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function loadLevel(levelNumber)
    if levelNumber == 1 then
        return require("levels.level1")
    elseif levelNumber == 2 then
        return require("levels.level2")
    end
    -- Add more levels as needed
end