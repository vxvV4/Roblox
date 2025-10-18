local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 8,
})

-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Shizo%20Hub%20Library.lua"))()

-- Set the title
Library:SetTitle("••• Shizo ••• Hub •••")

-- Create tabs
local mainTab = Library:CreateTab("Main")

-- // *** Add button Main Tab *** \\ --
mainTab:AddButton("Walk Speed", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Settings/Walk%20speed.lua"))()
end)

-- // *** Add button Main Tab *** \\ --
mainTab:AddButton("Infinite Jump", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Settings/Infinite%20Jump.lua"))()
end)

-- // *** Add button Main Tab *** \\ --
mainTab:AddButton("Gravity Changer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Settings/Gravity%20Charger.lua"))()
end)

-- // *** Add button Main Tab *** \\ --
mainTab:AddButton("Noclip", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Settings/Noclip.lua"))()
end)

-- // *** Add button Main Tab *** \\ --
mainTab:AddButton("Esp", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Settings/Esp.lua"))()
end)
