--!strict
local Types = require(script.Parent.Types)

type TerrainSelectors = Types.TerrainSelectors
type CellTypes = Types.CellTypes

local Selector = {}

function Selector.Select(selectors: TerrainSelectors, cellTypes: CellTypes): { Model }
    local models = {}

    for cellId, cellType in cellTypes do
        models[cellId] = selectors[cellType]:Choose()
    end

    return models
end

return Selector