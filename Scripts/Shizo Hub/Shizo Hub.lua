-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Shizo%20Hub%20Library.lua"))()

-- Set the title
Library:SetTitle("••• Shizo ••• Hub •••")

-- Create tabs
local mainTab = Library:CreateTab("Main")

-- Add buttons to Main tab
mainTab:AddButton("Infinite Jump", function()
    print("Infinite Jump activated!")
    -- Your infinite jump code here
end)
