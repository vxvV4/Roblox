local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 5,
})

local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Toggle%20Gui%20Shizo/Source.lua"))()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local noclipEnabled = false
local noclipConnection

local function enableNoclip()
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        pcall(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    end)
    print("Noclip ON")
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    pcall(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
    print("Noclip OFF")
end

ToggleLib:CreateToggle("Noclip", false, function()
    
    noclipEnabled = true
    enableNoclip()
end, function()
    
    noclipEnabled = false
    disableNoclip()
end)
