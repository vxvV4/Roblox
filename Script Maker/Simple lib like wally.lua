local library = loadstring(game:HttpGet("https://pastefy.app/iAE0T7Jn/raw"))()

-- Create a main window
local window = library:CreateWindow("My Script")

-- Add buttons to the window
window:AddButton({
    text = "Button 1",
    callback = function()
        print("Button 1 clicked!")
    end
})

window:AddButton({
    text = "Teleport",
    callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
})

-- Create a folder inside the window
local folder1 = window:AddFolder("Settings")

-- Add buttons inside the folder
folder1:AddButton({
    text = "Reset Character",
    callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

folder1:AddButton({
    text = "Print Hello",
    callback = function()
        print("Hello World!")
    end
})

-- Create another folder
local folder2 = window:AddFolder("Combat")

folder2:AddButton({
    text = "God Mode",
    callback = function()
        print("God mode activated!")
    end
})

-- You can nest folders inside folders
local subfolder = folder1:AddFolder("Advanced")

subfolder:AddButton({
    text = "Sub Button",
    callback = function()
        print("Subfolder button clicked!")
    end
})

-- Initialize the UI (this must be called last)
library:Init()
