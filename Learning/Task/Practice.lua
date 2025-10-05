--[[
================================================================================
     Well that's it Hope this Helps you
    File: 05_PRO_TIPS_AND_BEST_PRACTICES.lua
    Security, Optimization, Debugging, Common Mistakes, and Professional Code
================================================================================
]]--

-- ============================================================================
-- SECTION 1: SECURITY BEST PRACTICES
-- ============================================================================

--[[
GOLDEN RULE: NEVER TRUST THE CLIENT!
- Client can be exploited
- Server has final say
- Validate everything on server
]]--

-- ❌ BAD: Client handling damage (EXPLOITABLE!)
-- LocalScript
local remoteEvent = game.ReplicatedStorage.DealDamage
remoteEvent:FireServer(9999999)  -- Exploiters this just Simple i recommend do 9ea can change this!

-- ✅ GOOD: Server validates damage
-- Server Script
remoteEvent.OnServerEvent:Connect(function(player, targetPlayer, damage)
    -- Validate damage amount
    local maxDamage = 100
    if damage > maxDamage then
        warn(player.Name .. " tried to deal " .. damage .. " damage!")
        player:Kick("Exploiting")
        return
    end
    
    -- Validate distance
    if player.Character and targetPlayer.Character then
        local dist = (player.Character.HumanoidRootPart.Position - 
                     targetPlayer.Character.HumanoidRootPart.Position).Magnitude
        
        if dist > 50 then
            warn(player.Name .. " tried to damage from too far!")
            return
        end
    end
    
    -- Apply damage
    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:TakeDamage(damage)
    end
end)


-- ❌ BAD: Client giving items (EXPLOITABLE!)
-- LocalScript
local giveItemEvent = game.ReplicatedStorage.GiveItem
giveItemEvent:FireServer("Legendary Sword")

-- ✅ GOOD: Server checks if player earned it
-- Server Script
giveItemEvent.OnServerEvent:Connect(function(player, itemName)
    -- Check if player actually earned it
    if not player:GetAttribute("CompletedQuest") then
        warn(player.Name .. " tried to get item without quest!")
        return
    end
    
    -- Give item
    local item = game.ServerStorage.Items:FindFirstChild(itemName)
    if item then
        item:Clone().Parent = player.Backpack
    end
end)


-- RATE LIMITING (Prevent spam)
local rateLimits = {}
local COOLDOWN = 1  -- 1 second cooldown

remoteEvent.OnServerEvent:Connect(function(player)
    local lastUse = rateLimits[player]
    local now = tick()
    
    if lastUse and (now - lastUse) < COOLDOWN then
        warn(player.Name .. " is spamming!")
        return
    end
    
    rateLimits[player] = now
    
    -- Do the action
end)


-- ============================================================================
-- SECTION 2: COMMON MISTAKES & FIXES
-- ============================================================================

-- MISTAKE 1: Infinite loops without wait
--[[
❌ BAD:
while true do
    print("This crashes the game!")
end

✅ GOOD:
while true do
    print("This works!")
    task.wait(1)
end
]]--


-- MISTAKE 2: Not checking if objects exist
--[[
❌ BAD:
workspace.MyPart.Transparency = 1  -- Error if doesn't exist!

✅ GOOD:
local part = workspace:FindFirstChild("MyPart")
if part then
    part.Transparency = 1
end
]]--


-- MISTAKE 3: Memory leaks from connections
--[[
❌ BAD:
RunService.Heartbeat:Connect(function()
    part.Touched:Connect(function()  -- New connection every frame!
        print("Touched!")
    end)
end)

✅ GOOD:
local connection = part.Touched:Connect(function()
    print("Touched!")
end)

-- Disconnect when done
connection:Disconnect()
]]--


-- MISTAKE 4: Using global variables
--[[
❌ BAD:
myVariable = "I'm global!"  -- Can be accessed/changed anywhere

✅ GOOD:
local myVariable = "I'm local!"  -- Scoped properly
]]--


-- MISTAKE 5: Not using task.wait()
--[[
❌ BAD:
wait(1)  -- Minimum 1/30 second delay

✅ GOOD:
task.wait(1)  -- More accurate, faster
]]--


-- MISTAKE 6: String concatenation in loops
--[[
❌ BAD:
local str = ""
for i = 1, 1000 do
    str = str .. i  -- Creates new string each time (slow!)
end

✅ GOOD:
local parts = {}
for i = 1, 1000 do
    table.insert(parts, i)
end
local str = table.concat(parts)
]]--


-- ============================================================================
-- SECTION 3: DEBUGGING TECHNIQUES
-- ============================================================================

-- PRINT DEBUGGING
print("Value:", myVariable)
print("Type:", type(myVariable))
print("Table contents:")
for k, v in pairs(myTable) do
    print(k, "=", v)
end


-- WARN & ERROR
warn("This is a warning!")  -- Yellow text
error("This stops the script!")  -- Red text


-- ASSERT (Error if condition is false)
local player = game.Players:FindFirstChild("Bob")
assert(player, "Player Bob not found!")  -- Errors with message if nil


-- DEBUG LIBRARY
print(debug.traceback())  -- Show call stack

local function myFunction()
    print("Called from:", debug.info(2, "n"))
end


-- VISUAL DEBUGGING (Draw in 3D space)
local function drawRay(origin, direction, color)
    local ray = Instance.new("Part")
    ray.Anchored = true
    ray.CanCollide = false
    ray.Size = Vector3.new(0.2, 0.2, direction.Magnitude)
    ray.CFrame = CFrame.new(origin, origin + direction) * CFrame.new(0, 0, -direction.Magnitude/2)
    ray.Color = color or Color3.fromRGB(255, 0, 0)
    ray.Material = Enum.Material.Neon
    ray.Parent = workspace
    
    game:GetService("Debris"):AddItem(ray, 5)
end

-- Usage
drawRay(Vector3.new(0, 10, 0), Vector3.new(0, 0, 50), Color3.fromRGB(0, 255, 0))


-- OUTPUT FORMATTING
local function prettyPrint(t, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)
    
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(spacing .. tostring(k) .. " = {")
            prettyPrint(v, indent + 1)
            print(spacing .. "}")
        else
            print(spacing .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

local data = {name = "Bob", stats = {health = 100, level = 5}}
prettyPrint(data)


-- PERFORMANCE PROFILING
local startTime = tick()

-- Code to test
for i = 1, 100000 do
    local x = i * 2
end

local endTime = tick()
print("Execution time:", (endTime - startTime) * 1000, "ms")


-- ============================================================================
-- SECTION 4: CODE ORGANIZATION
-- ============================================================================

--[[
FOLDER STRUCTURE:

ReplicatedStorage
├── Modules
│   ├── WeaponModule
│   ├── InventoryModule
│   └── UtilityModule
├── RemoteEvents
│   ├── DamageEvent
│   └── PurchaseEvent
└── Assets
    ├── Sounds
    └── UI

ServerStorage
├── Modules (server-only)
├── Items
└── AdminTools

ServerScriptService
├── Systems
│   ├── DataStore
│   ├── Combat
│   └── Shop
└── Main (init script)
]]--


-- GOOD CODE STRUCTURE EXAMPLE
local MySystem = {}
MySystem.__index = MySystem

-- Private variables
local activePlayers = {}
local settings = {
    maxPlayers = 20,
    roundTime = 300
}

-- Private functions
local function validatePlayer(player)
    return player and player.Parent
end

local function cleanup()
    activePlayers = {}
end

-- Public functions
function MySystem.Init()
    print("System initialized")
end

function MySystem.AddPlayer(player)
    if not validatePlayer(player) then return false end
    
    activePlayers[player] = {
        joinTime = tick(),
        score = 0
    }
    
    return true
end

function MySystem.GetPlayerData(player)
    return activePlayers[player]
end

return MySystem


-- ============================================================================
-- SECTION 5: NAMING CONVENTIONS
-- ============================================================================

--[[
NAMING STANDARDS:

Variables:
✅ camelCase: local playerHealth = 100
✅ lowercase: local speed = 16

Functions:
✅ camelCase: local function calculateDamage()
✅ PascalCase: local function GetPlayerData()

Constants:
✅ UPPER_SNAKE_CASE: local MAX_HEALTH = 100

Classes/Modules:
✅ PascalCase: local WeaponSystem = {}

Instances:
✅ PascalCase: local MyPart = Instance.new("Part")

Private functions:
✅ _underscore prefix: local function _privateHelper()
]]--

-- GOOD NAMING EXAMPLES
local MAX_PLAYERS = 50  -- Constant
local playerHealth = 100  -- Variable
local isGameActive = true  -- Boolean

local function calculateDamage(weapon, target)  -- Function
    return weapon.damage * target.resistance
end

local WeaponClass = {}  -- Class
local DataManager = {}  -- Module


-- ============================================================================
-- SECTION 6: COMMENTS & DOCUMENTATION
-- ============================================================================

--[[
GOOD DOCUMENTATION EXAMPLE:
]]--

--- Calculates damage dealt to a target
-- @param attacker Player - The player dealing damage
-- @param target Player - The player receiving damage  
-- @param weapon Tool - The weapon being used
-- @return number - Final damage amount
local function calculateDamage(attacker, target, weapon)
    local baseDamage = weapon:GetAttribute("Damage") or 10
    local levelMultiplier = attacker.Level.Value * 0.1
    local armorReduction = target.Armor.Value * 0.5
    
    return math.max(1, baseDamage * (1 + levelMultiplier) - armorReduction)
end


-- SECTION COMMENTS
-- ============================================================================
-- SECTION: PLAYER MANAGEMENT
-- ============================================================================


-- TODO COMMENTS
-- TODO: Add cooldown system
-- FIXME: This breaks with large numbers
-- HACK: Temporary fix, needs refactoring
-- NOTE: This only works on server


-- ============================================================================
-- SECTION 7: OPTIMIZATION TIPS
-- ============================================================================

-- TIP 1: Cache frequently used values
--[[
❌ BAD:
for i = 1, 100 do
    workspace.Folder.Part.Transparency = i/100
end

✅ GOOD:
local part = workspace.Folder.Part
for i = 1, 100 do
    part.Transparency = i/100
end
]]--


-- TIP 2: Use local references for services
--[[
❌ BAD:
game:GetService("Players").PlayerAdded:Connect(...)

✅ GOOD:
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(...)
]]--


-- TIP 3: Limit GetDescendants() usage
--[[
❌ BAD:
RunService.Heartbeat:Connect(function()
    for _, part in pairs(workspace:GetDescendants()) do  -- Runs EVERY frame!
        if part:IsA("Part") then
            part.Color = Color3.fromRGB(255, 0, 0)
        end
    end
end)

✅ GOOD:
local parts = {}
for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("Part") then
        table.insert(parts, part)
    end
end

RunService.Heartbeat:Connect(function()
    for _, part in pairs(parts) do
        part.Color = Color3.fromRGB(255, 0, 0)
    end
end)
]]--


-- TIP 4: Destroy unused connections
local connection = part.Touched:Connect(function()
    print("Touched!")
end)

-- When done
connection:Disconnect()
connection = nil


-- TIP 5: Use Debris service for temporary parts
local Debris = game:GetService("Debris")

local tempPart = Instance.new("Part")
tempPart.Parent = workspace
Debris:AddItem(tempPart, 5)  -- Auto-delete after 5 seconds


-- TIP 6: Batch operations
--[[
❌ BAD:
for i = 1, 100 do
    local part = Instance.new("Part")
    part.Size = Vector3.new(5, 5, 5)
    part.Anchored = true
    part.Parent = workspace  -- Parent set 100 times!
end

✅ GOOD:
local folder = Instance.new("Folder")
for i = 1, 100 do
    local part = Instance.new("Part")
    part.Size = Vector3.new(5, 5, 5)
    part.Anchored = true
    part.Parent = folder  -- Parent to folder first
end
folder.Parent = workspace  -- Only one parent change
]]--


-- TIP 7: Use Region3 for large area checks
-- Instead of checking every player individually


-- ============================================================================
-- SECTION 8: USEFUL UTILITY FUNCTIONS
-- ============================================================================

-- LERP (Linear Interpolation)
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Smooth transition
local start = 0
local finish = 100
for i = 0, 1, 0.1 do
    local current = lerp(start, finish, i)
    print(current)
    task.wait()
end


-- CLAMP (Keep value within range)
local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local health = clamp(damage, 0, 100)  -- Always between 0-100


-- ROUND
local function round(number, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

print(round(3.14159, 2))  -- 3.14


-- RANDOM FROM TABLE
local function randomFromTable(t)
    return t[math.random(1, #t)]
end

local weapons = {"Sword", "Bow", "Staff"}
local randomWeapon = randomFromTable(weapons)


-- SHUFFLE TABLE
local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end


-- DEEP COPY TABLE
local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end


-- FORMAT NUMBER (Add commas)
local function formatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

print(formatNumber(1234567))  -- "1,234,567"


-- FORMAT TIME (Seconds to MM:SS)
local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", mins, secs)
end

print(formatTime(125))  -- "02:05"


-- GET PLAYER FROM CHARACTER
local function getPlayerFromCharacter(character)
    return game.Players:GetPlayerFromCharacter(character)
end


-- RAYCAST TO MOUSE
local function raycastToMouse(player, distance)
    local mouse = player:GetMouse()
    local camera = workspace.CurrentCamera
    
    local origin = camera.CFrame.Position
    local direction = (mouse.Hit.Position - origin).Unit * distance
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {player.Character}
    
    return workspace:Raycast(origin, direction, rayParams)
end


-- ============================================================================
-- SECTION 9: PROFESSIONAL PATTERNS
-- ============================================================================

-- SINGLETON PATTERN (Only one instance)
local GameManager = {}
local instance = nil

function GameManager.GetInstance()
    if not instance then
        instance = {
            gameState = "Lobby",
            roundNumber = 0,
            players = {}
        }
    end
    return instance
end


-- FACTORY PATTERN (Create objects)
local EnemyFactory = {}

function EnemyFactory.CreateEnemy(enemyType)
    if enemyType == "Zombie" then
        return {
            name = "Zombie",
            health = 50,
            speed = 10,
            damage = 5
        }
    elseif enemyType == "Boss" then
        return {
            name = "Boss",
            health = 500,
            speed = 8,
            damage = 25
        }
    end
end

local zombie = EnemyFactory.CreateEnemy("Zombie")


-- OBSERVER PATTERN (Event system)
local EventSystem = {}
EventSystem.listeners = {}

function EventSystem:Subscribe(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
end

function EventSystem:Publish(eventName, ...)
    if self.listeners[eventName] then
        for _, callback in pairs(self.listeners[eventName]) do
            callback(...)
        end
    end
end

-- Usage
EventSystem:Subscribe("PlayerDied", function(player)
    print(player.Name .. " died!")
end)

EventSystem:Publish("PlayerDied", game.Players.LocalPlayer)


-- STATE MACHINE
local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
    local self = setmetatable({}, StateMachine)
    self.currentState = nil
    self.states = {}
    return self
end

function StateMachine:AddState(name, onEnter, onExit, onUpdate)
    self.states[name] = {
        onEnter = onEnter,
        onExit = onExit,
        onUpdate = onUpdate
    }
end

function StateMachine:ChangeState(newState)
    if self.currentState then
        local state = self.states[self.currentState]
        if state and state.onExit then
            state.onExit()
        end
    end
    
    self.currentState = newState
    local state = self.states[newState]
    if state and state.onEnter then
        state.onEnter()
    end
end

function StateMachine:Update()
    if self.currentState then
        local state = self.states[self.currentState]
        if state and state.onUpdate then
            state.onUpdate()
        end
    end
end

-- Usage
local enemyAI = StateMachine.new()
enemyAI:AddState("Idle", 
    function() print("Entering Idle") end,
    function() print("Exiting Idle") end,
    function() print("Updating Idle") end
)
enemyAI:ChangeState("Idle")


-- ============================================================================
-- SECTION 10: TESTING & VALIDATION
-- ============================================================================

-- UNIT TEST EXAMPLE
local function assertEqual(actual, expected, testName)
    if actual == expected then
        print("✅ PASSED:", testName)
        return true
    else
        warn("❌ FAILED:", testName)
        warn("Expected:", expected, "Got:", actual)
        return false
    end
end

-- Test your functions
local function add(a, b)
    return a + b
end

assertEqual(add(2, 3), 5, "Add function test")
assertEqual(add(-1, 1), 0, "Add negative numbers")


-- VALIDATION HELPER
local function validateType(value, expectedType, valueName)
    if type(value) ~= expectedType then
        error(string.format("%s must be a %s, got %s", 
            valueName, expectedType, type(value)))
    end
end

local function giveCoins(player, amount)
    validateType(player, "Instance", "player")
    validateType(amount, "number", "amount")
    
    if amount < 0 then
        error("Amount must be positive")
    end
    
    -- Give coins logic
end


-- ============================================================================
-- SECTION 11: FINAL PRO TIPS
-- ============================================================================

--[[
And Wheeeeew!

1. ALWAYS use 'local' for variables
2. Cache references to improve performance
3. Use task.wait() instead of wait()
4. Never trust the client - validate on server
5. Comment complex logic
6. Use meaningful variable names
7. Break large functions into smaller ones
8. Handle errors with pcall
9. Disconnect unused connections
10. Test your code frequently

THINGS TO AVOID:

1. Global variables
2. Infinite loops without wait()
3. Creating connections in loops
4. Trusting client input
5. Hardcoded values (use variables/constants)
6. Not checking if objects exist
7. Nested callbacks (callback hell)
8. Giant functions (break them up!)
9. Magic numbers (use named constants)
10. Not handling edge cases

 KEEP LEARNING:

1. Read other people's code -- ( if you skidd put credits be like me WHAHAHAHA ) 
2. Join Roblox DevForum
3. Watch YouTube tutorials
4. Build projects (learn by doing!)
5. Ask questions
6. Study successful games
7. Practice daily
8. Read Roblox documentation
9. Experiment with new features
10. Never stop improving!

💡 PROJECT IDEAS TO BUILD:

if your Newwwww WHAAAAAAAAAWHUIII!
- Obby with checkpoints
- Coin collector
- Simple shooter
- Tycoon basics
- GUI shop

Woah
- Inventory system
- Quest system
- Skill cooldown system
- Team deathmatch
- Admin commands

Nick
- RPG with saving
- Battle royale
- Tower defense
- Racing game with tracks
- MMO-style game

YOUR LEARNING PATH:
-- Well if you don't school 
Week 1-2: Master Lua basics
Week 3-4: Learn Roblox objects & events
Week 5-6: Build simple games
Week 7-8: Add GUI and RemoteEvents
Week 9-10: Learn DataStores
Week 11-12: Optimization & polish
Week 13+: Build your dream game!

REMEMBER:
- Everyone starts as a beginner
- Mistakes are how you learn
- Don't give up!
- Ask for help when stuck
- Have fun coding!

YOU GOT THIS MAN WHAAAAAAA!!!!!
]]--


-- ============================================================================
-- CHEAT SHEET: QUICK REFERENCE
-- ============================================================================

--[[
SERVICES:
game:GetService("Players")
game:GetService("Workspace")
game:GetService("ReplicatedStorage")
game:GetService("RunService")
game:GetService("UserInputService")
game:GetService("TweenService")

FINDING OBJECTS:
:WaitForChild("Name")
:FindFirstChild("Name")
:FindFirstChildOfClass("Part")
:GetChildren()
:GetDescendants()

PLAYER:
player.Character
player.Name
player.UserId
player.CharacterAdded:Connect()

CHARACTER:
character:FindFirstChild("HumanoidRootPart")
character:FindFirstChildOfClass("Humanoid")
humanoid.Health
humanoid.WalkSpeed
humanoid:TakeDamage(amount)

PARTS:
part.Position = Vector3.new(x, y, z)
part.Size = Vector3.new(w, h, d)
part.Color = Color3.fromRGB(r, g, b)
part.Transparency = 0.5
part.Anchored = true

EVENTS:
event:Connect(function() end)
event:Fire(args)
event:Wait()

REMOTE EVENTS:
remoteEvent:FireServer(args)  -- Client to Server
remoteEvent:FireClient(player, args)  -- Server to One Client
remoteEvent:FireAllClients(args)  -- Server to All

TWEENING:
local tween = TweenService:Create(object, TweenInfo.new(time), {Property = value})
tween:Play()

INPUT:
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        -- E pressed
    end
end)

MATH:
math.random(min, max)
math.floor(num)
math.ceil(num)
math.abs(num)
math.sqrt(num)

STRINGS:
string.upper(str)
string.lower(str)
string.sub(str, start, end)
string.format("%s %d", text, number)

TABLES:
table.insert(t, value)
table.remove(t, index)
table.concat(t, separator)
#table  -- Get length
]]--


print("\n" .. string.rep("=", 60))
print("well yeah that's it i can't write more in sure this helps you this only i knew for now")
print("You now have put on your Stupd brain HEHEHEHEHE :D")
print("Start building projects :)")
print("Good luck yeah..")
print(string.rep("=", 60))
