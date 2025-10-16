local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local saveFile = "FaDhen_Toggles.json"

local savedData = {}
if isfile and isfile(saveFile) then
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(saveFile))
    end)
    if success and type(result) == "table" then
        savedData = result
    end
end

local function SaveToggles()
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(savedData))
  end
  
pcall(function()
    if CoreGui:FindFirstChild("FaDhenGui") then
        CoreGui.FaDhenGui:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FaDhenGui"
ScreenGui.Parent = CoreGui

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "HoverButton"
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
toggleBtn.Image = "rbxassetid://107465641424582"
toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggleBtn

local stroke = Instance.new("UIStroke")
stroke.Parent = toggleBtn
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 50, 80)
stroke.Transparency = 0.2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 60, 0, 60),
        BackgroundColor3 = Color3.fromRGB(255, 30, 70)
    }):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    }):Play()
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 230, 0, 250)
mainFrame.Position = UDim2.new(0.5, -115, 0.4, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = ScreenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Parent = mainFrame
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(255, 40, 70)
frameStroke.Transparency = 0.3
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(30, 10, 15)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 16)
headerBottom.Position = UDim2.new(0, 0, 1, -16)
headerBottom.BackgroundColor3 = Color3.fromRGB(30, 10, 15)
headerBottom.BackgroundTransparency = 0.2
headerBottom.BorderSizePixel = 0
headerBottom.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
headerLine.BackgroundTransparency = 0.4
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 0, 35)
titleLabel.Position = UDim2.new(0, 15, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal A Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 80, 100)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 50)
titleLabel.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 25)
closeButton.Position = UDim2.new(1, -45, 0, 12)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
closeButton.BackgroundTransparency = 0.2
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.TextStrokeTransparency = 0.6
closeButton.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Parent = closeButton
closeStroke.Thickness = 1.5
closeStroke.Color = Color3.fromRGB(255, 60, 80)
closeStroke.Transparency = 0.3
closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(255, 40, 60)
    }):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(200, 30, 50)
    }):Play()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -75)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)
scrollFrame.ScrollBarImageTransparency = 0.3
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

_G.FaDhenToggles = {}

function _G.FaDhenAddToggle(name, props)
    local callback = props.Callback
    local toggled = savedData[name] or false

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Parent = toggleFrame
    toggleStroke.Thickness = 1
    toggleStroke.Color = Color3.fromRGB(255, 40, 70)
    toggleStroke.Transparency = 0.5
    toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 100, 120)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextStrokeTransparency = 0.7
    label.TextStrokeColor3 = Color3.fromRGB(255, 30, 60)
    label.Parent = toggleFrame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 50, 0, 24)
    sliderBg.Position = UDim2.new(1, -60, 0.5, -12)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
    sliderBg.BackgroundTransparency = 0.2
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = toggleFrame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 12)
    sliderBgCorner.Parent = sliderBg

    local sliderBgStroke = Instance.new("UIStroke")
    sliderBgStroke.Parent = sliderBg
    sliderBgStroke.Thickness = 1.5
    sliderBgStroke.Color = Color3.fromRGB(255, 50, 80)
    sliderBgStroke.Transparency = 0.4
    sliderBgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local sliderBtn = Instance.new("Frame")
    sliderBtn.Size = UDim2.new(0, 20, 0, 20)
    sliderBtn.Position = UDim2.new(0, 2, 0, 2)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
    sliderBtn.BackgroundTransparency = 0.1
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg

    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(0, 10)
    sliderBtnCorner.Parent = sliderBtn

    local sliderBtnStroke = Instance.new("UIStroke")
    sliderBtnStroke.Parent = sliderBtn
    sliderBtnStroke.Thickness = 1.5
    sliderBtnStroke.Color = Color3.fromRGB(255, 80, 100)
    sliderBtnStroke.Transparency = 0.2
    sliderBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function updateSlider()
        local targetPos, bgColor, btnColor
        if toggled then
            targetPos = UDim2.new(0, 28, 0, 2)
            bgColor = Color3.fromRGB(200, 30, 50)
            btnColor = Color3.fromRGB(255, 60, 90)
        else
            targetPos = UDim2.new(0, 2, 0, 2)
            bgColor = Color3.fromRGB(60, 20, 30)
            btnColor = Color3.fromRGB(200, 50, 80)
        end
        TweenService:Create(sliderBtn, tweenInfo, {Position = targetPos}):Play()
        TweenService:Create(sliderBg, tweenInfo, {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(sliderBtn, tweenInfo, {BackgroundColor3 = btnColor}):Play()
    end

    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleFrame

    clickDetector.MouseButton1Click:Connect(function()
        toggled = not toggled
        savedData[name] = toggled
        SaveToggles()
        updateSlider()
        if callback then
            callback(toggled)
        end
    end)

    _G.FaDhenToggles[name] = {
        Toggle = function(state)
            toggled = state
            savedData[name] = toggled
            SaveToggles()
            updateSlider()
            if callback then callback(toggled) end
        end,
        GetState = function()
            return toggled
        end
    }

    updateSlider()
    if callback then callback(toggled) end
end

local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeButton.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)
