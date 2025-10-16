local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local plr = Players.LocalPlayer

-- Save file
local saveFile = "BrainrotHub_Toggles.json"
local savedData = {}
if isfile and isfile(saveFile) then
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(saveFile))
    end)
    if success and type(result) == "table" then
        savedData = result
    end
end

local function SaveToggles()
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(savedData))
    end
end

-- Remove old GUIs
pcall(function()
    if CoreGui:FindFirstChild("BrainrotHubGui") then CoreGui.BrainrotHubGui:Destroy() end
    if CoreGui:FindFirstChild("DeliveryTouchGUI") then CoreGui.DeliveryTouchGUI:Destroy() end
    if CoreGui:FindFirstChild("PremiumDeliveryGUI") then CoreGui.PremiumDeliveryGUI:Destroy() end
end)

pcall(function()
    local pg = plr:WaitForChild("PlayerGui")
    if pg:FindFirstChild("ProfessionalBoostGUI") then pg.ProfessionalBoostGUI:Destroy() end
end)

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHubGui"
ScreenGui.Parent = CoreGui

-- Toggle button
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "HoverButton"
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
toggleBtn.Image = "rbxassetid://116189732890823"
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundTransparency = 0.7
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggleBtn

local stroke = Instance.new("UIStroke")
stroke.Parent = toggleBtn
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 230, 0, 250)
mainFrame.Position = UDim2.new(0.5, -115, 0.4, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = ScreenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 16)
headerBottom.Position = UDim2.new(0, 0, 1, -16)
headerBottom.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
headerBottom.BorderSizePixel = 0
headerBottom.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 0, 35)
titleLabel.Position = UDim2.new(0, 15, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal A Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 25)
closeButton.Position = UDim2.new(1, -45, 0, 12)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -75)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Draggable
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- ========================================
-- FEATURE VARIABLES
-- ========================================
local espConnections = {}
local espEnabled = false

local espEnemyConnections = {}
local espEnemyEnabled = false

local speedEnabled = false
local speedConn = nil
local speedLastUpdate = 0
local SPEED_VALUE = 28

local autoShootEnabled = false
local autoShootConn = nil

local jumpBoostHolding = false
local jumpBoostStart = 0
local JUMP_LIFT = 20
local MAX_JUMP_TIME = 5

-- ========================================
-- ESP TARGET FUNCTIONS
-- ========================================
local targetNames = {
    ["Trenostruzzo Turbo 3000"] = true, ["Los Tralaleritos"] = true, ["La Vacca Saturno Saturnita"] = true,
    ["Matteo"] = true, ["Graipuss Medussi"] = true, ["Cocofanto Elefanto"] = true,
    ["Odin Din Din Dun"] = true, ["Tralalero Tralala"] = true, ["Girafa Celestre"] = true,
    ["Gattatino Nyanino"] = true, ["La Grande Combinasion"] = true, ["Garama and Madundung"] = true,
    ["Sammyni Spyderini"] = true, ["Unclito Samito"] = true, ["Zibra Zubra Zibralini"] = true,
    ["Torrtuginni Dragonfrutini"] = true, ["Tigroligre Frutonni"] = true, ["Tigrilini Watermelini"] = true,
    ["Statutino Libertino"] = true, ["Secret Lucky Block"] = true, ["Pot Hotspot"] = true,
    ["Brainrot God Lucky Block"] = true, ["Chimpanzini Spiderini"] = true, ["Gattatino Neonino"] = true,
    ["Las Tralaleritas"] = true, ["Mythic Lucky Block"] = true, ["Orcalero Orcala"] = true,
}

local function createESP(model)
    if model:IsA("Model") and targetNames[model.Name] then
        local root = model:FindFirstChild("RootPart")
        if root and not root:FindFirstChild("ESP_Text") then
            local gui = Instance.new("BillboardGui")
            gui.Name = "ESP_Text"
            gui.Adornee = root
            gui.AlwaysOnTop = true
            gui.Size = UDim2.new(0, 100, 0, 40)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.Parent = root

            local lbl = Instance.new("TextLabel")
            lbl.Name = "ESP_Label"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "🖕"
            lbl.TextColor3 = Color3.new(1, 1, 0)
            lbl.TextScaled = true
            lbl.Font = Enum.Font.SourceSansBold
            lbl.Visible = true
            lbl.Parent = gui
        end
    end
end

local function removeESP(model)
    if model:IsA("Model") and targetNames[model.Name] then
        local root = model:FindFirstChild("RootPart")
        if root then
            local esp = root:FindFirstChild("ESP_Text")
            if esp then esp:Destroy() end
        end
    end
end

local function updateESPVisibility()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local playerPos = char.HumanoidRootPart.Position
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and targetNames[obj.Name] then
            local root = obj:FindFirstChild("RootPart")
            if root then
                local gui = root:FindFirstChild("ESP_Text")
                if gui and gui:FindFirstChild("ESP_Label") then
                    local dist = (root.Position - playerPos).Magnitude
                    gui.ESP_Label.Visible = dist > 80
                end
            end
        end
    end
end

local function enableESP()
    local count = 0
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and targetNames[obj.Name] then count += 1 end
        createESP(obj)
    end
    table.insert(espConnections, workspace.ChildAdded:Connect(function(obj)
        task.wait(0.1)
        createESP(obj)
    end))
    table.insert(espConnections, RunService.RenderStepped:Connect(updateESPVisibility))
    StarterGui:SetCore("SendNotification", {
        Title = "ESP Target",
        Text = count > 0 and ("✅ " .. count .. " targets found") or "❌ No targets found",
        Duration = 3
    })
end

local function disableESP()
    for _, conn in pairs(espConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    espConnections = {}
    for _, obj in pairs(workspace:GetChildren()) do removeESP(obj) end
end

-- ========================================
-- ESP ENEMY (PLAYERS) FUNCTIONS
-- ========================================
local function createEnemyESP(player)
    if player == plr then return end
    
    local function addESP(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        
        if hrp:FindFirstChild("ESP_Enemy") then return end
        
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESP_Enemy"
        gui.Adornee = hrp
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 200, 0, 50)
        gui.StudsOffset = Vector3.new(0, 2, 0)
        gui.Parent = hrp
        
        local lbl = Instance.new("TextLabel")
        lbl.Name = "ESP_EnemyLabel"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = player.Name
        lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextStrokeTransparency = 0.5
        lbl.Parent = gui
        
        -- Update distance
        task.spawn(function()
            while lbl.Parent and espEnemyEnabled do
                task.wait(0.5)
                local myChar = plr.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - myChar.HumanoidRootPart.Position).Magnitude
                    lbl.Text = player.Name .. "\n[" .. math.floor(dist) .. "m]"
                end
            end
        end)
    end
    
    if player.Character then
        addESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        if espEnemyEnabled then
            addESP(char)
        end
    end)
end

local function removeEnemyESP(player)
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local esp = hrp:FindFirstChild("ESP_Enemy")
            if esp then esp:Destroy() end
        end
    end
end

local function enableEnemyESP()
    local count = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            count += 1
            createEnemyESP(player)
        end
    end
    
    table.insert(espEnemyConnections, Players.PlayerAdded:Connect(function(player)
        if espEnemyEnabled then
            createEnemyESP(player)
        end
    end))
    
    StarterGui:SetCore("SendNotification", {
        Title = "ESP Enemies",
        Text = count > 0 and ("✅ " .. count .. " enemies found") or "❌ No enemies found",
        Duration = 3
    })
end

local function disableEnemyESP()
    for _, conn in pairs(espEnemyConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    espEnemyConnections = {}
    for _, player in pairs(Players:GetPlayers()) do
        removeEnemyESP(player)
    end
end

-- ========================================
-- SPEED BOOST FUNCTIONS
-- ========================================
local function startSpeed()
    if speedConn then speedConn:Disconnect() end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    speedConn = RunService.Heartbeat:Connect(function(delta)
        speedLastUpdate += delta
        if speedLastUpdate < 0.03 then return end
        speedLastUpdate = 0
        if speedEnabled and hum and hrp then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = moveDir * SPEED_VALUE + Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            end
        end
    end)
end

local function stopSpeed()
    if speedConn then speedConn:Disconnect() speedConn = nil end
end

-- ========================================
-- AUTO SHOOT FUNCTIONS
-- ========================================
local function getNearestPlayer()
    local nearest, shortestDist = nil, math.huge
    local char = plr.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - other.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 70 and dist < shortestDist then
                shortestDist = dist
                nearest = other
            end
        end
    end
    return nearest
end

local function startAutoShoot()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    
    autoShootConn = RunService.Heartbeat:Connect(function()
        if autoShootEnabled then
            local backpack = plr:FindFirstChild("Backpack")
            local tool = backpack and backpack:FindFirstChild("Laser Cape")
            if tool then
                hum:EquipTool(tool)
                tool.Parent = char
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(0.05) do
            if autoShootEnabled then
                local target = getNearestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = target.Character.HumanoidRootPart.Position
                    pcall(function()
                        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
                        Net:RemoteEvent("UseItem"):FireServer(pos, target.Character.HumanoidRootPart)
                    end)
                end
            end
        end
    end)
end

local function stopAutoShoot()
    if autoShootConn then autoShootConn:Disconnect() autoShootConn = nil end
    local char = plr.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum:UnequipTools() end
    end
end

-- ========================================
-- JUMP BOOST FUNCTIONS (Always active, no start/stop)
-- ========================================
RunService.Heartbeat:Connect(function()
    if jumpBoostHolding then
        local elapsed = tick() - jumpBoostStart
        local remaining = math.max(0, MAX_JUMP_TIME - elapsed)
        if remaining <= 0 then
            jumpBoostHolding = false
            return
        end
        local char = plr.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, JUMP_LIFT, vel.Z)
            end
        end
    end
end)

-- ========================================
-- CREATE TOGGLES
-- ========================================
local function createToggle(name, callback)
    local toggled = savedData[name] or false
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 8)
    tCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 50, 0, 24)
    sliderBg.Position = UDim2.new(1, -60, 0.5, -12)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = toggleFrame
    
    local sBgCorner = Instance.new("UICorner")
    sBgCorner.CornerRadius = UDim.new(0, 12)
    sBgCorner.Parent = sliderBg
    
    local sliderBtn = Instance.new("Frame")
    sliderBtn.Size = UDim2.new(0, 20, 0, 20)
    sliderBtn.Position = UDim2.new(0, 2, 0, 2)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    local sBtnCorner = Instance.new("UICorner")
    sBtnCorner.CornerRadius = UDim.new(0, 10)
    sBtnCorner.Parent = sliderBtn
    
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local function updateSlider()
        local targetPos, bgColor, btnColor
        if toggled then
            targetPos = UDim2.new(0, 28, 0, 2)
            bgColor = Color3.fromRGB(76, 175, 80)
            btnColor = Color3.fromRGB(255, 255, 255)
        else
            targetPos = UDim2.new(0, 2, 0, 2)
            bgColor = Color3.fromRGB(80, 80, 80)
            btnColor = Color3.fromRGB(200, 200, 200)
        end
        TweenService:Create(sliderBtn, tweenInfo, {Position = targetPos}):Play()
        TweenService:Create(sliderBg, tweenInfo, {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(sliderBtn, tweenInfo, {BackgroundColor3 = btnColor}):Play()
    end
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleFrame
    
    clickDetector.MouseButton1Click:Connect(function()
        toggled = not toggled
        savedData[name] = toggled
        SaveToggles()
        updateSlider()
        if callback then callback(toggled) end
    end)
    
    updateSlider()
    if callback then callback(toggled) end
end

-- Create all toggles
createToggle("ESP Brainrot", function(state)
    espEnabled = state
    if state then
        enableESP()
    else
        disableESP()
    end
end)

createToggle("ESP Enemies", function(state)
    espEnemyEnabled = state
    if state then
        enableEnemyESP()
    else
        disableEnemyESP()
    end
end)

createToggle("Speed Boost", function(state)
    speedEnabled = state
    if state then
        startSpeed()
    else
        stopSpeed()
    end
end)

createToggle("Auto Shoot", function(state)
    autoShootEnabled = state
    if state then
        startAutoShoot()
    else
        stopAutoShoot()
    end
end)

createToggle("Jump Boost", function(state)
    -- Jump boost uses hold mechanic, just enable/disable holding
    if not state then
        jumpBoostHolding = false
    end
end)

-- Add hold button for Jump Boost
local jumpFrame = Instance.new("Frame")
jumpFrame.Size = UDim2.new(1, 0, 0, 50)
jumpFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpFrame.BorderSizePixel = 0
jumpFrame.Parent = scrollFrame

local jCorner = Instance.new("UICorner")
jCorner.CornerRadius = UDim.new(0, 8)
jCorner.Parent = jumpFrame

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(1, -20, 1, -10)
jumpBtn.Position = UDim2.new(0, 10, 0, 5)
jumpBtn.Text = "HOLD TO JUMP"
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 16
jumpBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.BorderSizePixel = 0
jumpBtn.Parent = jumpFrame

local jBtnCorner = Instance.new("UICorner")
jBtnCorner.CornerRadius = UDim.new(0, 6)
jBtnCorner.Parent = jumpBtn

jumpBtn.MouseButton1Down:Connect(function()
    if savedData["Jump Boost"] then
        jumpBoostHolding = true
        jumpBoostStart = tick()
    end
end)

jumpBtn.MouseButton1Up:Connect(function()
    jumpBoostHolding = false
end)

-- Toggle GUI visibility
local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

closeButton.MouseButton1Click:Connect(function()
    isOpen = false
    mainFrame.Visible = false
end)

-- Respawn handling
plr.CharacterAdded:Connect(function()
    task.wait(1)
    if speedEnabled then startSpeed() end
    if autoShootEnabled then startAutoShoot() end
end)

print("✅ Brainrot Hub Loaded!")
print("🎮 Features: ESP Brainrot, ESP Enemies, Speed Boost, Auto Shoot, Jump Boost")
