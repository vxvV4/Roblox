local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SliderLibrary = {}

pcall(function()
    if CoreGui:FindFirstChild("SliderLibGUI") then
        CoreGui.SliderLibGUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SliderLibGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local sliderContainer = Instance.new("Frame")
sliderContainer.Name = "SliderContainer"
sliderContainer.Size = UDim2.new(0, 220, 0, 0)
sliderContainer.Position = UDim2.new(0.5, -110, 0.25, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Active = true
sliderContainer.Parent = ScreenGui

local sliderLayout = Instance.new("UIListLayout")
sliderLayout.Parent = sliderContainer
sliderLayout.SortOrder = Enum.SortOrder.LayoutOrder
sliderLayout.Padding = UDim.new(0, 8)
sliderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

sliderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sliderContainer.Size = UDim2.new(0, 220, 0, sliderLayout.AbsoluteContentSize.Y)
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    sliderContainer.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

sliderContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = sliderContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

sliderContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

function SliderLibrary:CreateSlider(name, min, max, default, callback)
    local currentValue = default or min
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name
    sliderFrame.Size = UDim2.new(0, 210, 0, 70)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = sliderContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = sliderFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(138, 43, 226)
    frameStroke.Thickness = 2
    frameStroke.Parent = sliderFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentValue)
    valueLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 10)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.Position = UDim2.new((currentValue - min) / (max - min), -9, 0.5, -9)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderBtn
    
    local sliderDragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        
        valueLabel.Text = tostring(currentValue)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderBtn.Position = UDim2.new(pos, -9, 0.5, -9)
        
        if callback then
            pcall(callback, currentValue)
        end
    end
    
    sliderBtn.MouseButton1Down:Connect(function()
        sliderDragging = true
    end)
    
    sliderBtn.MouseButton1Up:Connect(function()
        sliderDragging = false
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
            sliderDragging = true
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
    
    return sliderFrame
end

return SliderLibrary
