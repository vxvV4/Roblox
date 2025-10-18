local TextboxLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/Shizo%20Hub/Textbox%20Gui%20Shizo/Source.lua"))()

TextboxLib:CreateTextbox("Walk Speed", "Enter speed...", function(value)
    local speed = tonumber(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)
