-- ThemeZ Module
local ThemeZ = {}
local TweenService = game:GetService("TweenService")

-- Theme Definitions
ThemeZ.Themes = {
	Rainbow = {
		Name = "Rainbow",
		MainBackground = Color3.fromRGB(30, 30, 30),
		TitleBar = Color3.fromRGB(30, 30, 30),
		ContentBackground = Color3.fromRGB(35, 35, 35),
		ButtonBackground = Color3.fromRGB(40, 70, 120),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(0, 200, 0),
		ToggleOff = Color3.fromRGB(76, 76, 76),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(153, 153, 153),
		TextboxBackground = Color3.fromRGB(20, 20, 20),
		UseRainbow = true,
		CornerRadius = 12
	},
	
	Dark = {
		Name = "Dark",
		MainBackground = Color3.fromRGB(20, 20, 20),
		TitleBar = Color3.fromRGB(13, 13, 13),
		ContentBackground = Color3.fromRGB(25, 25, 25),
		ButtonBackground = Color3.fromRGB(200, 0, 0),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(0, 200, 0),
		ToggleOff = Color3.fromRGB(76, 76, 76),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(153, 153, 153),
		TextboxBackground = Color3.fromRGB(0, 0, 0),
		UseRainbow = false,
		CornerRadius = 0
	},
	
	Blue = {
		Name = "Blue",
		MainBackground = Color3.fromRGB(25, 35, 50),
		TitleBar = Color3.fromRGB(15, 25, 40),
		ContentBackground = Color3.fromRGB(30, 40, 55),
		ButtonBackground = Color3.fromRGB(41, 128, 185),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(46, 204, 113),
		ToggleOff = Color3.fromRGB(52, 73, 94),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(149, 165, 166),
		TextboxBackground = Color3.fromRGB(15, 25, 40),
		UseRainbow = false,
		CornerRadius = 8
	},
	
	Purple = {
		Name = "Purple",
		MainBackground = Color3.fromRGB(40, 30, 50),
		TitleBar = Color3.fromRGB(30, 20, 40),
		ContentBackground = Color3.fromRGB(45, 35, 55),
		ButtonBackground = Color3.fromRGB(142, 68, 173),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(155, 89, 182),
		ToggleOff = Color3.fromRGB(58, 48, 68),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(187, 143, 206),
		TextboxBackground = Color3.fromRGB(25, 15, 35),
		UseRainbow = false,
		CornerRadius = 10
	},
	
	Cyan = {
		Name = "Cyan",
		MainBackground = Color3.fromRGB(20, 40, 45),
		TitleBar = Color3.fromRGB(10, 30, 35),
		ContentBackground = Color3.fromRGB(25, 45, 50),
		ButtonBackground = Color3.fromRGB(0, 188, 212),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(0, 230, 118),
		ToggleOff = Color3.fromRGB(38, 50, 56),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(128, 222, 234),
		TextboxBackground = Color3.fromRGB(15, 25, 30),
		UseRainbow = false,
		CornerRadius = 6
	},
	
	Green = {
		Name = "Green",
		MainBackground = Color3.fromRGB(25, 40, 30),
		TitleBar = Color3.fromRGB(15, 30, 20),
		ContentBackground = Color3.fromRGB(30, 45, 35),
		ButtonBackground = Color3.fromRGB(39, 174, 96),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(46, 204, 113),
		ToggleOff = Color3.fromRGB(44, 62, 80),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(130, 224, 170),
		TextboxBackground = Color3.fromRGB(15, 25, 20),
		UseRainbow = false,
		CornerRadius = 8
	},
	
	Light = {
		Name = "Light",
		MainBackground = Color3.fromRGB(240, 240, 240),
		TitleBar = Color3.fromRGB(220, 220, 220),
		ContentBackground = Color3.fromRGB(245, 245, 245),
		ButtonBackground = Color3.fromRGB(66, 133, 244),
		ButtonText = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(52, 168, 83),
		ToggleOff = Color3.fromRGB(189, 189, 189),
		TextPrimary = Color3.fromRGB(30, 30, 30),
		TextSecondary = Color3.fromRGB(95, 99, 104),
		TextboxBackground = Color3.fromRGB(255, 255, 255),
		UseRainbow = false,
		CornerRadius = 8
	}
}

-- Current Theme
ThemeZ.CurrentTheme = ThemeZ.Themes.Rainbow

-- Rainbow Gradient Function
function ThemeZ:AddRainbowGradient(parent)
	if not self.CurrentTheme.UseRainbow then return end
	
	local grad = Instance.new("UIGradient", parent)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 127, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 0, 255)),
	}
	grad.Rotation = 45
	
	local info = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
	TweenService:Create(grad, info, {Rotation = 405}):Play()
	
	return grad
end

-- Apply Corner Radius
function ThemeZ:AddCorner(parent)
	if self.CurrentTheme.CornerRadius > 0 then
		local corner = Instance.new("UICorner", parent)
		corner.CornerRadius = UDim.new(0, self.CurrentTheme.CornerRadius)
		return corner
	end
end

-- Apply Theme to GUI
function ThemeZ:ApplyToGUI(gui)
	local theme = self.CurrentTheme
	
	-- Find main frame (M)
	local mainFrame = gui:FindFirstChild("Frame") or gui:FindFirstChildWhichIsA("Frame")
	if mainFrame then
		mainFrame.BackgroundColor3 = theme.MainBackground
		self:AddCorner(mainFrame)
		if theme.UseRainbow then
			self:AddRainbowGradient(mainFrame)
		end
	end
	
	-- Apply to all elements
	for _, element in pairs(gui:GetDescendants()) do
		if element:IsA("Frame") then
			if element.Name == "TB" or element.Parent.Name == "TB" then
				element.BackgroundColor3 = theme.TitleBar
				self:AddCorner(element)
				if theme.UseRainbow then
					self:AddRainbowGradient(element)
				end
			elseif element.Name == "C" then
				-- Content frame stays transparent
			elseif element.Parent.Name == "C" then
				element.BackgroundColor3 = theme.ContentBackground
				self:AddCorner(element)
			end
		elseif element:IsA("TextButton") then
			if element.Name == "H" then
				-- Toggle button stays transparent
			else
				element.BackgroundColor3 = theme.ButtonBackground
				element.TextColor3 = theme.ButtonText
				self:AddCorner(element)
				if theme.UseRainbow then
					self:AddRainbowGradient(element)
				end
			end
		elseif element:IsA("TextLabel") then
			if element.Name == "T" then
				element.TextColor3 = theme.TextPrimary
			else
				-- Check if it's a paragraph (secondary text)
				if element.TextSize <= 10 then
					element.TextColor3 = theme.TextSecondary
				else
					element.TextColor3 = theme.TextPrimary
				end
			end
		elseif element:IsA("TextBox") then
			element.BackgroundColor3 = theme.TextboxBackground
			element.TextColor3 = theme.TextPrimary
			self:AddCorner(element)
		end
	end
end

-- Set Theme
function ThemeZ:SetTheme(themeName)
	if self.Themes[themeName] then
		self.CurrentTheme = self.Themes[themeName]
		return true
	end
	return false
end

-- Get Theme List
function ThemeZ:GetThemeList()
	local themes = {}
	for name, _ in pairs(self.Themes) do
		table.insert(themes, name)
	end
	return themes
end

return ThemeZ
