--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainGrid = Types.TerrainGrid
type GeneratorGrids = Types.GeneratorGrids

local SupportBuilder = {}

SupportBuilder.Dependencies = {
    "Island",
    "StarterIsland",
}

function SupportBuilder.Build(grids: GeneratorGrids): TerrainGrid
    -- Grids
    local supportGrid = grids.Support
    local supportHeightGrid = grids.SupportHeight

    local supportWrites = {}

    for position, support in supportGrid do
        local supportHeight = supportHeightGrid[position]

        for offset, column in support do
            local columnPosition = position + offset

            if column == "Fill" then
                for y = -supportHeight, -1 do
                    supportWrites[columnPosition + Vector3.new(0, y, 0)] = "Support Fill"
                end

                continue
            end

            if column == "Ladder" then
                for y = -supportHeight, 0 do
                    supportWrites[columnPosition + Vector3.new(0, y, 0)] = "Support Ladder"
                end

                continue
            end

            if column == "Well" then
                for y = -supportHeight, 0 do
                    if y == 0 then
                        supportWrites[columnPosition + Vector3.new(0, y, 0)] = "Support Well Top"
                    else
                        supportWrites[columnPosition + Vector3.new(0, y, 0)] = "Support Well"
                    end
                end

                continue
            end

            error("Unknown support column type: " .. column)
        end
    end

    return supportWrites
end

return SupportBuilder