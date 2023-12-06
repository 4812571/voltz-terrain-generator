--!strict
local Types = require(script.Parent.Parent.Types)

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

return function(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local spireGrid = grids.Spire
    local grassGrid = grids.Grass

    local spireWrites = {}

    for position, height in spireGrid do
        for y = 1, height do
            if y == height then
                if grassGrid[position] then
                    spireWrites[position + Vector3.new(0, y, 0)] = "Spire Grass"
                else
                    spireWrites[position + Vector3.new(0, y, 0)] = "Spire Top"
                end
            else
                spireWrites[position + Vector3.new(0, y, 0)] = "Spire Fill"
            end
        end
    end

    return spireWrites
end