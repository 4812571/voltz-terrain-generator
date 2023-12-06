local Replacer = require(script.Parent.Classes.Replacer)

-- Cell Types
export type CellType = string
export type CellId = number

-- Replacement Config
export type ReplacementMatrix = {
    [Vector3]: CellType,
}

export type ReplacementEntry = {
    Matrix: ReplacementMatrix,
    Extent: Vector3,
    Weight: number,
}

export type ReplacementConfig = {
    [CellType]: ReplacementEntry,
}

-- Selection Config
export type SelectionEntry = {
    Model: Model,
    Weight: number,
}

export type SelectionEntries = { SelectionEntry }

export type SelectionConfig = {
    [CellType]: SelectionEntries,
}

-- Noise Config
export type NoiseConfig = {
    Weight: number,
    Scale: number,
}

-- Generator Config
export type SupportConfig = {
    Height: number,
    SupportSpacing: number,
    LadderChance: number,
    WellChance: number,
    CircularChance: number,
    MinRadius: number,
    MaxRadius: number,
}

export type IslandConfig = {
    Size: number,
    Gaps: NoiseConfig,
    Depth: NoiseConfig,
}

export type BeaconConfig = {
    Offset: number,
    BeaconCount: number,
    CentralBeacon: boolean,
}

export type StarterIslandConfig = {
    IslandCount: number,
    IslandOffset: number,
    RadiusVariation: NoiseConfig,
}

export type CrystalConfig = {
    SpawnRate: number
}

export type SpireConfig = {
    Cities: NoiseConfig,
    Buildings: NoiseConfig,
    Alleys: NoiseConfig,
    Height: NoiseConfig,
}

export type GrassConfig = {
    Grass: NoiseConfig,
}

-- Terrain Config
export type TerrainConfig = {
    -- General
    Seed: number,
    CellSize: number,

    -- Template
    Replacement: ReplacementConfig,
    Selection: SelectionConfig,

    -- Generation
    Support: SupportConfig,
    Island: IslandConfig,
    Beacon: BeaconConfig,
    StarterIsland: StarterIslandConfig,
    Crystal: CrystalConfig,
    Spire: SpireConfig,
    Grass: GrassConfig,
}

-- Terrain Randomizers
export type Noise2D = {
    UnitNoise: (self: Noise2D, x: number, y: number, scale: number) -> number,
    Range: (self: Noise2D, x: number, y: number, scale: number, range: number) -> boolean,
    EdgeRange: (self: Noise2D, x: number, y: number, scale: number, range: number) -> boolean,
}

export type TerrainRandomizers = {
    -- Island
    IslandGaps: Noise2D,
    IslandDepth: Noise2D,

    -- Starter Island
    StarterIslandRadius: Noise2D,

    -- Crystal
    Crystal: Random,

    -- Spire
    SpireCities: Noise2D,
    SpireBuildings: Noise2D,
    SpireAlleys: Noise2D,
    SpireHeight: Noise2D,

    -- Grass
    Grass: Noise2D,

    -- Support
    SupportRadius: Random,
    SupportCircular: Random,
    SupportWell: Random,
    SupportLadder: Random,
}

-- Terrain Selectors
export type RandomChoice<T> = {
    AddChoice: (self: RandomChoice<T>, choice: T, weight: number) -> (),
    Choose: (self: RandomChoice<T>) -> T,
}

export type TerrainSelector = RandomChoice<Model>

export type TerrainSelectors = {
    [CellType]: TerrainSelector,
}

-- Terrain Replacements
export type TerrainReplacer = Replacer.Replacer
export type TerrainReplacers = RandomChoice<TerrainReplacer>

-- Generator Grids
export type Generator = (TerrainConfig, TerrainRandomizers, GeneratorGrids) -> { [any]: any }

export type GeneratorGrids = { [Generator]: { [any]: any } }
export type IslandGrid = {
    [Vector3]: number,
}

export type BeaconGrid = {
    [Vector3]: true,
}

export type CrystalGrid = {
    [Vector3]: true,
}

export type SpireGrid = {
    [Vector3]: number,
}

export type GrassGrid = {
    [Vector3]: true,
}

export type SupportColumnType = "Ladder" | "Well" | "Fill"

export type SupportSubGrid = {
    [Vector3]: SupportColumnType,
}

export type SupportGrid = {
	[Vector3]: SupportSubGrid
}

export type SupportPointGrid = {
    [Vector3]: true,
}

export type SupportHeightGrid = {
    [Vector3]: number,
}

export type StarterIslandPointGrid = {
    [Vector3]: true,
}

export type StarterIslandSubGrid = {
    [Vector3]: number,
}

export type StarterIslandGrid = {
    [Vector3]: StarterIslandSubGrid,
}

-- Terrain Grids
export type Builder = (GeneratorGrids) -> TerrainGrid

export type TerrainGrid = {
    [Vector3]: CellType,
}

export type CellGrid = {
    [Vector3]: CellId,
}

export type CellTypes = {
    [CellId]: CellType,
}

export type CellPositions = {
    [CellId]: Vector3,
}

export type CellExtents = {
    [CellId]: Vector3,
}

export type ReplacerResult = {
    CellGrid: CellGrid,
    CellTypes: CellTypes,
    CellPositions: CellPositions,
    CellExtents: CellExtents,
}

export type Graph<Node, Edge> = {
    AddEdgePair: (self: Graph<Node, Edge>, node1: Node, node2: Node, edge: Edge?) -> (),
    HasEdge: (self: Graph<Node, Edge>, node1: Node, node2: Node) -> any,
}

export type WeldGraph = Graph<Model, Weld>

export type WelderResult = {
    Welds: { Weld },
    WeldGraph: WeldGraph,
}

return nil