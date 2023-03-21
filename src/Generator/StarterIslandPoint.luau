--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type StarterIslandPointGrid = Types.StarterIslandPointGrid
type GeneratorGrids = Types.GeneratorGrids

local StarterIslandPointGenerator = {}

StarterIslandPointGenerator.Dependencies = {
    
}

function StarterIslandPointGenerator.Generate(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): StarterIslandPointGrid
    -- Config
    local islandConfig = config.Island
    local starterIslandConfig = config.StarterIsland

    local starterIslandPointGrid = {} :: StarterIslandPointGrid

    local islandAngleDifference = math.rad(360 / starterIslandConfig.IslandCount)

    for i = 1, starterIslandConfig.IslandCount do
        local unitX = math.cos(islandAngleDifference * i)
        local unitY = math.sin(islandAngleDifference * i)

        local scaledX = math.round(unitX * (islandConfig.Size + starterIslandConfig.IslandOffset))
        local scaledY = math.round(unitY * (islandConfig.Size + starterIslandConfig.IslandOffset))

        starterIslandPointGrid[Vector3.new(scaledX, 0, scaledY)] = true
    end

    return starterIslandPointGrid
end

return StarterIslandPointGenerator