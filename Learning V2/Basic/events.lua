-- EVENTS
-- How to detect when things happen

-- TOUCHED EVENT (when something touches a part)
local part = workspace.Part

part.Touched:Connect(function(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if humanoid then
        print(hit.Parent.Name .. " touched the part")
    end
end)

-- TOUCH ENDED
part.TouchEnded:Connect(function(hit)
    print("Stopped touching")
end)

-- CHANGED EVENT (when property changes)
local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")

humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    print("Health changed to: " .. humanoid.Health)
end)

-- DIED EVENT
humanoid.Died:Connect(function()
    print("Player died")
end)

-- CHILD ADDED
workspace.ChildAdded:Connect(function(child)
    print("New child added: " .. child.Name)
end)

-- CHILD REMOVED
workspace.ChildRemoved:Connect(function(child)
    print("Child removed: " .. child.Name)
end)

-- PLAYER EVENTS
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    print(player.Name .. " joined the game")
    
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. " spawned")
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    print(player.Name .. " left the game")
end)

-- BUTTON CLICK (GUI)
local button = script.Parent -- assuming script is in button

button.MouseButton1Click:Connect(function()
    print("Button clicked")
end)

-- MOUSE HOVER
button.MouseEnter:Connect(function()
    print("Mouse on button")
end)

button.MouseLeave:Connect(function()
    print("Mouse left button")
end)

-- USER INPUT
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- ignore if typing in chat
    
    if input.KeyCode == Enum.KeyCode.E then
        print("E key pressed")
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        print("Left click")
    end
end)

-- WAIT FOR EVENT (blocks code until event fires)
part.Touched:Wait() -- waits until something touches
print("Something touched!")

-- DISCONNECT EVENT
local connection = part.Touched:Connect(function()
    print("Touched")
end)

-- Later, stop listening to event
connection:Disconnect()

-- RUNSERVICE EVENTS (runs every frame)
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function(deltaTime)
    -- Runs every frame on server
    print("Frame time: " .. deltaTime)
end)

RunService.RenderStepped:Connect(function(deltaTime)
    -- Runs every frame on client (before rendering)
end)

-- WAIT (pause code)
wait(2) -- wait 2 seconds
task.wait(2) -- newer, better version

-- SPAWN (run code without blocking)
task.spawn(function()
    wait(5)
    print("This runs after 5 seconds")
end)

-- DELAY (run code after delay)
task.delay(3, function()
    print("Delayed by 3 seconds")
end)
