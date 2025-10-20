local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Script%20Maker/Useful/YouTube%20Library.lua"))()

local Window = Library:CreateWindow("Be a Beggar!")

Window:AddToggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

Window:AddToggle("Auto Upgrade", false, function(state)
    print("Auto Upgrade:", state)
end)

Window:AddButton("Claim Rewards", function()
    print("Button clicked!")
end)

Window:AddToggle("Auto Buy Employees", false, function(state)
    print("Auto Buy Employees:", state)
end)

Window:AddToggle("Anti AFK", true, function(state)
    print("Anti AFK:", state)
end)

Window:AddToggle("Auto Collect", false, function(state)
    print("Auto Collect:", state)
end)
