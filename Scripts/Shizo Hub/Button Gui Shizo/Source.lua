local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ButtonLibrary = {}

pcall(function()
    if CoreGui:FindFirstChild("ButtonLibGUI") then
        CoreGui.ButtonLibGUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ButtonLibGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 190, 0, 0)
buttonContainer.Position = UDim2.new(0.5, -95, 0.15, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Active = true
buttonContainer.Parent = ScreenGui

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Parent = buttonContainer
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Padding = UDim.new(0, 8)
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

buttonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    buttonContainer.Size = UDim2.new(0, 190, 0, buttonLayout.AbsoluteContentSize.Y)
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    buttonContainer.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

buttonContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = buttonContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

buttonContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

function ButtonLibrary:CreateButton(name, callback)
    
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Name = name
    buttonFrame.Size = UDim2.new(0, 180, 0, 45)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    buttonFrame.Text = name
    buttonFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.TextSize = 14
    buttonFrame.TextWrapped = true
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = buttonContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = buttonFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(138, 43, 226)
    frameStroke.Thickness = 2
    frameStroke.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
    
    buttonFrame.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(160, 60, 255)
        }):Play()
    end)
    
    buttonFrame.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)
    
    return buttonFrame
end

return ButtonLibrary
