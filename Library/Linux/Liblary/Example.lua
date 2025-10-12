--[[

FOR DNS 

--]]

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/Linux/Liblary/Source.lua"))()

local window = library:CreateWindow("Main")

window:AddLabel({text = "Player Settings"})

window:AddToggle({
	text = "Enable ESP",
	state = false,
	callback = function(value)
		print("ESP:", value)
	end
})

window:AddColor({
	text = "ESP Color",
	color = Color3.fromRGB(255, 0, 0),
	callback = function(color)
		print("ESP Color:", color)
	end
})

window:AddToggle({
	text = "Infinite Jump",
	state = false,
	callback = function(value)
		print("Infinite Jump:", value)
	end
})

window:AddSlider({
	text = "Walk Speed",
	min = 16,
	max = 200,
	value = 16,
	float = 1,
	callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
	end
})

window:AddSlider({
	text = "Jump Power",
	min = 50,
	max = 300,
	value = 50,
	float = 1,
	callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
	end
})

window:AddButton({
	text = "Reset Character",
	callback = function()
		game.Players.LocalPlayer.Character:BreakJoints()
	end
})

window:AddBox({
	text = "Custom Name",
	value = "",
	callback = function(value, enter)
		if enter then
			print("Name set to:", value)
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

window:AddDropdown({
	text = "Team Select",
	list = {"Red", "Blue", "Green", "Yellow"},
	values = {},
	callback = function(values)
		print("Selected teams:", table.concat(values, ", "))
	end
})

local folder = window:AddFolder("Combat")

folder:AddToggle({
	text = "Auto Farm",
	state = false,
	callback = function(value)
		print("Auto Farm:", value)
	end
})

folder:AddColor({
	text = "Hitbox Color",
	color = Color3.fromRGB(0, 255, 0),
	callback = function(color)
		print("Hitbox Color:", color)
	end
})

folder:AddSlider({
	text = "Attack Speed",
	min = 1,
	max = 10,
	value = 1,
	float = 0.1,
	callback = function(value)
		print("Attack Speed:", value)
	end
})

folder:AddButton({
	text = "Kill All",
	callback = function()
		print("Kill All activated")
	end
})

local window2 = library:CreateWindow("Settings")

window2:AddToggle({
	text = "Show FPS",
	state = true,
	callback = function(value)
		print("Show FPS:", value)
	end
})

window2:AddColor({
	text = "UI Theme",
	color = Color3.fromRGB(255, 65, 65),
	callback = function(color)
		print("Theme Color:", color)
	end
})

window2:AddBox({
	text = "Discord Webhook",
	value = "",
	callback = function(value)
		print("Webhook:", value)
	end
})

library:Init()
