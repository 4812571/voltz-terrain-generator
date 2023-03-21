--!strict
local Types = require(script.Parent.Types)

type TerrainGrid = Types.TerrainGrid
type TerrainReplacers = Types.TerrainReplacers
type ReplacerResult = Types.ReplacerResult

local TableUtil = require(script.Parent.Parent.TableUtil)
local Counter = require(script.Parent.Parent.Counter)

local Replacer = {}

function Replacer._loadLargeCells(terrainGrid, idGenerator, replacers, cellGrid)
    local cellTypes = {}
    local cellPositions = {}
    local cellExtents = {}

    for position, _ in terrainGrid do
        -- Select Replacer
        local selectedReplacer = replacers:Choose()

        -- Cell Avoidance
        if selectedReplacer:Overlaps(position, cellGrid) then
            continue
        end

        -- Placement Check
        if not selectedReplacer:Matches(position, terrainGrid) then
            continue
        end

        -- Generate Id & Store Cell Data
        local cellId = idGenerator:Next()
        cellTypes[cellId] = selectedReplacer.Type
        cellPositions[cellId] = position
        cellExtents[cellId] = selectedReplacer.Extent

        -- Reserve Cells
        for _, position in selectedReplacer:Coverage(position) do
            cellGrid[position] = cellId
        end
    end

    local largeCells = {
        Types = cellTypes,
        Positions = cellPositions,
        Extents = cellExtents,
    }

    return largeCells
end

function Replacer._loadSmallCells(terrainGrid, idGenerator, cellGrid)
    local cellTypes = {}
    local cellPositions = {}
    local cellExtents = {}

    for position, cellType in terrainGrid do
        -- Ignore Large Cell Reservations
        if cellGrid[position] then
            continue
        end

        -- Generate Id & Store Cell Data
        local cellId = idGenerator:Next()
        cellTypes[cellId] = cellType
        cellPositions[cellId] = position
        cellExtents[cellId] = Vector3.new(1, 1, 1)

        -- Reserve Cell
        cellGrid[position] = cellId
    end

    local smallCells = {
        Types = cellTypes,
        Positions = cellPositions,
        Extents = cellExtents,
    }

    return smallCells
end

function Replacer.Replace(terrainGrid: TerrainGrid, replacers: TerrainReplacers): ReplacerResult
    local idGenerator = Counter.new()

    local cellGrid = {}

    local largeCells = Replacer._loadLargeCells(terrainGrid, idGenerator, replacers, cellGrid)
    local smallCells = Replacer._loadSmallCells(terrainGrid, idGenerator, cellGrid)

    local replacerResult = {
        CellGrid = cellGrid,
        CellTypes = TableUtil.Assign(largeCells.Types, smallCells.Types),
        CellPositions = TableUtil.Assign(largeCells.Positions, smallCells.Positions),
        CellExtents = TableUtil.Assign(largeCells.Extents, smallCells.Extents),
    }

    return replacerResult
end

return Replacer