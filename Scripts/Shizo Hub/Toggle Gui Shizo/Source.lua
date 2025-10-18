local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ToggleLibrary = {}

pcall(function()
    if CoreGui:FindFirstChild("ToggleLibGUI") then
        CoreGui.ToggleLibGUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToggleLibGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local toggleContainer = Instance.new("Frame")
toggleContainer.Name = "ToggleContainer"
toggleContainer.Size = UDim2.new(0, 190, 0, 0)
toggleContainer.Position = UDim2.new(0.5, -95, 0.1, 0)
toggleContainer.BackgroundTransparency = 1
toggleContainer.Active = true
toggleContainer.Parent = ScreenGui

local toggleLayout = Instance.new("UIListLayout")
toggleLayout.Parent = toggleContainer
toggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
toggleLayout.Padding = UDim.new(0, 8)
toggleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

toggleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    toggleContainer.Size = UDim2.new(0, 190, 0, toggleLayout.AbsoluteContentSize.Y)
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    toggleContainer.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

toggleContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

function ToggleLibrary:CreateToggle(name, defaultState, onCallback, offCallback)
    local isToggled = defaultState or false
  
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name
    toggleFrame.Size = UDim2.new(0, 180, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = toggleContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = toggleFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(138, 43, 226)
    frameStroke.Thickness = 2
    frameStroke.Parent = toggleFrame
  
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextWrapped = true
    titleLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0, 45, 0, 30)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -15)
    toggleBtn.BackgroundColor3 = isToggled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 50)
    toggleBtn.Text = isToggled and "ON" or "OFF"
    toggleBtn.TextColor3 = isToggled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if isToggled then
          
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            }):Play()
            toggleBtn.Text = "ON"
            toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            
            if onCallback then
                pcall(onCallback)
            end
        else
            
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
            toggleBtn.Text = "OFF"
            toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            
            if offCallback then
                pcall(offCallback)
            end
        end
    end)
  
    toggleBtn.MouseEnter:Connect(function()
        if isToggled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(160, 60, 255)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            }):Play()
        end
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        if isToggled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
        end
    end)
    
    return toggleFrame
end

return ToggleLibrary
