local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig

local WeightedChoice = require(script.Parent.Parent.Parent.WeightedChoice)

local SelectorSource = {}

function SelectorSource.CreateSelectors(terrainConfig: TerrainConfig)
    -- Config
    local seed = terrainConfig.Seed
    local selectionConfig = terrainConfig.Selection

    local random = Random.new(seed)

    local selectors = {}

    for cellType, selectionEntries in selectionConfig do
        local selector = WeightedChoice.new(random:NextNumber())

        for _, selectionEntry in selectionEntries do
            selector:AddChoice(selectionEntry.Model, selectionEntry.Weight)
        end

        selectors[cellType] = selector
    end

    return selectors
end

return SelectorSource