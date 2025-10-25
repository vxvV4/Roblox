local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GuiMaker"
gui.ResetOnSpawn = false

local elements, selection = {}, {}
_G.SelectedGuiObject = nil
local function makeDraggable(obj)
	obj.Active = true
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local offset = input.Position - obj.AbsolutePosition
			local conn
			conn = UserInput.InputChanged:Connect(function(move)
				if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
					obj.Position = UDim2.new(0, move.Position.X - offset.X, 0, move.Position.Y - offset.Y)
				end
			end)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if conn then conn:Disconnect() end
				end
			end)
		end
	end)
end

local function selectObject(obj)
	for _, v in ipairs(selection) do
		if v:IsA("GuiObject") then v.BorderSizePixel = 0 end
	end
	selection = {obj}
	if obj:IsA("GuiObject") then
		obj.BorderColor3 = Color3.new(0, 1, 0)
		obj.BorderSizePixel = 2
	end
	_G.SelectedGuiObject = obj
end

local function createElement(className)
	local inst = Instance.new(className, gui)
	inst.Size = UDim2.new(0, 160, 0, 30)
	inst.Position = UDim2.new(0.5, math.random(-100,100), 0.5, math.random(-100,100))
	inst.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
		inst.Font = Enum.Font.SourceSans
		inst.TextSize = 16
		inst.TextColor3 = Color3.new(1,1,1)
		inst.Text = className
	end
	makeDraggable(inst)
	inst.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			selectObject(inst)
		end
	end)
	table.insert(elements, inst)
end

local function exportLayout()
	local lines = {"-- ZumHub GUI Exported Layout"}
	table.insert(lines, "return function()")
	table.insert(lines, "local gui = Instance.new('ScreenGui', game.Players.LocalPlayer.PlayerGui)")
	for _, v in ipairs(elements) do
		table.insert(lines, ("local e = Instance.new('%s', gui)"):format(v.ClassName))
		table.insert(lines, ("e.Position = UDim2.new(0, %d, 0, %d)"):format(v.Position.X.Offset, v.Position.Y.Offset))
		table.insert(lines, ("e.Size = UDim2.new(0, %d, 0, %d)"):format(v.Size.X.Offset, v.Size.Y.Offset))
		if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
			table.insert(lines, ("e.Text = %q"):format(v.Text))
		end
		table.insert(lines, ("e.BackgroundColor3 = Color3.new(%.3f, %.3f, %.3f)"):format(v.BackgroundColor3.R, v.BackgroundColor3.G, v.BackgroundColor3.B))
	end
	table.insert(lines, "end")
	setclipboard(table.concat(lines, "\n"))
end

local function saveLayout()
	local save = {}
	for _, v in ipairs(elements) do
		table.insert(save, {
			Class = v.ClassName,
			Pos = {v.Position.X.Offset, v.Position.Y.Offset},
			Size = {v.Size.X.Offset, v.Size.Y.Offset},
			Text = v.Text or "",
			Color = {v.BackgroundColor3.R, v.BackgroundColor3.G, v.BackgroundColor3.B}
		})
	end
	writefile("GuiMakerLayout.json", HttpService:JSONEncode(save))
end

local function loadLayout()
	if not isfile("GuiMakerLayout.json") then return end
	local load = HttpService:JSONDecode(readfile("GuiMakerLayout.json"))
	for _, data in ipairs(load) do
		local inst = Instance.new(data.Class, gui)
		inst.Position = UDim2.new(0, data.Pos[1], 0, data.Pos[2])
		inst.Size = UDim2.new(0, data.Size[1], 0, data.Size[2])
		inst.BackgroundColor3 = Color3.new(data.Color[1], data.Color[2], data.Color[3])
		if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
			inst.Text = data.Text
			inst.Font = Enum.Font.SourceSans
			inst.TextSize = 16
			inst.TextColor3 = Color3.new(1,1,1)
		end
		makeDraggable(inst)
		inst.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				selectObject(inst)
			end
		end)
		table.insert(elements, inst)
	end
end

local function animateHover(btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
end

local function createLoginTemplate()
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, -150, 0.5, -100)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Text = "🔐 Login"
	title.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 20

	local username = Instance.new("TextBox", frame)
	username.Size = UDim2.new(0.8, 0, 0, 30)
	username.Position = UDim2.new(0.1, 0, 0, 60)
	username.PlaceholderText = "Username"
	username.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	username.TextColor3 = Color3.new(1,1,1)

	local password = username:Clone()
	password.PlaceholderText = "Password"
	password.Position = UDim2.new(0.1, 0, 0, 100)
	password.Parent = frame

	local loginBtn = Instance.new("TextButton", frame)
	loginBtn.Size = UDim2.new(0.8, 0, 0, 30)
	loginBtn.Position = UDim2.new(0.1, 0, 0, 150)
	loginBtn.Text = "Login"
	loginBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 120)
	loginBtn.TextColor3 = Color3.new(1, 1, 1)

	makeDraggable(frame)
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			selectObject(frame)
		end
	end)
	table.insert(elements, frame)
end

local toolbar = Instance.new("ScrollingFrame", gui)
toolbar.Size = UDim2.new(0, 280, 1, 0)
toolbar.Position = UDim2.new(1, -280, 0, 0)
toolbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toolbar.CanvasSize = UDim2.new(0, 0, 0, 1200)
toolbar.ScrollBarThickness = 4

local function addToolButton(text, y, callback)
	local btn = Instance.new("TextButton", toolbar)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.MouseButton1Click:Connect(callback)
	animateHover(btn)
end

local y = 0
for _, element in pairs({"TextLabel","TextButton","TextBox","Frame","ImageLabel","ImageButton","ViewportFrame","ScrollingFrame","UICorner","UIGridLayout","UIScale"}) do
	addToolButton("➕ "..element, y, function() createElement(element) end)
	y = y + 35
end
addToolButton("📁 Template: Login", y, createLoginTemplate) y += 35
addToolButton("💾 Save Layout", y, saveLayout) y += 35
addToolButton("📂 Load Layout", y, loadLayout) y += 35
addToolButton("📋 Export to Lua", y, exportLayout) y += 35

-- === Code Editor Tab ===
local codePanel = Instance.new("Frame")
codePanel.Size = UDim2.new(0, 280, 0, 300)
codePanel.Position = UDim2.new(1, -280, 1, -310)
codePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
codePanel.Visible = true
codePanel.Parent = gui

local title = Instance.new("TextLabel", codePanel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "✍️ Code Editor"
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local codeBox = Instance.new("TextBox", codePanel)
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.TextWrapped = true
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.TextColor3 = Color3.new(1, 1, 1)
codeBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
codeBox.Position = UDim2.new(0, 5, 0, 35)
codeBox.Size = UDim2.new(1, -10, 0, 180)
codeBox.Text = "-- Write your Lua GUI code here"

local function createEditorBtn(text, pos, callback)
	local btn = Instance.new("TextButton", codePanel)
	btn.Text = text
	btn.Size = UDim2.new(0.48, 0, 0, 25)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Font = Enum.Font.SourceSans
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(callback)
end

local currentThread = nil

createEditorBtn("🧷 Start Code", UDim2.new(0, 5, 0, 225), function()
	if currentThread then return end
	currentThread = coroutine.create(function()
		local env = {script = {Parent = _G.SelectedGuiObject}}
		setfenv(loadstring(codeBox.Text), env)()
	end)
	coroutine.resume(currentThread)
end)

createEditorBtn("💥 Run Code", UDim2.new(0.52, 0, 0, 225), function()
	local env = {script = {Parent = _G.SelectedGuiObject}}
	local success, err = pcall(function()
		setfenv(loadstring(codeBox.Text), env)()
	end)
	if not success then warn("[Code Error]:", err) end
end)

createEditorBtn("🛑 Stop Code", UDim2.new(0, 5, 0, 260), function()
	currentThread = nil
end)

createEditorBtn("💾 Save", UDim2.new(0.52, 0, 0, 260), function()
	writefile("GuiMakerCode.lua", codeBox.Text)
end)

createEditorBtn("📂 Load", UDim2.new(0, 5, 0, 295), function()
	if isfile("GuiMakerCode.lua") then
		codeBox.Text = readfile("GuiMakerCode.lua")
	end
end)

createEditorBtn("🔌 Apply to Selected", UDim2.new(0.52, 0, 0, 295), function()
	if not _G.SelectedGuiObject then return end
	local env = {script = {Parent = _G.SelectedGuiObject}}
	local success, err = pcall(function()
		setfenv(loadstring(codeBox.Text), env)()
	end)
	if not success then warn("[Apply Error]:", err) end
end)
