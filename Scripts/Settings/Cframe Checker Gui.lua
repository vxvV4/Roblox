-- // Gui Maker ,\\ --
local G = Instance.new("ScreenGui", game.CoreGui)
local M = Instance.new("Frame", G)
M.Size = UDim2.new(0, 200, 0, 30)
M.Position = UDim2.new(0, 10, 0.5, -15)
M.BackgroundColor3 = Color3.new(0, 0, 0)
M.BorderSizePixel = 0
M.Active = true

--  // Title Bar \\ --
local TB = Instance.new("Frame", M)
TB.Size = UDim2.new(1, 0, 0, 30)
TB.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
TB.BorderSizePixel = 0

local T = Instance.new("TextLabel", TB)
T.Size = UDim2.new(1, -60, 1, 0)
T.Position = UDim2.new(0, 5, 0, 0)
T.BackgroundTransparency = 1
T.Text = "GUI" -- // Depends on you what's title you want kiddo ;) \\ --
T.TextColor3 = Color3.new(1, 1, 1)
T.TextSize = 12
T.Font = Enum.Font.GothamBold
T.TextXAlignment = Enum.TextXAlignment.Left

-- // the collapsible \\ --
local H = Instance.new("TextButton", TB)
H.Size = UDim2.new(0, 30, 0, 30)
H.Position = UDim2.new(1, -30, 0, 0)
H.BackgroundTransparency = 1
H.Text = "-"
H.TextColor3 = Color3.new(1, 1, 1)
H.TextSize = 18
H.Font = Enum.Font.GothamBold

-- // Content \\ --
local C = Instance.new("Frame", M)
C.Size = UDim2.new(1, 0, 1, -30)
C.Position = UDim2.new(0, 0, 0, 30)
C.BackgroundTransparency = 1
C.BorderSizePixel = 0

local L = Instance.new("UIListLayout", C)
L.Padding = UDim.new(0, 3)

local P = Instance.new("UIPadding", C)
P.PaddingTop = UDim.new(0, 3)
P.PaddingLeft = UDim.new(0, 3)
P.PaddingRight = UDim.new(0, 3)
P.PaddingBottom = UDim.new(0, 3)

-- // This Will Auto resize based On Elements Added \\ --
L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    M.Size = UDim2.new(0, 200, 0, C.Visible and (L.AbsoluteContentSize.Y + 36) or 30)
end)

--  // Hide/Show \\ --
local vis = true
H.MouseButton1Click:Connect(function()
    vis = not vis
    C.Visible = vis
    H.Text = vis and "-" or "+"
    M.Size = UDim2.new(0, 200, 0, vis and (L.AbsoluteContentSize.Y + 36) or 30)
end)

-- // Don't fucking remove this important to drag \\ --
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

-- //  Button \\ --
function BtnZ(txt, cb)
    local b = Instance.new("TextButton", C)
    b.Size = UDim2.new(1, -6, 0, 25)
    b.BackgroundColor3 = Color3.new(0.78, 0, 0)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
end

BtnZ("Button 1", function() 
setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.Position))
end)
