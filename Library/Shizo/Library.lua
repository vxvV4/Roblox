-- // Made by Shizoscript \\ --
local Library = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function Library:CreateWindow(title)
    local window = {}
    
    local player = Players.LocalPlayer
    local gui = player:WaitForChild("PlayerGui")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = title or "GUI"
    sg.ResetOnSpawn = false
    sg.Parent = gui
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, 185, 0, 25)
    shadow.Position = UDim2.new(0.5, -90, 0.5, -40)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = sg
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 8)
    shadowCorner.Parent = shadow
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0.5, -15, 0.5, -15)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = Color3.fromRGB(70, 180, 70)
    glow.ImageTransparency = 0.7
    glow.ZIndex = 0
    glow.Parent = shadow
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 180, 0, 25)
    main.Position = UDim2.new(0.5, -90, 0.5, -40)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    main.BorderSizePixel = 0
    main.ZIndex = 1
    main.Parent = sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "Title"
    titleBar.Size = UDim2.new(1, 0, 0, 25)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 8)
    titleFix.Position = UDim2.new(0, 0, 1, -8)
    titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleFix.BorderSizePixel = 0
    titleFix.ZIndex = 2
    titleFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 8, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "GUI"
    titleText.TextColor3 = Color3.fromRGB(70, 180, 70)
    titleText.TextSize = 10
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 3
    titleText.Parent = titleBar
    
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(70, 180, 70)
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.5
    titleStroke.Parent = titleText
    
    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Name = "CollapseBtn"
    collapseBtn.Size = UDim2.new(0, 22, 0, 25)
    collapseBtn.Position = UDim2.new(1, -22, 0, 0)
    collapseBtn.BackgroundTransparency = 1
    collapseBtn.Text = "v"
    collapseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    collapseBtn.TextSize = 11
    collapseBtn.Font = Enum.Font.GothamBold
    collapseBtn.ZIndex = 3
    collapseBtn.Parent = titleBar
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -25)
    content.Position = UDim2.new(0, 0, 0, 25)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.ZIndex = 2
    content.Parent = main
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingBottom = UDim.new(0, 8)
    contentPadding.Parent = content
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = content
    
    local collapsed = false
    local currentHeight = 25
    local elementCount = 0
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not collapsed then
            currentHeight = 25 + layout.AbsoluteContentSize.Y + 16
            main.Size = UDim2.new(0, 180, 0, currentHeight)
            shadow.Size = UDim2.new(0, 185, 0, currentHeight + 5)
        end
    end)
    
    collapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        
        local newSize = collapsed and UDim2.new(0, 180, 0, 25) or UDim2.new(0, 180, 0, currentHeight)
        local shadowSize = collapsed and UDim2.new(0, 185, 0, 30) or UDim2.new(0, 185, 0, currentHeight + 5)
        local newText = collapsed and ">" or "v"
        
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = newSize}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = shadowSize}):Play()
        collapseBtn.Text = newText
    end)
    
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        main.Position = newPos
        shadow.Position = newPos
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
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
            update(input)
        end
    end)
    
    function window:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 25)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 9
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        label.LayoutOrder = elementCount
        label.ZIndex = 3
        label.Parent = content
        elementCount = elementCount + 1
        
        return {
            SetText = function(self, newText)
                label.Text = newText
            end
        }
    end
  
    function window:AddToggle(name, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 25)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.LayoutOrder = elementCount
        toggleFrame.ZIndex = 3
        toggleFrame.Parent = content
        elementCount = elementCount + 1
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -42, 1, 0)
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = name
        toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        toggleLabel.TextSize = 9
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.ZIndex = 3
        toggleLabel.Parent = toggleFrame
        
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 38, 0, 18)
        toggleBg.Position = UDim2.new(1, -38, 0.5, -9)
        toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBg.BorderSizePixel = 0
        toggleBg.ZIndex = 3
        toggleBg.Parent = toggleFrame
        
        local toggleBgCorner = Instance.new("UICorner")
        toggleBgCorner.CornerRadius = UDim.new(1, 0)
        toggleBgCorner.Parent = toggleBg
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 14, 0, 14)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.ZIndex = 4
        toggleCircle.Parent = toggleBg
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = toggleCircle
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(1, 0, 1, 0)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 5
        toggleBtn.Parent = toggleBg
        
        local toggled = false
        
        toggleBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local bgColor = toggled and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(40, 40, 40)
            local circlePos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 80)
            
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
            
            if callback then
                callback(toggled)
            end
        end)
        
        return {
            SetState = function(self, state)
                toggled = state
                local bgColor = toggled and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(40, 40, 40)
                local circlePos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 80)
                toggleBg.BackgroundColor3 = bgColor
                toggleCircle.Position = circlePos
                toggleCircle.BackgroundColor3 = circleColor
            end
        }
    end
    
    function window:AddButton(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.LayoutOrder = elementCount
        btn.ZIndex = 3
        btn.Parent = content
        elementCount = elementCount + 1
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            wait(0.1)
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            
            if callback then
                callback()
            end
        end)
    end
    
    function window:AddTextBox(name, placeholder, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Size = UDim2.new(1, 0, 0, 45)
        textBoxFrame.BackgroundTransparency = 1
        textBoxFrame.LayoutOrder = elementCount
        textBoxFrame.ZIndex = 3
        textBoxFrame.Parent = content
        elementCount = elementCount + 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 9
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3
        label.Parent = textBoxFrame
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, 0, 0, 25)
        textBox.Position = UDim2.new(0, 0, 0, 20)
        textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        textBox.BorderSizePixel = 0
        textBox.PlaceholderText = placeholder or "Enter text..."
        textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        textBox.Text = ""
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.TextSize = 9
        textBox.Font = Enum.Font.Gotham
        textBox.ClearTextOnFocus = false
        textBox.ZIndex = 3
        textBox.Parent = textBoxFrame
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 5)
        textBoxCorner.Parent = textBox
        
        local textBoxPadding = Instance.new("UIPadding")
        textBoxPadding.PaddingLeft = UDim.new(0, 8)
        textBoxPadding.PaddingRight = UDim.new(0, 8)
        textBoxPadding.Parent = textBox
        
        textBox.FocusLost:Connect(function(enterPressed)
            if callback then
                callback(textBox.Text)
            end
        end)
        
        return {
            SetText = function(self, text)
                textBox.Text = text
            end,
            GetText = function(self)
                return textBox.Text
            end
        }
    end
    
    function window:AddSlider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 45)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.LayoutOrder = elementCount
        sliderFrame.ZIndex = 3
        sliderFrame.Parent = content
        elementCount = elementCount + 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -45, 0, 18)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 9
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3
        label.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 45, 0, 18)
        valueLabel.Position = UDim2.new(1, -45, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default or min)
        valueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        valueLabel.TextSize = 9
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.ZIndex = 3
        valueLabel.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 25)
        sliderBg.Position = UDim2.new(0, 0, 0, 20)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBg.BorderSizePixel = 0
        sliderBg.ZIndex = 3
        sliderBg.Parent = sliderFrame
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 5)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 4
        sliderFill.Parent = sliderBg
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 5)
        sliderFillCorner.Parent = sliderFill
        
        local dragging = false
        local currentValue = default or min
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * pos)
            
            valueLabel.Text = tostring(currentValue)
            TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
            
            if callback then
                callback(currentValue)
            end
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider(input)
            end
        end)
        
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        local initPos = (currentValue - min) / (max - min)
        sliderFill.Size = UDim2.new(initPos, 0, 1, 0)
        
        return {
            SetValue = function(self, value)
                currentValue = math.clamp(value, min, max)
                valueLabel.Text = tostring(currentValue)
                local pos = (currentValue - min) / (max - min)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            end,
            GetValue = function(self)
                return currentValue
            end
        }
    end
    
    function window:AddFolder(name)
        local folder = {}
        folder.open = false
        folder.elementCount = 0
        
        local folderFrame = Instance.new("Frame")
        folderFrame.Size = UDim2.new(1, 0, 0, 25)
        folderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        folderFrame.BorderSizePixel = 0
        folderFrame.LayoutOrder = elementCount
        folderFrame.ClipsDescendants = true
        folderFrame.ZIndex = 3
        folderFrame.Parent = content
        elementCount = elementCount + 1
        
        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = UDim.new(0, 5)
        folderCorner.Parent = folderFrame
        
        local titleBtn = Instance.new("TextButton")
        titleBtn.Size = UDim2.new(1, 0, 0, 25)
        titleBtn.BackgroundTransparency = 1
        titleBtn.Text = ""
        titleBtn.ZIndex = 4
        titleBtn.Parent = folderFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -25, 1, 0)
        titleLabel.Position = UDim2.new(0, 8, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = name
        titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        titleLabel.TextSize = 9
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 4
        titleLabel.Parent = titleBtn
        
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 18, 0, 25)
        arrow.Position = UDim2.new(1, -18, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = ">"
        arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
        arrow.TextSize = 10
        arrow.Font = Enum.Font.GothamBold
        arrow.ZIndex = 4
        arrow.Parent = titleBtn
        
        local folderContent = Instance.new("Frame")
        folderContent.Size = UDim2.new(1, 0, 0, 0)
        folderContent.Position = UDim2.new(0, 0, 0, 25)
        folderContent.BackgroundTransparency = 1
        folderContent.ClipsDescendants = true
        folderContent.ZIndex = 4
        folderContent.Parent = folderFrame
        
        local folderPadding = Instance.new("UIPadding")
        folderPadding.PaddingLeft = UDim.new(0, 8)
        folderPadding.PaddingRight = UDim.new(0, 8)
        folderPadding.PaddingTop = UDim.new(0, 4)
        folderPadding.PaddingBottom = UDim.new(0, 4)
        folderPadding.Parent = folderContent
        
        local folderLayout = Instance.new("UIListLayout")
        folderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        folderLayout.Padding = UDim.new(0, 4)
        folderLayout.Parent = folderContent
        
        folderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if folder.open then
                local newHeight = folderLayout.AbsoluteContentSize.Y + 8
                folderContent.Size = UDim2.new(1, 0, 0, newHeight)
                folderFrame.Size = UDim2.new(1, 0, 0, 25 + newHeight)
            end
        end)
        
        titleBtn.MouseButton1Click:Connect(function()
            folder.open = not folder.open
            
            local newArrow = folder.open and "v" or ">"
            local newHeight = folder.open and (25 + folderLayout.AbsoluteContentSize.Y + 8) or 25
            local contentHeight = folder.open and (folderLayout.AbsoluteContentSize.Y + 8) or 0
            
            arrow.Text = newArrow
            TweenService:Create(folderFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, newHeight)}):Play()
            TweenService:Create(folderContent, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, contentHeight)}):Play()
        end)
        
        function folder:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.TextSize = 8
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            label.LayoutOrder = folder.elementCount
            label.ZIndex = 5
            label.Parent = folderContent
            folder.elementCount = folder.elementCount + 1
            
            return {
                SetText = function(self, newText)
                    label.Text = newText
                end
            }
        end
      
        function folder:AddToggle(name, callback)

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 25)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.LayoutOrder = folder.elementCount
            toggleFrame.ZIndex = 5
            toggleFrame.Parent = folderContent
            folder.elementCount = folder.elementCount + 1
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -42, 1, 0)
            toggleLabel.Position = UDim2.new(0, 0, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            toggleLabel.TextSize = 8
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.ZIndex = 5
            toggleLabel.Parent = toggleFrame
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 38, 0, 18)
            toggleBg.Position = UDim2.new(1, -38, 0.5, -9)
            toggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            toggleBg.BorderSizePixel = 0
            toggleBg.ZIndex = 5
            toggleBg.Parent = toggleFrame
            
            local toggleBgCorner = Instance.new("UICorner")
            toggleBgCorner.CornerRadius = UDim.new(1, 0)
            toggleBgCorner.Parent = toggleBg
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 14, 0, 14)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.ZIndex = 6
            toggleCircle.Parent = toggleBg
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 7
            toggleBtn.Parent = toggleBg
            
            local toggled = false
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                local bgColor = toggled and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(35, 35, 35)
                local circlePos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
                
                TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
                TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
                
                if callback then
                    callback(toggled)
                end
            end)
            
            return {
                SetState = function(self, state)
                    toggled = state
                    local bgColor = toggled and Color3.fromRGB(70, 180, 70) or Color3.fromRGB(35, 35, 35)
                    local circlePos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    local circleColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
                    toggleBg.BackgroundColor3 = bgColor
                    toggleCircle.Position = circlePos
                    toggleCircle.BackgroundColor3 = circleColor
                end
            }
        end
        
        function folder:AddButton(name, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.BorderSizePixel = 0
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextSize = 8
            btn.Font = Enum.Font.GothamBold
            btn.LayoutOrder = folder.elementCount
            btn.ZIndex = 5
            btn.Parent = folderContent
            folder.elementCount = folder.elementCount + 1
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                
                if callback then
                    callback()
                end
            end)
        end
        
        function folder:AddTextBox(name, placeholder, callback)
            local textBoxFrame = Instance.new("Frame")
            textBoxFrame.Size = UDim2.new(1, 0, 0, 45)
            textBoxFrame.BackgroundTransparency = 1
            textBoxFrame.LayoutOrder = folder.elementCount
            textBoxFrame.ZIndex = 5
            textBoxFrame.Parent = folderContent
            folder.elementCount = folder.elementCount + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 18)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.TextSize = 8
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 5
            label.Parent = textBoxFrame
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, 0, 0, 25)
            textBox.Position = UDim2.new(0, 0, 0, 20)
            textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            textBox.BorderSizePixel = 0
            textBox.PlaceholderText = placeholder or "Enter text..."
            textBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
            textBox.Text = ""
            textBox.TextColor3 = Color3.fromRGB(220, 220, 220)
            textBox.TextSize = 8
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 5
            textBox.Parent = textBoxFrame
            
            local textBoxCorner = Instance.new("UICorner")
            textBoxCorner.CornerRadius = UDim.new(0, 5)
            textBoxCorner.Parent = textBox
            
            local textBoxPadding = Instance.new("UIPadding")
            textBoxPadding.PaddingLeft = UDim.new(0, 8)
            textBoxPadding.PaddingRight = UDim.new(0, 8)
            textBoxPadding.Parent = textBox
            
            textBox.FocusLost:Connect(function(enterPressed)
                if callback then
                    callback(textBox.Text)
                end
            end)
            
            return {
                SetText = function(self, text)
                    textBox.Text = text
                end,
                GetText = function(self)
                    return textBox.Text
                end
            }
        end
        
        function folder:AddSlider(name, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.LayoutOrder = folder.elementCount
            sliderFrame.ZIndex = 5
            sliderFrame.Parent = folderContent
            folder.elementCount = folder.elementCount + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -45, 0, 18)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.TextSize = 8
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 5
            label.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 45, 0, 18)
            valueLabel.Position = UDim2.new(1, -45, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or min)
            valueLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
            valueLabel.TextSize = 8
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = 5
            valueLabel.Parent = sliderFrame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 25)
            sliderBg.Position = UDim2.new(0, 0, 0, 20)
            sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            sliderBg.BorderSizePixel = 0
            sliderBg.ZIndex = 5
            sliderBg.Parent = sliderFrame
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(0, 5)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
            sliderFill.BorderSizePixel = 0
            sliderFill.ZIndex = 6
            sliderFill.Parent = sliderBg
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(0, 5)
            sliderFillCorner.Parent = sliderFill
            
            local dragging = false
            local currentValue = default or min
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * pos)
                
                valueLabel.Text = tostring(currentValue)
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                
                if callback then
                    callback(currentValue)
                end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            local initPos = (currentValue - min) / (max - min)
            sliderFill.Size = UDim2.new(initPos, 0, 1, 0)
            
            return {
                SetValue = function(self, value)
                    currentValue = math.clamp(value, min, max)
                    valueLabel.Text = tostring(currentValue)
                    local pos = (currentValue - min) / (max - min)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                end,
                GetValue = function(self)
                    return currentValue
                end
            }
        end
        
        return folder
    end
    
    return window
end

return Library
