local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local Loader = require(script.Parent.Parent.Loader)

local Builder = {}

local loadOrder = {
    "Island",
    "Crystal",
    "Spire",
    "StarterIsland",
    "Support",
}

function Builder.Build(grids: GeneratorGrids): TerrainGrid
    local builders = Loader.LoadChildren(script)

    local terrainGrid = {}

    for _, builderName in loadOrder do
        local builder = builders[builderName]
        local resultGrid = builder.Build(grids)

        -- Merge each result grid into the terrain grid
        for position, cellType in resultGrid do
            terrainGrid[position] = cellType
        end
    end

    return terrainGrid
end

return Builder