--!strict
local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type GeneratorGrids = Types.GeneratorGrids
type Generator = Types.Generator

local Generator = {}

-- local loadOrder = {
--     -- Beacon
--     "Beacon",

--     -- Starter Island
--     "StarterIslandPoint",
--     "StarterIsland",

--     -- Island
--     "Island",

--     -- Island Features
--     "Grass",
--     "Spire",
--     "Crystal",

--     -- Support
--     "SupportPoint",
--     "SupportHeight",
--     "Support",
-- }

function Generator.Generate(terrainConfig: TerrainConfig, randomizers: TerrainRandomizers, loadOrder: { Generator }?): GeneratorGrids
    loadOrder = loadOrder or {
        require(script.Beacon),
        require(script.StarterIslandPoint),
        require(script.StarterIsland),
        require(script.Island),
        require(script.Grass),
        require(script.Spire),
        require(script.Crystal),
        require(script.SupportPoint),
        require(script.SupportHeight),
        require(script.Support),
    }

    local grids = {}

    for _, generator in loadOrder do
        grids[generator] = generator(terrainConfig, randomizers, grids)
    end

    return grids
end

return Generator