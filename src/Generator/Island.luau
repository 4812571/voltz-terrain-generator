--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type IslandGrid = Types.IslandGrid
type GeneratorGrids = Types.GeneratorGrids

-- IslandGenerator.Dependencies = {

-- }

return function(config: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): IslandGrid
	-- Config
	local islandConfig = config.Island

	-- Randomizers
	local gapNoise = randomizers.IslandGaps
	local depthNoise = randomizers.IslandDepth

	local islandGrid = {}

	for x = -islandConfig.Size, islandConfig.Size do
		for z = -islandConfig.Size, islandConfig.Size do
			-- Circle
			if math.sqrt(x*x + z*z) > islandConfig.Size then
				continue
			end

			-- Gaps
			if gapNoise:Range(x, z, islandConfig.Gaps.Scale, islandConfig.Gaps.Weight) then
				continue
			end

			-- Depth
			local depth = math.floor(depthNoise:UnitNoise(x, z, islandConfig.Depth.Scale) * islandConfig.Depth.Weight)

			-- Grid
			islandGrid[Vector3.new(x, 0, z)] = depth
		end
	end

	return islandGrid
end