function initSettings()
    nameInput = {
        text = playerName,
        x = 200,
        y = 130,
        width = 200,
        height = 30,
        active = false
    }
    
    colorOptions = {
        {name = "White", color = {1, 1, 1}},
        {name = "Red", color = {1, 0, 0}},
        {name = "Green", color = {0, 1, 0}},
        {name = "Blue", color = {0, 0, 1}},
        {name = "Yellow", color = {1, 1, 0}},
        {name = "Cyan", color = {0, 1, 1}},
        {name = "Magenta", color = {1, 0, 1}}
    }

    settingsButtons = {
        {
            text = "Back to Menu",
            x = 200,
            y = 500,  -- Moved down to be below all other elements
            width = 200,
            height = 50,
            action = function() gameState = "menu" end
        }
    }
end

function drawSettings()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Settings", 0, 50, love.graphics.getWidth(), "center")

    -- Draw name input section
    love.graphics.setFont(smallFont)
    love.graphics.printf("Player Name:", 200, 100, 200, "center")
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", nameInput.x, nameInput.y, nameInput.width, nameInput.height)
    love.graphics.setColor(nameInput.active and {1, 1, 0} or {1, 1, 1})
    love.graphics.rectangle("line", nameInput.x, nameInput.y, nameInput.width, nameInput.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(nameInput.text, nameInput.x + 10, nameInput.y + 5, nameInput.width - 20, "left")

    -- Draw color options section with more spacing
    love.graphics.setFont(smallFont)
    love.graphics.printf("Select Player Color:", 200, 220, 200, "center")
    
    for i, colorOption in ipairs(colorOptions) do
        local y = 250 + (i-1) * 30
        
        -- Draw the option background - different color for selected item
        if i == playerSettings.selectedColorIndex then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
        love.graphics.rectangle("fill", 200, y, 200, 25)
        
        -- Draw white outline around currently selected color
        if i == playerSettings.selectedColorIndex then
            love.graphics.setColor(1, 1, 1)
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
            playerSettings.selectedColorIndex = i
            return
        end
    end
end