--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type SupportHeightGrid = Types.SupportHeightGrid
type GeneratorGrids = Types.GeneratorGrids

local SupportPoint = require(script.Parent.SupportPoint)
local StarterIslandPoint = require(script.Parent.StarterIslandPoint)

return function(terrainConfig: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): SupportHeightGrid
    -- Config
    local supportConfig = terrainConfig.Support

    -- Grids
    local supportPointGrid = grids[SupportPoint]
    local starterIslandPointGrid = grids[StarterIslandPoint]

    local supportHeightGrid = {}

    for position, _ in supportPointGrid do
        supportHeightGrid[position] = supportConfig.Height
    end

    for position, _ in starterIslandPointGrid do
        supportHeightGrid[position] = supportConfig.Height
    end

    return supportHeightGrid
end