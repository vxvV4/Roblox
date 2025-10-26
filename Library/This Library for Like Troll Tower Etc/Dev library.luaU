--(Forked) from this sexy man https://github.com/dawid-scripts
-- // modified by Shizo & Nation \\ --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function ripple(obj)
	spawn(function()
		local Mouse = game.Players.LocalPlayer:GetMouse()
		local Circle = Instance.new("ImageLabel")
		Circle.Name = "Circle"
		Circle.Parent = obj
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1.000
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Circle.ImageTransparency = 0.4
		
		local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		
		local Size = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 1.5
		
		Circle:TweenSizeAndPosition(
			UDim2.new(0, Size, 0, Size),
			UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
			"Out",
			"Quad",
			0.2,
			false
		)
		
		for i = 1, 20 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.05
			wait(0.3 / 10)
		end
		Circle:Destroy()
	end)
end

local function draggable(obj)
	local gui = obj
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		local EndPos = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X, 
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
		local Tween = TweenService:Create(gui, TweenInfo.new(0.2), {Position = EndPos})
		Tween:Play()
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

local lib = {}

function lib:Window(text)
	local ft = false
	local vistab = true
	local mini = false

	local VenLib = Instance.new("ScreenGui")
	local mainframe = Instance.new("Frame")
	local mainframeBorder = Instance.new("UIStroke")
	local mainholder = Instance.new("Frame")
	local containers = Instance.new("Folder")
	local tabholder = Instance.new("Frame")
	local tablist = Instance.new("UIListLayout")
	local top = Instance.new("Frame")
	local title = Instance.new("TextLabel")
	local minimize = Instance.new("ImageButton")

	VenLib.Name = "VenLib"
	VenLib.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	VenLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	VenLib.ResetOnSpawn = false

	mainframe.Name = "mainframe"
	mainframe.Parent = VenLib
	mainframe.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	mainframe.BorderSizePixel = 0
	mainframe.ClipsDescendants = true
	mainframe.Position = UDim2.new(0.35, 0, 0.3, 0)
	mainframe.Size = UDim2.new(0, 500, 0, 320)
	draggable(mainframe)

	
	mainframeBorder.Parent = mainframe
	mainframeBorder.Color = Color3.fromRGB(80, 80, 80)
	mainframeBorder.Thickness = 2

	mainholder.Name = "mainholder"
	mainholder.Parent = mainframe
	mainholder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	mainholder.BorderSizePixel = 0
	mainholder.Position = UDim2.new(0, 0, 0, 0)
	mainholder.Size = UDim2.new(0, 500, 0, 35)

	containers.Name = "containers"
	containers.Parent = mainholder

	tabholder.Name = "tabholder"
	tabholder.Parent = mainholder
	tabholder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	tabholder.BackgroundTransparency = 1.000
	tabholder.BorderSizePixel = 0
	tabholder.Position = UDim2.new(0.02, 0, 1.1, 0)
	tabholder.Size = UDim2.new(0, 480, 0, 28)

	tablist.Name = "tablist"
	tablist.Parent = tabholder
	tablist.FillDirection = Enum.FillDirection.Horizontal
	tablist.SortOrder = Enum.SortOrder.LayoutOrder
	tablist.Padding = UDim.new(0, 5)

	top.Name = "top"
	top.Parent = mainholder
	top.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	top.BorderSizePixel = 0
	top.Position = UDim2.new(0, 0, 0, 0)
	top.Size = UDim2.new(0, 500, 0, 35)

	minimize.Name = "minimize"
	minimize.Parent = top
	minimize.BackgroundTransparency = 1.000
	minimize.LayoutOrder = 6
	minimize.Position = UDim2.new(0.94, 0, 0.2, 0)
	minimize.Size = UDim2.new(0, 24, 0, 24)
	minimize.ZIndex = 2
	minimize.Image = "rbxassetid://3926307971"
	minimize.ImageRectOffset = Vector2.new(884, 284)
	minimize.ImageRectSize = Vector2.new(36, 36)

	title.Name = "title"
	title.Parent = top
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1.000
	title.BorderSizePixel = 0
	title.Position = UDim2.new(0.02, 0, 0.1, 0)
	title.Size = UDim2.new(0, 200, 0, 28)
	title.Font = Enum.Font.GothamBold
	title.Text = text
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16.000
	title.TextXAlignment = Enum.TextXAlignment.Left

	minimize.MouseButton1Click:Connect(function()
		if mini == false then
			mainframe:TweenSize(UDim2.new(0, 500, 0, 35), "Out", "Quad", 0.25)
			mini = not mini
		else
			mainframe:TweenSize(UDim2.new(0, 500, 0, 320), "In", "Quad", 0.25)
			mini = not mini
		end
	end)

	local tabs = {}

	function tabs:Tab(tabTitle)
		local tabbtn = Instance.new("TextButton")
		local tabbtnBorder = Instance.new("UIStroke")
		local containerpadding = Instance.new("UIPadding")
		local container = Instance.new("ScrollingFrame")
		local containerlist = Instance.new("UIListLayout")
		
		tabbtn.Name = "tabbtn"
		tabbtn.Parent = tabholder
		tabbtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
		tabbtn.BorderSizePixel = 0
		tabbtn.BackgroundTransparency = 1
		tabbtn.AutoButtonColor = false
		tabbtn.Font = Enum.Font.GothamBold
		tabbtn.Text = tabTitle
		tabbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabbtn.TextSize = 14.000
		tabbtn.Size = UDim2.new(0, tabbtn.TextBounds.X + 25, 0, 28)

		
		tabbtnBorder.Parent = tabbtn
		tabbtnBorder.Color = Color3.fromRGB(70, 70, 70)
		tabbtnBorder.Thickness = 1.5

		container.Name = "container"
		container.Parent = containers
		container.Active = true
		container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		container.BorderSizePixel = 0
		container.Position = UDim2.new(0.02, 0, 2.2, 0)
		container.Size = UDim2.new(0, 480, 0, 235)
		container.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		container.CanvasSize = UDim2.new(0, 0, 0, 0)
		container.ScrollBarThickness = 5
		container.Visible = vistab
		container.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

		containerpadding.Name = "containerpadding"
		containerpadding.Parent = container
		containerpadding.PaddingLeft = UDim.new(0, 8)
		containerpadding.PaddingTop = UDim.new(0, 8)

		containerlist.Name = "containerlist"
		containerlist.Parent = container
		containerlist.SortOrder = Enum.SortOrder.LayoutOrder
		containerlist.Padding = UDim.new(0, 6)

		if ft == false then
			ft = true
			vistab = false
			tabbtn.BackgroundTransparency = 0
		end

		tabbtn.MouseButton1Click:Connect(function()
			for i, v in next, containers:GetChildren() do
				if v.Name == "container" then
					v.Visible = false
				end
			end
			for i, v in next, tabholder:GetChildren() do
				if v.ClassName == "TextButton" then
					v.BackgroundTransparency = 1
				end
			end
			tabbtn.BackgroundTransparency = 0
			container.Visible = true
		end)

		local tab = {}

		function tab:Button(btnText, callback)
			callback = callback or function() end
			
			local button = Instance.new("TextButton")
			local buttonBorder = Instance.new("UIStroke")
			
			button.Name = "button"
			button.Parent = container
			button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			button.BorderSizePixel = 0
			button.AutoButtonColor = false
			button.Font = Enum.Font.Gotham
			button.Text = btnText
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.TextSize = 15.000
			button.Size = UDim2.new(0, 460, 0, 38)
			button.ClipsDescendants = true

		
			buttonBorder.Parent = button
			buttonBorder.Color = Color3.fromRGB(80, 80, 80)
			buttonBorder.Thickness = 2

			local me = TweenService:Create(
				button,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
			)

			local ml = TweenService:Create(
				button,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
			)

			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			button.MouseEnter:Connect(function() me:Play() end)
			button.MouseLeave:Connect(function() ml:Play() end)
			button.MouseButton1Click:Connect(function()
				ripple(button)
				pcall(callback)
			end)
		end

		function tab:Toggle(toggleText, callback)
			local toggle = Instance.new("TextButton")
			local toggleBorder = Instance.new("UIStroke")
			local toggleTitle = Instance.new("TextLabel")
			local status = Instance.new("Frame")
			local statusBorder = Instance.new("UIStroke")
			local toggled = false
			callback = callback or function() end
			
			toggle.Name = "toggle"
			toggle.Parent = container
			toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			toggle.BorderSizePixel = 0
			toggle.ClipsDescendants = true
			toggle.AutoButtonColor = false
			toggle.Font = Enum.Font.SourceSans
			toggle.Text = ""
			toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			toggle.TextSize = 14.000
			toggle.Size = UDim2.new(0, 460, 0, 40)

			
			toggleBorder.Parent = toggle
			toggleBorder.Color = Color3.fromRGB(80, 80, 80)
			toggleBorder.Thickness = 2

			toggleTitle.Name = "title"
			toggleTitle.Parent = toggle
			toggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			toggleTitle.BackgroundTransparency = 1.000
			toggleTitle.BorderSizePixel = 0
			toggleTitle.Position = UDim2.new(0, 50, 0, 0)
			toggleTitle.Font = Enum.Font.Gotham
			toggleTitle.Text = toggleText
			toggleTitle.Size = UDim2.new(0, 400, 1, 0)
			toggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			toggleTitle.TextSize = 15.000
			toggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			status.Name = "status"
			status.Parent = toggle
			status.AnchorPoint = Vector2.new(0, 0.5)
			status.BackgroundColor3 = Color3.fromRGB(255, 49, 49)
			status.BorderSizePixel = 0
			status.Position = UDim2.new(0, 12, 0.5, 0)
			status.Size = UDim2.new(0, 26, 0, 26)

			
			statusBorder.Parent = status
			statusBorder.Color = Color3.fromRGB(120, 120, 120)
			statusBorder.Thickness = 2

			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			local me = TweenService:Create(
				toggle,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
			)

			local ml = TweenService:Create(
				toggle,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
			)

			local truetoggle = TweenService:Create(
				status,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(81, 255, 55)}
			)

			local falsetoggle = TweenService:Create(
				status,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(255, 49, 49)}
			)

			toggle.MouseEnter:Connect(function() me:Play() end)
			toggle.MouseLeave:Connect(function() ml:Play() end)

			toggle.MouseButton1Click:Connect(function()
				if toggled == false then
					truetoggle:Play()
					toggled = not toggled
				else
					falsetoggle:Play()
					toggled = not toggled
				end
				ripple(toggle)
				callback(toggled)
			end)
		end

		function tab:Slider(sliderText, min, max, start, callback)
			local slider = Instance.new("Frame")
			local sliderBorder = Instance.new("UIStroke")
			local sliderTitle = Instance.new("TextLabel")
			local placetoslide = Instance.new("TextButton")
			local placetoslideBorder = Instance.new("UIStroke")
			local slideframe = Instance.new("Frame")
			local value = Instance.new("TextLabel")
			local dragging = false

			slider.Name = "slider"
			slider.Parent = container
			slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			slider.BackgroundTransparency = 0
			slider.BorderSizePixel = 0
			slider.Size = UDim2.new(0, 460, 0, 42)

		
			sliderBorder.Parent = slider
			sliderBorder.Color = Color3.fromRGB(80, 80, 80)
			sliderBorder.Thickness = 2

			sliderTitle.Name = "title"
			sliderTitle.Parent = slider
			sliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sliderTitle.BackgroundTransparency = 1.000
			sliderTitle.BorderSizePixel = 0
			sliderTitle.Position = UDim2.new(0, 10, 0, 0)
			sliderTitle.Size = UDim2.new(0, 200, 0, 20)
			sliderTitle.ZIndex = 2
			sliderTitle.Font = Enum.Font.Gotham
			sliderTitle.Text = sliderText
			sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			sliderTitle.TextSize = 15.000
			sliderTitle.TextXAlignment = Enum.TextXAlignment.Left

			placetoslide.Name = "placetoslide"
			placetoslide.Parent = slider
			placetoslide.AnchorPoint = Vector2.new(0.5, 0)
			placetoslide.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			placetoslide.BorderSizePixel = 0
			placetoslide.Position = UDim2.new(0.5, 0, 0.52, 0)
			placetoslide.Size = UDim2.new(0, 440, 0, 16)
			placetoslide.AutoButtonColor = false
			placetoslide.Text = ""

			
			placetoslideBorder.Parent = placetoslide
			placetoslideBorder.Color = Color3.fromRGB(90, 90, 90)
			placetoslideBorder.Thickness = 1.5

			slideframe.Name = "slideframe"
			slideframe.Parent = placetoslide
			slideframe.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
			slideframe.BorderSizePixel = 0
			slideframe.Size = UDim2.new((start or 0) / max, 0, 1, 0)

			value.Name = "value"
			value.Parent = placetoslide
			value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			value.BackgroundTransparency = 1.000
			value.BorderSizePixel = 0
			value.Size = UDim2.new(1, 0, 1, 0)
			value.Font = Enum.Font.GothamBold
			value.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
			value.TextColor3 = Color3.fromRGB(255, 255, 255)
			value.TextSize = 13.000
			
			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			local function slide(input)
				local pos = UDim2.new(
					math.clamp((input.Position.X - placetoslide.AbsolutePosition.X) / placetoslide.AbsoluteSize.X, 0, 1),
					0, 1, 0
				)
				slideframe:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
				local s = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
				value.Text = tostring(s)
				callback(s)
			end

			placetoslide.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or 
				   input.UserInputType == Enum.UserInputType.Touch then
					slide(input)
					dragging = true
				end
			end)

			placetoslide.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or 
				   input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
								 input.UserInputType == Enum.UserInputType.Touch) then
					slide(input)
				end
			end)
		end

		function tab:Dropdown(dropText, list, callback)
			list = list or {}
			local d = false
			callback = callback or function() end
			
			local dropdown = Instance.new("TextButton")
			local dropdownBorder = Instance.new("UIStroke")
			local dropTitle = Instance.new("TextLabel")
			local arrow = Instance.new("ImageButton")
			local dropdowncontainer = Instance.new("ScrollingFrame")
			local dropdowncontainerBorder = Instance.new("UIStroke")
			local dropdownlist = Instance.new("UIListLayout")

			dropdown.Name = "dropdown"
			dropdown.Parent = container
			dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			dropdown.BorderSizePixel = 0
			dropdown.Size = UDim2.new(0, 460, 0, 40)
			dropdown.ZIndex = 2
			dropdown.AutoButtonColor = false
			dropdown.Font = Enum.Font.SourceSans
			dropdown.Text = ""
			dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
			dropdown.TextSize = 14.000
			dropdown.ClipsDescendants = false

			
			dropdownBorder.Parent = dropdown
			dropdownBorder.Color = Color3.fromRGB(80, 80, 80)
			dropdownBorder.Thickness = 2

			local t = TweenService:Create(
				dropdown,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
			)

			local nt = TweenService:Create(
				dropdown,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
			)

			local closetween = TweenService:Create(
				arrow,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{Rotation = 90}
			)
			
			local opentween = TweenService:Create(
				arrow,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{Rotation = 0}
			)

			dropTitle.Name = "title"
			dropTitle.Parent = dropdown
			dropTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dropTitle.BackgroundTransparency = 1.000
			dropTitle.BorderSizePixel = 0
			dropTitle.Position = UDim2.new(0, 12, 0, 0)
			dropTitle.Size = UDim2.new(0, 400, 1, 0)
			dropTitle.Font = Enum.Font.Gotham
			dropTitle.Text = dropText
			dropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropTitle.TextSize = 15.000
			dropTitle.TextXAlignment = Enum.TextXAlignment.Left

			arrow.Name = "arrow"
			arrow.Parent = dropdown
			arrow.BackgroundTransparency = 1.000
			arrow.LayoutOrder = 11
			arrow.Position = UDim2.new(0.92, 0, 0.25, 0)
			arrow.Size = UDim2.new(0, 20, 0, 20)
			arrow.ZIndex = 2
			arrow.Image = "rbxassetid://3926305904"
			arrow.ImageRectOffset = Vector2.new(564, 284)
			arrow.ImageRectSize = Vector2.new(36, 36)
			arrow.Rotation = 90

			dropdowncontainer.Name = "dropdowncontainer"
			dropdowncontainer.Parent = dropdown
			dropdowncontainer.Active = true
			dropdowncontainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			dropdowncontainer.BorderSizePixel = 0
			dropdowncontainer.Position = UDim2.new(0, 0, 1, 0)
			dropdowncontainer.Size = UDim2.new(0, 460, 0, 0)
			dropdowncontainer.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			dropdowncontainer.CanvasSize = UDim2.new(0, 0, 0, 0)
			dropdowncontainer.ScrollBarThickness = 4
			dropdowncontainer.Visible = false
			dropdowncontainer.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			dropdowncontainer.ZIndex = 3
      
			dropdowncontainerBorder.Parent = dropdowncontainer
			dropdowncontainerBorder.Color = Color3.fromRGB(80, 80, 80)
			dropdowncontainerBorder.Thickness = 2

			dropdownlist.Name = "dropdownlist"
			dropdownlist.Parent = dropdowncontainer
			dropdownlist.SortOrder = Enum.SortOrder.LayoutOrder

			dropdown.MouseButton1Click:Connect(function()
				if d == false then
					d = not d
					opentween:Play()
					dropdowncontainer.Visible = true
					t:Play()
					dropdowncontainer:TweenSize(UDim2.new(0, 460, 0, math.min(120, #list * 35)), "In", "Quad", 0.25)
					container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 130)
				else
					d = not d
					closetween:Play()
					nt:Play()
					dropdowncontainer:TweenSize(UDim2.new(0, 460, 0, 0), "Out", "Quad", 0.25)
					container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)
					wait(0.3)
					dropdowncontainer.Visible = false
				end
			end)
			
			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			for i, v in next, list do
				local option = Instance.new("TextButton")
				local optionBorder = Instance.new("UIStroke")
				
				option.Name = "option"
				option.Parent = dropdowncontainer
				

				option.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				option.BorderSizePixel = 0
				option.Size = UDim2.new(0, 460, 0, 35)
				option.AutoButtonColor = false
				option.Font = Enum.Font.Gotham
				option.TextColor3 = Color3.fromRGB(255, 255, 255)
				option.TextSize = 14.000
				option.Text = v
				option.ZIndex = 3

				
				optionBorder.Parent = option
				optionBorder.Color = Color3.fromRGB(70, 70, 70)
				optionBorder.Thickness = 1

				local me = TweenService:Create(
					option,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundColor3 = Color3.fromRGB(60, 60, 60)}
				)

				local ml = TweenService:Create(
					option,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
				)

				option.MouseEnter:Connect(function()
					me:Play()
				end)
				
				option.MouseLeave:Connect(function()
					ml:Play()
				end)

				option.MouseButton1Click:Connect(function()
					dropTitle.Text = v
					d = not d
					closetween:Play()
					nt:Play()
					dropdowncontainer:TweenSize(UDim2.new(0, 460, 0, 0), "Out", "Quad", 0.25)
					container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)
					wait(0.3)
					dropdowncontainer.Visible = false
					callback(v)
				end)
				
				dropdowncontainer.CanvasSize = UDim2.new(0, 0, 0, dropdownlist.AbsoluteContentSize.Y)
			end
		end

		function tab:Textbox(textboxText, disappear, callback)
			callback = callback or function() end
			
			local textbox = Instance.new("Frame")
			local textboxBorder = Instance.new("UIStroke")
			local textboxTitle = Instance.new("TextLabel")
			local textboxframe = Instance.new("Frame")
			local textboxframeBorder = Instance.new("UIStroke")
			local textboxmain = Instance.new("TextBox")

			textbox.Name = "textbox"
			textbox.Parent = container
			textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			textbox.BackgroundTransparency = 0
			textbox.BorderSizePixel = 0
			textbox.Size = UDim2.new(0, 460, 0, 42)

			
			textboxBorder.Parent = textbox
			textboxBorder.Color = Color3.fromRGB(80, 80, 80)
			textboxBorder.Thickness = 2

			textboxTitle.Name = "title"
			textboxTitle.Parent = textbox
			textboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			textboxTitle.BackgroundTransparency = 1.000
			textboxTitle.BorderSizePixel = 0
			textboxTitle.Position = UDim2.new(0, 10, 0, 0)
			textboxTitle.Size = UDim2.new(0, 200, 0, 20)
			textboxTitle.ZIndex = 2
			textboxTitle.Font = Enum.Font.Gotham
			textboxTitle.Text = textboxText
			textboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			textboxTitle.TextSize = 15.000
			textboxTitle.TextXAlignment = Enum.TextXAlignment.Left

			textboxframe.Name = "textboxframe"
			textboxframe.Parent = textbox
			textboxframe.AnchorPoint = Vector2.new(0.5, 0)
			textboxframe.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			textboxframe.BorderSizePixel = 0
			textboxframe.Position = UDim2.new(0.5, 0, 0.52, 0)
			textboxframe.Size = UDim2.new(0, 440, 0, 18)

			
			textboxframeBorder.Parent = textboxframe
			textboxframeBorder.Color = Color3.fromRGB(90, 90, 90)
			textboxframeBorder.Thickness = 1.5

			textboxmain.Name = "textboxmain"
			textboxmain.Parent = textboxframe
			textboxmain.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			textboxmain.BackgroundTransparency = 1
			textboxmain.BorderSizePixel = 0
			textboxmain.Size = UDim2.new(1, -8, 1, 0)
			textboxmain.Position = UDim2.new(0, 4, 0, 0)
			textboxmain.Font = Enum.Font.Gotham
			textboxmain.Text = ""
			textboxmain.PlaceholderText = "Enter text..."
			textboxmain.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			textboxmain.TextColor3 = Color3.fromRGB(255, 255, 255)
			textboxmain.TextSize = 14.000
			textboxmain.TextXAlignment = Enum.TextXAlignment.Left
			textboxmain.ClearTextOnFocus = false
			
			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			
			textboxmain.Focused:Connect(function()
				TweenService:Create(
					textboxframeBorder,
					TweenInfo.new(0.2),
					{Color = Color3.fromRGB(70, 140, 255)}
				):Play()
			end)

			textboxmain.FocusLost:Connect(function(ep)
				TweenService:Create(
					textboxframeBorder,
					TweenInfo.new(0.2),
					{Color = Color3.fromRGB(90, 90, 90)}
				):Play()
				
				if ep then
					if #textboxmain.Text > 0 then
						pcall(callback, textboxmain.Text)
						if disappear then
							textboxmain.Text = ""
						end
					end
				end
			end)
		end

		function tab:Label(labelText)
			local label = Instance.new("TextLabel")
			local labelBorder = Instance.new("UIStroke")

			label.Name = "label"
			label.Parent = container
			label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			label.BorderSizePixel = 0
			label.Size = UDim2.new(0, 460, 0, 32)
			label.Font = Enum.Font.GothamBold
			label.Text = labelText
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextSize = 15.000
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Center

			
			local padding = Instance.new("UIPadding")
			padding.Parent = label
			padding.PaddingLeft = UDim.new(0, 12)

			-- Add border
			labelBorder.Parent = label
			labelBorder.Color = Color3.fromRGB(80, 80, 80)
			labelBorder.Thickness = 2

			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)

			return {
				SetText = function(self, newText)
					label.Text = newText
				end
			}
		end

		function tab:Seperator()
			local seperator = Instance.new("Frame")

			seperator.Name = "seperator"
			seperator.Parent = container
			seperator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			seperator.BorderSizePixel = 0
			seperator.Size = UDim2.new(0, 460, 0, 2)

			container.CanvasSize = UDim2.new(0, 0, 0, containerlist.AbsoluteContentSize.Y + 15)
		end

		return tab
	end
	return tabs
end

return lib
