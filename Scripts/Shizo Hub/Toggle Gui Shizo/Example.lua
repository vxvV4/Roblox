-- Load the library
local ToggleLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Toggle%20Gui%20Shizo/Source.lua"))()

-- Create toggles with callbacks
ToggleLib:CreateToggle("Infinite Jump", false, function()
    -- Code when turned ON
    print("Infinite Jump ON!")
    _G.InfJump = true
end, function()
    -- Code when turned OFF
    print("Infinite Jump OFF!")
    _G.InfJump = false
end)
