--!strict
local Types = require(script.Parent.Types)

type ReplacementConfig = Types.ReplacementConfig
type SelectionConfig = Types.SelectionConfig
type SelectionEntries = Types.SelectionEntries
type SelectionEntry = Types.SelectionEntry

local Consumer = {}

function Consumer.ConsumeReplacementFolder(replacementsFolder: Folder, cellSize: Vector3): ReplacementConfig
	local replacementConfig = {}

	-- Rounding is necessary to prevent floating point errors
	local function roundV3(v3: Vector3): Vector3
		return Vector3.new(math.round(v3.X), math.round(v3.Y), math.round(v3.Z))
	end

	for _, replacementModel in replacementsFolder:GetChildren() do
		-- Validate Model
		local mainPart = assert(replacementModel:FindFirstChild("Main"), "Replacement model must have a 'Main' part") :: BasePart
		local matrixFolder = assert(replacementModel:FindFirstChild("Matrix"), "Replacement model must have a 'Matrix' folder") :: Folder
		local weight = assert(replacementModel:GetAttribute("Weight"), "Replacement model must have a 'Weight' attribute") :: number
		
		-- Generate Replacement Matrix
		local cornerPosition = mainPart.Position - (mainPart.Size / 2) + (cellSize / 2)

		local replacementMatrix = {}

		for _, matrixPart in matrixFolder:GetChildren() do
			if matrixPart:IsA("BasePart") then
				local cellPosition = (matrixPart.Position - cornerPosition) / cellSize
				local cellType = matrixPart.Name

				-- Add Cell to Matrix
				replacementMatrix[roundV3(cellPosition)] = cellType
			end
		end

		-- Generate Replacement Entry
		local replacementEntry = {
			Matrix = replacementMatrix,
			Weight = weight,
			Extent = roundV3(mainPart.Size / cellSize),
		}

		replacementConfig[replacementModel.Name] = replacementEntry
	end

	return replacementConfig
end

function Consumer.ConsumeSelectionFolder(cellTemplateFolder: Folder): SelectionConfig
	local selectionConfig = {} :: SelectionConfig

	for _, cellTypeFolder in cellTemplateFolder:GetChildren() do
		local selectionEntries = {} :: SelectionEntries

		for _, cellTemplate in cellTypeFolder:GetChildren() do
			-- Validate Model
			local weight = assert(cellTemplate:GetAttribute("Weight"), "Cell template must have a 'Weight' attribute") :: number
	
			-- Strip Custom Attributes
			local templateClone = cellTemplate:Clone() :: Model
			templateClone:SetAttribute("Weight", nil)

			-- Generate Selection Entry
			local selectionEntry = {
				Model = templateClone,
				Weight = weight,
			} :: SelectionEntry

			table.insert(selectionEntries, selectionEntry)
		end

		selectionConfig[cellTypeFolder.Name] = selectionEntries
	end

	return selectionConfig
end

return Consumer