local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript",
    Icon = "rbxassetid://29819383",
    Duration = 2,
})

local ShiftLockGui = Instance.new("ScreenGui")
local ShiftLock = Instance.new("ImageButton")

ShiftLockGui.Parent = game.CoreGui

ShiftLock.Parent = ShiftLockGui
ShiftLock.BackgroundColor3 = Color3.new(0,0,0)
ShiftLock.BackgroundTransparency = 1
ShiftLock.Position = UDim2.new(0.955, 0, 0.42, 0)
ShiftLock.Image = "rbxasset://textures/ui/mouseLock_off.png"
ShiftLock.Size = UDim2.new(0.04,0,0.08)
ShiftLock.Draggable = false

ShiftLockMode = false
ShiftLock.MouseButton1Click:connect(function()
if ShiftLockMode == false then
ShiftLockMode = true
ShiftLock.Image = "rbxasset://textures/ui/mouseLock_on.png"
else
ShiftLockMode = false
ShiftLock.Image = "rbxasset://textures/ui/mouseLock_off.png"
end
end)

game:GetService('RunService').RenderStepped:connect(function()
if ShiftLockMode == true then
local root = game.Players.LocalPlayer.Character.HumanoidRootPart
local camera = workspace.CurrentCamera
local MAX_LENGTH = 900000

local function GetUpdatedCameraCFrame(ROOT, CAMERA)
return CFrame.new(root.Position, Vector3.new(CAMERA.CFrame.LookVector.X * MAX_LENGTH, root.Position.Y, CAMERA.CFrame.LookVector.Z * MAX_LENGTH))
end

root.CFrame = GetUpdatedCameraCFrame(root, camera)
end
end)
