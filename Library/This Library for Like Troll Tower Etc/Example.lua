local VenLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/This%20Library%20for%20Like%20Troll%20Tower%20Etc/Dev%20library.luaU"))()

-- Or if it's a local module:
-- local VenLib = require(script.VenLib)

-- Create a Window
local Window = VenLib:Window("My Cool Script")

-- Create Tabs
local MainTab = Window:Tab("Main")
local SettingsTab = Window:Tab("Settings")
local MiscTab = Window:Tab("Misc")

-- ============================================
-- BUTTON EXAMPLE
-- ============================================
MainTab:Button("Click Me!", function()
    print("Button was clicked!")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Button Clicked";
        Text = "You pressed the button!";
        Duration = 3;
    })
end)

-- ============================================
-- TOGGLE EXAMPLE
-- ============================================
MainTab:Toggle("Enable Feature", function(state)
    if state then
        print("Toggle is ON")
        -- Your code when toggle is enabled
    else
        print("Toggle is OFF")
        -- Your code when toggle is disabled
    end
end)

-- ============================================
-- SLIDER EXAMPLE
-- ============================================
MainTab:Slider("Walk Speed", 16, 200, 16, function(value)
    print("Slider value:", value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
-- Parameters: Text, Min, Max, Default, Callback

-- ============================================
-- DROPDOWN EXAMPLE
-- ============================================
local weapons = {"Sword", "Bow", "Staff", "Dagger"}
MainTab:Dropdown("Select Weapon", weapons, function(selected)
    print("Selected weapon:", selected)
    -- Your code when option is selected
end)

-- ============================================
-- TEXTBOX EXAMPLE
-- ============================================
MainTab:Textbox("Player Name", false, function(text)
    print("Text entered:", text)
    -- Use the text input
end)
-- Parameters: Text, DisappearAfterEnter (true/false), Callback

-- Textbox that clears after entering
MainTab:Textbox("Teleport to Player", true, function(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer then
        print("Teleporting to:", playerName)
        -- Teleport code here
    end
end)

-- ============================================
-- LABEL EXAMPLE
-- ============================================
local statusLabel = MainTab:Label("Status: Ready")

MainTab:Seperator()

--ll // ass Label \\ ll
SettingsTab:Label("═══ Display Settings ═══")

SettingsTab:Toggle("Show FPS", function(state)
    if state then
        print("FPS counter enabled")
    else
        print("FPS counter disabled")
    end
end)

SettingsTab:Slider("GUI Transparency", 0, 100, 0, function(value)
    print("Transparency:", value .. "%")
    -- Adjust UI transparency
end)

SettingsTab:Seperator()

SettingsTab:Label("═══ Audio Settings ═══")

SettingsTab:Slider("Volume", 0, 100, 50, function(value)
    print("Volume:", value .. "%")
end)

MiscTab:Button("Reset Character", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

MiscTab:Button("Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

local themes = {"Dark", "Blue", "Red", "Green", "Purple"}
MiscTab:Dropdown("Theme", themes, function(theme)
    print("Theme changed to:", theme)
    -- Change UI colors based on theme just example Lmao
end)

MiscTab:Textbox("Custom Message", false, function(msg)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end)

local espEnabled = false
local espLabel = MainTab:Label("ESP: Disabled")
MainTab:Toggle("Enable ESP", function(state)
    espEnabled = state
    espLabel:SetText(state and "ESP: Enabled" or "ESP: Disabled")
    -- Your ESP code here
end)

-- // Add Slider \\ --
MainTab:Slider("Field of View", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

-- // Add Dropdown \\ --
local locations = {"Spawn", "Shop", "Arena", "Secret"}
MainTab:Dropdown("Teleport Location", locations, function(location)
    if location == "Spawn" then
        -- Teleport to spawn
    elseif location == "Shop" then
        -- Teleport to shop
    end
    print("Teleporting to:", location)
end)

-- // Add Toggle \\ --
local speedEnabled = false
local normalSpeed = 16
MainTab:Toggle("Speed Hack", function(state)
    speedEnabled = state
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = normalSpeed
    end
end)

print("VenLib UI Loaded Successfully!")
