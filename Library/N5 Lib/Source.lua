local SharpUI = {}
SharpUI.__index = SharpUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local function Create(class, props)
	local obj = Instance.new(class)
	for k,v in pairs(props or {}) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if props and props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

function SharpUI:New(title)
	local selfObj = setmetatable({}, SharpUI)
	selfObj.ScreenGui = Create("ScreenGui", {Parent = game.CoreGui, Name = "SharpUI"})
	selfObj.MainFrame = Create("Frame", {
		Parent = selfObj.ScreenGui,
		Size = UDim2.new(0, 500, 0, 320),
		Position = UDim2.new(0.5, -250, 0.5, -160),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		Active = true,
		Draggable = true
	})
	selfObj.Title = Create("TextLabel", {
		Parent = selfObj.MainFrame,
		Size = UDim2.new(1,0,0,45),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		Text = title or "Sharp Hub",
		TextColor3 = Color3.fromRGB(255,255,255),
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 20
	})
	Create("UIPadding", {
		Parent = selfObj.Title,
		PaddingLeft = UDim.new(0,10)
	})
	selfObj.SubTitle = Create("TextLabel", {
		Parent = selfObj.MainFrame,
		Size = UDim2.new(1,0,0,20),
		Position = UDim2.new(0,10,0,25),
		BackgroundTransparency = 1,
		Text = "By Shizoscript",
		TextColor3 = Color3.fromRGB(200,200,200),
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 14
	})
	selfObj.HideButton = Create("ImageButton", {
		Parent = selfObj.ScreenGui,
		Size = UDim2.new(0,40,0,40),
		Position = UDim2.new(1,-60,1,-60),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		Image = "rbxassetid://89313692535877",
		ZIndex = 10,
		Active = true
	})
	Create("UICorner", {
		Parent = selfObj.HideButton,
		CornerRadius = UDim.new(0.25,0)
	})
	
	-- Make hide button draggable
	local dragging = false
	local dragInput, mousePos, framePos
	
	selfObj.HideButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = selfObj.HideButton.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	selfObj.HideButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			selfObj.HideButton.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
	
	local visible = true
	selfObj.HideButton.MouseButton1Click:Connect(function()
		if not dragging then
			visible = not visible
			selfObj.MainFrame.Visible = visible
		end
	end)
	
	selfObj.TabList = Create("ScrollingFrame", {
		Parent = selfObj.MainFrame,
		Position = UDim2.new(0,5,0,50),
		Size = UDim2.new(0,120,1,-55),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(255,255,255),
		CanvasSize = UDim2.new(0,0,0,0)
	})
	local tabLayout = Create("UIListLayout", {
		Parent = selfObj.TabList,
		Padding = UDim.new(0,6),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	Create("UIPadding", {
		Parent = selfObj.TabList,
		PaddingTop = UDim.new(0,5),
		PaddingLeft = UDim.new(0,5),
		PaddingRight = UDim.new(0,5)
	})
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		selfObj.TabList.CanvasSize = UDim2.new(0,0,0,tabLayout.AbsoluteContentSize.Y + 10)
	end)
	selfObj.Content = Create("Frame", {
		Parent = selfObj.MainFrame,
		Position = UDim2.new(0,130,0,50),
		Size = UDim2.new(1,-135,1,-55),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		ClipsDescendants = true
	})
	selfObj.PageLayout = Create("UIPageLayout", {
		Parent = selfObj.Content,
		Animated = true,
		Circular = false,
		TweenTime = 0.3,
		TouchInputEnabled = true,
		ScrollWheelInputEnabled = true
	})
	selfObj.PageLayout.Stopped:Connect(function(currentPage)
		for name, scrollFrame in pairs(selfObj.Tabs) do
			if scrollFrame == currentPage then
				for _, btn in pairs(selfObj.TabButtons) do
					btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
				end
				if selfObj.TabButtons[name] then
					selfObj.TabButtons[name].BackgroundColor3 = Color3.fromRGB(30,30,30)
				end
				break
			end
		end
	end)
	selfObj.Tabs = {}
	selfObj.TabButtons = {}
	return selfObj
end

function SharpUI:AddTab(name)
	local button = Create("TextButton", {
		Parent = self.TabList,
		Size = UDim2.new(1,0,0,35),
		Text = name,
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		TextColor3 = Color3.fromRGB(255,255,255),
		Font = Enum.Font.GothamBold,
		TextSize = 16
	})
	local scroll = Create("ScrollingFrame", {
		Parent = self.Content,
		Size = UDim2.new(1,0,1,0),
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 8,
		ScrollBarImageColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1
	})
	local list = Create("UIListLayout", {
		Parent = scroll,
		Padding = UDim.new(0,10),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	Create("UIPadding", {
		Parent = scroll,
		PaddingTop = UDim.new(0,10),
		PaddingLeft = UDim.new(0,10),
		PaddingRight = UDim.new(0,10)
	})
	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 20)
	end)
	self.TabButtons[name] = button
	self.Tabs[name] = scroll
	button.MouseButton1Click:Connect(function()
		self.PageLayout:JumpTo(scroll)
		for _, btn in pairs(self.TabButtons) do
			btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
		end
		button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	end)
	if #self.Tabs == 1 then
		button.BackgroundColor3 = Color3.fromRGB(30,30,30)
		self.PageLayout:JumpTo(scroll)
	end
	return scroll
end

function SharpUI:AddButton(tab, text, callback)
	local Btn = Create("TextButton", {
		Parent = tab,
		Size = UDim2.new(1,0,0,40),
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(10,10,10),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2
	})
	Btn.MouseButton1Click:Connect(callback)
	return Btn
end

function SharpUI:AddToggle(tab, text, default, callback)
	local toggleFrame = Create("Frame", {
		Parent = tab,
		Size = UDim2.new(1,0,0,40),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2
	})
	local title = Create("TextLabel", {
		Parent = toggleFrame,
		Size = UDim2.new(0.7,0,1,0),
		Position = UDim2.new(0,10,0,0),
		Text = text,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local btn = Create("TextButton", {
		Parent = toggleFrame,
		Size = UDim2.new(0.25,0,0.7,0),
		Position = UDim2.new(0.72,0,0.15,0),
		Text = default and "ON" or "OFF",
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(80,0,0),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BorderSizePixel = 0
	})
	btn.MouseButton1Click:Connect(function()
		default = not default
		btn.Text = default and "ON" or "OFF"
		btn.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(80,0,0)
		callback(default)
	end)
	return toggleFrame
end

function SharpUI:AddSlider(tab, text, min, max, default, callback)
	local frame = Create("Frame", {
		Parent = tab,
		Size = UDim2.new(1,0,0,45),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2
	})
	local label = Create("TextLabel", {
		Parent = frame,
		Size = UDim2.new(1,-10,0,20),
		Position = UDim2.new(0,10,0,0),
		Text = text.." : "..default,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local bar = Create("Frame", {
		Parent = frame,
		Size = UDim2.new(0.9,0,0,12),
		Position = UDim2.new(0.05,0,0,28),
		BackgroundColor3 = Color3.fromRGB(40,40,40),
		BorderSizePixel = 0
	})
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0,6)
	local fill = Create("Frame", {
		Parent = bar,
		Size = UDim2.new((default-min)/(max-min),0,1,0),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 0
	})
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)
	local handle = Create("Frame", {
		Parent = fill,
		Size = UDim2.new(0,16,0,16),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(1,0,0.5,0),
		BackgroundColor3 = Color3.fromRGB(150,150,150),
		BorderSizePixel = 0
	})
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1,0)
	local dragging = false
	local function updateInput(input)
		local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * rel)
		fill.Size = UDim2.new(rel,0,1,0)
		label.Text = text.." : "..val
		callback(val)
	end
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateInput(input)
		end
	end)
	bar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateInput(input)
		end
	end)
	return frame
end

function SharpUI:AddDropdown(tab, text, options, callback)
	local selectedOptions = {}
	local frame = Create("Frame", {
		Parent = tab,
		Size = UDim2.new(1,0,0,40),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2
	})
	local title = Create("TextLabel", {
		Parent = frame,
		Size = UDim2.new(0.7,0,1,0),
		Position = UDim2.new(0,10,0,0),
		Text = text,
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local btn = Create("TextButton", {
		Parent = frame,
		Size = UDim2.new(0.25,0,0.7,0),
		Position = UDim2.new(0.72,0,0.15,0),
		Text = "▼",
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(30,30,30),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BorderSizePixel = 0
	})
	
	-- Create dropdown container that sits outside the main frame
	local dropdownContainer = Create("Frame", {
		Parent = frame,
		Size = UDim2.new(1,0,0,0),
		Position = UDim2.new(0,0,1,2),
		BackgroundTransparency = 1,
		ZIndex = 10
	})
	
	local dropdownFrame = Create("ScrollingFrame", {
		Parent = dropdownContainer,
		Size = UDim2.new(1,0,0,0),
		Position = UDim2.new(0,0,0,0),
		CanvasSize = UDim2.new(0,0,0,0),
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2,
		Visible = false,
		ZIndex = 10
	})
	
	local listLayout = Create("UIListLayout", {
		Parent = dropdownFrame,
		Padding = UDim.new(0,2),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	-- Add options first
	for i, option in ipairs(options) do
		local optBtn = Create("TextButton", {
			Parent = dropdownFrame,
			Size = UDim2.new(1,0,0,30),
			Text = "☐ " .. option,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(255,255,255),
			BackgroundColor3 = Color3.fromRGB(40,40,40),
			BorderSizePixel = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 10
		})
		Create("UIPadding", {
			Parent = optBtn,
			PaddingLeft = UDim.new(0,10)
		})
		optBtn.MouseButton1Click:Connect(function()
			if selectedOptions[option] then
				selectedOptions[option] = nil
				optBtn.Text = "☐ " .. option
				optBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
			else
				selectedOptions[option] = true
				optBtn.Text = "☑ " .. option
				optBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			end
			callback(selectedOptions)
		end)
	end
	
	-- Update size function
	local function updateDropdownSize()
		local contentHeight = listLayout.AbsoluteContentSize.Y
		dropdownFrame.CanvasSize = UDim2.new(0,0,0,contentHeight)
		
		if contentHeight > 150 then
			dropdownFrame.Size = UDim2.new(1,0,0,150)
			dropdownContainer.Size = UDim2.new(1,0,0,150)
		elseif contentHeight > 0 then
			dropdownFrame.Size = UDim2.new(1,0,0,contentHeight)
			dropdownContainer.Size = UDim2.new(1,0,0,contentHeight)
		else
			dropdownFrame.Size = UDim2.new(1,0,0,100)
			dropdownContainer.Size = UDim2.new(1,0,0,100)
		end
	end
	
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownSize)
	
	-- Wait a frame then update size
	spawn(function()
		wait(0.1)
		updateDropdownSize()
	end)
	
	btn.MouseButton1Click:Connect(function()
		dropdownFrame.Visible = not dropdownFrame.Visible
		if dropdownFrame.Visible then
			updateDropdownSize()
		end
	end)
	
	return frame
end

function SharpUI:AddImage(tab, defaultId)
	local frame = Create("Frame", {
		Parent = tab,
		Size = UDim2.new(1,0,0,120),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BorderColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 2
	})
	local image = Create("ImageLabel", {
		Parent = frame,
		Size = UDim2.new(1,0,0,100),
		Image = "rbxassetid://"..(defaultId or "0"),
		BackgroundColor3 = Color3.fromRGB(20,20,20),
		BorderSizePixel = 0
	})
	local input = Create("TextBox", {
		Parent = frame,
		Size = UDim2.new(1,0,0,20),
		Position = UDim2.new(0,0,0,100),
		Text = defaultId or "",
		TextColor3 = Color3.fromRGB(255,255,255),
		BackgroundColor3 = Color3.fromRGB(30,30,30),
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		TextSize = 14
	})
	input.FocusLost:Connect(function()
		local id = input.Text
		image.Image = "rbxassetid://"..id
	end)
	return frame
end

return SharpUI
