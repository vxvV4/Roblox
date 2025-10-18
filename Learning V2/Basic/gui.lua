-- GUI (User Interface)
-- Creating and controlling UI elements

-- GET PLAYER GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CREATE SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false -- keeps GUI when player respawns
screenGui.IgnoreGuiInset = true -- full screen

-- CREATE FRAME (container)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 150) -- width, height in pixels
frame.Position = UDim2.new(0.5, -100, 0.5, -75) -- centered
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

-- CREATE TEXT LABEL
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, 0, 0, 50) -- full width, 50px height
label.Position = UDim2.new(0, 0, 0, 0)
label.Text = "Hello World"
label.TextSize = 24
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextStrokeTransparency = 0.5 -- outline

-- CREATE BUTTON
local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0.5, -75, 0, 60)
button.Text = "Click Me"
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.BorderSizePixel = 0

-- Button events
button.MouseButton1Click:Connect(function()
    print("Button clicked!")
    label.Text = "Button was clicked"
end)

button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- lighter green
end)

button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- back to normal
end)

-- CREATE TEXT BOX (input)
local textBox = Instance.new("TextBox")
textBox.Parent = frame
textBox.Size = UDim2.new(0, 180, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 110)
textBox.PlaceholderText = "Type here..."
textBox.Text = ""
textBox.TextSize = 18
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Get text from textbox
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        print("User typed:", textBox.Text)
    end
end)

-- CREATE IMAGE LABEL
local image = Instance.new("ImageLabel")
image.Parent = screenGui
image.Size = UDim2.new(0, 100, 0, 100)
image.Position = UDim2.new(0, 10, 0, 10)
image.Image = "rbxassetid://1234567890" -- replace with real asset ID
image.BackgroundTransparency = 1

-- CREATE IMAGE BUTTON
local imageButton = Instance.new("ImageButton")
imageButton.Parent = screenGui
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.Position = UDim2.new(1, -60, 0, 10)
imageButton.Image = "rbxassetid://1234567890"
imageButton.BackgroundTransparency = 1

imageButton.MouseButton1Click:Connect(function()
    print("Image button clicked")
end)

-- UDIM2 EXPLAINED
-- UDim2.new(scaleX, offsetX, scaleY, offsetY)
-- Scale: 0 to 1 (percentage of parent)
-- Offset: pixels

-- Common UDim2 patterns:
local examples = {
    fullSize = UDim2.new(1, 0, 1, 0), -- fills parent
    halfSize = UDim2.new(0.5, 0, 0.5, 0), -- 50% of parent
    centered = UDim2.new(0.5, -50, 0.5, -50), -- centered 100x100
    fixedSize = UDim2.new(0, 200, 0, 100), -- 200x100 pixels
    topLeft = UDim2.new(0, 10, 0, 10), -- 10px from top-left
    bottomRight = UDim2.new(1, -110, 1, -60), -- bottom-right corner
}

-- COLOR3 options
local colors = {
    fromRGB = Color3.fromRGB(255, 0, 0), -- red
    fromHSV = Color3.fromHSV(0.5, 1, 1), -- cyan
    new = Color3.new(1, 0, 0), -- red (0-1 range)
}

-- VISIBILITY
frame.Visible = true -- show
frame.Visible = false -- hide

-- TRANSPARENCY
frame.BackgroundTransparency = 0 -- solid
frame.BackgroundTransparency = 0.5 -- half transparent
frame.BackgroundTransparency = 1 -- invisible

-- UI CORNER (rounded corners)
local corner = Instance.new("UICorner")
corner.Parent = frame
corner.CornerRadius = UDim.new(0, 10) -- 10px radius

-- UI STROKE (outline)
local stroke = Instance.new("UIStroke")
stroke.Parent = frame
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2

-- UI GRADIENT
local gradient = Instance.new("UIGradient")
gradient.Parent = frame
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
})

-- UI LIST LAYOUT (auto arrange children)
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = frame
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- UI PADDING (spacing inside frame)
local padding = Instance.new("UIPadding")
padding.Parent = frame
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- SCROLLING FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = screenGui
scrollFrame.Size = UDim2.new(0, 200, 0, 300)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600) -- scrollable area
scrollFrame.ScrollBarThickness = 6

-- TWEENING GUI (animations)
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(
    0.5, -- duration
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

local tween = TweenService:Create(frame, tweenInfo, {
    Size = UDim2.new(0, 300, 0, 200)
})
tween:Play()

-- DESTROY GUI
screenGui:Destroy()

-- ENABLE/DISABLE CORE GUI
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) -- hide player list
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) -- hide health bar

-- ZINDEX (layering)
frame.ZIndex = 2 -- higher = on top
button.ZIndex = 3

-- ABSOLUTE SIZE/POSITION (get actual pixel values)
print(frame.AbsoluteSize) -- actual size in pixels
print(frame.AbsolutePosition) -- actual position on screen

-- CLIPPING (cut off children outside frame)
frame.ClipsDescendants = true
