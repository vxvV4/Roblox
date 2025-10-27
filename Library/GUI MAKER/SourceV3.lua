local ThemeZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/GUI%20MAKER/ThemeZ%20for%20SourceV3.lua"))()

-- Set your desired theme
ThemeZ:SetTheme("Rainbow") -- Options: Rainbow, Dark, Blue, Purple, Cyan, Green, Light

-- Mini Box GUI
local G = Instance.new("ScreenGui", game.CoreGui)
G.Name = "ThemedGUI"

local M = Instance.new("Frame", G)
M.Name = "Frame"
M.Size = UDim2.new(0, 200, 0, 30)
M.Position = UDim2.new(0.5, -100, 0.5, -15) -- CENTERED NA TO!
M.AnchorPoint = Vector2.new(0.5, 0.5) -- MAY ANCHOR POINT NA PARA EXACT CENTER
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
T.Text = "GUI"
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
L.HorizontalAlignment = Enum.HorizontalAlignment.Center -- NAKA-CENTER NA LAHAT NG ELEMENTS!

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

-- Paragraph
function Par(txt)
    local l = Instance.new("TextLabel", C)
    l.Size = UDim2.new(1, -6, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = ThemeZ.CurrentTheme.TextSecondary
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextWrapped = true
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.TextXAlignment = Enum.TextXAlignment.Center -- CENTERED TEXT
end

-- Textbox
function Box(txt, ph, cb)
    local f = Instance.new("Frame", C)
    f.Size = UDim2.new(1, -6, 0, 40)
    f.BackgroundColor3 = ThemeZ.CurrentTheme.ContentBackground
    f.BorderSizePixel = 0
    ThemeZ:AddCorner(f)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -6, 0, 15)
    l.Position = UDim2.new(0, 3, 0, 2)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = ThemeZ.CurrentTheme.TextPrimary
    l.TextSize = 9
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextBox", f)
    b.Size = UDim2.new(1, -6, 0, 20)
    b.Position = UDim2.new(0, 3, 0, 18)
    b.BackgroundColor3 = ThemeZ.CurrentTheme.TextboxBackground
    b.PlaceholderText = ph
    b.Text = ""
    b.TextColor3 = ThemeZ.CurrentTheme.TextPrimary
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.FocusLost:Connect(function() cb(b.Text) end)
    ThemeZ:AddCorner(b)
end

-- Apply theme to entire GUI (adds corners and rainbow effects)
ThemeZ:ApplyToGUI(G)

-- Examples
Par("Welcome to ThemeZ!")
Btn("Test Button", function() print("Button clicked!") end)
Tog("Rainbow Mode", true, function(v) print("Rainbow:", v) end)
Box("Username", "Enter name...", function(v) print("Input:", v) end)

-- Theme Switcher
Btn("Change Theme", function()
    local themes = ThemeZ:GetThemeList()
    local current = ThemeZ.CurrentTheme.Name
    local currentIndex = table.find(themes, current)
    local nextIndex = (currentIndex % #themes) + 1
    
    ThemeZ:SetTheme(themes[nextIndex])
    
    -- Recreate GUI with new theme
    G:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxvV4/Roblox/refs/heads/main/Library/GUI%20MAKER/SourceV3.lua"))()
end)

Par("Current Theme: " .. ThemeZ.CurrentTheme.Name)
