local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AuxHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 280, 0, 280)
main.Position = UDim2.new(0.5, -140, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BackgroundTransparency = 0.3
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false 
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "AUX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

local getIdBtn = Instance.new("TextButton")
getIdBtn.Name = "GetID"
getIdBtn.Size = UDim2.new(0, 115, 0, 35)
getIdBtn.Position = UDim2.new(0, 20, 0, 50)
getIdBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
getIdBtn.BackgroundTransparency = 0.2
getIdBtn.Text = "Heavy Punch ID"
getIdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getIdBtn.Font = Enum.Font.GothamSemibold
getIdBtn.TextSize = 12
getIdBtn.BorderSizePixel = 0
getIdBtn.Parent = main

local getIdCorner = Instance.new("UICorner")
getIdCorner.CornerRadius = UDim.new(0, 8)
getIdCorner.Parent = getIdBtn

local getLightIdBtn = Instance.new("TextButton")
getLightIdBtn.Name = "GetLightID"
getLightIdBtn.Size = UDim2.new(0, 115, 0, 35)
getLightIdBtn.Position = UDim2.new(0, 145, 0, 50)
getLightIdBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 40)
getLightIdBtn.BackgroundTransparency = 0.2
getLightIdBtn.Text = "Light Punch ID"
getLightIdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getLightIdBtn.Font = Enum.Font.GothamSemibold
getLightIdBtn.TextSize = 12
getLightIdBtn.BorderSizePixel = 0
getLightIdBtn.Parent = main

local getLightIdCorner = Instance.new("UICorner")
getLightIdCorner.CornerRadius = UDim.new(0, 8)
getLightIdCorner.Parent = getLightIdBtn

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 240, 0, 35)
toggle.Position = UDim2.new(0.5, -120, 0, 95)
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggle.BackgroundTransparency = 0.2
toggle.Text = "Start Goku/Gojo Combo: OFF"
toggle.TextColor3 = Color3.fromRGB(255, 80, 80)
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 14
toggle.BorderSizePixel = 0
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

-- ANTI-HEAVY PUNCH TOGGLE
local antiHeavyToggle = Instance.new("TextButton")
antiHeavyToggle.Name = "AntiHeavyToggle"
antiHeavyToggle.Size = UDim2.new(0, 240, 0, 35)
antiHeavyToggle.Position = UDim2.new(0.5, -120, 0, 185)
antiHeavyToggle.BackgroundColor3 = Color3.fromRGB(35, 30, 30)
antiHeavyToggle.BackgroundTransparency = 0.2
antiHeavyToggle.Text = "🛡️ Anti-Heavy Punch: OFF"
antiHeavyToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
antiHeavyToggle.Font = Enum.Font.GothamSemibold
antiHeavyToggle.TextSize = 14
antiHeavyToggle.BorderSizePixel = 0
antiHeavyToggle.Parent = main

local antiHeavyCorner = Instance.new("UICorner")
antiHeavyCorner.CornerRadius = UDim.new(0, 8)
antiHeavyCorner.Parent = antiHeavyToggle

local dropdown = Instance.new("Frame")
dropdown.Name = "Dropdown"
dropdown.Size = UDim2.new(0, 240, 0, 35)
dropdown.Position = UDim2.new(0.5, -120, 0, 140)
dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
dropdown.BackgroundTransparency = 0.2
dropdown.BorderSizePixel = 0
dropdown.Parent = main

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 8)
dropCorner.Parent = dropdown

local dropLabel = Instance.new("TextButton")
dropLabel.Size = UDim2.new(1, 0, 1, 0)
dropLabel.BackgroundTransparency = 1
dropLabel.Text = "🎯 Select Target Player ▼"
dropLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
dropLabel.Font = Enum.Font.GothamSemibold
dropLabel.TextSize = 13
dropLabel.Parent = dropdown

local dropList = Instance.new("ScrollingFrame")
dropList.Name = "List"
dropList.Size = UDim2.new(1, 0, 0, 0)
dropList.Position = UDim2.new(0, 0, 1, 5)
dropList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
dropList.BackgroundTransparency = 0.15
dropList.BorderSizePixel = 0
dropList.ScrollBarThickness = 4
dropList.Visible = false
dropList.ClipsDescendants = true
dropList.Parent = dropdown

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = dropList

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = dropList

local comboActive = false
local antiHeavyActive = false
local targetPlayer = nil
local originalPos = nil
local followConnection = nil
local attackConnection = nil
local antiHeavyConnection = nil
local capturedHeavyID = nil
local capturedLightID = nil
local isListeningHeavy = false
local isListeningLight = false
local currentAttackType = "Heavy"

local function updatePlayerList()
	for _, child in pairs(dropList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -8, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			btn.BackgroundTransparency = 0.3
			btn.Text = "👤 " .. p.Name
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 12
			btn.BorderSizePixel = 0
			btn.Parent = dropList
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 6)
			btnCorner.Parent = btn
			
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			end)
			
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			end)
			
			btn.MouseButton1Click:Connect(function()
				targetPlayer = p
				dropLabel.Text = "🎯 Target: " .. p.Name
				dropLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
				dropList.Visible = false
			end)
		end
	end
	
	dropList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4)
end

local function attackCombo()
	local attackID = capturedHeavyID or capturedLightID
	local attackInput = capturedHeavyID and "Heavy Punch" or "Light Punch"
	
	if not attackID then
		return
	end
	
	local args = {
		{
			Input = attackInput,
			ID = attackID
		}
	}
	
	pcall(function()
		ReplicatedStorage:WaitForChild("Events"):WaitForChild("Attack"):FireServer(unpack(args))
	end)
end

local function startAntiHeavy()
	if antiHeavyConnection then
		antiHeavyConnection:Disconnect()
	end
	
	-- Monitor incoming attacks and dodge
	antiHeavyConnection = RunService.Heartbeat:Connect(function()
		if not antiHeavyActive or not player.Character then
			return
		end
		
		local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
		local playerHum = player.Character:FindFirstChild("Humanoid")
		
		if not playerRoot or not playerHum then
			return
		end
		
		-- Check for nearby players attacking
		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer ~= player and otherPlayer.Character then
				local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
				local otherHum = otherPlayer.Character:FindFirstChild("Humanoid")
				
				if otherRoot and otherHum and otherHum.Health > 0 then
					local distance = (playerRoot.Position - otherRoot.Position).Magnitude
					
					-- If someone is close (attacking range)
					if distance < 10 then
						-- Dodge backwards quickly
						local dodgeDirection = (playerRoot.Position - otherRoot.Position).Unit
						local dodgeDistance = 15 -- studs away
						
						local newPosition = playerRoot.Position + (dodgeDirection * dodgeDistance)
						
						-- Teleport away (instant dodge)
						playerRoot.CFrame = CFrame.new(newPosition, otherRoot.Position)
						
						-- Small cooldown to avoid spam
						task.wait(0.5)
					end
				end
			end
		end
	end)
end

local function stopAntiHeavy()
	if antiHeavyConnection then
		antiHeavyConnection:Disconnect()
		antiHeavyConnection = nil
	end
end

local function startFollowing()
	if followConnection then
		followConnection:Disconnect()
	end
	
	followConnection = RunService.Heartbeat:Connect(function()
		if not comboActive then
			if followConnection then
				followConnection:Disconnect()
				followConnection = nil
			end
			return
		end
		
		if targetPlayer and targetPlayer.Character and player.Character then
			local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
			local targetHum = targetPlayer.Character:FindFirstChild("Humanoid")
			
			if targetRoot and playerRoot and targetHum and targetHum.Health > 0 then
				local targetCFrame = targetRoot.CFrame
				local offset = targetCFrame.LookVector * -3
				
				playerRoot.CFrame = CFrame.new(targetRoot.Position + offset, targetRoot.Position)
			end
		end
	end)
end

local function stopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	
	if originalPos and player.Character then
		local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
		if playerRoot then
			playerRoot.CFrame = originalPos
		end
	end
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	
	if method == "FireServer" and self.Name == "Attack" and args[1] then
		if type(args[1]) == "table" and args[1].ID then
			
			if isListeningHeavy and args[1].Input == "Heavy Punch" then
				capturedHeavyID = args[1].ID
				isListeningHeavy = false
				
				getIdBtn.Text = "✅ Heavy: " .. tostring(capturedHeavyID)
				getIdBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
				print("🎯 Heavy Punch ID: " .. tostring(capturedHeavyID))
			end
			
			if isListeningLight and args[1].Input == "Light Punch" then
				capturedLightID = args[1].ID
				isListeningLight = false
				
				getLightIdBtn.Text = "✅ Light: " .. tostring(capturedLightID)
				getLightIdBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
				print("🎯 Light Punch ID: " .. tostring(capturedLightID))
			end
		end
	end
	
	return oldNamecall(self, ...)
end))

getIdBtn.MouseButton1Click:Connect(function()
	if not isListeningHeavy then
		isListeningHeavy = true
		
		getIdBtn.Text = "👊 HEAVY PUNCH NOW!"
		getIdBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 40)
		
		task.spawn(function()
			task.wait(10)
			if isListeningHeavy then
				isListeningHeavy = false
				getIdBtn.Text = "⏱️ Timeout"
				getIdBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
				task.wait(2)
				getIdBtn.Text = "Heavy Punch ID"
				getIdBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
			end
		end)
	end
end)

getLightIdBtn.MouseButton1Click:Connect(function()
	if not isListeningLight then
		isListeningLight = true
		
		getLightIdBtn.Text = "👊 LIGHT PUNCH NOW!"
		getLightIdBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 40)
		
		task.spawn(function()
			task.wait(10)
			if isListeningLight then
				isListeningLight = false
				getLightIdBtn.Text = "⏱️ Timeout"
				getLightIdBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
				task.wait(2)
				getLightIdBtn.Text = "Light Punch ID"
				getLightIdBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 40)
			end
		end)
	end
end)

-- ANTI-HEAVY PUNCH TOGGLE
antiHeavyToggle.MouseButton1Click:Connect(function()
	antiHeavyActive = not antiHeavyActive
	
	if antiHeavyActive then
		antiHeavyToggle.Text = "🛡️ Anti-Heavy Punch: ON"
		antiHeavyToggle.TextColor3 = Color3.fromRGB(80, 255, 80)
		antiHeavyToggle.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
		
		startAntiHeavy()
		print("🛡️ Anti-Heavy Punch ACTIVATED! Auto-dodge enabled!")
	else
		antiHeavyToggle.Text = "🛡️ Anti-Heavy Punch: OFF"
		antiHeavyToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
		antiHeavyToggle.BackgroundColor3 = Color3.fromRGB(35, 30, 30)
		
		stopAntiHeavy()
		print("🛡️ Anti-Heavy Punch DISABLED!")
	end
end)

toggle.MouseButton1Click:Connect(function()
	comboActive = not comboActive
	
	if comboActive then
		if not targetPlayer then
			toggle.Text = "❌ SELECT A TARGET FIRST!"
			toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
			task.wait(1)
			toggle.Text = "Start Goku/Gojo Combo: OFF"
			toggle.TextColor3 = Color3.fromRGB(255, 80, 80)
			comboActive = false
			return
		end
		
		if not capturedHeavyID and not capturedLightID then
			toggle.Text = "❌ DETECT ID FIRST!"
			toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
			task.wait(1)
			toggle.Text = "Start Goku/Gojo Combo: OFF"
			toggle.TextColor3 = Color3.fromRGB(255, 80, 80)
			comboActive = false
			return
		end
		
		toggle.Text = "⚡ Goku/Gojo Combo: ACTIVE"
		toggle.TextColor3 = Color3.fromRGB(80, 255, 80)
		
		if player.Character then
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				originalPos = root.CFrame
			end
		end
		
		startFollowing()
		
		if attackConnection then
			attackConnection:Disconnect()
		end
		
		attackConnection = RunService.Heartbeat:Connect(function()
			if comboActive then
				task.wait(0.3)
				attackCombo()
			end
		end)
		
	else
		toggle.Text = "Start Goku/Gojo Combo: OFF"
		toggle.TextColor3 = Color3.fromRGB(255, 80, 80)
		
		if attackConnection then
			attackConnection:Disconnect()
			attackConnection = nil
		end
		
		stopFollowing()
		originalPos = nil
	end
end)

dropLabel.MouseButton1Click:Connect(function()
	dropList.Visible = not dropList.Visible
	if dropList.Visible then
		updatePlayerList()
		local targetSize = math.min(120, listLayout.AbsoluteContentSize.Y + 8)
		dropList:TweenSize(UDim2.new(1, 0, 0, targetSize), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		dropLabel.Text = "🎯 Select Target Player ▲"
	else
		dropList:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		task.wait(0.2)
		dropList.Visible = false
		if targetPlayer then
			dropLabel.Text = "🎯 Target: " .. targetPlayer.Name
		else
			dropLabel.Text = "🎯 Select Target Player ▼"
		end
	end
end)

updatePlayerList()

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
	if p == targetPlayer then
		targetPlayer = nil
		dropLabel.Text = "🎯 Select Target Player ▼"
		dropLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
		
		if comboActive then
			comboActive = false
			toggle.Text = "Start Goku/Gojo Combo: OFF"
			toggle.TextColor3 = Color3.fromRGB(255, 80, 80)
			stopFollowing()
		end
	end
	updatePlayerList()
end)

task.wait(0.5)
print("AUX HUB Loaded!")
print(" Anti-Heavy Punch: Protects you from attacks!")
print(" Goku/Gojo Combo: Combo your target!")
print("Not work? Try Manually Use your Punch or Heavy punch and detect your ID")
