local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShitLibrary"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if syn then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

function Library:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
  
    local FloatingButton = Instance.new("TextButton")
    FloatingButton.Name = "FloatingButton"
    FloatingButton.Size = UDim2.new(0, isMobile and 70 or 80, 0, isMobile and 30 or 35)
    FloatingButton.Position = UDim2.new(1, isMobile and -75 or -85, 0, isMobile and 10 or 15)
    FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    FloatingButton.BorderSizePixel = 0
    FloatingButton.Text = "Close"
    FloatingButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    FloatingButton.TextSize = isMobile and 12 or 14
    FloatingButton.Font = Enum.Font.GothamBold
    FloatingButton.ZIndex = 999
    FloatingButton.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = isMobile and UDim2.new(0, 340, 0, 400) or UDim2.new(0, 650, 0, 360)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
  
    local windowVisible = true
    FloatingButton.MouseButton1Click:Connect(function()
        windowVisible = not windowVisible
        MainFrame.Visible = windowVisible
        FloatingButton.Text = windowVisible and "Close" or "Open"
    end)
    
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextSize = isMobile and 15 or 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 1, -35)
    Container.Position = UDim2.new(0, 0, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame
    
    local TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = isMobile and UDim2.new(0, 80, 1, 0) or UDim2.new(0, 140, 1, 0)
    TabsContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    TabsContainer.BorderSizePixel = 0
    TabsContainer.ScrollBarThickness = 4
    TabsContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsContainer.Parent = Container
    
    local TabsList = Instance.new("UIListLayout")
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0, 5)
    TabsList.Parent = TabsContainer
    
    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingTop = UDim.new(0, 10)
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)
    TabsPadding.Parent = TabsContainer
    
    TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsContainer.CanvasSize = UDim2.new(0, 0, 0, TabsList.AbsoluteContentSize.Y + 20)
    end)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = isMobile and UDim2.new(1, -80, 1, 0) or UDim2.new(1, -140, 1, 0)
    ContentContainer.Position = isMobile and UDim2.new(0, 80, 0, 0) or UDim2.new(0, 140, 0, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Container
    
    function Window:CreateTab(tabName)
        local Tab = {}
        Tab.Elements = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = isMobile and UDim2.new(1, 0, 0, 35) or UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = isMobile and 13 or 15
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Parent = TabsContainer
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
                tab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                tab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            TabButton.TextColor3 = Color3.fromRGB(240, 240, 240)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        if not Window.CurrentTab then
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            TabButton.TextColor3 = Color3.fromRGB(240, 240, 240)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        function Tab:AddButton(buttonConfig)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, isMobile and 35 or 38)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            Button.BorderSizePixel = 0
            Button.Text = buttonConfig.Name
            Button.TextColor3 = Color3.fromRGB(220, 220, 220)
            Button.TextSize = isMobile and 13 or 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = TabContent
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 38)}):Play()
                
                if buttonConfig.Callback then
                    buttonConfig.Callback()
                end
            end)
            
            return Button
        end
        
        function Tab:AddToggle(toggleConfig)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, isMobile and 35 or 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleConfig.Name
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            ToggleLabel.TextSize = isMobile and 13 or 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, 0)
            ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, 0)
            ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(120, 120, 125)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local toggled = toggleConfig.Default or false
            
            local function UpdateToggle()
                if toggled then
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(1, -18, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(100, 180, 255)
                    }):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 100, 140)
                    }):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(120, 120, 125)
                    }):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    }):Play()
                end
                
                if toggleConfig.Callback then
                    toggleConfig.Callback(toggled)
                end
            end
            
            UpdateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    UpdateToggle()
                end
            }
        end
        
        function Tab:AddTextBox(textboxConfig)
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Size = UDim2.new(1, 0, 0, isMobile and 60 or 65)
            TextBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            TextBoxFrame.BorderSizePixel = 0
            TextBoxFrame.Parent = TabContent
            
            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = textboxConfig.Name
            TextBoxLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            TextBoxLabel.TextSize = isMobile and 13 or 14
            TextBoxLabel.Font = Enum.Font.Gotham
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -20, 0, 30)
            TextBox.Position = UDim2.new(0, 10, 0, 28)
            TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            TextBox.BorderSizePixel = 0
            TextBox.Text = textboxConfig.Default or ""
            TextBox.PlaceholderText = textboxConfig.Placeholder or "Enter text..."
            TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
            TextBox.TextSize = isMobile and 12 or 13
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = TextBoxFrame
            
            local TextBoxPadding = Instance.new("UIPadding")
            TextBoxPadding.PaddingLeft = UDim.new(0, 8)
            TextBoxPadding.PaddingRight = UDim.new(0, 8)
            TextBoxPadding.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enter)
                if textboxConfig.Callback then
                    textboxConfig.Callback(TextBox.Text)
                end
            end)
            
            return {
                Set = function(text)
                    TextBox.Text = text
                end
            }
        end
        
        function Tab:AddMultiDropdown(dropdownConfig)
            local selected = {}
            local expanded = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, isMobile and 35 or 38)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            DropdownFrame.ClipsDescendants = true
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 35 or 38)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownConfig.Name
            DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            DropdownLabel.TextSize = isMobile and 13 or 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, isMobile and 35 or 38)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Color3.fromRGB(180, 180, 180)
            DropdownArrow.TextSize = isMobile and 10 or 12
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownFrame
            
            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 0, 0, isMobile and 35 or 38)
            OptionsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
            OptionsContainer.BorderSizePixel = 0
            OptionsContainer.Parent = DropdownFrame
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsList.Parent = OptionsContainer
            
            for _, option in ipairs(dropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, isMobile and 30 or 32)
                OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = ""
                OptionButton.Parent = OptionsContainer
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -35, 1, 0)
                OptionLabel.Position = UDim2.new(0, 30, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = option
                OptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionLabel.TextSize = isMobile and 12 or 13
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.Parent = OptionButton
                
                local Checkbox = Instance.new("Frame")
                Checkbox.Size = UDim2.new(0, 16, 0, 16)
                Checkbox.Position = UDim2.new(0, 10, 0.5, 0)
                Checkbox.AnchorPoint = Vector2.new(0, 0.5)
                Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                Checkbox.BorderSizePixel = 0
                Checkbox.Parent = OptionButton
                
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Text = "✓"
                Checkmark.TextColor3 = Color3.fromRGB(100, 180, 255)
                Checkmark.TextSize = isMobile and 14 or 16
                Checkmark.Font = Enum.Font.GothamBold
                Checkmark.Visible = false
                Checkmark.Parent = Checkbox
                
                OptionButton.MouseButton1Click:Connect(function()
                    if table.find(selected, option) then
                        table.remove(selected, table.find(selected, option))
                        Checkmark.Visible = false
                        Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    else
                        table.insert(selected, option)
                        Checkmark.Visible = true
                        Checkbox.BackgroundColor3 = Color3.fromRGB(60, 100, 140)
                    end
                    
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(selected)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local contentHeight = #dropdownConfig.Options * (isMobile and 30 or 32)
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {
                        Size = UDim2.new(1, 0, 0, (isMobile and 35 or 38) + contentHeight)
                    }):Play()
                    TweenService:Create(OptionsContainer, TweenInfo.new(0.3), {
                        Size = UDim2.new(1, 0, 0, contentHeight)
                    }):Play()
                    DropdownArrow.Text = "▲"
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {
                        Size = UDim2.new(1, 0, 0, isMobile and 35 or 38)
                    }):Play()
                    TweenService:Create(OptionsContainer, TweenInfo.new(0.3), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    DropdownArrow.Text = "▼"
                end
            end)
            
            return {
                Set = function(options)
                    selected = options
                    for _, child in pairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            local label = child:FindFirstChildOfClass("TextLabel")
                            local checkbox = child:FindFirstChildOfClass("Frame")
                            if label and checkbox then
                                local checkmark = checkbox:FindFirstChildOfClass("TextLabel")
                                if table.find(selected, label.Text) then
                                    checkmark.Visible = true
                                    checkbox.BackgroundColor3 = Color3.fromRGB(60, 100, 140)
                                else
                                    checkmark.Visible = false
                                    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                                end
                            end
                        end
                    end
                end
            }
        end
        
        function Tab:AddSlider(sliderConfig)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, isMobile and 55 or 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderConfig.Name
            SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            SliderLabel.TextSize = isMobile and 13 or 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0.3, -10, 0, 20)
            SliderValue.Position = UDim2.new(0.7, 0, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(sliderConfig.Default or sliderConfig.Min)
            SliderValue.TextColor3 = Color3.fromRGB(100, 180, 255)
            SliderValue.TextSize = isMobile and 13 or 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 32)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderButton = Instance.new("Frame")
            SliderButton.Size = UDim2.new(0, 14, 0, 14)
            SliderButton.Position = UDim2.new(1, -7, 0.5, 0)
            SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            SliderButton.BorderSizePixel = 0
            SliderButton.Parent = SliderFill
            
            local draggingSlider = false
            local currentValue = sliderConfig.Default or sliderConfig.Min
            
            -- PART 2 - Continue from Part 1

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * pos)
                
                if sliderConfig.Increment then
                    value = math.floor(value / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                end
                
                currentValue = value
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                
                if sliderConfig.Callback then
                    sliderConfig.Callback(value)
                end
            end
            
            local function StartDrag(input)
                draggingSlider = true
                UpdateSlider(input)
            end
            
            local function StopDrag()
                draggingSlider = false
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    StartDrag(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    StopDrag()
                end
            end)
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    StartDrag(input)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    StopDrag()
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    StopDrag()
                end
            end)
            
            local initialPos = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
            SliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            
            return {
                Set = function(value)
                    currentValue = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                    SliderValue.Text = tostring(currentValue)
                    local pos = (currentValue - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                end
            }
        end
        
        function Tab:AddParagraph(paragraphConfig)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
            ParagraphFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = TabContent
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 0)
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 8)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = paragraphConfig.Title
            ParagraphTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
            ParagraphTitle.TextSize = isMobile and 14 or 15
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphTitle.TextWrapped = true
            ParagraphTitle.Parent = ParagraphFrame
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 0, 0)
            ParagraphContent.Position = UDim2.new(0, 10, 0, 0)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = paragraphConfig.Content
            ParagraphContent.TextColor3 = Color3.fromRGB(180, 180, 180)
            ParagraphContent.TextSize = isMobile and 12 or 13
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
            
            local titleSize = game:GetService("TextService"):GetTextSize(
                paragraphConfig.Title,
                isMobile and 14 or 15,
                Enum.Font.GothamBold,
                Vector2.new(ParagraphFrame.AbsoluteSize.X - 20, math.huge)
            )
            
            ParagraphTitle.Size = UDim2.new(1, -20, 0, titleSize.Y)
            ParagraphContent.Position = UDim2.new(0, 10, 0, titleSize.Y + 12)
            
            local contentSize = game:GetService("TextService"):GetTextSize(
                paragraphConfig.Content,
                isMobile and 12 or 13,
                Enum.Font.Gotham,
                Vector2.new(ParagraphFrame.AbsoluteSize.X - 20, math.huge)
            )
            
            ParagraphContent.Size = UDim2.new(1, -20, 0, contentSize.Y)
            ParagraphFrame.Size = UDim2.new(1, 0, 0, titleSize.Y + contentSize.Y + 20)
            
            return {
                Set = function(title, content)
                    ParagraphTitle.Text = title
                    ParagraphContent.Text = content
                    
                    local newTitleSize = game:GetService("TextService"):GetTextSize(
                        title,
                        isMobile and 14 or 15,
                        Enum.Font.GothamBold,
                        Vector2.new(ParagraphFrame.AbsoluteSize.X - 20, math.huge)
                    )
                    
                    ParagraphTitle.Size = UDim2.new(1, -20, 0, newTitleSize.Y)
                    ParagraphContent.Position = UDim2.new(0, 10, 0, newTitleSize.Y + 12)
                    
                    local newContentSize = game:GetService("TextService"):GetTextSize(
                        content,
                        isMobile and 12 or 13,
                        Enum.Font.Gotham,
                        Vector2.new(ParagraphFrame.AbsoluteSize.X - 20, math.huge)
                    )
                    
                    ParagraphContent.Size = UDim2.new(1, -20, 0, newContentSize.Y)
                    ParagraphFrame.Size = UDim2.new(1, 0, 0, newTitleSize.Y + newContentSize.Y + 20)
                end
            }
        end
        
        function Tab:AddLabel(labelText)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, isMobile and 30 or 32)
            Label.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            Label.BorderSizePixel = 0
            Label.Text = labelText
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = isMobile and 13 or 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabContent
            
            local LabelPadding = Instance.new("UIPadding")
            LabelPadding.PaddingLeft = UDim.new(0, 10)
            LabelPadding.PaddingRight = UDim.new(0, 10)
            LabelPadding.Parent = Label
            
            return {
                Set = function(text)
                    Label.Text = text
                end
            }
        end
        
        return Tab
    end
    
    return Window
end

return Library
