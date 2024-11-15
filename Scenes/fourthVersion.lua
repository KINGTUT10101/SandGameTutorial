local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local push = require ("Libraries.push")

local gridManager = require ("gridManager")
local materials = require ("materialsUpgraded") -- Contains information about each material

local lastTick = 0 -- Time since last grid update
local tickRate = 1/16 -- Time between each grid update

function thisScene:load (...)
    -- Set up the grid manager
    gridManager:init (32, 32, materials)
end

function thisScene:update (dt)
    lastTick = lastTick + dt -- Add time since last frame to counter

    -- Check if enough time has passed to execute another simulation tick
    if lastTick >= tickRate then
        gridManager:updateGrid ()

        lastTick = 0 -- Reset time since last tick
    end

    -- Get mouse coordinates
    local mouseX, mouseY = push:toGame(love.mouse.getPosition ())
    local gridX, gridY = gridManager:screenToGrid (mouseX, mouseY)
    
    -- Validate mouse position
    if gridManager:validate (gridX, gridY) == true then
        -- Determine if one of the mouse buttons is pressed
        if love.mouse.isDown (1) then
            -- Replace the cell with sand
            gridManager:replace (gridX, gridY, "sand")
        elseif love.mouse.isDown (2) then
            -- Replace the cell with air
            gridManager:replace (gridX, gridY, "air")
        end
    end
end

function thisScene:draw ()
    gridManager:renderGrid ()

    -- Show the name of the scene
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("Fourth Version", 1620, 10)
end

function thisScene:keypressed (key, scancode, isrepeat)
    -- Reset the grid when the R key is pressed
    if key == "r" then
        gridManager:resetGrid ()
    end
end

return thisScene