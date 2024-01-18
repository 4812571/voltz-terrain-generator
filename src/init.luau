--!strict
local Types = require(script.Types)

type TerrainConfig = Types.TerrainConfig
type Generator = Types.Generator
type Builder = Types.Builder

-- Object Sources
local RandomizerSource = require(script.Sources.RandomizerSource)
local ReplacerSource = require(script.Sources.ReplacerSource)
local SelectorSource = require(script.Sources.SelectorSource)

-- Generation
local Generator = require(script.Generator)
local Builder = require(script.Builder)
local Replacer = require(script.Replacer)
local Selector = require(script.Selector)
local Renderer = require(script.Renderer)
local Welder = require(script.Welder)
local Positioner = require(script.Positioner)
local Consumer = require(script.Consumer)

local Terrain = {}

-- Helper Aliases
Terrain.ConsumeReplacementFolder = Consumer.ConsumeReplacementFolder
Terrain.ConsumeSelectionFolder = Consumer.ConsumeSelectionFolder

function Terrain.Generate(terrainConfig: TerrainConfig, generatorOrder: { Generator }?, buildOrder: { Builder }?)
	-- Source Objects
	local randomizers = RandomizerSource.CreateRandomizers(terrainConfig)
	local replacers = ReplacerSource.CreateReplacers(terrainConfig)
	local selectors = SelectorSource.CreateSelectors(terrainConfig)

	-- Generate Grids
	local grids = Generator.Generate(terrainConfig, randomizers, generatorOrder)

	-- Generate Terrain Grid
	local terrainGrid = Builder.Build(grids, buildOrder)

	-- Replace Cells
	local replacerResult = Replacer.Replace(terrainGrid, replacers)

	local cellGrid = replacerResult.CellGrid
	local cellTypes = replacerResult.CellTypes
	local cellPositions = replacerResult.CellPositions
	local cellExtents = replacerResult.CellExtents

	-- Select Templates
	local templateModels = Selector.Select(selectors, cellTypes)

	-- Position Templates
	local finalPositions = Positioner.Position(terrainConfig, cellPositions, cellExtents)

	-- Render Terrain
	local cellModels = Renderer.Render(templateModels, finalPositions)

	-- Weld Terrain
	local weldResult = Welder.Weld(cellGrid, cellModels)

	local weldGraph = weldResult.WeldGraph
	local welds = weldResult.Welds

	-- Package Results
	local generationResult = {
		Models = cellModels,
		Welds = welds,
		WeldGraph = weldGraph,
	}

	return generationResult
end

return Terrain
