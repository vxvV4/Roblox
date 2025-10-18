--[[
a simple Library You can use for Scripting ny Shizo
--]]
local hizo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function hizo:Window(title)
    local window = {}
    local isVisible = true
    
    -- //*** Screen Gui ***\\ --
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "hizoLib"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- //* The Main Frame *\\ --
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.4, 0, 0.35, 0)
    Main.Size = UDim2.new(0, 280, 0, 35)
    Main.ClipsDescendants = true
    Main.Active = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = Main
    
    -- //* This is The Title *\\ --
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Main
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -20, 0, 35)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "hizo"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- //* Container *\\ -- 
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = Main
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 8, 0, 40)
    Container.Size = UDim2.new(1, -16, 1, -45)
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    
    -- //* This is The Floating Squircle Shape *\\ --
    local FloatingBtn = Instance.new("TextButton")
    FloatingBtn.Name = "FloatingBtn"
    FloatingBtn.Parent = ScreenGui
    FloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FloatingBtn.BorderSizePixel = 0
    FloatingBtn.Position = UDim2.new(1, -50, 0, 10)
    FloatingBtn.Size = UDim2.new(0, 35, 0, 35)
    FloatingBtn.Font = Enum.Font.Gotham
    FloatingBtn.Text = "Hide"
    FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatingBtn.TextSize = 10
    FloatingBtn.ZIndex = 100
    
    local FloatingCorner = Instance.new("UICorner")
    FloatingCorner.CornerRadius = UDim.new(0, 10)
    FloatingCorner.Parent = FloatingBtn
    
    FloatingBtn.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        
        if isVisible then
            Main.Visible = true
            FloatingBtn.Text = "Hide"
        else
            Main.Visible = false
            FloatingBtn.Text = "Show"
        end
    end)
    
    -- //* This is Dragging Functions *\\ --
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- //* This will Auto Resize *\\ --
    local function updateSize()
        local contentSize = UIListLayout.AbsoluteContentSize.Y
        Main:TweenSize(UDim2.new(0, 280, 0, contentSize + 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
    
    -- //* Toggle Elements *\\ -- 
    function window:Toggle(text, default, callback)
        local toggled = default or false
        
        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Name = "Toggle"
        ToggleFrame.Parent = Container
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Font = Enum.Font.Gotham
        ToggleFrame.Text = ""
        ToggleFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleFrame.TextSize = 12
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 12
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = ToggleFrame
        ToggleIndicator.BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Position = UDim2.new(1, -28, 0.5, -8)
        ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 3)
        IndicatorCorner.Parent = ToggleIndicator
        
        ToggleFrame.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local tween = TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
            })
            tween:Play()
            
            callback(toggled)
        end)
        
        return toggled
    end
    
    -- //* buttom Elements *\\ -- 
    function window:Button(text, callback)
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Name = "Button"
        ButtonFrame.Parent = Container
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Font = Enum.Font.Gotham
        ButtonFrame.Text = text
        ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonFrame.TextSize = 12
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = ButtonFrame
        
        ButtonFrame.MouseButton1Click:Connect(function()
            local tween = TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            })
            tween:Play()
            
            wait(0.1)
            
            local tween2 = TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            })
            tween2:Play()
            
            callback()
        end)
    end
    
    return window
end
--//***** return *****\\--
return hizo
