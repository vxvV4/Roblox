local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local Container = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    
    local ToggleButton = Instance.new("TextButton")
    local ToggleCorner = Instance.new("UICorner")
    
    ScreenGui.Name = "ReplicatedStorage" -- //** Don't change This Cause This helps to Anti-Inspect the Gui Recommendation by shizo HEHE **\\ --
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 200, 0, 50)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0, 5)
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.Size = UDim2.new(1, 0, 1, -30)
    Container.ClipsDescendants = true
    
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    
    UIPadding.Parent = Container
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 2)
  
    local CreditLabel = Instance.new("TextLabel")
    CreditLabel.Name = "Credit"
    CreditLabel.Parent = MainFrame
    CreditLabel.BackgroundTransparency = 1
    CreditLabel.Position = UDim2.new(0, 0, 1, -18)
    CreditLabel.Size = UDim2.new(1, 0, 0, 18)
    CreditLabel.Font = Enum.Font.Gotham
    CreditLabel.Text = "YouTube: Shizoscript"
    CreditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    CreditLabel.TextSize = 10
  
    ToggleButton.Name = "FloatingToggle"
    ToggleButton.Parent = ScreenGui
    ToggleButton.Position = UDim2.new(1, -60, 0, 10)
    ToggleButton.Size = UDim2.new(0, 45, 0, 45)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "UI"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local uiVisible = true
    
    ToggleButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        MainFrame.Visible = uiVisible
        ToggleButton.BackgroundColor3 = uiVisible and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    local Window = {}
    
    function Window:AddButton(name, callback)
        local ButtonFrame = Instance.new("Frame")
        local ButtonLabel = Instance.new("TextButton")
        local ButtonCorner = Instance.new("UICorner")
        
        ButtonFrame.Name = name
        ButtonFrame.Parent = Container
        ButtonFrame.BackgroundTransparency = 1
        ButtonFrame.Size = UDim2.new(1, 0, 0, 22)
        
        ButtonLabel.Name = "Button"
        ButtonLabel.Parent = ButtonFrame
        ButtonLabel.Position = UDim2.new(0, 0, 0, 0)
        ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
        ButtonLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ButtonLabel.BorderSizePixel = 0
        ButtonLabel.Font = Enum.Font.Gotham
        ButtonLabel.Text = name
        ButtonLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        ButtonLabel.TextSize = 13
        ButtonLabel.AutoButtonColor = false
        
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = ButtonLabel
        
        ButtonLabel.MouseButton1Click:Connect(function()
            ButtonLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            wait(0.1)
            ButtonLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            if callback then
                pcall(function()
                    callback()
                end)
            end
        end)
        
        MainFrame.Size = UDim2.new(0, 200, 0, 53 + (#Container:GetChildren() - 1) * 24)
    end
    
    function Window:AddToggle(name, default, callback)
        local ToggleFrame = Instance.new("Frame")
        local ToggleLabel = Instance.new("TextLabel")
        local StatusFrame = Instance.new("Frame")
        local StatusCorner = Instance.new("UICorner")
        local StatusLabel = Instance.new("TextLabel")
        local ToggleButtonInside = Instance.new("TextButton")
        
        local toggled = default or false
        
        ToggleFrame.Name = name
        ToggleFrame.Parent = Container
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Size = UDim2.new(1, 0, 0, 22)
        
        ToggleLabel.Name = "Label"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        ToggleLabel.TextSize = 13
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        StatusFrame.Name = "StatusFrame"
        StatusFrame.Parent = ToggleFrame
        StatusFrame.Position = UDim2.new(0.75, 0, 0.15, 0)
        StatusFrame.Size = UDim2.new(0, 35, 0, 16)
        StatusFrame.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        StatusFrame.BorderSizePixel = 0
        
        StatusCorner.CornerRadius = UDim.new(0, 3)
        StatusCorner.Parent = StatusFrame
        
        StatusLabel.Name = "StatusLabel"
        StatusLabel.Parent = StatusFrame
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Size = UDim2.new(1, 0, 1, 0)
        StatusLabel.Font = Enum.Font.GothamBold
        StatusLabel.Text = toggled and "ON" or "OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.TextSize = 11
        
        ToggleButtonInside.Name = "Button"
        ToggleButtonInside.Parent = ToggleFrame
        ToggleButtonInside.BackgroundTransparency = 1
        ToggleButtonInside.Size = UDim2.new(1, 0, 1, 0)
        ToggleButtonInside.Text = ""
        ToggleButtonInside.ZIndex = 2
        
        ToggleButtonInside.MouseButton1Click:Connect(function()
            toggled = not toggled
            StatusLabel.Text = toggled and "ON" or "OFF"
            StatusFrame.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
            
            if callback then
                pcall(function()
                    callback(toggled)
                end)
            end
        end)
        
        MainFrame.Size = UDim2.new(0, 200, 0, 53 + (#Container:GetChildren() - 1) * 24)
    end
    
    return Window
end

return Library
