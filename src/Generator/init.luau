--!strict
local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type GeneratorGrids = Types.GeneratorGrids

local Loader = require(script.Parent.Parent.Loader)

local Generator = {}

local loadOrder = {
    -- Beacon
    "Beacon",

    -- Starter Island
    "StarterIslandPoint",
    "StarterIsland",

    -- Island
    "Island",

    -- Island Features
    "Grass",
    "Spire",
    "Crystal",

    -- Support
    "SupportPoint",
    "SupportHeight",
    "Support",
}

function Generator.Generate(terrainConfig: TerrainConfig, randomizers: TerrainRandomizers): GeneratorGrids
    local generators = Loader.LoadChildren(script)

    local grids = {}

    for _, generatorName in loadOrder do
        local generator = generators[generatorName]
        grids[generatorName] = generator.Generate(terrainConfig, randomizers, grids)
    end

    return grids
end

return Generator