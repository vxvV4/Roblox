-- Shizo GUI Btn source 
-- Created by Aux Devs

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- THEME CONFIGURATION
-- ============================================
local THEMES = {
    Black = {
        Background = Color3.fromRGB(20, 20, 20),
        Button = Color3.fromRGB(180, 30, 30),
        ButtonHover = Color3.fromRGB(220, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(40, 40, 40)
    },
    
    Dark = {
        Background = Color3.fromRGB(30, 30, 35),
        Button = Color3.fromRGB(70, 130, 180),
        ButtonHover = Color3.fromRGB(90, 150, 200),
        Text = Color3.fromRGB(240, 240, 240),
        Border = Color3.fromRGB(50, 50, 55)
    },
    
    Purple = {
        Background = Color3.fromRGB(25, 20, 35),
        Button = Color3.fromRGB(138, 43, 226),
        ButtonHover = Color3.fromRGB(168, 73, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(75, 50, 100)
    },
    
    Cyber = {
        Background = Color3.fromRGB(10, 15, 25),
        Button = Color3.fromRGB(0, 255, 200),
        ButtonHover = Color3.fromRGB(50, 255, 220),
        Text = Color3.fromRGB(0, 255, 200),
        Border = Color3.fromRGB(0, 100, 80)
    },
    
    Fire = {
        Background = Color3.fromRGB(25, 15, 10),
        Button = Color3.fromRGB(255, 80, 20),
        ButtonHover = Color3.fromRGB(255, 120, 60),
        Text = Color3.fromRGB(255, 200, 150),
        Border = Color3.fromRGB(100, 40, 10)
    }
}

local CURRENT_THEME = "Black" -- Change this to switch themes!

-- ============================================
-- CREATE GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShizoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Main Frame ( I make this super small for mobile :) )
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
MainFrame.BackgroundColor3 = THEMES[CURRENT_THEME].Background
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = THEMES[CURRENT_THEME].Border
MainFrame.Parent = ScreenGui

-- Corner for MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SHIZO HUB"
Title.TextColor3 = THEMES[CURRENT_THEME].Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Divider Line
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.9, 0, 0, 2)
Divider.Position = UDim2.new(0.05, 0, 0, 38)
Divider.BackgroundColor3 = THEMES[CURRENT_THEME].Border
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- ============================================
-- BUTTON CREATION FUNCTION
-- ============================================
local function createButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.85, 0, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = THEMES[CURRENT_THEME].Button
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = THEMES[CURRENT_THEME].Text
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Hover Effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = THEMES[CURRENT_THEME].ButtonHover,
            Size = UDim2.new(0.88, 0, 0, 37)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = THEMES[CURRENT_THEME].Button,
            Size = UDim2.new(0.85, 0, 0, 35)
        }):Play()
    end)
    
    -- Click Function
    Button.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(Button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.82, 0, 0, 33)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.85, 0, 0, 35)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- ============================================
-- CREATE BUTTONS (PUT YOUR LOGIC HERE!)
-- ============================================

-- Button 1 - Example
createButton("Execute", UDim2.new(0.075, 0, 0, 50), function()
    print("Execute button clicked!")
    -- PUT YOUR EXECUTE LOGIC HERE
    -- Example:
    -- loadstring(game:HttpGet("your_script_url"))()
end)

-- Button 2 - Example
createButton("Fly", UDim2.new(0.075, 0, 0, 95), function()
    print("Fly button clicked!")
    -- PUT YOUR FLY LOGIC HERE
end)

-- Button 3 - Example
createButton("ESP", UDim2.new(0.075, 0, 0, 140), function()
    print("ESP button clicked!")
    -- PUT YOUR ESP LOGIC HERE
end)

-- Button 4 - Close Button
createButton("Close", UDim2.new(0.075, 0, 0, 185), function()
    ScreenGui:Destroy()
end)

-- ============================================
-- DRAGGABLE FUNCTIONALITY
-- ============================================
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ============================================
-- THEME CHANGE FUNCTION
-- ============================================
local function applyTheme(themeName)
    if not THEMES[themeName] then
        warn("Theme '" .. themeName .. "' does not exist!")
        return
    end
    
    CURRENT_THEME = themeName
    local theme = THEMES[themeName]
    
    -- Apply to MainFrame
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        BackgroundColor3 = theme.Background,
        BorderColor3 = theme.Border
    }):Play()
    
    -- Apply to Title
    TweenService:Create(Title, TweenInfo.new(0.3), {
        TextColor3 = theme.Text
    }):Play()
    
    -- Apply to Divider
    TweenService:Create(Divider, TweenInfo.new(0.3), {
        BackgroundColor3 = theme.Border
    }):Play()
    
    -- Apply to all buttons
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.3), {
                BackgroundColor3 = theme.Button,
                TextColor3 = theme.Text
            }):Play()
        end
    end
    
    print("Theme changed to: " .. themeName)
end

-- ============================================
-- USAGE EXAMPLES
-- ============================================

-- To change theme, call this function:
-- applyTheme("Purple")
-- applyTheme("Cyber")
-- applyTheme("Fire")
-- applyTheme("Dark")

-- Or add a theme switcher button:
--[[
createButton("Theme", UDim2.new(0.075, 0, 0, 230), function()
    local themes = {"Black", "Dark", "Purple", "Cyber", "Fire"}
    local currentIndex = table.find(themes, CURRENT_THEME)
    local nextIndex = (currentIndex % #themes) + 1
    applyTheme(themes[nextIndex])
end)
]]--

print("✅ Shizo GUI Loaded | Theme: " .. CURRENT_THEME)
