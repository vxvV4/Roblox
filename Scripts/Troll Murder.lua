local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local MainCorner = Instance.new("UICorner")
local TopCorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 200, 0, 300)

MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 8)

TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

TopCorner.Parent = TopBar
TopCorner.CornerRadius = UDim.new(0, 8)

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "YouTube: Shizoscript"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 8, 0, 43)
ContentFrame.Size = UDim2.new(1, -16, 1, -51)
ContentFrame.ScrollBarThickness = 4
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 6)
end)

local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateDrag(input)
        end
    end
end)

TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    local ButtonCorner = Instance.new("UICorner")
    
    Button.Parent = ContentFrame
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    
    ButtonCorner.Parent = Button
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    
    Button.MouseButton1Click:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        task.wait(0.1)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

local function CreateToggle(text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    local ToggleLabel = Instance.new("TextLabel")
    local ToggleButton = Instance.new("TextButton")
    local ToggleIndicator = Instance.new("Frame")
    local FrameCorner = Instance.new("UICorner")
    local ButtonCorner = Instance.new("UICorner")
    local IndicatorCorner = Instance.new("UICorner")
    
    local isEnabled = default
    
    ToggleFrame.Parent = ContentFrame
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    
    FrameCorner.Parent = ToggleFrame
    FrameCorner.CornerRadius = UDim.new(0, 6)
    
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -38, 0.5, -8)
    ToggleButton.Size = UDim2.new(0, 32, 0, 16)
    ToggleButton.Text = ""
    
    ButtonCorner.Parent = ToggleButton
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    
    ToggleIndicator.Parent = ToggleButton
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -6)
    ToggleIndicator.Size = UDim2.new(0, 12, 0, 12)
    
    IndicatorCorner.Parent = ToggleIndicator
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local function updateToggle()
        if isEnabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            ToggleIndicator.Position = UDim2.new(1, -14, 0.5, -6)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -6)
        end
    end
    
    updateToggle()
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        updateToggle()
        
        if callback then
            callback(isEnabled)
        end
    end)
    
    return ToggleFrame
end

local autoFarmRunning = false 

CreateToggle("Auto Slap", false, function(state)
    autoFarmRunning = state  
    
    if state then
        
        task.spawn(function()
            while autoFarmRunning do
                local args = {"LeftDown"}
                
                
                local player = game:GetService("Players").LocalPlayer
                local backpack = player:FindFirstChild("Backpack")
                local slapHand = backpack and backpack:FindFirstChild("SlapHand")
                
                if slapHand and slapHand:FindFirstChild("Remote") then
                    slapHand.Remote:FireServer(unpack(args))
                end
                
                task.wait(1)
            end
        end)
    end
end)


CreateButton("Get Coins", function()
  
  for i = 1, 99999999999999999 do
local args = {
	"Coin3"
}
game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("Coins"):InvokeServer(unpack(args))
end

end)




CreateButton("Kill ALL ( you need buy Rocket first )", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for i, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local args = { Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z) }
                game:GetService("ReplicatedStorage"):WaitForChild("ROBLOX_RocketFireEvent"):FireServer(unpack(args))
                print("Fired at:", player.Name)
                task.wait(0.1)
            end
        end
    end
end)







CreateButton("Buy Secret ( Rocket )", function()
    local args = {
	"Gears",
	"RocketLauncher"
}
game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UI"):InvokeServer(unpack(args))
end)
