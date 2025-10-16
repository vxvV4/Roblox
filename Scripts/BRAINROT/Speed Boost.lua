-- Speed Boost 
pcall(function() game.CoreGui:FindFirstChild("PremiumDeliveryGUI"):Destroy() end)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PremiumDeliveryGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 170, 0, 50)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 200, 120)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Transparency = 0.2

local label = Instance.new("TextButton", frame)
label.AnchorPoint = Vector2.new(0, 0.5)
label.Position = UDim2.new(0, 10, 0.5, 0)
label.Size = UDim2.new(0.5, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Speed Booster"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamSemibold
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
label.AutoButtonColor = false

local switch = Instance.new("TextButton", frame)
switch.AnchorPoint = Vector2.new(1, 0.5)
switch.Position = UDim2.new(1, -8, 0.5, 0)
switch.Size = UDim2.new(0, 46, 0, 22)
switch.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
switch.Text = ""
switch.AutoButtonColor = false
Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

local circle = Instance.new("Frame", switch)
circle.Size = UDim2.new(0, 18, 0, 18)
circle.Position = UDim2.new(0, 2, 0.5, -9)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BorderSizePixel = 0
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local speed = 28
local active = false
local heartbeatConn
local lastUpdate = 0
local updateInterval = 0.03

local function startSpeed()
	if heartbeatConn then heartbeatConn:Disconnect() end
	heartbeatConn = RunService.Heartbeat:Connect(function(delta)
		lastUpdate = lastUpdate + delta
		if lastUpdate < updateInterval then return end
		lastUpdate = 0

		if active and humanoid and humanoidRootPart then
			local moveDir = humanoid.MoveDirection
			if moveDir.Magnitude > 0 then
				humanoidRootPart.AssemblyLinearVelocity = moveDir * speed + Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
			end
		end
	end)
end

local function stopSpeed()
	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end
end

local function toggleSwitch()
	if active then
		active = false
		stopSpeed()
		TweenService:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
		TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
	else
		active = true
		startSpeed()
		TweenService:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0,200,120)}):Play()
		TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
	end
end

switch.MouseButton1Click:Connect(toggleSwitch)

Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")
	if active then
		task.wait(1)
		startSpeed()
	end
end)

local dragging, dragInput, dragStart, startPos
local dragThreshold = 5
local hasDragged = false

local function update(input)
	local delta = input.Position - dragStart
	if delta.Magnitude > dragThreshold then hasDragged = true end
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

label.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		hasDragged = false
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				if not hasDragged then toggleSwitch() end
			end
		end)
	end
end)

label.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)
