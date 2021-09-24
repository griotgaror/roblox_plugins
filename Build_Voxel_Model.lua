local TOOLBAR = plugin:CreateToolbar("Tool")
local PLUGIN_NAME = "Voxel Model Builder"
local PLUGIN_TEXT = "Build Voxel Modele"
local PLUGIN_ICON = "rbxassetid://4458901886"
local PLUGIN_INIT = TOOLBAR:CreateButton(PLUGIN_NAME, PLUGIN_TEXT, PLUGIN_ICON)

local GREEN = Color3.new(0, 1, 0)
local BLACK = Color3.new(0, 0, 0)
local WHITE = Color3.new(100, 100, 100)

local VOXEL_SIZE = 4

local selection = Instance.new("SelectionBox")
selection.LineThickness = 0.1

local holo = Instance.new("Part")
holo.Name = "holo"
holo.Anchored, holo.CanCollide, holo.CastShadow = true, false, false
holo.Size = Vector3.new(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE)
holo.Material = Enum.Material.Plastic

local mouse = nil

local Material = {"Plastic", "Grass"}

local place_objekt = function()
	if workspace:FindFirstChild("holo") then
		local objekt = holo:Clone()
		objekt:FindFirstChildOfClass("SelectionBox"):Destroy()
		objekt.Parent = workspace:FindFirstChild(PLUGIN_NAME)
		objekt.Transparency = 0
		objekt.CFrame = holo.CFrame
	end
end


function find_surface(list, value)
	for surface, action in pairs(list) do
		if surface == value and mouse.Target ~= nil  then
			holo.Parent = workspace
			holo.CFrame = CFrame.new(action)
			holo.Transparency = 0.5
			selection.Adornee = holo
			selection.Parent = holo
			selection.Color3 = GREEN
		end
	end
end 


function show_holo()
	if mouse.Target ~= nil and mouse.Target.Parent == workspace:FindFirstChild(PLUGIN_NAME) then
		mouse.TargetFilter = holo

		local Surfaces = {
			Right = mouse.Target.CFrame.p + Vector3.new(VOXEL_SIZE, 0, 0),
			Left = mouse.Target.CFrame.p - Vector3.new(VOXEL_SIZE, 0, 0),
			Back = mouse.Target.CFrame.p + Vector3.new(0, 0, VOXEL_SIZE),
			Front = mouse.Target.CFrame.p - Vector3.new(0, 0, VOXEL_SIZE),
			Bottom = mouse.Target.CFrame.p - Vector3.new(0, VOXEL_SIZE, 0),
			Top = mouse.Target.CFrame.p + Vector3.new(0, VOXEL_SIZE, 0),
		}

		setmetatable(Surfaces, {__call = find_surface})
		Surfaces(mouse.TargetSurface.Name)
	else
		selection.Parent = nil
		selection.Adornee = nil
		holo.Parent = nil
	end
end



-- function create_ui_button(frame)
-- 	for i = 1, #Material do
-- 		local image_button = Instance.new("ImageButton", frame)
-- 		image_button.BackgroundColor3 = WHITE
-- 		image_button.Size = UDim2.new(0 ,50, 0, 50)
-- 		image_button.Name = Material[i]

-- 		local image_script = Instance.new("Script", image_button)
-- 		image_script.Source =  [[
-- 			local Material = {
-- 				Plastic = Enum.Material.Plastic,
-- 				Grass  = Enum.Material.Grass,
-- 			}

-- 			script.Parent.MouseButton1Down:Connect(function()
-- 				for idx, value in pairs(Material) do
-- 					print(idx, value)

-- 				end
-- 			end)
-- 		]]
-- 	end
-- end


-- function create_gui()
-- 	local screen = Instance.new("ScreenGui", game.StarterGui)
-- 	screen.Name = PLUGIN_NAME
	
-- 	local frame = Instance.new("Frame", screen)
-- 	frame.AutomaticSize = Enum.AutomaticSize.XY
-- 	frame.BackgroundColor3 = BLACK
-- 	frame.BackgroundTransparency = 0.3
-- 	-- frame.Position = UDim2(0, 10, 0, 10)

-- 	local grid = Instance.new("UIGridLayout", frame)
-- 	grid.CellPadding = UDim2.new(0, 3, 0, 3)
-- 	grid.FillDirection = Enum.FillDirection.Vertical

-- 	create_ui_button(frame)
-- end


function init_plugin()
	if not workspace:FindFirstChild(PLUGIN_NAME) then	
		Instance.new("Folder", workspace).Name = PLUGIN_NAME
	
		plugin:Activate(true)
		--camera placing to first part
		local voxel = holo:Clone()
		voxel.CFrame = CFrame.new(Vector3.new(0, 0, 0))
		voxel.Parent = workspace:FindFirstChild(PLUGIN_NAME)
		voxel.Transparency = 0
	
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(voxel.CFrame.p + Vector3.new(10, 20, 0), voxel.CFrame.p)  * CFrame.Angles(math.rad(5), 0, 0)
		camera.CameraType = Enum.CameraType.Custom
		
		--init_mouse
		mouse = plugin:GetMouse()
		mouse.Move:Connect(show_holo)
		mouse.Button1Down:Connect(place_objekt)

		-- create_gui()
	end
end


PLUGIN_INIT.Click:Connect(init_plugin)

--Check Plugin Disable
workspace.ChildRemoved:Connect(function(child)
	if child.Name == PLUGIN_NAME then
		plugin:Deactivate()
		
		if workspace:FindFirstChild(holo.Name) then
			holo:Destroy()
		end

		if game.StarterGui:FindFirstChild(PLUGIN_NAME) then
			game.StarterGui:FindFirstChild(PLUGIN_NAME):Destroy()
		end

	end
end)

plugin.Deactivation:Connect(function()
	warn(PLUGIN_NAME, "Disable")
end)
