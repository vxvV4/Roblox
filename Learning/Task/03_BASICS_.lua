--[[
================================================================================
    ROBLOX INDT 
    File: 03_ROBLOX_INTERMEDIATE.lua
    RemoteEvents, GUI, Input, Tweening, and more!
    maybe you can learn how Remote events works etc..
================================================================================
]]--

-- ============================================================================
-- SECTION 1: REMOTE EVENTS (Client-Server Communication)
-- ============================================================================

--[[
IMPORTANT CONCEPTS:
- Server = One computer running the game (authoritative)
- Client = Each player's device (shows game to player)
- RemoteEvent = Send messages between server and client
- RemoteFunction = Send AND receive response
]]--

-- Create RemoteEvent (put in ReplicatedStorage)
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "DamageEvent"
remoteEvent.Parent = game.ReplicatedStorage


-- SERVER SCRIPT: Listen for client
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("DamageEvent")

remoteEvent.OnServerEvent:Connect(function(player, damageAmount)
    print(player.Name .. " sent damage:", damageAmount)
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:TakeDamage(damageAmount)
        end
    end
end)

-- Send to ALL clients
remoteEvent:FireAllClients("Hello everyone!")

-- Send to ONE client
remoteEvent:FireClient(player, "Just for you!")


-- LOCAL SCRIPT (CLIENT): Send to server
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("DamageEvent")

-- Send message to server
remoteEvent:FireServer(25)  -- Deal 25 damage

-- Listen from server
remoteEvent.OnClientEvent:Connect(function(message)
    print("Server sent:", message)
end)


-- REMOTE FUNCTION (with return value)
local remoteFunction = Instance.new("RemoteFunction")
remoteFunction.Name = "GetPlayerData"
remoteFunction.Parent = ReplicatedStorage

-- SERVER
remoteFunction.OnServerInvoke = function(player)
    return {
        coins = 100,
        level = 5,
        inventory = {"Sword", "Shield"}
    }
end

-- CLIENT
local data = remoteFunction:InvokeServer()
print("Coins:", data.coins)
print("Level:", data.level)


-- ============================================================================
-- SECTION 2: USER INPUT (Keyboard, Mouse, Touch)
-- ============================================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- KEYBOARD INPUT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  -- Ignore if typing in chat
    
    if input.KeyCode == Enum.KeyCode.E then
        print("E key pressed!")
    elseif input.KeyCode == Enum.KeyCode.Space then
        print("Spacebar pressed!")
    elseif input.KeyCode == Enum.KeyCode.W then
        print("W pressed!")
    end
end)

-- Key released
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.E then
        print("E key released!")
    end
end)

-- Check if key is currently held down
if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
    print("Shift is being held!")
end


-- MOUSE INPUT
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        print("Left mouse button clicked!")
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        print("Right mouse button clicked!")
    end
end)


-- MOUSE POSITION & TARGET
local mouse = player:GetMouse()

-- Mouse position on screen
print("Mouse X:", mouse.X, "Y:", mouse.Y)

-- What the mouse is pointing at
print("Mouse target:", mouse.Target)

-- Mouse moved
mouse.Move:Connect(function()
    local target = mouse.Target
    if target then
        print("Hovering over:", target.Name)
    end
end)

-- Mouse click
mouse.Button1Down:Connect(function()
    print("Mouse clicked at:", mouse.Hit.Position)
end)


-- ============================================================================
-- SECTION 3: GUI CREATION (User Interface)
-- ============================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui (container for all UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyGui"
screenGui.Parent = playerGui


-- CREATE FRAME (background box)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 400, 0, 300)  -- Width 400px, Height 300px
frame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Centered
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui


-- CREATE TEXT LABEL
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)  -- Full width, 50px height
titleLabel.Position = UDim2.new(0, 0, 0, 0)  -- Top of frame
titleLabel.Text = "Welcome to My Game!"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1  -- Invisible background
titleLabel.Parent = frame


-- CREATE BUTTON
local button = Instance.new("TextButton")
button.Name = "PlayButton"
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)  -- Centered
button.Text = "Click Me!"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 20
button.Font = Enum.Font.Gotham
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.BorderSizePixel = 0
button.Parent = frame

-- Button click event
button.MouseButton1Click:Connect(function()
    print("Button clicked!")
    button.Text = "Clicked!"
end)

-- Button hover effects
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)  -- Lighter
end)

button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)  -- Original
end)


-- CREATE IMAGE LABEL
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 100, 0, 100)
imageLabel.Position = UDim2.new(0, 10, 0, 60)
imageLabel.Image = "rbxassetid://123456789"  -- Replace with real asset ID
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = frame


-- CREATE TEXT BOX (input field)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 40)
textBox.Position = UDim2.new(0.5, -100, 0, 200)
textBox.PlaceholderText = "Enter your name..."
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 18
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.Parent = frame

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        print("User entered:", textBox.Text)
    end
end)


-- UDIM2 EXPLAINED
--[[
UDim2.new(ScaleX, OffsetX, ScaleY, OffsetY)

Scale: Percentage of parent (0 to 1)
Offset: Exact pixels

Examples:
UDim2.new(1, 0, 1, 0)      -- Full size
UDim2.new(0.5, 0, 0.5, 0)  -- Half size
UDim2.new(0, 100, 0, 50)   -- 100x50 pixels
UDim2.new(0.5, -50, 0.5, -50)  -- Centered
]]--


-- ============================================================================
-- SECTION 4: TWEENING (Smooth Animations)
-- ============================================================================

local TweenService = game:GetService("TweenService")
local part = workspace.MyPart

-- Create TweenInfo
local tweenInfo = TweenInfo.new(
    2,                              -- Duration (seconds)
    Enum.EasingStyle.Quad,          -- Style (how it moves)
    Enum.EasingDirection.Out,       -- Direction
    0,                              -- Repeat count (0=once, -1=forever)
    false,                          -- Reverse?
    0                               -- Delay before starting
)

-- Goal (what properties to change)
local goal = {
    Position = Vector3.new(0, 50, 0),
    Transparency = 0.5,
    Color = Color3.fromRGB(255, 0, 0),
    Size = Vector3.new(10, 10, 10)
}

-- Create and play tween
local tween = TweenService:Create(part, tweenInfo, goal)
tween:Play()

-- Tween events
tween.Completed:Connect(function(playbackState)
    print("Tween finished!")
    if playbackState == Enum.PlaybackState.Completed then
        print("Completed normally")
    end
end)

-- Control tween
tween:Pause()   -- Pause
tween:Play()    -- Resume
tween:Cancel()  -- Stop and reset


-- EASING STYLES
--[[
Common EasingStyles:
- Linear: Constant speed
- Quad: Gentle acceleration
- Cubic: More acceleration
- Quart: Strong acceleration
- Bounce: Bouncy effect
- Elastic: Springy effect
- Sine: Smooth sine wave

EasingDirection:
- In: Starts slow
- Out: Ends slow
- InOut: Slow at both ends
]]--


-- Tween GUI example
local frame = playerGui.MyGui.Frame
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local goal = {Position = UDim2.new(0.5, -200, 0.5, -150)}
local tween = TweenService:Create(frame, tweenInfo, goal)
tween:Play()


-- ============================================================================
-- SECTION 5: RUNSERVICE (Game Loop)
-- ============================================================================

local RunService = game:GetService("RunService")

-- Heartbeat (runs every frame BEFORE physics)
RunService.Heartbeat:Connect(function(deltaTime)
    -- deltaTime = time since last frame
    -- Runs ~60 times per second
end)

-- RenderStepped (CLIENT ONLY - before rendering)
RunService.RenderStepped:Connect(function(deltaTime)
    -- Best for camera updates
    -- Best for visual effects
end)

-- Stepped (AFTER physics simulation)
RunService.Stepped:Connect(function(time, deltaTime)
    -- time = total elapsed time
    -- deltaTime = time since last frame
end)


-- Example: Rotating part
local part = workspace.SpinningPart
RunService.Heartbeat:Connect(function(deltaTime)
    part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(1), 0)
end)


-- Check if server or client
if RunService:IsServer() then
    print("This is SERVER code")
elseif RunService:IsClient() then
    print("This is CLIENT code")
end

if RunService:IsStudio() then
    print("Running in Roblox Studio")
end


-- ============================================================================
-- SECTION 6: RAYCASTING (Shooting, Line of Sight)
-- ============================================================================

local character = player.Character
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Create ray parameters
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {character}  -- Ignore player

-- Cast ray
local origin = rootPart.Position
local direction = rootPart.CFrame.LookVector * 100  -- 100 studs forward

local result = workspace:Raycast(origin, direction, rayParams)

if result then
    print("Hit:", result.Instance.Name)
    print("Position:", result.Position)
    print("Distance:", result.Distance)
    print("Normal:", result.Normal)
    
    -- Visualize hit point
    local hitPart = Instance.new("Part")
    hitPart.Size = Vector3.new(1, 1, 1)
    hitPart.Position = result.Position
    hitPart.Anchored = true
    hitPart.CanCollide = false
    hitPart.Material = Enum.Material.Neon
    hitPart.Color = Color3.fromRGB(255, 0, 0)
    hitPart.Parent = workspace
    
    game:GetService("Debris"):AddItem(hitPart, 1)
else
    print("Nothing hit")
end


-- Raycast from mouse
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    local origin = camera.CFrame.Position
    local direction = (mouse.Hit.Position - origin).Unit * 500
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        print("Shot hit:", result.Instance.Name)
    end
end)


-- ============================================================================
-- SECTION 7: MAGNITUDE (Distance Checking)
-- ============================================================================

local player1 = game.Players.LocalPlayer
local player2 = game.Players:FindFirstChild("OtherPlayer")

if player1.Character and player2 and player2.Character then
    local pos1 = player1.Character.HumanoidRootPart.Position
    local pos2 = player2.Character.HumanoidRootPart.Position
    
    local distance = (pos1 - pos2).Magnitude
    
    if distance < 10 then
        print("Players are close!")
    elseif distance < 50 then
        print("Players are nearby")
    else
        print("Players are far apart")
    end
end


-- Find closest player
local function findClosestPlayer(myPosition)
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherPos = otherPlayer.Character.HumanoidRootPart.Position
            local distance = (myPosition - otherPos).Magnitude
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer, closestDistance
end


-- ============================================================================
-- SECTION 8: CAMERA MANIPULATION
-- ============================================================================

local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- Set camera to custom mode
camera.CameraType = Enum.CameraType.Scriptable

-- Position camera
camera.CFrame = CFrame.new(0, 50, 0) * CFrame.lookAt(Vector3.new(0, 50, 0), Vector3.new(0, 0, 0))

-- Follow part
local partToFollow = workspace.TargetPart
RunService.RenderStepped:Connect(function()
    camera.CFrame = CFrame.new(partToFollow.Position + Vector3.new(0, 10, 10), partToFollow.Position)
end)

-- Reset camera
camera.CameraType = Enum.CameraType.Custom


-- Shake camera
local function shakeCamera(intensity, duration)
    local initialCFrame = camera.CFrame
    local elapsed = 0
    
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        elapsed = elapsed + dt
        
        if elapsed >= duration then
            connection:Disconnect()
            camera.CFrame = initialCFrame
            return
        end
        
        local shake = Vector3.new(
            math.random(-intensity, intensity),
            math.random(-intensity, intensity),
            math.random(-intensity, intensity)
        )
        
        camera.CFrame = initialCFrame * CFrame.new(shake)
    end)
end

-- Use it
shakeCamera(0.5, 0.3)


-- ============================================================================
-- SECTION 9: SOUNDS
-- ============================================================================

-- Create sound
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://123456789"  -- Replace with real ID
sound.Volume = 0.5
sound.Looped = false
sound.Parent = workspace

-- Play sound
sound:Play()

-- Stop sound
sound:Stop()

-- Sound events
sound.Ended:Connect(function()
    print("Sound finished playing")
end)


-- Play sound at position (3D audio)
local soundPart = Instance.new("Part")
soundPart.Position = Vector3.new(0, 10, 0)
soundPart.Anchored = true
soundPart.Transparency = 1
soundPart.CanCollide = false
soundPart.Parent = workspace

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://123456789"
sound.Parent = soundPart
sound:Play()


-- ============================================================================
-- SECTION 10: CONTEXT ACTION SERVICE (Mobile Buttons)
-- ============================================================================

local ContextActionService = game:GetService("ContextActionService")

-- Create mobile button
local function handleAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        print("Jump button pressed!")
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Jump = true
        end
    end
end

-- Bind action
ContextActionService:BindAction(
    "JumpAction",  -- Name
    handleAction,  -- Function
    true,          -- Create mobile button?
    Enum.KeyCode.Space  -- PC key
)

-- Unbind action
ContextActionService:UnbindAction("JumpAction")


-- ============================================================================
-- PRACTICE PROJECTS
-- ============================================================================

--[[
BUILD THESE TO PRACTICE:

1. Shop System with GUI
   - Show coins on screen
   - Buy button that costs coins
   - Update coins when purchased

2. Kill Feed
   - Show who killed who
   - Display in top-right corner
   - Fade out after 5 seconds

3. Proximity Prompt Alternative
   - Show "Press E to interact" when near object
   - Do action when E is pressed

4. Simple Gun
   - Raycast from camera
   - Show bullet trail
   - Deal damage on hit

5. Dash Ability
   - Press Q to dash forward
   - 3 second cooldown
   - Show cooldown on GUI

6. Health Bar
   - Show health above player head
   - Update when damaged
   - Turn red when low

7. Teleport Pad
   - Step on pad
   - Show countdown GUI
   - Teleport after 3 seconds

8. Coin Collection System
   - Coins spawn randomly
   - Collect on touch
   - Show total on GUI
]]--


print("\n✅ You've completed ROBLOX INTERMEDIATE! Now move to 04_ROBLOX_ADVANCED.lua")
