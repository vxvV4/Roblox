-- Load the library
local ToggleLib = loadstring(game:HttpGet("YOUR_PASTEBIN_URL"))()

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
