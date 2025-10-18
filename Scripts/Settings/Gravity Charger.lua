local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 2,
})

local SliderLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Slider%20Gui%20Shizo/Source.lua"))()

SliderLib:CreateSlider("Gravity", 16, 200, 16, function(value)
    game.Workspace.Gravity = value
end)
