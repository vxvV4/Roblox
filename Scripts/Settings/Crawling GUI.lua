local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 2,
})

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextButton0 = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0,0,250)
Frame.BorderColor3 = Color3.new(0,0,250)
Frame.Position = UDim2.new(0.9,0,0.5)
Frame.Size = UDim2.new(0.08,0,0.1)
Frame.Active = true
Frame.Draggable = true 

TextButton0.Parent = Frame
TextButton0.BackgroundColor3 = Color3.new(10,5,0)
TextButton0.BackgroundTransparency = 0.0000000001
TextButton0.Position = UDim2.new(0.103524067, 0, 0.200333327, 0)
TextButton0.TextColor3 = Color3.new(0,0,0)
TextButton0.Size = UDim2.new(0.8,0.9,0.6)
TextButton0.Font = Enum.Font.SourceSansLight
TextButton0.FontSize = Enum.FontSize.Size14
TextButton0.Text = "Crawl"
TextButton0.TextScaled = true
TextButton0.TextSize = 8
TextButton0.TextWrapped = true
TextButton0.Visible = false

TextButton0.MouseButton1Click:connect(function()
TextButton0.Visible = false
TextButton.Visible = true
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "J", false, game)
wait()
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(false, "J", false, game)
end)

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.new(10,5,0)
TextButton.BackgroundTransparency = 0.0000000001
TextButton.Position = UDim2.new(0.103524067, 0, 0.200333327, 0)
TextButton.TextColor3 = Color3.new(0,0,0)
TextButton.Size = UDim2.new(0.8,0.9,0.6)
TextButton.Font = Enum.Font.SourceSansLight
TextButton.FontSize = Enum.FontSize.Size14
TextButton.Text = "Crawl"
TextButton.TextScaled = true
TextButton.TextSize = 8
TextButton.TextWrapped = true

TextButton.MouseButton1Click:connect(function()
TextButton.Visible = false
TextButton0.Visible = true
local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://282574440"
local k = game:GetService("Players").LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
k:Play()
k:AdjustSpeed(2)

NameHotkey = Enum.KeyCode.J
local uis = game:GetService("UserInputService")
local NameOn = false
uis.InputBegan:Connect(function(inp, processed)
	if processed then return end
	if inp.KeyCode == NameHotkey then
		NameOn = not NameOn
k:stop()
			end
		end)
end)
