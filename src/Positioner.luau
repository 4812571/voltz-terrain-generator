local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type CellPositions = Types.CellPositions
type CellExtents = Types.CellExtents

local Positioner = {}

function Positioner.Position(terrainConfig: TerrainConfig, positions: CellPositions, extents: CellExtents): CellPositions
    local centerPositions = {}

    for cellId, position in positions do
        centerPositions[cellId] = (position + extents[cellId] / 2) * terrainConfig.CellSize
    end

    return centerPositions
end

return Positioner