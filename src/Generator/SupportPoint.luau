--!strict
local ChunkGrid = require(script.Parent.Parent.Classes.ChunkGrid)
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type SupportPointGrid = Types.SupportPointGrid
type GeneratorGrids = Types.GeneratorGrids

local SupportPointGenerator = {}

SupportPointGenerator.Dependencies = {
    "Island",
}

function SupportPointGenerator._generateMainlandSupports(supportPointGrid: SupportPointGrid, islandGrid, supportConfig)
    local supportChunkGrid = ChunkGrid.new(Vector3.new(10, 10, 10))

    for position, _ in islandGrid do
        if supportChunkGrid:IsInRange(position, supportConfig.SupportSpacing) then
            continue
        end

        supportChunkGrid:Insert(position)
    end

    for _, position in supportChunkGrid:GetElements() do
        supportPointGrid[position] = true
    end
end

function SupportPointGenerator._generateStarterIslandSupports(supportPointGrid: SupportPointGrid, starterIslandGrid)
    for position, _ in starterIslandGrid do
        supportPointGrid[position] = true
    end
end

function SupportPointGenerator.Generate(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): SupportPointGrid
    -- Grids
    local islandGrid = grids.Island
    local starterIslandGrid = grids.StarterIsland

    -- Config
    local supportConfig = config.Support

    local supportPointChunkGrid = ChunkGrid.new(Vector3.new(10, 10, 10))

    for position, _ in islandGrid do
        if supportPointChunkGrid:IsInRange(position, supportConfig.SupportSpacing) then
            continue
        end

        supportPointChunkGrid:Insert(position)
    end

    local supportPointGrid = {} :: SupportPointGrid

    SupportPointGenerator._generateMainlandSupports(supportPointGrid, islandGrid, supportConfig)
    SupportPointGenerator._generateStarterIslandSupports(supportPointGrid, starterIslandGrid)

    return supportPointGrid
end

return SupportPointGenerator