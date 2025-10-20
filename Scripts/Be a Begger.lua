--[[
This Script It's not Finished yet.
Hehehe

Shizoscript.
--]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Script%20Maker/Useful/YouTube%20Library.lua"))()
local Window = Library:CreateWindow("Be a Beggar!")
local connection = nil

Window:AddToggle("Auto Farm", false, function(state)

    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if state then
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MinigameEvent"):FireServer(true)
        end)
        print("ON")
    else
        print("OFF")
    end
end)
