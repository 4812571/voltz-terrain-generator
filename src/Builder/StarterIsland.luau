--!strict
local Types = require(script.Parent.Parent.Types)

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local StarterIslandBuilder = {}

StarterIslandBuilder.Dependencies = {
    
}

function StarterIslandBuilder._buildStarterIsland(position: Vector3, starterIsland, starterIslandWrites)
    for offset, depth in starterIsland do
        local columnPosition = position + offset

        for y = -depth, 0 do
            starterIslandWrites[columnPosition + Vector3.new(0, y, 0)] = "Surface Fill"
        end
    end
end

function StarterIslandBuilder.Build(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local starterIslandGrid = grids.StarterIsland

    local starterIslandWrites = {}

    for position, starterIsland in starterIslandGrid do
        StarterIslandBuilder._buildStarterIsland(position, starterIsland, starterIslandWrites)
    end

    return starterIslandWrites
end

return StarterIslandBuilder