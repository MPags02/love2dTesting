local backButton = {
    text = "Back",
    x = 50,
    y = 500,
    width = 100,
    height = 40
}

function initLeaderboard()
    -- Initialize leaderboard data structure if it doesn't exist
    if not leaderboardData then
        leaderboardData = {
            [1] = {},  -- Level 1 times
            [2] = {}   -- Level 2 times
        }
    end
end

function addTimeToLeaderboard(level, time)
    if not leaderboardData[level] then return end
    
    -- Add new entry
    table.insert(leaderboardData[level], {
        name = playerName,
        time = time,
        date = os.date("%Y-%m-%d")
    })
    
    -- Sort by time
    table.sort(leaderboardData[level], function(a, b) return a.time < b.time end)
    
    -- Keep only top 10
    while #leaderboardData[level] > 10 do
        table.remove(leaderboardData[level])
    end
end

function drawLeaderboard()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Leaderboard", 0, 50, love.graphics.getWidth(), "center")
    
    -- Draw level tabs
    love.graphics.setFont(smallFont)
    for i = 1, 2 do
        local x = love.graphics.getWidth() / 2 - 200 + (i-1) * 200
        love.graphics.rectangle("line", x, 100, 200, 40)
        love.graphics.printf("Level " .. i, x, 110, 200, "center")
    end
    
    -- Draw times for each level
    local y = 160
    for level = 1, 2 do
        local x = 100 + (level-1) * 300
        
        -- Draw headers
        love.graphics.printf("Rank", x, y, 50, "left")
        love.graphics.printf("Name", x + 50, y, 100, "left")
        love.graphics.printf("Time", x + 150, y, 100, "left")
        
        -- Draw times if there are any
        if leaderboardData and leaderboardData[level] then
            if #leaderboardData[level] == 0 then
                love.graphics.printf("No times yet!", x, y + 30, 250, "center")
            else
                for rank, entry in ipairs(leaderboardData[level]) do
                    y = y + 30
                    love.graphics.printf(rank .. ".", x, y, 50, "left")
                    love.graphics.printf(entry.name, x + 50, y, 100, "left")
                    love.graphics.printf(string.format("%.2f", entry.time), x + 150, y, 100, "left")
                end
            end
        else
            love.graphics.printf("No times yet!", x, y + 30, 250, "center")
        end
        
        -- Reset y for next level
        y = 160
    end
    
    -- Draw back button
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", backButton.x, backButton.y, backButton.width, backButton.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", backButton.x, backButton.y, backButton.width, backButton.height)
    love.graphics.printf(backButton.text, backButton.x, backButton.y + 10, backButton.width, "center")
end

function checkLeaderboardButtons(x, y)
    -- Check back button
    if x >= backButton.x and x <= backButton.x + backButton.width and
       y >= backButton.y and y <= backButton.y + backButton.height then
        gameState = "menu"
    end
end
