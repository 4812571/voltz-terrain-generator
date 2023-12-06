local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid
type Builder = Types.Builder

local Builder = {}

-- local loadOrder = {
--     "Island",
--     "Crystal",
--     "Spire",
--     "StarterIsland",
--     "Support",
-- }

function Builder.Build(grids: GeneratorGrids, loadOrder: { Builder }?): TerrainGrid
    loadOrder = loadOrder or {
        require(script.Island),
        require(script.Crystal),
        require(script.Spire),
        require(script.StarterIsland),
        require(script.Support),
    }

    local terrainGrid = {}

    for _, builder in loadOrder do
        local resultGrid = builder(grids)

        -- Merge each result grid into the terrain grid
        for position, cellType in resultGrid do
            terrainGrid[position] = cellType
        end
    end

    return terrainGrid
end

return Builder