--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type CrystalGrid = Types.CrystalGrid
type GeneratorGrids = Types.GeneratorGrids

local CrystalGenerator = {}

CrystalGenerator.Dependencies = {
    "Island",
    "Spire",
}

function CrystalGenerator.Generate(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): CrystalGrid
    -- Grids
    local islandGrid = grids.Island
    local spireGrid = grids.Spire

    -- Config
    local crystalConfig = config.Crystal

    -- Randomizers
    local crystalRandom = randomizers.Crystal

    local crystalGrid = {} :: CrystalGrid

    for position, _ in islandGrid do
        -- Spire Avoidance
        if spireGrid[position] then
            continue
        end

        -- Crystal Randomization
        if crystalRandom:NextNumber() < crystalConfig.SpawnRate then
            crystalGrid[position] = true
        end
    end

    return crystalGrid
end

return CrystalGenerator