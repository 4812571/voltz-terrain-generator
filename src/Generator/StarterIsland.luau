--!strict
local Types = require(script.Parent.Parent.Types)

type Noise2D = Types.Noise2D

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type StarterIslandGrid = Types.StarterIslandGrid
type GeneratorGrids = Types.GeneratorGrids

local StarterIslandPoint = require(script.Parent.StarterIslandPoint)

-- local StarterIslandGenerator = {}

-- StarterIslandGenerator.Dependencies = {
--     "StarterIslandPoint",
-- }

local function generateStarterIsland(position, terrainConfig, islandRadiusNoise: Noise2D, islandDepthNoise: Noise2D)
    -- Config
    local islandConfig = terrainConfig.Island
    local starterIslandConfig = terrainConfig.StarterIsland

    local islandSize = islandConfig.Size

    local starterIsland = {}

    -- Noise Values
    local radiusVariation = starterIslandConfig.RadiusVariation

    for x = -islandSize, islandSize do
        for z = -islandSize, islandSize do
            -- Noisy Radius
            local islandRadius = islandSize + math.floor(islandRadiusNoise:UnitNoise(x, z, radiusVariation.Scale) * radiusVariation.Weight)

            -- Circle
            if math.sqrt(x ^ 2 + z ^ 2) > islandRadius then
                continue
            end

            -- Generate Depth
            local depth = math.floor(islandDepthNoise:UnitNoise(x, z, islandConfig.Depth.Scale) * islandConfig.Depth.Weight)

            -- Grid
            starterIsland[Vector3.new(x, 0, z)] = depth
        end
    end
end

return function(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): StarterIslandGrid
    -- Grids
    local starterIslandPointGrid = grids[StarterIslandPoint]

    -- Randomizers
    local islandRadiusNoise = randomizers.StarterIslandRadius
    local islandDepthNoise = randomizers.IslandDepth

    local starterIslandGrid = {}

    for position, _ in starterIslandPointGrid do
        starterIslandGrid[position] = generateStarterIsland(position, config, islandRadiusNoise, islandDepthNoise)
    end

    return starterIslandGrid
end