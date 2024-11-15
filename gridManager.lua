local gridManager = {
    grid = {}, -- Contains the cell data
    gridSize = 32, -- Size of the map
    cellSize = 32, -- Size of each cell on screen
    materials = nil, -- Holds a reference to the material data
}

function gridManager:init (gridSize, cellSize, materials)
    self.gridSize = gridSize
    self.cellSize = cellSize
    self.materials = materials

    self:resetGrid ()
end

-- Clears the grid and fills it with air
function gridManager:resetGrid ()
    local grid = {}

    for i = 1, self.gridSize do
        local column = {} -- Cache the current column
        grid[i] = column

        for j = 1, self.gridSize do
            local cell = {
                material = "air",
                lastUpdate = 0,
            }

            column[j] = cell
        end
    end

    self.grid = grid
end

-- Updates the cells in the grid
function gridManager:updateGrid ()
    local updateStartTime = love.timer.getTime()
    local grid = self.grid

    for i = 1, self.gridSize do
        local column = grid[i] -- Cache the current column

        for j = 1, self.gridSize do
            local cell = column[j]

            -- Check if the cell has already been updated this tick
            if cell.lastUpdate < updateStartTime then
                -- Update the cell's lastUpdate attribute
                -- Make sure you do this BEFORE the cell is updated
                cell.lastUpdate = updateStartTime

                -- Call the cell material's update method
                self.materials[cell.material].update (i, j)
            end
        end
    end
end

-- Renders the cells to the screen
function gridManager:renderGrid ()
    local grid = self.grid

    for i = 1, self.gridSize do
        local column = grid[i] -- Cache the current column

        for j = 1, self.gridSize do
            local cell = column[j]

            -- Set the render color using the cell's material
            love.graphics.setColor (self.materials[cell.material].color)

            -- Render the cell using its position and the cell size
            love.graphics.rectangle (
                "fill",
                i * self.cellSize,
                j * self.cellSize,
                self.cellSize,
                self.cellSize
            )

            -- Render red outlines over each cell
            love.graphics.setColor (1, 0, 0, 1)
            love.graphics.rectangle (
                "line",
                i * self.cellSize,
                j * self.cellSize,
                self.cellSize,
                self.cellSize
            )
        end
    end
end

-- Converts an on-screen coordinate into a map coordinate
function gridManager:screenToGrid (screenX, screenY)
    local gridX = math.floor (screenX / self.cellSize)
    local gridY = math.floor (screenY / self.cellSize)
    
    return gridX, gridY
end

-- Checks if the provided map coordinates are valid positions in the grid
function gridManager:validate (gridX, gridY)
    return gridX >= 1 and gridX <= self.gridSize and gridY >= 1 and gridY <= self.gridSize
end

function gridManager:swap (oldGridX, oldGridY, newGridX, newGridY)
    -- Check if provided coordinates are valid
    if self:validate (oldGridX, oldGridY) == true and self:validate (newGridX, newGridY) then
        -- Swap the cells
        self.grid[oldGridX][oldGridY], self.grid[newGridX][newGridY] = self.grid[newGridX][newGridY], self.grid[oldGridX][oldGridY]
    end
end

function gridManager:replace (gridX, gridY, materialID)
    assert (self.materials[materialID] ~= nil, "Provided material ID is invalid")

    -- Validate position
    if self:validate (gridX, gridY) == true then
        -- Change material type
        self.grid[gridX][gridY].material = materialID
    end
end

function gridManager:getMaterial (gridX, gridY)
    if self:validate (gridX, gridY) == true then
        return self.grid[gridX][gridY].material
    else
        return "invalid"
    end
end

return gridManager