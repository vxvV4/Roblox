local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local connections = {}
local targetNames = {
	["Trenostruzzo Turbo 3000"] = true,
	["Los Tralaleritos"] = true,
	["La Vacca Saturno Saturnita"] = true,
	["Matteo"] = true,
	["Graipuss Medussi"] = true,
	["Cocofanto Elefanto"] = true,
	["Odin Din Din Dun"] = true,
	["Tralalero Tralala"] = true,
	["Girafa Celestre"] = true,
	["Gattatino Nyanino"] = true,
	["La Grande Combinasion"] = true,
	["Garama and Madundung"] = true,
	["Sammyni Spyderini"] = true,
	["Unclito Samito"] = true,
	["Zibra Zubra Zibralini"] = true,
	["Torrtuginni Dragonfrutini"] = true,
	["Tigroligre Frutonni"] = true,
	["Tigrilini Watermelini"] = true,
	["Statutino Libertino"] = true,
	["Secret Lucky Block"] = true,
	["Pot Hotspot"] = true,
	["Brainrot God Lucky Block"] = true,
	["Chimpanzini Spiderini"] = true,
	["Gattatino Neonino"] = true,
	["Las Tralaleritas"] = true,
	["Mythic Lucky Block"] = true,
	["Orcalero Orcala"] = true,
}

local function createESPText(model)
	if model:IsA("Model") and targetNames[model.Name] then
		local root = model:FindFirstChild("RootPart")
		if root and not root:FindFirstChild("ESP_Text") then
			local gui = Instance.new("BillboardGui")
			gui.Name = "ESP_Text"
			gui.Adornee = root
			gui.AlwaysOnTop = true
			gui.Size = UDim2.new(0, 100, 0, 40)
			gui.StudsOffset = Vector3.new(0, 3, 0)
			gui.Parent = root

			local label = Instance.new("TextLabel")
			label.Name = "ESP_Label"
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = "🖕"
			label.TextColor3 = Color3.new(1, 1, 0)
			label.TextScaled = true
			label.Font = Enum.Font.SourceSansBold
			label.Visible = true
			label.Parent = gui
		end
	end
end

local function removeESP(model)
	if model:IsA("Model") and targetNames[model.Name] then
		local root = model:FindFirstChild("RootPart")
		if root then
			local esp = root:FindFirstChild("ESP_Text")
			if esp then
				esp:Destroy()
			end
		end
	end
end

local function updateESPVisibility()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local playerPos = char.HumanoidRootPart.Position
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Model") and targetNames[obj.Name] then
			local root = obj:FindFirstChild("RootPart")
			if root then
				local gui = root:FindFirstChild("ESP_Text")
				if gui and gui:FindFirstChild("ESP_Label") then
					local label = gui.ESP_Label
					local dist = (root.Position - playerPos).Magnitude
					label.Visible = dist > 80
				end
			end
		end
	end
end

local function enableESP()
	local foundCount = 0
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Model") and targetNames[obj.Name] then
			foundCount += 1
		end
		createESPText(obj)
	end

	table.insert(connections, workspace.ChildAdded:Connect(function(obj)
		task.wait(0.1)
		createESPText(obj)
	end))

	table.insert(connections, RunService.RenderStepped:Connect(updateESPVisibility))

	if foundCount > 0 then
		StarterGui:SetCore("SendNotification", {
			Title = "Target message",
			Text = "✅ " .. foundCount .. " target success found.",
			Duration = 6
		})
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Target message",
			Text = "❌ target not found.",
			Duration = 6
		})
	end
end

local function disableESP()
	for _, conn in pairs(connections) do
		if conn and typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end
	connections = {}

	for _, obj in pairs(workspace:GetChildren()) do
		removeESP(obj)
	end
  
	getgenv().activateESP = nil
	getgenv().disableESP = nil
end

getgenv().activateESP = enableESP
getgenv().disableESP = disableESP
