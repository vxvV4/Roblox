-- 99 Nights in the Forest Script - COMPLETE CONVERSION
-- Load the FIXED library (use your merged Part 1 + Part 2 code)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/99%20Nights%20Stuff/Library.lua"))()

-- Services and variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local workspaceItems = workspace:WaitForChild("Items")

-- Script variables
local showCoordinates = false
local espEnabled = false
local currentFOV = 70
local coordinatesGui = nil
local espFolder = nil
local autoBringEnabled = false
local autoGrindersEnabled = false
local autoCampfireEnabled = false
local autoCookFoodEnabled = false
local killAuraEnabled = false
local autoPlantEnabled = false
local autoOpenChestsEnabled = true
local farmLogActive = false
local farmLogTimer = 0
local chestRange = 50
local bringDelay = 0.1
local maxItemsPerFrame = 3
local isProcessing = false
local campfirePosition = Vector3.new(0.5, 8.0, -0.3)
local originalFogEnd = Lighting.FogEnd
local originalWalkSpeed = 16
local originalJumpPower = 50
local rescuedKids = {}

-- Enhanced grinder positions
local grindPositions = {
    Vector3.new(20.8, 6.3, -5.2),
    Vector3.new(22, 6.3, -5.2),
    Vector3.new(19, 6.3, -5.2),
    Vector3.new(20.8, 6.3, -3),
}

-- Item categories - COMPLETE LISTS
local allFoodItems = {
    "Apple", "Berry", "Cake", "Carrot", "Cooked Morsel", "Cooked Steak", 
    "Hearty Stew", "Morsel", "Pepper", "Steak", "Stew", "Fish", "Bread", 
    "Mushroom", "Rabbit", "Cooked Fish", "Raw Fish", "Meat", "Cooked Meat"
}

local cookableFoods = {
    "Morsel", "Steak", "Fish", "Raw Fish", "Meat", "Rabbit"
}

local fuelItems = {
    "Coal", "Log", "Chair", "Oil Barrel", "Fuel Canister", "Matches", "Lighter"
}

local grindableItems = {
    "Bolt", "Sheet Metal", "Scrap", "Metal Chair", "Car Engine", 
    "Old Car Engine", "Tyre", "Broken Fan", "Broken Microwave", 
    "Broken Radio", "Old Radio", "Washing Machine", "UFO Scrap", 
    "UFO Junk", "UFO Component", "Log", "Cultist Experiment",
    "Cultist Prototype", "Pipe", "Wire", "Battery", "Circuit", "Gear", "Spring"
}

local cultistItems = {
    "Crossbow Cultist", "Cultist", "Cultist Experiment", 
    "Cultist Prototype", "Cultist Gem", "Mega Cultist"
}

local seedItems = {
    "Berry Seed Packs", "Firefly Seed Packs", 
    "Flower Seed Packs", "Chili Seed Packs"
}

local flashlightItems = {"Old Flashlight", "Strong Flashlight"}

local toolsItems = {
    "Chainsaw", "Giant Sack", "Good Axe", "Good Sack", 
    "Old Axe", "Old Sack", "Strong Axe", "Hammer", 
    "Pickaxe", "Shovel", "Knife"
}

local meleeWeapons = {
    "Katana", "Morningstar", "Spear", "Inferno Sword"
}

local rangedWeapons = {
    "Revolver", "Rifle", "Tactical Shotgun", "Crossbow"
}

local ammoItems = {
    "Revolver Ammo", "Rifle Ammo", "Shotgun Ammo"
}

local armorItems = {
    "Iron Armor", "Iron Body", "Leather Armor", "Leather Body",
    "Riot Shield", "Thorn Armor", "Thorn Body", "Poison Armor",
    "Poison Armour", "Alien Armor", "Alien Armour"
}

local corpseFuelItems = {
    "Alpha Wolf Corpse", "Bear Corpse", "Wolf Corpse", 
    "Biofuel", "Chair", "Coal", "Fuel Canister", "Oil Barrel", "Log"
}

local materialsItems = {
    "Bolt", "Broken Fan", "Broken Microwave", "Broken Radio",
    "Car Engine", "Old Car Engine", "Metal Chair", "Sheet Metal",
    "Tyre", "Washing Machine", "Old Radio", "UFO Scrap",
    "UFO Junk", "UFO Component", "Scrap", "Pipe", "Wire",
    "Battery", "Circuit", "Spring", "Volcanic Rock", "Lava Crystal", "Sulfur"
}

local animalParts = {
    "Alpha Wolf Pelt", "Bear Pelt", "Rabbit Foot", "Wolf Pelt"
}

local medicalItems = {
    "Bandage", "Medkit", "Wildfire Potion"
}

local containerItems = {
    "Barrel", "Crate", "Box", "Container", "Infernal Sack"
}

-- Anti-AFK function
local function antiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Core functions
local function startDrag(item)
    pcall(function()
        ReplicatedStorage.RemoteEvents.RequestStartDraggingItem:FireServer(item)
    end)
end

local function stopDrag(item)
    pcall(function()
        ReplicatedStorage.RemoteEvents.StopDraggingItem:FireServer(item)
    end)
end

-- Auto Plant function
local function autoPlant()
    if not autoPlantEnabled then return end
    
    local leftLegPos = hrp.Position + Vector3.new(-1, -3, 0)
    local rightLegPos = hrp.Position + Vector3.new(1, -3, 0)
    local plantPos = math.random() > 0.5 and leftLegPos or rightLegPos
    
    pcall(function()
        local args = {
            Instance.new("Model", nil),
            plantPos
        }
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
    end)
end

-- Smart Lost Child Finding
local function findSmartLostChild()
    local chars = workspace:FindFirstChild("Characters")
    if chars then
        for _, kid in pairs(chars:GetChildren()) do
            if kid:IsA("Model") and (kid.Name:lower():find("lost") or kid.Name:lower():find("child") or kid.Name:lower():find("kid")) then
                local kidId = kid.Name .. "_" .. tostring(kid:GetDebugId())
                
                if not rescuedKids[kidId] then
                    if kid:FindFirstChild("HumanoidRootPart") then
                        rescuedKids[kidId] = true
                        return kid.HumanoidRootPart.Position
                    elseif kid.PrimaryPart then
                        rescuedKids[kidId] = true
                        return kid.PrimaryPart.Position
                    end
                end
            end
        end
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("lost") or obj.Name:lower():find("child") or obj.Name:lower():find("kid")) then
            local kidId = obj.Name .. "_" .. tostring(obj:GetDebugId())
            
            if not rescuedKids[kidId] then
                if obj:FindFirstChild("HumanoidRootPart") then
                    rescuedKids[kidId] = true
                    return obj.HumanoidRootPart.Position
                elseif obj.PrimaryPart then
                    rescuedKids[kidId] = true
                    return obj.PrimaryPart.Position
                end
            end
        end
    end
    
    return nil
end

-- Farm Log function
local function farmLog20Seconds()
    if farmLogActive then return end
    
    farmLogActive = true
    farmLogTimer = 20
    
    spawn(function()
        local smallTreesFound = 0
        local targetTrees = 20
        
        local function searchForSmallTrees(parent)
            for _, item in ipairs(parent:GetChildren()) do
                if smallTreesFound >= targetTrees then break end
                
                if item.Name == "Small Tree" then
                    local targetPart = nil
                    
                    if item:IsA("Model") then
                        if item.PrimaryPart then
                            targetPart = item.PrimaryPart
                        else
                            for _, child in ipairs(item:GetDescendants()) do
                                if child:IsA("Part") or child:IsA("MeshPart") then
                                    targetPart = child
                                    break
                                end
                            end
                        end
                    elseif item:IsA("Part") or item:IsA("MeshPart") then
                        targetPart = item
                    end
                    
                    if targetPart then
                        local dropPos = hrp.Position + Vector3.new(
                            math.random(-3, 3), 
                            2,
                            math.random(-3, 3)
                        )
                        
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(dropPos))
                            elseif targetPart then
                                targetPart.CFrame = CFrame.new(dropPos)
                                targetPart.Position = dropPos
                            end
                        end)
                        
                        pcall(function()
                            startDrag(item)
                            wait(0.1)
                            stopDrag(item)
                        end)
                        
                        smallTreesFound = smallTreesFound + 1
                        wait(0.2)
                    end
                end
                
                if item:IsA("Folder") or item:IsA("Model") then
                    searchForSmallTrees(item)
                end
            end
        end
        
        searchForSmallTrees(workspace)
        
        if smallTreesFound < targetTrees then
            for _, item in ipairs(workspaceItems:GetChildren()) do
                if smallTreesFound >= targetTrees then break end
                
                if item.Name == "Wood" or item.Name == "Log" then
                    local targetPart = nil
                    
                    if item:IsA("Model") then
                        if item.PrimaryPart then
                            targetPart = item.PrimaryPart
                        else
                            for _, child in ipairs(item:GetDescendants()) do
                                if child:IsA("Part") or child:IsA("MeshPart") then
                                    targetPart = child
                                    break
                                end
                            end
                        end
                    elseif item:IsA("Part") or item:IsA("MeshPart") then
                        targetPart = item
                    end
                    
                    if targetPart then
                        local dropPos = hrp.Position + Vector3.new(
                            math.random(-3, 3), 
                            2,
                            math.random(-3, 3)
                        )
                        
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(dropPos))
                            else
                                targetPart.CFrame = CFrame.new(dropPos)
                                targetPart.Position = dropPos
                            end
                        end)
                        
                        pcall(function()
                            startDrag(item)
                            wait(0.1)
                            stopDrag(item)
                        end)
                        
                        smallTreesFound = smallTreesFound + 1
                        wait(0.2)
                    end
                end
            end
        end
    end)
    
    spawn(function()
        while farmLogTimer > 0 and farmLogActive do
            wait(1)
            farmLogTimer = farmLogTimer - 1
        end
        
        if farmLogActive then
            if hrp then
                pcall(function()
                    hrp.CFrame = CFrame.new(campfirePosition + Vector3.new(0, 5, 0))
                end)
            end
        end
        
        farmLogActive = false
    end)
end

-- Out Build function
local function outBuild()
    spawn(function()
        pcall(function()
            local args = {
                "FireAllClients",
                Instance.new("Model", nil)
            }
            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("EquipItemHandle"):FireServer(unpack(args))
        end)
        
        wait(1)
        
        local builds = {
            {
                cframe = CFrame.new(15.795425415039062, 5.4606242179870605, 26.283519744873047, 0.8064058423042297, 0, 0.5913625359535217, 0, 1, 0, -0.5913625359535217, 0, 0.8064058423042297),
                position = Vector3.new(15.795425415039062, 0.9606242179870605, 26.283519744873047),
                rotation = CFrame.new(0, 0, 0, 0.8064058423042297, 0, 0.5913625359535217, 0, 1, 0, -0.5913625359535217, 0, 0.8064058423042297)
            },
            {
                cframe = CFrame.new(5.438966751098633, 5.4606242179870605, 31.235794067382812, 0.9908662438392639, 0, 0.13484829664230347, 0, 1, 0, -0.13484829664230347, 0, 0.9908662438392639),
                position = Vector3.new(5.438966751098633, 0.9606242179870605, 31.235794067382812),
                rotation = CFrame.new(0, 0, 0, 0.9908662438392639, 0, 0.13484829664230347, 0, 1, 0, -0.13484829664230347, 0, 0.9908662438392639)
            },
            {
                cframe = CFrame.new(-6.363698482513428, 5.4606242179870605, 30.34702491760254, 0.9584082961082458, 0, -0.2854006588459015, 0, 1, 0, 0.2854006588459015, 0, 0.9584082961082458),
                position = Vector3.new(-6.363698482513428, 0.9606242179870605, 30.34702491760254),
                rotation = CFrame.new(0, 0, 0, 0.9584082961082458, 0, -0.2854006588459015, 0, 1, 0, 0.2854006588459015, 0, 0.9584082961082458)
            },
            {
                cframe = CFrame.new(-16.738080978393555, 5.4606242179870605, 26.39202880859375, 0.8259918093681335, 0, -0.5636822581291199, 0, 1.0000001192092896, 0, 0.5636823177337646, 0, 0.825991690158844),
                position = Vector3.new(-16.738080978393555, 0.9606242179870605, 26.39202880859375),
                rotation = CFrame.new(0, 0, 0, 0.8259918093681335, 0, -0.5636822581291199, 0, 1.0000001192092896, 0, 0.5636823177337646, 0, 0.825991690158844)
            },
            {
                cframe = CFrame.new(24.503076553344727, 5.469470977783203, 18.115869522094727, 0.5435669422149658, 0, 0.8393658399581909, 0, 1, 0, -0.8393658399581909, 0, 0.5435669422149658),
                position = Vector3.new(24.503076553344727, 0.9694709777832031, 18.115869522094727),
                rotation = CFrame.new(0, 0, 0, 0.5435669422149658, 0, 0.8393658399581909, 0, 1, 0, -0.8393658399581909, 0, 0.5435669422149658)
            }
        }
        
        local successCount = 0
        
        for i, build in ipairs(builds) do
            local success = pcall(function()
                local args = {
                    Instance.new("Model", nil),
                    {
                        Valid = true,
                        CFrame = build.cframe,
                        Position = build.position
                    },
                    build.rotation
                }
                ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlaceStructure"):InvokeServer(unpack(args))
            end)
            
            if success then
                successCount = successCount + 1
            end
            
            wait(0.2)
        end
        
        pcall(function()
            local args = {
                "FireAllClients",
                Instance.new("Model", nil)
            }
            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UnequipItemHandle"):FireServer(unpack(args))
        end)
    end)
end

local function bringItemsToPlayer(itemsToFind)
    if isProcessing then return end
    isProcessing = true
    
    spawn(function()
        local itemsToProcess = {}
        
        for _, item in ipairs(workspaceItems:GetChildren()) do
            if not item.Name:find("Chest") then
                local shouldInclude = false
                
                if #itemsToFind == 0 then
                    shouldInclude = true
                else
                    for _, targetItem in ipairs(itemsToFind) do
                        local itemNameLower = item.Name:lower()
                        local targetLower = targetItem:lower()
                        
                        if itemNameLower:find(targetLower) or targetLower:find(itemNameLower) then
                            shouldInclude = true
                            break
                        end
                        
                        if item.Name:find(targetItem) or targetItem:find(item.Name) then
                            shouldInclude = true
                            break
                        end
                    end
                end
                
                if shouldInclude then
                    table.insert(itemsToProcess, item)
                end
            end
        end
        
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart
                    for _, child in ipairs(item:GetDescendants()) do
                        if child:IsA("MeshPart") or child:IsA("Part") then
                            targetPart = child
                            break
                        end
                    end
                    
                    if targetPart then
                        local dropPos = hrp.Position + Vector3.new(math.random(-3,3), 3, math.random(-3,3))
                        
                        if item:IsA("Model") and item.PrimaryPart then
                            item:SetPrimaryPartCFrame(CFrame.new(dropPos))
                        else
                            targetPart.Position = dropPos
                        end
                    end
                    table.insert(batch, item)
                end
            end
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    startDrag(item)
                end
            end
            
            task.wait(bringDelay)
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    stopDrag(item)
                end
            end
            
            task.wait(0.02)
        end
        
        isProcessing = false
    end)
end

local function bringItemsToCampfire(itemsToFind)
    if isProcessing then return end
    isProcessing = true
    
    spawn(function()
        local itemsToProcess = {}
        
        for _, item in ipairs(workspaceItems:GetChildren()) do
            if not item.Name:find("Chest") then
                local shouldInclude = false
                
                for _, targetItem in ipairs(itemsToFind) do
                    local itemNameLower = item.Name:lower()
                    local targetLower = targetItem:lower()
                    
                    if itemNameLower:find(targetLower) or targetLower:find(itemNameLower) then
                        shouldInclude = true
                        break
                    end
                    
                    if item.Name:find(targetItem) or targetItem:find(item.Name) then
                        shouldInclude = true
                        break
                    end
                end
                
                if shouldInclude then
                    table.insert(itemsToProcess, item)
                end
            end
        end
        
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart
                    for _, child in ipairs(item:GetDescendants()) do
                        if child:IsA("MeshPart") or child:IsA("Part") then
                            targetPart = child
                            break
                        end
                    end
                    
                    if targetPart then
                        local randomOffset = Vector3.new(
                            math.random(-1, 1),
                            math.random(0, 2),
                            math.random(-1, 1)
                        )
                        local finalPos = campfirePosition + randomOffset
                        
                        if item:IsA("Model") and item.PrimaryPart then
                            item:SetPrimaryPartCFrame(CFrame.new(finalPos))
                        else
                            targetPart.Position = finalPos
                        end
                    end
                    table.insert(batch, item)
                end
            end
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    startDrag(item)
                end
            end
            
            task.wait(bringDelay)
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    stopDrag(item)
                end
            end
            
            task.wait(0.02)
        end
        
        isProcessing = false
    end)
end

local function bringItemsToGrinder(itemsToFind)
    if isProcessing then return end
    isProcessing = true
    
    spawn(function()
        local itemsToProcess = {}
        
        for _, item in ipairs(workspaceItems:GetChildren()) do
            if not item.Name:find("Chest") then
                local shouldInclude = false
                
                for _, targetItem in ipairs(itemsToFind) do
                    local itemNameLower = item.Name:lower()
                    local targetLower = targetItem:lower()
                    
                    if itemNameLower:find(targetLower) or targetLower:find(itemNameLower) then
                        shouldInclude = true
                        break
                    end
                    
                    if item.Name:find(targetItem) or targetItem:find(item.Name) then
                        shouldInclude = true
                        break
                    end
                end
                
                if shouldInclude then
                    table.insert(itemsToProcess, item)
                end
            end
        end
        
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            local currentGrindPos = grindPositions[((i-1) % #grindPositions) + 1]
            
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart
                    for _, child in ipairs(item:GetDescendants()) do
                        if child:IsA("MeshPart") or child:IsA("Part") then
                            targetPart = child
                            break
                        end
                    end
                    
                    if targetPart then
                        local randomOffset = Vector3.new(
                            math.random(-1, 1) * 0.5,
                            math.random(0, 2),
                            math.random(-1, 1) * 0.5
                        )
                        local finalPos = currentGrindPos + randomOffset
                        
                        if item:IsA("Model") and item.PrimaryPart then
                            item:SetPrimaryPartCFrame(CFrame.new(finalPos))
                        else
                            targetPart.Position = finalPos
                        end
                    end
                    table.insert(batch, item)
                end
            end
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    startDrag(item)
                end
            end
            
            task.wait(bringDelay)
            
            for _, item in ipairs(batch) do
                if item and item.Parent then
                    stopDrag(item)
                end
            end
            
            task.wait(0.02)
        end
        
        isProcessing = false
    end)
end

local function teleportToCampfire()
    if hrp then
        pcall(function()
            hrp.CFrame = CFrame.new(campfirePosition + Vector3.new(0, 5, 0))
        end)
    end
end

local function openChest(chest)
    if not autoOpenChestsEnabled then return end
    if not chest or not chest:FindFirstChild("Main") then return end
    
    local chestPosition = chest.Main.Position
    local playerPosition = hrp.Position
    local distance = (chestPosition - playerPosition).Magnitude
    
    if distance > chestRange then return end
    
    local proxAtt = chest.Main:FindFirstChild("ProximityAttachment")
    if proxAtt then
        for _, obj in ipairs(proxAtt:GetChildren()) do
            if obj:IsA("ProximityPrompt") or obj.Name == "ProximityInteraction" then
                pcall(function() fireproximityprompt(obj) end)
            end
        end
    end
end

local function killAura()
    if not killAuraEnabled then return end
    
    local characters = workspace:FindFirstChild("Characters")
    if not characters then return end
    
    for _, enemy in pairs(characters:GetChildren()) do
        if enemy.Name ~= player.Name and enemy:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local inventory = player:FindFirstChild("Inventory")
                if inventory then
                    for _, weapon in pairs(inventory:GetChildren()) do
                        if weapon:IsA("Tool") or weapon.Name:find("Axe") or weapon.Name:find("Spear") or weapon.Name:find("Katana") or weapon.Name:find("Sword") then
                            local args = {
                                enemy,
                                weapon,
                                "11_5204135765",
                                enemy:FindFirstChild("HumanoidRootPart").CFrame
                            }
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(unpack(args))
                            break
                        end
                    end
                end
            end)
        end
    end
end

-- Auto plant loop
spawn(function()
    while true do
        if autoPlantEnabled then
            autoPlant()
        end
        wait(1)
    end
end)

-- Event connections
workspaceItems.ChildAdded:Connect(function(item)
    if item.Name:find("Chest") then
        task.wait(0.1)
        openChest(item)
    end
end)

RunService.Heartbeat:Connect(function()
    if killAuraEnabled then killAura() end
end)

player.CharacterAdded:Connect(function(character)
    char = character
    hrp = character:WaitForChild("HumanoidRootPart")
end)

antiAFK()

for _, item in ipairs(workspaceItems:GetChildren()) do
    if item.Name:find("Chest") then
        openChest(item)
    end
end

-- ============================================
-- CREATE UI WITH FIXED LIBRARY - COMPLETE
-- ============================================

Library:CreateWindow("99 Nights - Aux Hub")

-- INFO TAB
local InfoTab = Library:CreateTab("Info")

InfoTab:CreateLabel("99 Nights in the Forest")
InfoTab:CreateLabel("Beta Version")
InfoTab:CreateLabel("Features: Farm Log, Auto Kid")
InfoTab:CreateLabel("Finding, Items, Auto functions")
InfoTab:CreateLabel("Movement utilities & more!")
InfoTab:CreateLabel("Credits: VantaXock, Polleser")

-- SETTINGS TAB
local SettingsTab = Library:CreateTab("Settings")

SettingsTab:CreateLabel("Script Settings")

SettingsTab:CreateSlider("Batch Delay", 0.05, 1, 0.1, function(value)
    bringDelay = value
end)

SettingsTab:CreateSlider("Items Per Batch", 1, 10, 3, function(value)
    maxItemsPer-- PART 2 - Continue from Settings Tab
-- Merge this after Part 1

Frame = value
end)

SettingsTab:CreateToggle("Anti-Lag", false, function(enabled)
    if enabled then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or 
               v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
        
        workspace.Terrain.Decoration = false
        
        Library:Notify("Anti-Lag", "Enabled! FPS improved.", 3)
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or 
               v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = true
            end
        end
        
        workspace.Terrain.Decoration = true
        
        Library:Notify("Anti-Lag", "Disabled. Normal quality.", 3)
    end
end)

SettingsTab:CreateToggle("Show Coordinates", false, function(enabled)
    showCoordinates = enabled
    if enabled then
        if coordinatesGui then coordinatesGui:Destroy() end

        coordinatesGui = Instance.new("ScreenGui")
        coordinatesGui.Name = "CoordinatesGui"
        coordinatesGui.ResetOnSpawn = false
        coordinatesGui.Parent = player.PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 250, 0, 80)
        frame.Position = UDim2.new(0, 10, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizePixel = 0
        frame.BackgroundTransparency = 0.3
        frame.Parent = coordinatesGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local coordText = Instance.new("TextLabel")
        coordText.Size = UDim2.new(1, -10, 1, -10)
        coordText.Position = UDim2.new(0, 5, 0, 5)
        coordText.BackgroundTransparency = 1
        coordText.Text = "Loading..."
        coordText.TextColor3 = Color3.fromRGB(255, 255, 255)
        coordText.TextSize = 16
        coordText.Font = Enum.Font.Code
        coordText.TextXAlignment = Enum.TextXAlignment.Left
        coordText.Parent = frame
        
        spawn(function()
            while showCoordinates and coordinatesGui do
                if hrp then
                    local pos = hrp.Position
                    coordText.Text = string.format("Position:\nX: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z)
                end
                wait(0.1)
            end
        end)
    else
        if coordinatesGui then
            coordinatesGui:Destroy()
            coordinatesGui = nil
        end
    end
end)

SettingsTab:CreateToggle("ESP Teammates", false, function(enabled)
    espEnabled = enabled
    if enabled then
        if espFolder then espFolder:Destroy() end

        espFolder = Instance.new("Folder")
        espFolder.Name = "ESPFolder"
        espFolder.Parent = game.CoreGui
        
        local function addESP(character)
            if not character or character == char then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not rootPart then return end
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_" .. character.Name
            billboard.Adornee = rootPart
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = espFolder
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = character.Name
            nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = billboard
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.Text = "0 studs"
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            distanceLabel.TextStrokeTransparency = 0.5
            distanceLabel.TextSize = 12
            distanceLabel.Font = Enum.Font.SourceSans
            distanceLabel.Parent = billboard
            
            spawn(function()
                while espEnabled and billboard and billboard.Parent and rootPart and hrp do
                    local distance = (rootPart.Position - hrp.Position).Magnitude
                    distanceLabel.Text = string.format("%.0f studs", distance)
                    wait(0.1)
                end
            end)
        end
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                addESP(otherPlayer.Character)
            end
        end
        
        Players.PlayerAdded:Connect(function(otherPlayer)
            otherPlayer.CharacterAdded:Connect(function(character)
                if espEnabled then
                    wait(1)
                    addESP(character)
                end
            end)
        end)
    else
        if espFolder then
            espFolder:Destroy()
            espFolder = nil
        end
    end
end)

SettingsTab:CreateSlider("FOV", 30, 120, 70, function(value)
    currentFOV = value
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = value
    end
end)

SettingsTab:CreateButton("Refresh Character", function()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = originalWalkSpeed
        char.Humanoid.JumpPower = originalJumpPower
    end
    
    Library:Notify("Settings", "Character refreshed!", 2)
end)

-- HELP KIDS TAB
local HelpKidsTab = Library:CreateTab("Help Kids")

HelpKidsTab:CreateLabel("Lost Child Finder")
HelpKidsTab:CreateLabel("Auto find Dino Kid, Koala kid")

HelpKidsTab:CreateButton("Find Lost Child", function()
    local childPos = findSmartLostChild()
    if childPos then
        hrp.CFrame = CFrame.new(childPos + Vector3.new(0, 5, 0))
        Library:Notify("Kid Finder", "Found and teleported!", 3)
    else
        Library:Notify("Kid Finder", "No new kids found!", 3)
    end
end)

HelpKidsTab:CreateButton("Reset Rescued Kids", function()
    rescuedKids = {}
    Library:Notify("Kid Finder", "List cleared!", 2)
end)

-- CULTIST TAB
local CultistTab = Library:CreateTab("Cultist")

CultistTab:CreateLabel("Cultist Items")
CultistTab:CreateLabel("Bring cultist-related items")

CultistTab:CreateButton("Bring All Cultist Items", function()
    bringItemsToPlayer(cultistItems)
end)

for _, cultistItem in ipairs(cultistItems) do
    CultistTab:CreateButton(cultistItem, function()
        if isProcessing then return end
        bringItemsToPlayer({cultistItem})
    end)
end

-- BRING TAB
local BringTab = Library:CreateTab("Bring")

BringTab:CreateLabel("Item Bringing System")

BringTab:CreateButton("Bring All Items", function()
    bringItemsToPlayer({})
end)

BringTab:CreateToggle("Auto Bring All", false, function(enabled)
    autoBringEnabled = enabled
    if enabled then
        spawn(function()
            while autoBringEnabled do
                if not isProcessing then
                    bringItemsToPlayer({})
                end
                wait(3)
            end
        end)
    end
end)

-- FOOD ITEMS
BringTab:CreateLabel("--- Food Items ---")
for _, foodItem in ipairs(allFoodItems) do
    BringTab:CreateButton(foodItem, function()
        if isProcessing then return end
        bringItemsToPlayer({foodItem})
    end)
end

-- SEEDS
BringTab:CreateLabel("--- Seeds ---")
for _, seedItem in ipairs(seedItems) do
    BringTab:CreateButton(seedItem, function()
        if isProcessing then return end
        bringItemsToPlayer({seedItem})
    end)
end

-- FLASHLIGHTS
BringTab:CreateLabel("--- Flashlights ---")
for _, flashItem in ipairs(flashlightItems) do
    BringTab:CreateButton(flashItem, function()
        if isProcessing then return end
        bringItemsToPlayer({flashItem})
    end)
end

-- TOOLS
BringTab:CreateLabel("--- Tools & Sacks ---")
for _, toolItem in ipairs(toolsItems) do
    BringTab:CreateButton(toolItem, function()
        if isProcessing then return end
        bringItemsToPlayer({toolItem})
    end)
end

-- MELEE WEAPONS
BringTab:CreateLabel("--- Melee Weapons ---")
for _, meleeItem in ipairs(meleeWeapons) do
    BringTab:CreateButton(meleeItem, function()
        if isProcessing then return end
        bringItemsToPlayer({meleeItem})
    end)
end

-- RANGED WEAPONS
BringTab:CreateLabel("--- Ranged Weapons ---")
for _, rangedItem in ipairs(rangedWeapons) do
    BringTab:CreateButton(rangedItem, function()
        if isProcessing then return end
        bringItemsToPlayer({rangedItem})
    end)
end

-- AMMO
BringTab:CreateLabel("--- Ammunition ---")
for _, ammoItem in ipairs(ammoItems) do
    BringTab:CreateButton(ammoItem, function()
        if isProcessing then return end
        bringItemsToPlayer({ammoItem})
    end)
end

-- ARMOR
BringTab:CreateLabel("--- Armor & Protection ---")
for _, armorItem in ipairs(armorItems) do
    BringTab:CreateButton(armorItem, function()
        if isProcessing then return end
        bringItemsToPlayer({armorItem})
    end)
end

-- CORPSES & FUEL
BringTab:CreateLabel("--- Corpses & Fuel ---")
for _, corpseItem in ipairs(corpseFuelItems) do
    BringTab:CreateButton(corpseItem, function()
        if isProcessing then return end
        bringItemsToPlayer({corpseItem})
    end)
end

-- MATERIALS
BringTab:CreateLabel("--- Materials & Scrap ---")
for _, materialItem in ipairs(materialsItems) do
    BringTab:CreateButton(materialItem, function()
        if isProcessing then return end
        bringItemsToPlayer({materialItem})
    end)
end

-- ANIMAL PARTS
BringTab:CreateLabel("--- Animal Parts ---")
for _, animalItem in ipairs(animalParts) do
    BringTab:CreateButton(animalItem, function()
        if isProcessing then return end
        bringItemsToPlayer({animalItem})
    end)
end

-- MEDICAL
BringTab:CreateLabel("--- Medical Items ---")
for _, medItem in ipairs(medicalItems) do
    BringTab:CreateButton(medItem, function()
        if isProcessing then return end
        bringItemsToPlayer({medItem})
    end)
end

-- CONTAINERS
BringTab:CreateLabel("--- Containers ---")
for _, containerItem in ipairs(containerItems) do
    BringTab:CreateButton(containerItem, function()
        if isProcessing then return end
        bringItemsToPlayer({containerItem})
    end)
end

-- GRINDER TAB
local GrinderTab = Library:CreateTab("Grinder")

GrinderTab:CreateLabel("Auto Grinders System")

GrinderTab:CreateButton("Grind All Materials", function()
    autoGrindersEnabled = false
    bringItemsToGrinder(grindableItems)
end)

GrinderTab:CreateToggle("Auto Grind All", false, function(enabled)
    autoGrindersEnabled = enabled
    if enabled then
        spawn(function()
            while autoGrindersEnabled do
                if not isProcessing then
                    bringItemsToGrinder(grindableItems)
                end
                wait(4)
            end
        end)
    end
end)

GrinderTab:CreateLabel("--- Grindable Materials ---")
for _, grindItem in ipairs(grindableItems) do
    GrinderTab:CreateButton(grindItem, function()
        if isProcessing then return end
        bringItemsToGrinder({grindItem})
    end)
end

-- CAMPFIRE TAB
local CampfireTab = Library:CreateTab("Campfire")

CampfireTab:CreateLabel("Campfire Management")

CampfireTab:CreateButton("Teleport to Campfire", teleportToCampfire)

CampfireTab:CreateButton("Bring All Fuel", function()
    autoCampfireEnabled = false
    bringItemsToCampfire(fuelItems)
end)

CampfireTab:CreateToggle("Auto Fuel Campfire", false, function(enabled)
    autoCampfireEnabled = enabled
    if enabled then
        spawn(function()
            while autoCampfireEnabled do
                if not isProcessing then
                    bringItemsToCampfire(fuelItems)
                end
                wait(3)
            end
        end)
    end
end)

CampfireTab:CreateLabel("--- Fuel Items ---")
for _, fuelItem in ipairs(fuelItems) do
    CampfireTab:CreateButton(fuelItem, function()
        if isProcessing then return end
        bringItemsToCampfire({fuelItem})
    end)
end

-- COOK TAB
local CookTab = Library:CreateTab("Cook")

CookTab:CreateLabel("Cooking System")

CookTab:CreateButton("Bring All Cookable", function()
    bringItemsToCampfire(cookableFoods)
end)

CookTab:CreateToggle("Auto Cook", false, function(enabled)
    if enabled then
        spawn(function()
            while enabled do
                if not isProcessing then
                    bringItemsToCampfire(cookableFoods)
                end
                wait(3)
            end
        end)
    end
end)

CookTab:CreateLabel("--- Cookable Foods ---")
for _, cookItem in ipairs(cookableFoods) do
    CookTab:CreateButton(cookItem, function()
        if isProcessing then return end
        bringItemsToCampfire({cookItem})
    end)
end

-- BRING FOODS TAB
local BringFoodsTab = Library:CreateTab("Bring Foods")

BringFoodsTab:CreateLabel("Food Items")

BringFoodsTab:CreateButton("Bring All Food Items", function()
    bringItemsToPlayer(allFoodItems)
end)

BringFoodsTab:CreateToggle("Auto Bring All Foods", false, function(enabled)
    if enabled then
        spawn(function()
            while enabled do
                if not isProcessing then
                    bringItemsToPlayer(allFoodItems)
                end
                wait(3)
            end
        end)
    end
end)

BringFoodsTab:CreateLabel("--- Individual Foods ---")
for _, foodItem in ipairs(allFoodItems) do
    BringFoodsTab:CreateButton(foodItem, function()
        if isProcessing then return end
        bringItemsToPlayer({foodItem})
    end)
end

-- MAIN TAB (LAST)
local MainTab = Library:CreateTab("Main")

MainTab:CreateLabel("99 Nights Forest - Aux Hub")
MainTab:CreateLabel("Welcome!")

MainTab:CreateButton("Farm Log 20 Seconds", farmLog20Seconds)

MainTab:CreateButton("Out Build (Development)", outBuild)

MainTab:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    originalWalkSpeed = value
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

MainTab:CreateSlider("Jump Power", 50, 200, 50, function(value)
    originalJumpPower = value
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

MainTab:CreateToggle("Remove Fog", false, function(enabled)
    if enabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = originalFogEnd
    end
end)

MainTab:CreateToggle("Fullbright", false, function(enabled)
    if enabled then
        Lighting.Brightness = 10
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

MainTab:CreateToggle("Auto Plant (Dev)", false, function(enabled)
    autoPlantEnabled = enabled
end)

MainTab:CreateToggle("Kill Aura (OP!)", false, function(enabled)
    killAuraEnabled = enabled
end)

MainTab:CreateToggle("Auto Open Chests", true, function(enabled)
    autoOpenChestsEnabled = enabled
end)

MainTab:CreateSlider("Chest Range", 1, 1000, 50, function(value)
    chestRange = value
end)

-- Success notification
Library:Notify("99 Nights", "Script loaded by VantaXock!", 3)
