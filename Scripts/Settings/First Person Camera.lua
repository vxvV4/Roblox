--First Person Camera Function
local function Active()
local player = game.Players.LocalPlayer
local char = player.Character

char.Humanoid.CameraOffset = Vector3.new(0, 0, -1)

for i, v in pairs(char:GetChildren()) do if v:IsA("BasePart") and v.Name ~= "Head" then
    v:GetPropertyChangedSignal("LocalTransparencyModifier"):connect(function()
    v.LocalTransparencyModifier = v.Transparency 
end)
    v.LocalTransparencyModifier = v.Transparency
end
game.Players.LocalPlayer.CameraMaxZoomDistance = -1
game.Players.LocalPlayer.CameraMinZoomDistance = -1
end


local ray = Ray.new(char.Head.Position,((char.Head.CFrame + char.Head.CFrame.LookVector * 2) - char.Head. Position).Position.Unit)
local ignoreList = char:GetChildren()
local hit, pos = game.Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

if hit then
char.Humanoid.CameraOffset = Vector3.new(0, 0,-(char.Head.Position - pos).magnitude)
else
char.Humanoid.CameraOffset = Vector3.new(0, 0, -1)
end
end
--



Active()
DeathOperator = false
game:GetService('RunService').Heartbeat:connect(function()
if DeathOperator == false and game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
DeathOperator = true
end
if DeathOperator == true and game.Players.LocalPlayer.Character.HumanoidRootPart and game.Players.LocalPlayer.Character.Humanoid.Health >= 1 then
DeathOperator = false
wait(0.1)
game.Players.LocalPlayer.CameraMaxZoomDistance = 1
game.Players.LocalPlayer.CameraMinZoomDistance = 1
Active()
end
end)
