local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button = Instance.new("TextButton")
local Label = Instance.new("TextLabel")
local UICorner_Frame = Instance.new("UICorner")
local UICorner_Button = Instance.new("UICorner")
local UICorner_Label = Instance.new("UICorner")

ScreenGui.Name = "DeliveryTouchGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -70, 0.5, -45)
Frame.Size = UDim2.new(0, 140, 0, 90)
Frame.Active = true
Frame.Draggable = true
UICorner_Frame.CornerRadius = UDim.new(0, 10)
UICorner_Frame.Parent = Frame

Label.Parent = Frame
Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Size = UDim2.new(0, 120, 0, 25)
Label.Font = Enum.Font.GothamBold
Label.Text = "No Target"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 12
UICorner_Label.CornerRadius = UDim.new(0, 8)
UICorner_Label.Parent = Label

Button.Parent = Frame
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.Position = UDim2.new(0, 10, 0, 50)
Button.Size = UDim2.new(0, 120, 0, 30)
Button.Font = Enum.Font.GothamBold
Button.Text = "Auto Laser: OFF"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 12
Button.TextWrapped = true
UICorner_Button.CornerRadius = UDim.new(0, 8)
UICorner_Button.Parent = Button

local ENABLED = false
local MAX_RANGE = 70

local function getNearestPlayer()
    local nearest = nil
    local shortestDist = math.huge
    local char = plr.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, other in pairs(Players:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - other.Character.HumanoidRootPart.Position).Magnitude
            if dist <= MAX_RANGE and dist < shortestDist then
                shortestDist = dist
                nearest = other
            end
        end
    end
    return nearest
end

local function autoEquip()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    RunService.Heartbeat:Connect(function()
        if ENABLED then
            local backpack = plr:FindFirstChild("Backpack")
            local tool = backpack and backpack:FindFirstChild("Laser Cape")
            if tool then
                humanoid:EquipTool(tool)
                tool.Parent = char
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.05) do
            if ENABLED then
                local targetPlayer = getNearestPlayer()
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = targetPlayer.Character.HumanoidRootPart.Position
                    pcall(function()
                        Net:RemoteEvent("UseItem"):FireServer(pos, targetPlayer.Character.HumanoidRootPart)
                    end)
                end
            end
        end
    end)
end

autoEquip()
plr.CharacterAdded:Connect(autoEquip)

task.spawn(function()
    while task.wait(0.1) do
        if ENABLED then
            local nearest = getNearestPlayer()
            if nearest then
                Label.Text = nearest.Name
            else
                Label.Text = "No target"
            end
        else
            Label.Text = "No target"
        end
    end
end)

Button.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    local char = plr.Character
    local humanoid = char and char:FindFirstChild("Humanoid")

    if ENABLED then
        Button.Text = "Auto Laser: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
    else
        Button.Text = "Auto Laser: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Label.Text = "No target"
        
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end)

print("✅ GUI + Auto-equip + Aimbot Laser Cape aktif dengan Label target saat ON")
