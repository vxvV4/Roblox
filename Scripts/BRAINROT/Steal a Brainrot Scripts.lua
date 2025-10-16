-- By Shizo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "ProfessionalBoostGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 138, 0, 60) 
mainFrame.Position = UDim2.new(0.80, -69, 0.60, 0) 
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5 
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 2
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local boostButton = Instance.new("TextButton")
boostButton.Size = UDim2.new(1, -8, 0.65, 0)
boostButton.Position = UDim2.new(0, 4, 0, 4)
boostButton.Text = "BOOST"
boostButton.TextScaled = true
boostButton.Font = Enum.Font.GothamBold
boostButton.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
boostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
boostButton.BorderSizePixel = 0
boostButton.ZIndex = 3
boostButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = boostButton

local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(1, -8, 0.2, 0)
progressContainer.Position = UDim2.new(0, 4, 0.75, 0)
progressContainer.BackgroundColor3 = Color3.fromRGB(229, 231, 235)
progressContainer.BorderSizePixel = 0
progressContainer.ZIndex = 3
progressContainer.Parent = mainFrame

local progressContainerCorner = Instance.new("UICorner")
progressContainerCorner.CornerRadius = UDim.new(0, 6)
progressContainerCorner.Parent = progressContainer

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(1, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(34, 157, 94)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 4
progressBar.Parent = progressContainer

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 6)
progressCorner.Parent = progressBar

local originalButtonColor = boostButton.BackgroundColor3
local hoverColor = Color3.fromRGB(37, 99, 235)
local activeColor = Color3.fromRGB(29, 78, 216)

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

local holdingBoost = false
local boostStartTime = 0
local progressTween = nil

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

RunService.Heartbeat:Connect(function()
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
