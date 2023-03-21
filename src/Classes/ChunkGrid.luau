local ChunkGrid = {}
ChunkGrid.__index = ChunkGrid

export type ChunkGrid = {
    Insert: (self: ChunkGrid, position: Vector3) -> (),
    IsInRange: (self: ChunkGrid, position: Vector3, range: number) -> boolean,
    GetElements: (self: ChunkGrid) -> { Vector3 },
}

function ChunkGrid.new(chunkSize: Vector3): ChunkGrid
    local self = setmetatable({}, ChunkGrid)
    self._chunkSize = chunkSize
    self._chunks = {}
    return self
end

function ChunkGrid:Insert(position: Vector3): ()
    local chunkPosition = Vector3.new(
        math.floor(position.X / self._chunkSize.X),
        math.floor(position.Y / self._chunkSize.Y),
        math.floor(position.Z / self._chunkSize.Z)
    )

    local chunk = self._chunks[chunkPosition]

    if not chunk then
        chunk = {}
        self._chunks[chunkPosition] = chunk
    end

    chunk[position] = true
end


function ChunkGrid:IsInRange(position: Vector3, range: number)
    local minPosition = position - Vector3.new(range, range, range)
    local maxPosition = position + Vector3.new(range, range, range)

    local minChunkPosition = Vector3.new(
        math.floor(minPosition.X / self._chunkSize.X),
        math.floor(minPosition.Y / self._chunkSize.Y),
        math.floor(minPosition.Z / self._chunkSize.Z)
    )

    local maxChunkPosition = Vector3.new(
        math.floor(maxPosition.X / self._chunkSize.X),
        math.floor(maxPosition.Y / self._chunkSize.Y),
        math.floor(maxPosition.Z / self._chunkSize.Z)
    )

    for x = minChunkPosition.X, maxChunkPosition.X do
        for y = minChunkPosition.Y, maxChunkPosition.Y do
            for z = minChunkPosition.Z, maxChunkPosition.Z do
                local chunkPosition = Vector3.new(x, y, z)
                local chunk = self._chunks[chunkPosition]

                if not chunk then
                    continue
                end

                for elementPosition, _ in chunk do
                    if (elementPosition - position).Magnitude <= range then
                        return true
                    end
                end
            end
        end
    end

    return false
end


function ChunkGrid:GetElements(): { Vector3 }
    local elements = {}

    for _, chunk in pairs(self._chunks) do
        for elementPosition, _ in chunk do
            table.insert(elements, elementPosition)
        end
    end

    return elements
end

return ChunkGrid