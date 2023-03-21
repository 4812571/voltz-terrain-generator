local Types = require(script.Parent.Types)

type CellGrid = Types.CellGrid
type WelderResult = Types.WelderResult
type WeldGraph = Types.WeldGraph

local Graph = require(script.Parent.Parent.Graph)

local Welder = {}

local neighborOffsets = {
    Vector3.new(-1,  0,  0),
    Vector3.new( 1,  0,  0),
    Vector3.new( 0, -1,  0),
    Vector3.new( 0,  1,  0),
    Vector3.new( 0,  0, -1),
    Vector3.new( 0,  0,  1),
}

function Welder._getNeighbors(cellPosition, cellGrid)
    local neighbors = {}

    for _, offset in neighborOffsets do
        local neighborPosition = cellPosition + offset
        local neighborCellId = cellGrid[neighborPosition]

        if neighborCellId then
            table.insert(neighbors, neighborCellId)
        end
    end

    return neighbors
end

function Welder._createWeld(cellModel, neighborCellModel)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = cellModel.PrimaryPart
    weld.Part1 = neighborCellModel.PrimaryPart
    weld.Parent = cellModel

    return weld
end

function Welder.Weld(cellGrid: CellGrid, cellModels: { Model }): WelderResult
    local weldGraph = Graph.new() :: WeldGraph
    local welds = {}

    for cellPosition, cellId in cellGrid do
        local cellModel = cellModels[cellId]

        for _, neighborCellId in Welder._getNeighbors(cellPosition, cellGrid) do
            -- Skip Self Welds
            if cellId == neighborCellId then
                continue
            end

            local neighborCellModel = cellModels[neighborCellId]

            -- Skip Duplicate Welds
            if weldGraph:HasEdge(cellModel, neighborCellModel) then
                continue
            end

            -- Weld
            local weld = Welder._createWeld(cellModel, neighborCellModel)

            -- Record Weld
            table.insert(welds, weld)
            weldGraph:AddEdgePair(cellModel, neighborCellModel, weld)
        end
    end
    
    local weldResult = {
        Welds = welds,
        WeldGraph = weldGraph,
    }

    return weldResult
end

return Welder