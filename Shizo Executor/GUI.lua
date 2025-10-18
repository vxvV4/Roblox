-- ============================================ --
-- ROBLOX EXECUTOR GUI BY SHIZO
-- Created by Aux Devs
-- ============================================ --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- SYNTAX DETECTOR MODULE
-- ============================================
local SyntaxDetector = {}

local LUA_KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
    "if", "in", "local", "nil", "not", "or", "repeat", "return", "then",
    "true", "until", "while", "goto", "continue"
}

function SyntaxDetector:isValidLua(code)
    if type(code) ~= "string" or code == "" or code:match("^%s*$") then
        return false, "Code is empty"
    end
    
    local func, err = loadstring(code)
    return func ~= nil, func and "Syntax is valid ✅" or err
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0.5, -25, 0, 10)
FloatingButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatingButton.BorderSizePixel = 2
FloatingButton.BorderColor3 = Color3.fromRGB(180, 30, 30)
FloatingButton.Text = "S"
FloatingButton.TextColor3 = Color3.fromRGB(180, 30, 30)
FloatingButton.TextSize = 24
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.ZIndex = 100
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 700, 0.6, 0)
MainContainer.Position = UDim2.new(0.5, -350, 1, 0) 
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = ScreenGui

local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(0, 180, 0, 95)
ActionFrame.Position = UDim2.new(0, 0, 0, 0)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = MainContainer

local function createActionButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 85, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ActionFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        }):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

createActionButton("Load IY", UDim2.new(0, 0, 0, 0), function()
    addStatus("📥 Loading Infinite Yield...", Color3.fromRGB(100, 200, 255))
    
    spawn(function()
        local success, err = pcall(function()
            local scriptUrl = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
            local scriptSource = game:HttpGetAsync(scriptUrl)
            
            if scriptSource and scriptSource ~= "" then
                local loadedFunc = loadstring(scriptSource)
                if loadedFunc then
                    loadedFunc()
                else
                    error("Failed to compile script")
                end
            else
                error("Failed to fetch script")
            end
        end)
        
        if success then
            addStatus("✅ Infinite Yield Loaded!", Color3.fromRGB(100, 255, 100))
        else
            addStatus("❌ Error: " .. tostring(err):sub(1, 30), Color3.fromRGB(255, 100, 100))
            warn("Full IY Error:", err)
        end
    end)
end)

createActionButton("Rejoin", UDim2.new(0, 95, 0, 0), function()
    addStatus("🔄 Rejoining...", Color3.fromRGB(200, 200, 200))
    wait(0.5)
    TeleportService:Teleport(game.PlaceId, player)
end)

createActionButton("Hop", UDim2.new(0, 0, 0, 50), function()
    addStatus("🌐 Server hopping...", Color3.fromRGB(200, 200, 200))
    local success, result = pcall(function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    break
                end
            end
        end
    end)
    
    if not success then
        addStatus("❌ Server hop failed", Color3.fromRGB(255, 100, 100))
    end
end)

local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 180, 1, -105)
LeftPanel.Position = UDim2.new(0, 0, 0, 105)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LeftPanel.BorderSizePixel = 2
LeftPanel.BorderColor3 = Color3.fromRGB(40, 40, 40)
LeftPanel.Parent = MainContainer

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 10)
LeftCorner.Parent = LeftPanel

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Size = UDim2.new(1, 0, 0, 40)
LeftTitle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LeftTitle.BorderSizePixel = 0
LeftTitle.Text = "STATUS"
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.TextSize = 16
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.Parent = LeftPanel

local LeftTitleCorner = Instance.new("UICorner")
LeftTitleCorner.CornerRadius = UDim.new(0, 10)
LeftTitleCorner.Parent = LeftTitle

local LeftTitleCover = Instance.new("Frame")
LeftTitleCover.Size = UDim2.new(1, 0, 0, 10)
LeftTitleCover.Position = UDim2.new(0, 0, 1, -10)
LeftTitleCover.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LeftTitleCover.BorderSizePixel = 0
LeftTitleCover.Parent = LeftTitle

local StatusContainer = Instance.new("ScrollingFrame")
StatusContainer.Size = UDim2.new(0.9, 0, 1, -50)
StatusContainer.Position = UDim2.new(0.05, 0, 0, 45)
StatusContainer.BackgroundTransparency = 1
StatusContainer.BorderSizePixel = 0
StatusContainer.ScrollBarThickness = 4
StatusContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
StatusContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
StatusContainer.Parent = LeftPanel

local StatusLayout = Instance.new("UIListLayout")
StatusLayout.Padding = UDim.new(0, 8)
StatusLayout.Parent = StatusContainer

local function addStatus(text, color)
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = StatusContainer
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = StatusLabel
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.Parent = StatusLabel
    
    return StatusLabel
end

-- Initial Status
local SyntaxStatus = addStatus("Ready", Color3.fromRGB(200, 200, 200))

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 500, 1, 0)
RightPanel.Position = UDim2.new(0, 195, 0, 0) 
RightPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RightPanel.BorderSizePixel = 2
RightPanel.BorderColor3 = Color3.fromRGB(40, 40, 40)
RightPanel.Parent = MainContainer

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 10)
RightCorner.Parent = RightPanel

local RightTitle = Instance.new("TextLabel")
RightTitle.Size = UDim2.new(1, 0, 0, 40)
RightTitle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
RightTitle.BorderSizePixel = 0
RightTitle.Text = "SCRIPT EDITOR"
RightTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RightTitle.TextSize = 16
RightTitle.Font = Enum.Font.GothamBold
RightTitle.Parent = RightPanel

local RightTitleCorner = Instance.new("UICorner")
RightTitleCorner.CornerRadius = UDim.new(0, 10)
RightTitleCorner.Parent = RightTitle

local RightTitleCover = Instance.new("Frame")
RightTitleCover.Size = UDim2.new(1, 0, 0, 10)
RightTitleCover.Position = UDim2.new(0, 0, 1, -10)
RightTitleCover.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
RightTitleCover.BorderSizePixel = 0
RightTitleCover.Parent = RightTitle

local ScriptScrollFrame = Instance.new("ScrollingFrame")
ScriptScrollFrame.Size = UDim2.new(0.94, 0, 1, -95)
ScriptScrollFrame.Position = UDim2.new(0.03, 0, 0, 45)
ScriptScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScriptScrollFrame.BorderSizePixel = 1
ScriptScrollFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
ScriptScrollFrame.ScrollBarThickness = 6
ScriptScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y -- Only vertical scroll!
ScriptScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptScrollFrame.Parent = RightPanel

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 6)
ScrollCorner.Parent = ScriptScrollFrame

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, -50, 1, 0)
ScriptBox.Position = UDim2.new(0, 45, 0, 5)
ScriptBox.BackgroundTransparency = 1
ScriptBox.Text = "-- Enter your script here\nprint('Hello World!')\n\n-- This scrolls infinitely!\nfor i = 1, 100 do\n    print(i)\nend"
ScriptBox.TextColor3 = Color3.fromRGB(220, 220, 220)
ScriptBox.TextSize = 14
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.TextWrapped = true 
ScriptBox.Parent = ScriptScrollFrame

local function updateCanvasSize()
    local textBounds = ScriptBox.TextBounds.Y
    ScriptScrollFrame.CanvasSize = UDim2.new(0, 0, 0, textBounds + 20)
end

ScriptBox:GetPropertyChangedSignal("TextBounds"):Connect(updateCanvasSize)
updateCanvasSize()

local LineNumbersLabel = Instance.new("TextLabel")
LineNumbersLabel.Size = UDim2.new(0, 35, 1, 0)
LineNumbersLabel.Position = UDim2.new(0, 5, 0, 5)
LineNumbersLabel.BackgroundTransparency = 1
LineNumbersLabel.Text = "1"
LineNumbersLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
LineNumbersLabel.TextSize = 14
LineNumbersLabel.Font = Enum.Font.Code
LineNumbersLabel.TextXAlignment = Enum.TextXAlignment.Right
LineNumbersLabel.TextYAlignment = Enum.TextYAlignment.Top
LineNumbersLabel.Parent = ScriptScrollFrame

local function updateLineNumbers()
    local text = ScriptBox.Text
    local lineCount = select(2, text:gsub('\n', '\n')) + 1
    local numbers = {}
    for i = 1, lineCount do
        table.insert(numbers, tostring(i))
    end
    LineNumbersLabel.Text = table.concat(numbers, '\n')
end

ScriptBox:GetPropertyChangedSignal("Text"):Connect(updateLineNumbers)
updateLineNumbers()

local function createButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 145, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = RightPanel
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        }):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return Button
end

local function checkSyntax()
    local code = ScriptBox.Text
    local isValid, message = SyntaxDetector:isValidLua(code)
    
    if isValid then
        SyntaxStatus.Text = "✅ Syntax Valid"
        SyntaxStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        SyntaxStatus.Text = "❌ Syntax Error"
        SyntaxStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        addStatus("Error: " .. tostring(message):sub(1, 25), Color3.fromRGB(255, 150, 150))
    end
    
    return isValid
end

ScriptBox:GetPropertyChangedSignal("Text"):Connect(function()
    wait(0.5)
    checkSyntax()
end)

createButton("Execute", UDim2.new(0, 15, 1, -45), function()
    if checkSyntax() then
        local success, err = pcall(function()
            loadstring(ScriptBox.Text)()
        end)
        
        if success then
            addStatus("✅ Executed", Color3.fromRGB(100, 255, 100))
        else
            addStatus("❌ Error: " .. tostring(err):sub(1, 25), Color3.fromRGB(255, 100, 100))
        end
    end
end)

createButton("Clear", UDim2.new(0, 170, 1, -45), function()
    ScriptBox.Text = ""
    addStatus("🗑️ Cleared", Color3.fromRGB(200, 200, 200))
end)

createButton("Copy", UDim2.new(0, 325, 1, -45), function()
    if setclipboard then
        setclipboard(ScriptBox.Text)
        addStatus("📋 Copied", Color3.fromRGB(100, 200, 255))
    else
        addStatus("⚠️ No clipboard", Color3.fromRGB(255, 200, 100))
    end
end)

local isOpen = false

FloatingButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if isOpen then
        
        FloatingButton.Text = "X"
        FloatingButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        FloatingButton.BorderColor3 = Color3.fromRGB(255, 50, 50)
        
        TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -350, 0.2, 0)
        }):Play()
    else
        
        FloatingButton.Text = "S"
        FloatingButton.TextColor3 = Color3.fromRGB(180, 30, 30)
        FloatingButton.BorderColor3 = Color3.fromRGB(180, 30, 30)
        
        TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -350, 1, 0)
        }):Play()
    end
end)

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(FloatingButton)
