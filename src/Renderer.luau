--!strict
local Types = require(script.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type CellGrid = Types.CellGrid

local Renderer = {}

function Renderer.Render(templateModels, finalPositions): { Model }
    local cellModels = {}

    for cellId, templateModel in templateModels do
        local model = templateModel:Clone()
        local modelCFrame = CFrame.new(finalPositions[cellId])

        model:PivotTo(modelCFrame)
        cellModels[cellId] = model
    end

    return cellModels
end

return Renderer