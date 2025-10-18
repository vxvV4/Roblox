local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local TextboxLibrary = {}

pcall(function()
    if CoreGui:FindFirstChild("TextboxLibGUI") then
        CoreGui.TextboxLibGUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TextboxLibGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local textboxContainer = Instance.new("Frame")
textboxContainer.Name = "TextboxContainer"
textboxContainer.Size = UDim2.new(0, 220, 0, 0)
textboxContainer.Position = UDim2.new(0.5, -110, 0.2, 0)
textboxContainer.BackgroundTransparency = 1
textboxContainer.Active = true
textboxContainer.Parent = ScreenGui

local textboxLayout = Instance.new("UIListLayout")
textboxLayout.Parent = textboxContainer
textboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
textboxLayout.Padding = UDim.new(0, 8)
textboxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

textboxLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    textboxContainer.Size = UDim2.new(0, 220, 0, textboxLayout.AbsoluteContentSize.Y)
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    textboxContainer.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

textboxContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = textboxContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

textboxContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

function TextboxLibrary:CreateTextbox(name, placeholder, callback)
    
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = name
    textboxFrame.Size = UDim2.new(0, 210, 0, 70)
    textboxFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = textboxContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = textboxFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(138, 43, 226)
    frameStroke.Thickness = 2
    frameStroke.Parent = textboxFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textboxFrame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 0, 30)
    textbox.Position = UDim2.new(0, 10, 0, 30)
    textbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    textbox.Text = ""
    textbox.PlaceholderText = placeholder or "Enter text..."
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 12
    textbox.BorderSizePixel = 0
    textbox.ClearTextOnFocus = false
    textbox.Parent = textboxFrame
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = textbox
    
    textbox.Focused:Connect(function()
        TweenService:Create(frameStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(160, 60, 255)
        }):Play()
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(frameStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(138, 43, 226)
        }):Play()
        
        if enterPressed and callback then
            pcall(callback, textbox.Text)
        end
    end)
    
    return textbox
end

return TextboxLibrary
