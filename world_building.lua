local plugin_name = "world_building"
local toolbar = plugin:CreateToolbar("Tools")
local button = toolbar:CreateButton(plugin_name, "a tool for voxel world building", "rbxassetid://4458901886")

local WHITE =  Color3.new(200, 200, 200)
local RED = Color3.new(1, 0, 0)

local selection = Instance.new("SelectionBox")
selection.LineThickness = 0.1
selection.Color3 = WHITE


local voxel_creation = function()
	local voxel = Instance.new("Part")
	voxel.Anchored, voxel.CastShadow = true, false
	voxel.Size = Vector3.new(4, 4, 4)
	
	return voxel
end


local find_objekts = function(objekt)
	local reg_1 = objekt.CFrame.p - Vector3.new(objekt.Size.X / 4, 1, objekt.Size.Z / 4)
	local reg_2 = objekt.CFrame.p + Vector3.new(objekt.Size.X / 4, 1, objekt.Size.Z / 4)
	
	local objekts_found = {}
	
	for _, part in pairs(workspace:FindPartsInRegion3(Region3.new(reg_1, reg_2), objekt)) do
		table.insert(objekts_found, part)
	end
	
	return #objekts_found
end


local holo = nil

local show_holo_boden = function(mouse)
	selection.Parent = holo
	selection.Adornee  = holo
	holo.Name = "test_objekt"
	
	local find_other_parts = find_objekts(holo)
	
	if find_other_parts > 0 then
		selection.Color3 = RED
		
	else
		selection.Color3 = WHITE
	end
	
	-- place holo boden
	if mouse.hit.X < mouse.Target.CFrame.X and mouse.hit.Z > mouse.Target.CFrame.Z then
		holo.Parent = workspace
		holo.CFrame = CFrame.new(mouse.Target.CFrame.p + Vector3.new(0, 0, holo.Size.Z))
		
	elseif mouse.hit.X > mouse.Target.CFrame.Y and mouse.hit.Z < mouse.Target.CFrame.Z then
		holo.Parent = workspace
		holo.CFrame = CFrame.new(mouse.Target.CFrame.p - Vector3.new(0, 0, holo.Size.Z))
		
	elseif mouse.hit.X> mouse.Target.CFrame.Y and mouse.hit.Z > mouse.Target.CFrame.Z then
		holo.Parent = workspace
		holo.CFrame = CFrame.new(mouse.Target.CFrame.p + Vector3.new(holo.Size.Z, 0, 0))
		
	elseif mouse.hit.X< mouse.Target.CFrame.Y and mouse.hit.Z < mouse.Target.CFrame.Z then
		holo.Parent = workspace
		holo.CFrame = CFrame.new(mouse.Target.CFrame.p - Vector3.new(holo.Size.Z, 0, 0))
	
	else
		holo.Parent = nil
	end
end


local place_objekt = function()
	if selection.Color3 == WHITE then
		local clone = holo:Clone()
		clone.Parent = workspace:FindFirstChild(plugin_name)
		clone.CFrame = holo.CFrame
		clone:FindFirstChildOfClass("SelectionBox"):Destroy()
		clone.Material = Enum.Material.Plastic

		holo.Parent = nil
	end
end


-- plugin is enable
local activate_plugin = function()
	plugin:Activate(true)
	local mouse = plugin:GetMouse()
	
	holo = Instance.new("Part")
	holo.Anchored, holo.CanCollide  = true, false
	holo.CastShadow = false
	holo.Size = Vector3.new(4, 4, 4)
	holo.Material = Enum.Material.ForceField
	
	--holo = voxel_creation()

	mouse.Move:Connect(function()
		if mouse.Target ~= nil and mouse.Target.Parent == workspace:FindFirstChild(plugin_name) then
			
			show_holo_boden(mouse)	
		else
			holo.Parent = nil
		end
	end)
	
	mouse.Button1Down:Connect(function()
		if workspace:FindFirstChild(holo.Name) then
			place_objekt()
		end
	end)
end


--press plugin icon
button.Click:Connect(function()
	if  not workspace:FindFirstChild(plugin_name) then
		Instance.new("Folder", workspace).Name = plugin_name
		
		local first_part = voxel_creation()
		first_part.CFrame = CFrame.new(Vector3.new(0, 0, 0))
		first_part.Parent = workspace:FindFirstChild(plugin_name)
		first_part.Material = Enum.Material.Plastic
		
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		
		local part = workspace:FindFirstChild(plugin_name):FindFirstChildOfClass("Part")
		camera.CFrame = CFrame.new(part.CFrame.p + Vector3.new(0, 25, 0), part.CFrame.p) * CFrame.Angles(math.rad(20), 0, 0)
		camera.CameraType = Enum.CameraType.Custom
		
		wait(1)
		if workspace:FindFirstChild(plugin_name) then
			activate_plugin()
		end
		
	end
end)


-- plugin deactivate
workspace.ChildRemoved:Connect(function(child)
	if child.Name == plugin_name then
		plugin:Deactivate()
		
		if workspace:FindFirstChild(holo.Name) then
			selection.Parent = nil
			selection.Adornee = nil
			holo:Destroy()
		end
		
	end
end)

