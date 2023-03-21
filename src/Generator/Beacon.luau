--!strict
local Types = require(script.Parent.Parent.Types)

type TerrainConfig = Types.TerrainConfig
type TerrainRandomizers = Types.TerrainRandomizers
type BeaconGrid = Types.BeaconGrid
type GeneratorGrids = Types.GeneratorGrids

local Beacon = {}

Beacon.Dependencies = {
    
}

function Beacon.Generate(terrainConfig: TerrainConfig, randomizers: TerrainRandomizers, grids: GeneratorGrids): BeaconGrid
    -- Config
    local beaconConfig = terrainConfig.Beacon
    
    local beaconGrid = {} :: BeaconGrid

    if beaconConfig.CentralBeacon then
        beaconGrid[Vector3.new(0, 0, 0)] = true 
    end

    local beaconAngleDifference = math.rad(360 / beaconConfig.BeaconCount)

    for i = 1, beaconConfig.BeaconCount do
        local unitX = math.cos(beaconAngleDifference * i)
        local unitY = math.sin(beaconAngleDifference * i)

        local scaledX = math.round(unitX * beaconConfig.Offset)
        local scaledY = math.round(unitY * beaconConfig.Offset)

        beaconGrid[Vector3.new(scaledX, 0, scaledY)] = true
    end

    return beaconGrid
end

return Beacon