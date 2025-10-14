local supportedGames = {
    {
        name = "99 Nights in the Forest",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/99%20Nights%20in%20the%20Forest.lua",
    },
    {
        name = "Steal-a-drawed-brainrot",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Steal%20a%20drawed%20brainrot.lua",
    },
    {
        name = "Brookhaven RP",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Brookhaven%20RP.lua",
    },
    {
        name = "Morph Tower",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/%5BUPDT%5D%20Morph%20Tower.lua",
    },
    {
        name = "Build an army",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Build%20an%20army.lua",
    },
    {
        name = "Steal a BlackPink",
        scriptUrl = "https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Steal%20a%20BlackPink.lua",
    },
}

local selectedGame = nil

local function loadScript(scriptUrl)
    local success, scriptContent = pcall(function()
        return game:HttpGet(scriptUrl)
    end)
    
    if not success then
        warn("Fetch failed")
        return false
    end
    
    local func, loadErr = loadstring(scriptContent)
    if not func then
        warn("Load error:", loadErr)
        return false
    end
    
    local execSuccess, execErr = pcall(func)
    if not execSuccess then
        warn("Execution error:", execErr)
        return false
    end
    
    return true
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local GameList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local LoadButton = Instance.new("TextButton")
local LoadButtonCorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -225, 0.5, -150)
Frame.Size = UDim2.new(0, 450, 0, 300)

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 12)

-- Title
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Game Loader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.TextTransparency = 0.1

-- Game List
GameList.Parent = Frame
GameList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
GameList.BackgroundTransparency = 0.3
GameList.BorderSizePixel = 0
GameList.Position = UDim2.new(0, 15, 0, 60)
GameList.Size = UDim2.new(1, -130, 1, -75)
GameList.ScrollBarThickness = 4
GameList.ScrollBarImageTransparency = 0.5

local GameListCorner = Instance.new("UICorner")
GameListCorner.Parent = GameList
GameListCorner.CornerRadius = UDim.new(0, 8)

UIListLayout.Parent = GameList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local ListPadding = Instance.new("UIPadding")
ListPadding.Parent = GameList
ListPadding.PaddingTop = UDim.new(0, 8)
ListPadding.PaddingLeft = UDim.new(0, 8)
ListPadding.PaddingRight = UDim.new(0, 8)

-- Load Button
LoadButton.Parent = Frame
LoadButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
LoadButton.BackgroundTransparency = 0.2
LoadButton.BorderSizePixel = 0
LoadButton.Position = UDim2.new(1, -105, 0.5, -25)
LoadButton.Size = UDim2.new(0, 90, 0, 50)
LoadButton.Font = Enum.Font.GothamBold
LoadButton.Text = "Load"
LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadButton.TextSize = 18
LoadButton.TextTransparency = 0.1

LoadButtonCorner.Parent = LoadButton
LoadButtonCorner.CornerRadius = UDim.new(0, 10)

-- Create game buttons
for i, game in ipairs(supportedGames) do
    local GameButton = Instance.new("TextButton")
    GameButton.Parent = GameList
    GameButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    GameButton.BackgroundTransparency = 0.3
    GameButton.BorderSizePixel = 0
    GameButton.Size = UDim2.new(1, -10, 0, 40)
    GameButton.Font = Enum.Font.GothamSemibold
    GameButton.Text = game.name
    GameButton.TextColor3 = Color3.fromRGB(220, 220, 230)
    GameButton.TextSize = 14
    GameButton.TextXAlignment = Enum.TextXAlignment.Left
    GameButton.TextTruncate = Enum.TextTruncate.AtEnd
    GameButton.TextTransparency = 0.1
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.Parent = GameButton
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    
    local Padding = Instance.new("UIPadding")
    Padding.Parent = GameButton
    Padding.PaddingLeft = UDim.new(0, 12)
    
    -- Hover effect
    GameButton.MouseEnter:Connect(function()
        if selectedGame ~= game then
            GameButton.BackgroundTransparency = 0.2
        end
    end)
    
    GameButton.MouseLeave:Connect(function()
        if selectedGame ~= game then
            GameButton.BackgroundTransparency = 0.3
        end
    end)
    
    GameButton.MouseButton1Click:Connect(function()
        selectedGame = game
        
        -- Reset all buttons
        for _, btn in ipairs(GameList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                btn.BackgroundTransparency = 0.3
                btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            end
        end
        
        -- Highlight selected
        GameButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        GameButton.BackgroundTransparency = 0.2
        GameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Update canvas size
GameList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 16)

-- Load button hover effect
LoadButton.MouseEnter:Connect(function()
    LoadButton.BackgroundTransparency = 0.1
end)

LoadButton.MouseLeave:Connect(function()
    LoadButton.BackgroundTransparency = 0.2
end)

-- Load button click
LoadButton.MouseButton1Click:Connect(function()
    if not selectedGame then
        LoadButton.Text = "Select Game!"
        LoadButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        wait(1)
        LoadButton.Text = "Load"
        LoadButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        return
    end
    
    LoadButton.Text = "Loading..."
    LoadButton.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
    
    local success = loadScript(selectedGame.scriptUrl)
    
    if success then
        LoadButton.Text = "Loaded!"
        LoadButton.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
        wait(1)
        ScreenGui:Destroy()
    else
        LoadButton.Text = "Failed"
        LoadButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        wait(2)
        LoadButton.Text = "Load"
        LoadButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    end
end)
