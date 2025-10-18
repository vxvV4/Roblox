local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 8,
})

local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Toggle%20Gui%20Shizo/Source.lua"))()

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local espEnabled = false
local espConnection

local function createESP(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if not target.Character:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = target.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = target.Character
    end
    
    if target.Character:FindFirstChild("Head") and not target.Character.Head:FindFirstChild("ESP_Name") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Adornee = target.Character.Head
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = target.Character.Head
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = target.Name
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 16
        textLabel.Parent = billboard
      
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.Font = Enum.Font.SourceSans
        distanceLabel.TextSize = 14
        distanceLabel.Parent = billboard
        
        RunService.RenderStepped:Connect(function()
            if espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                distanceLabel.Text = math.floor(distance) .. " studs"
            end
        end)
    end
end

local function removeESP(target)
    if target.Character then
        for _, v in pairs(target.Character:GetDescendants()) do
            if v.Name == "ESP_Highlight" or v.Name == "ESP_Name" then
                v:Destroy()
            end
        end
    end
end

local function enableESP()
    espEnabled = true
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            createESP(v)
        end
    end
    
    espConnection = RunService.Heartbeat:Connect(function()
        if espEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character then
                    createESP(v)
                end
            end
        end
    end)
    
    game.Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            if espEnabled then
                wait(0.5)
                createESP(newPlayer)
            end
        end)
    end)
    
    print("✅ ESP ON")
end

local function disableESP()
    espEnabled = false
    
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    
    for _, v in pairs(game.Players:GetPlayers()) do
        removeESP(v)
    end
    
    print("❌ ESP OFF")
end

ToggleLib:CreateToggle("ESP", false, function()
    enableESP()
end, function()
    disableESP()
end)
