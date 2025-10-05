--[[
================================================================================
    ROBLOX BASICS - Est Roblox Scripting
    File: 02_ROBLOX_BASICS.lua
    Learn Roblox-scriting Well yeah i this helps me learn actually 
================================================================================
]]--

-- ============================================================================
-- SECTION 1: SERVICES (Most Important!)
-- ============================================================================

-- Services are core systems in Roblox. Always get them at the top!
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")  -- Can also use: workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

--[[
Common Services:
- Players: Manage players in the game
- Workspace: Everything visible in the 3D world
- ReplicatedStorage: Objects accessible by both server and client
- ServerStorage: Server-only objects (not sent to clients)
- RunService: Game loop and frame updates
- UserInputService: Keyboard, mouse, touch input
- TweenService: Smooth animations
- Debris: Auto-delete objects after time
]]--


-- ============================================================================
-- SECTION 2: GAME HIERARCHY
-- ============================================================================

--[[
Roblox Game Structure:
Well use Dex so you'll know what i mean Lmao

game
├── Workspace (3D world)
│   ├── Parts
│   ├── Models
│   └── NPCs
├── Players
│   └── Player
│       ├── Character (Player model in world)
│       └── PlayerGui (UI)
├── ReplicatedStorage (Client & Server)
├── ServerStorage (Server only)
├── ReplicatedFirst (Loads first)
└── ServerScriptService (Server scripts)
]]--


-- ============================================================================
-- SECTION 3: FINDING OBJECTS
-- ============================================================================

-- WaitForChild (WAITS until object exists - safe!)
local part = workspace:WaitForChild("MyPart")
print("Found:", part.Name)

-- WaitForChild with timeout (wait max 5 seconds)
local part2 = workspace:WaitForChild("MyPart", 5)
if part2 then
    print("Found it!")
else
    warn("Part not found after 5 seconds")
end


-- FindFirstChild (returns nil if not found - check before using!)
local maybePart = workspace:FindFirstChild("MaybePart")
if maybePart then
    print("Part exists!")
else
    print("Part doesn't exist")
end


-- FindFirstChildOfClass (find by class type)
local humanoid = character:FindFirstChildOfClass("Humanoid")
local script = workspace:FindFirstChildOfClass("Script")


-- FindFirstChildWhichIsA (includes inherited classes)
local part = workspace:FindFirstChildWhichIsA("BasePart")  -- Part, MeshPart, etc.


-- FindFirstAncestor (search up the parent tree)
local model = part:FindFirstAncestor("Model")


-- GetChildren (all direct children)
for _, child in pairs(workspace:GetChildren()) do
    print("Child:", child.Name)
end


-- GetDescendants (all children, grandchildren, etc.)
for _, descendant in pairs(workspace:GetDescendants()) do
    if descendant:IsA("Part") then
        print("Found part:", descendant.Name)
    end
end


-- ============================================================================
-- SECTION 4: PLAYER MANAGEMENT
-- ============================================================================

-- Get local player (LocalScript only!)
local player = Players.LocalPlayer

-- Get player properties
print("Username:", player.Name)
print("Display Name:", player.DisplayName)
print("UserId:", player.UserId)
print("Account Age:", player.AccountAge, "days")


-- Player added event (Server script)
Players.PlayerAdded:Connect(function(player)
    print(player.Name .. " joined the game!")
    
    -- Give player 100 coins
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 100
    coins.Parent = leaderstats
end)


-- Player leaving event
Players.PlayerRemoving:Connect(function(player)
    print(player.Name .. " left the game!")
end)


-- Character added (when player spawns)
player.CharacterAdded:Connect(function(character)
    print(player.Name .. " spawned!")
    
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    print("Health:", humanoid.Health)
end)


-- Wait for character (if it doesn't exist yet)
local character = player.Character or player.CharacterAdded:Wait()


-- Get all players in game
for _, p in pairs(Players:GetPlayers()) do
    print("Player:", p.Name)
end


-- ============================================================================
-- SECTION 5: CHARACTER & HUMANOID
-- ============================================================================

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Health
print("Current health:", humanoid.Health)
print("Max health:", humanoid.MaxHealth)

humanoid.Health = 50  -- Set health
humanoid.MaxHealth = 200  -- Change max health


-- Death event
humanoid.Died:Connect(function()
    print("Player died!")
end)


-- Take damage
humanoid:TakeDamage(25)


-- Movement
humanoid.WalkSpeed = 16   -- Default: 16
humanoid.JumpPower = 50   -- Default: 50 (or use JumpHeight)
humanoid.JumpHeight = 7.2 -- Alternative to JumpPower


-- Humanoid states
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)

--[[
Common HumanoidStateTypes:
- Running
- Jumping
- Freefall
- Flying
- Swimming
- Dead
- Physics (ragdoll)
]]--


-- Get current state
local state = humanoid:GetState()
if state == Enum.HumanoidStateType.Running then
    print("Player is running!")
end


-- ============================================================================
-- SECTION 6: PARTS & PROPERTIES
-- ============================================================================

-- Create a new part
local part = Instance.new("Part")
part.Name = "MyPart"
part.Size = Vector3.new(10, 5, 10)  -- Width, Height, Depth
part.Position = Vector3.new(0, 10, 0)  -- X, Y, Z
part.Anchored = true  -- Won't fall
part.CanCollide = true  -- Can be touched
part.Transparency = 0  -- 0 = solid, 1 = invisible
part.Material = Enum.Material.Neon
part.BrickColor = BrickColor.new("Bright red")
part.Color = Color3.fromRGB(255, 0, 0)  -- RGB color
part.Parent = workspace  -- Add to game (always last!)


-- Common properties
part.Reflectance = 0.5  -- Shininess (0-1)
part.CastShadow = true
part.CollisionGroup = "Default"


-- Destroy object
part:Destroy()


-- Clone object
local copy = part:Clone()
copy.Position = Vector3.new(20, 10, 0)
copy.Parent = workspace


-- ============================================================================
-- SECTION 7: VECTOR3 & CFRAME
-- ============================================================================

-- Vector3 (Position in 3D space)
local pos = Vector3.new(10, 5, 0)  -- X, Y, Z
print("X:", pos.X, "Y:", pos.Y, "Z:", pos.Z)

-- Vector3 math
local pos1 = Vector3.new(10, 0, 0)
local pos2 = Vector3.new(5, 0, 0)
local distance = (pos1 - pos2).Magnitude  -- 5 studs
print("Distance:", distance)

-- Special Vector3 values
print(Vector3.zero)    -- (0, 0, 0)
print(Vector3.one)     -- (1, 1, 1)
print(Vector3.xAxis)   -- (1, 0, 0)
print(Vector3.yAxis)   -- (0, 1, 0)
print(Vector3.zAxis)   -- (0, 0, 1)


-- CFrame (Position + Rotation)
part.CFrame = CFrame.new(0, 10, 0)  -- Just position

-- Move relative to current position
part.CFrame = part.CFrame * CFrame.new(0, 5, 0)  -- Move up 5 studs
part.CFrame = part.CFrame * CFrame.new(5, 0, 0)  -- Move right 5 studs

-- Rotation (in radians!)
part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(90), 0)  -- Rotate 90°

-- Look at position
local targetPos = Vector3.new(50, 10, 50)
part.CFrame = CFrame.lookAt(part.Position, targetPos)

-- Get direction vectors
local lookVector = part.CFrame.LookVector    -- Forward
local rightVector = part.CFrame.RightVector  -- Right
local upVector = part.CFrame.UpVector        -- Up


-- ============================================================================
-- SECTION 8: TOUCH DETECTION
-- ============================================================================

local part = workspace.TouchPart

-- Basic touch event
part.Touched:Connect(function(hit)
    print("Something touched the part:", hit.Name)
end)


-- Check if a player touched it
part.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
    if humanoid then
        print("A player touched the part!")
        humanoid:TakeDamage(10)
    end
end)


-- Touch ended event
part.TouchEnded:Connect(function(hit)
    print("Stopped touching")
end)


-- Debounce (prevent spam)
local debounce = false

part.Touched:Connect(function(hit)
    if debounce then return end  -- Still on cooldown
    debounce = true
    
    local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:TakeDamage(10)
        print("Damage dealt!")
    end
    
    wait(1)  -- Cooldown time
    debounce = false
end)


-- Better debounce (per player)
local debounces = {}

part.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if not player then return end
    
    if debounces[player] then return end
    debounces[player] = true
    
    humanoid:TakeDamage(10)
    
    wait(1)
    debounces[player] = nil
end)


-- ============================================================================
-- SECTION 9: EVENTS & CONNECTIONS
-- ============================================================================

-- Connect to event
local connection = part.Touched:Connect(function(hit)
    print("Touched!")
end)

-- Disconnect event (stop listening)
connection:Disconnect()


-- Once (fire only once then auto-disconnect)
part.Touched:Once(function(hit)
    print("This only fires once!")
end)


-- Changed event (property changes)
part:GetPropertyChangedSignal("Color"):Connect(function()
    print("Part color changed to:", part.Color)
end)


-- ============================================================================
-- SECTION 10: WAIT & TIMING
-- ============================================================================

-- Basic wait
wait(2)  -- Wait 2 seconds
print("2 seconds passed")

-- task.wait (faster and better)
task.wait(1)  -- Preferred way

-- Wait for event
local connection
connection = part.Touched:Connect(function()
    print("Part was touched!")
    connection:Disconnect()  -- Stop waiting
end)

-- Spawn (run code in parallel)
spawn(function()
    wait(2)
    print("This runs in the background")
end)

-- task.spawn (better than spawn)
task.spawn(function()
    print("This also runs in background")
end)

-- Delay (run after time)
task.delay(3, function()
    print("This runs after 3 seconds")
end)


-- ============================================================================
-- SECTION 11: SIMPLE TELEPORT
-- ============================================================================

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Teleport player
local teleportPart = workspace.TeleportPart

teleportPart.Touched:Connect(function(hit)
    if hit.Parent:FindFirstChildOfClass("Humanoid") then
        local hrp = hit.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, 50, 0)  -- Teleport to Y=50
        end
    end
end)


-- ============================================================================
-- SECTION 12: SIMPLE DAMAGE SYSTEM
-- ============================================================================

local damagePart = workspace.DamagePart
local DAMAGE = 25
local COOLDOWN = 1
local debounces = {}

damagePart.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if not player then return end
    
    if debounces[player] then return end
    debounces[player] = true
    
    humanoid:TakeDamage(DAMAGE)
    print(player.Name .. " took " .. DAMAGE .. " damage!")
    
    task.wait(COOLDOWN)
    debounces[player] = nil
end)


-- ============================================================================
-- SECTION 13: LEADERSTATS (SCOREBOARD)
-- ============================================================================

Players.PlayerAdded:Connect(function(player)
    -- Create leaderstats folder
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    -- Add coins
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    -- Add kills
    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Value = 0
    kills.Parent = leaderstats
end)

-- Give coins to player
local function giveCoins(player, amount)
    local coins = player.leaderstats:FindFirstChild("Coins")
    if coins then
        coins.Value = coins.Value + amount
    end
end


-- ============================================================================
-- SECTION 14: DEBRIS SERVICE (AUTO-DELETE)
-- ============================================================================

local Debris = game:GetService("Debris")

-- Create part that deletes after 5 seconds
local tempPart = Instance.new("Part")
tempPart.Position = Vector3.new(0, 10, 0)
tempPart.Parent = workspace
Debris:AddItem(tempPart, 5)  -- Delete after 5 seconds


-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

--[[
TRY THESE YOURSELF:

1. Create a part that changes color when touched
2. Make a kill brick that teleports player back to spawn
3. Create a coin that gives 10 coins when collected and disappears
4. Make a speed boost pad that increases WalkSpeed for 5 seconds
5. Create a part that follows the player
6. Make a simple obby checkpoint system
7. Create a health regeneration system
8. Make a part that rotates continuously

]]--


print("\n✅ You've completed ROBLOX BASICS? Now move to 03_ROBLOX_INTERMEDIATE.lua")
