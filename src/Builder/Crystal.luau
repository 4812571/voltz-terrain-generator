--!strict
local Types = require(script.Parent.Parent.Types)

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local CrystalBuilder = {}

CrystalBuilder.Dependencies = {
    
}

function CrystalBuilder.Build(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local crystalGrid = grids.Crystal

    local crystalWrites = {}

    for position, _ in crystalGrid do
        crystalWrites[position + Vector3.new(0, 1, 0)] = "Resource Crystal"
    end

    return crystalWrites
end

return CrystalBuilder