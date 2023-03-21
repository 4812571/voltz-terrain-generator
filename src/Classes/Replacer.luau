local Replacer = {}
Replacer.__index = Replacer

type Grid = {
    [Vector3]: any,
}

export type Replacer = {
    Type: string,
    Extent: Vector3,
    Coverage: (self: Replacer, position: Vector3) -> { Vector3 },
    Overlaps: (self: Replacer, position: Vector3, grid: Grid) -> boolean,
    Matches: (self: Replacer, position: Vector3, grid: Grid) -> boolean,
}

function Replacer.new(cellType, extent, matrix)
    local self = setmetatable({}, Replacer)

    self.Type = cellType
    self.Extent = extent

    self._matrix = matrix

    return self
end

function Replacer:_coverageOffsets()
    local coverageOffsets = {}

    for dx = 0, self.Extent.X - 1 do
        for dy = 0, self.Extent.Y - 1 do
            for dz = 0, self.Extent.Z - 1 do
                local offset = Vector3.new(dx, dy, dz)
                table.insert(coverageOffsets, offset)
            end
        end
    end

    return coverageOffsets
end

function Replacer:Coverage(position: Vector3): { Vector3 }
    local coverage = {}

    for _, offset in self:_coverageOffsets() do
        table.insert(coverage, position + offset)
    end

    return coverage
end

function Replacer:Overlaps(position: Vector3, grid: Grid): boolean
    for _, position in self:Coverage(position) do
        if grid[position] then
            return true
        end
    end

    return false
end

function Replacer:Matches(position: Vector3, grid: Grid): boolean
    for _, offset in self:_coverageOffsets() do
        local cellType = grid[position + offset]

        if cellType ~= self._matrix[offset] then
            return false
        end
    end

    return true
end

return Replacer