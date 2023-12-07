--!strict
local Types = require(script.Parent.Parent.Types)
local Generator = script.Parent.Parent.Generator

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local Island = require(Generator.Island)
local Grass = require(Generator.Grass)

-- IslandBuilder.Dependencies = {

-- }

return function(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local islandGrid = grids[Island]
    local grassGrid = grids[Grass]

    local islandWrites = {}

    for position, depth in islandGrid do
        for y = -depth, 0 do
            islandWrites[position + Vector3.new(0, y, 0)] = if y == 0 and grassGrid[position] then "Surface Grass" else "Surface Fill"
        end
    end

    return islandWrites
end

-- return IslandBuilder