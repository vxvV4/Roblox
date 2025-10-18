-- TWEENING (Smooth Animations)
-- Make things move smoothly instead of instantly

local TweenService = game:GetService("TweenService")

-- BASIC TWEEN
local part = workspace.Part

-- Create tween info
local tweenInfo = TweenInfo.new(
    2, -- duration in seconds
    Enum.EasingStyle.Quad, -- animation style
    Enum.EasingDirection.Out, -- easing direction
    0, -- repeat count (0 = no repeat, -1 = infinite)
    false, -- reverse after finishing?
    0 -- delay before starting
)

-- What to animate
local goal = {
    Position = Vector3.new(0, 10, 0),
    Size = Vector3.new(10, 10, 10),
    Transparency = 0.5,
    Color = Color3.fromRGB(255, 0, 0)
}

-- Create and play tween
local tween = TweenService:Create(part, tweenInfo, goal)
tween:Play()

-- TWEEN EVENTS
tween.Completed:Connect(function(playbackState)
    if playbackState == Enum.PlaybackState.Completed then
        print("Tween finished!")
    end
end)

-- CONTROL TWEENS
tween:Play() -- start
tween:Pause() -- pause
tween:Cancel() -- stop and reset
tween:Destroy() -- clean up

-- EASING STYLES (how animation moves)
local styles = {
    Enum.EasingStyle.Linear, -- constant speed
    Enum.EasingStyle.Quad, -- smooth acceleration
    Enum.EasingStyle.Cubic, -- more dramatic
    Enum.EasingStyle.Quart, -- even more dramatic
    Enum.EasingStyle.Bounce, -- bouncy effect
    Enum.EasingStyle.Elastic, -- elastic/springy
    Enum.EasingStyle.Sine, -- gentle curve
    Enum.EasingStyle.Back, -- overshoots then comes back
    Enum.EasingStyle.Exponential, -- very dramatic
}

-- EASING DIRECTIONS
local directions = {
    Enum.EasingDirection.In, -- slow start, fast end
    Enum.EasingDirection.Out, -- fast start, slow end
    Enum.EasingDirection.InOut, -- slow start and end
}

-- COMMON TWEEN PATTERNS

-- Move part smoothly
local function movePart(part, targetPos)
    local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Position = targetPos}
    local tween = TweenService:Create(part, info, goal)
    tween:Play()
    return tween
end

-- Fade in
local function fadeIn(object)
    local info = TweenInfo.new(0.5)
    local goal = {Transparency = 0}
    TweenService:Create(object, info, goal):Play()
end

-- Fade out
local function fadeOut(object)
    local info = TweenInfo.new(0.5)
    local goal = {Transparency = 1}
    TweenService:Create(object, info, goal):Play()
end

-- Scale up/down
local function scaleObject(object, targetSize)
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local goal = {Size = targetSize}
    TweenService:Create(object, info, goal):Play()
end

-- Rotate object
local function rotateObject(object, degrees)
    local info = TweenInfo.new(1)
    local goal = {Orientation = Vector3.new(0, degrees, 0)}
    TweenService:Create(object, info, goal):Play()
end

-- GUI TWEENING

-- Button hover effect
local button = script.Parent

button.MouseEnter:Connect(function()
    local info = TweenInfo.new(0.2)
    local goal = {Size = UDim2.new(0, 160, 0, 50)} -- bigger
    TweenService:Create(button, info, goal):Play()
end)

button.MouseLeave:Connect(function()
    local info = TweenInfo.new(0.2)
    local goal = {Size = UDim2.new(0, 150, 0, 40)} -- normal size
    TweenService:Create(button, info, goal):Play()
end)

-- Slide in GUI from side
local frame = script.Parent
local info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local goal = {Position = UDim2.new(0.5, 0, 0.5, 0)} -- center
TweenService:Create(frame, info, goal):Play()

-- Fade in GUI
local screenGui = script.Parent
for _, gui in pairs(screenGui:GetDescendants()) do
    if gui:IsA("GuiObject") then
        gui.Transparency = 1
        local info = TweenInfo.new(1)
        local goal = {BackgroundTransparency = 0}
        TweenService:Create(gui, info, goal):Play()
    end
end

-- CHAINING TWEENS (one after another)
local function chainTweens()
    local part = workspace.Part
    
    -- First tween
    local tween1 = TweenService:Create(
        part,
        TweenInfo.new(1),
        {Position = Vector3.new(10, 5, 0)}
    )
    
    -- Second tween
    local tween2 = TweenService:Create(
        part,
        TweenInfo.new(1),
        {Position = Vector3.new(10, 5, 10)}
    )
    
    -- Play first, then second
    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
    end)
end

-- LOOPING TWEEN
local function createLoopingTween(object)
    local info = TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1, -- infinite repeats
        true -- reverse (goes back and forth)
    )
    local goal = {Position = Vector3.new(0, 10, 0)}
    TweenService:Create(object, info, goal):Play()
end

-- HUMANOID ANIMATIONS (different from tweening)
local humanoid = game.Players.LocalPlayer.Character.Humanoid
local animator = humanoid:WaitForChild("Animator")

-- Load animation
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://12345678"
local track = animator:LoadAnimation(anim)

-- Play animation
track:Play()
track:Stop()
track:AdjustSpeed(2) -- play faster

-- COLOR TWEENING
local function rainbowPart(part)
    local colors = {
        Color3.fromRGB(255, 0, 0), -- red
        Color3.fromRGB(255, 127, 0), -- orange
        Color3.fromRGB(255, 255, 0), -- yellow
        Color3.fromRGB(0, 255, 0), -- green
        Color3.fromRGB(0, 0, 255), -- blue
        Color3.fromRGB(75, 0, 130), -- indigo
        Color3.fromRGB(148, 0, 211), -- violet
    }
    
    local function tweenToNextColor(index)
        local nextIndex = (index % #colors) + 1
        local info = TweenInfo.new(1)
        local goal = {Color = colors[nextIndex]}
        local tween = TweenService:Create(part, info, goal)
        
        tween.Completed:Connect(function()
            tweenToNextColor(nextIndex)
        end)
        
        tween:Play()
    end
    
    tweenToNextColor(1)
end

-- WAIT FOR TWEEN TO FINISH
local tween = TweenService:Create(part, TweenInfo.new(2), {Position = Vector3.new(0, 10, 0)})
tween:Play()
tween.Completed:Wait() -- waits until tween finishes
print("Tween done!")
