--[[

Steal a BlackPink Script

--]]

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/Linux/Liblary/Source.lua"))()

local window = library:CreateWindow("Steal a BlackPink")

-- Luck Folder
local luckFolder = window:AddFolder("Luck")

luckFolder:AddButton({
	text = "2x Server Luck (15 min)",
	callback = function()
		game:GetService("ReplicatedStorage")["2xServerLuckPurchaseEvent"]:FireServer()
		print("2x Server Luck activated")
	end
})

-- Cash Packs Folder
local cashFolder = window:AddFolder("Cash Packs")

cashFolder:AddButton({
	text = "30K Cash",
	callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		ReplicatedStorage["CashPack#1PurchaseEvent"]:FireServer()
		print("30K Cash claimed")
	end
})

cashFolder:AddButton({
	text = "250K Cash",
	callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		ReplicatedStorage["CashPack#2PurchaseEvent"]:FireServer()
		print("250K Cash claimed")
	end
})

cashFolder:AddButton({
	text = "1M Cash",
	callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		ReplicatedStorage["CashPack#3PurchaseEvent"]:FireServer()
		print("1M Cash claimed")
	end
})

cashFolder:AddButton({
	text = "5M Cash",
	callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		ReplicatedStorage["CashPack#4PurchaseEvent"]:FireServer()
		print("5M Cash claimed")
	end
})

cashFolder:AddButton({
	text = "10M Cash",
	callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		ReplicatedStorage["CashPack#5PurchaseEvent"]:FireServer()
		print("10M Cash claimed")
	end
})

-- Auto Farm Folder
local farmFolder = window:AddFolder("Auto Farm")

local autoFarmEnabled = false

farmFolder:AddToggle({
	text = "Auto Farm Money",
	state = false,
	callback = function(value)
		autoFarmEnabled = value
		print("Auto Farm:", value)
	end
})

-- Stealing Folder
local stealFolder = window:AddFolder("Stealing")

local savedPosition = nil

stealFolder:AddButton({
	text = "Save Position",
	callback = function()
		local player = game.Players.LocalPlayer
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			savedPosition = player.Character.HumanoidRootPart.CFrame
			print("Position saved!")
		end
	end
})

stealFolder:AddButton({
	text = "Teleport to Saved Position",
	callback = function()
		local player = game.Players.LocalPlayer
		if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = savedPosition
			print("Teleported to saved position!")
		else
			warn("No position saved!")
		end
	end
})

local walkSpeedEnabled = false
local currentWalkSpeed = 16

stealFolder:AddToggle({
	text = "Walk Speed",
	state = false,
	callback = function(value)
		walkSpeedEnabled = value
		local player = game.Players.LocalPlayer
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			if value then
				player.Character.Humanoid.WalkSpeed = currentWalkSpeed
			else
				player.Character.Humanoid.WalkSpeed = 16
			end
		end
	end
})

stealFolder:AddSlider({
	text = "Walk Speed",
	min = 16,
	max = 200,
	value = 16,
	float = 1,
	callback = function(value)
		currentWalkSpeed = value
		local player = game.Players.LocalPlayer
		if walkSpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = value
		end
	end
})

local noclipEnabled = false

stealFolder:AddToggle({
	text = "Noclip",
	state = false,
	callback = function(value)
		noclipEnabled = value
		print("Noclip:", value)
	end
})

local espEnabled = false

stealFolder:AddToggle({
	text = "ESP (Highlights)",
	state = false,
	callback = function(value)
		espEnabled = value
		if value then
			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character then
					local highlight = Instance.new("Highlight")
					highlight.Name = "ESP_Highlight"
					highlight.Adornee = player.Character
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					highlight.Parent = player.Character
				end
			end
		else
			for _, player in pairs(game.Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
					player.Character.ESP_Highlight:Destroy()
				end
			end
		end
	end
})

window:AddBind({
	text = "Toggle UI",
	key = "RightShift",
	callback = function()
		library:Close()
	end
})

library:Init()

-- Noclip Loop
game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled then
		local player = game.Players.LocalPlayer
		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- ESP Update Loop
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if espEnabled then
			wait(0.5)
			local highlight = Instance.new("Highlight")
			highlight.Name = "ESP_Highlight"
			highlight.Adornee = character
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.Parent = character
		end
	end)
end)

-- Auto Farm Loop
spawn(function()
	while true do
		if autoFarmEnabled then
			for i = 1, 5 do
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				
				ReplicatedStorage["CashPack#5PurchaseEvent"]:FireServer()
				ReplicatedStorage["CashPack#4PurchaseEvent"]:FireServer()
				ReplicatedStorage["CashPack#3PurchaseEvent"]:FireServer()
				
				task.wait(0.01)
			end
			task.wait(0.1)
		else
			task.wait(0.5)
		end
	end
end)
