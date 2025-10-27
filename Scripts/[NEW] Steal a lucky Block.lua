local ThemeZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/GUI%20MAKER/ThemeZ%20for%20SourceV3.lua"))()

-- Set your desired theme
ThemeZ:SetTheme("Rainbow") -- Options: Rainbow, Dark, Blue, Purple, Cyan, Green, Light

-- Mini Box GUI
local G = Instance.new("ScreenGui", game.CoreGui)
G.Name = "ThemedGUI"

local M = Instance.new("Frame", G)
M.Name = "Frame"
M.Size = UDim2.new(0, 200, 0, 30)
M.Position = UDim2.new(0.5, -100, 0.5, -15)
M.AnchorPoint = Vector2.new(0.5, 0.5)
M.BackgroundColor3 = ThemeZ.CurrentTheme.MainBackground
M.BorderSizePixel = 0
M.Active = true

-- Title Bar
local TB = Instance.new("Frame", M)
TB.Name = "TB"
TB.Size = UDim2.new(1, 0, 0, 30)
TB.BackgroundColor3 = ThemeZ.CurrentTheme.TitleBar
TB.BorderSizePixel = 0

local T = Instance.new("TextLabel", TB)
T.Name = "T"
T.Size = UDim2.new(1, -60, 1, 0)
T.Position = UDim2.new(0, 5, 0, 0)
T.BackgroundTransparency = 1
T.Text = "YouTube: ShizoScript"
T.TextColor3 = ThemeZ.CurrentTheme.TextPrimary
T.TextSize = 12
T.Font = Enum.Font.GothamBold
T.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
local H = Instance.new("TextButton", TB)
H.Name = "H"
H.Size = UDim2.new(0, 30, 0, 30)
H.Position = UDim2.new(1, -30, 0, 0)
H.BackgroundTransparency = 1
H.Text = "-"
H.TextColor3 = ThemeZ.CurrentTheme.TextPrimary
H.TextSize = 18
H.Font = Enum.Font.GothamBold

-- Content
local C = Instance.new("Frame", M)
C.Name = "C"
C.Size = UDim2.new(1, 0, 1, -30)
C.Position = UDim2.new(0, 0, 0, 30)
C.BackgroundTransparency = 1
C.BorderSizePixel = 0

local L = Instance.new("UIListLayout", C)
L.Padding = UDim.new(0, 3)
L.HorizontalAlignment = Enum.HorizontalAlignment.Center

local P = Instance.new("UIPadding", C)
P.PaddingTop = UDim.new(0, 3)
P.PaddingLeft = UDim.new(0, 3)
P.PaddingRight = UDim.new(0, 3)
P.PaddingBottom = UDim.new(0, 3)

-- Auto resize
L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    M.Size = UDim2.new(0, 200, 0, C.Visible and (L.AbsoluteContentSize.Y + 36) or 30)
end)

-- Hide/Show
local vis = true
H.MouseButton1Click:Connect(function()
    vis = not vis
    C.Visible = vis
    H.Text = vis and "-" or "+"
    M.Size = UDim2.new(0, 200, 0, vis and (L.AbsoluteContentSize.Y + 36) or 30)
end)

-- Drag
local d, di, ds, sp
TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        d, ds, sp = true, i.Position, M.Position
    end
end)
TB.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
end)
TB.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end
end)
game:GetService("UserInputService").InputChanged:Connect(function(i)
    if i == di and d then
        local delta = i.Position - ds
        M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end
end)

-- Button
function Btn(txt, cb)
    local b = Instance.new("TextButton", C)
    b.Size = UDim2.new(1, -6, 0, 25)
    b.BackgroundColor3 = ThemeZ.CurrentTheme.ButtonBackground
    b.Text = txt
    b.TextColor3 = ThemeZ.CurrentTheme.ButtonText
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
    
    ThemeZ:AddCorner(b)
    if ThemeZ.CurrentTheme.UseRainbow then
        ThemeZ:AddRainbowGradient(b)
    end
end

-- Toggle
function Tog(txt, def, cb)
    local f = Instance.new("Frame", C)
    f.Size = UDim2.new(1, -6, 0, 25)
    f.BackgroundColor3 = ThemeZ.CurrentTheme.ContentBackground
    f.BorderSizePixel = 0
    ThemeZ:AddCorner(f)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -35, 1, 0)
    l.Position = UDim2.new(0, 3, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = ThemeZ.CurrentTheme.TextPrimary
    l.TextSize = 10
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 25, 0, 18)
    b.Position = UDim2.new(1, -28, 0.5, -9)
    b.BackgroundColor3 = def and ThemeZ.CurrentTheme.ToggleOn or ThemeZ.CurrentTheme.ToggleOff
    b.Text = ""
    b.BorderSizePixel = 0
    ThemeZ:AddCorner(b)
    
    local on = def
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and ThemeZ.CurrentTheme.ToggleOn or ThemeZ.CurrentTheme.ToggleOff
        cb(on)
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

Btn("Invisible", function() 
    local INVISIBILITY_POSITION = Vector3.new(-25.95, 84, 3537.55)
    
    if not player.Character then
        warn("Character not found")
        return
    end

    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("HumanoidRootPart not found")
        return
    end

    local savedPosition = humanoidRootPart.CFrame

    player.Character:MoveTo(INVISIBILITY_POSITION)
    task.wait(0.15)

    local seat = Instance.new("Seat")
    seat.Name = "invischair"
    seat.Anchored = false
    seat.CanCollide = false
    seat.Transparency = 1
    seat.Position = INVISIBILITY_POSITION
    seat.Parent = workspace

    local weld = Instance.new("Weld")
    weld.Part0 = seat
    weld.Part1 = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    weld.Parent = seat

    task.wait()
    seat.CFrame = savedPosition

    for _, descendant in player.Character:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            descendant.Transparency = 0.5
        end
    end
end)

Btn("Off Invisible", function() 
    local invisChair = workspace:FindFirstChild("invischair")
    if invisChair then
        invisChair:Destroy()
    end

    if player.Character then
        for _, descendant in player.Character:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.Transparency = 0
            end
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Transparency = 1
        end
    end
    
    print("Visibility restored!")
end)

local autoUpGui = nil
local autoUpEnabled = false
local holdingBoost = false
local boostStartTime = 0
local progressTween = nil
local heartbeatConnection = nil

Tog("Auto Up", false, function(state)
    autoUpEnabled = state
    
    if state then
        
        autoUpGui = Instance.new("ScreenGui")
        autoUpGui.ResetOnSpawn = false
        autoUpGui.Name = "PixelRedBoostGUI"
        autoUpGui.Parent = game.CoreGui
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 138, 0, 60) 
        mainFrame.Position = UDim2.new(0.80, -69, 0.60, 0) 
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0) 
        mainFrame.BackgroundTransparency = 0
        mainFrame.BorderSizePixel = 3
        mainFrame.BorderColor3 = Color3.fromRGB(139, 0, 0)
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.ZIndex = 2
        mainFrame.Parent = autoUpGui
        
        local boostButton = Instance.new("TextButton")
        boostButton.Size = UDim2.new(1, -8, 0.65, 0)
        boostButton.Position = UDim2.new(0, 4, 0, 4)
        boostButton.Text = "BOOST"
        boostButton.TextScaled = true
        boostButton.Font = Enum.Font.Code 
        boostButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
        boostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        boostButton.BorderSizePixel = 2
        boostButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
        boostButton.ZIndex = 3
        boostButton.Parent = mainFrame
        
        local progressContainer = Instance.new("Frame")
        progressContainer.Size = UDim2.new(1, -8, 0.2, 0)
        progressContainer.Position = UDim2.new(0, 4, 0.75, 0)
        progressContainer.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        progressContainer.BorderSizePixel = 2
        progressContainer.BorderColor3 = Color3.fromRGB(139, 0, 0)
        progressContainer.ZIndex = 3
        progressContainer.Parent = mainFrame
        
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(1, 0, 1, 0)
        progressBar.Position = UDim2.new(0, 0, 0, 0)
        progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
        progressBar.BorderSizePixel = 0
        progressBar.ZIndex = 4
        progressBar.Parent = progressContainer
        
        local originalButtonColor = boostButton.BackgroundColor3
        local hoverColor = Color3.fromRGB(220, 20, 60)
        local activeColor = Color3.fromRGB(139, 0, 0) 
        
        local hoverTweenIn = TweenService:Create(
            boostButton,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = hoverColor}
        )
        
        local hoverTweenOut = TweenService:Create(
            boostButton,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = originalButtonColor}
        )
        
        boostButton.MouseEnter:Connect(function()
            if not holdingBoost then
                hoverTweenIn:Play()
            end
        end)
        
        boostButton.MouseLeave:Connect(function()
            if not holdingBoost then
                hoverTweenOut:Play()
            end
        end)
        
        local LIFT_SPEED = 20
        local MAX_JUMP_TIME = 5
        
        local function animateProgress(targetSize)
            if progressTween then
                progressTween:Cancel()
            end
            
            progressTween = TweenService:Create(
                progressBar,
                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {Size = targetSize}
            )
            progressTween:Play()
        end
        
        local pressEffect = TweenService:Create(
            boostButton,
            TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = activeColor}
        )
        
        local releaseEffect = TweenService:Create(
            boostButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = originalButtonColor}
        )
        
        boostButton.MouseButton1Down:Connect(function()
            holdingBoost = true
            boostStartTime = tick()
            pressEffect:Play()
        end)
        
        boostButton.MouseButton1Up:Connect(function()
            holdingBoost = false
            releaseEffect:Play()
        end)
        
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - boostStartTime
        
            if holdingBoost then
                local remaining = math.max(0, MAX_JUMP_TIME - elapsed)
                local ratio = remaining / MAX_JUMP_TIME
                animateProgress(UDim2.new(ratio, 0, 1, 0))
        
                if remaining <= 0 then
                    holdingBoost = false
                    animateProgress(UDim2.new(0, 0, 1, 0))
                    return
                end
        
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local vel = hrp.AssemblyLinearVelocity
                        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, LIFT_SPEED, vel.Z)
                    end
                end
            else
                animateProgress(UDim2.new(1, 0, 1, 0))
            end
        end)
        
    else
        
        if autoUpGui then
            autoUpGui:Destroy()
            autoUpGui = nil
        end
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        holdingBoost = false
    end
end)
