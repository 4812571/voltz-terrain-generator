--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type GrassGrid = Types.GrassGrid
type GeneratorGrids = Types.GeneratorGrids

local Island = require(script.Parent.Island)

-- GrassGenerator.Dependencies = {
--     "Island",
-- }

return function(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): GrassGrid
    -- Grids
    local islandGrid = grids[Island]

    -- Config
    local grassConfig = config.Grass

    -- Randomizers
    local grassNoise = randomizers.Grass

    local grassGrid = {} :: GrassGrid

    for position, _ in islandGrid do
        -- Grass Noise
        if grassNoise:EdgeRange(position.X, position.Z, grassConfig.Grass.Scale, grassConfig.Grass.Weight) then
            grassGrid[position] = true
        end
    end

    return grassGrid
end