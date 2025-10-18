-- GUI TEMPLATES REFERENCE (SMALLER VERSION)
-- Copy and paste these templates anytime you need them
-- All support PC and Mobile, Dark theme by default

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === THEME COLORS ===
-- Change these to change your entire GUI theme!

local THEME = {
    -- Dark Theme (default)
    Background = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 150, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(50, 50, 50),
}

-- === HELPER: MAKE DRAGGABLE (PC + MOBILE) ===

local function makeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    local function update(input)
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(
            framePos.X.Scale, 
            framePos.X.Offset + delta.X,
            framePos.Y.Scale, 
            framePos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- === 1. BUTTON GUI (SMALL) ===

local function createButtonGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 35) -- smaller
    button.Position = UDim2.new(0.5, -50, 0.5, -17)
    button.BackgroundColor3 = THEME.Accent
    button.Text = "Click"
    button.TextColor3 = THEME.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        print("Button clicked!")
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 105, 0, 37)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 35)}):Play()
    end)
end

-- === 2. TOGGLE GUI (SMALL) ===

local function createToggleGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 140, 0, 35) -- smaller
    frame.Position = UDim2.new(0.5, -70, 0.3, 0)
    frame.BackgroundColor3 = THEME.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Toggle"
    label.TextColor3 = THEME.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Parent = frame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBg.BackgroundColor3 = THEME.Secondary
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local toggled = false
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = ""
    toggleButton.Parent = toggleBg
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Text}):Play()
        else
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Secondary}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
    end)
    
    makeDraggable(frame)
end

-- === 3. TEXTBOX WITH BUTTON GUI (SMALL) ===

local function createTextboxButtonGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 80) -- smaller
    frame.Position = UDim2.new(0.5, -100, 0.4, 0)
    frame.BackgroundColor3 = THEME.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Enter Text"
    title.TextColor3 = THEME.Text
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -16, 0, 28)
    textBox.Position = UDim2.new(0, 8, 0, 32)
    textBox.BackgroundColor3 = THEME.Secondary
    textBox.Text = ""
    textBox.PlaceholderText = "Type..."
    textBox.TextColor3 = THEME.Text
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.TextSize = 13
    textBox.Font = Enum.Font.Gotham
    textBox.BorderSizePixel = 0
    textBox.Parent = frame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 70, 0, 24)
    submitBtn.Position = UDim2.new(0.5, -35, 1, -30)
    submitBtn.BackgroundColor3 = THEME.Accent
    submitBtn.Text = "Submit"
    submitBtn.TextColor3 = THEME.Text
    submitBtn.TextSize = 13
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = submitBtn
    
    submitBtn.MouseButton1Click:Connect(function()
        print("Submitted:", textBox.Text)
        textBox.Text = ""
    end)
    
    makeDraggable(frame)
end

-- === 4. SLIDER GUI (SMALL, PC + MOBILE) ===

local function createSliderGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 60) -- smaller
    frame.Position = UDim2.new(0.5, -90, 0.5, -30)
    frame.BackgroundColor3 = THEME.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = "Value: 50"
    label.TextColor3 = THEME.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 5)
    sliderBg.Position = UDim2.new(0, 12, 0, 40)
    sliderBg.BackgroundColor3 = THEME.Secondary
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 14, 0, 14)
    handle.Position = UDim2.new(0.5, -7, 0.5, -7)
    handle.BackgroundColor3 = THEME.Text
    handle.BorderSizePixel = 0
    handle.Parent = sliderBg
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    local currentValue = 50
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(relativeX * 100)
        
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        handle.Position = UDim2.new(relativeX, -7, 0.5, -7)
        label.Text = "Value: " .. currentValue
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    makeDraggable(frame)
end

-- === 5. KEY SYSTEM GUI (SMALL) ===

local function createKeySystemGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 130) -- smaller
    frame.Position = UDim2.new(0.5, -110, 0.5, -65)
    frame.BackgroundColor3 = THEME.Background
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = THEME.Secondary
    title.Text = "Key System"
    title.TextColor3 = THEME.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -16, 0, 20)
    subtitle.Position = UDim2.new(0, 8, 0, 42)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter key to continue"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = frame
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -24, 0, 30)
    keyBox.Position = UDim2.new(0, 12, 0, 65)
    keyBox.BackgroundColor3 = THEME.Secondary
    keyBox.Text = ""
    keyBox.PlaceholderText = "Key..."
    keyBox.TextColor3 = THEME.Text
    keyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    keyBox.TextSize = 13
    keyBox.Font = Enum.Font.Gotham
    keyBox.BorderSizePixel = 0
    keyBox.Parent = frame
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keyBox
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 80, 0, 26)
    submitBtn.Position = UDim2.new(0.5, -40, 1, -32)
    submitBtn.BackgroundColor3 = THEME.Accent
    submitBtn.Text = "Submit"
    submitBtn.TextColor3 = THEME.Text
    submitBtn.TextSize = 13
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = submitBtn
    
    local correctKey = "TEST123"
    
    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == correctKey then
            subtitle.Text = "✓ Correct!"
            subtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(1)
            screenGui:Destroy()
        else
            subtitle.Text = "✗ Wrong Key!"
            subtitle.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            subtitle.Text = "Enter key to continue"
            subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
    
    makeDraggable(frame)
end

-- === 6. NOTIFICATION GUI (SMALL) ===

local function createNotification(text, duration)
    local screenGui = playerGui:FindFirstChild("NotificationGui") or Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = playerGui
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 200, 0, 50) -- smaller
    notif.Position = UDim2.new(1, 10, 0, 10)
    notif.BackgroundColor3 = THEME.Background
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, -16)
    label.Position = UDim2.new(0, 8, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = notif
    
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -210, 0, 10)}):Play()
    
    task.delay(duration or 3, function()
        local slideOut = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 10)})
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

-- === HOW TO COMBINE GUIS ===

local function createCombinedGUI()
    -- This shows how to put multiple elements in ONE frame
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    
    -- Main container frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 220, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
    mainFrame.BackgroundColor3 = THEME.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = THEME.Secondary
    title.Text = "Settings"
    title.TextColor3 = THEME.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Add UIListLayout to auto-arrange elements
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = mainFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 43)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = mainFrame
    
    -- Button 1
    local btn1 = Instance.new("TextButton")
    btn1.Size = UDim2.new(1, 0, 0, 30)
    btn1.BackgroundColor3 = THEME.Accent
    btn1.Text = "Option 1"
    btn1.TextColor3 = THEME.Text
    btn1.TextSize = 13
    btn1.Font = Enum.Font.GothamBold
    btn1.BorderSizePixel = 0
    btn1.LayoutOrder = 1
    btn1.Parent = mainFrame
    
    local btn1Corner = Instance.new("UICorner")
    btn1Corner.CornerRadius = UDim.new(0, 6)
    btn1Corner.Parent = btn1
    
    btn1.MouseButton1Click:Connect(function()
        print("Option 1 clicked")
    end)
    
    -- Button 2
    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(1, 0, 0, 30)
    btn2.BackgroundColor3 = THEME.Accent
    btn2.Text = "Option 2"
    btn2.TextColor3 = THEME.Text
    btn2.TextSize = 13
    btn2.Font = Enum.Font.GothamBold
    btn2.BorderSizePixel = 0
    btn2.LayoutOrder = 2
    btn2.Parent = mainFrame
    
    local btn2Corner = Instance.new("UICorner")
    btn2Corner.CornerRadius = UDim.new(0, 6)
    btn2Corner.Parent = btn2
    
    btn2.MouseButton1Click:Connect(function()
        print("Option 2 clicked")
    end)
    
    -- Textbox
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.BackgroundColor3 = THEME.Secondary
    textBox.Text = ""
    textBox.PlaceholderText = "Enter value..."
    textBox.TextColor3 = THEME.Text
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.TextSize = 13
    textBox.Font = Enum.Font.Gotham
    textBox.BorderSizePixel = 0
    textBox.LayoutOrder = 3
    textBox.Parent = mainFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox
    
    -- Toggle
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundColor3 = THEME.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.LayoutOrder = 4
    toggleFrame.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0, 100, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Enable Feature"
    toggleLabel.TextColor3 = THEME.Text
    toggleLabel.TextSize = 12
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Position = UDim2.new(0, 8, 0, 0)
    toggleLabel.Parent = toggleFrame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 35, 0, 18)
    toggleBg.Position = UDim2.new(1, -40, 0.5, -9)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggleFrame
    
    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBg
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 14, 0, 14)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local toggled = false
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = ""
    toggleButton.Parent = toggleBg
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
        else
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end)
    
    makeDraggable(mainFrame)
end

-- === HOW TO USE ===

-- Single GUIs:
-- createButtonGUI()
-- createToggleGUI()
-- createTextboxButtonGUI()
-- createSliderGUI()
-- createKeySystemGUI()
-- createNotification("Test!", 3)

-- Combined GUI (multiple elements in one frame):
-- createCombinedGUI()

--[[
=== HOW TO COMBINE GUIS ===

METHOD 1: Using UIListLayout (auto-arrange vertically)

1. Create ONE main Frame as container
2. Add UIListLayout to auto-arrange children
3. Add UIPadding for spacing inside frame
4. Set LayoutOrder on each element (1, 2, 3, etc)
5. All elements will stack automatically!

Example:
local mainFrame = Instance.new("Frame")
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8) -- 8px gap between elements
listLayout.Parent = mainFrame

local button1 = Instance.new("TextButton")
button1.LayoutOrder = 1 -- shows first
button1.Parent = mainFrame

local button2 = Instance.new("TextButton")
button2.LayoutOrder = 2 -- shows second
button2.Parent = mainFrame

METHOD 2: Manual positioning (more control)

Position each element manually using UDim2:
- First element: Position = UDim2.new(0, 10, 0, 10)
- Second element: Position = UDim2.new(0, 10, 0, 50)
- Third element: Position = UDim2.new(0, 10, 0, 90)

Just add 40-50 to Y offset for each element

Example:
local button1 = Instance.new("TextButton")
button1.Position = UDim2.new(0, 10, 0, 10) -- Y = 10
button1.Parent = mainFrame

local textbox = Instance.new("TextBox")
textbox.Position = UDim2.new(0, 10, 0, 50) -- Y = 50 (40px below)
textbox.Parent = mainFrame

=== CHANGING COLORS ===

To change theme, edit THEME table at top:

THEME = {
    Background = Color3.fromRGB(25, 25, 25), -- main frame color
    Secondary = Color3.fromRGB(35, 35, 35), -- textbox, header color
    Accent = Color3.fromRGB(0, 150, 0), -- button color
    Text = Color3.fromRGB(255, 255, 255), -- text color
    Border = Color3.fromRGB(50, 50, 50), -- border color (unused here)
}

RGB COLOR GUIDE:
- Red = Color3.fromRGB(255, 0, 0)
- Green = Color3.fromRGB(0, 255, 0)
- Blue = Color3.fromRGB(0, 0, 255)
- Yellow = Color3.fromRGB(255, 255, 0)
- Purple = Color3.fromRGB(150, 0, 255)
- Orange = Color3.fromRGB(255, 150, 0)
- Cyan = Color3.fromRGB(0, 255, 255)
- Pink = Color3.fromRGB(255, 100, 200)
- Black = Color3.fromRGB(0, 0, 0)
- White = Color3.fromRGB(255, 255, 255)
- Gray = Color3.fromRGB(128, 128, 128)
- Dark Gray = Color3.fromRGB(50, 50, 50)

PRESET THEMES:

Dark Theme:
Background = Color3.fromRGB(25, 25, 25)
Secondary = Color3.fromRGB(35, 35, 35)
Accent = Color3.fromRGB(0, 150, 0)
Text = Color3.fromRGB(255, 255, 255)

Light Theme:
Background = Color3.fromRGB(240, 240, 240)
Secondary = Color3.fromRGB(255, 255, 255)
Accent = Color3.fromRGB(0, 120, 215)
Text = Color3.fromRGB(0, 0, 0)

Blue Theme:
Background = Color3.fromRGB(20, 30, 50)
Secondary = Color3.fromRGB(30, 45, 70)
Accent = Color3.fromRGB(50, 150, 255)
Text = Color3.fromRGB(255, 255, 255)

Red Theme:
Background = Color3.fromRGB(40, 20, 20)
Secondary = Color3.fromRGB(60, 30, 30)
Accent = Color3.fromRGB(220, 50, 50)
Text = Color3.fromRGB(255, 255, 255)

Purple Theme:
Background = Color3.fromRGB(30, 20, 40)
Secondary = Color3.fromRGB(45, 30, 60)
Accent = Color3.fromRGB(150, 50, 255)
Text = Color3.fromRGB(255, 255, 255)

Green Theme:
Background = Color3.fromRGB(20, 40, 20)
Secondary = Color3.fromRGB(30, 60, 30)
Accent = Color3.fromRGB(50, 220, 50)
Text = Color3.fromRGB(255, 255, 255)

=== QUICK TIPS ===

1. Always use UICorner for rounded corners
2. Use TweenService for smooth animations
3. makeDraggable() works on PC and mobile
4. Use TextSize 12-16 for small GUIs
5. Keep frame sizes under 300x300 for mobile
6. Add wait() or task.wait() between tweens
7. Use LayoutOrder with UIListLayout
8. Test on phone and PC!

=== SIZE GUIDE ===

Small Button: UDim2.new(0, 100, 0, 35)
Medium Button: UDim2.new(0, 150, 0, 45)
Large Button: UDim2.new(0, 200, 0, 50)

Small Frame: UDim2.new(0, 200, 0, 150)
Medium Frame: UDim2.new(0, 300, 0, 250)
Large Frame: UDim2.new(0, 400, 0, 400)

Small Text: TextSize = 12
Medium Text: TextSize = 14-16
Large Text: TextSize = 18-20
Title Text: TextSize = 20-24

=== POSITION GUIDE ===

Center screen:
Position = UDim2.new(0.5, -width/2, 0.5, -height/2)

Top left:
Position = UDim2.new(0, 10, 0, 10)

Top right:
Position = UDim2.new(1, -width-10, 0, 10)

Bottom left:
Position = UDim2.new(0, 10, 1, -height-10)

Bottom right:
Position = UDim2.new(1, -width-10, 1, -height-10)

=== HOW TO MAKE YOUR OWN GUI ===

Step 1: Copy one of the functions above
Step 2: Change the sizes to what you need
Step 3: Change colors using THEME
Step 4: Add more elements by copying existing ones
Step 5: Position them manually or use UIListLayout
Step 6: Test it!

Example - Making custom menu:
1. Start with createCombinedGUI() as template
2. Change mainFrame.Size to your size
3. Add more buttons by copying btn1 code
4. Change LayoutOrder (1, 2, 3, 4...)
5. Change button.Text to your text
6. Add your functions to MouseButton1Click

DONE! This all Can Learn you make Script And make Gui jist keep going This is all i learn 
saying this useless? Fucking it's not useless i make it so you can also learn :)
if you see this you can learn my all Codes i always Sharing what i learned 

( Shizo ) .
]]
