local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers

local Noise2D = require(script.Parent.Parent.Parent.Noise2D)

local Randomizer = {}

function Randomizer.CreateRandomizers(terrainConfig: TerrainConfig): TerrainRandomizers
    -- Config
    local seed = terrainConfig.Seed

    local random = Random.new(seed)

    local function GenRandom()
        return Random.new(random:NextNumber())
    end

    local function GenNoise()
        return Noise2D.new(random:NextNumber())
    end

    local randomizers = {
        -- Island
        IslandGaps = GenNoise(),
        IslandDepth = GenNoise(),
        StarterIslandRadius = GenNoise(),

        -- Crystal
        Crystal = GenRandom(),

        -- Spire
        SpireCities = GenNoise(),
        SpireBuildings = GenNoise(),
        SpireAlleys = GenNoise(),
        SpireHeight = GenNoise(),

        -- Grass
        Grass = GenNoise(),
        
        -- Support
        SupportRadius = GenRandom(),
        SupportCircular = GenRandom(),
        SupportWell = GenRandom(),
        SupportLadder = GenRandom(),
    }

    return randomizers
end

return Randomizer