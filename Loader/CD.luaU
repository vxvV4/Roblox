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


local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local GameList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local LoadButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.Size = UDim2.new(0, 400, 0, 200)

GameList.Parent = Frame
GameList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GameList.BorderSizePixel = 0
GameList.Position = UDim2.new(0, 10, 0, 10)
GameList.Size = UDim2.new(1, -110, 1, -20)
GameList.ScrollBarThickness = 6

UIListLayout.Parent = GameList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

LoadButton.Parent = Frame
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
LoadButton.BorderSizePixel = 0
LoadButton.Position = UDim2.new(1, -90, 0.5, -20)
LoadButton.Size = UDim2.new(0, 80, 0, 40)
LoadButton.Font = Enum.Font.GothamBold
LoadButton.Text = "Load"
LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadButton.TextSize = 16

-- Create game buttons
for i, game in ipairs(supportedGames) do
    local GameButton = Instance.new("TextButton")
    GameButton.Parent = GameList
    GameButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    GameButton.BorderSizePixel = 0
    GameButton.Size = UDim2.new(1, -10, 0, 35)
    GameButton.Font = Enum.Font.Gotham
    GameButton.Text = game.name
    GameButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    GameButton.TextSize = 13
    GameButton.TextXAlignment = Enum.TextXAlignment.Left
    GameButton.TextTruncate = Enum.TextTruncate.AtEnd
    
    local Padding = Instance.new("UIPadding")
    Padding.Parent = GameButton
    Padding.PaddingLeft = UDim.new(0, 10)
    
    GameButton.MouseButton1Click:Connect(function()
        selectedGame = game
        
        -- Reset all buttons
        for _, btn in ipairs(GameList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        -- Highlight selected
        GameButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        GameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Update canvas size
GameList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

-- Load button click
LoadButton.MouseButton1Click:Connect(function()
    if not selectedGame then
        LoadButton.Text = "Select Game!"
        LoadButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        wait(1)
        LoadButton.Text = "Load"
        LoadButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        return
    end
    
    LoadButton.Text = "Loading..."
    LoadButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local success = loadScript(selectedGame.scriptUrl)
    
    if success then
        LoadButton.Text = "Loaded!"
        LoadButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        wait(1)
        ScreenGui:Destroy()
    else
        LoadButton.Text = "Failed"
        LoadButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        wait(2)
        LoadButton.Text = "Load"
        LoadButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)
