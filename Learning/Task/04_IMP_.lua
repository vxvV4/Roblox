--[[
================================================================================
    ROBLOX IMPOT
    File: 04_ROBLOX_ADVANCED.lua
    DataStores, OOP, Module Scripts, Optimization, and others Tec etc...
================================================================================
]]--

-- ============================================================================
-- SECTION 1: MODULE SCRIPTS (Reusable Code)
-- ============================================================================

--[[
ModuleScript = Reusable code library
Place in: ReplicatedStorage (for both server and client)
         ServerStorage (server only)
i think???????? WHAAAAA ?!!!!
]]--

-- CREATE MODULE (MyModule in ReplicatedStorage)
local MyModule = {}

-- Module variables
MyModule.Version = "1.0.0"
MyModule.Author = "YourName"

-- Module functions
function MyModule.SayHello(name)
    return "Hello, " .. name .. "!"
end

function MyModule.Calculate(a, b, operation)
    if operation == "add" then
        return a + b
    elseif operation == "multiply" then
        return a * b
    else
        return 0
    end
end

-- Private function (not accessible outside)
local function privateHelper()
    return "This is private"
end

-- Public function using private function
function MyModule.UseHelper()
    return privateHelper()
end

return MyModule  -- MUST return the module!


-- USE MODULE (in another script)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MyModule = require(ReplicatedStorage.MyModule)

print(MyModule.SayHello("Bob"))  -- "Hello, Bob!"
local result = MyModule.Calculate(5, 3, "add")  -- 8


-- ============================================================================
-- SECTION 2: OOP (Object-Oriented Programming)
-- ============================================================================

-- CREATE A CLASS (Weapon class example)
local Weapon = {}
Weapon.__index = Weapon

-- Constructor
function Weapon.new(name, damage, fireRate)
    local self = setmetatable({}, Weapon)
    
    -- Properties
    self.Name = name
    self.Damage = damage
    self.FireRate = fireRate
    self.Ammo = 30
    self.MaxAmmo = 30
    
    return self
end

-- Methods
function Weapon:Shoot()
    if self.Ammo > 0 then
        self.Ammo = self.Ammo - 1
        print(self.Name .. " fired! Ammo: " .. self.Ammo)
        return true
    else
        print("Out of ammo!")
        return false
    end
end

function Weapon:Reload()
    self.Ammo = self.MaxAmmo
    print(self.Name .. " reloaded!")
end

function Weapon:GetInfo()
    return string.format("%s (DMG: %d, Ammo: %d/%d)", 
        self.Name, self.Damage, self.Ammo, self.MaxAmmo)
end

-- USE THE CLASS
local rifle = Weapon.new("AK-47", 35, 0.1)
print(rifle:GetInfo())
rifle:Shoot()
rifle:Shoot()
rifle:Reload()


-- INHERITANCE (Advanced OOP)
local Pistol = setmetatable({}, {__index = Weapon})
Pistol.__index = Pistol

function Pistol.new(name, damage)
    local self = Weapon.new(name, damage, 0.5)
    setmetatable(self, Pistol)
    
    self.MaxAmmo = 12
    self.Ammo = 12
    
    return self
end

function Pistol:QuickDraw()
    print(self.Name .. " quick draw!")
end

local glock = Pistol.new("Glock-17", 25)
glock:Shoot()
glock:QuickDraw()


-- ============================================================================
-- SECTION 3: DATASTORES (Save Player Data)
-- ============================================================================

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local playerData = DataStoreService:GetDataStore("PlayerData_v1")

local defaultData = {
    Coins = 0,
    Level = 1,
    XP = 0,
    Inventory = {},
    Settings = {
        Music = true,
        SFX = true
    }
}

-- LOAD DATA
local function loadData(player)
    local success, data = pcall(function()
        return playerData:GetAsync(player.UserId)
    end)
    
    if success then
        if data then
            print("Loaded data for " .. player.Name)
            return data
        else
            print("New player: " .. player.Name)
            return defaultData
        end
    else
        warn("Failed to load data for " .. player.Name)
        return defaultData
    end
end

-- SAVE DATA
local function saveData(player, data)
    local success = pcall(function()
        playerData:SetAsync(player.UserId, data)
    end)
    
    if success then
        print("Saved data for " .. player.Name)
    else
        warn("Failed to save data for " .. player.Name)
    end
end

-- PLAYER ADDED
Players.PlayerAdded:Connect(function(player)
    local data = loadData(player)
    
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = data.Coins
    coins.Parent = leaderstats
end)

-- PLAYER LEAVING
Players.PlayerRemoving:Connect(function(player)
    local data = {
        Coins = player.leaderstats.Coins.Value,
        Level = 1,
    }
    saveData(player, data)
end)


-- ============================================================================
-- SECTION 4: COLLECTIONS SERVICE (Tags)
-- ============================================================================

local CollectionService = game:GetService("CollectionService")

-- Add tag to object
CollectionService:AddTag(part, "Collectible")

-- Check if has tag
if CollectionService:HasTag(part, "Collectible") then
    print("This is collectible!")
end

-- Get all objects with tag
local collectibles = CollectionService:GetTagged("Collectible")
for _, obj in pairs(collectibles) do
    print("Found collectible:", obj.Name)
end

-- Listen for new tagged objects
CollectionService:GetInstanceAddedSignal("Collectible"):Connect(function(object)
    print("New collectible added:", object.Name)
    
    if object:IsA("BasePart") then
        object.Touched:Connect(function(hit)
            print("Collectible touched!")
        end)
    end
end)


-- ============================================================================
-- SECTION 5: REGION3 (Area Detection)
-- ============================================================================

-- Create region
local corner1 = Vector3.new(-50, 0, -50)
local corner2 = Vector3.new(50, 50, 50)
local region = Region3.new(corner1, corner2)

-- Find parts in region
local parts = workspace:FindPartsInRegion3(region, nil, 100)

for _, part in pairs(parts) do
    print("Found in region:", part.Name)
end

-- With ignore list
local ignoreList = {workspace.BaseplatePart}
local parts = workspace:FindPartsInRegion3(region, ignoreList, 100)


-- ============================================================================
-- SECTION 6: PATHFINDING (AI Navigation)
-- ============================================================================

local PathfindingService = game:GetService("PathfindingService")

local function findPath(start, finish)
    -- Create path
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })
    
    -- Compute path
    local success, errorMessage = pcall(function()
        path:ComputeAsync(start, finish)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    else
        warn("Path failed:", errorMessage)
        return nil
    end
end

-- Move NPC along path
local function moveAlongPath(npc, waypoints)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    
    for i, waypoint in pairs(waypoints) do
        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end
        
        humanoid:MoveTo(waypoint.Position)
        humanoid.MoveToFinished:Wait()
    end
end

-- Example usage
local npc = workspace.Zombie
local targetPos = workspace.Target.Position
local waypoints = findPath(npc.HumanoidRootPart.Position, targetPos)

if waypoints then
    moveAlongPath(npc, waypoints)
end


-- ============================================================================
-- SECTION 7: METATABLES (Advanced Lua)
-- ============================================================================

-- Simple metatable
local myTable = {value = 10}

local metatable = {
    __add = function(t1, t2)
        return t1.value + t2.value
    end,
    
    __tostring = function(t)
        return "Value: " .. t.value
    end,
    
    __index = function(t, key)
        return "Key '" .. key .. "' doesn't exist"
    end
}

setmetatable(myTable, metatable)

local table2 = {value = 5}
setmetatable(table2, metatable)

print(myTable + table2)  -- 15
print(myTable)  -- "Value: 10"
print(myTable.nonexistent)  -- "Key 'nonexistent' doesn't exist"


-- ============================================================================
-- SECTION 8: PERFORMANCE OPTIMIZATION
-- ============================================================================

-- ❌ BAD: Creating connections in loops
for i = 1, 100 do
    part.Touched:Connect(function() end)  -- 100 connections!
end

-- ✅ GOOD: One connection
part.Touched:Connect(function() end)


-- ❌ BAD: Searching every frame
RunService.Heartbeat:Connect(function()
    local part = workspace:FindFirstChild("MyPart")  -- Slow!
end)

-- ✅ GOOD: Cache the reference
local cachedPart = workspace:WaitForChild("MyPart")
RunService.Heartbeat:Connect(function()
    -- Use cachedPart
end)


-- ❌ BAD: Using wait() in loops
for i = 1, 100 do
    wait()  -- Minimum 1/30 second each
end

-- ✅ GOOD: Use task.wait()
for i = 1, 100 do
    task.wait()  -- Much faster
end


-- ❌ BAD: Concatenating in loops
local str = ""
for i = 1, 1000 do
    str = str .. i  -- Creates new string each time
end

-- ✅ GOOD: Use table.concat
local parts = {}
for i = 1, 1000 do
    table.insert(parts, i)
end
local str = table.concat(parts, ", ")


-- ❌ BAD: pairs() on arrays
local array = {1, 2, 3, 4, 5}
for i, v in pairs(array) do  -- Slower
    print(v)
end

-- ✅ GOOD: ipairs() or numeric for
for i, v in ipairs(array) do  -- Faster
    print(v)
end

for i = 1, #array do  -- Fastest
    print(array[i])
end


-- ============================================================================
-- SECTION 9: ERROR HANDLING (pcall & xpcall)
-- ============================================================================

-- pcall (protected call)
local success, result = pcall(function()
    return workspace.NonExistent.Value  -- Will error
end)

if success then
    print("Success:", result)
else
    warn("Error:", result)
end


-- Retry logic
local function retryOperation(func, maxRetries)
    for attempt = 1, maxRetries do
        local success, result = pcall(func)
        
        if success then
            return true, result
        else
            warn("Attempt " .. attempt .. " failed:", result)
            if attempt < maxRetries then
                task.wait(1)
            end
        end
    end
    
    return false, "All attempts failed"
end

-- Usage
local success, data = retryOperation(function()
    return DataStore:GetAsync("Key")
end, 3)


-- xpcall (pcall with error handler)
local function errorHandler(err)
    warn("Custom error handler:", err)
    warn(debug.traceback())
end

xpcall(function()
    error("Something went wrong!")
end, errorHandler)


-- ============================================================================
-- SECTION 10: CUSTOM EVENTS SYSTEM
-- ============================================================================

-- Event class
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self.connections = {}
    return self
end

function Signal:Connect(callback)
    local connection = {
        callback = callback,
        connected = true
    }
    
    table.insert(self.connections, connection)
    
    return {
        Disconnect = function()
            connection.connected = false
        end
    }
end

function Signal:Fire(...)
    for _, connection in pairs(self.connections) do
        if connection.connected then
            task.spawn(connection.callback, ...)
        end
    end
end

function Signal:Wait()
    local waiting = true
    local args = nil
    
    local connection
    connection = self:Connect(function(...)
        waiting = false
        args = {...}
        connection:Disconnect()
    end)
    
    while waiting do
        task.wait()
    end
    
    return table.unpack(args)
end

-- Usage
local myEvent = Signal.new()

local conn = myEvent:Connect(function(msg)
    print("Received:", msg)
end)

myEvent:Fire("Hello!")
conn:Disconnect()


-- ============================================================================
-- SECTION 11: ANIMATION SCRIPTING
-- ============================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

-- Load animation
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://123456789"

local animTrack = animator:LoadAnimation(animation)

-- Play animation
animTrack:Play()

-- Stop animation
animTrack:Stop()

-- Animation properties
animTrack.Priority = Enum.AnimationPriority.Action
animTrack.Looped = false

-- Animation events
animTrack.Stopped:Connect(function()
    print("Animation finished")
end)

-- Adjust speed
animTrack:AdjustSpeed(1.5)  -- 1.5x speed


-- ============================================================================
-- SECTION 12: ADVANCED RAYCASTING
-- ============================================================================

-- Whitelist raycast (only hit specific parts)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include
rayParams.FilterDescendantsInstances = {workspace.TargetFolder}

local result = workspace:Raycast(origin, direction, rayParams)


-- Raycast with collision groups
local rayParams = RaycastParams.new()
rayParams.CollisionGroup = "Bullets"
rayParams.IgnoreWater = true

local result = workspace:Raycast(origin, direction, rayParams)


-- Multiple raycasts (shotgun pattern)
local function shotgunRaycast(origin, direction, pelletCount, spread)
    local hits = {}
    
    for i = 1, pelletCount do
        local randomX = math.random(-spread, spread) / 100
        local randomY = math.random(-spread, spread) / 100
        
        local spreadDir = (direction + Vector3.new(randomX, randomY, 0)).Unit * 100
        
        local result = workspace:Raycast(origin, spreadDir)
        if result then
            table.insert(hits, result)
        end
    end
    
    return hits
end


-- ============================================================================
-- SECTION 13: TWEEN CHAINS (Sequential Animations)
-- ============================================================================

local TweenService = game:GetService("TweenService")

local function tweenSequence(part)
    local tween1 = TweenService:Create(part, TweenInfo.new(1), {
        Position = Vector3.new(0, 10, 0)
    })
    
    local tween2 = TweenService:Create(part, TweenInfo.new(1), {
        Position = Vector3.new(20, 10, 0),
        Color = Color3.fromRGB(255, 0, 0)
    })
    
    local tween3 = TweenService:Create(part, TweenInfo.new(1), {
        Position = Vector3.new(0, 10, 0),
        Transparency = 1
    })
    
    tween1:Play()
    tween1.Completed:Wait()
    
    tween2:Play()
    tween2.Completed:Wait()
    
    tween3:Play()
    tween3.Completed:Wait()
    
    part:Destroy()
end

task.spawn(tweenSequence, workspace.MyPart)


-- ============================================================================
-- PRACTICE ADVANCED PROJECTS
-- ============================================================================

--[[
BUILD THESE TO MASTER ADVANCED SKILLS:

1. Inventory System
   - Save/load with DataStore
   - Drag and drop GUI
   - Item stacking
   - Equipment system

2. Quest System
   - Track multiple quests
   - Quest objectives
   - Rewards on completion
   - Save progress

3. AI Enemy System
   - Pathfinding to player
   - Attack when in range
   - Health bar
   - Death animation

4. Advanced Gun System
   - Raycasting bullets
   - Recoil and spread
   - Magazine system
   - Different gun types (class-based)

5. Shop System with DataStore
   - Buy/sell items
   - Currency system
   - Save purchases
   - GUI with categories

6. Skill System
   - Cooldown management
   - Visual effects
   - Level requirements
   - Multiple abilities

7. Team System
   - Auto team balance
   - Team colors
   - Spawn locations
   - Score tracking

8. Admin Commands
   - Kick/ban players
   - Teleport
   - Give items
   - Server announcements
]]--


print("\n✅Didn't use bypass it's hard make your own Lmao")
