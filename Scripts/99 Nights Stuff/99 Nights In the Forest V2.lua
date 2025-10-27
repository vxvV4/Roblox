-- 99 Nights in the Forest - COMPLETE V3 with Dropdowns & NEW Items
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Scripts/99%20Nights%20Stuff/Library.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local workspaceItems = workspace:WaitForChild("Items")

-- Variables
local showCoordinates, espEnabled = false, false
local currentFOV = 70
local coordinatesGui, espFolder = nil, nil
local autoBringEnabled, autoGrindersEnabled = false, false
local autoCampfireEnabled, autoCookFoodEnabled = false, false
local killAuraEnabled, autoPlantEnabled = false, false
local autoOpenChestsEnabled = true
local farmLogActive, farmLogTimer = false, 0
local chestRange, bringDelay = 50, 0.1
local maxItemsPerFrame, isProcessing = 3, false
local campfirePosition = Vector3.new(0.5, 8.0, -0.3)
local originalFogEnd = Lighting.FogEnd
local originalWalkSpeed, originalJumpPower = 16, 50
local rescuedKids = {}

-- SELECTED ITEMS FOR DROPDOWNS
local selectedCampfireItems = {}
local selectedCookItems = {}
local selectedBringItems = {}
local selectedGrindItems = {}

local grindPositions = {
    Vector3.new(20.8, 6.3, -5.2),
    Vector3.new(22, 6.3, -5.2),
    Vector3.new(19, 6.3, -5.2),
    Vector3.new(20.8, 6.3, -3),
}

-- ========== COMPLETE ITEM LISTS ==========

local allFoodItems = {
    "Apple", "Berry", "Cake", "Carrot", "Cooked Morsel", "Cooked Steak", 
    "Hearty Stew", "Morsel", "Pepper", "Steak", "Stew", "Fish", "Bread", 
    "Mushroom", "Rabbit", "Cooked Fish", "Raw Fish", "Meat", "Cooked Meat",
    "Cooked Rabbit", "Berry Pie", "Carrot Soup"
}

local fishItems = {
    "Mackerel", "Salmon", "Clownfish", "Swordfish", "Jellyfish", 
    "Char", "Eel", "Shark", "Raw Fish", "Cooked Fish"
}

local potionIngredients = {
    "Morsel", "Bunny Foot", "Coal", "Mackerel", "Steak", "Berry",
    "Dripleaf", "Moonflower", "Stareweed", "Cave Vine"
}

local cookableFoods = {
    "Morsel", "Steak", "Fish", "Raw Fish", "Meat", "Rabbit", "Mackerel", "Salmon"
}

local fuelItems = {
    "Coal", "Log", "Chair", "Oil Barrel", "Fuel Canister", "Matches", 
    "Lighter", "Biofuel", "Wood"
}

local grindableItems = {
    "Bolt", "Sheet Metal", "Scrap", "Metal Chair", "Car Engine", 
    "Old Car Engine", "Tyre", "Broken Fan", "Broken Microwave", 
    "Broken Radio", "Old Radio", "Washing Machine", "UFO Scrap", 
    "UFO Junk", "UFO Component", "Log", "Cultist Experiment",
    "Cultist Prototype", "Pipe", "Wire", "Battery", "Circuit", 
    "Gear", "Spring", "Volcanic Rock"
}

local cultistItems = {
    "Crossbow Cultist", "Cultist", "Cultist Experiment", 
    "Cultist Prototype", "Cultist Gem", "Mega Cultist", "Cultist King"
}

local seedItems = {
    "Berry Seed Packs", "Firefly Seed Packs", 
    "Flower Seed Packs", "Chili Seed Packs"
}

local flashlightItems = {
    "Old Flashlight", "Strong Flashlight", "Lantern"
}

local fishingRods = {
    "Old Rod", "Good Rod", "Strong Rod"
}

local tamingFlutes = {
    "Deer Flute", "Wolf Flute", "Bear Flute"
}

local trimKits = {
    "Leather Trim", "Iron Trim", "Thorn Trim", "Poison Trim", "Alien Trim"
}

local toolsItems = {
    "Chainsaw", "Giant Sack", "Good Axe", "Good Sack", 
    "Old Axe", "Old Sack", "Strong Axe", "Hammer", 
    "Pickaxe", "Shovel", "Knife", "Medium Sack"
}

local meleeWeapons = {
    "Katana", "Morningstar", "Spear", "Inferno Sword", "Cultist Mace"
}

local rangedWeapons = {
    "Revolver", "Rifle", "Tactical Shotgun", "Crossbow", 
    "Inferno Crossbow", "Ray Gun", "Laser Cannon"
}

local ammoItems = {
    "Revolver Ammo", "Rifle Ammo", "Shotgun Ammo", "Crossbow Bolt"
}

local armorItems = {
    "Iron Armor", "Iron Body", "Leather Armor", "Leather Body",
    "Riot Shield", "Thorn Armor", "Thorn Body", "Poison Armor",
    "Poison Armour", "Alien Armor", "Alien Armour"
}

local warmClothing = {
    "Winter Coat", "Fur Coat", "Warm Vest", "Thermal Jacket"
}

local materialsItems = {
    "Bolt", "Broken Fan", "Broken Microwave", "Broken Radio",
    "Car Engine", "Old Car Engine", "Metal Chair", "Sheet Metal",
    "Tyre", "Washing Machine", "Old Radio", "UFO Scrap",
    "UFO Junk", "UFO Component", "Scrap", "Pipe", "Wire",
    "Battery", "Circuit", "Spring", "Volcanic Rock", "Lava Crystal", 
    "Sulfur", "Meteor Metal"
}

local animalParts = {
    "Alpha Wolf Pelt", "Bear Pelt", "Rabbit Foot", "Wolf Pelt", "Deer Antler"
}

local medicalItems = {
    "Bandage", "Medkit", "Wildfire Potion", "Health Potion"
}

local containerItems = {
    "Barrel", "Crate", "Box", "Container", "Infernal Sack", "Storage Chest"
}

local furnitureItems = {
    "Bed", "Chair", "Table", "Campfire Bench", "Storage Shelf",
    "Weapon Rack", "Armor Stand", "Crafting Table", "Decorative Plant"
}

local specialItems = {
    "Cauldron", "Teleporter", "Radio", "Map", "Compass", "Watch"
}

-- ========== CORE FUNCTIONS ==========

local function antiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

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

local function autoPlant()
    if not autoPlantEnabled then return end
    local leftLegPos = hrp.Position + Vector3.new(-1, -3, 0)
    local rightLegPos = hrp.Position + Vector3.new(1, -3, 0)
    local plantPos = math.random() > 0.5 and leftLegPos or rightLegPos
    pcall(function()
        local args = {Instance.new("Model", nil), plantPos}
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
    end)
end

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
    return nil
end

local function farmLog20Seconds()
    if farmLogActive then return end
    farmLogActive, farmLogTimer = true, 20
    spawn(function()
        local smallTreesFound, targetTrees = 0, 20
        local function searchForSmallTrees(parent)
            for _, item in ipairs(parent:GetChildren()) do
                if smallTreesFound >= targetTrees then break end
                if item.Name == "Small Tree" then
                    local targetPart = nil
                    if item:IsA("Model") then
                        targetPart = item.PrimaryPart or item:FindFirstChildWhichIsA("Part") or item:FindFirstChildWhichIsA("MeshPart")
                    elseif item:IsA("Part") or item:IsA("MeshPart") then
                        targetPart = item
                    end
                    if targetPart then
                        local dropPos = hrp.Position + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(dropPos))
                            else
                                targetPart.Position = dropPos
                            end
                        end)
                        pcall(function() startDrag(item); wait(0.1); stopDrag(item) end)
                        smallTreesFound = smallTreesFound + 1
                        wait(0.2)
                    end
                end
                if item:IsA("Folder") or item:IsA("Model") then searchForSmallTrees(item) end
            end
        end
        searchForSmallTrees(workspace)
    end)
    spawn(function()
        while farmLogTimer > 0 and farmLogActive do wait(1); farmLogTimer = farmLogTimer - 1 end
        if farmLogActive and hrp then
            pcall(function() hrp.CFrame = CFrame.new(campfirePosition + Vector3.new(0, 5, 0)) end)
        end
        farmLogActive = false
    end)
end

local function bringItemsToPlayer(itemsToFind)
    if isProcessing then return end
    isProcessing = true
    spawn(function()
        local itemsToProcess = {}
        for _, item in ipairs(workspaceItems:GetChildren()) do
            if not item.Name:find("Chest") then
                local shouldInclude = #itemsToFind == 0
                if not shouldInclude then
                    for _, targetItem in ipairs(itemsToFind) do
                        if item.Name:lower():find(targetItem:lower()) or targetItem:lower():find(item.Name:lower()) then
                            shouldInclude = true
                            break
                        end
                    end
                end
                if shouldInclude then table.insert(itemsToProcess, item) end
            end
        end
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart = item:FindFirstChildWhichIsA("MeshPart") or item:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local dropPos = hrp.Position + Vector3.new(math.random(-3,3), 3, math.random(-3,3))
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(dropPos))
                            else
                                targetPart.Position = dropPos
                            end
                        end)
                    end
                    table.insert(batch, item)
                end
            end
            for _, item in ipairs(batch) do if item and item.Parent then startDrag(item) end end
            task.wait(bringDelay)
            for _, item in ipairs(batch) do if item and item.Parent then stopDrag(item) end end
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
                for _, targetItem in ipairs(itemsToFind) do
                    if item.Name:lower():find(targetItem:lower()) or targetItem:lower():find(item.Name:lower()) then
                        table.insert(itemsToProcess, item)
                        break
                    end
                end
            end
        end
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart = item:FindFirstChildWhichIsA("MeshPart") or item:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local finalPos = campfirePosition + Vector3.new(math.random(-1, 1), math.random(0, 2), math.random(-1, 1))
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(finalPos))
                            else
                                targetPart.Position = finalPos
                            end
                        end)
                    end
                    table.insert(batch, item)
                end
            end
            for _, item in ipairs(batch) do if item and item.Parent then startDrag(item) end end
            task.wait(bringDelay)
            for _, item in ipairs(batch) do if item and item.Parent then stopDrag(item) end end
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
                for _, targetItem in ipairs(itemsToFind) do
                    if item.Name:lower():find(targetItem:lower()) or targetItem:lower():find(item.Name:lower()) then
                        table.insert(itemsToProcess, item)
                        break
                    end
                end
            end
        end
        for i = 1, #itemsToProcess, maxItemsPerFrame do
            local batch = {}
            local currentGrindPos = grindPositions[((i-1) % #grindPositions) + 1]
            for j = i, math.min(i + maxItemsPerFrame - 1, #itemsToProcess) do
                local item = itemsToProcess[j]
                if item and item.Parent then
                    local targetPart = item:FindFirstChildWhichIsA("MeshPart") or item:FindFirstChildWhichIsA("Part")
                    if targetPart then
                        local finalPos = currentGrindPos + Vector3.new(math.random(-1, 1) * 0.5, math.random(0, 2), math.random(-1, 1) * 0.5)
                        pcall(function()
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(CFrame.new(finalPos))
                            else
                                targetPart.Position = finalPos
                            end
                        end)
                    end
                    table.insert(batch, item)
                end
            end
            for _, item in ipairs(batch) do if item and item.Parent then startDrag(item) end end
            task.wait(bringDelay)
            for _, item in ipairs(batch) do if item and item.Parent then stopDrag(item) end end
            task.wait(0.02)
        end
        isProcessing = false
    end)
end

local function teleportToCampfire()
    if hrp then pcall(function() hrp.CFrame = CFrame.new(campfirePosition + Vector3.new(0, 5, 0)) end) end
end

local function openChest(chest)
    if not autoOpenChestsEnabled or not chest or not chest:FindFirstChild("Main") then return end
    local distance = (chest.Main.Position - hrp.Position).Magnitude
    if distance > chestRange then return end
    local proxAtt = chest.Main:FindFirstChild("ProximityAttachment")
    if proxAtt then
        for _, obj in ipairs(proxAtt:GetChildren()) do
            if obj:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(obj) end) end
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
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(enemy, weapon, "11_5204135765", enemy.HumanoidRootPart.CFrame)
                            break
                        end
                    end
                end
            end)
        end
    end
end

-- Auto plant loop
spawn(function() while true do if autoPlantEnabled then autoPlant() end wait(1) end end)

-- Event connections
workspaceItems.ChildAdded:Connect(function(item) if item.Name:find("Chest") then task.wait(0.1); openChest(item) end end)
RunService.Heartbeat:Connect(function() if killAuraEnabled then killAura() end end)
player.CharacterAdded:Connect(function(character) char = character; hrp = character:WaitForChild("HumanoidRootPart") end)
antiAFK()
for _, item in ipairs(workspaceItems:GetChildren()) do if item.Name:find("Chest") then openChest(item) end end

-- ========== CREATE UI ==========

Library:CreateWindow("99 Nights - Complete V3")

-- INFO TAB
local InfoTab = Library:CreateTab("Info")
InfoTab:CreateLabel("99 Nights in the Forest V3")
InfoTab:CreateLabel("Complete Edition with Dropdowns")
InfoTab:CreateLabel("New Items: Fish, Trim Kits")
InfoTab:CreateLabel("Fishing Rods, Potions & More!")
InfoTab:CreateLabel("Credits: VantaXock, Polleser")

-- SETTINGS TAB
local SettingsTab = Library:CreateTab("Settings")
SettingsTab:CreateLabel("Performance Settings")
SettingsTab:CreateSlider("Batch Delay", 0.05, 1, 0.1, function(v) bringDelay = v end)
SettingsTab:CreateSlider("Items Per Batch", 1, 10, 3, function(v) maxItemsPerFrame = v end)
SettingsTab:CreateToggle("Anti-Lag", false, function(enabled)
    settings().Rendering.QualityLevel = enabled and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    workspace.Terrain.Decoration = not enabled
    Library:Notify("Anti-Lag", enabled and "Enabled!" or "Disabled", 2)
end)
SettingsTab:CreateSlider("FOV", 30, 120, 70, function(v) workspace.CurrentCamera.FieldOfView = v end)

-- HELP KIDS TAB
local HelpKidsTab = Library:CreateTab("Help Kids")
HelpKidsTab:CreateLabel("Lost Child Finder System")
HelpKidsTab:CreateButton("Find Lost Child", function()
    local childPos = findSmartLostChild()
    if childPos then
        hrp.CFrame = CFrame.new(childPos + Vector3.new(0, 5, 0))
        Library:Notify("Kid Finder", "Found child!", 2)
    else
        Library:Notify("Kid Finder", "No new kids!", 2)
    end
end)
HelpKidsTab:CreateButton("Reset Rescued List", function() rescuedKids = {}; Library:Notify("Reset", "List cleared!", 2) end)

-- BRING TAB WITH DROPDOWN
local BringTab = Library:CreateTab("Bring")
BringTab:CreateLabel("Item Bringing System")
BringTab:CreateButton("Bring All Items", function() bringItemsToPlayer({}) end)

-- Combine all items for dropdown
local allItemsList = {}
for _, t in ipairs({allFoodItems, fishItems, toolsItems, meleeWeapons, rangedWeapons, armorItems, materialsItems, seedItems, flashlightItems, fishingRods, trimKits, tamingFlutes}) do
    for _, item in ipairs(t) do
        if not table.find(allItemsList, item) then
            table.insert(allItemsList, item)
        end
    end
end

BringTab:CreateDropdown("Select Items to Bring", allItemsList, function(selected)
    selectedBringItems = selected
end)

BringTab:CreateToggle("Auto Bring Selected", false, function(enabled)
    autoBringEnabled = enabled
    if enabled then
        spawn(function()
            while autoBringEnabled do
                if not isProcessing and #selectedBringItems > 0 then
                    bringItemsToPlayer(selectedBringItems)
                end
                wait(3)
            end
        end)
    end
end)

-- Quick category buttons
BringTab:CreateLabel("--- Quick Categories ---")
BringTab:CreateButton("Bring All Food", function() bringItemsToPlayer(allFoodItems) end)
BringTab:CreateButton("Bring All Fish", function() bringItemsToPlayer(fishItems) end)
BringTab:CreateButton("Bring All Weapons", function()
    local weapons = {}
    for _, w in ipairs(meleeWeapons) do table.insert(weapons, w) end
    for _, w in ipairs(rangedWeapons) do table.insert(weapons, w) end
    bringItemsToPlayer(weapons)
end)
BringTab:CreateButton("Bring All Tools", function() bringItemsToPlayer(toolsItems) end)
BringTab:CreateButton("Bring All Armor", function() bringItemsToPlayer(armorItems) end)
BringTab:CreateButton("Bring Fishing Rods", function() bringItemsToPlayer(fishingRods) end)
BringTab:CreateButton("Bring Trim Kits", function() bringItemsToPlayer(trimKits) end)
BringTab:CreateButton("Bring Taming Flutes", function() bringItemsToPlayer(tamingFlutes) end)

-- GRINDER TAB WITH DROPDOWN
local GrinderTab = Library:CreateTab("Grinder")
GrinderTab:CreateLabel("Auto Grinder System")
GrinderTab:CreateButton("Grind All Materials", function() bringItemsToGrinder(grindableItems) end)

GrinderTab:CreateDropdown("Select Items to Grind", grindableItems, function(selected)
    selectedGrindItems = selected
end)

GrinderTab:CreateToggle("Auto Grind Selected", false, function(enabled)
    autoGrindersEnabled = enabled
    if enabled then
        spawn(function()
            while autoGrindersEnabled do
                if not isProcessing and #selectedGrindItems > 0 then
                    bringItemsToGrinder(selectedGrindItems)
                end
                wait(4)
            end
        end)
    end
end)

-- CAMPFIRE TAB WITH DROPDOWN
local CampfireTab = Library:CreateTab("Campfire")
CampfireTab:CreateLabel("Campfire Management")
CampfireTab:CreateButton("Teleport to Campfire", teleportToCampfire)
CampfireTab:CreateButton("Bring All Fuel", function() bringItemsToCampfire(fuelItems) end)

CampfireTab:CreateDropdown("Select Fuel Items", fuelItems, function(selected)
    selectedCampfireItems = selected
end)

CampfireTab:CreateToggle("Auto Fuel Selected", false, function(enabled)
    autoCampfireEnabled = enabled
    if enabled then
        spawn(function()
            while autoCampfireEnabled do
                if not isProcessing and #selectedCampfireItems > 0 then
                    bringItemsToCampfire(selectedCampfireItems)
                end
                wait(3)
            end
        end)
    end
end)

-- COOK TAB WITH DROPDOWN
local CookTab = Library:CreateTab("Cook")
CookTab:CreateLabel("Cooking System")
CookTab:CreateButton("Bring All Cookable", function() bringItemsToCampfire(cookableFoods) end)

CookTab:CreateDropdown("Select Foods to Cook", cookableFoods, function(selected)
    selectedCookItems = selected
end)

CookTab:CreateToggle("Auto Cook Selected", false, function(enabled)
    autoCookFoodEnabled = enabled
    if enabled then
        spawn(function()
            while autoCookFoodEnabled do
                if not isProcessing and #selectedCookItems > 0 then
                    bringItemsToCampfire(selectedCookItems)
                end
                wait(3)
            end
        end)
    end
end)

-- POTION TAB
local PotionTab = Library:CreateTab("Potions")
PotionTab:CreateLabel("Potion Brewing System")
PotionTab:CreateLabel("Bring ingredients to Cauldron!")
PotionTab:CreateButton("Bring All Ingredients", function() bringItemsToPlayer(potionIngredients) end)
PotionTab:CreateLabel("--- Individual Ingredients ---")
for _, ingredient in ipairs(potionIngredients) do
    PotionTab:CreateButton(ingredient, function()
        if not isProcessing then bringItemsToPlayer({ingredient}) end
    end)
end

-- FISH TAB
local FishTab = Library:CreateTab("Fish")
FishTab:CreateLabel("Fishing Items & Fish")
FishTab:CreateButton("Bring All Fish", function() bringItemsToPlayer(fishItems) end)
FishTab:CreateButton("Bring All Fishing Rods", function() bringItemsToPlayer(fishingRods) end)
FishTab:CreateLabel("--- Individual Fish ---")
for _, fish in ipairs(fishItems) do
    FishTab:CreateButton(fish, function()
        if not isProcessing then bringItemsToPlayer({fish}) end
    end)
end

-- MAIN TAB
local MainTab = Library:CreateTab("Main")
MainTab:CreateLabel("Core Features")
MainTab:CreateButton("Farm Log 20 Seconds", farmLog20Seconds)
MainTab:CreateSlider("Walk Speed", 16, 100, 16, function(v)
    originalWalkSpeed = v
    if char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
end)
MainTab:CreateSlider("Jump Power", 50, 200, 50, function(v)
    originalJumpPower = v
    if char:FindFirstChild("Humanoid")
end)
MainTab:CreateToggle("Remove Fog", false, function(enabled)
    Lighting.FogEnd = enabled and 100000 or originalFogEnd
end)
MainTab:CreateToggle("Fullbright", false, function(enabled)
    Lighting.Brightness = enabled and 10 or 1
    Lighting.GlobalShadows = not enabled
end)
MainTab:CreateToggle("Auto Plant", false, function(enabled)
    autoPlantEnabled = enabled
end)
MainTab:CreateToggle("Kill Aura (OP!)", false, function(enabled)
    killAuraEnabled = enabled
end)
MainTab:CreateToggle("Auto Open Chests", true, function(enabled)
    autoOpenChestsEnabled = enabled
end)
MainTab:CreateSlider("Chest Range", 1, 1000, 50, function(v)
    chestRange = v
end)

-- CULTIST TAB
local CultistTab = Library:CreateTab("Cultist")
CultistTab:CreateLabel("Cultist Items & Entities")
CultistTab:CreateButton("Bring All Cultist Items", function()
    bringItemsToPlayer(cultistItems)
end)
CultistTab:CreateLabel("--- Individual Cultist Items ---")
for _, cultistItem in ipairs(cultistItems) do
    CultistTab:CreateButton(cultistItem, function()
        if not isProcessing then
            bringItemsToPlayer({cultistItem})
        end
    end)
end

-- WEAPONS TAB
local WeaponsTab = Library:CreateTab("Weapons")
WeaponsTab:CreateLabel("All Weapons & Ammo")

WeaponsTab:CreateButton("Bring All Weapons", function()
    local allWeapons = {}
    for _, w in ipairs(meleeWeapons) do table.insert(allWeapons, w) end
    for _, w in ipairs(rangedWeapons) do table.insert(allWeapons, w) end
    bringItemsToPlayer(allWeapons)
end)

WeaponsTab:CreateButton("Bring All Ammo", function()
    bringItemsToPlayer(ammoItems)
end)

WeaponsTab:CreateLabel("--- Melee Weapons ---")
for _, melee in ipairs(meleeWeapons) do
    WeaponsTab:CreateButton(melee, function()
        if not isProcessing then bringItemsToPlayer({melee}) end
    end)
end

WeaponsTab:CreateLabel("--- Ranged Weapons ---")
for _, ranged in ipairs(rangedWeapons) do
    WeaponsTab:CreateButton(ranged, function()
        if not isProcessing then bringItemsToPlayer({ranged}) end
    end)
end

WeaponsTab:CreateLabel("--- Ammunition ---")
for _, ammo in ipairs(ammoItems) do
    WeaponsTab:CreateButton(ammo, function()
        if not isProcessing then bringItemsToPlayer({ammo}) end
    end)
end

-- ARMOR TAB
local ArmorTab = Library:CreateTab("Armor")
ArmorTab:CreateLabel("Armor & Protection")
ArmorTab:CreateButton("Bring All Armor", function()
    bringItemsToPlayer(armorItems)
end)

ArmorTab:CreateButton("Bring All Trim Kits", function()
    bringItemsToPlayer(trimKits)
end)

ArmorTab:CreateButton("Bring All Warm Clothing", function()
    bringItemsToPlayer(warmClothing)
end)

ArmorTab:CreateLabel("--- Armor Sets ---")
for _, armor in ipairs(armorItems) do
    ArmorTab:CreateButton(armor, function()
        if not isProcessing then bringItemsToPlayer({armor}) end
    end)
end

ArmorTab:CreateLabel("--- Trim Kits ---")
for _, trim in ipairs(trimKits) do
    ArmorTab:CreateButton(trim, function()
        if not isProcessing then bringItemsToPlayer({trim}) end
    end)
end

ArmorTab:CreateLabel("--- Warm Clothing ---")
for _, clothing in ipairs(warmClothing) do
    ArmorTab:CreateButton(clothing, function()
        if not isProcessing then bringItemsToPlayer({clothing}) end
    end)
end

-- TOOLS TAB
local ToolsTab = Library:CreateTab("Tools")
ToolsTab:CreateLabel("All Tools & Equipment")
ToolsTab:CreateButton("Bring All Tools", function()
    bringItemsToPlayer(toolsItems)
end)

ToolsTab:CreateButton("Bring All Flashlights", function()
    bringItemsToPlayer(flashlightItems)
end)

ToolsTab:CreateButton("Bring All Fishing Rods", function()
    bringItemsToPlayer(fishingRods)
end)

ToolsTab:CreateButton("Bring All Taming Flutes", function()
    bringItemsToPlayer(tamingFlutes)
end)

ToolsTab:CreateLabel("--- Tools ---")
for _, tool in ipairs(toolsItems) do
    ToolsTab:CreateButton(tool, function()
        if not isProcessing then bringItemsToPlayer({tool}) end
    end)
end

ToolsTab:CreateLabel("--- Flashlights ---")
for _, flashlight in ipairs(flashlightItems) do
    ToolsTab:CreateButton(flashlight, function()
        if not isProcessing then bringItemsToPlayer({flashlight}) end
    end)
end

ToolsTab:CreateLabel("--- Fishing Rods ---")
for _, rod in ipairs(fishingRods) do
    ToolsTab:CreateButton(rod, function()
        if not isProcessing then bringItemsToPlayer({rod}) end
    end)
end

ToolsTab:CreateLabel("--- Taming Flutes ---")
for _, flute in ipairs(tamingFlutes) do
    ToolsTab:CreateButton(flute, function()
        if not isProcessing then bringItemsToPlayer({flute}) end
    end)
end

-- MATERIALS TAB
local MaterialsTab = Library:CreateTab("Materials")
MaterialsTab:CreateLabel("Crafting Materials & Scrap")
MaterialsTab:CreateButton("Bring All Materials", function()
    bringItemsToPlayer(materialsItems)
end)

MaterialsTab:CreateButton("Bring All Animal Parts", function()
    bringItemsToPlayer(animalParts)
end)

MaterialsTab:CreateLabel("--- Materials & Scrap ---")
for _, material in ipairs(materialsItems) do
    MaterialsTab:CreateButton(material, function()
        if not isProcessing then bringItemsToPlayer({material}) end
    end)
end

MaterialsTab:CreateLabel("--- Animal Parts ---")
for _, animalPart in ipairs(animalParts) do
    MaterialsTab:CreateButton(animalPart, function()
        if not isProcessing then bringItemsToPlayer({animalPart}) end
    end)
end

-- SEEDS TAB
local SeedsTab = Library:CreateTab("Seeds")
SeedsTab:CreateLabel("Seed Packs & Farming")
SeedsTab:CreateButton("Bring All Seeds", function()
    bringItemsToPlayer(seedItems)
end)

SeedsTab:CreateLabel("--- Seed Packs ---")
for _, seed in ipairs(seedItems) do
    SeedsTab:CreateButton(seed, function()
        if not isProcessing then bringItemsToPlayer({seed}) end
    end)
end

-- MEDICAL TAB
local MedicalTab = Library:CreateTab("Medical")
MedicalTab:CreateLabel("Medical Items & Potions")
MedicalTab:CreateButton("Bring All Medical", function()
    bringItemsToPlayer(medicalItems)
end)

MedicalTab:CreateLabel("--- Medical Items ---")
for _, med in ipairs(medicalItems) do
    MedicalTab:CreateButton(med, function()
        if not isProcessing then bringItemsToPlayer({med}) end
    end)
end

-- CONTAINERS TAB
local ContainersTab = Library:CreateTab("Containers")
ContainersTab:CreateLabel("Storage & Containers")
ContainersTab:CreateButton("Bring All Containers", function()
    bringItemsToPlayer(containerItems)
end)

ContainersTab:CreateLabel("--- Containers ---")
for _, container in ipairs(containerItems) do
    ContainersTab:CreateButton(container, function()
        if not isProcessing then bringItemsToPlayer({container}) end
    end)
end

-- FURNITURE TAB
local FurnitureTab = Library:CreateTab("Furniture")
FurnitureTab:CreateLabel("Furniture & Base Items")
FurnitureTab:CreateButton("Bring All Furniture", function()
    bringItemsToPlayer(furnitureItems)
end)

FurnitureTab:CreateLabel("--- Furniture Items ---")
for _, furniture in ipairs(furnitureItems) do
    FurnitureTab:CreateButton(furniture, function()
        if not isProcessing then bringItemsToPlayer({furniture}) end
    end)
end

-- SPECIAL ITEMS TAB
local SpecialTab = Library:CreateTab("Special")
SpecialTab:CreateLabel("Special & Unique Items")
SpecialTab:CreateButton("Bring All Special Items", function()
    bringItemsToPlayer(specialItems)
end)

SpecialTab:CreateLabel("--- Special Items ---")
for _, special in ipairs(specialItems) do
    SpecialTab:CreateButton(special, function()
        if not isProcessing then bringItemsToPlayer({special}) end
    end)
end

-- FOOD TAB (COMPLETE)
local FoodTab = Library:CreateTab("Food")
FoodTab:CreateLabel("All Food Items")
FoodTab:CreateButton("Bring All Food", function()
    bringItemsToPlayer(allFoodItems)
end)

FoodTab:CreateToggle("Auto Bring All Food", false, function(enabled)
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

FoodTab:CreateLabel("--- Individual Food Items ---")
for _, food in ipairs(allFoodItems) do
    FoodTab:CreateButton(food, function()
        if not isProcessing then bringItemsToPlayer({food}) end
    end)
end

-- TELEPORT TAB
local TeleportTab = Library:CreateTab("Teleport")
TeleportTab:CreateLabel("Teleportation System")

TeleportTab:CreateButton("Teleport to Campfire", function()
    teleportToCampfire()
end)

TeleportTab:CreateButton("Teleport to Random Player", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= player and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            Library:Notify("Teleport", "Teleported to " .. randomPlayer.Name, 2)
        end
    end
end)

TeleportTab:CreateTextbox("X Position", "Enter X coordinate", function(text)
    local x = tonumber(text)
    if x and hrp then
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(x, pos.Y, pos.Z)
        Library:Notify("Teleport", "Moved to X: " .. x, 2)
    end
end)

TeleportTab:CreateTextbox("Y Position", "Enter Y coordinate", function(text)
    local y = tonumber(text)
    if y and hrp then
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, y, pos.Z)
        Library:Notify("Teleport", "Moved to Y: " .. y, 2)
    end
end)

TeleportTab:CreateTextbox("Z Position", "Enter Z coordinate", function(text)
    local z = tonumber(text)
    if z and hrp then
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, pos.Y, z)
        Library:Notify("Teleport", "Moved to Z: " .. z, 2)
    end
end)

-- MISC TAB
local MiscTab = Library:CreateTab("Misc")
MiscTab:CreateLabel("Miscellaneous Features")

MiscTab:CreateToggle("Infinite Jump", false, function(enabled)
    if enabled then
        local connection
        connection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        Library:Notify("Infinite Jump", "Enabled!", 2)
    end
end)

MiscTab:CreateToggle("No Clip", false, function(enabled)
    local noClipEnabled = enabled
    if enabled then
        spawn(function()
            while noClipEnabled do
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait(0.1)
            end
        end)
        Library:Notify("No Clip", "Enabled!", 2)
    end
end)

MiscTab:CreateButton("Reset Character", function()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
        Library:Notify("Reset", "Character reset!", 2)
    end
end)

MiscTab:CreateSlider("Time of Day", 0, 24, 12, function(value)
    Lighting.ClockTime = value
end)

MiscTab:CreateToggle("Show Coordinates", false, function(enabled)
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

MiscTab:CreateToggle("ESP Teammates", false, function(enabled)
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

MiscTab:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

MiscTab:CreateButton("Copy Discord (if any)", function()
    setclipboard("VantaXock#0000")
    Library:Notify("Copied", "Discord copied!", 2)
end)

-- Final Success Notification
Library:Notify("99 Nights V3", "Welcome", 4)
Library:Notify("Welcome", "Made by Shizo", 3)
