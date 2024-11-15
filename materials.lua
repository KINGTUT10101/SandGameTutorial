local materials = {}

materials.air = {
    color = {179/255, 235/255, 1, 1},
    update = function (grid, gridSize, gridX, gridY) end,
}

materials.sand = {
    color = {1, 1, 0, 1},
    update = function (grid, gridSize, gridX, gridY)
        -- Check if the cell below is air
        if gridY < gridSize and grid[gridX][gridY + 1].material == "air" then
            -- Swap the cells
            grid[gridX][gridY], grid[gridX][gridY + 1] = grid[gridX][gridY + 1], grid[gridX][gridY]
        end
    end,
}

return materials