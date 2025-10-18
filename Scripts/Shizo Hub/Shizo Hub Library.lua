local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}
-- // ** This can't Double or Multiple Window ** \\ --
-- // ** Clean Up Old if Exist ** \\ -- 
pcall(function()
    if CoreGui:FindFirstChild("PurpleBlackLib") then
        CoreGui.PurpleBlackLib:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PurpleBlackLib"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- // ** The Icon of The Floating Squircle Shape that can Show/Hide The Whole UI ** \\ --
local floatBtn = Instance.new("ImageButton")
floatBtn.Name = "FloatToggle"
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 15, 0.5, -25)
floatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatBtn.BorderSizePixel = 0
floatBtn.Image = "rbxassetid://107465641424582"
floatBtn.ScaleType = Enum.ScaleType.Fit
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.Parent = ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0.2, 0)
floatCorner.Parent = floatBtn

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Color3.fromRGB(138, 43, 226)
floatStroke.Thickness = 2
floatStroke.Parent = floatBtn

local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 550, 0, 350)
mainWindow.Position = UDim2.new(0.5, -275, 0.5, -175)
mainWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainWindow.BorderSizePixel = 0
mainWindow.Active = true
mainWindow.Visible = false
mainWindow.Parent = ScreenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 12)
windowCorner.Parent = mainWindow

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = Color3.fromRGB(138, 43, 226)
windowStroke.Thickness = 2
windowStroke.Parent = mainWindow

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainWindow

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Xx GHOSTHUB xX"
titleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -40)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainWindow

local tabArea = Instance.new("ScrollingFrame")
tabArea.Name = "TabArea"
tabArea.Size = UDim2.new(0, 140, 1, -10)
tabArea.Position = UDim2.new(0, 5, 0, 5)
tabArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tabArea.BorderSizePixel = 0
tabArea.ScrollBarThickness = 4
tabArea.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
tabArea.CanvasSize = UDim2.new(0, 0, 0, 0)
tabArea.Parent = contentContainer

local tabAreaCorner = Instance.new("UICorner")
tabAreaCorner.CornerRadius = UDim.new(0, 8)
tabAreaCorner.Parent = tabArea

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabArea
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 5)
tabPadding.PaddingLeft = UDim.new(0, 5)
tabPadding.PaddingRight = UDim.new(0, 5)
tabPadding.PaddingBottom = UDim.new(0, 5)
tabPadding.Parent = tabArea

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -150, 1, -10)
contentArea.Position = UDim2.new(0, 150, 0, 5)
contentArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = contentContainer

local contentAreaCorner = Instance.new("UICorner")
contentAreaCorner.CornerRadius = UDim.new(0, 8)
contentAreaCorner.Parent = contentArea

local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainWindow.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainWindow.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local isOpen = false
floatBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainWindow.Visible = isOpen
end)

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    mainWindow.Visible = false
end)

local tabs = {}

function Library:CreateTab(name)
    local tab = {
        Name = name,
        Buttons = {}
    }
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(138, 43, 226)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabArea
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(50, 50, 50)
    tabStroke.Thickness = 1
    tabStroke.Parent = tabBtn
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = name .. "_Container"
    tabContainer.Size = UDim2.new(1, -10, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.Visible = false
    tabContainer.Parent = contentArea
    
    local buttonGrid = Instance.new("UIGridLayout")
    buttonGrid.Parent = tabContainer
    buttonGrid.CellSize = UDim2.new(0, 85, 0, 38)
    buttonGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    buttonGrid.SortOrder = Enum.SortOrder.LayoutOrder
    buttonGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local gridPadding = Instance.new("UIPadding")
    gridPadding.PaddingTop = UDim.new(0, 10)
    gridPadding.PaddingLeft = UDim.new(0, 10)
    gridPadding.PaddingRight = UDim.new(0, 10)
    gridPadding.PaddingBottom = UDim.new(0, 10)
    gridPadding.Parent = tabContainer
    
    tab.Container = tabContainer
    tab.Button = tabBtn
    tab.Grid = buttonGrid
    tab.Stroke = tabStroke
    
    local function updateCanvasSize()
        task.wait(0.05)
        local contentSize = buttonGrid.AbsoluteContentSize.Y
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, contentSize + 20)
    end
    
    buttonGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            t.Button.TextColor3 = Color3.fromRGB(138, 43, 226)
            t.Stroke.Color = Color3.fromRGB(50, 50, 50)
        end
        tabContainer.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        tabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        tabStroke.Color = Color3.fromRGB(138, 43, 226)
    end)
    
    -- //**Add button function**\\ --
    function tab:AddButton(buttonName, callback)
        local btn = Instance.new("TextButton")
        btn.Name = buttonName
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        btn.Text = buttonName
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextWrapped = true
        btn.BorderSizePixel = 0
        btn.Parent = tabContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(80, 80, 80)
        btnStroke.Thickness = 1
        btnStroke.Parent = btn
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(160, 60, 255)
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            }):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            if callback then
                pcall(callback)
            end
        end)
        
        table.insert(tab.Buttons, btn)
        updateCanvasSize()
        
        return btn
    end
    
    table.insert(tabs, tab)
    
    task.wait(0.05)
    tabArea.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    
    -- //* This will Auto Select the Tab *\\ --
    if #tabs == 1 then
        task.spawn(function()
            task.wait(0.1)
            tabContainer.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabStroke.Color = Color3.fromRGB(138, 43, 226)
        end)
    end
    
    return tab
end

function Library:SetTitle(title)
    titleLabel.Text = title
end

return Library
