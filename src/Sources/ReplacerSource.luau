local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig

local WeightedChoice = require(script.Parent.Parent.Parent.WeightedChoice)

local Replacer = require(script.Parent.Parent.Classes.Replacer)

local ReplacerSource = {}

function ReplacerSource.CreateReplacers(terrainConfig: TerrainConfig)
    -- Config
    local seed = terrainConfig.Seed
    local replacementConfig = terrainConfig.Replacement

    local replacers = WeightedChoice.new(seed)

    for cellType, replacementEntry in replacementConfig do
        local replacer = Replacer.new(cellType, replacementEntry.Extent, replacementEntry.Matrix)
        replacers:AddChoice(replacer, replacementEntry.Weight)
    end

    return replacers
end

return ReplacerSource