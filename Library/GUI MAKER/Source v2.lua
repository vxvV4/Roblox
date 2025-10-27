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

-- // Toggle \\ --
function TogZ(txt, def, cb)
    local f = Instance.new("Frame", C)
    f.Size = UDim2.new(1, -6, 0, 25)
    f.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    f.BorderSizePixel = 0
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -35, 1, 0)
    l.Position = UDim2.new(0, 3, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 10
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 25, 0, 18)
    b.Position = UDim2.new(1, -28, 0.5, -9)
    b.BackgroundColor3 = def and Color3.new(0, 0.78, 0) or Color3.new(0.3, 0.3, 0.3)
    b.Text = ""
    b.BorderSizePixel = 0
    
    local on = def
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.new(0, 0.78, 0) or Color3.new(0.3, 0.3, 0.3)
        cb(on)
    end)
end

-- // Paragraph \\ --
function ParZ(txt)
    local l = Instance.new("TextLabel", C)
    l.Size = UDim2.new(1, -6, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextWrapped = true
    l.AutomaticSize = Enum.AutomaticSize.Y
end

-- // TextBox \\ --
function BoxZ(txt, ph, cb)
    local f = Instance.new("Frame", C)
    f.Size = UDim2.new(1, -6, 0, 40)
    f.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    f.BorderSizePixel = 0
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -6, 0, 15)
    l.Position = UDim2.new(0, 3, 0, 2)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextBox", f)
    b.Size = UDim2.new(1, -6, 0, 20)
    b.Position = UDim2.new(0, 3, 0, 18)
    b.BackgroundColor3 = Color3.new(0, 0, 0)
    b.PlaceholderText = ph
    b.Text = ""
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.FocusLost:Connect(function() cb(b.Text) end)
end

-- Examples --
ParZ("Welcome!")
BtnZ("Button 1", function() print("1") end)
TogZ("Toggle 1", false, function(v) print(v) end)
BoxZ("Input", "Enter text...", function(v) print(v) end)
BtnZ("Button 2", function() print("2") end)

--[[
===  // CUSTOMIZATION TIPS IF YOU NEEDES \\ --===

CHANGING COLORS:
- Main background: M.BackgroundColor3 = Color3.new(0, 0, 0)
- Title bar: TB.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
- Button color: b.BackgroundColor3 = Color3.new(0.78, 0, 0)
- Toggle ON: Color3.new(0, 0.78, 0)
- Toggle OFF: Color3.new(0.3, 0.3, 0.3)

SIZING:
- Width: M.Size = UDim2.new(0, 200, ...)
- Button height: b.Size = UDim2.new(1, -6, 0, 25)
- Padding: L.Padding = UDim.new(0, 3)

POSITION:
- Left: M.Position = UDim2.new(0, 10, 0.5, -15)
- Right: M.Position = UDim2.new(1, -210, 0.5, -15)
- Center: M.Position = UDim2.new(0.5, -100, 0.5, -15)

ADDING ELEMENTS:
BtnZ("Name", function() code end)
TogZ("Name", false, function(state) code end)
ParZ("Text here")
BoxZ("Label", "Placeholder", function(text) code end)

FONTS:
Enum.Font.Gotham, GothamBold, Code, SourceSans, RobotoMono

TEXT COLORS (RGB 0-1):
White = Color3.new(1, 1, 1)
Red = Color3.new(1, 0, 0)
Green = Color3.new(0, 1, 0)
Blue = Color3.new(0, 0, 1)
Gray = Color3.new(0.5, 0.5, 0.5)

THEMES:
Dark Red: Button = (0.78, 0, 0), BG = (0, 0, 0)
Blue: Button = (0, 0.5, 1), BG = (0.05, 0.05, 0.15)
Purple: Button = (0.6, 0, 0.8), BG = (0.1, 0, 0.15)
Green: Button = (0, 0.7, 0.2), BG = (0, 0.1, 0)

IMPORTANT:
- Always use BorderSizePixel = 0 to remove borders
- AutomaticSize.Y for text that wraps
- TextWrapped = true for long text
- C is content frame, add all elements there
- Functions return nothing, they create directly
- Use game.CoreGui for exploit compatibility
- Dragging only works on title bar TB
- Toggle state stored in 'on' variable
]]
