local library = loadstring(game:HttpGet("https://pastefy.app/ExKO7llZ/raw"))()

-- Variables for Auto Spawn
local autoSpawnEnabled = false
local spawnSpeed = 1
local selectedTroop = "Infantry"
local spawnLoop

-- Variables for Auto Delete
local autoDeleteEnabled = false
local selectedDeleteTroop = "Infantry"
local deleteLoop
local playerBase = nil

-- Function to find player's base
local function findPlayerBase()
	local success, base = pcall(function()
		return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GetBase"):InvokeServer()
	end)
	
	if success and base then
		print("DEBUG: Detected your base:", base.Name)
		return base
	else
		print("DEBUG: Failed to get base from server")
		return nil
	end
end

-- Function to delete troop from player's base
local function deleteTroop()
	if not playerBase then
		playerBase = findPlayerBase()
	end
	
	if playerBase and playerBase:FindFirstChild("Plot") and playerBase.Plot:FindFirstChild("Objects") then
		local objects = playerBase.Plot.Objects
		
		-- Find the troop in objects
		for _, troop in pairs(objects:GetChildren()) do
			if troop.Name == selectedDeleteTroop then
				-- Get any part from the troop (Primary, Right Arm, Left Arm, etc.)
				for _, part in pairs(troop:GetChildren()) do
					if part:IsA("BasePart") then
						local args = { part }
						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TryDelete"):InvokeServer(unpack(args))
						print("Deleted:", selectedDeleteTroop, "from base:", playerBase.Name)
						return
					end
				end
			end
		end
	end
end

-- Auto Delete Loop Function
local function startAutoDelete()
	if deleteLoop then
		deleteLoop:Disconnect()
	end
	
	deleteLoop = game:GetService("RunService").Heartbeat:Connect(function()
		if autoDeleteEnabled then
			deleteTroop()
			task.wait(0.5)
		end
	end)
end

-- Function to spawn troop at player position
local function spawnTroop()
	local player = game.Players.LocalPlayer
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local position = player.Character.HumanoidRootPart.Position
		local cframe = CFrame.new(position.X, position.Y, position.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		
		local args = {
			selectedTroop,
			cframe,
			selectedTroop
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TryPlace"):InvokeServer(unpack(args))
		print("Spawned:", selectedTroop, "at position:", position)
	end
end

-- Auto Spawn Loop Function
local function startAutoSpawn()
	if spawnLoop then
		spawnLoop:Disconnect()
	end
	
	spawnLoop = game:GetService("RunService").Heartbeat:Connect(function()
		if autoSpawnEnabled then
			spawnTroop()
			task.wait(spawnSpeed)
		end
	end)
end

local window = library:CreateWindow("Build Your Army")

-- Auto Spawn Section
local spawnFolder = window:AddFolder("Spawn Troops ( Free )")

spawnFolder:AddToggle({
	text = "Auto Spawn",
	state = false,
	callback = function(value)
		autoSpawnEnabled = value
		print("Auto Spawn:", value)
		if value then
			startAutoSpawn()
		end
	end
})

spawnFolder:AddSlider({
	text = "Spawn Speed",
	min = 0.1,
	max = 10,
	value = 1,
	float = 0.1,
	callback = function(value)
		spawnSpeed = value
		print("Spawn Speed:", value)
	end
})

spawnFolder:AddDropdown({
	text = "Select Troop",
	list = {
		"Infantry",
		"Machine Gunner",
		"Rocketeer",
		"Humvee",
		"Special Force",
		"Tank",
		"Apc",
		"Sniper",
		"Heavy Tank",
		"Drone",
		"Artillery",
		"Medic",
		"Rocket Artillery",
		"Helicopter",
		"Jet"
	},
	values = {"Infantry"},
	callback = function(values)
		if #values > 0 then
			selectedTroop = values[1]
			print("Selected Troop:", selectedTroop)
		end
	end
})

spawnFolder:AddButton({
	text = "Spawn (Manual)",
	callback = function()
		spawnTroop()
	end
})

-- Auto Delete Section
local deleteFolder = window:AddFolder("Auto Delete ( Troops )")

deleteFolder:AddToggle({
	text = "Auto Delete",
	state = false,
	callback = function(value)
		autoDeleteEnabled = value
		print("Auto Delete:", value)
		if value then
			playerBase = findPlayerBase()
			if playerBase then
				print("Detected Base:", playerBase.Name)
			else
				print("Could not detect your base!")
			end
			startAutoDelete()
		end
	end
})

deleteFolder:AddDropdown({
	text = "Select Troop to Delete",
	list = {
		"Infantry",
		"Machine Gunner",
		"Rocketeer",
		"Humvee",
		"Special Force",
		"Tank",
		"Apc",
		"Sniper",
		"Heavy Tank",
		"Drone",
		"Artillery",
		"Medic",
		"Rocket Artillery",
		"Helicopter",
		"Jet"
	},
	values = {"Infantry"},
	callback = function(values)
		if #values > 0 then
			selectedDeleteTroop = values[1]
			print("Selected Troop to Delete:", selectedDeleteTroop)
		end
	end
})



library:Init()
