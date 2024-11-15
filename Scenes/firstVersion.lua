local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")

local materials = require ("materials") -- Contains information about each material

local gridSize = 32 -- Size of the map
local cellSize = 32 -- Size of each cell on screen
local grid = {} -- Contains the cell data
local lastTick = 0 -- Time since last grid update
local tickRate = 1/16 -- Time between each grid update

-- Clears the grid and fills it with air
local function resetGrid ()
    grid = {}

    for i = 1, gridSize do
        grid[i] = {}

        for j = 1, gridSize do
            local cell = {
                material = "air"
            }

            grid[i][j] = cell
        end
    end
end

-- Updates the cells in the grid
local function updateGrid ()
    for i = 1, gridSize do
        for j = 1, gridSize do
            local cell = grid[i][j]

            -- Call the cell material's update method
            materials[cell.material].update (grid, gridSize, i, j)
        end
    end
end

-- Renders the cells to the screen
local function renderGrid ()
    for i = 1, gridSize do
        for j = 1, gridSize do
            local cell = grid[i][j]

            -- Set the render color using the cell's material
            love.graphics.setColor (materials[cell.material].color)

            -- Render the cell using its position and the cell size
            love.graphics.rectangle (
                "fill",
                i * cellSize,
                j * cellSize,
                cellSize,
                cellSize
            )
        end
    end
end

function thisScene:load (...)
    resetGrid ()
end

function thisScene:update (dt)
    lastTick = lastTick + dt -- Add time since last frame to counter

    -- Check if enough time has passed to execute another simulation tick
    if lastTick > tickRate then
        updateGrid ()
        print ("TICK")

        lastTick = 0 -- Reset time since last tick
    end
end

function thisScene:draw ()
    renderGrid ()

    -- Show the name of the scene
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("First Version", 1620, 10)
end

function thisScene:keypressed (key, scancode, isrepeat)
    -- Reset the grid when the R key is pressed
	if key == "r" then
        resetGrid ()
    end
end

return thisScene