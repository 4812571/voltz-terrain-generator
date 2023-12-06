--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type SpireGrid = Types.SpireGrid
type GeneratorGrids = Types.GeneratorGrids

-- SpireGenerator.Dependencies = {
--     "Island",
-- }

local function shouldGenerate(position, cityNoise, buildingNoise, alleyNoise, heightNoise, config)
    local isCity = cityNoise:EdgeRange(position.X, position.Z, config.Cities.Scale, config.Cities.Weight)
    local isBuilding = buildingNoise:EdgeRange(position.X, position.Z, config.Buildings.Scale, config.Buildings.Weight)
    local isAlley = alleyNoise:EdgeRange(position.X, position.Z, config.Alleys.Scale, config.Alleys.Weight)

    return isCity and isBuilding and not isAlley
end

return function(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): SpireGrid
    -- Grids
    local islandGrid = grids.Island

    -- Config
    local spireConfig = config.Spire

    -- Randomizers
    local cityNoise = randomizers.SpireCities
    local buildingNoise = randomizers.SpireBuildings
    local alleyNoise = randomizers.SpireAlleys
    local heightNoise = randomizers.SpireHeight

    local spireGrid = {}

    for position, _ in islandGrid do
        if not shouldGenerate(position, cityNoise, buildingNoise, alleyNoise, heightNoise, spireConfig) then
            continue
        end

        local spireHeight = math.floor(heightNoise:UnitNoise(position.X, position.Z, spireConfig.Height.Scale) * spireConfig.Height.Weight)

        if spireHeight == 0 then
            continue
        end

        spireGrid[position] = spireHeight
    end

    return spireGrid
end