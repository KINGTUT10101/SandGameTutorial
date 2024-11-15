local gridManager = require ("gridManager")

local materials = {}

materials.air = {
    color = {179/255, 235/255, 1, 1},
    update = function (gridX, gridY) end,
}

materials.sand = {
    color = {1, 1, 0, 1},
    update = function (gridX, gridY)
        -- Check if the cell below is air
        if gridManager:getMaterial (gridX, gridY + 1) == "air" then
            -- Swap the cells
            gridManager:swap (gridX, gridY, gridX, gridY + 1)
        end
    end,
}

return materials