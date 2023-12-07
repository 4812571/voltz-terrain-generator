--!strict
local Types = require(script.Parent.Parent.Types)
local Generator = script.Parent.Parent.Generator

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local StarterIsland = require(Generator.StarterIsland)

-- StarterIslandBuilder.Dependencies = {

-- }

local function buildStarterIsland(position: Vector3, starterIsland, starterIslandWrites)
    for offset, depth in starterIsland do
        local columnPosition = position + offset

        for y = -depth, 0 do
            starterIslandWrites[columnPosition + Vector3.new(0, y, 0)] = "Surface Fill"
        end
    end
end

return function(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local starterIslandGrid = grids[StarterIsland]

    local starterIslandWrites = {}

    for position, starterIsland in starterIslandGrid do
        buildStarterIsland(position, starterIsland, starterIslandWrites)
    end

    return starterIslandWrites
end