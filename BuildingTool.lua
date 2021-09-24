local pluginName = "BuildingTool"

function createPart(position)
	if workspace:FindFirstChild(pluginName) then
		local part = Instance.new("Part", workspace.BuildingTool)
		part.Size = Vector3.new(1, 1, 1)
		part.Anchored = true
		part.Material = Enum.Material.Metal
		part.CFrame = CFrame.new(position)
	end
end

-- PLUGIN ACTIVATE
local pluginClickt = false
local selectionService  = game:GetService("Selection")

selectionService.SelectionChanged:Connect(function()
	if pluginClickt == true then
		for _,  selection in pairs(selectionService:Get()) do
			if selection == workspace:FindFirstChild(pluginName) or workspace.BuildingTool:GetChildren() then
				plugin:Activate(false)
			else
				plugin:Activate(true)
			end
		end
	end
end)


local toolbar = plugin:CreateToolbar("modelBuilder")
local buildPlugin = toolbar:CreateButton(pluginName,  pluginName, "rbxassetid://4458901886")

buildPlugin.Click:Connect(function()
	if workspace:FindFirstChild(pluginName) then
		--PLUGIN FOLDER EXISTENT
	else
		pluginClickt = true
		
		local buildingTool = Instance.new("Folder", workspace)
		buildingTool.Name = pluginName
		createPart(Vector3.new(0, 20, 0))
		
		local selection = selectionService:Get()
		table.clear(selection)
		table.insert(selection, workspace:FindFirstChild(pluginName).Part)
		selectionService:Set(selection)
		
		local currentCamera = workspace.CurrentCamera
		currentCamera.Focus  = workspace:FindFirstChild(pluginName).Part.CFrame
	end
end)


function findSurface(mouse)
	local  mouseTarget = mouse.Target.CFrame
	local targetSize = mouse.Target.size
	
	local targetSurface = {
		Right = Vector3.new(mouseTarget.p.X + targetSize.X, mouseTarget.p.Y, mouseTarget.p.Z),
		Left = Vector3.new(mouseTarget.p.X - targetSize.X, mouseTarget.p.Y, mouseTarget.p.Z ),
		Top  = Vector3.new(mouseTarget.p.X, mouseTarget.p.Y + targetSize.Y, mouseTarget.p.Z ),
		Bottom = Vector3.new(mouseTarget.p.X, mouseTarget.Y - targetSize.Y, mouseTarget.Z),
		Front = Vector3.new(mouseTarget.p.X, mouseTarget.Y, mouseTarget.Z - targetSize.Z),
		Back = Vector3.new(mouseTarget.X, mouseTarget.Y, mouseTarget.Z + targetSize.Z) 
	}
	
	for surface, position in pairs(targetSurface) do
		if surface == mouse.TargetSurface.Name then
			print("Find Surface")
			createPart(position)
		end
	end
end

local mouse = plugin:GetMouse()
local userInputService = game:GetService("UserInputService")
local surfaceSelection

--PLACE BLOCK
mouse.Button1Down:Connect(function()
	if mouse.Target then
		if mouse.Target.Parent == workspace:FindFirstChild(pluginName) then
			print(mouse.TargetSurface.Name)
			findSurface(mouse)
		end
	end
end)

-- REMOVE BLOCK
userInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			if mouse.Target and mouse.Target.Parent == workspace:FindFirstChild(pluginName) then
				local pluginFolder = workspace:FindFirstChild(pluginName):GetChildren()
				
				if table.getn(pluginFolder) == 1 then
					--NOTHING
				else
					mouse.Target:Destroy()
				end
			end
		end
	end
end)


--SELECTET SURFACE
mouse.move:Connect(function()
	for _, selection in pairs(selectionService:Get()) do
		if selection == workspace:FindFirstChild(pluginName) then
			if  workspace:FindFirstChild(pluginName):FindFirstChild("SurfaceSelection") then
				if mouse.Target and mouse.Target.Parent == workspace:FindFirstChild(pluginName) then
					surfaceSelection.Adornee = mouse.Target
					surfaceSelection.TargetSurface = mouse.TargetSurface
				else
					surfaceSelection.Adornee = nil
				end	
			else
				surfaceSelection = Instance.new("SurfaceSelection", workspace:FindFirstChild(pluginName))
			end
		end
	end 
end)


