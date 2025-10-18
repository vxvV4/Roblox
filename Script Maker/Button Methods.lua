local hizo = loadstring(game:HttpGet("your_script_url"))()
local window = hizo:Window("hizo")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ============================================
-- TELEPORT BUTTONS (Very useful!)
-- ============================================

-- TP to specific location
window:Button("TP to Base", function()
    local char = Players.LocalPlayer.Character
    if char then
        char.HumanoidRootPart.CFrame = CFrame.new(100, 50, 200)
    end
end)

-- TP to nearest player
window:Button("TP to Nearest Player", function()
    local myChar = Players.LocalPlayer.Character
    if myChar then
        local myPos = myChar.HumanoidRootPart.Position
        local nearest = nil
        local nearestDist = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local theirHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if theirHrp then
                    local dist = (myPos - theirHrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = theirHrp
                    end
                end
            end
        end
        
        if nearest then
            myChar.HumanoidRootPart.CFrame = nearest.CFrame
            print("TP to nearest player!")
        end
    end
end)

-- TP all players to you
window:Button("TP All to Me", function()
    local myChar = Players.LocalPlayer.Character
    if myChar then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                player.Character.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- ============================================
-- KILL/DAMAGE BUTTONS
-- ============================================

-- Kill all players once
window:Button("Kill All", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                local args = {
                    CFrame.new(pos.X, pos.Y, pos.Z),
                    Vector3.new(pos.X, pos.Y, pos.Z),
                    "Standard Launcher"
                }
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RocketLauncherEvent"):FireServer(unpack(args))
                wait(0.1)
            end
        end
    end
    print("Killed all!")
end)

-- Kill nearest player
window:Button("Kill Nearest", function()
    local myChar = Players.LocalPlayer.Character
    if myChar then
        local myPos = myChar.HumanoidRootPart.Position
        local nearest = nil
        local nearestDist = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local theirHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if theirHrp then
                    local dist = (myPos - theirHrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = theirHrp
                    end
                end
            end
        end
        
        if nearest then
            local pos = nearest.Position
            local args = {
                CFrame.new(pos.X, pos.Y, pos.Z),
                Vector3.new(pos.X, pos.Y, pos.Z),
                "Standard Launcher"
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RocketLauncherEvent"):FireServer(unpack(args))
            print("Killed nearest!")
        end
    end
end)

-- ============================================
-- COLLECT/FARM BUTTONS (One-time collect all)
-- ============================================

-- Collect all coins
window:Button("Collect All Coins", function()
    local char = Players.LocalPlayer.Character
    if char then
        for _, coin in pairs(workspace.Coins:GetChildren()) do
            char.HumanoidRootPart.CFrame = coin.CFrame
            wait(0.05)
        end
        print("All coins collected!")
    end
end)

-- Collect all items in folder
window:Button("Collect All Items", function()
    local char = Players.LocalPlayer.Character
    if char then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("BasePart") then
                char.HumanoidRootPart.CFrame = item.CFrame
                wait(0.1)
            end
        end
        print("All items collected!")
    end
end)

-- ============================================
-- SPEED/STATS BUTTONS
-- ============================================

-- Boost speed
window:Button("Speed Boost", function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 100
        print("Speed boosted!")
    end
end)

-- Reset speed
window:Button("Reset Speed", function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
        print("Speed reset!")
    end
end)

-- Boost jump
window:Button("Jump Boost", function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = 100
        print("Jump boosted!")
    end
end)

-- ============================================
-- UTILITY BUTTONS
-- ============================================

-- Remove fog
window:Button("Remove Fog", function()
    game.Lighting.FogEnd = 100000
    print("Fog removed!")
end)

-- Fullbright
window:Button("Fullbright", function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
    game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    print("Fullbright ON!")
end)

-- Noclip once (walk through walls for 5 seconds)
window:Button("Noclip 5sec", function()
    local char = Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        print("Noclip 5 seconds!")
        wait(5)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        print("Noclip ended!")
    end
end)

-- Reset character
window:Button("Reset Character", function()
    Players.LocalPlayer.Character.Humanoid.Health = 0
end)

-- Rejoin server
window:Button("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
end)

-- ============================================
-- INFO BUTTONS
-- ============================================

-- Print player count
window:Button("Player Count", function()
    print("Players in server:", #Players:GetPlayers())
end)

-- Print your position
window:Button("My Position", function()
    local char = Players.LocalPlayer.Character
    if char then
        local pos = char.HumanoidRootPart.Position
        print("Position:", pos)
    end
end)

-- List all players
window:Button("List Players", function()
    print("=== PLAYERS ===")
    for i, player in pairs(Players:GetPlayers()) do
        print(i, player.Name)
    end
end)

-- ============================================
-- SPAM BUTTONS (Temporary spam)
-- ============================================

-- Spam fire for 5 seconds
window:Button("Spam Fire 5sec", function()
    spawn(function()
        local endTime = tick() + 5
        while tick() < endTime do
            local args = {
                CFrame.new(0, 100, 0),
                Vector3.new(0, 100, 0),
                "Standard Launcher"
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RocketLauncherEvent"):FireServer(unpack(args))
            wait(0.1)
        end
        print("Spam ended!")
    end)
end)

-- Spam jump 10 times
window:Button("Spam Jump x10", function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        for i = 1, 10 do
            char.Humanoid.Jump = true
            wait(0.3)
        end
        print("Jump spam done!")
    end
end)

-- ============================================
-- BRING BUTTONS (Bring items to you)
-- ============================================

-- Bring all coins to you
window:Button("Bring All Coins", function()
    local char = Players.LocalPlayer.Character
    if char then
        local myPos = char.HumanoidRootPart.Position
        for _, coin in pairs(workspace.Coins:GetChildren()) do
            if coin:IsA("BasePart") then
                coin.CFrame = CFrame.new(myPos)
            end
        end
        print("Coins brought to you!")
    end
end)

-- Bring nearest player to you
window:Button("Bring Nearest Player", function()
    local myChar = Players.LocalPlayer.Character
    if myChar then
        local myPos = myChar.HumanoidRootPart.Position
        local nearest = nil
        local nearestDist = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local theirHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if theirHrp then
                    local dist = (myPos - theirHrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = theirHrp
                    end
                end
            end
        end
        
        if nearest then
            nearest.CFrame = CFrame.new(myPos)
            print("Brought nearest player!")
        end
    end
end)
