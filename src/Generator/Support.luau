--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type SupportSubGrid = Types.SupportSubGrid
type SupportGrid = Types.SupportGrid
type GeneratorGrids = Types.GeneratorGrids

-- SupportGenerator.Dependencies = {
--     "SupportPoint",
--     "StarterIslandPoint",
-- }

local function generateSupport(radius, isCircular, supportConfig, wellRandom: Random, ladderRandom: Random): SupportSubGrid
    local support = {} :: SupportSubGrid

    for x = -radius, radius do
        for z = -radius, radius do
            if isCircular and math.sqrt(x*x + z*z) > radius then
                continue
            end

            if ladderRandom:NextNumber() < supportConfig.LadderChance then
                support[Vector3.new(x, 0, z)] = "Ladder"
            elseif wellRandom:NextNumber() < supportConfig.WellChance then
                support[Vector3.new(x, 0, z)] = "Well"
            else
                support[Vector3.new(x, 0, z)] = "Fill"
            end
        end
    end

    return support
end

local function generateStarterSupport()
    local support = {} :: SupportSubGrid

    for x = -1, 1 do
        for z = -1, 1 do
            if math.sqrt(x*x + z*z) > 1 then
                continue
            end

            if x == 0 and z == 0 then
                support[Vector3.new(x, 0, z)] = "Well"
            else
                support[Vector3.new(x, 0, z)] = "Fill"
            end
        end
    end

    return support
end

return function(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): SupportGrid
    -- Grids
    local supportPointGrid = grids.SupportPoint
    local starterIslandPointGrid = grids.StarterIslandPoint

    -- Config
    local supportConfig = config.Support

    -- Randomizers
    local radiusRandom = randomizers.SupportRadius
    local circularRandom = randomizers.SupportCircular
    local wellRandom = randomizers.SupportWell
    local ladderRandom = randomizers.SupportLadder

    local supportGrid = {} :: SupportGrid

    for position, _ in supportPointGrid do
        local radius = radiusRandom:NextInteger(supportConfig.MinRadius, supportConfig.MaxRadius)
        local isCircular = circularRandom:NextNumber() < supportConfig.CircularChance

        supportGrid[position] = generateSupport(radius, isCircular, supportConfig, wellRandom, ladderRandom)
    end

    for position, _ in starterIslandPointGrid do
        supportGrid[position] = generateStarterSupport()
    end

    return supportGrid
end