--!strict
local Types = require(script.Parent.Parent.Types)
local Generator = script.Parent.Parent.Generator

type GeneratorGrids = Types.GeneratorGrids
type TerrainGrid = Types.TerrainGrid

local Crystal = require(Generator.Crystal)

-- local CrystalBuilder = {}

-- CrystalBuilder.Dependencies = {

-- }

return function(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local crystalGrid = grids[Crystal]

    local crystalWrites = {}

    for position, _ in crystalGrid do
        crystalWrites[position + Vector3.new(0, 1, 0)] = "Resource Crystal"
    end

    return crystalWrites
end