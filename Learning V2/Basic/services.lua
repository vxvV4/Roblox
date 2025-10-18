-- ROBLOX SERVICES
-- Always get services at the top of your script

-- Most common services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Other useful services
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Teams = game:GetService("Teams")
local Chat = game:GetService("Chat")
local StarterGui = game:GetService("StarterGui")

-- GET LOCAL PLAYER (LocalScript only)
local player = Players.LocalPlayer
local userId = player.UserId
local username = player.Name
local displayName = player.DisplayName

-- Get character
local character = player.Character or player.CharacterAdded:Wait()

-- Get humanoid
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Check if character exists
if player.Character then
    print("Character loaded")
end

-- Wait for character to spawn
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    print("Character spawned")
end)

-- GET ALL PLAYERS (Server only)
local allPlayers = Players:GetPlayers()
for _, plr in pairs(allPlayers) do
    print(plr.Name)
end

-- Player events
Players.PlayerAdded:Connect(function(plr)
    print(plr.Name .. " joined")
end)

Players.PlayerRemoving:Connect(function(plr)
    print(plr.Name .. " left")
end)

-- WORKSPACE shortcuts
local workspace = game.Workspace -- or just workspace

-- REPLICATED STORAGE (shared between client and server)
-- Put RemoteEvents, RemoteFunctions, and shared modules here

-- SERVER STORAGE (server only)
-- Put server-side items here that clients shouldn't see

-- Check if script is on server or client
if RunService:IsServer() then
    print("Running on server")
end

if RunService:IsClient() then
    print("Running on client")
end

-- Check if in studio
if RunService:IsStudio() then
    print("Running in Roblox Studio")
end
