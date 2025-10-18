-- REMOTE EVENTS & FUNCTIONS
-- Communication between client and server

-- Put RemoteEvents in ReplicatedStorage so both client and server can access

-- === REMOTE EVENT (one-way communication) ===

-- SERVER SCRIPT (send to client)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

-- Send to ONE player
local player = game.Players:GetPlayers()[1]
remoteEvent:FireClient(player, "Hello", 123, true)

-- Send to ALL players
remoteEvent:FireAllClients("Broadcast message")

-- Receive from client
remoteEvent.OnServerEvent:Connect(function(player, ...)
    print(player.Name .. " sent:", ...)
end)

-- LOCAL SCRIPT (send to server)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

-- Send to server
remoteEvent:FireServer("Hello from client", 456)

-- Receive from server
remoteEvent.OnClientEvent:Connect(function(...)
    print("Server sent:", ...)
end)

-- === REMOTE FUNCTION (two-way with response) ===

-- SERVER SCRIPT
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")

-- Client calls server (client -> server)
remoteFunction.OnServerInvoke = function(player, amount)
    print(player.Name .. " wants to buy something")
    
    -- Return response to client
    if amount >= 100 then
        return true, "Purchase successful"
    else
        return false, "Not enough money"
    end
end

-- LOCAL SCRIPT
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")

-- Call server and wait for response
local success, message = remoteFunction:InvokeServer(150)
print(success, message)

-- Server calls client (server -> client)
remoteFunction.OnClientInvoke = function(data)
    print("Server asked for:", data)
    return "Client response"
end

-- === COMMON PATTERNS ===

-- EXAMPLE 1: Damage system
-- Server Script
local damageEvent = ReplicatedStorage.DamageEvent

damageEvent.OnServerEvent:Connect(function(player, target, damage)
    -- Verify player can damage
    if not canDamage(player) then return end
    
    local targetHumanoid = target:FindFirstChild("Humanoid")
    if targetHumanoid then
        targetHumanoid.Health = targetHumanoid.Health - damage
    end
end)

-- Local Script (when player attacks)
local damageEvent = ReplicatedStorage.DamageEvent
damageEvent:FireServer(targetCharacter, 25)

-- EXAMPLE 2: Buy system
-- Server Script
local buyFunction = ReplicatedStorage.BuyItem

buyFunction.OnServerInvoke = function(player, itemName, price)
    local playerMoney = getMoney(player)
    
    if playerMoney >= price then
        playerMoney = playerMoney - price
        giveItem(player, itemName)
        return true, "Bought " .. itemName
    else
        return false, "Not enough money"
    end
end

-- Local Script (when clicking buy button)
local buyFunction = ReplicatedStorage.BuyItem
local success, msg = buyFunction:InvokeServer("Sword", 100)
print(msg)

-- EXAMPLE 3: Chat command
-- Local Script
local chatEvent = ReplicatedStorage.ChatCommand

game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 1) == "/" then
        local command = message:sub(2)
        chatEvent:FireServer(command)
    end
end)

-- Server Script
local chatEvent = ReplicatedStorage.ChatCommand

chatEvent.OnServerEvent:Connect(function(player, command)
    if command == "heal" then
        player.Character.Humanoid.Health = 100
    elseif command == "speed" then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)

-- SECURITY TIPS
-- NEVER trust the client
-- Always verify on server:
-- - Check if player owns item
-- - Verify positions and distances
-- - Check cooldowns
-- - Validate all data from client
