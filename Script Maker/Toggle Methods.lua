local hizo = loadstring(game:HttpGet("your_script_url"))()
local window = hizo:Window("hizo")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- METHOD 1: WHILE LOOP (Best for slow tasks)
-- ============================================
local farmRunning = false

window:Toggle("Auto Farm", false, function(state)
    if state then
        -- TURN ON
        farmRunning = true
        spawn(function()
            while farmRunning do
                print("Farming...")
                -- Your code here
                wait(1)
            end
            print("Farm stopped!")
        end)
    else
        -- TURN OFF
        farmRunning = false
    end
end)

-- ============================================
-- METHOD 2: RUNSERVICE (Best for fast/smooth loops)
-- ============================================
local killConnection

window:Toggle("Auto Kill", false, function(state)
    if state then
        -- TURN ON
        killConnection = RunService.Heartbeat:Connect(function()
            print("Killing...")
            -- Your kill code here
        end)
    else
        -- TURN OFF
        if killConnection then
            killConnection:Disconnect()
            killConnection = nil
        end
    end
end)

-- ============================================
-- METHOD 3: REPEAT UNTIL (Simple & clean)
-- ============================================
local collectEnabled = false

window:Toggle("Auto Collect", false, function(state)
    if state then
        -- TURN ON
        collectEnabled = true
        spawn(function()
            repeat
                print("Collecting...")
                -- Your collect code here
                wait(0.5)
            until not collectEnabled
            print("Collection stopped!")
        end)
    else
        -- TURN OFF
        collectEnabled = false
    end
end)

-- ============================================
-- METHOD 4: FOR LOOP with WHILE (Loop through all items repeatedly)
-- ============================================
local espRunning = false

window:Toggle("ESP All Players", false, function(state)
    if state then
        -- TURN ON
        espRunning = true
        spawn(function()
            while espRunning do
                for _, player in pairs(Players:GetPlayers()) do
                    if not espRunning then break end  -- Stop immediately if toggled off
                    
                    if player ~= Players.LocalPlayer and player.Character then
                        print("ESP on:", player.Name)
                        -- Your ESP code here
                    end
                end
                wait(0.1)
            end
            print("ESP stopped!")
        end)
    else
        -- TURN OFF
        espRunning = false
    end
end)

-- ============================================
-- REAL EXAMPLE 1: Auto Rocket (Your code)
-- ============================================
local rocketConnection

window:Toggle("Auto Rocket All", false, function(state)
    if state then
        -- TURN ON
        rocketConnection = RunService.Heartbeat:Connect(function()
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
        end)
    else
        -- TURN OFF
        if rocketConnection then
            rocketConnection:Disconnect()
            rocketConnection = nil
        end
    end
end)

-- ============================================
-- REAL EXAMPLE 2: Auto Farm Coins
-- ============================================
local coinFarmRunning = false

window:Toggle("Auto Farm Coins", false, function(state)
    if state then
        -- TURN ON
        coinFarmRunning = true
        spawn(function()
            while coinFarmRunning do
                for _, coin in pairs(workspace.Coins:GetChildren()) do
                    if not coinFarmRunning then break end
                    
                    local char = Players.LocalPlayer.Character
                    if char and coin:FindFirstChild("Hitbox") then
                        char.HumanoidRootPart.CFrame = coin.Hitbox.CFrame
                        print("Collected:", coin.Name)
                        wait(0.1)
                    end
                end
                wait(1)
            end
            print("Coin farm stopped!")
        end)
    else
        -- TURN OFF
        coinFarmRunning = false
    end
end)

-- ============================================
-- REAL EXAMPLE 3: Auto Click (Fast loop)
-- ============================================
local clickConnection

window:Toggle("Auto Click", false, function(state)
    if state then
        -- TURN ON
        clickConnection = RunService.Heartbeat:Connect(function()
            mouse1click()  -- Or your click code
            print("Clicking...")
        end)
    else
        -- TURN OFF
        if clickConnection then
            clickConnection:Disconnect()
            clickConnection = nil
        end
    end
end)

-- ============================================
-- REAL EXAMPLE 4: Kill Aura (Target nearest)
-- ============================================
local auraRunning = false

window:Toggle("Kill Aura", false, function(state)
    if state then
        -- TURN ON
        auraRunning = true
        spawn(function()
            while auraRunning do
                local myChar = Players.LocalPlayer.Character
                if myChar then
                    local myPos = myChar.HumanoidRootPart.Position
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if not auraRunning then break end
                        
                        if player ~= Players.LocalPlayer and player.Character then
                            local theirHrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if theirHrp then
                                local distance = (myPos - theirHrp.Position).Magnitude
                                
                                if distance <= 50 then  -- 50 studs range
                                    print("Killing:", player.Name, "Distance:", distance)
                                    -- Your kill code here
                                end
                            end
                        end
                    end
                end
                wait(0.1)
            end
            print("Kill aura stopped!")
        end)
    else
        -- TURN OFF
        auraRunning = false
    end
end)

-- ============================================
-- REAL EXAMPLE 5: Auto Teleport to Players
-- ============================================
local tpRunning = false

window:Toggle("Auto TP to Players", false, function(state)
    if state then
        -- TURN ON
        tpRunning = true
        spawn(function()
            while tpRunning do
                for _, player in pairs(Players:GetPlayers()) do
                    if not tpRunning then break end
                    
                    if player ~= Players.LocalPlayer and player.Character then
                        local theirHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local myChar = Players.LocalPlayer.Character
                        
                        if theirHrp and myChar then
                            myChar.HumanoidRootPart.CFrame = theirHrp.CFrame * CFrame.new(0, 5, 0)
                            print("TP to:", player.Name)
                            wait(2)
                        end
                    end
                end
                wait()
            end
            print("Auto TP stopped!")
        end)
    else
        -- TURN OFF
        tpRunning = false
    end
end)

-- ============================================
-- ADVANCED: Multiple connections in one toggle
-- ============================================
local conn1, conn2, conn3
local multiRunning = false

window:Toggle("Multi Feature", false, function(state)
    if state then
        -- TURN ON ALL
        multiRunning = true
        
        conn1 = RunService.Heartbeat:Connect(function()
            print("Feature 1 running")
        end)
        
        conn2 = RunService.RenderStepped:Connect(function()
            print("Feature 2 running")
        end)
        
        spawn(function()
            while multiRunning do
                print("Feature 3 running")
                wait(1)
            end
        end)
    else
        -- TURN OFF ALL
        multiRunning = false
        
        if conn1 then conn1:Disconnect() conn1 = nil end
        if conn2 then conn2:Disconnect() conn2 = nil end
    end
end)

-- ============================================
-- BUTTON EXAMPLES (One-time execution)
-- ============================================

-- Button: Kill all once
window:Button("Kill All (Once)", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            print("Killing:", player.Name)
            -- Your kill code here
        end
    end
    print("Done!")
end)

-- Button: Collect all coins once
window:Button("Collect All Coins", function()
    local char = Players.LocalPlayer.Character
    if char then
        for _, coin in pairs(workspace.Coins:GetChildren()) do
            char.HumanoidRootPart.CFrame = coin.CFrame
            wait(0.1)
        end
    end
    print("All coins collected!")
end)

-- Button: TP to spawn
window:Button("TP to Spawn", function()
    local char = Players.LocalPlayer.Character
    if char then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- Button: Fire rocket once
window:Button("Fire Rocket", function()
    local args = {
        CFrame.new(0, 100, 0),
        Vector3.new(0, 100, 0),
        "Standard Launcher"
    }
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RocketLauncherEvent"):FireServer(unpack(args))
end)
