loadstring(game:HttpGet("https://raw.githubusercontent.com/NabaruBrainrot/Tempat-Penyimpanan-Roblox-Brainrot-/refs/heads/main/Ui%20Baru"))()


_G.FaDhenAddToggle("SPEED BOOSTER", {
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NabaruBrainrot/Tempat-Penyimpanan-Roblox-Brainrot-/refs/heads/main/wanjir%20berjalan%20up"))()
        end
    end
})








_G.FaDhenAddToggle("AUTO INVISIBLE", {
    Callback = function(state)
        if state then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Invisible%20Mode'))()
        end
    end
})







-- Float Part Toggle Script (Fluxus)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Variabel utama
local screenGui = nil
local button = nil
local isOn = false
local floatingPart = nil
local connection = nil

-- Fungsi buat part neon
local function createPart()
	local part = Instance.new("Part")
	part.Size = Vector3.new(6, 1, 6)
	part.Anchored = true
	part.CanCollide = true
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(0, 255, 255)
	part.Transparency = 0.25
	part.Parent = workspace
	return part
end

-- Fungsi aktif/nonaktif float
local function toggleFloat(state)
	isOn = state
	if isOn then
		button.Text = "Float: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		floatingPart = createPart()

		connection = RunService.RenderStepped:Connect(function()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") and floatingPart then
				local root = char.HumanoidRootPart
				floatingPart.Position = root.Position - Vector3.new(0, 2.7, 0)
			end
		end)
	else
		button.Text = "Float: OFF"
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if floatingPart then
			floatingPart:Destroy()
			floatingPart = nil
		end
	end
end

-- Fungsi buat GUI saat toggle utama aktif
local function createGUI()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FloatToggleGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("CoreGui")

	button = Instance.new("TextButton")
	button.Parent = screenGui
	button.Size = UDim2.new(0, 140, 0, 45)
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, -20, 0.5, 0)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = "Float: OFF"
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.BorderSizePixel = 0
	button.Active = true

	-- Hover efek
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	button.MouseLeave:Connect(function()
		if button.Text == "Float: OFF" then
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		else
			button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		end
	end)

	-- Toggle float saat tombol diklik
	button.MouseButton1Click:Connect(function()
		toggleFloat(not isOn)
	end)
end

-- Fungsi hapus GUI saat toggle utama dimatikan
local function destroyGUI()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	if floatingPart then
		floatingPart:Destroy()
		floatingPart = nil
	end
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end
end

-- === Tambahkan toggle utama kamu ===
_G.FaDhenAddToggle("AUTO FLOAT", {
	Callback = function(state)
		if state then
			createGUI() -- Saat toggle ON, munculkan GUI
		else
			destroyGUI() -- Saat toggle OFF, hapus GUI
		end
	end
})




local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ragdollConnection = nil

local function anchorCharacter(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Anchored = state
        end
    end
end

local function handleRagdoll(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    ragdollConnection = humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics 
        or newState == Enum.HumanoidStateType.Ragdoll 
        or newState == Enum.HumanoidStateType.FallingDown then
            anchorCharacter(char, true)
            task.wait(0.01)
            anchorCharacter(char, false)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function enableAntiRagdoll()
    if player.Character then
        handleRagdoll(player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        handleRagdoll(char)
    end)
end

local function disableAntiRagdoll()
    if ragdollConnection then
        ragdollConnection:Disconnect()
        ragdollConnection = nil
    end
end











--=== Toggle baru ===--
_G.FaDhenAddToggle("ANTI RAGDOL", {
    Callback = function(state)
        if state then
            enableAntiRagdoll()
        else
            disableAntiRagdoll()
        end
    end
})








local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))

-- flag toggle
getgenv().FaDhenAutoAim = getgenv().FaDhenAutoAim or false


local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    local myPos = myChar.HumanoidRootPart.Position
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end


local function hookTool(tool)
    if tool:IsA("Tool") and not tool:FindFirstChild("FaDhenHooked") then
        local marker = Instance.new("BoolValue")
        marker.Name = "FaDhenHooked"
        marker.Parent = tool

        tool.Activated:Connect(function()
            if getgenv().FaDhenAutoAim then
                local nearest = getNearestPlayer()
                if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = nearest.Character.HumanoidRootPart
                    Net:RemoteEvent("UseItem"):FireServer(hrp.Position, hrp)
                    return
                end
            end

            
            local PlayerMouse = require(ReplicatedStorage.Packages.PlayerMouse)
            Net:RemoteEvent("UseItem"):FireServer(PlayerMouse.Hit.Position, PlayerMouse.Target)
        end)
    end
end


local function hookBackpack()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        hookTool(tool)
    end
    LocalPlayer.Backpack.ChildAdded:Connect(hookTool)
end


LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) 
    hookBackpack()
end)


hookBackpack()


_G.FaDhenAddToggle("AUTO AIMBOT", {
    Callback = function(state)
        getgenv().FaDhenAutoAim = state
    end
})



_G.FaDhenAddToggle("BOOST JUMP", {
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NabaruBrainrot/Tempat-Penyimpanan-Roblox-Brainrot-/refs/heads/main/BoostJump"))()
        end
    end
})





local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer


local FaESP = getgenv().FaDhenESP or {}
getgenv().FaDhenESP = FaESP

FaESP.Enabled = FaESP.Enabled or false
FaESP.Connections = FaESP.Connections or {}

local function destroyESPFromCharacter(character)
	if character:FindFirstChild("ESP_Highlight") then
		character.ESP_Highlight:Destroy()
	end
	local head = character:FindFirstChild("Head")
	if head and head:FindFirstChild("ESP_Name") then
		head.ESP_Name:Destroy()
	end
end

local function applyESPToCharacter(player, character)
	if player == localPlayer then return end
	if not character then return end

	local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
	if not head then return end

	destroyESPFromCharacter(character)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Name"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 1.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = player.DisplayName
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.Parent = billboard

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.Adornee = character
	highlight.FillColor = Color3.new(1, 0, 0)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.new(0, 0, 0)
	highlight.OutlineTransparency = 0.2
	highlight.Parent = character
end

local function trackPlayer(player)
	if player == localPlayer then return end
	if player.Character then
		applyESPToCharacter(player, player.Character)
	end
	FaESP.Connections[player] = player.CharacterAdded:Connect(function(character)
		applyESPToCharacter(player, character)
	end)
end

local function untrackPlayer(player)
	if FaESP.Connections[player] then
		FaESP.Connections[player]:Disconnect()
		FaESP.Connections[player] = nil
	end
	if player ~= localPlayer and player.Character then
		destroyESPFromCharacter(player.Character)
	end
end

function FaESP:Enable()
	if self.Enabled then return end
	self.Enabled = true
	for _, plr in ipairs(Players:GetPlayers()) do
		trackPlayer(plr)
	end
	self.Connections._PlayerAdded = Players.PlayerAdded:Connect(function(plr)
		trackPlayer(plr)
	end)
	self.Connections._PlayerRemoving = Players.PlayerRemoving:Connect(function(plr)
		untrackPlayer(plr)
	end)
end

function FaESP:Disable()
	if not self.Enabled then return end
	self.Enabled = false
	for key, conn in pairs(self.Connections) do
		if conn and conn.Disconnect then
			conn:Disconnect()
		end
		self.Connections[key] = nil
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= localPlayer and plr.Character then
			destroyESPFromCharacter(plr.Character)
		end
	end
end


_G.FaDhenAddToggle("ESP PLAYER", {
    Callback = function(state)
        if state then
            FaESP:Enable()
        else
            FaESP:Disable()
        end
    end
})






local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local screenGui
local function createMainGui()
    if screenGui then return screenGui end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UtilityGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = gui

    
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 200, 0, 32)
    frame.Position = UDim2.new(0.5, 0, 0.02, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 90, 1, 0)
    resetBtn.Position = UDim2.new(0, 0, 0, 0)
    resetBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    resetBtn.Text = "Reset"
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 14
    resetBtn.Parent = frame
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

    resetBtn.MouseButton1Click:Connect(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end)

    
    local leaveBtn = Instance.new("TextButton")
    leaveBtn.Size = UDim2.new(0, 90, 1, 0)
    leaveBtn.Position = UDim2.new(0, 100, 0, 0)
    leaveBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    leaveBtn.TextColor3 = Color3.new(1, 1, 1)
    leaveBtn.Text = "Leave"
    leaveBtn.Font = Enum.Font.GothamBold
    leaveBtn.TextSize = 14
    leaveBtn.Parent = frame
    Instance.new("UICorner", leaveBtn).CornerRadius = UDim.new(0, 6)

    leaveBtn.MouseButton1Click:Connect(function()
        game:Shutdown()
    end)

    player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if not gui:FindFirstChild("UtilityGui") then
            screenGui.Parent = gui
        end
    end)

    return screenGui
end


_G.FaDhenAddToggle("Show Button", {
    Callback = function(state)
        if state then
            createMainGui().Enabled = true
        else
            if screenGui then
                screenGui.Enabled = false
            end
        end
    end
})







_G.FaDhenAddToggle("Tp Sentry", {
    Callback = function(state)
        if state then
            pcall(function()
                game.CoreGui:FindFirstChild("SentryTeleportGUI"):Destroy()
            end)

            local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
            ScreenGui.Name = "SentryTeleportGUI"
            ScreenGui.ResetOnSpawn = false

            local Button = Instance.new("TextButton", ScreenGui)
            Button.Size = UDim2.new(0, 100, 0, 30)
            Button.Position = UDim2.new(0, 10, 0, 10)
            Button.Text = "Tp Sentry"
            Button.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            Button.TextColor3 = Color3.new(0, 0, 0)
            Button.BorderSizePixel = 2

            local looping = false 
            
            local function teleportSentryLoop()
                local player = game.Players.LocalPlayer
                if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = player.Character.HumanoidRootPart

                local sentryParts = {}
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("BasePart") and obj.Name:match("^Sentry_") then
                        table.insert(sentryParts, obj)
                    end
                end

                -- Looping aktif
                looping = true
                Button.Text = "Tp Active"

                task.spawn(function()
                    while looping do
                        for _, part in pairs(sentryParts) do
                            local forward = hrp.CFrame.LookVector
                            local targetPos = hrp.Position + forward * 3
                            part.CFrame = CFrame.new(targetPos, hrp.Position + forward)
                            part.Anchored = true
                        end
                        task.wait(0.1)
                    end
                    Button.Text = "Tp Sentry"
                end)
            end

            
            Button.MouseButton1Click:Connect(function()
                if not looping then
                    teleportSentryLoop()
                else
                    looping = false 
                end
            end)

        else
            
            pcall(function()
                game.CoreGui:FindFirstChild("SentryTeleportGUI"):Destroy()
            end)
        end
    end
})









--SCRIPT LAIN


local DEBUG = false
local BATCH_SIZE = 250 -- jumlah object maksimal tiap frame
local SEARCH_TRAPS_IN_GAME = false

local function dprint(...)
	if DEBUG then print(...) end
end

local function processBillboardIfNeeded(obj)
	if not (obj:IsA("BasePart") and obj.Name == "Main") then return end
	if obj:GetAttribute("BillboardProcessed") then return end

	local parent = obj.Parent
	local ok = false
	while parent do
		if parent:IsA("Folder") and parent.Name == "Purchases" then
			ok = true
			break
		end
		parent = parent.Parent
	end
	if not ok then return end

	for _, child in ipairs(obj:GetChildren()) do
		if child:IsA("BillboardGui") then
			child.Size = UDim2.new(0, 180, 0, 150)
			child.MaxDistance = 90
			child.StudsOffset = Vector3.new(0, 5, 0)
			dprint("✅ BillboardGui diubah:", obj:GetFullName())
		end
	end

	obj:SetAttribute("BillboardProcessed", true)
end

-- 🔄 Queue system ultra ringan
local queue = {}
local heartbeat = game:GetService("RunService").Heartbeat
local processing = false

local function queueObject(obj)
	if not obj then return end
	queue[#queue + 1] = obj
end

-- ⚙️ Worker ringan dijalankan per frame
task.spawn(function()
	while true do
		if #queue > 0 then
			local processed = 0
			while processed < BATCH_SIZE and #queue > 0 do
				local obj = table.remove(queue, 1)
				if obj then
					task.defer(processBillboardIfNeeded, obj)
				end
				processed += 1
			end
		end
		-- Tunggu 1 frame penuh (super ringan, tanpa stutter)
		heartbeat:Wait()
	end
end)

-- ⏳ Muat semua objek awal ke queue
task.defer(function()
	for _, obj in ipairs(workspace:GetDescendants()) do
		queueObject(obj)
	end
end)

-- ⚡ Objek baru juga masuk queue
workspace.DescendantAdded:Connect(queueObject)
