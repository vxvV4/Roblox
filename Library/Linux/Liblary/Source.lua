--[[
              =
             ====
            =======
           ==========
          ============
         ===============
        ==================
         //. Aux Hub  .\\
        // Linux Library \\
// Made By VantaXock X Shizoscript \\

--]]
local library = {flags = {}, windows = {}, open = true}

--// Services \\--
local runService = game:GetService"RunService"
local tweenService = game:GetService"TweenService"
local textService = game:GetService"TextService"
local inputService = game:GetService"UserInputService"
local ui = Enum.UserInputType.MouseButton1

--// Locals \\--
local dragging, dragInput, dragStart, startPos, dragObject

--// Chroma Color \\--
local chromaColor
local rainbowTime = 5
spawn(function()
	while wait() do
		chromaColor = Color3.fromHSV(tick() % rainbowTime / rainbowTime, 1, 1)
	end
end)

--// Functions \\--
local function update(input)
	local delta = input.Position - dragStart
	local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
	dragObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos)
end

function library:Create(class, properties)
	properties = typeof(properties) == "table" and properties or {}
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

local function createOptionHolder(holderTitle, parent, parentTable, subHolder)
	local size = subHolder and 30 or 35
	parentTable.main = library:Create("Frame", {
		LayoutOrder = subHolder and parentTable.position or 0,
		Position = UDim2.new(0, 20 + (180 * (parentTable.position or 0)), 0, 20),
		Size = UDim2.new(0, 170, 0, size),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		ClipsDescendants = true,
		Parent = parent
	})
	
	local round
	if not subHolder then
		round = library:Create("Frame", {
			Size = UDim2.new(1, 0, 0, size),
			BackgroundColor3 = parentTable.open and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(40, 40, 40),
			BorderSizePixel = 0,
			Parent = parentTable.main
		})
	end
	
	local title = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 0, size),
		BackgroundTransparency = subHolder and 0 or 1,
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 0,
		Text = holderTitle,
		TextSize = subHolder and 14 or 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
		Parent = parentTable.main
	})
	
	local closeHolder = library:Create("Frame", {
		Position = UDim2.new(1, -size, 0, 0),
		Size = UDim2.new(0, size, 0, size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local closeButton = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = closeHolder
	})
	
	local close = library:Create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = parentTable.open and "▼" or "▶",
		TextSize = 10,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = parentTable.open and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100),
		Parent = closeHolder
	})
	
	parentTable.content = library:Create("Frame", {
		Position = UDim2.new(0, 0, 0, size),
		Size = UDim2.new(1, 0, 1, -size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local layout = library:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parentTable.content
	})
	
	layout.Changed:connect(function()
		parentTable.content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)
	
	if not subHolder then
		library:Create("UIPadding", {
			Parent = parentTable.content
		})
		
		title.InputBegan:connect(function(input)
			if input.UserInputType == ui then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			end
		end)
		title.InputChanged:connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			elseif dragging and input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		title.InputEnded:connect(function(input)
			if input.UserInputType == ui then
				dragging = false
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	
	closeButton.MouseButton1Click:connect(function()
		parentTable.open = not parentTable.open
		close.Text = parentTable.open and "▼" or "▶"
		close.TextColor3 = parentTable.open and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100)
		if subHolder then
			title.BackgroundColor3 = parentTable.open and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(45, 45, 45)
		else
			round.BackgroundColor3 = parentTable.open and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(40, 40, 40)
		end
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)

	function parentTable:SetTitle(newTitle)
		title.Text = tostring(newTitle)
	end
	
	return parentTable
end

--// BUTTON \\--
local function createButton(option, parent)
	local main = library:Create("TextLabel", {
		ZIndex = 2,
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = round
	})
	
	local inContact
	local clicking
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			library.flags[option.flag] = true
			clicking = true
			round.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			option.callback()
		elseif input.UserInputType == Enum.UserInputType.Touch then
			library.flags[option.flag] = true
			clicking = true
			round.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			option.callback()
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not clicking then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == ui then
			clicking = false
			if inContact then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			else
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			clicking = false
			if inContact then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			else
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not clicking then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
end

--// TOGGLE \\--
local function createToggle(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local tickboxOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(-1, 8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = option.state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local tickboxInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = option.state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Parent = tickboxOutline
	})
	
	local checkmarkHolder = library:Create("Frame", {
		Position = UDim2.new(0, 3, 0, 3),
		Size = option.state and UDim2.new(1, -6, 1, -6) or UDim2.new(0, 0, 1, -6),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = tickboxOutline
	})
	
	local checkmark = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Text = "✓",
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(60, 60, 60),
		Parent = checkmarkHolder
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = main
	})
	
	local inContact
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			option:SetState(not option.state)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			option:SetState(not option.state)
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.state then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.state then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	function option:SetState(state)
		library.flags[self.flag] = state
		self.state = state
		checkmarkHolder.Size = option.state and UDim2.new(1, -6, 1, -6) or UDim2.new(0, 0, 1, -6)
		tickboxInner.BackgroundColor3 = state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(60, 60, 60)
		if state then
			tickboxOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		else
			if inContact then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
		self.callback(state)
	end

	if option.state then
		delay(1, function() option.callback(true) end)
	end
end

--// MULTI DROPDOWN \\--
local function createMultiDropdown(option, parent)
	local valueCount = 0
	
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local titleLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 6),
		Size = UDim2.new(1, -10, 0, 12),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = round
	})
	
	local valueLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 18),
		Size = UDim2.new(1, -20, 0, 20),
		BackgroundTransparency = 1,
		Text = "None",
		TextSize = 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = round
	})
	
	local arrow = library:Create("TextLabel", {
		Position = UDim2.new(1, -13, 0, 13),
		Size = UDim2.new(-1, 26, 1, -26),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Text = "▼",
		Rotation = 90,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		Parent = round
	})
	
	option.mainHolder = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(0, 180, 0, 44),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Visible = false,
		Parent = library.base
	})
	
	local content = library:Create("ScrollingFrame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.fromRGB(),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = option.mainHolder
	})
	
	library:Create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		Parent = content
	})
	
	local layout = library:Create("UIListLayout", {
		Parent = content
	})
	
	layout.Changed:connect(function()
		option.mainHolder.Size = UDim2.new(0, 180, 0, (valueCount > 4 and (4 * 34) or layout.AbsoluteContentSize.Y) + 10)
		content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)
	
	local inContact
	round.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
			content.ScrollBarThickness = 5
		elseif input.UserInputType == Enum.UserInputType.Touch then
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
			content.ScrollBarThickness = 5
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	round.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
	
	function option:AddValue(value)
		valueCount = valueCount + 1
		local isSelected = false
		for _, v in pairs(self.values) do
			if v == value then
				isSelected = true
				break
--// MULTI DROPDOWN \\--
local function createMultiDropdown(option, parent)
	local valueCount = 0
	
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local titleLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 6),
		Size = UDim2.new(1, -10, 0, 12),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = round
	})
	
	local valueLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 18),
		Size = UDim2.new(1, -20, 0, 20),
		BackgroundTransparency = 1,
		Text = "None",
		TextSize = 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = round
	})
	
	local arrow = library:Create("TextLabel", {
		Position = UDim2.new(1, -13, 0, 13),
		Size = UDim2.new(-1, 26, 1, -26),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Text = "▼",
		Rotation = 90,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		Parent = round
	})
	
	option.mainHolder = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(0, 180, 0, 44),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Visible = false,
		Parent = library.base
	})
	
	local content = library:Create("ScrollingFrame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = option.mainHolder
	})
	
	library:Create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		Parent = content
	})
	
	local layout = library:Create("UIListLayout", {
		Parent = content
	})
	
	layout.Changed:connect(function()
		option.mainHolder.Size = UDim2.new(0, 180, 0, (valueCount > 4 and (4 * 34) or layout.AbsoluteContentSize.Y) + 10)
		content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)
	
	local inContact
	local roundButton = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = round
	})
	
	roundButton.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
			content.ScrollBarThickness = 5
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	roundButton.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
	
	option.items = {}
	
	function option:AddValue(value)
		valueCount = valueCount + 1
		local isSelected = false
		for _, v in pairs(self.values) do
			if v == value then
				isSelected = true
				break
			end
		end
		
		local label = library:Create("TextLabel", {
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Text = value,
			TextSize = 14,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = content
		})
		
		library:Create("UIPadding", {
			PaddingLeft = UDim.new(0, 32),
			Parent = label
		})
		
		local checkbox = library:Create("Frame", {
			ZIndex = 4,
			Position = UDim2.new(0, 8, 0, 9),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundColor3 = isSelected and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(50, 50, 50),
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(40, 40, 40),
			Parent = label
		})
		
		local check = library:Create("TextLabel", {
			ZIndex = 5,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = isSelected and "✓" or "",
			TextSize = 14,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Parent = checkbox
		})
		
		local button = library:Create("TextButton", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = label
		})
		
		local itemInContact = false
		local startPosition = nil
		local isScrolling = false
		
		button.InputBegan:connect(function(input)
			if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
				startPosition = input.Position
				isScrolling = false
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				itemInContact = true
				if not isScrolling then
					label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				end
			end
		end)
		
		button.InputChanged:connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and startPosition then
				local delta = (input.Position - startPosition).Magnitude
				if delta > 5 then
					isScrolling = true
				end
			end
		end)
		
		button.InputEnded:connect(function(input)
			if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
				if startPosition and not isScrolling then
					local delta = (input.Position - startPosition).Magnitude
					if delta < 5 then
						label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
						self:Toggle(value)
						wait(0.1)
					end
				end
				startPosition = nil
				isScrolling = false
				label.BackgroundColor3 = itemInContact and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(70, 70, 70)
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				itemInContact = false
				label.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			end
		end)
		
		self.items[value] = {label = label, checkbox = checkbox, check = check}
	end
	
	for _, value in next, option.list do
		option:AddValue(tostring(value))
	end
	
	function option:Toggle(value)
		local index = nil
		for i, v in pairs(self.values) do
			if v == value then
				index = i
				break
			end
		end
		
		if index then
			table.remove(self.values, index)
			if self.items[value] then
				self.items[value].checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				self.items[value].check.Text = ""
			end
		else
			table.insert(self.values, value)
			if self.items[value] then
				self.items[value].checkbox.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
				self.items[value].check.Text = "✓"
			end
		end
		
		local text = #self.values > 0 and table.concat(self.values, ", ") or "None"
		valueLabel.Text = text
		library.flags[self.flag] = self.values
		self.callback(self.values)
	end
	
	function option:Close()
		library.activePopup = nil
		self.open = false
		content.ScrollBarThickness = 0
		round.BackgroundColor3 = inContact and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(80, 80, 80)
		wait(0.3)
		if not self.open then
			self.mainHolder.Visible = false
		end
	end

	return option
end

--// TEXTBOX \\--
local function createBox(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local titleLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 6),
		Size = UDim2.new(1, -10, 0, 12),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = round
	})
	
	local inputvalue = library:Create("TextBox", {
		Position = UDim2.new(0, 5, 0, 18),
		Size = UDim2.new(1, -10, 0, 20),
		BackgroundTransparency = 1,
		Text = option.value,
		TextSize = 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		PlaceholderText = "",
		ClearTextOnFocus = false,
		Parent = round
	})
	
	local inContact
	local focused
	round.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			if not focused then inputvalue:CaptureFocus() end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			if not focused then inputvalue:CaptureFocus() end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not focused then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	round.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not focused then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
	
	inputvalue.Focused:connect(function()
		focused = true
		round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end)
	
	inputvalue.FocusLost:connect(function(enter)
		focused = false
		round.BackgroundColor3 = inContact and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(80, 80, 80)
		option:SetValue(inputvalue.Text, enter)
	end)
	
	function option:SetValue(value, enter)
		library.flags[self.flag] = tostring(value)
		self.value = tostring(value)
		inputvalue.Text = self.value
		self.callback(value, enter)
	end
	
	return option
end

--// LABEL \\--
local function createLabel(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	function option:SetText(newText)
		self.text = tostring(newText)
		main.Text = " " .. self.text
	end
	
	return option
end

--// SLIDER \\--
local function createSlider(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local title = library:Create("TextLabel", {
		Position = UDim2.new(0, 0, 0, 3),
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	local slider = library:Create("Frame", {
		Position = UDim2.new(0, 8, 0, 28),
		Size = UDim2.new(1, -16, 0, 4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = main
	})
	
	local fill = library:Create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = slider
	})
	
	local circle = library:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = slider
	})
	
	local valueRound = library:Create("Frame", {
		Position = UDim2.new(1, -55, 0, 3),
		Size = UDim2.new(0, 50, 0, 15),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local inputvalue = library:Create("TextBox", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.value,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextWrapped = true,
		Font = Enum.Font.SourceSansBold,
		Parent = valueRound
	})
	
	if option.min >= 0 then
		fill.Size = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 1, 0)
	else
		fill.Position = UDim2.new((0 - option.min) / (option.max - option.min), 0, 0, 0)
		fill.Size = UDim2.new(option.value / (option.max - option.min), 0, 1, 0)
	end
	
	local sliding
	local inContact
	main.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			fill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			circle.Size = UDim2.new(0, 12, 0, 12)
			circle.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			sliding = true
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		elseif input.UserInputType == Enum.UserInputType.Touch then
			fill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			circle.Size = UDim2.new(0, 12, 0, 12)
			circle.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			sliding = true
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not sliding then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	inputService.InputChanged:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		end
	end)

	main.InputEnded:connect(function(input)
		if input.UserInputType == ui then
			sliding = false
			if inContact then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
			if inContact then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			inputvalue:ReleaseFocus()
			if not sliding then
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)

	inputvalue.FocusLost:connect(function()
		circle.Size = UDim2.new(0, 0, 0, 0)
		circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		option:SetValue(tonumber(inputvalue.Text) or option.value)
	end)

	function option:SetValue(value)
		value = math.floor(value / option.float + 0.5) * option.float
		value = math.clamp(value, self.min, self.max)
		circle.Position = UDim2.new((value - self.min) / (self.max - self.min), 0, 0.5, 0)
		if self.min >= 0 then
			fill.Size = UDim2.new((value - self.min) / (self.max - self.min), 0, 1, 0)
		else
			fill.Position = UDim2.new((0 - self.min) / (self.max - self.min), 0, 0, 0)
			fill.Size = UDim2.new(value / (self.max - self.min), 0, 1, 0)
		end
		library.flags[self.flag] = value
		self.value = value
		inputvalue.Text = value
		self.callback(value)
	end
	
	return option
end

--// KEYBIND \\--
local function createBind(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local bindOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(0, -60, 1, -8),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local bindInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Parent = bindOutline
	})
	
	local bindLabel = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.key,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = bindInner
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = main
	})
	
	local inContact
	local selecting
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			selecting = true
			bindLabel.Text = "..."
			bindOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			selecting = true
			bindLabel.Text = "..."
			bindOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not selecting then
				bindOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not selecting then
				bindOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	inputService.InputBegan:connect(function(input)
		if selecting then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local key = input.KeyCode.Name
				if key == "Escape" then
					option:SetKey("None")
				else
					option:SetKey(key)
				end
				selecting = false
				bindOutline.BackgroundColor3 = inContact and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(100, 100, 100)
			end
		elseif option.key ~= "None" and input.KeyCode.Name == option.key then
			option.callback()
		end
	end)
	
	function option:SetKey(key)
		library.flags[self.flag] = key
		self.key = key
		bindLabel.Text = key
	end
	
	return option
end

--// COLOR PICKER WINDOW \\--
local function createColorPickerWindow(option)
	option.mainHolder = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(0, 180, 0, 180),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Visible = false,
		Parent = library.base
	})
	
	local hue, sat, val = Color3.toHSV(option.color)
	hue, sat, val = hue == 0 and 1 or hue, sat + 0.005, val - 0.005
	local editinghue
	local editingsatval
	local currentColor = option.color
	local previousColors = {[1] = option.color}
	local originalColor = option.color
	local rainbowEnabled
	local rainbowLoop
	
	function option:updateVisuals(Color)
		currentColor = Color
		self.visualize2.BackgroundColor3 = Color
		hue, sat, val = Color3.toHSV(Color)
		hue = hue == 0 and 1 or hue
		self.satval.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		self.hueSlider.Position = UDim2.new(1 - hue, 0, 0, 0)
		self.satvalSlider.Position = UDim2.new(sat, 0, 1 - val, 0)
	end
	
	-- Hue Slider
	option.hue = library:Create("Frame", {
		ZIndex = 3,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 8, 1, -8),
		Size = UDim2.new(1, -70, 0, 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = option.mainHolder
	})
	
	local Gradient = library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Parent = option.hue
	})
	
	option.hueSlider = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1 - hue, 0, 0, 0),
		Size = UDim2.new(0, 2, 1, 0),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		Parent = option.hue
	})
	
	option.hue.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editinghue = true
			X = (option.hue.AbsolutePosition.X + option.hue.AbsoluteSize.X) - option.hue.AbsolutePosition.X
			X = (Input.Position.X - option.hue.AbsolutePosition.X) / X
			X = X < 0 and 0 or X > 0.995 and 0.995 or X
			option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
		end
	end)
	
	inputService.InputChanged:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement and editinghue then
			X = (option.hue.AbsolutePosition.X + option.hue.AbsoluteSize.X) - option.hue.AbsolutePosition.X
			X = (Input.Position.X - option.hue.AbsolutePosition.X) / X
			X = X <= 0 and 0 or X >= 0.995 and 0.995 or X
			option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
		end
	end)
	
	option.hue.InputEnded:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editinghue = false
		end
	end)
	
	-- Saturation/Value Picker
	option.satval = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -70, 1, -38),
		BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		ClipsDescendants = true,
		Parent = option.mainHolder
	})
	
	local satvalOverlay1 = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = option.satval
	})
	
	local satvalGradient1 = library:Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Parent = satvalOverlay1
	})
	
	local satvalOverlay2 = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Parent = option.satval
	})
	
	local satvalGradient2 = library:Create("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Parent = satvalOverlay2
	})
	
	option.satvalSlider = library:Create("Frame", {
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(sat, 0, 1 - val, 0),
		Size = UDim2.new(0, 4, 0, 4),
		Rotation = 45,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Parent = option.satval
	})
	
	option.satval.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editingsatval = true
			X = (option.satval.AbsolutePosition.X + option.satval.AbsoluteSize.X) - option.satval.AbsolutePosition.X
			Y = (option.satval.AbsolutePosition.Y + option.satval.AbsoluteSize.Y) - option.satval.AbsolutePosition.Y
			X = (Input.Position.X - option.satval.AbsolutePosition.X) / X
			Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / Y
			X = X <= 0.005 and 0.005 or X >= 1 and 1 or X
			Y = Y <= 0 and 0 or Y >= 0.995 and 0.995 or Y
			option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
		end
	end)
	
	inputService.InputChanged:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement and editingsatval then
			X = (option.satval.AbsolutePosition.X + option.satval.AbsoluteSize.X) - option.satval.AbsolutePosition.X
			Y = (option.satval.AbsolutePosition.Y + option.satval.AbsoluteSize.Y) - option.satval.AbsolutePosition.Y
			X = (Input.Position.X - option.satval.AbsolutePosition.X) / X
			Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / Y
			X = X <= 0.005 and 0.005 or X >= 1 and 1 or X
			Y = Y <= 0 and 0 or Y >= 0.995 and 0.995 or Y
			option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
		end
	end)
	
	option.satval.InputEnded:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editingsatval = false
		end
	end)
	
	-- Color Preview
	option.visualize2 = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 8),
		Size = UDim2.new(0, -50, 0, 50),
		BackgroundColor3 = currentColor,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = option.mainHolder
	})
	
	-- Reset Button
	option.resetColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 62),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.resetText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Reset",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.resetColor
	})
	
	local resetInContact
	option.resetColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				previousColors = {originalColor}
				option:SetColor(originalColor)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			resetInContact = true
			option.resetColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.resetColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			resetInContact = false
			option.resetColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Undo Button
	option.undoColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 82),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.undoText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Undo",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.undoColor
	})
	
	local undoInContact
	option.undoColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				local Num = #previousColors == 1 and 0 or 1
				option:SetColor(previousColors[#previousColors - Num])
				if #previousColors ~= 1 then
					table.remove(previousColors, #previousColors)
				end
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			undoInContact = true
			option.undoColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.undoColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			undoInContact = false
			option.undoColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Set Button
	option.setColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 102),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.setText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Set",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.setColor
	})
	
	local setInContact
	option.setColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				table.insert(previousColors, currentColor)
				option:SetColor(currentColor)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			setInContact = true
			option.setColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.setColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			setInContact = false
			option.setColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Rainbow Button
	option.rainbow = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 122),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.rainbowText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "RGB",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.rainbow
	})
	
	local rainbowInContact
	option.rainbow.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			rainbowEnabled = not rainbowEnabled
			if rainbowEnabled then
				rainbowLoop = runService.Heartbeat:connect(function()
					option:SetColor(chromaColor)
					option.rainbowText.TextColor3 = chromaColor
				end)
			else
				if rainbowLoop then
					rainbowLoop:Disconnect()
				end
				option:SetColor(previousColors[#previousColors])
				option.rainbowText.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			rainbowInContact = true
			option.rainbow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.rainbow.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			rainbowInContact = false
			option.rainbow.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	return option
end

--// COLOR PICKER \\--
local function createColor(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local colorBoxOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(-1, 8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local colorBoxInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = option.color,
		BorderSizePixel = 0,
		Parent = colorBoxOutline
	})
	
	local inContact
	main.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			if not option.mainHolder then createColorPickerWindow(option) end
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				colorBoxOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			end
		end
	end)
	
	main.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				colorBoxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	function option:SetColor(newColor)
		if self.mainHolder then
			self:updateVisuals(newColor)
		end
		colorBoxInner.BackgroundColor3 = newColor
		library.flags[self.flag] = newColor
		self.color = newColor
		self.callback(newColor)
	end
	
	function option:Close()
		library.activePopup = nil
		self.open = false
		colorBoxOutline.BackgroundColor3 = inContact and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100)
		wait(0.3)
		if not self.open then
			self.mainHolder.Visible = false
		end
	end
	
	return option
end

--// Load options Function \\--
local function loadOptions(option, holder)
	for _,newOption in next, option.options do
		if newOption.type == "button" then
			createButton(newOption, option)
		elseif newOption.type == "toggle" then
			createToggle(newOption, option)
		elseif newOption.type == "dropdown" then
			createMultiDropdown(newOption, option)
		elseif newOption.type == "box" then
			createBox(newOption, option)
		elseif newOption.type == "label" then
			createLabel(newOption, option)
		elseif newOption.type == "slider" then
			createSlider(newOption, option)
		elseif newOption.type == "bind" then
			createBind(newOption, option)
		elseif newOption.type == "color" then
			createColor(newOption, option)
		elseif newOption.type == "folder" then
			newOption:init()
		end
	end
end

local function getFnctions(parent)
	function parent:AddButton(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "button"
		option.position = #self.options
		option.flag = option.flag or option.text
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddToggle(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.state = typeof(option.state) == "boolean" and option.state or false
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "toggle"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.state
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddDropdown(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.list = typeof(option.list) == "table" and option.list or {}
		option.values = typeof(option.values) == "table" and option.values or {}
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.open = false
		option.type = "dropdown"
local library = {flags = {}, windows = {}, open = true}

--// Services \\--
local runService = game:GetService"RunService"
local tweenService = game:GetService"TweenService"
local textService = game:GetService"TextService"
local inputService = game:GetService"UserInputService"
local ui = Enum.UserInputType.MouseButton1

--// Locals \\--
local dragging, dragInput, dragStart, startPos, dragObject

--// Chroma Color \\--
local chromaColor
local rainbowTime = 5
spawn(function()
	while wait() do
		chromaColor = Color3.fromHSV(tick() % rainbowTime / rainbowTime, 1, 1)
	end
end)

--// Functions \\--
local function update(input)
	local delta = input.Position - dragStart
	local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
	dragObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos)
end

function library:Create(class, properties)
	properties = typeof(properties) == "table" and properties or {}
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

local function createOptionHolder(holderTitle, parent, parentTable, subHolder)
	local size = subHolder and 30 or 35
	parentTable.main = library:Create("Frame", {
		LayoutOrder = subHolder and parentTable.position or 0,
		Position = UDim2.new(0, 20 + (180 * (parentTable.position or 0)), 0, 20),
		Size = UDim2.new(0, 170, 0, size),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		ClipsDescendants = true,
		Parent = parent
	})
	
	local round
	if not subHolder then
		round = library:Create("Frame", {
			Size = UDim2.new(1, 0, 0, size),
			BackgroundColor3 = parentTable.open and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(40, 40, 40),
			BorderSizePixel = 0,
			Parent = parentTable.main
		})
	end
	
	local title = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 0, size),
		BackgroundTransparency = subHolder and 0 or 1,
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 0,
		Text = holderTitle,
		TextSize = subHolder and 14 or 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
		Parent = parentTable.main
	})
	
	local closeHolder = library:Create("Frame", {
		Position = UDim2.new(1, -size, 0, 0),
		Size = UDim2.new(0, size, 0, size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local closeButton = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = closeHolder
	})
	
	local close = library:Create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = parentTable.open and "▼" or "▶",
		TextSize = 10,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = parentTable.open and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100),
		Parent = closeHolder
	})
	
	parentTable.content = library:Create("Frame", {
		Position = UDim2.new(0, 0, 0, size),
		Size = UDim2.new(1, 0, 1, -size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local layout = library:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parentTable.content
	})
	
	layout.Changed:connect(function()
		parentTable.content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)
	
	if not subHolder then
		library:Create("UIPadding", {
			Parent = parentTable.content
		})
		
		title.InputBegan:connect(function(input)
			if input.UserInputType == ui then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			end
		end)
		title.InputChanged:connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			elseif dragging and input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		title.InputEnded:connect(function(input)
			if input.UserInputType == ui then
				dragging = false
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	
	closeButton.MouseButton1Click:connect(function()
		parentTable.open = not parentTable.open
		close.Text = parentTable.open and "▼" or "▶"
		close.TextColor3 = parentTable.open and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100)
		if subHolder then
			title.BackgroundColor3 = parentTable.open and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(45, 45, 45)
		else
			round.BackgroundColor3 = parentTable.open and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(40, 40, 40)
		end
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 170, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 170, 0, size)
	end)

	function parentTable:SetTitle(newTitle)
		title.Text = tostring(newTitle)
	end
	
	return parentTable
end

--// BUTTON \\--
local function createButton(option, parent)
	local main = library:Create("TextLabel", {
		ZIndex = 2,
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = round
	})
	
	local inContact
	local clicking
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			library.flags[option.flag] = true
			clicking = true
			round.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			option.callback()
		elseif input.UserInputType == Enum.UserInputType.Touch then
			library.flags[option.flag] = true
			clicking = true
			round.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			option.callback()
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not clicking then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == ui then
			clicking = false
			if inContact then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			else
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			clicking = false
			if inContact then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			else
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not clicking then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
end

--// TOGGLE \\--
local function createToggle(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local tickboxOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(-1, 8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = option.state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local tickboxInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = option.state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Parent = tickboxOutline
	})
	
	local checkmarkHolder = library:Create("Frame", {
		Position = UDim2.new(0, 3, 0, 3),
		Size = option.state and UDim2.new(1, -6, 1, -6) or UDim2.new(0, 0, 1, -6),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = tickboxOutline
	})
	
	local checkmark = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Text = "✓",
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(60, 60, 60),
		Parent = checkmarkHolder
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = main
	})
	
	local inContact
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			option:SetState(not option.state)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			option:SetState(not option.state)
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.state then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.state then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	function option:SetState(state)
		library.flags[self.flag] = state
		self.state = state
		checkmarkHolder.Size = option.state and UDim2.new(1, -6, 1, -6) or UDim2.new(0, 0, 1, -6)
		tickboxInner.BackgroundColor3 = state and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(60, 60, 60)
		if state then
			tickboxOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		else
			if inContact then
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				tickboxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
		self.callback(state)
	end

	if option.state then
		delay(1, function() option.callback(true) end)
	end
end

--// MULTI DROPDOWN \\--
local function createMultiDropdown(option, parent)
	local valueCount = 0
	
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local titleLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 6),
		Size = UDim2.new(1, -10, 0, 12),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = round
	})
	
	local valueLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 18),
		Size = UDim2.new(1, -20, 0, 20),
		BackgroundTransparency = 1,
		Text = "None",
		TextSize = 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = round
	})
	
	local arrow = library:Create("TextLabel", {
		Position = UDim2.new(1, -13, 0, 13),
		Size = UDim2.new(-1, 26, 1, -26),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Text = "▼",
		Rotation = 90,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		Parent = round
	})
	
	option.mainHolder = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(0, 180, 0, 44),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Visible = false,
		Parent = library.base
	})
	
	local content = library:Create("ScrollingFrame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.fromRGB(),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = option.mainHolder
	})
	
	library:Create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		Parent = content
	})
	
	local layout = library:Create("UIListLayout", {
		Parent = content
	})
	
	layout.Changed:connect(function()
		option.mainHolder.Size = UDim2.new(0, 180, 0, (valueCount > 4 and (4 * 34) or layout.AbsoluteContentSize.Y) + 10)
		content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)
	
	local inContact
	local roundButton = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = round
	})
	
	roundButton.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
			content.ScrollBarThickness = 5
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	roundButton.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
	
	option.items = {}
	
	function option:AddValue(value)
		valueCount = valueCount + 1
		local isSelected = false
		for _, v in pairs(self.values) do
			if v == value then
				isSelected = true
				break
			end
		end
		
		local label = library:Create("TextLabel", {
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Text = "        " .. value,
			TextSize = 12,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = content
		})
		
		local checkbox = library:Create("Frame", {
			ZIndex = 4,
			Position = UDim2.new(0, 8, 0, 9),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundColor3 = isSelected and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(50, 50, 50),
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(40, 40, 40),
			Parent = label
		})
		
		local check = library:Create("TextLabel", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = isSelected and "✓" or "",
			TextSize = 14,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Parent = checkbox
		})
		
		local button = library:Create("TextButton", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Parent = label
		})
		
		local itemInContact = false
		button.InputBegan:connect(function(input)
			if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
				label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				self:Toggle(value)
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				itemInContact = true
				label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			end
		end)
		
		button.InputEnded:connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				itemInContact = false
				label.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			end
		end)
		
		self.items[value] = {label = label, checkbox = checkbox, check = check}
	end
	
	for _, value in next, option.list do
		option:AddValue(tostring(value))
	end
	
	function option:Toggle(value)
		local index = nil
		for i, v in pairs(self.values) do
			if v == value then
				index = i
				break
			end
		end
		
		if index then
			table.remove(self.values, index)
			if self.items[value] then
				self.items[value].checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				self.items[value].check.Text = ""
			end
		else
			table.insert(self.values, value)
			if self.items[value] then
				self.items[value].checkbox.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
				self.items[value].check.Text = "✓"
			end
		end
		
		local text = #self.values > 0 and table.concat(self.values, ", ") or "None"
		valueLabel.Text = text
		library.flags[self.flag] = self.values
		self.callback(self.values)
	end
	
	function option:Close()
		library.activePopup = nil
		self.open = false
		content.ScrollBarThickness = 0
		round.BackgroundColor3 = inContact and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(80, 80, 80)
		wait(0.3)
		if not self.open then
			self.mainHolder.Visible = false
		end
	end

	return option
end

--// TEXTBOX \\--
local function createBox(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local round = library:Create("Frame", {
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(1, -10, 1, -8),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local titleLabel = library:Create("TextLabel", {
		Position = UDim2.new(0, 5, 0, 6),
		Size = UDim2.new(1, -10, 0, 12),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = round
	})
	
	local inputvalue = library:Create("TextBox", {
		Position = UDim2.new(0, 5, 0, 18),
		Size = UDim2.new(1, -10, 0, 20),
		BackgroundTransparency = 1,
		Text = option.value,
		TextSize = 15,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		PlaceholderText = "",
		ClearTextOnFocus = false,
		Parent = round
	})
	
	local inContact
	local focused
	round.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			if not focused then inputvalue:CaptureFocus() end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			if not focused then inputvalue:CaptureFocus() end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not focused then
				round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	round.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not focused then
				round.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			end
		end
	end)
	
	inputvalue.Focused:connect(function()
		focused = true
		round.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end)
	
	inputvalue.FocusLost:connect(function(enter)
		focused = false
		round.BackgroundColor3 = inContact and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(80, 80, 80)
		option:SetValue(inputvalue.Text, enter)
	end)
	
	function option:SetValue(value, enter)
		library.flags[self.flag] = tostring(value)
		self.value = tostring(value)
		inputvalue.Text = self.value
		self.callback(value, enter)
	end
	
	return option
end

--// LABEL \\--
local function createLabel(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	function option:SetText(newText)
		self.text = tostring(newText)
		main.Text = " " .. self.text
	end
	
	return option
end

--// SLIDER \\--
local function createSlider(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	local title = library:Create("TextLabel", {
		Position = UDim2.new(0, 0, 0, 3),
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	local slider = library:Create("Frame", {
		Position = UDim2.new(0, 8, 0, 28),
		Size = UDim2.new(1, -16, 0, 4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = main
	})
	
	local fill = library:Create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = slider
	})
	
	local circle = library:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = slider
	})
	
	local valueRound = library:Create("Frame", {
		Position = UDim2.new(1, -55, 0, 3),
		Size = UDim2.new(0, 50, 0, 15),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = main
	})
	
	local inputvalue = library:Create("TextBox", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.value,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextWrapped = true,
		Font = Enum.Font.SourceSansBold,
		Parent = valueRound
	})
	
	if option.min >= 0 then
		fill.Size = UDim2.new((option.value - option.min) / (option.max - option.min), 0, 1, 0)
	else
		fill.Position = UDim2.new((0 - option.min) / (option.max - option.min), 0, 0, 0)
		fill.Size = UDim2.new(option.value / (option.max - option.min), 0, 1, 0)
	end
	
	local sliding
	local inContact
	main.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			fill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			circle.Size = UDim2.new(0, 12, 0, 12)
			circle.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			sliding = true
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		elseif input.UserInputType == Enum.UserInputType.Touch then
			fill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			circle.Size = UDim2.new(0, 12, 0, 12)
			circle.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			sliding = true
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not sliding then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	inputService.InputChanged:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
			option:SetValue(option.min + ((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X) * (option.max - option.min))
		end
	end)

	main.InputEnded:connect(function(input)
		if input.UserInputType == ui then
			sliding = false
			if inContact then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
			if inContact then
				fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
				circle.Size = UDim2.new(0, 8, 0, 8)
				circle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			else
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			inputvalue:ReleaseFocus()
			if not sliding then
				fill.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				circle.Size = UDim2.new(0, 0, 0, 0)
				circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)

	inputvalue.FocusLost:connect(function()
		circle.Size = UDim2.new(0, 0, 0, 0)
		circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		option:SetValue(tonumber(inputvalue.Text) or option.value)
	end)

	function option:SetValue(value)
		value = math.floor(value / option.float + 0.5) * option.float
		value = math.clamp(value, self.min, self.max)
		circle.Position = UDim2.new((value - self.min) / (self.max - self.min), 0, 0.5, 0)
		if self.min >= 0 then
			fill.Size = UDim2.new((value - self.min) / (self.max - self.min), 0, 1, 0)
		else
			fill.Position = UDim2.new((0 - self.min) / (self.max - self.min), 0, 0, 0)
			fill.Size = UDim2.new(value / (self.max - self.min), 0, 1, 0)
		end
		library.flags[self.flag] = value
		self.value = value
		inputvalue.Text = value
		self.callback(value)
	end
	
	return option
end

--// KEYBIND \\--
local function createBind(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local bindOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(0, -60, 1, -8),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local bindInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Parent = bindOutline
	})
	
	local bindLabel = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.key,
		TextSize = 12,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = bindInner
	})
	
	local button = library:Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = main
	})
	
	local inContact
	local selecting
	button.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			selecting = true
			bindLabel.Text = "..."
			bindOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			selecting = true
			bindLabel.Text = "..."
			bindOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not selecting then
				bindOutline.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
			end
		end
	end)
	
	button.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not selecting then
				bindOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	inputService.InputBegan:connect(function(input)
		if selecting then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local key = input.KeyCode.Name
				if key == "Escape" then
					option:SetKey("None")
				else
					option:SetKey(key)
				end
				selecting = false
				bindOutline.BackgroundColor3 = inContact and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(100, 100, 100)
			end
		elseif option.key ~= "None" and input.KeyCode.Name == option.key then
			option.callback()
		end
	end)
	
	function option:SetKey(key)
		library.flags[self.flag] = key
		self.key = key
		bindLabel.Text = key
	end
	
	return option
end

--// COLOR PICKER WINDOW \\--
local function createColorPickerWindow(option)
	option.mainHolder = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(0, 180, 0, 180),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Visible = false,
		Parent = library.base
	})
	
	local hue, sat, val = Color3.toHSV(option.color)
	hue, sat, val = hue == 0 and 1 or hue, sat + 0.005, val - 0.005
	local editinghue
	local editingsatval
	local currentColor = option.color
	local previousColors = {[1] = option.color}
	local originalColor = option.color
	local rainbowEnabled
	local rainbowLoop
	
	function option:updateVisuals(Color)
		currentColor = Color
		self.visualize2.BackgroundColor3 = Color
		hue, sat, val = Color3.toHSV(Color)
		hue = hue == 0 and 1 or hue
		self.satval.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		self.hueSlider.Position = UDim2.new(1 - hue, 0, 0, 0)
		self.satvalSlider.Position = UDim2.new(sat, 0, 1 - val, 0)
	end
	
	-- Hue Slider
	option.hue = library:Create("Frame", {
		ZIndex = 3,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 8, 1, -8),
		Size = UDim2.new(1, -70, 0, 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = option.mainHolder
	})
	
	local Gradient = library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Parent = option.hue
	})
	
	option.hueSlider = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1 - hue, 0, 0, 0),
		Size = UDim2.new(0, 2, 1, 0),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		Parent = option.hue
	})
	
	option.hue.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editinghue = true
			X = (option.hue.AbsolutePosition.X + option.hue.AbsoluteSize.X) - option.hue.AbsolutePosition.X
			X = (Input.Position.X - option.hue.AbsolutePosition.X) / X
			X = X < 0 and 0 or X > 0.995 and 0.995 or X
			option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
		end
	end)
	
	inputService.InputChanged:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement and editinghue then
			X = (option.hue.AbsolutePosition.X + option.hue.AbsoluteSize.X) - option.hue.AbsolutePosition.X
			X = (Input.Position.X - option.hue.AbsolutePosition.X) / X
			X = X <= 0 and 0 or X >= 0.995 and 0.995 or X
			option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
		end
	end)
	
	option.hue.InputEnded:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editinghue = false
		end
	end)
	
	-- Saturation/Value Picker
	option.satval = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -70, 1, -38),
		BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		ClipsDescendants = true,
		Parent = option.mainHolder
	})
	
	local satvalOverlay1 = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = option.satval
	})
	
	local satvalGradient1 = library:Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Parent = satvalOverlay1
	})
	
	local satvalOverlay2 = library:Create("Frame", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Parent = option.satval
	})
	
	local satvalGradient2 = library:Create("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Parent = satvalOverlay2
	})
	
	option.satvalSlider = library:Create("Frame", {
		ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(sat, 0, 1 - val, 0),
		Size = UDim2.new(0, 4, 0, 4),
		Rotation = 45,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Parent = option.satval
	})
	
	option.satval.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editingsatval = true
			X = (option.satval.AbsolutePosition.X + option.satval.AbsoluteSize.X) - option.satval.AbsolutePosition.X
			Y = (option.satval.AbsolutePosition.Y + option.satval.AbsoluteSize.Y) - option.satval.AbsolutePosition.Y
			X = (Input.Position.X - option.satval.AbsolutePosition.X) / X
			Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / Y
			X = X <= 0.005 and 0.005 or X >= 1 and 1 or X
			Y = Y <= 0 and 0 or Y >= 0.995 and 0.995 or Y
			option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
		end
	end)
	
	inputService.InputChanged:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement and editingsatval then
			X = (option.satval.AbsolutePosition.X + option.satval.AbsoluteSize.X) - option.satval.AbsolutePosition.X
			Y = (option.satval.AbsolutePosition.Y + option.satval.AbsoluteSize.Y) - option.satval.AbsolutePosition.Y
			X = (Input.Position.X - option.satval.AbsolutePosition.X) / X
			Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / Y
			X = X <= 0.005 and 0.005 or X >= 1 and 1 or X
			Y = Y <= 0 and 0 or Y >= 0.995 and 0.995 or Y
			option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
		end
	end)
	
	option.satval.InputEnded:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			editingsatval = false
		end
	end)
	
	-- Color Preview
	option.visualize2 = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 8),
		Size = UDim2.new(0, -50, 0, 50),
		BackgroundColor3 = currentColor,
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(40, 40, 40),
		Parent = option.mainHolder
	})
	
	-- Reset Button
	option.resetColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 62),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.resetText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Reset",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.resetColor
	})
	
	local resetInContact
	option.resetColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				previousColors = {originalColor}
				option:SetColor(originalColor)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			resetInContact = true
			option.resetColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.resetColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			resetInContact = false
			option.resetColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Undo Button
	option.undoColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 82),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.undoText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Undo",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.undoColor
	})
	
	local undoInContact
	option.undoColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				local Num = #previousColors == 1 and 0 or 1
				option:SetColor(previousColors[#previousColors - Num])
				if #previousColors ~= 1 then
					table.remove(previousColors, #previousColors)
				end
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			undoInContact = true
			option.undoColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.undoColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			undoInContact = false
			option.undoColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Set Button
	option.setColor = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 102),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.setText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "Set",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.setColor
	})
	
	local setInContact
	option.setColor.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			if not rainbowEnabled then
				table.insert(previousColors, currentColor)
				option:SetColor(currentColor)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			setInContact = true
			option.setColor.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.setColor.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			setInContact = false
			option.setColor.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Rainbow Button
	option.rainbow = library:Create("Frame", {
		ZIndex = 3,
		Position = UDim2.new(1, -8, 0, 122),
		Size = UDim2.new(0, -50, 0, 16),
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(60, 60, 60),
		Parent = option.mainHolder
	})
	
	option.rainbowText = library:Create("TextLabel", {
		ZIndex = 3,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "RGB",
		Font = Enum.Font.SourceSansBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = option.rainbow
	})
	
	local rainbowInContact
	option.rainbow.InputBegan:connect(function(Input)
		if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
			rainbowEnabled = not rainbowEnabled
			if rainbowEnabled then
				rainbowLoop = runService.Heartbeat:connect(function()
					option:SetColor(chromaColor)
					option.rainbowText.TextColor3 = chromaColor
				end)
			else
				if rainbowLoop then
					rainbowLoop:Disconnect()
				end
				option:SetColor(previousColors[#previousColors])
				option.rainbowText.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			rainbowInContact = true
			option.rainbow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)
	
	option.rainbow.InputEnded:connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			rainbowInContact = false
			option.rainbow.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	return option
end

--// COLOR PICKER \\--
local function createColor(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	local colorBoxOutline = library:Create("Frame", {
		Position = UDim2.new(1, -5, 0, 3),
		Size = UDim2.new(-1, 8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(80, 80, 80),
		Parent = main
	})
	
	local colorBoxInner = library:Create("Frame", {
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = option.color,
		BorderSizePixel = 0,
		Parent = colorBoxOutline
	})
	
	local inContact
	main.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			if not option.mainHolder then createColorPickerWindow(option) end
			if library.activePopup then
				library.activePopup:Close()
			end
			local position = main.AbsolutePosition
			option.mainHolder.Position = UDim2.new(0, position.X - 4, 0, position.Y + 1)
			option.open = true
			option.mainHolder.Visible = true
			library.activePopup = option
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				colorBoxOutline.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
			end
		end
	end)
	
	main.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				colorBoxOutline.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end
	end)
	
	function option:SetColor(newColor)
		if self.mainHolder then
			self:updateVisuals(newColor)
		end
		colorBoxInner.BackgroundColor3 = newColor
		library.flags[self.flag] = newColor
		self.color = newColor
		self.callback(newColor)
	end
	
	function option:Close()
		library.activePopup = nil
		self.open = false
		colorBoxOutline.BackgroundColor3 = inContact and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(100, 100, 100)
		wait(0.3)
		if not self.open then
			self.mainHolder.Visible = false
		end
	end
	
	return option
end

--// Load options Function \\--
local function loadOptions(option, holder)
	for _,newOption in next, option.options do
		if newOption.type == "button" then
			createButton(newOption, option)
		elseif newOption.type == "toggle" then
			createToggle(newOption, option)
		elseif newOption.type == "dropdown" then
			createMultiDropdown(newOption, option)
		elseif newOption.type == "box" then
			createBox(newOption, option)
		elseif newOption.type == "label" then
			createLabel(newOption, option)
		elseif newOption.type == "slider" then
			createSlider(newOption, option)
		elseif newOption.type == "bind" then
			createBind(newOption, option)
		elseif newOption.type == "color" then
			createColor(newOption, option)
		elseif newOption.type == "folder" then
			newOption:init()
		end
	end
end

local function getFnctions(parent)
	function parent:AddButton(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "button"
		option.position = #self.options
		option.flag = option.flag or option.text
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddToggle(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.state = typeof(option.state) == "boolean" and option.state or false
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "toggle"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.state
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddDropdown(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.list = typeof(option.list) == "table" and option.list or {}
		option.values = typeof(option.values) == "table" and option.values or {}
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.open = false
		option.type = "dropdown"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.values
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddBox(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.value = tostring(option.value or "")
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "box"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddLabel(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.type = "label"
		option.position = #self.options
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddSlider(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.min = typeof(option.min) == "number" and option.min or 0
		option.max = typeof(option.max) == "number" and option.max or 100
		option.value = math.clamp(typeof(option.value) == "number" and option.value or option.min, option.min, option.max)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.float = typeof(option.float) == "number" and option.float or 1
		option.type = "slider"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddBind(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.key = tostring(option.key or "None")
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "bind"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.key
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddColor(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.color = typeof(option.color) == "Color3" and option.color or Color3.fromRGB(255, 255, 255)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.open = false
		option.type = "color"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.color
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddFolder(title)
		local option = {}
		option.title = tostring(title)
		option.options = {}
		option.open = false
		option.type = "folder"
		option.position = #self.options
		table.insert(self.options, option)
		
		getFnctions(option)
		
		function option:init()
			createOptionHolder(self.title, parent.content, self, true)
			loadOptions(self, parent)
		end
		
		return option
	end
end

function library:CreateWindow(title)
	local window = {title = tostring(title), options = {}, open = true, canInit = true, init = false, position = #self.windows}
	getFnctions(window)
	
	table.insert(library.windows, window)
	
	return window
end

function library:Init()
	self.base = self.base or self:Create("ScreenGui")
	if syn and syn.protect_gui then
		syn.protect_gui(self.base)
	elseif get_hidden_gui then
		get_hidden_gui(self.base)
	elseif gethui then
		self.base.Parent = gethui()
	else
		self.base.Parent = game:GetService"CoreGui"
	end
	self.base.ResetOnSpawn = false
	self.base.Name = "LibraryUI"
	
	for _, window in next, self.windows do
		if window.canInit and not window.init then
			window.init = true
			createOptionHolder(window.title, self.base, window)
			loadOptions(window)
		end
	end
	return self.base
end

function library:Close()
	if typeof(self.base) ~= "Instance" then return end
	self.open = not self.open
	for _, window in next, self.windows do
		if window.main then
			window.main.Visible = self.open
		end
	end
end

inputService.InputBegan:connect(function(input)
	if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
		if library.activePopup and library.activePopup.open then
			local pos = input.Position
			local holderPos = library.activePopup.mainHolder.AbsolutePosition
			local holderSize = library.activePopup.mainHolder.AbsoluteSize
			
			local isOutside = pos.X < holderPos.X or pos.Y < holderPos.Y or 
			                  pos.X > holderPos.X + holderSize.X or 
			                  pos.Y > holderPos.Y + holderSize.Y
			
			if isOutside then
				library.activePopup:Close()
			end
		end
	end
end)

inputService.InputChanged:connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

return library
