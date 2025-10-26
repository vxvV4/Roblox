--[[
Example 

-- Load the library
local Library = loadstring(game:HttpGet("https://pastefy.app/BK6ukfW7/raw"))()

-- Create the main window
Library:CreateWindow("My Game Script Hub")

-- Show a welcome notification
Library:Notify("Welcome!", "Script loaded successfully", 3)

-- ========================================
-- TAB 1: Main Features
-- ========================================
local MainTab = Library:CreateTab("Main")

-- Button example
MainTab:CreateButton("Teleport to Spawn", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Library:Notify("Teleport", "Teleported to spawn!", 2)
    end
end)

-- Toggle example - Speed boost
local speedEnabled = false
MainTab:CreateToggle("Speed Boost", false, function(state)
    speedEnabled = state
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.WalkSpeed = 50
            Library:Notify("Speed", "Speed boost enabled!", 2)
        else
            player.Character.Humanoid.WalkSpeed = 16
            Library:Notify("Speed", "Speed boost disabled!", 2)
        end
    end
end)

-- Toggle example - Jump power
MainTab:CreateToggle("High Jump", false, function(state)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.JumpPower = 100
            Library:Notify("Jump", "High jump enabled!", 2)
        else
            player.Character.Humanoid.JumpPower = 50
            Library:Notify("Jump", "High jump disabled!", 2)
        end
    end
end)

-- Slider example - Custom walk speed
MainTab:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Slider example - Jump power
MainTab:CreateSlider("Jump Power", 50, 200, 50, function(value)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Label example
MainTab:CreateLabel("Movement Settings")

-- ========================================
-- TAB 2: Player Options
-- ========================================
local PlayerTab = Library:CreateTab("Player")

-- Dropdown example - Player selection
local function getPlayerNames()
    local names = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(names, player.Name)
    end
    return names
end

PlayerTab:CreateDropdown("Select Players", getPlayerNames(), function(selected)
    print("Selected players:", table.concat(selected, ", "))
    Library:Notify("Selection", #selected .. " player(s) selected", 2)
end)

-- Textbox example - Custom player name
PlayerTab:CreateTextbox("Search Player", "Enter player name...", function(text)
    local found = game.Players:FindFirstChild(text)
    if found then
        Library:Notify("Found", "Player " .. text .. " found!", 2)
    else
        Library:Notify("Not Found", "Player " .. text .. " not found!", 2)
    end
end)

-- Button example - Refresh player list
PlayerTab:CreateButton("Refresh Players", function()
    Library:Notify("Refresh", "Player list refreshed!", 2)
    -- You would recreate the dropdown here with updated player list
end)

-- Textbox example - Custom message
PlayerTab:CreateTextbox("Chat Message", "Type message here...", function(text)
    if text ~= "" then
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SCRIPT]: " .. text,
            Color = Color3.fromRGB(255, 255, 0)
        })
    end
end)

-- Label example
PlayerTab:CreateLabel("Player Management Tools")

-- ========================================
-- TAB 3: Visual Settings
-- ========================================
local VisualTab = Library:CreateTab("Visuals")

-- Toggle example - ESP
VisualTab:CreateToggle("Enable ESP", false, function(state)
    if state then
        Library:Notify("ESP", "ESP enabled!", 2)
        -- Add your ESP code here
    else
        Library:Notify("ESP", "ESP disabled!", 2)
        -- Remove ESP code here
    end
end)

-- Toggle example - Fullbright
VisualTab:CreateToggle("Fullbright", false, function(state)
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        Library:Notify("Fullbright", "Fullbright enabled!", 2)
    else
        lighting.Brightness = 1
        lighting.ClockTime = 12
        lighting.FogEnd = 10000
        Library:Notify("Fullbright", "Fullbright disabled!", 2)
    end
end)

-- Slider example - FOV
VisualTab:CreateSlider("Field of View", 70, 120, 70, function(value)
    local camera = workspace.CurrentCamera
    camera.FieldOfView = value
end)

-- Dropdown example - Camera modes
VisualTab:CreateDropdown("Camera Effects", {"Night Vision", "Black & White", "Blur", "Normal"}, function(selected)
    Library:Notify("Camera", "Effects applied: " .. #selected, 2)
end)

-- ========================================
-- TAB 4: Teleports
-- ========================================
local TeleportTab = Library:CreateTab("Teleports")

-- Buttons for different locations
TeleportTab:CreateButton("Teleport to (0, 50, 0)", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        Library:Notify("Teleport", "Teleported!", 2)
    end
end)

TeleportTab:CreateButton("Teleport to (100, 50, 100)", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(100, 50, 100)
        Library:Notify("Teleport", "Teleported!", 2)
    end
end)

TeleportTab:CreateButton("Teleport to Random Player", function()
    local players = game.Players:GetPlayers()
    if #players > 1 then
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= game.Players.LocalPlayer and randomPlayer.Character then
            local hrp = randomPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame
                Library:Notify("Teleport", "Teleported to " .. randomPlayer.Name, 2)
            end
        end
    end
end)

-- Textbox for custom coordinates
TeleportTab:CreateTextbox("Custom X Position", "Enter X coordinate...", function(text)
    local x = tonumber(text)
    if x then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(x, currentPos.Y, currentPos.Z)
            Library:Notify("Teleport", "Moved to X: " .. x, 2)
        end
    end
end)

TeleportTab:CreateLabel("Teleportation Tools")

-- ========================================
-- TAB 5: Misc
-- ========================================
local MiscTab = Library:CreateTab("Misc")

-- Toggle example - Infinite jump
local infJumpConnection
MiscTab:CreateToggle("Infinite Jump", false, function(state)
    if state then
        infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        Library:Notify("Infinite Jump", "Enabled!", 2)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
        end
        Library:Notify("Infinite Jump", "Disabled!", 2)
    end
end)

-- Toggle example - No clip
local noClipEnabled = false
MiscTab:CreateToggle("No Clip", false, function(state)
    noClipEnabled = state
    if state then
        Library:Notify("No Clip", "Enabled! (Use W,A,S,D to move)", 2)
    else
        Library:Notify("No Clip", "Disabled!", 2)
    end
end)

-- No clip loop
game:GetService("RunService").Stepped:Connect(function()
    if noClipEnabled then
        local player = game.Players.LocalPlayer
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Button example - Reset character
MiscTab:CreateButton("Reset Character", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 0
        Library:Notify("Reset", "Character reset!", 2)
    end
end)

-- Slider example - Time of day
MiscTab:CreateSlider("Time of Day", 0, 24, 12, function(value)
    game:GetService("Lighting").ClockTime = value
end)

-- Dropdown example - Game actions
MiscTab:CreateDropdown("Quick Actions", {"Collect All", "Reset Stats", "Clear Inventory", "Save Data"}, function(selected)
    for _, action in pairs(selected) do
        Library:Notify("Action", action .. " selected", 1.5)
    end
end)

MiscTab:CreateLabel("Miscellaneous Options")

-- ========================================
-- TAB 6: Credits
-- ========================================
local CreditsTab = Library:CreateTab("Credits")

CreditsTab:CreateLabel("Script created by: YourName")
CreditsTab:CreateLabel("Version: 1.0.0")
CreditsTab:CreateLabel("Last updated: 2024")
CreditsTab:CreateLabel("Thanks for using!")

CreditsTab:CreateButton("Copy Discord", function()
    setclipboard("YourDiscord#0000")
    Library:Notify("Copied", "Discord copied to clipboard!", 2)
end)

CreditsTab:CreateButton("Join Discord Server", function()
    Library:Notify("Discord", "Opening Discord invite...", 2)
    -- Add your discord invite link handling here
end)

-- Final notification
wait(1)
Library:Notify("Ready!", "All features loaded. Press Right Shift to toggle GUI", 4)

--]]





local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CompactLibrary"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 450, 0, 300)
MainWindow.Position = UDim2.new(0.5, -225, 0.5, -150)
MainWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainWindow

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Library"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold -- FIXED
Title.Parent = MainWindow

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 100, 1, -75)
TabContainer.Position = UDim2.new(0, 5, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 4
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.Parent = MainWindow

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabContainer

local TabLayout = Instance.new("UIListLayout")
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.PaddingLeft = UDim.new(0, 5)
TabPadding.PaddingRight = UDim.new(0, 5)
TabPadding.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -115, 1, -75)
ContentContainer.Position = UDim2.new(0, 110, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainWindow

local LeftPanel = Instance.new("ScrollingFrame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0.48, 0, 1, 0)
LeftPanel.Position = UDim2.new(0, 0, 0, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LeftPanel.BorderSizePixel = 0
LeftPanel.ScrollBarThickness = 4
LeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
LeftPanel.ScrollingEnabled = true
LeftPanel.Active = true
LeftPanel.Parent = ContentContainer

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftPanel

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
LeftLayout.Padding = UDim.new(0, 5)
LeftLayout.Parent = LeftPanel

local LeftPadding = Instance.new("UIPadding")
LeftPadding.PaddingTop = UDim.new(0, 5)
LeftPadding.PaddingLeft = UDim.new(0, 5)
LeftPadding.PaddingRight = UDim.new(0, 5)
LeftPadding.PaddingBottom = UDim.new(0, 5)
LeftPadding.Parent = LeftPanel

-- Right Panel (BLACK)
local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.48, 0, 1, 0)
RightPanel.Position = UDim2.new(0.52, 0, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RightPanel.BorderSizePixel = 0
RightPanel.ScrollBarThickness = 4
RightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
RightPanel.ScrollingEnabled = true
RightPanel.Active = true
RightPanel.Parent = ContentContainer

local RightCorner = Instance.new("UICorner")
RightCorner.CornerRadius = UDim.new(0, 6)
RightCorner.Parent = RightPanel

local RightLayout = Instance.new("UIListLayout")
RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
RightLayout.Padding = UDim.new(0, 5)
RightLayout.Parent = RightPanel

local RightPadding = Instance.new("UIPadding")
RightPadding.PaddingTop = UDim.new(0, 5)
RightPadding.PaddingLeft = UDim.new(0, 5)
RightPadding.PaddingRight = UDim.new(0, 5)
RightPadding.PaddingBottom = UDim.new(0, 5)
RightPadding.Parent = RightPanel

-- Close Button - FIXED FONT
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 100, 0, 25)
CloseButton.Position = UDim2.new(0.5, -50, 1, -30)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold -- FIXED
CloseButton.Parent = MainWindow

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- BLACK THEME Floating Button with "Show GUI" Text - FIXED FONT
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 55, 0, 55)
FloatingButton.Position = UDim2.new(0, 20, 0.5, -27)
FloatingButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatingButton.Text = "Show GUI"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextSize = 10
FloatingButton.Font = Enum.Font.GothamBold -- FIXED
FloatingButton.TextWrapped = true
FloatingButton.Visible = false
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0.25, 0)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(40, 40, 40)
FloatStroke.Thickness = 2
FloatStroke.Transparency = 0.3
FloatStroke.Parent = FloatingButton

-- Hover animation
FloatingButton.MouseEnter:Connect(function()
    TweenService:Create(FloatingButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 60, 0, 60),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
    TweenService:Create(FloatStroke, TweenInfo.new(0.2), {
        Thickness = 3,
        Transparency = 0.1
    }):Play()
end)

FloatingButton.MouseLeave:Connect(function()
    TweenService:Create(FloatingButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    }):Play()
    TweenService:Create(FloatStroke, TweenInfo.new(0.2), {
        Thickness = 2,
        Transparency = 0.3
    }):Play()
end)

-- Notification Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Parent = NotificationContainer

-- Update canvas sizes
LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    LeftPanel.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
end)

RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
end)

-- Dragging Function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

makeDraggable(MainWindow)
makeDraggable(FloatingButton)

-- Toggle Window
local function toggleWindow()
    MainWindow.Visible = not MainWindow.Visible
    FloatingButton.Visible = not FloatingButton.Visible
end

CloseButton.MouseButton1Click:Connect(toggleWindow)
FloatingButton.MouseButton1Click:Connect(toggleWindow)

-- Keybind (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleWindow()
    end
end)

-- Notification System - FIXED FONT
local function CreateNotification(title, message, duration)
    duration = duration or 3
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 70)
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.Parent = NotificationContainer
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -10, 0, 20)
    NotifTitle.Position = UDim2.new(0, 5, 0, 5)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 14
    NotifTitle.Font = Enum.Font.GothamBold -- FIXED
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = Notification
    
    local NotifMessage = Instance.new("TextLabel")
    NotifMessage.Size = UDim2.new(1, -10, 1, -30)
    NotifMessage.Position = UDim2.new(0, 5, 0, 25)
    NotifMessage.BackgroundTransparency = 1
    NotifMessage.Text = message
    NotifMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifMessage.TextSize = 12
    NotifMessage.Font = Enum.Font.Gotham -- FIXED
    NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
    NotifMessage.TextWrapped = true
    NotifMessage.Parent = Notification
    
    Notification.Position = UDim2.new(0, 300, 0, 0)
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(duration)
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0, 300, 0, 0)
    }):Play()
    task.wait(0.3)
    Notification:Destroy()
end

-- Library Functions
local currentTab = nil
local tabs = {}
local openDropdown = nil

function Library:CreateWindow(title)
    Title.Text = title or "Library"
    return self
end

function Library:Notify(title, message, duration)
    CreateNotification(title, message, duration)
end

-- Bro Just Continue This I need to do my Homework :)
-- CONTINUE WITH PART 2 alrighty brother I'll finish this

-- FIXED ROBLOX UI LIBRARY - PART 2 (COMPLETE)
-- Merge this after Part 1

function Library:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamBold -- FIXED
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 4)
    TabCorner.Parent = TabButton
    
    local tab = {
        Button = TabButton,
        LeftElements = {},
        RightElements = {}
    }
    
    TabButton.MouseButton1Click:Connect(function()
        if openDropdown then
            openDropdown.Visible = false
            openDropdown = nil
        end
        
        for _, t in pairs(tabs) do
            t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            for _, element in pairs(t.LeftElements) do
                element.Visible = false
            end
            for _, element in pairs(t.RightElements) do
                element.Visible = false
            end
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        for _, element in pairs(tab.LeftElements) do
            element.Visible = true
        end
        for _, element in pairs(tab.RightElements) do
            element.Visible = true
        end
        currentTab = tab
        
        LeftPanel.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
        RightPanel.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
    end)
    
    table.insert(tabs, tab)
    
    if #tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        currentTab = tab
    end
    
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    
    local TabFunctions = {}
    
    function TabFunctions:CreateButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 12
        Button.Font = Enum.Font.Gotham -- FIXED
        Button.Visible = (currentTab == tab)
        Button.Parent = LeftPanel
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        
        table.insert(tab.LeftElements, Button)
    end
    
    function TabFunctions:CreateToggle(name, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = name
        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.Visible = (currentTab == tab)
        ToggleFrame.Parent = LeftPanel
        
        local TglCorner = Instance.new("UICorner")
        TglCorner.CornerRadius = UDim.new(0, 4)
        TglCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham -- FIXED
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 30, 0, 20)
        ToggleButton.Position = UDim2.new(1, -35, 0.5, -10)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 80, 80)
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame
        
        local TglBtnCorner = Instance.new("UICorner")
        TglBtnCorner.CornerRadius = UDim.new(1, 0)
        TglBtnCorner.Parent = ToggleButton
        
        local toggled = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 80, 80)
            if callback then callback(toggled) end
        end)
        
        table.insert(tab.LeftElements, ToggleFrame)
    end
    
    function TabFunctions:CreateSlider(name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = name
        SliderFrame.Size = UDim2.new(1, 0, 0, 45)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.Visible = (currentTab == tab)
        SliderFrame.Parent = LeftPanel
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 20)
        Label.Position = UDim2.new(0, 5, 0, 2)
        Label.BackgroundTransparency = 1
        Label.Text = name .. ": " .. tostring(default)
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham -- FIXED
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame
        
        local SliderBack = Instance.new("Frame")
        SliderBack.Size = UDim2.new(1, -10, 0, 6)
        SliderBack.Position = UDim2.new(0, 5, 1, -10)
        SliderBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        SliderBack.Parent = SliderFrame
        
        local SliderBackCorner = Instance.new("UICorner")
        SliderBackCorner.CornerRadius = UDim.new(1, 0)
        SliderBackCorner.Parent = SliderBack
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderFill.Parent = SliderBack
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        local dragging = false
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = name .. ": " .. tostring(value)
            if callback then callback(value) end
        end
        
        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider(input)
            end
        end)
        
        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        table.insert(tab.LeftElements, SliderFrame)
    end
    
    function TabFunctions:CreateLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Name = text
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham -- FIXED
        Label.Visible = (currentTab == tab)
        Label.Parent = LeftPanel
        
        local LblCorner = Instance.new("UICorner")
        LblCorner.CornerRadius = UDim.new(0, 4)
        LblCorner.Parent = Label
        
        table.insert(tab.LeftElements, Label)
    end
    
    function TabFunctions:CreateDropdown(name, options, callback)
        local DropdownFrame = Instance.new("TextButton")
        DropdownFrame.Name = name
        DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownFrame.Text = ""
        DropdownFrame.Visible = (currentTab == tab)
        DropdownFrame.ClipsDescendants = false
        DropdownFrame.ZIndex = 1
        DropdownFrame.Parent = RightPanel
        
        local DropCorner = Instance.new("UICorner")
        DropCorner.CornerRadius = UDim.new(0, 4)
        DropCorner.Parent = DropdownFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 1, 0)
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham -- FIXED
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 2
        Label.Parent = DropdownFrame
        
        local maxHeight = 150
        local optionHeight = 27
        local totalHeight = #options * optionHeight + 4
        local dropdownHeight = math.min(totalHeight, maxHeight)
        
        local OptionsFrame = Instance.new("ScrollingFrame")
        OptionsFrame.Name = "Options"
        OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, dropdownHeight)
        OptionsFrame.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + 32)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Visible = false
        OptionsFrame.ClipsDescendants = true
        OptionsFrame.ScrollBarThickness = 4
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        OptionsFrame.ScrollingEnabled = true
        OptionsFrame.Active = true
        OptionsFrame.ZIndex = 1000
        OptionsFrame.Parent = ScreenGui
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 4)
        OptCorner.Parent = OptionsFrame
        
        local OptLayout = Instance.new("UIListLayout")
        OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptLayout.Padding = UDim.new(0, 2)
        OptLayout.Parent = OptionsFrame
        
        local OptPadding = Instance.new("UIPadding")
        OptPadding.PaddingTop = UDim.new(0, 2)
        OptPadding.PaddingLeft = UDim.new(0, 2)
        OptPadding.PaddingRight = UDim.new(0, 2)
        OptPadding.PaddingBottom = UDim.new(0, 2)
        OptPadding.Parent = OptionsFrame
        
        local selectedOptions = {}
        
        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, -4, 0, 25)
            OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.TextSize = 10
            OptionButton.Font = Enum.Font.Gotham -- FIXED
            OptionButton.ZIndex = 1001
            OptionButton.Parent = OptionsFrame
            
            local OptBtnCorner = Instance.new("UICorner")
            OptBtnCorner.CornerRadius = UDim.new(0, 3)
            OptBtnCorner.Parent = OptionButton
            
            OptionButton.MouseButton1Click:Connect(function()
                if table.find(selectedOptions, option) then
                    table.remove(selectedOptions, table.find(selectedOptions, option))
                    OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                else
                    table.insert(selectedOptions, option)
                    OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                if callback then callback(selectedOptions) end
            end)
        end
        
        OptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptLayout.AbsoluteContentSize.Y + 4)
        end)
        
        DropdownFrame.MouseButton1Click:Connect(function()
            if openDropdown and openDropdown ~= OptionsFrame then
                openDropdown.Visible = false
            end
            
            OptionsFrame.Visible = not OptionsFrame.Visible
            
            if OptionsFrame.Visible then
                OptionsFrame.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + 32)
                OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, dropdownHeight)
                openDropdown = OptionsFrame
                DropdownFrame.ZIndex = 100
            else
                openDropdown = nil
                DropdownFrame.ZIndex = 1
            end
        end)
        
        RightPanel:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if OptionsFrame.Visible then
                OptionsFrame.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + 32)
                OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, dropdownHeight)
            end
        end)
        
        DropdownFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if OptionsFrame.Visible then
                OptionsFrame.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + 32)
            end
        end)
        
        DropdownFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if OptionsFrame.Visible then
                OptionsFrame.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, dropdownHeight)
            end
        end)
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not OptionsFrame.Visible then return end
                
                local mousePos = input.Position
                local dropdownPos = DropdownFrame.AbsolutePosition
                local dropdownSize = DropdownFrame.AbsoluteSize
                local optionsPos = OptionsFrame.AbsolutePosition
                local optionsSize = OptionsFrame.AbsoluteSize
                
                local insideDropdown = mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                                      mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y
                
                local insideOptions = mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                                     mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y
                
                if not insideDropdown and not insideOptions then
                    OptionsFrame.Visible = false
                    openDropdown = nil
                    DropdownFrame.ZIndex = 1
                end
            end
        end)
        
        table.insert(tab.RightElements, DropdownFrame)
    end
    
    function TabFunctions:CreateTextbox(name, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Name = name
        TextboxFrame.Size = UDim2.new(1, 0, 0, 50)
        TextboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TextboxFrame.Visible = (currentTab == tab)
        TextboxFrame.Parent = RightPanel
        
        local TxtCorner = Instance.new("UICorner")
        TxtCorner.CornerRadius = UDim.new(0, 4)
        TxtCorner.Parent = TextboxFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 18)
        Label.Position = UDim2.new(0, 5, 0, 3)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 11
        Label.Font = Enum.Font.Gotham -- FIXED
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TextboxFrame
        
        local Textbox = Instance.new("TextBox")
        Textbox.Size = UDim2.new(1, -10, 0, 25)
        Textbox.Position = UDim2.new(0, 5, 1, -28)
        Textbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Textbox.PlaceholderText = placeholder or "Enter text..."
        Textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        Textbox.Text = ""
        Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        Textbox.TextSize = 11
        Textbox.Font = Enum.Font.Gotham -- FIXED
        Textbox.TextXAlignment = Enum.TextXAlignment.Left
        Textbox.ClearTextOnFocus = false
        Textbox.Parent = TextboxFrame
        
        local TxtBoxCorner = Instance.new("UICorner")
        TxtBoxCorner.CornerRadius = UDim.new(0, 4)
        TxtBoxCorner.Parent = Textbox
        
        local TxtBoxPadding = Instance.new("UIPadding")
        TxtBoxPadding.PaddingLeft = UDim.new(0, 5)
        TxtBoxPadding.PaddingRight = UDim.new(0, 5)
        TxtBoxPadding.Parent = Textbox
        
        Textbox.FocusLost:Connect(function(enterPressed)
            if callback then callback(Textbox.Text) end
        end)
        
        table.insert(tab.RightElements, TextboxFrame)
    end
    
    return TabFunctions
end

return Library
